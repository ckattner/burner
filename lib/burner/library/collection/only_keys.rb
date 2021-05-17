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
      # This job knows how to take an array of objects and limit it to a specific set of keys.
      # The keys are pulled from another register which helps make it dynamic (you can load
      # up this other register with a dynamic list of keys at run-time.)
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: An array of objects.
      class OnlyKeys < JobWithRegister
        BLANK = ''

        attr_reader :keys_register,
                    :resolver

        def initialize(
          keys_register:,
          name: '',
          register: DEFAULT_REGISTER,
          separator: BLANK
        )
          super(name: name, register: register)

          @keys_register = keys_register.to_s
          @resolver      = Objectable.resolver(separator: separator)

          freeze
        end

        def perform(output, payload)
          objects = array(payload[register])
          count   = objects.length
          keys    = array(payload[keys_register])

          output.detail("Dynamically limiting #{count} object(s) with key(s): #{keys.join(', ')}")

          payload[register] = objects.map { |object| transform(object, keys) }
        end

        private

        def transform(object, keys)
          keys.each_with_object({}) do |key, memo|
            value = resolver.get(object, key)

            resolver.set(memo, key, value)
          end
        end
      end
    end
  end
end
