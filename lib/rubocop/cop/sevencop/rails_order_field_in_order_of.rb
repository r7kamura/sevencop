# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Prefer `in_order_of` to MySQL `FIELD` function.
      #
      # @example
      #   # bad
      #   order('FIELD(id, 1, 2, 3)')
      #
      #   # good
      #   in_order_of(:id, [1, 2, 3])
      #
      #   # bad
      #   order(Arel.sql('FIELD(id, 1, 2, 3)'))
      #
      #   # good
      #   in_order_of(:id, [1, 2, 3])
      #
      #   # bad
      #   order('FIELD(id, 1, 2, 3) DESC')
      #
      #   # good
      #   in_order_of(:id, [1, 2, 3]).reverse_order
      #
      #   # bad
      #   order("FIELD(id, #{ids.join(', ')})")
      #
      #   # good
      #   in_order_of(:id, ids)
      class RailsOrderFieldInOrderOf < Base
        extend AutoCorrector

        REGEXP_FIELD_DSTR_HEAD = /
          \A
          \s*
          field\(
            \s*
            (?<column_name>[^,]+)
            ,\s*
          \z
        /ix.freeze

        REGEXP_FIELD_DSTR_TAIL = /
          \A
          \s*
          \)
          \s*
          (?:
            \s+
            (?<order>asc|desc)
          )?
          \z
        /ix.freeze

        REGEXP_FIELD_STR = /
          \A
          \s*
          field\(
            \s*
            (?<column_name>[^,]+)
            ,\s*
            (?<values>.+)
            \s*
          \)
          (?:
            \s+
            (?<order>asc|desc)
          )?
          \s*
          \z
        /ix.freeze

        MSG = 'Prefer `in_order_of` to MySQL `FIELD` function.'

        RESTRICT_ON_SEND = %i[
          order
          reorder
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          return unless bad?(node)

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @!method match_arel_sql_field?(node)
        #   @param node [RuboCop::AST::Node, nil]
        #   @return [Boolean]
        def_node_matcher :match_arel_sql_field?, <<~PATTERN
          (send
            (const {nil? cbase} :Arel)
            :sql
            #match_field?
          )
        PATTERN

        # @!method match_field?(node)
        #   @param node [RuboCop::AST::Node, nil]
        #   @return [Boolean]
        def_node_matcher :match_field?, <<~PATTERN
          {
            #match_field_dstr?
            #match_field_str?
          }
        PATTERN

        # @!method match_field_dstr_body?(node)
        #   @param node [RuboCop::AST::Node, nil]
        #   @return [Boolean]
        def_node_matcher :match_field_dstr_body?, <<~PATTERN
          (begin
            (send
              _
              :join
              (str #match_field_dstr_body_separator?)
            )
          )
        PATTERN

        # @!method match_order_with_field?(node)
        #   @param node [RuboCop::AST::Node, nil]
        #   @return [Boolean]
        def_node_matcher :match_order_with_field?, <<~PATTERN
          (send
            _
            _
            {
              #match_arel_sql_field?
              #match_field?
            }
            ...
          )
        PATTERN
        alias bad? match_order_with_field?

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        def autocorrect(
          corrector,
          node
        )
          corrector.replace(
            node.location.expression.with(
              begin_pos: node.location.selector.begin_pos
            ),
            format_in_order_of(node)
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String, nil]
        def extract_column_name(node)
          if node.each_descendant(:dstr).any?
            extract_column_name_from_dstr(node)
          else
            extract_column_name_from_str(node)
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def extract_column_name_from_dstr(node)
          node.each_descendant(:str).first.value[REGEXP_FIELD_DSTR_HEAD, :column_name]
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def extract_column_name_from_str(node)
          node.each_descendant(:str).first.value[REGEXP_FIELD_STR, :column_name]
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String, nil]
        def extract_order_from_dstr(node)
          node.each_descendant(:str).to_a.last.value[REGEXP_FIELD_DSTR_TAIL, :order]
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String, nil]
        def extract_order_from_str(node)
          node.each_descendant(:str).first.value[REGEXP_FIELD_STR, :order]
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String, nil]
        def extract_rest_order(node)
          rest_order_arguments = node.arguments[1..]
          return if rest_order_arguments.empty?

          format(
            '.order(%<rest_order_arguments>s)',
            rest_order_arguments: rest_order_arguments.map(&:source).join(', ')
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String, nil]
        def extract_reverse_order_from_dstr(node)
          '.reverse_order' if match_desc_on_dstr?(node)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String, nil]
        def extract_reverse_order_from_str(node)
          '.reverse_order' if match_desc_on_str?(node)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def extract_values_from_dstr(node)
          node.each_descendant.find do |descendant|
            match_field_dstr_body?(descendant)
          end.children.first.receiver.source
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def extract_values_from_str(node)
          format(
            '[%<values>s]',
            values: node.each_descendant(:str).first.value[REGEXP_FIELD_STR, :values].split(',').map(&:strip).join(', ')
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def format_in_order_of(node)
          if node.each_descendant(:dstr).any?
            format_in_order_of_on_dstr(node)
          else
            format_in_order_of_on_str(node)
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def format_in_order_of_on_dstr(node)
          format(
            "in_order_of(:'%<column_name>s', %<values>s)%<reverse_order>s%<rest_order>s",
            column_name: extract_column_name_from_dstr(node),
            rest_order: extract_rest_order(node),
            reverse_order: extract_reverse_order_from_dstr(node),
            values: extract_values_from_dstr(node)
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [String]
        def format_in_order_of_on_str(node)
          format(
            "in_order_of(:'%<column_name>s', %<values>s)%<reverse_order>s%<rest_order>s",
            column_name: extract_column_name_from_str(node),
            rest_order: extract_rest_order(node),
            reverse_order: extract_reverse_order_from_str(node),
            values: extract_values_from_str(node)
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def match_desc_on_dstr?(node)
          extract_order_from_dstr(node).to_s.casecmp('desc').zero?
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Boolean]
        def match_desc_on_str?(node)
          extract_order_from_str(node).to_s.casecmp('desc').zero?
        end

        # @param node [RuboCop::AST::Node]
        # @return [Boolean]
        def match_field_dstr?(node)
          node.dstr_type? &&
            node.children.size == 3 &&
            match_field_dstr_head?(node.children[0]) &&
            match_field_dstr_body?(node.children[1]) &&
            match_field_dstr_tail?(node.children[2])
        end

        # @param separator [String]
        # @return [Boolean]
        def match_field_dstr_body_separator?(separator)
          separator.strip == ','
        end

        # @param node [RuboCop::AST::Node]
        # @return [Boolean]
        def match_field_dstr_head?(node)
          node&.str_type? &&
            node.value.match?(REGEXP_FIELD_DSTR_HEAD)
        end

        def match_field_dstr_tail?(node)
          node&.str_type? &&
            node.value.match?(REGEXP_FIELD_DSTR_TAIL)
        end

        # @param node [RuboCop::AST::Node]
        # @return [Boolean]
        def match_field_str?(node)
          node.str_type? &&
            node.value.match?(REGEXP_FIELD_STR)
        end
      end
    end
  end
end
