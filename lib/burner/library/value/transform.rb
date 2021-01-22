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
      # Transform the current value of the register through a Realize::Pipeline.  This will
      # transform the entire value, as opposed to the b/collection/transform job, which will
      # iterate over each row/record in a dataset and transform each row/record.
      #
      # Expected Payload[register] input: anything.
      # Payload[register] output: anything.
      class Transform < JobWithRegister
        attr_reader :pipeline

        def initialize(name: '', register: DEFAULT_REGISTER, separator: '', transformers: [])
          super(name: name, register: register)

          resolver = Objectable.resolver(separator: separator)

          @pipeline = Realize::Pipeline.new(transformers, resolver: resolver)

          freeze
        end

        def perform(_output, payload)
          payload[register] = pipeline.transform(payload[register], payload.time)
        end
      end
    end
  end
end
