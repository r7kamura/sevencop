# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::BundlerGemGroupOrdered, :config do
  context 'when `group` is sorted' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        group :development do
          gem 'd'
        end

        group :test do
          gem 't'
        end
      RUBY
    end
  end

  context 'when `group` sort key cannot be computed' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        group :development do
          gem 'd'
        end

        group group_name do
          gem 'x'
        end
      RUBY
    end
  end

  context 'when `group` is not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        group :test do
          gem 't'
        end

        group :development do
        ^^^^^^^^^^^^^^^^^^^^^ Sort `group` in alphabetical order.
          gem 'd'
        end
      RUBY

      expect_correction(<<~RUBY)
        group :development do
          gem 'd'
        end

        group :test do
          gem 't'
        end
      RUBY
    end
  end

  context 'when `group` with sorted multi arguments is not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        group :development, :test do
          gem 'dt'
        end

        group :development do
        ^^^^^^^^^^^^^^^^^^^^^ Sort `group` in alphabetical order.
          gem 'd'
        end
      RUBY

      expect_correction(<<~RUBY)
        group :development do
          gem 'd'
        end

        group :development, :test do
          gem 'dt'
        end
      RUBY
    end
  end

  context 'when `group` with unsorted multi arguments is not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        group :test do
          gem 't'
        end

        group :test, :development do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sort `group` in alphabetical order.
          gem 'dt'
        end
      RUBY

      expect_correction(<<~RUBY)
        group :test, :development do
          gem 'dt'
        end

        group :test do
          gem 't'
        end
      RUBY
    end
  end

  context 'when commented `group` is not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        # test
        group :test do
          gem 't'
        end

        # development
        group :development do
        ^^^^^^^^^^^^^^^^^^^^^ Sort `group` in alphabetical order.
          gem 'd'
        end
      RUBY

      expect_correction(<<~RUBY)
        # development
        group :development do
          gem 'd'
        end

        # test
        group :test do
          gem 't'
        end
      RUBY
    end
  end
end
