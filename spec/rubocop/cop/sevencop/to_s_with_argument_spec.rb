# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::ToSWithArgument, :config do
  context 'without argument' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        to_s
      RUBY
    end
  end

  context 'with argument' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        to_s(:delimited)
        ^^^^^^^^^^^^^^^^ Use `to_formatted_s(...)` instead of `to_s(...)`.
      RUBY

      expect_correction(<<~RUBY)
        to_formatted_s(:delimited)
      RUBY
    end
  end

  context 'argument and receiver' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        1.to_s(:delimited)
        ^^^^^^^^^^^^^^^^^^ Use `to_formatted_s(...)` instead of `to_s(...)`.
      RUBY

      expect_correction(<<~RUBY)
        1.to_formatted_s(:delimited)
      RUBY
    end
  end

  context 'with argument and safe navigation operator' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        1&.to_s(:delimited)
        ^^^^^^^^^^^^^^^^^^^ Use `to_formatted_s(...)` instead of `to_s(...)`.
      RUBY

      expect_correction(<<~RUBY)
        1&.to_formatted_s(:delimited)
      RUBY
    end
  end
end
