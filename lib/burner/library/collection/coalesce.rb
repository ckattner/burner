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
      # This is generally used right after the Group job has been executed on a separate
      # dataset in a separate register.  This job can match up specified values in its dataset
      # with lookup values in another.  If it finds a match then it will (shallow) copy over
      # the values into the respective dataset.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: array of objects.
      class Coalesce < JobWithRegister
        attr_reader :grouped_register, :key_mappings, :keys, :resolver

        def initialize(
          name:,
          grouped_register:,
          key_mappings: [],
          keys: [],
          register: DEFAULT_REGISTER,
          separator: ''
        )
          super(name: name, register: register)

          @grouped_register = grouped_register.to_s
          @key_mappings     = Modeling::KeyMapping.array(key_mappings)
          @keys             = Array(keys)
          @resolver         = Objectable.resolver(separator: separator.to_s)

          raise ArgumentError, 'at least one key is required' if @keys.empty?

          freeze
        end

        def perform(output, payload)
          payload[register] = array(payload[register])
          count             = payload[register].length

          output.detail("Coalescing based on key(s): #{keys} for #{count} records(s)")

          payload[register].each do |record|
            key    = make_key(record)
            lookup = find_lookup(payload, key)

            key_mappings.each do |key_mapping|
              value = resolver.get(lookup, key_mapping.from)

              resolver.set(record, key_mapping.to, value)
            end
          end
        end

        private

        def find_lookup(payload, key)
          (payload[grouped_register] || {})[key] || {}
        end

        def make_key(record)
          keys.map { |key| resolver.get(record, key) }
        end
      end
    end
  end
end
