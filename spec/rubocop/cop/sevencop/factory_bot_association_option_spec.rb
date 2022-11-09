# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::FactoryBotAssociationOption, :config do
  context 'when `association` has no factory option' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        association :user
      TEXT
    end
  end

  context 'when `association` has no factory option but other option' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        association :user, strtaegy: :build
      TEXT
    end
  end

  context 'when `association` has non-redundant factory option' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        association :author, factory: :user
      TEXT
    end
  end

  context 'when `association` has redundant but array factory option' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        association :user, factory: %i[user]
      TEXT
    end
  end

  context 'when `association` has redundant factory option' do
    it 'registers offense' do
      expect_offense(<<~TEXT)
        association :user, factory: :user
                           ^^^^^^^^^^^^^^ Remove redundant options from FactoryBot associations.
      TEXT

      expect_correction(<<~RUBY)
        association :user
      RUBY
    end
  end
end
