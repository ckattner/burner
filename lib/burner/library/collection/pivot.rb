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
      # Take an array of objects and pivot a key into multiple keys.  It essentially takes all
      # the values for a key and creates N number of keys (one per value.)
      # Under the hood it uses HashMath's Record and Table classes:
      # https://github.com/bluemarblepayroll/hash_math
      #
      # An example of a normalized dataset that could be pivoted:
      #
      # records = [
      #   { patient_id: 1, key: :first_name, value: 'bozo' },
      #   { patient_id: 1, key: :last_name,  value: 'clown' },
      #   { patient_id: 2, key: :first_name, value: 'frank' },
      #   { patient_id: 2, key: :last_name,  value: 'rizzo' },
      # ]
      #
      # Using the following job configuration:
      #
      # config = {
      #   unique_key: :patient_id
      # }
      #
      # Once ran through this job, it would set the register to:
      #
      # records = [
      #   { patient_id: 1, first_name: 'bozo', last_name: 'clown' },
      #   { patient_id: 2, first_name: 'frank', last_name: 'rizzo' },
      # ]
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: An array of objects.
      class Pivot < JobWithRegister
        DEFAULT_PIVOT_KEY       = :key
        DEFAULT_PIVOT_VALUE_KEY = :value

        attr_reader :insensitive,
                    :other_keys,
                    :non_pivoted_keys,
                    :pivot_key,
                    :pivot_value_key,
                    :resolver,
                    :unique_keys

        def initialize(
          unique_keys:,
          insensitive: false,
          name: '',
          other_keys: [],
          pivot_key: DEFAULT_PIVOT_KEY,
          pivot_value_key: DEFAULT_PIVOT_KEY_VALUE,
          register: DEFAULT_REGISTER,
          separator: ''
        )
          super(name: name, register: register)

          @insensitive      = insensitive || false
          @pivot_key        = pivot_key.to_s
          @pivot_value_key  = pivot_value_key.to_s
          @resolver         = Objectable.resolver(separator: separator)
          @unique_keys      = Array(unique_keys)
          @other_keys       = Array(other_keys)
          @non_pivoted_keys = @unique_keys + @other_keys

          freeze
        end

        def perform(output, payload)
          objects = array(payload[register])
          table   = make_table(objects)

          output.detail("Pivoting #{objects.length} object(s)")
          output.detail("By key: #{pivot_key} and value: #{pivot_value_key}")

          objects.each { |object| object_to_table(object, table) }

          pivoted_objects = table.to_a.map(&:fields)

          output.detail("Resulting dataset has #{pivoted_objects.length} object(s)")

          payload[register] = pivoted_objects
        end

        private

        def resolve_key(object)
          key_to_use = resolver.get(object, pivot_key)

          make_key(key_to_use)
        end

        def make_key(value)
          insensitive ? value.to_s.downcase : value
        end

        def make_row_id(object)
          unique_keys.map { |k| make_key(resolver.get(object, k)) }
        end

        def make_key_map(objects)
          objects.each_with_object({}) do |object, key_map|
            key = resolver.get(object, pivot_key)
            unique_key = make_key(key)

            key_map[unique_key] ||= Set.new

            key_map[unique_key] << key
          end
        end

        def make_record(objects)
          key_map = make_key_map(objects)
          keys    = non_pivoted_keys + key_map.values.map(&:first)

          HashMath::Record.new(keys)
        end

        def make_table(objects)
          HashMath::Table.new(make_record(objects))
        end

        def object_to_table(object, table)
          row_id = make_row_id(object)

          non_pivoted_keys.each do |key|
            value = resolver.get(object, key)

            table.add(row_id, key, value)
          end

          key_to_use   = resolve_key(object)
          value_to_use = resolver.get(object, pivot_value_key)

          table.add(row_id, key_to_use, value_to_use)

          self
        end
      end
    end
  end
end
