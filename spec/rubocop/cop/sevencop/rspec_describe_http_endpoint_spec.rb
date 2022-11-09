# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecDescribeHttpEndpoint, :config do
  context 'when top-level describes HTTP endpoint' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        RSpec.describe 'GET /users' do
        end
      RUBY
    end
  end

  context 'when top-level does not describe HTTP endpoint' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        RSpec.describe 'Users' do
                       ^^^^^^^ Pass HTTP endpoint identifier (e.g. `GET /users`) to top-level `describe` on request-specs.
        end
      RUBY
    end
  end

  context 'when top-level with cbase does not describe HTTP endpoint' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        ::RSpec.describe 'Users' do
                         ^^^^^^^ Pass HTTP endpoint identifier (e.g. `GET /users`) to top-level `describe` on request-specs.
        end
      RUBY
    end
  end

  context 'when top-level does not describe HTTP endpoint and there is metadata' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        RSpec.describe 'Users', type: :model do
                       ^^^^^^^ Pass HTTP endpoint identifier (e.g. `GET /users`) to top-level `describe` on request-specs.
        end
      RUBY
    end
  end
end
