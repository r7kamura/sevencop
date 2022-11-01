# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Prefer ActiveSupport time helper.
      #
      # @safety
      #   This cop is unsafe because method calls such as `n.days` cannot be precisely identified as derived from ActiveSupport.
      #
      # @example
      #   # bad
      #   Time.zone.now
      #
      #   # good
      #   Time.current
      #
      #   # bad
      #   Time.zone.today
      #
      #   # good
      #   Date.current
      #
      #   # bad
      #   Time.current - n.days
      #   Time.zone.now - n.days
      #
      #   # good
      #   n.days.ago
      #
      #   # bad
      #   Time.current + n.days
      #
      #   # good
      #   n.days.since
      #
      #   # bad
      #   time.after?(Time.current)
      #   time > Time.current
      #   Time.current < time
      #   Time.current.before?(time)
      #
      #   # good
      #   time.future?
      #
      #   # bad
      #   time.before?(Time.current)
      #   time < Time.current
      #   Time.current > time
      #   Time.current.after?(time)
      #
      #   # good
      #   time.past?
      class RailsRelativeTimeCalculation < Base
        extend AutoCorrector

        CALCULATION_METHOD_NAMES = ::Set.new(
          %i[
            -
            +
          ]
        ).freeze

        COMPARISON_METHOD_NAMES = ::Set.new(
          %i[
            <
            >
            after?
            before?
          ]
        ).freeze

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
        ).freeze

        MSG = 'Prefer ActiveSupport time helper.'

        RESTRICT_ON_SEND = [
          *CALCULATION_METHOD_NAMES,
          *COMPARISON_METHOD_NAMES,
          :now,
          :today
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          case node.method_name
          when :-
            check_subtraction(node)
          when :+
            check_addition(node)
          when :<, :before?
            check_less_than(node)
          when :>, :after?
            check_greater_than(node)
          when :now
            check_now(node)
          when :today
            check_today(node)
          end
        end

        private

        # @!method comparison_to_current?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_to_current?, <<~PATTERN
          {
            #comparison_for_future? |
              #comparison_for_past?
          }
        PATTERN

        # @!method comparison_for_future?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_future?, <<~PATTERN
          {
            #comparison_for_future_with_current_left? |
              #comparison_for_future_with_current_right?
          }
        PATTERN

        # @!method comparison_for_future_with_current_left?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_future_with_current_left?, <<~PATTERN
          (send
            #current?
            {:< | :before?}
            _
          )
        PATTERN

        # @!method comparison_for_future_with_current_right?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_future_with_current_right?, <<~PATTERN
          (send
            _
            {:> | :after?}
            #current?
          )
        PATTERN

        # @!method comparison_for_past?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_past?, <<~PATTERN
          {
            #comparison_for_past_with_current_left? |
              #comparison_for_past_with_current_right?
          }
        PATTERN

        # @!method comparison_for_past_with_current_left?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_past_with_current_left?, <<~PATTERN
          (send
            #current?
            {:> | :after?}
            _
          )
        PATTERN

        # @!method comparison_for_past_with_current_right?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_past_with_current_right?, <<~PATTERN
          (send
            _
            {:< | :before?}
            #current?
          )
        PATTERN

        # @!method current?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :current?, <<~PATTERN
          (send
            (const
              {nil? | cbase}
              :Time
            )
            :current
          )
        PATTERN

        # @!method duration?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :duration?, <<~PATTERN
          (send
            _
            DURATION_METHOD_NAMES
          )
        PATTERN

        # @!method duration_calculation_to_current?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :duration_calculation_to_current?, <<~PATTERN
          (send
            #current?
            _
            #duration?
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

        # @!method time_zone_today?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :time_zone_today?, <<~PATTERN
          (send
            (send
              (const
                {nil? | cbase}
                :Time
              )
              :zone
            )
            :today
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_comparison_helper(
          corrector,
          node
        )
          corrector.replace(
            node,
            format(
              '%<time>s.%<helper_method_name>s',
              helper_method_name: helper_method_name_for_comparison(node),
              time: find_comparison_subject(node).source
            )
          )
        end

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_date_current(
          corrector,
          node
        )
          corrector.replace(
            node.location.expression.with(
              begin_pos: node.receiver.receiver.location.name.begin_pos # To keep `::`.
            ),
            'Date.current'
          )
        end

        # @param corrector [RuboCop::Cop::Corrector]
        # @param helper_method_name [Symbol]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_duration_helper(
          corrector,
          node,
          helper_method_name:
        )
          corrector.replace(
            node,
            format(
              '%<duration>s.%<helper_method_name>s',
              duration: node.first_argument.source,
              helper_method_name: helper_method_name
            )
          )
        end

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_time_current(
          corrector,
          node
        )
          corrector.replace(
            node.location.expression.with(
              begin_pos: node.receiver.receiver.location.name.begin_pos # To keep `::`.
            ),
            'Time.current'
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_addition(node)
          return unless duration_calculation_to_current?(node)

          add_offense(node) do |corrector|
            autocorrect_to_duration_helper(
              corrector,
              node,
              helper_method_name: :since
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_greater_than(node)
          return unless comparison_to_current?(node)

          add_offense(node) do |corrector|
            autocorrect_to_comparison_helper(
              corrector,
              node
            )
          end
        end
        alias check_less_than check_greater_than

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_now(node)
          return unless time_zone_now?(node)

          add_offense(node) do |corrector|
            autocorrect_to_time_current(
              corrector,
              node
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_subtraction(node)
          return unless duration_calculation_to_current?(node)

          add_offense(node) do |corrector|
            autocorrect_to_duration_helper(
              corrector,
              node,
              helper_method_name: :ago
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_today(node)
          return unless time_zone_today?(node)

          add_offense(node) do |corrector|
            autocorrect_to_date_current(
              corrector,
              node
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [RuboCop::AST::Node]
        def find_comparison_subject(node)
          if current?(node.receiver)
            node.first_argument
          else
            node.receiver
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [Symbol]
        def helper_method_name_for_comparison(node)
          if comparison_for_future?(node)
            :future?
          else
            :past?
          end
        end
      end
    end
  end
end
