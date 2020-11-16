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
      # Take a register's value (an array of objects) and group the objects by the specified keys.
      # It essentially creates a hash from an array. This is useful for creating a O(1) lookup
      # which can then be used in conjunction with the Coalesce Job for another array of data.
      # It is worth noting that the resulting hashes values are singular objects and not an array
      # like Ruby's Enumerable#group_by method.
      #
      # An example of this specific job:
      #
      # input: [{ id: 1, code: 'a' }, { id: 2, code: 'b' }]
      # keys: [:code]
      # output: { ['a'] => { id: 1, code: 'a' }, ['b'] => { id: 2, code: 'b' } }
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: hash.
      class Group < JobWithRegister
        attr_reader :keys, :resolver

        def initialize(
          name:,
          keys: [],
          register: DEFAULT_REGISTER,
          separator: ''
        )
          super(name: name, register: register)

          @keys     = Array(keys)
          @resolver = Objectable.resolver(separator: separator.to_s)

          raise ArgumentError, 'at least one key is required' if @keys.empty?

          freeze
        end

        def perform(output, payload)
          payload[register] = array(payload[register])
          count             = payload[register].length

          output.detail("Grouping based on key(s): #{keys} for #{count} records(s)")

          grouped_records = payload[register].each_with_object({}) do |record, memo|
            key       = make_key(record)
            memo[key] = record
          end

          payload[register] = grouped_records
        end

        private

        def make_key(record)
          keys.map { |key| resolver.get(record, key) }
        end
      end
    end
  end
end
