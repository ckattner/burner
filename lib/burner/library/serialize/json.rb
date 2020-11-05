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
      # Treat value like a Ruby object and serialize it using JSON.
      #
      # Expected Payload[register] input: anything.
      # Payload[register] output: string representing the output of the JSON serializer.
      class Json < JobWithRegister
        def perform(_output, payload)
          payload[register] = payload[register].to_json
        end
      end
    end
  end
end
