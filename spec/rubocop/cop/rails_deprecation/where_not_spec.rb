# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RailsDeprecation::WhereNot, :config do
  let(:config) do
    RuboCop::Config.new(
      'AllCops' => {
        'TargetRailsVersion' => target_rails_version
      }
    )
  end

  let(:target_rails_version) do
    6.0
  end

  context 'with where.not with single element Hash' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        where.not(key1: value1)
      RUBY
    end
  end

  context 'with where.not with multiple elements Hash on Rails 6.1' do
    let(:target_rails_version) do
      6.1
    end

    it 'registers an offense' do
      expect_no_offenses(<<~RUBY)
        where.not(key1: value1, key2: value2)
      RUBY
    end
  end

  context 'with where.not with multiple elements Hash' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        where.not(key1: value1, key2: value2)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `where.not(key1: value1).where.not(key2: value2)` instead of `where.not(key1: value1, key2: value2)`.
      RUBY

      expect_correction(<<~RUBY)
        where.not(key1: value1).where.not(key2: value2)
      RUBY
    end
  end

  context 'with where.not with more multiple elements Hash' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        where.not(key1: value1, key2: value2, key3: value3)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `where.not(key1: value1).where.not(key2: value2)` instead of `where.not(key1: value1, key2: value2)`.
      RUBY

      expect_correction(<<~RUBY)
        where.not(key1: value1).where.not(key2: value2).where.not(key3: value3)
      RUBY
    end
  end
end
