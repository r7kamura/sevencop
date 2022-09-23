# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::AutoloadOrdered, :config do
  context 'when `autoload` is sorted' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        autoload :A, 'a'
        autoload :B, 'b'
      RUBY
    end
  end

  context 'when `autoload` is not sorted in different sections' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        autoload :B, 'b'
        autoload :D, 'd'

        autoload :A, 'a'
        autoload :C, 'c'
      RUBY
    end
  end

  context 'when `autoload` is not sorted' do
    it 'registers an offense' do
      expect_offense(<<~TEXT)
        autoload :B, 'b'
        autoload :A, 'a'
        ^^^^^^^^^^^^^^^^ Sort `autoload` in alphabetical order within their section.
      TEXT

      expect_correction(<<~RUBY)
        autoload :A, 'a'
        autoload :B, 'b'
      RUBY
    end
  end
end
