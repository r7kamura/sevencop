# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Checks if the map method is used in a chain.
      #
      # This cop is another version of `Performance/MapMethodChain` cop which has the autocorrection support.
      # They have decided not to add autocorrection, so we have this cop in case you want to use it.
      # https://github.com/rubocop/rubocop-performance/issues/436
      #
      # @example
      #   # bad
      #   array.map(&:foo).map(&:bar)
      #
      #   # good
      #   array.map { |element| element.foo.bar }
      class MapMethodChain < Base
        extend AutoCorrector

        include IgnoredNode

        RESTRICT_ON_SEND = %i[map collect].freeze

        # @!method block_pass_with_symbol_arg?(node)
        def_node_matcher :block_pass_with_symbol_arg?, <<~PATTERN
          (:block_pass (:sym $_))
        PATTERN

        def on_send(node)
          return if part_of_ignored_node?(node)
          return unless (map_arg = block_pass_with_symbol_arg?(node.first_argument))

          map_args = [map_arg]
          return unless (begin_of_chained_map_method = find_begin_of_chained_map_method(node, map_args))

          range = begin_of_chained_map_method.loc.selector.begin.join(node.source_range.end)
          replacement = "#{begin_of_chained_map_method.method_name} { |element| element.#{map_args.join('.')} }"
          add_offense(
            range,
            message: format(
              'Use `%<replacement>s` instead of `%<method_name>s` method chain.',
              method_name: begin_of_chained_map_method.method_name,
              replacement: replacement
            )
          ) do |corrector|
            corrector.replace(range, replacement)
          end

          ignore_node(node)
        end

        private

        def find_begin_of_chained_map_method(
          node,
          map_args
        )
          return unless (chained_map_method = node.receiver)
          return if !chained_map_method.call_type? || !RESTRICT_ON_SEND.include?(chained_map_method.method_name)
          return unless (map_arg = block_pass_with_symbol_arg?(chained_map_method.first_argument))

          map_args.unshift(map_arg)

          receiver = chained_map_method.receiver

          return chained_map_method unless receiver&.call_type? && block_pass_with_symbol_arg?(receiver.first_argument)

          find_begin_of_chained_map_method(chained_map_method, map_args)
        end
      end
    end
  end
end
