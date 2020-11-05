# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Value
      # Copy one value in a register to another.  Note that this does *not* perform any type of
      # deep copy, it simply points one register's value to another.  If you decide to later mutate
      # one register then you may mutate the other.
      #
      # Expected Payload[from_register] input: anything.
      # Payload[to_register] output: whatever value was specified in the from_register.
      class Copy < Job
        attr_reader :from_register, :to_register

        def initialize(name:, to_register: DEFAULT_REGISTER, from_register: DEFAULT_REGISTER)
          super(name: name)

          @from_register = from_register.to_s
          @to_register   = to_register.to_s

          freeze
        end

        def perform(output, payload)
          output.detail("Copying register: '#{from_register}' to: '#{to_register}'")

          payload[to_register] = payload[from_register]
        end
      end
    end
  end
end
