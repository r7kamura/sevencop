# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::MapMethodChain, :config do
  context 'with 2 map method chain' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        array.map(&:foo).map(&:bar)
              ^^^^^^^^^^^^^^^^^^^^^ Use `map { |element| element.foo.bar }` instead of `map` method chain.
      RUBY

      expect_correction(<<~RUBY)
        array.map { |element| element.foo.bar }
      RUBY
    end
  end

  context 'with 3 map method chain' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        array&.map(&:foo).map(&:bar).map(&:baz)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `map { |element| element.foo.bar.baz }` instead of `map` method chain.
      RUBY

      expect_correction(<<~RUBY)
        array&.map { |element| element.foo.bar.baz }
      RUBY
    end
  end
end
