# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecDescribeHttpEndpoint, :config do
  context 'when top-level describes HTTP endpoint' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        RSpec.describe 'GET /users' do
        end
      RUBY
    end
  end

  context 'when top-level does not describe HTTP endpoint' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        RSpec.describe 'Users' do
                       ^^^^^^^ Pass HTTP endpoint identifier to top-level `describe` on request-specs.
        end
      RUBY
    end
  end
end
