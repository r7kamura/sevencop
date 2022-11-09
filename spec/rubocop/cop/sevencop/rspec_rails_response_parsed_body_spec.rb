# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecRailsResponseParsedBody, :config do
  context 'when `response.parsed_body` is used' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        expect(response.parsed_body).to eq('foo' => 'bar')
      RUBY
    end
  end

  context 'when `JSON.parse(response.body)` is used' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        expect(JSON.parse(response.body)).to eq('foo' => 'bar')
               ^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `response.parsed_body` to `JSON.parse(response.body)`.
      RUBY

      expect_correction(<<~RUBY)
        expect(response.parsed_body).to eq('foo' => 'bar')
      RUBY
    end
  end

  context 'when `::JSON.parse(response.body)` is used' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        expect(::JSON.parse(response.body)).to eq('foo' => 'bar')
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `response.parsed_body` to `JSON.parse(response.body)`.
      RUBY

      expect_correction(<<~RUBY)
        expect(response.parsed_body).to eq('foo' => 'bar')
      RUBY
    end
  end
end
