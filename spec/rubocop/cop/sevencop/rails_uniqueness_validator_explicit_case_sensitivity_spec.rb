# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsUniquenessValidatorExplicitCaseSensitivity, :config do
  context 'with simple boolean uniqueness' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        validates :name, uniqueness: true
                                     ^^^^ Specify :case_sensitivity option on use of UniquenessValidator.
      TEXT

      expect_correction(<<~RUBY)
        validates :name, uniqueness: { case_sensitive: true }
      RUBY
    end
  end

  context 'with complex uniqueness without case_sensitivity' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        validates :name, uniqueness: { allow_nil: true, scope: :user_id }
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Specify :case_sensitivity option on use of UniquenessValidator.
      TEXT

      expect_correction(<<~RUBY)
        validates :name, uniqueness: { allow_nil: true, scope: :user_id, case_sensitive: true }
      RUBY
    end
  end

  context 'with complex uniqueness with case_sensitivity' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        validates :name, uniqueness: { allow_nil: true, case_sensitive: true, scope: :user_id }
      TEXT
    end
  end
end
