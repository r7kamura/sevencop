# frozen_string_literal: true

module RuboCop
  module Cop
    module RailsDeprecation
      class Base < ::RuboCop::Cop::Base
        DEFAULT_MAXIMUM_TARGET_RAILS_VERSION = ::Float::INFINITY

        DEFAULT_MINIMUM_TARGET_RAILS_VERSION = 5.0

        class << self
          attr_writer(
            :maximum_target_rails_version,
            :minimum_target_rails_version
          )

          # @return [Float]
          def maximum_target_rails_version
            @maximum_target_rails_version ||= DEFAULT_MAXIMUM_TARGET_RAILS_VERSION
          end

          # @return [Float]
          def minimum_target_rails_version
            @minimum_target_rails_version ||= DEFAULT_MINIMUM_TARGET_RAILS_VERSION
          end

          # @note Called from `RuboCop::Cop::Team#support_target_rails_version?`.
          # @param [Float] version
          # @return [Boolean]
          def support_target_rails_version?(version)
            (minimum_target_rails_version..maximum_target_rails_version).include?(version)
          end
        end
      end
    end
  end
end
