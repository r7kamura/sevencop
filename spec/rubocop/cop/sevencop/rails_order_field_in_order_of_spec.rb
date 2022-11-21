# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsOrderFieldInOrderOf, :config do
  context 'with `FIELD`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(id, 1, 2, 3)')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `field`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('field(id, 1, 2, 3)')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and quoted column name' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(`id`, 1, 2, 3)')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and receiver' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        relation.order('FIELD(id, 1, 2, 3)')
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        relation.in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and table name' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(posts.id, 1, 2, 3)')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'posts.id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and `Arel.sql`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order(Arel.sql('FIELD(id, 1, 2, 3)'))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and `::Arel.sql`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order(::Arel.sql('FIELD(id, 1, 2, 3)'))
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and `DESC`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(id, 1, 2, 3) DESC')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3]).reverse_order
      RUBY
    end
  end

  context 'with `FIELD` and `desc`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(id, 1, 2, 3) desc')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3]).reverse_order
      RUBY
    end
  end

  context 'with `FIELD` and `ASC`' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(id, 1, 2, 3) ASC')
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3])
      RUBY
    end
  end

  context 'with `FIELD` and `join(", ")`' do
    it 'registers offense' do
      expect_offense(<<~'RUBY')
        order("FIELD(id, #{ids.join(', ')})")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', ids)
      RUBY
    end
  end

  context 'with `FIELD` and another argument' do
    it 'registers offense' do
      expect_offense(<<~RUBY)
        order('FIELD(id, 1, 2, 3)', position: :asc)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', [1, 2, 3]).order(position: :asc)
      RUBY
    end
  end

  context 'with `FIELD` and `join(", ")` and another argument' do
    it 'registers offense' do
      expect_offense(<<~'RUBY')
        order("FIELD(id, #{ids.join(', ')})", position: :asc)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        in_order_of(:'id', ids).order(position: :asc)
      RUBY
    end
  end

  context 'with `FIELD` and other query method' do
    it 'registers offense' do
      expect_offense(<<~'RUBY')
        where('articles_count > 5').order("field(id, #{product_ids.join(',')})")
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `in_order_of` to MySQL `FIELD` function.
      RUBY

      expect_correction(<<~RUBY)
        where('articles_count > 5').in_order_of(:'id', product_ids)
      RUBY
    end
  end
end
