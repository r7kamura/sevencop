# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsRelativeTimeCalculation, :config do
  context 'with relative time helper' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with relative time calculation with Time.current and -' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current - n.days
        ^^^^^^^^^^^^^^^^^^^^^ Prefer relative time helpers.
      RUBY

      expect_correction(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with relative time calculation with +' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current + n.days
        ^^^^^^^^^^^^^^^^^^^^^ Prefer relative time helpers.
      RUBY

      expect_correction(<<~RUBY)
        n.days.since
      RUBY
    end
  end

  context 'with relative time calculation with ::Time.current' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        ::Time.current - n.days
        ^^^^^^^^^^^^^^^^^^^^^^^ Prefer relative time helpers.
      RUBY

      expect_correction(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with relative time calculation with Time.zone.now' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.zone.now - n.days
        ^^^^^^^^^^^^^^^^^^^^^^ Prefer relative time helpers.
      RUBY

      expect_correction(<<~RUBY)
        n.days.ago
      RUBY
    end
  end
end
