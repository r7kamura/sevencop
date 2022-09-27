# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::MethodDefinitionKeywordArgumentOrdered, :config do
  context 'when keyword arguments are sorted' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        def foo(a, d:, e:, b: 2, c: 1); end
      RUBY
    end
  end

  context 'when default-value-less keyword arguments are not sorted' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        def foo(b:, a:)
                    ^^ Sort method definition keyword arguments in alphabetical order.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo(a:, b:)
        end
      RUBY
    end
  end

  context 'when default-value-full keyword arguments are not sorted' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        def foo(b: 1, a: 2)
                      ^^^^ Sort method definition keyword arguments in alphabetical order.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo(a: 2, b: 1)
        end
      RUBY
    end
  end
end
