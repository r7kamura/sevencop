# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Prefer ActiveSupport time helper.
      #
      # @safety
      #   This cop is unsafe.
      #   This cop considers `n.days` is a Duration, and `date` in `date == Date.current` is a Date, but there is no guarantee.
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
      #   Date.current.tomorrow
      #
      #   # good
      #   Date.tomorrow
      #
      #   # bad
      #   Date.current.yesterday
      #
      #   # good
      #   Date.yesterday
      #
      #   # bad
      #   date == Date.current
      #   Date.current == date
      #
      #   # good
      #   date.today?
      #
      #   # bad
      #   date == Date.tomorrow
      #   Date.tomorrow == date
      #
      #   # good
      #   date.tomorrow?
      #
      #   # bad
      #   date == Date.yesterday
      #   Date.yesterday == date
      #
      #   # good
      #   date.yesterday?
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
          :==,
          :now,
          :today,
          :tomorrow,
          :yesterday
        ].freeze

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def on_send(node)
          case node.method_name
          when :-
            check_subtraction(node)
          when :+
            check_addition(node)
          when :==
            check_equality(node)
          when :<, :before?
            check_less_than(node)
          when :>, :after?
            check_greater_than(node)
          when :now
            check_now(node)
          when :today
            check_today(node)
          when :tomorrow
            check_tomorrow(node)
          when :yesterday
            check_yesterday(node)
          end
        end

        private

        # @!method comparison_to_time_current?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_to_time_current?, <<~PATTERN
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
            #comparison_for_future_with_time_current_left? |
              #comparison_for_future_with_time_current_right?
          }
        PATTERN

        # @!method comparison_for_future_with_time_current_left?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_future_with_time_current_left?, <<~PATTERN
          (send
            #time_current?
            {:< | :before?}
            _
          )
        PATTERN

        # @!method comparison_for_future_with_time_current_right?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_future_with_time_current_right?, <<~PATTERN
          (send
            _
            {:> | :after?}
            #time_current?
          )
        PATTERN

        # @!method comparison_for_past?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_past?, <<~PATTERN
          {
            #comparison_for_past_with_time_current_left? |
              #comparison_for_past_with_time_current_right?
          }
        PATTERN

        # @!method comparison_for_past_with_time_current_left?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_past_with_time_current_left?, <<~PATTERN
          (send
            #time_current?
            {:> | :after?}
            _
          )
        PATTERN

        # @!method comparison_for_past_with_time_current_right?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :comparison_for_past_with_time_current_right?, <<~PATTERN
          (send
            _
            {:< | :before?}
            #time_current?
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

        # @!method date_with?(node, method_name)
        #   @param node [RuboCop::AST::Node]
        #   @param method_name [Symbol]
        #   @return [Boolean]
        def_node_matcher :date_with?, <<~PATTERN
          (send
            (const
              {nil? | cbase}
              :Date
            )
            %1
          )
        PATTERN

        # @!method date_current_with?(node, method_name)
        #   @param node [RuboCop::AST::Node]
        #   @param method_name [Symbol]
        #   @return [Boolean]
        def_node_matcher :date_current_with?, <<~PATTERN
          (send
            (send
              (const
                {nil? | cbase}
                :Date
              )
              :current
            )
            %1
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

        # @!method duration_calculation_to_time_current?(node)
        #   @param node [RuboCop::AST::Node]
        #   @return [Boolean]
        def_node_matcher :duration_calculation_to_time_current?, <<~PATTERN
          (send
            #time_current?
            _
            #duration?
          )
        PATTERN

        # @!method equals_to_date_with_left?(node, method_name)
        #   @param node [RuboCop::AST::Node]
        #   @param method_name [Symbol]
        #   @return [Boolean]
        def_node_matcher :equals_to_date_with_left?, <<~PATTERN
          (send
            #date_with?(%1)
            :==
            _
          )
        PATTERN

        # @!method equals_to_date_with_right?(node, method_name)
        #   @param node [RuboCop::AST::Node]
        #   @param method_name [Symbol]
        #   @return [Boolean]
        def_node_matcher :equals_to_date_with_right?, <<~PATTERN
          (send
            _
            :==
            #date_with?(%1)
          )
        PATTERN

        # @!method time_zone_with?(node, method_name)
        #   @param node [RuboCop::AST::Node]
        #   @param method_name [Symbol]
        #   @return [Boolean]
        def_node_matcher :time_zone_with?, <<~PATTERN
          (send
            (send
              (const
                {nil? | cbase}
                :Time
              )
              :zone
            )
            %1
          )
        PATTERN

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_comparison_helper_for_time_current(
          corrector,
          node
        )
          corrector.replace(
            node,
            format(
              '%<time>s.%<helper_method_name>s',
              helper_method_name: helper_method_name_for_comparison(node),
              time: find_comparison_subject_to_time_current(node).source
            )
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
        # @param date_method_name [Symbol]
        # @param helper_method_name [Symbol]
        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def autocorrect_to_equality_helper_for_date(
          corrector,
          node,
          date_method_name:,
          helper_method_name:
        )
          corrector.replace(
            node,
            format(
              '%<date>s.%<helper_method_name>s',
              date: find_equality_subject_to_date_with(node, date_method_name).source,
              helper_method_name: helper_method_name
            )
          )
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_addition(node)
          return unless duration_calculation_to_time_current?(node)

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
        def check_equality(node)
          check_equality_to_date_current(node)
          check_equality_to_date_tomorrow(node)
          check_equality_to_date_yesterday(node)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_equality_to_date_current(node)
          return unless equals_to_date_with?(node, :current)

          add_offense(node) do |corrector|
            autocorrect_to_equality_helper_for_date(
              corrector,
              node,
              date_method_name: :current,
              helper_method_name: :today?
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_equality_to_date_tomorrow(node)
          return unless equals_to_date_with?(node, :tomorrow)

          add_offense(node) do |corrector|
            autocorrect_to_equality_helper_for_date(
              corrector,
              node,
              date_method_name: :tomorrow,
              helper_method_name: :tomorrow?
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_equality_to_date_yesterday(node)
          return unless equals_to_date_with?(node, :yesterday)

          add_offense(node) do |corrector|
            autocorrect_to_equality_helper_for_date(
              corrector,
              node,
              date_method_name: :yesterday,
              helper_method_name: :yesterday?
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_greater_than(node)
          return unless comparison_to_time_current?(node)

          add_offense(node) do |corrector|
            autocorrect_to_comparison_helper_for_time_current(
              corrector,
              node
            )
          end
        end
        alias check_less_than check_greater_than

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_now(node)
          return unless time_zone_with?(node, :now)

          add_offense(node) do |corrector|
            replace_keeping_cbase(
              corrector: corrector,
              node: node,
              with: 'Time.current'
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_subtraction(node)
          return unless duration_calculation_to_time_current?(node)

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
          check_today_to_date_current(node)
          check_today_to_time_zone(node)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_today_to_date_current(node)
          return unless date_current_with?(node, :today)

          add_offense(node) do |corrector|
            replace_keeping_cbase(
              corrector: corrector,
              node: node,
              with: 'Date.current'
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_today_to_time_zone(node)
          return unless time_zone_with?(node, :today)

          add_offense(node) do |corrector|
            replace_keeping_cbase(
              corrector: corrector,
              node: node,
              with: 'Date.current'
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_tomorrow(node)
          return unless date_current_with?(node, :tomorrow)

          add_offense(node) do |corrector|
            replace_keeping_cbase(
              corrector: corrector,
              node: node,
              with: 'Date.tomorrow'
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [void]
        def check_yesterday(node)
          return unless date_current_with?(node, :yesterday)

          add_offense(node) do |corrector|
            replace_keeping_cbase(
              corrector: corrector,
              node: node,
              with: 'Date.yesterday'
            )
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @param method_name [Symbol]
        # @return [Boolean]
        def equals_to_date_with?(
          node,
          method_name
        )
          equals_to_date_with_left?(node, method_name) ||
            equals_to_date_with_right?(node, method_name)
        end

        # @param node [RuboCop::AST::SendNode]
        # @return [RuboCop::AST::Node]
        def find_comparison_subject_to_time_current(node)
          if time_current?(node.receiver)
            node.first_argument
          else
            node.receiver
          end
        end

        # @param node [RuboCop::AST::SendNode]
        # @param method_name [Symbol]
        # @return [RuboCop::AST::Node]
        def find_equality_subject_to_date_with(
          node,
          method_name
        )
          if date_with?(node.receiver, method_name)
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

        # @param corrector [RuboCop::Cop::Corrector]
        # @param node [RuboCop::AST::SendNode]
        # @param with [String]
        # @return [void]
        def replace_keeping_cbase(
          corrector:,
          node:,
          with:
        )
          corrector.replace(
            node.location.expression.with(
              begin_pos: node.each_descendant(:const).first.location.name.begin_pos
            ),
            with
          )
        end
      end
    end
  end
end
