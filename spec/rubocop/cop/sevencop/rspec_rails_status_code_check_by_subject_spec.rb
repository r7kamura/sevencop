# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Sevencop::RSpecRailsStatusCodeCheckBySubject, :config do
  context 'when `is_expected.to redirect_to(root_path)` is used' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        is_expected.to redirect_to(root_path)
      RUBY
    end
  end

  context 'when `is_expected.to eq(200)` is used' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        is_expected.to eq(200)
        ^^^^^^^^^^^^^^^^^^^^^^ Use `expect(response).to have_http_status(code)` instead of `is_expected.to eq(code)`.
      RUBY

      expect_correction(<<~RUBY)
        subject
        expect(response).to have_http_status(200)
      RUBY
    end
  end

  context 'when `is_expected.to eq(:ok)` is used' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        is_expected.to eq(:ok)
        ^^^^^^^^^^^^^^^^^^^^^^ Use `expect(response).to have_http_status(code)` instead of `is_expected.to eq(code)`.
      RUBY

      expect_correction(<<~RUBY)
        subject
        expect(response).to have_http_status(:ok)
      RUBY
    end
  end
end
