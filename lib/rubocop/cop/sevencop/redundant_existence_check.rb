# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies redundant existent check before file operation.
      #
      # @safety
      #   This cop is unsafe because it can register a false positive
      #   where the check is truly needed.
      #
      # @example
      #
      #   # bad
      #   FileUtils.mkdir(a) unless FileTest.exist?(a)
      #
      #   # good
      #   FileUtils.mkdir(a)
      #
      #   # bad
      #   FileUtils.rm(a) if FileTest.exist?(a)
      #
      #   # good
      #   FileUtils.rm(a)
      #
      class RedundantExistenceCheck < Base
        extend AutoCorrector

        CLASS_NAMES_FOR_EXIST = ::Set[
          :File,
          :FileTest,
        ]

        METHOD_NAMES_FOR_MAKE = ::Set[
          :makedirs,
          :mkdir,
          :mkdir_p,
          :mkpath,
          :touch,
        ]

        METHOD_NAMES_FOR_REMOVE = ::Set[
          :remove,
          :remove_dir,
          :remove_entry,
          :remove_entry_secure,
          :remove_file,
          :rm,
          :rm_f,
          :rm_r,
          :rm_rf,
          :rmdir,
          :rmtree,
          :safe_unlink,
        ]

        METHOD_NAMES_FOR_EXIST = ::Set[
          :exist?,
          :exists?,
        ]

        MSG = 'Avoid redundant existent check before file operation.'

        def_node_matcher :make_unless_exist?, <<~PATTERN
          (if
            (send (const nil? CLASS_NAMES_FOR_EXIST) METHOD_NAMES_FOR_EXIST _)
            nil?
            (send (const nil? :FileUtils) METHOD_NAMES_FOR_MAKE ...)
          )
        PATTERN

        def_node_matcher :remove_if_exist?, <<~PATTERN
          (if
            (send (const nil? CLASS_NAMES_FOR_EXIST) METHOD_NAMES_FOR_EXIST _)
            (send (const nil? :FileUtils) METHOD_NAMES_FOR_REMOVE ...)
            nil?
          )
        PATTERN

        def on_if(node)
          if redundant_on_if(node)
            add_offense(node) do |rewriter|
              remove_if(
                node: node,
                rewriter: rewriter
              )
            end
          elsif redundant_on_unless(node)
            add_offense(node) do |rewriter|
              remove_unless(
                node: node,
                rewriter: rewriter
              )
            end
          end
        end

        private

        def redundant_on_if(node)
          remove_if_exist?(node) && same_argument_on_if(node)
        end

        def redundant_on_unless(node)
          make_unless_exist?(node) && same_argument_on_unless(node)
        end

        def remove_if(node:, rewriter:)
          rewriter.replace(
            node.location.expression,
            node.children[1].source
          )
        end

        def remove_unless(node:, rewriter:)
          rewriter.replace(
            node.location.expression,
            node.children[2].source
          )
        end

        def same_argument_on_if(node)
          node.children[0].children[2] == node.children[1].children[2]
        end

        def same_argument_on_unless(node)
          node.children[0].children[2] == node.children[2].children[2]
        end
      end
    end
  end
end
