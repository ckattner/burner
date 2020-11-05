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
      # Take an array and remove the first N elements, where N is specified by the amount
      # attribute.  The initial use case for this was to remove "header" rows from arrays,
      # like you would expect when parsing CSV files.
      #
      # Expected Payload[register] input: nothing.
      # Payload[register] output: An array with N beginning elements removed.
      class Shift < JobWithRegister
        DEFAULT_AMOUNT = 0

        private_constant :DEFAULT_AMOUNT

        attr_reader :amount

        def initialize(name:, amount: DEFAULT_AMOUNT, register: DEFAULT_REGISTER)
          super(name: name, register: register)

          @amount = amount.to_i

          freeze
        end

        def perform(output, payload)
          output.detail("Shifting #{amount} entries.")

          payload[register] = array(payload[register]).slice(amount..-1)
        end
      end
    end
  end
end
