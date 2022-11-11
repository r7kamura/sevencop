# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::MethodDefinitionInIncluded, :config do
  context 'when method is defined not in included' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module A
          def foo
          end
        end
      RUBY
    end
  end

  context 'when method is defined at top-level' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        def foo
        end
      RUBY
    end
  end

  context 'when method is defined in included' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module A
          extend ::ActiveSupport::Concern

          included do
            # @return [void]
            def foo
            ^^^^^^^ Do not define methods in `included` blocks.
            end
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        module A
          extend ::ActiveSupport::Concern

            # @return [void]
            public def foo
            end

          included do
          end
        end
      RUBY
    end
  end

  context 'when definition in included is private' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module A
          extend ::ActiveSupport::Concern

          included do
            private

            # @return [void]
            def foo
            ^^^^^^^ Do not define methods in `included` blocks.
            end
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        module A
          extend ::ActiveSupport::Concern

            # @return [void]
            private def foo
            end

          included do
            private

          end
        end
      RUBY
    end
  end
end
