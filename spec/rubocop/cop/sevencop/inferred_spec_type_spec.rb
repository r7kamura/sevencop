# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::InferredSpecType, :config do
  context 'with necessary type in keyword arguments' do
    it 'does not register any offense' do
      expect_no_offenses(<<~TEXT)
        RSpec.describe User, type: :model
      TEXT
    end
  end

  context 'with redundant type in keyword arguments' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT, 'spec/models/user_spec.rb')
        RSpec.describe User, type: :model
                             ^^^^^^^^^^^^ Remove redundant spec type.
      TEXT

      expect_correction(<<~TEXT)
        RSpec.describe User
      TEXT
    end
  end

  context 'with redundant type in Hash arguments' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT, 'spec/models/user_spec.rb')
        RSpec.describe User, { type: :model }
                             ^^^^^^^^^^^^^^^^ Remove redundant spec type.
      TEXT

      expect_correction(<<~TEXT)
        RSpec.describe User
      TEXT
    end
  end

  context 'with redundant type and other Hash metadata' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT, 'spec/models/user_spec.rb')
        RSpec.describe User, other: true, type: :model
                                          ^^^^^^^^^^^^ Remove redundant spec type.
      TEXT

      expect_correction(<<~TEXT)
        RSpec.describe User, other: true
      TEXT
    end
  end

  context 'with redundant type and other Symbol metadata' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT, 'spec/models/user_spec.rb')
        RSpec.describe User, :other, type: :model
                                     ^^^^^^^^^^^^ Remove redundant spec type.
      TEXT

      expect_correction(<<~TEXT)
        RSpec.describe User, :other
      TEXT
    end
  end

  context 'with redundant type and receiver-less describe' do
    it 'autocorrects offense' do
      expect_offense(<<~TEXT, 'spec/models/user_spec.rb')
        describe User, type: :model
                       ^^^^^^^^^^^^ Remove redundant spec type.
      TEXT

      expect_correction(<<~TEXT)
        describe User
      TEXT
    end
  end
end
