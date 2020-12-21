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
      # This job can take two arrays and coalesces them by index.  For example:
      #
      # input:
      #   base_register: [ 'hello', 'bugs' ]
      #   with_register: [ 'world', 'bunny' ]
      # output:
      #  register: [ ['hello', 'world'], ['bugs', 'bunny'] ]
      #
      # Expected Payload[base_register] input: array of objects.
      # Expected Payload[with_register] input: array of objects.
      # Payload[register] output: An array of two-dimensional arrays.
      class Zip < JobWithRegister
        attr_reader :base_register, :with_register

        def initialize(
          name:,
          with_register:,
          base_register: DEFAULT_REGISTER,
          register: DEFAULT_REGISTER
        )
          super(name: name, register: register)

          @base_register = base_register.to_s
          @with_register = with_register.to_s

          freeze
        end

        def perform(output, payload)
          base_data = array(payload[base_register])
          with_data = array(payload[with_register])

          output.detail("Combining register: #{base_register} (#{base_data.length} record(s))")
          output.detail("With register: #{with_register} (#{with_data.length} record(s))")

          payload[register] = base_data.zip(with_data)
        end
      end
    end
  end
end
