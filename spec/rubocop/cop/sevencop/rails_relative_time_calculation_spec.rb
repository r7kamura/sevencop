# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsRelativeTimeCalculation, :config do
  context 'with relative time helper' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with time calculation with `Time.current - n.days`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current - n.days
        ^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with time calculation with `Time.current + n.days`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current + n.days
        ^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        n.days.since
      RUBY
    end
  end

  context 'with time calculation with `::Time.current`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        ::Time.current - n.days
        ^^^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with time calculation with `Time.zone.now`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.zone.now - n.days
        ^^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        n.days.ago
      RUBY
    end
  end

  context 'with time calculation with `time > Time.current`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        time > Time.current
        ^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.future?
      RUBY
    end
  end

  context 'with time calculation with `time.after?(Time.curernt)`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        time.after?(Time.current)
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.future?
      RUBY
    end
  end

  context 'with time calculation with `Time.current < time`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current < time
        ^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.future?
      RUBY
    end
  end

  context 'with time calculation with `Time.current.before?(time)`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current.before?(time)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.future?
      RUBY
    end
  end

  context 'with time calculation with `time < Time.current`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        time < Time.current
        ^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.past?
      RUBY
    end
  end

  context 'with time calculation with `time.before?(Time.current)`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        time.before?(Time.current)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.past?
      RUBY
    end
  end

  context 'with time calculation with `Time.current > time`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current > time
        ^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.past?
      RUBY
    end
  end

  context 'with time calculation with `Time.current.after?(time)`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.current.after?(time)
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        time.past?
      RUBY
    end
  end
end
