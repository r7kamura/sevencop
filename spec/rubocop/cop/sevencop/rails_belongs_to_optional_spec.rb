# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsBelongsToOptional, :config do
  context 'with optional: true' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        belongs_to :group, optional: true
      RUBY
    end
  end

  context 'with optional: false' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        belongs_to :group, optional: false
      RUBY
    end
  end

  context 'with { optional: true }' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        belongs_to :group, { optional: true }
      RUBY
    end
  end

  context 'with options' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        belongs_to :group, options
      RUBY
    end
  end

  context 'without no options' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        belongs_to :group
        ^^^^^^^^^^^^^^^^^ Specify :optional option.
      RUBY

      expect_correction(<<~RUBY)
        belongs_to :group, optional: true
      RUBY
    end
  end

  context 'with Hash options but no :optional element' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        belongs_to :group, class_name: 'Team'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify :optional option.
      RUBY

      expect_correction(<<~RUBY)
        belongs_to :group, class_name: 'Team', optional: true
      RUBY
    end
  end

  context 'with scope' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        belongs_to :group, -> { a }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify :optional option.
      RUBY

      expect_correction(<<~RUBY)
        belongs_to :group, -> { a }, optional: true
      RUBY
    end
  end
end
