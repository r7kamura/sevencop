# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::BundlerGemGroupNameOrdered, :config do
  context 'when `group` names are sorted' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        group :development, :test do
          gem 'rspec-rails'
        end
      RUBY
    end
  end

  context 'when `group` names are not sorted' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        group :test, :development do
                     ^^^^^^^^^^^^ Sort `group` names in alphabetical order.
          gem 'rspec-rails'
        end
      RUBY

      expect_correction(<<~RUBY)
        group :development, :test do
          gem 'rspec-rails'
        end
      RUBY
    end
  end
end
