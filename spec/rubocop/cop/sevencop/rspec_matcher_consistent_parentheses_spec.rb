# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecMatcherConsistentParentheses, :config do
  context 'with consistent parentheses' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        is_expected.to eq(1)
      RUBY
    end
  end

  context 'with block matcher' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        is_expected.to change { subject }.by(1)
      RUBY
    end
  end

  context 'with operator' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        is_expected.to be > 1
      RUBY
    end
  end

  context 'with inconsistent parentheses' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        is_expected.to eq 1
                       ^^^^ Keep consistent parentheses style in RSpec matchers.
      RUBY

      expect_correction(<<~RUBY)
        is_expected.to eq(1)
      RUBY
    end
  end
end
