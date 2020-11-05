# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Collection
      # Take the list of from_registers and concatenate each of their values together.
      # Each from_value will be coerced into an array if it not an array.
      #
      # Expected Payload[from_register] input: array of objects.
      # Payload[to_register] output: An array of objects.
      class Concatenate < Job
        attr_reader :from_registers, :to_register

        def initialize(name:, from_registers: [], to_register: DEFAULT_REGISTER)
          super(name: name)

          @from_registers = Array(from_registers)
          @to_register    = to_register.to_s

          freeze
        end

        def perform(output, payload)
          output.detail("Concatenating registers: '#{from_registers}' to: '#{to_register}'")

          payload[to_register] = from_registers.each_with_object([]) do |from_register, memo|
            from_register_value = array(payload[from_register])

            memo.concat(from_register_value)
          end
        end
      end
    end
  end
end
