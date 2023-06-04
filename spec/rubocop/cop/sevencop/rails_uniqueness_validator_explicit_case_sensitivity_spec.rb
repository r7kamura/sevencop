# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsUniquenessValidatorExplicitCaseSensitivity, :config do
  context 'with simple boolean uniqueness' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        validates :name, uniqueness: true
                                     ^^^^ Specify :case_sensitivity option on use of UniquenessValidator.
      RUBY

      expect_correction(<<~RUBY)
        validates :name, uniqueness: { case_sensitive: true }
      RUBY
    end
  end

  context 'with simple boolean uniqueness and other validations' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        validates :name, foo: true, uniqueness: true
                                                ^^^^ Specify :case_sensitivity option on use of UniquenessValidator.
      RUBY

      expect_correction(<<~RUBY)
        validates :name, foo: true, uniqueness: { case_sensitive: true }
      RUBY
    end
  end

  context 'with complex uniqueness without case_sensitivity' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        validates :name, uniqueness: { allow_nil: true, scope: :user_id }
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify :case_sensitivity option on use of UniquenessValidator.
      RUBY

      expect_correction(<<~RUBY)
        validates :name, uniqueness: { allow_nil: true, scope: :user_id, case_sensitive: true }
      RUBY
    end
  end

  context 'with complex uniqueness with case_sensitivity' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        validates :name, uniqueness: { allow_nil: true, case_sensitive: true, scope: :user_id }
      RUBY
    end
  end
end
