# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecEmptyLineAfterLet, :config do
  context 'with `let` as last child without following empty line' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        context 'with something' do
          let(:foo) do
            'foo'
          end
        end
      RUBY
    end
  end

  context 'with `let` without following empty line' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        context 'with something' do
          let(:foo) do
          ^^^^^^^^^^^^ Insert empty line after `let`.
            'foo'
          end
          let(:bar) do
            'bar'
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        context 'with something' do
          let(:foo) do
            'foo'
          end

          let(:bar) do
            'bar'
          end
        end
      RUBY
    end
  end

  context 'with `let!` without following empty line' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        context 'with something' do
          let!(:foo) do
          ^^^^^^^^^^^^^ Insert empty line after `let`.
            'foo'
          end
          let(:bar) do
            'bar'
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        context 'with something' do
          let!(:foo) do
            'foo'
          end

          let(:bar) do
            'bar'
          end
        end
      RUBY
    end
  end
end
