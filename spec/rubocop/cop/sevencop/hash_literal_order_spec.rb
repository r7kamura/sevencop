# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::HashLiteralOrder, :config do
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
        ^^^^^^^^^^^^^^^^^^^^ Sort Hash literal entries by key.
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
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sort Hash literal entries by key.
      TEXT

      expect_correction(<<~RUBY)
        { 'a' => 1, 'b' => 1, 'c' => 1 }
      RUBY
    end
  end

  context 'with multi-lines Hash' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        {
        ^ Sort Hash literal entries by key.
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
        ^^^^^^^^^^^^^^^^^^ Sort Hash literal entries by key.
      TEXT

      expect_correction(<<~RUBY)
        {a: 1, b: 1, c: 1}
      RUBY
    end
  end
end
