# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::Sevencop::RailsRouteOrdered, :config do
  context 'when routes are ordered' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        get "/users" => "users#index"
        get "/users/:id" => "users#show"
      RUBY
    end
  end

  context 'when routes are not ordered by path' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        get "/users/:id" => "users#show"
        get "/users" => "users#index"
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sort routes by path and HTTP method.
      RUBY

      expect_correction(<<~RUBY)
        get "/users" => "users#index"
        get "/users/:id" => "users#show"
      RUBY
    end
  end

  context 'when routes are not ordered by HTTP method' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        post "/users" => "users#create"
        get  "/users" => "users#index"
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Sort routes by path and HTTP method.
      RUBY

      expect_correction(<<~RUBY)
        get  "/users" => "users#index"
        post "/users" => "users#create"
      RUBY
    end
  end
end
