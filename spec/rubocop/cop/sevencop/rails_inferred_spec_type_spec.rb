# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::RailsInferredSpecType, :config do
  context 'with necessary type in keyword arguments' do
    it 'registers no offense' do
      expect_no_offenses(<<~RUBY)
        RSpec.describe User, type: :model
      RUBY
    end
  end

  context 'with redundant type in keyword arguments' do
    it 'registers offense' do
      expect_offense(<<~RUBY, '/path/to/project/spec/models/user_spec.rb')
        RSpec.describe User, type: :model
                             ^^^^^^^^^^^^ Remove redundant spec type.
      RUBY

      expect_correction(<<~RUBY)
        RSpec.describe User
      RUBY
    end
  end

  context 'with redundant type in Hash arguments' do
    it 'registers offense' do
      expect_offense(<<~RUBY, '/path/to/project/spec/models/user_spec.rb')
        RSpec.describe User, { type: :model }
                             ^^^^^^^^^^^^^^^^ Remove redundant spec type.
      RUBY

      expect_correction(<<~RUBY)
        RSpec.describe User
      RUBY
    end
  end

  context 'with redundant type and other Hash metadata' do
    it 'registers offense' do
      expect_offense(<<~RUBY, '/path/to/project/spec/models/user_spec.rb')
        RSpec.describe User, other: true, type: :model
                                          ^^^^^^^^^^^^ Remove redundant spec type.
      RUBY

      expect_correction(<<~RUBY)
        RSpec.describe User, other: true
      RUBY
    end
  end

  context 'with redundant type and other Symbol metadata' do
    it 'registers offense' do
      expect_offense(<<~RUBY, '/path/to/project/spec/models/user_spec.rb')
        RSpec.describe User, :other, type: :model
                                     ^^^^^^^^^^^^ Remove redundant spec type.
      RUBY

      expect_correction(<<~RUBY)
        RSpec.describe User, :other
      RUBY
    end
  end

  context 'with redundant type and receiver-less describe' do
    it 'registers offense' do
      expect_offense(<<~RUBY, '/path/to/project/spec/models/user_spec.rb')
        describe User, type: :model
                       ^^^^^^^^^^^^ Remove redundant spec type.
      RUBY

      expect_correction(<<~RUBY)
        describe User
      RUBY
    end
  end
end
