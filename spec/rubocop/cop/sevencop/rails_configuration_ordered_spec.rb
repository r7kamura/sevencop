# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsConfigurationOrdered, :config do
  context 'when there is only one configuration item' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a1.a2 = true
          end
        end
      RUBY
    end
  end

  context 'when configuration items are sorted' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a1.a2 = true
            config.b1.b2 = true
          end
        end
      RUBY
    end
  end

  context 'when configuration items are not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.b1.b2 = true
            config.a1.a2 = true
            ^^^^^^^^^^^^^^^^^^^ Sort configuration items in alphabetical order.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a1.a2 = true
            config.b1.b2 = true
          end
        end
      RUBY
    end
  end

  context 'when there is an unrelated item' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            "foo".bar

            config.a1.a2 = true
          end
        end
      RUBY
    end
  end

  context 'when there is an ignored configuration item' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.load_defaults 7.1

            config.a1.a2 = true
          end
        end
      RUBY
    end
  end

  context 'when there is an configuration item in block' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.b1.b2 do
              config.a1.a2 = true
            end
          end
        end
      RUBY
    end
  end
end
