# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsRelativeTimeCalculation, :config do
  context 'with `Time.zone.now`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.zone.now
        ^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        Time.current
      RUBY
    end
  end

  context 'with `::Time.zone.now`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        ::Time.zone.now
        ^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        ::Time.current
      RUBY
    end
  end

  context 'with `Time.zone.today`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        Time.zone.today
        ^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        Date.current
      RUBY
    end
  end

  context 'with `::Time.zone.today`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        ::Time.zone.today
        ^^^^^^^^^^^^^^^^^ Prefer ActiveSupport time helper.
      RUBY

      expect_correction(<<~RUBY)
        ::Date.current
      RUBY
    end
  end

  context 'with `Time.current - n.days`' do
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

  context 'with `Time.current + n.days`' do
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

  context 'with `::Time.current`' do
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

  context 'with `time > Time.current`' do
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

  context 'with `time.after?(Time.curernt)`' do
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

  context 'with `Time.current < time`' do
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

  context 'with `Time.current.before?(time)`' do
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

  context 'with `time < Time.current`' do
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

  context 'with `time.before?(Time.current)`' do
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

  context 'with `Time.current > time`' do
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

  context 'with `Time.current.after?(time)`' do
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
