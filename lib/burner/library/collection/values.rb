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
      # Take an array of objects and call #values on each object.
      # If include_keys is true (it is false by default), then call #keys on the first
      # object and inject that as a "header" object.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: An array of arrays.
      class Values < JobWithRegister
        attr_reader :include_keys

        def initialize(include_keys: false, name: '', register: DEFAULT_REGISTER)
          super(name: name, register: register)

          @include_keys = include_keys || false

          freeze
        end

        def perform(_output, payload)
          payload[register] = array(payload[register])
          keys = include_keys ? [keys(payload[register].first)] : []
          values = payload[register].map { |object| values(object) }
          payload[register] = keys + values
        end

        private

        def keys(object)
          object.respond_to?(:keys) ? object.keys : []
        end

        def values(object)
          object.respond_to?(:values) ? object.values : []
        end
      end
    end
  end
end
