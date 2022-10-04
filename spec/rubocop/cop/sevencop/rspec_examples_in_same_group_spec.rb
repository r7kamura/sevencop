# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecExamplesInSameGroup, :config do
  context 'with identical examples' do
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

  context 'with non identical examples' do
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
end
