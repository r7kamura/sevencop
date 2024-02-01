# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RSpecRailsHaveHttpStatus, :config do
  context 'with `have_http_status`' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        it 'creates a new post' do
          expect { subject }.to change(Post, :count).by(1)
          expect(response).to have_http_status(200)
        end
      RUBY
    end
  end

  context 'with `redirect_to`' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        it 'creates a new post' do
          expect { subject }.to change(Post, :count).by(1)
          expect(response).to redirect_to(posts_path)
        end
      RUBY
    end
  end

  context 'without status check method' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        it 'creates a new post' do
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Always check status code with `have_http_status`.
          expect { subject }.to change(Post, :count).by(1)
        end
      RUBY
    end
  end
end
