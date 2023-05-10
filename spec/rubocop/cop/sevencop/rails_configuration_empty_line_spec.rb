# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsConfigurationEmptyLine, :config do
  context 'when there is only one configuration item' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true
          end
        end
      RUBY
    end
  end

  context 'when there is an empty line between configuration items' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true

            config.b = true
          end
        end
      RUBY
    end
  end

  context 'when there is no empty line between configuration items' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true
            config.b = true
            ^^^^^^^^^^^^^^^ Put an empty line between configuration items.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true

            config.b = true
          end
        end
      RUBY
    end
  end

  context 'when there is no empty line between chained configuration items' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a1.a2 = true
            config.b1.b2 = true
            ^^^^^^^^^^^^^^^^^^^ Put an empty line between configuration items.
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

  context 'when there is no empty line between some of configuration items' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true

            config.b = true
            config.c = true
            ^^^^^^^^^^^^^^^ Put an empty line between configuration items.

            config.d = true
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true

            config.b = true

            config.c = true

            config.d = true
          end
        end
      RUBY
    end
  end

  context 'when there is no empty line between configuration items with modifier' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true
            config.b = true if condition
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Put an empty line between configuration items.

            config.c = true if condition
            config.d = true
            ^^^^^^^^^^^^^^^ Put an empty line between configuration items.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        module Example
          class Application < Rails::Application
            config.a = true

            config.b = true if condition

            config.c = true if condition

            config.d = true
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
            config.a do
              config.b = true
            end
          end
        end
      RUBY
    end
  end
end
