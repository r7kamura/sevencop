# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::HashElementOrdered, :config do
  context 'with unrelated key' do
    it 'registers no offenses' do
      expect_no_offenses(<<~TEXT)
        { b => 1, c => 1, a => 1 }
      TEXT
    end
  end

  context 'with sorted Hash' do
    it 'registers no offenses' do
      expect_no_offenses(<<~TEXT)
        { a: 1, b: 1, c: 1 }
      TEXT
    end
  end

  context 'with empty Hash' do
    it 'registers no offenses' do
      expect_no_offenses(<<~TEXT)
        {}
      TEXT
    end
  end

  context 'with Symbol key' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        { b: 1, c: 1, a: 1 }
        ^^^^^^^^^^^^^^^^^^^^ Sort Hash elements by key.
      TEXT

      expect_correction(<<~RUBY)
        { a: 1, b: 1, c: 1 }
      RUBY
    end
  end

  context 'with String key' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        { 'b' => 1, 'c' => 1, 'a' => 1 }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sort Hash elements by key.
      TEXT

      expect_correction(<<~RUBY)
        { 'a' => 1, 'b' => 1, 'c' => 1 }
      RUBY
    end
  end

  context 'with keyword arguments' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        foo(b: 1, a: 1)
            ^^^^^^^^^^ Sort Hash elements by key.
      TEXT

      expect_correction(<<~RUBY)
        foo(a: 1, b: 1)
      RUBY
    end
  end

  context 'with multi-lines Hash' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        {
        ^ Sort Hash elements by key.
          b: 1,
          c: 1,
          a: 1
        }
      TEXT

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
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        {b: 1, c: 1, a: 1}
        ^^^^^^^^^^^^^^^^^^ Sort Hash elements by key.
      TEXT

      expect_correction(<<~RUBY)
        {a: 1, b: 1, c: 1}
      RUBY
    end
  end
end
