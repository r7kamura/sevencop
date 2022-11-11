# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::MethodDefinitionArgumentsMultiline, :config do
  context 'when there is one argument' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        def foo(a)
        end
      RUBY
    end
  end

  context 'when there are multilined multiple arguments' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        def foo(
          a,
          b
        )
        end
      RUBY
    end
  end

  context 'when there are non-multilined multiple block arguments' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        foo do |a, b|
        end
      RUBY
    end
  end

  context 'when there are non-multilined multiple arguments' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        def foo(a, b)
               ^^^^^^ Insert new lines between method definition arguments.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo(
          a,
          b
        )
        end
      RUBY
    end
  end

  context 'when there are non-multilined parentheses-less multiple arguments' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        def foo a, b
                ^^^^ Insert new lines between method definition arguments.
        end
      RUBY

      expect_correction(<<~RUBY)
        def foo(
          a,
          b
        )
        end
      RUBY
    end
  end
end
