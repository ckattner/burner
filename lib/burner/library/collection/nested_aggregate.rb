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
      # Iterate over a collection of objects, calling key on each object, then aggregating the
      # returns of key together into one array.  This new derived array will be set as the value
      # for the payload's register.  Leverage the key_mappings option to optionally copy down
      # keys and values from outer to inner records.  This job is particularly useful
      # if you have nested arrays but wish to deal with each level/depth in the aggregate.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: array of objects.
      class NestedAggregate < JobWithRegister
        attr_reader :key, :key_mappings, :resolver

        def initialize(key:, key_mappings: [], name: '', register: DEFAULT_REGISTER, separator: '')
          super(name: name, register: register)

          raise ArgumentError, 'key is required' if key.to_s.empty?

          @key          = key.to_s
          @key_mappings = Modeling::KeyMapping.array(key_mappings)
          @resolver     = Objectable.resolver(separator: separator.to_s)

          freeze
        end

        def perform(output, payload)
          records = array(payload[register])
          count   = records.length

          output.detail("Aggregating on key: #{key} for #{count} records(s)")

          # Outer loop on parent records
          payload[register] = records.each_with_object([]) do |record, memo|
            inner_records = resolver.get(record, key)

            # Inner loop on child records
            array(inner_records).each do |inner_record|
              memo << copy_key_mappings(record, inner_record)
            end
          end
        end

        private

        def copy_key_mappings(source_record, destination_record)
          key_mappings.each do |key_mapping|
            value = resolver.get(source_record, key_mapping.from)

            resolver.set(destination_record, key_mapping.to, value)
          end

          destination_record
        end
      end
    end
  end
end
