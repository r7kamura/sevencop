# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecMemoizedHelperBlockDelimiter, :config do
  context 'when do-end is used' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        let(:foo) do
          'bar'
        end
      RUBY
    end
  end

  context 'when blockpass is used' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        let(:foo, &block)
      RUBY
    end
  end

  context 'when braces is used on `let`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        let(:foo) {
                  ^ Use do-end block delimiter on RSpec memoized helper.
          'bar'
        }
      RUBY

      expect_correction(<<~RUBY)
        let(:foo) do
          'bar'
        end
      RUBY
    end
  end

  context 'when braces is used on `let!`' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        let!(:foo) {
                   ^ Use do-end block delimiter on RSpec memoized helper.
          'bar'
        }
      RUBY

      expect_correction(<<~RUBY)
        let!(:foo) do
          'bar'
        end
      RUBY
    end
  end

  context 'when braces is used on `subject` without name' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        subject {
                ^ Use do-end block delimiter on RSpec memoized helper.
          'bar'
        }
      RUBY

      expect_correction(<<~RUBY)
        subject do
          'bar'
        end
      RUBY
    end
  end

  context 'when braces is used on `subject` with name' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        subject(:foo) {
                      ^ Use do-end block delimiter on RSpec memoized helper.
          'bar'
        }
      RUBY

      expect_correction(<<~RUBY)
        subject(:foo) do
          'bar'
        end
      RUBY
    end
  end

  context 'when braces is used in one-line' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        let(:foo) { 'bar' }
                  ^^^^^^^^^ Use do-end block delimiter on RSpec memoized helper.
      RUBY

      expect_correction(<<~RUBY)
        let(:foo) do
         'bar'#{' '}
        end
      RUBY
    end
  end

  context 'when braces is used in without spaces' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        let(:foo){'bar'}
                 ^^^^^^^ Use do-end block delimiter on RSpec memoized helper.
      RUBY

      expect_correction(<<~RUBY)
        let(:foo) do
        'bar'
        end
      RUBY
    end
  end
end
