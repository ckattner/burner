# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module Deserialize
      # Take a CSV string and de-serialize into object(s).
      #
      # Expected Payload[register] input: nothing.
      # Payload[register] output: an array of arrays.  Each inner array represents one data row.
      class Csv < JobWithRegister
        # This currently only supports returning an array of arrays, including the header row.
        # In the future this could be extended to offer more customizable options, such as
        # making it return an array of hashes with the columns mapped, etc.)
        def perform(_output, payload)
          payload[register] = CSV.new(payload[register], headers: false).to_a
        end
      end
    end
  end
end
