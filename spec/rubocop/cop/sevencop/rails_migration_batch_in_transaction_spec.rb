# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsMigrationBatchInTransaction, :config do
  context 'when `update_all` is used within `disable_ddl_transaction!`' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class BackfillUsersSomeColumn < ActiveRecord::Migration[7.0]
          disable_ddl_transaction!

          def change
            User.update_all(some_column: 'some value')
          end
        end
      RUBY
    end
  end

  context 'when `update_all` is used without `disable_ddl_transaction!`' do
    it 'registers an offense' do
      expect_offense(<<~TEXT)
        class BackfillUsersSomeColumn < ActiveRecord::Migration[7.0]
          def change
            User.update_all(some_column: 'some value')
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Disable transaction in batch processing.
          end
        end
      TEXT

      expect_correction(<<~RUBY)
        class BackfillUsersSomeColumn < ActiveRecord::Migration[7.0]
          disable_ddl_transaction!

          def change
            User.update_all(some_column: 'some value')
          end
        end
      RUBY
    end
  end
end
