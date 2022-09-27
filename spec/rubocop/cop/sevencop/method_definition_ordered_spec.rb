# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Sevencop::MethodDefinitionOrdered, :config do
  context 'when `def` is sorted' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        def a
        end

        def b
        end
      RUBY
    end
  end

  context 'when `def` is not sorted' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        def b
        end

        def a
        ^^^^^ Sort method definition in alphabetical order.
        end
      RUBY

      expect_correction(<<~RUBY)
        def a
        end

        def b
        end

      RUBY
    end
  end

  context 'when `def` is sorted in their section' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class Foo
          def c
          end

          def d
          end

          private

          def a
          end

          def b
          end
        end
      RUBY
    end
  end

  context 'when `#initialize` is put before other instance methods' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class Foo
          def initialize
          end

          def a
          end
        end
      RUBY
    end
  end

  context 'when `#initialize` is put after other instance methods' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class Foo
          def a
          end

          def initialize
          ^^^^^^^^^^^^^^ Sort method definition in alphabetical order.
          end
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          def initialize
          end

          def a
          end

        end
      RUBY
    end

    context 'when `defs` is not sorted' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class Foo
            def self.b
            end

            def self.a
            ^^^^^^^^^^ Sort method definition in alphabetical order.
            end
          end
        RUBY

        expect_correction(<<~RUBY)
          class Foo
            def self.a
            end

            def self.b
            end

          end
        RUBY
      end
    end

    context 'when unrelated visibility method call is put between unsorted `defs`' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class Foo
            def self.b
            end

            private

            def self.a
            ^^^^^^^^^^ Sort method definition in alphabetical order.
            end
          end
        RUBY

        expect_correction(<<~RUBY)
          class Foo
            def self.a
            end

            def self.b
            end

            private

          end
        RUBY
      end
    end

    context 'when there are sorted `defs` and `def`' do
      it 'does not register an offense' do
        expect_no_offenses(<<~RUBY)
          class Foo
            def self.a
            end

            def self.b
            end

            def c
            end

            def d
            end
          end
        RUBY
      end
    end

    context 'when unsorted method has some comments' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          class Foo
            # comment b
            def b
            end

            # comment a
            def a
            ^^^^^ Sort method definition in alphabetical order.
            end
          end
        RUBY

        expect_correction(<<~RUBY)
          class Foo
            # comment a
            def a
            end

            # comment b
            def b
            end

          end
        RUBY
      end
    end
  end
end
