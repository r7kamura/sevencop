# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::OrderField, :config do
  context 'without field' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        articles.order('id DESC')
      TEXT
    end
  end

  context 'with Hash' do
    it 'registers no offense' do
      expect_no_offenses(<<~TEXT)
        articles.order(id: :desc)
      TEXT
    end
  end

  context 'with receiver' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        articles.order('field(id, ?)', a)
                       ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      TEXT

      expect_correction(<<~RUBY)
        articles.order(Arel.sql('field(id, ?)'), a)
      RUBY
    end
  end

  context 'without receiver' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        order('field(id, ?)', a)
              ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      TEXT

      expect_correction(<<~RUBY)
        order(Arel.sql('field(id, ?)'), a)
      RUBY
    end
  end

  context 'with FIELD' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        order('FIELD(id, ?)', a)
              ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      TEXT

      expect_correction(<<~RUBY)
        order(Arel.sql('FIELD(id, ?)'), a)
      RUBY
    end
  end

  context 'with reorder' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT)
        reorder('field(id, ?)', a)
                ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      TEXT

      expect_correction(<<~RUBY)
        reorder(Arel.sql('field(id, ?)'), a)
      RUBY
    end
  end

  context 'with dstr' do
    it 'autocorrects offense' do
      expect_offense(<<~'TEXT')
        articles.order("field(id, #{ids.join(', ')})")
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      TEXT

      expect_correction(<<~'RUBY')
        articles.order(Arel.sql("field(id, #{ids.join(', ')})"))
      RUBY
    end
  end
end
