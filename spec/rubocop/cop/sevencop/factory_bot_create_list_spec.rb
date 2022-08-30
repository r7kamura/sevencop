# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::FactoryBotCreateList, :config do
  context 'with block argument' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        Array.new(2) do |i|
          create(:user, order: i)
        end
      RUBY
    end
  end

  context 'with correctable code' do
    it 'autocorrects an offense' do
      expect_offense(<<~TEXT)
        Array.new(2) do
        ^^^^^^^^^^^^^^^ Use `create_list` instead.
          create(:user)
        end
      TEXT

      expect_correction(<<~RUBY)
        create_list(:user, 2)
      RUBY
    end
  end

  context 'with correctable code that includes extra arguments on `create`' do
    it 'autocorrects an offense' do
      expect_offense(<<~TEXT)
        Array.new(2) do
        ^^^^^^^^^^^^^^^ Use `create_list` instead.
          create(:user, name: 'alice')
        end
      TEXT

      expect_correction(<<~RUBY)
        create_list(:user, 2, name: 'alice')
      RUBY
    end
  end
end
