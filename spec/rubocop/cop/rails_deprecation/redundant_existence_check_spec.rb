# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RedundantExistenceCheck, :config do
  context 'with FileUtils.rm(a)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.rm(a) if FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.rm(a, force: true)
      RUBY
    end
  end

  context 'with FileUtils.rm(a, force: true)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.rm(a, force: true) if FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.rm(a, force: true)
      RUBY
    end
  end

  context 'with FileUtils.rm_f(a)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.rm_f(a) if FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.rm_f(a)
      RUBY
    end
  end

  context 'with File.delete(a)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        File.delete(a) if FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.rm_f(a)
      RUBY
    end
  end

  context 'with FileUtils.mkdir(a)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.mkdir(a) unless FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.mkdir_p(a)
      RUBY
    end
  end

  context 'with FileUtils.mkdir_p(a, verbose: true)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.mkdir_p(a, verbose: true) unless FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.mkdir_p(a, verbose: true)
      RUBY
    end
  end

  context 'with FileUtils.mkdir(a, verbose: true)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.mkdir(a, verbose: true) unless FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.mkdir_p(a, verbose: true)
      RUBY
    end
  end

  context 'with FileUtils.mkdir(a, force: true, verbose: true)' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        FileUtils.mkdir(a, force: true, verbose: true) unless FileTest.exist?(a)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid redundant existent check before file operation.
      TEXT

      expect_correction(<<~RUBY)
        FileUtils.mkdir(a, force: true, verbose: true)
      RUBY
    end
  end

  context 'with different 1st argument' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        FileUtils.mkdir(a) unless FileTest.exist?(b)
      TEXT
    end
  end
end
