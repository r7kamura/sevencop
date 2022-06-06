# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RedundantExistenceCheck, :config do
  context 'with make-unless-exist' do
    it 'registers an offense' do
      expect_offense(<<~TEXT)
        FileUtils.mkdir(a) unless FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.mkdir(a)
      RUBY
    end
  end

  context 'with make-unless-exist with different argument' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        FileUtils.mkdir(a) unless FileTest.exist?(b)
      TEXT
    end
  end

  context 'with make-unless-exist with options' do
    it 'registers an offense' do
      expect_offense(<<~TEXT)
        FileUtils.mkdir(a, verbose: true) unless FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.mkdir(a, verbose: true)
      RUBY
    end
  end

  context 'with remove-if-exist' do
    it 'registers an offense' do
      expect_offense(<<~TEXT)
        FileUtils.rm(a) if FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.rm(a)
      RUBY
    end
  end
end
