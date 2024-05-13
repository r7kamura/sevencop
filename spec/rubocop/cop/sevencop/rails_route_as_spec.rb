# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Sevencop::RailsRouteAs, :config do
  context 'when `as` option is used' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        get "/users" => "users#index", as: "users"
      RUBY
    end
  end

  context 'when `as` option is not used' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        get "/users" => "users#index"
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Always use `as` option on routing methods. Use `as: nil` if you don't need named routes.
      RUBY
    end
  end
end
