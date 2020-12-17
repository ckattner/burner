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
      # Take an array of arrays and create a CSV.  You can optionally pre-pend a byte order mark,
      # see Burner::Modeling::ByteOrderMark for acceptable options.
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: a serialized CSV string.
      class Csv < JobWithRegister
        attr_reader :byte_order_mark

        def initialize(name:, byte_order_mark: nil, register: DEFAULT_REGISTER)
          super(name: name, register: register)

          @byte_order_mark = Modeling::ByteOrderMark.resolve(byte_order_mark)

          freeze
        end

        def perform(_output, payload)
          serialized_rows = CSV.generate(options) do |csv|
            array(payload[register]).each do |row|
              csv << row
            end
          end

          payload[register] = "#{byte_order_mark}#{serialized_rows}"
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
