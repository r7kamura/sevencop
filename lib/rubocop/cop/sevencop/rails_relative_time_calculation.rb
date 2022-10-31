# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Prefer relative time helpers.
      #
      # @safety
      #   This cop is unsafe because method calls such as `n.days` cannot be precisely identified as derived from ActiveSupport.
      #
      # @example
      #   # bad
      #   Time.current - n.days
      #   Time.zone.now - n.days
      #
      #   # good
      #   n.days.ago
      #
      #   # bad
      #   Time.current + n.days
      #   Time.zone.now + n.days
      #
      #   # good
      #   n.days.since
      class RailsRelativeTimeCalculation < Base
        extend AutoCorrector

        DURATION_METHOD_NAMES = ::Set.new(
          %i[
            day
            days
            fortnight
            fortnights
            hour
            hours
            minute
            minutes
            month
            months
            second
            seconds
            week
            weeks
            year
            years
          ]
        )

        MSG = 'Prefer relative time helpers.'

        RESTRICT_ON_SEND = %i[
          -
          +
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          return unless relative_time_calculation?(node)

          add_offense(node) do |corrector|
            autocorrect(corrector, node)
          end
        end

        private

        # @!method duration?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :duration?, <<~PATTERN
          (send
            _
            DURATION_METHOD_NAMES
          )
        PATTERN

        # @!method relative_time_calculation?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :relative_time_calculation?, <<~PATTERN
          (send
            {#time_current? | #time_zone_now?}
            _
            #duration?
          )
        PATTERN

        # @!method time_current?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :time_current?, <<~PATTERN
          (send
            (const
              {nil? | cbase}
              :Time
            )
            :current
          )
        PATTERN

        # @!method time_zone_now?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :time_zone_now?, <<~PATTERN
          (send
            (send
              (const
                {nil? | cbase}
                :Time
              )
              :zone
            )
            :now
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect(
          corrector,
          node
        )
          corrector.replace(
            node,
            format(
              '%<duration>s.%<helper_method_name>s',
              duration: node.first_argument.source,
              helper_method_name: helper_method_name_from(node)
            )
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Symbol]
        def helper_method_name_from(node)
          case node.method_name
          when :-
            :ago
          when :+
            :since
          end
        end
      end
    end
  end
end
