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
      # Take a JSON string and deserialize into object(s).
      #
      # Expected Payload[register] input: string of JSON data.
      # Payload[register] output: anything, as specified by the JSON de-serializer.
      class Json < JobWithRegister
        def perform(_output, payload)
          payload[register] = JSON.parse(payload[register])
        end
      end
    end
  end
end
