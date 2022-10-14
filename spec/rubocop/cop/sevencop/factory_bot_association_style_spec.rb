# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::FactoryBotAssociationStyle, :config do
  context 'when EnforcedStyle is implicit' do
    context 'when implicit style is used' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          factory :article do
            user
          end
        RUBY
      end
    end

    context 'when `association` has more than 1 argument' do
      it 'does not register an offense' do
        expect_no_offenses(<<~TEXT)
          factory :article do
            association :author, factory: :user
          end
        TEXT
      end
    end

    context 'when `association` is called in attribute block' do
      it 'does not register an offense' do
        expect_no_offenses(<<~TEXT)
          factory :article do
            author do
              association :user
            end
          end
        TEXT
      end
    end

    context 'when `association` has only 1 argument' do
      it 'registers and corrects an offense' do
        expect_offense(<<~TEXT)
          factory :article do
            association :user
            ^^^^^^^^^^^^^^^^^ Use consistent style in FactoryBot associations.
          end
        TEXT

        expect_correction(<<~RUBY)
          factory :article do
            user
          end
        RUBY
      end
    end
  end

  context 'when EnforcedStyle is explicit' do
    let(:cop_config) do
      { 'EnforcedStyle' => 'explicit' }
    end

    context 'when explicit style is used' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          factory :article do
            association :user
          end
        RUBY
      end
    end

    context 'when implicit association is used' do
      it 'registers and corrects an offense' do
        expect_offense(<<~TEXT)
          factory :article do
            user
            ^^^^ Use consistent style in FactoryBot associations.
          end
        TEXT

        expect_correction(<<~RUBY)
          factory :article do
            association :user
          end
        RUBY
      end
    end

    context 'when one of NonImplicitAssociationMethodNames is used' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          factory :article do
            skip_create
          end
        RUBY
      end
    end
  end
end
