# frozen_string_literal: true

module Sevencop
  module CopConcerns
    autoload :BatchProcessing, 'sevencop/cop_concerns/batch_processing'
    autoload :ColumnTypeMethod, 'sevencop/cop_concerns/column_type_method'
    autoload :DisableDdlTransaction, 'sevencop/cop_concerns/disable_ddl_transaction'
    autoload :Ordered, 'sevencop/cop_concerns/ordered'
  end
end
