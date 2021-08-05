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
      # Adds the values of the from_registers to the to_register array.
      # All existing elements in the to_register array will be shifted upwards.
      #
      # Expected Payload[from_registers] input: Array containing names of registers
      # whose values to prepend.
      # Payload[to_register] output: An array with the from_registers'
      # payload added to the beginning.
      class Unshift < JobWithRegister
        attr_reader :from_registers, :to_register

        def initialize(from_registers: [], name: '', to_register: DEFAULT_REGISTER)
          super(name: name, register: to_register)

          @from_registers = Array(from_registers)
          @to_register    = to_register.to_s

          freeze
        end

        def perform(output, payload)
          output.detail("Prepending registers: '#{from_registers}' to: '#{to_register}'")

          register = array(payload[to_register])

          from_registers.each do |from_register|
            from_register_value = payload[from_register]

            register.unshift(from_register_value)
          end
        end
      end
    end
  end
end
