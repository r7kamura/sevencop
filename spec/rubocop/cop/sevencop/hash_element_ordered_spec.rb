# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::HashElementOrdered, :config do
  context 'with unrelated key' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        { b => 1, c => 1, a => 1 }
      RUBY
    end
  end

  context 'with sorted Hash' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        { a: 1, b: 1, c: 1 }
      RUBY
    end
  end

  context 'with empty Hash' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        {}
      RUBY
    end
  end

  context 'with Symbol key' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        { b: 1, c: 1, a: 1 }
        ^^^^^^^^^^^^^^^^^^^^ Sort Hash elements by key.
      RUBY

      expect_correction(<<~RUBY)
        { a: 1, b: 1, c: 1 }
      RUBY
    end
  end

  context 'with String key' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        { 'b' => 1, 'c' => 1, 'a' => 1 }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sort Hash elements by key.
      RUBY

      expect_correction(<<~RUBY)
        { 'a' => 1, 'b' => 1, 'c' => 1 }
      RUBY
    end
  end

  context 'with keyword arguments' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        foo(b: 1, a: 1)
            ^^^^^^^^^^ Sort Hash elements by key.
      RUBY

      expect_correction(<<~RUBY)
        foo(a: 1, b: 1)
      RUBY
    end
  end

  context 'with multi-lines Hash' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        {
        ^ Sort Hash elements by key.
          b: 1,
          c: 1,
          a: 1
        }
      RUBY

      expect_correction(<<~RUBY)
        {
          a: 1,
          b: 1,
          c: 1
        }
      RUBY
    end
  end

  context 'with surrounding-space-less Hash' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        {b: 1, c: 1, a: 1}
        ^^^^^^^^^^^^^^^^^^ Sort Hash elements by key.
      RUBY

      expect_correction(<<~RUBY)
        {a: 1, b: 1, c: 1}
      RUBY
    end
  end
end
