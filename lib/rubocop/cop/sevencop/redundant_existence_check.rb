# frozen_string_literal: true

module RuboCop
  module Cop
    module Sevencop
      # Identifies redundant existent check before file operation.
      #
      # @safety
      #   This cop is unsafe because it can register a false positive where the check is truly needed.
      #
      # @example
      #
      #   # bad
      #   FileUtils.mkdir(a) unless FileTest.exist?(a)
      #
      #   # good
      #   FileUtils.mkdir_p(a)
      #
      #   # bad
      #   FileUtils.rm(a) if File.exist?(a)
      #
      #   # good
      #   FileUtils.rm_f(a)
      #
      class RedundantExistenceCheck < Base
        extend AutoCorrector

        CLASS_NAMES_FOR_EXIST = ::Set[
          :File,
          :FileTest,
        ]

        CLASS_NAMES_FOR_OPERATION = ::Set[
          :File,
          :FileUtils,
        ]

        METHOD_NAMES_FOR_MAKE = ::Set[
          :makedirs,
          :mkdir,
          :mkdir_p,
          :mkpath,
          :touch,
        ]

        METHOD_NAMES_FOR_REMOVE = ::Set[
          :delete,
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
          :unlink,
        ]

        METHOD_NAMES_FOR_EXIST = ::Set[
          :exist?,
          :exists?,
        ]

        METHOD_NAMES_FOR_FORCE_OPERATION = ::Set[
          :makedirs,
          :mkdir_p,
          :mkpath,
          :rm_f,
          :rm_rf,
          :rm_tree,
          :safe_unlink,
          :touch,
        ]

        METHOD_MAPPING_FOR_FORCE_REPLACEMENT = {
          'FileUtils.mkdir' => 'FileUtils.mkdir_p',
          'File.delete' => 'FileUtils.rm_f',
          'File.unlink' => 'FileUtils.rm_f'
        }.freeze

        MSG = 'Avoid redundant existent check before file operation.'

        def_node_matcher :make_unless_exist?, <<~PATTERN
          (if
            (send (const nil? CLASS_NAMES_FOR_EXIST) METHOD_NAMES_FOR_EXIST _)
            nil?
            (send (const nil? CLASS_NAMES_FOR_OPERATION) METHOD_NAMES_FOR_MAKE ...)
          )
        PATTERN

        def_node_matcher :remove_if_exist?, <<~PATTERN
          (if
            (send (const nil? CLASS_NAMES_FOR_EXIST) METHOD_NAMES_FOR_EXIST _)
            (send (const nil? CLASS_NAMES_FOR_OPERATION) METHOD_NAMES_FOR_REMOVE ...)
            nil?
          )
        PATTERN

        def on_if(node)
          return unless redundant_on_if(node) || redundant_on_unless(node)

          add_offense(node) do |corrector|
            corrector.replace(
              node.location.expression,
              enforce(node)
            )
          end
        end

        private

        def enforce(node)
          if force_operation?(node)
            node.if_branch.source
          elsif force_replaceable_method?(node)
            enforce_by_replacement(node)
          else
            enforce_by_force_option(node)
          end
        end

        def enforce_by_force_option(node)
          arguments = node.if_branch.arguments.map(&:source)
          arguments << 'force: true' unless force_operation?(node)
          format(
            '%<receiver>s.%<method_name>s(%<arguments>s)',
            arguments: arguments.join(', '),
            method_name: node.if_branch.method_name,
            receiver: node.if_branch.receiver.source
          )
        end

        def enforce_by_replacement(node)
          format(
            '%<signature>s(%<arguments>s)',
            arguments: node.if_branch.arguments.map(&:source).join(', '),
            signature: METHOD_MAPPING_FOR_FORCE_REPLACEMENT[operation_method_signature(node)]
          )
        end

        def force_operation?(node)
          force_operation_method_name?(node) || force_operation_argument?(node)
        end

        def force_operation_argument?(node)
          node.if_branch.last_argument.hash_type? &&
            node.if_branch.last_argument.pairs.any? do |pair|
              pair.key.value == :force && pair.value.true_type?
            end
        end

        def force_operation_method_name?(node)
          METHOD_NAMES_FOR_FORCE_OPERATION.include?(node.if_branch.method_name)
        end

        def redundant_on_if(node)
          remove_if_exist?(node) && same_argument?(node)
        end

        def redundant_on_unless(node)
          make_unless_exist?(node) && same_argument?(node)
        end

        def force_replaceable_method?(node)
          METHOD_MAPPING_FOR_FORCE_REPLACEMENT.key?(operation_method_signature(node))
        end

        def operation_method_signature(node)
          format(
            '%<receiver>s.%<method_name>s',
            method_name: node.if_branch.method_name,
            receiver: node.if_branch.receiver.source
          )
        end

        def same_argument?(node)
          node.condition.first_argument == node.if_branch.first_argument
        end
      end
    end
  end
end
