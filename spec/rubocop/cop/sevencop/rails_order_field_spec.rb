# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsOrderField, :config do
  context 'without field' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        articles.order('id DESC')
      RUBY
    end
  end

  context 'with Hash' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        articles.order(id: :desc)
      RUBY
    end
  end

  context 'with receiver' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        articles.order('field(id, ?)', a)
                       ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      RUBY

      expect_correction(<<~RUBY)
        articles.order(Arel.sql('field(id, ?)'), a)
      RUBY
    end
  end

  context 'without receiver' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('field(id, ?)', a)
              ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      RUBY

      expect_correction(<<~RUBY)
        order(Arel.sql('field(id, ?)'), a)
      RUBY
    end
  end

  context 'with FIELD' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(id, ?)', a)
              ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      RUBY

      expect_correction(<<~RUBY)
        order(Arel.sql('FIELD(id, ?)'), a)
      RUBY
    end
  end

  context 'with reorder' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        reorder('field(id, ?)', a)
                ^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      RUBY

      expect_correction(<<~RUBY)
        reorder(Arel.sql('field(id, ?)'), a)
      RUBY
    end
  end

  context 'with dstr' do
    it 'registers offense' do
      expect_offense(<<~'RUBY')
        articles.order("field(id, #{ids.join(', ')})")
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Wrap safe SQL String by `Arel.sql`.
      RUBY

      expect_correction(<<~'RUBY')
        articles.order(Arel.sql("field(id, #{ids.join(', ')})"))
      RUBY
    end
  end
end
