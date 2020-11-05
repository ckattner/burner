# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Serialize
      # Take an array of arrays and create a CSV.
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: a serialized CSV string.
      class Csv < JobWithRegister
        def perform(_output, payload)
          payload[register] = CSV.generate(options) do |csv|
            array(payload[register]).each do |row|
              csv << row
            end
          end
        end

        private

        def options
          {
            headers: false,
            write_headers: false
          }
        end
      end
    end
  end
end
