# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecExamplesInSameGroup, :config do
  context 'with single regular example in same group' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          it 'returns 200' do
            subject
            expect(response).to have_http_status(200)
          end
        end

        context 'when use is not logged in' do
          it 'returns 401' do
            subject
            expect(response).to have_http_status(401)
          end
        end
      RUBY
    end
  end

  context 'with regular example and allowed inclusion in same group' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          it 'returns 200' do
            subject
            expect(response).to have_http_status(200)
          end

          include_examples 'creates Foo'
        end
      RUBY
    end
  end

  context 'with multiple regular examples in same group' do
    it 'registers an offense' do
      expect_offense(<<~TEXT)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          it 'returns 200' do
            subject
            expect(response).to have_http_status(200)
          end

          it 'creates Foo' do
          ^^^^^^^^^^^^^^^^^^^ Combine examples in the same group in the time-consuming kinds of specs.
            expect { subject }.to change(Foo, :count).by(1)
          end
        end
      TEXT
    end
  end

  context 'with regular example and disallowed inclusion in same group' do
    let(:cop_config) do
      { 'IncludeSharedExamples' => true }
    end

    it 'registers an offense' do
      expect_offense(<<~TEXT)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          it 'returns 200' do
            subject
            expect(response).to have_http_status(200)
          end

          include_examples 'creates Foo'
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Combine examples in the same group in the time-consuming kinds of specs.
        end
      TEXT
    end
  end

  context 'with regular example and disallowed inclusion with block in same group' do
    let(:cop_config) do
      { 'IncludeSharedExamples' => true }
    end

    it 'registers an offense' do
      expect_offense(<<~TEXT)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          it 'returns 200' do
            subject
            expect(response).to have_http_status(200)
          end

          include_examples 'creates Foo' do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Combine examples in the same group in the time-consuming kinds of specs.
          end
        end
      TEXT
    end
  end

  context 'with disallowed inclusion and regular example in same group' do
    let(:cop_config) do
      { 'IncludeSharedExamples' => true }
    end

    it 'registers an offense' do
      expect_offense(<<~TEXT)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          include_examples 'creates Foo'

          it 'returns 200' do
          ^^^^^^^^^^^^^^^^^^^ Combine examples in the same group in the time-consuming kinds of specs.
            subject
            expect(response).to have_http_status(200)
          end
        end
      TEXT
    end
  end

  context 'with disallowed inclusion and regular example with block in same group' do
    let(:cop_config) do
      { 'IncludeSharedExamples' => true }
    end

    it 'registers an offense' do
      expect_offense(<<~TEXT)
        context 'when user is logged in' do
          before do
            log_in(user)
          end

          include_examples 'creates Foo' do
          end

          it 'returns 200' do
          ^^^^^^^^^^^^^^^^^^^ Combine examples in the same group in the time-consuming kinds of specs.
            subject
            expect(response).to have_http_status(200)
          end
        end
      TEXT
    end
  end
end
