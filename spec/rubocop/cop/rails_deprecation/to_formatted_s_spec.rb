# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RailsDeprecation::ToFormattedS, :config do
  let(:config) do
    RuboCop::Config.new(
      'AllCops' => {
        'TargetRailsVersion' => target_rails_version
      }
    )
  end

  let(:target_rails_version) do
    7.0
  end

  context 'with #to_s' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        to_s
      RUBY
    end
  end

  context 'with #to_s with receiver' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        1.to_s
      RUBY
    end
  end

  context 'with #to_s with arguments on Rails 6.1' do
    let(:target_rails_version) do
      6.1
    end

    it 'registers an offense' do
      expect_no_offenses(<<~RUBY)
        to_s(:delimited)
      RUBY
    end
  end

  context 'with #to_s with arguments' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        to_s(:delimited)
        ^^^^^^^^^^^^^^^^ Use `to_fs(...)` instead of `to_s(...)`.
      RUBY

      expect_correction(<<~RUBY)
        to_fs(:delimited)
      RUBY
    end
  end

  context 'with #to_s with arguments and receiver' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        1.to_s(:delimited)
        ^^^^^^^^^^^^^^^^^^ Use `to_fs(...)` instead of `to_s(...)`.
      RUBY

      expect_correction(<<~RUBY)
        1.to_fs(:delimited)
      RUBY
    end
  end

  context 'with #to_s with &.' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        1&.to_s(:delimited)
        ^^^^^^^^^^^^^^^^^^^ Use `to_fs(...)` instead of `to_s(...)`.
      RUBY

      expect_correction(<<~RUBY)
        1&.to_fs(:delimited)
      RUBY
    end
  end
end
