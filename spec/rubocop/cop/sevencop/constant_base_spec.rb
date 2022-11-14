# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::ConstantBase, :config do
  context 'with prefixed constant in class' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        class Foo
          ::Bar
        end
      RUBY
    end
  end

  context 'with prefixed constant in module' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        module Foo
          ::Bar
        end
      RUBY
    end
  end

  context 'with prefixed constant in neither class nor module' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        ::Bar
        ^^ Remove unnecessary `::` prefix from constant.
      RUBY

      expect_correction(<<~RUBY)
        Bar
      RUBY
    end
  end

  context 'with prefixed nested constant in neither class nor module' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        ::Bar::Baz
        ^^ Remove unnecessary `::` prefix from constant.
      RUBY

      expect_correction(<<~RUBY)
        Bar::Baz
      RUBY
    end
  end

  context 'with prefixed constant in sclass' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        class << self
          ::Bar
          ^^ Remove unnecessary `::` prefix from constant.
        end
      RUBY

      expect_correction(<<~RUBY)
        class << self
          Bar
        end
      RUBY
    end
  end
end