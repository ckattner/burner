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
      # Convert an array of arrays to an array of objects.  The difference between this
      # job and ArraysToObjects is that this one does not take in mappings and instead
      # will use the first entry as the array of keys to positionally map to.
      #
      # For example, if a register had this:
      #
      #   [['id', 'first', 'last'], [1, 'frank', 'rizzo']]
      #
      # Then executing this job would result in this:
      #
      #   [{ 'id' => 1, 'first' => frank, 'last' => rizzo }]
      #
      # As a side-effect, the keys_register would result in this, if no key mappings were specified:
      #
      #   ['id', 'first', 'last']
      #
      # If key mappings are specified:
      # [
      #  {
      #     from: 'first',
      #     to: 'first_name'
      #  }
      # ]
      # Then the register will now be:
      #   [{ 'id' => 1, 'first_name' => frank, 'last' => rizzo }]
      #
      # And the keys_register will now contain:
      #   ['id', 'first_name', 'last']
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: An array of hashes.
      class FlatFileParse < JobWithDynamicKeys
        attr_reader :key_mappings

        def initialize(keys_register:, name: '', register: DEFAULT_REGISTER, separator: BLANK,
                       key_mappings: [])
          super(name: name, register: register, keys_register: keys_register, separator: separator)

          @key_mappings = Modeling::KeyMapping.array(key_mappings)

          freeze
        end

        def perform(output, payload)
          objects     = array(payload[register])
          keys        = array(objects.shift)
          count       = objects.length
          mapped_keys = update_keys_using_mappings(keys, output)

          output.detail("Mapping #{count} array(s) to key(s): #{mapped_keys.join(', ')}")

          payload[register]      = objects.map { |object| transform(object, mapped_keys) }
          payload[keys_register] = mapped_keys
        end

        private

        def transform(object, keys)
          object.each_with_object({}).with_index do |(value, memo), index|
            next if index >= keys.length

            key = keys[index]

            resolver.set(memo, key, value)
          end
        end

        def update_keys_using_mappings(keys, output)
          updated_keys = []

          keys.each do |key|
            updated_keys.push(find_key_name_to_use_from_mappings(key, output))
          end

          updated_keys
        end

        def find_key_name_to_use_from_mappings(key, output)
          key_to_use = key

          key_mappings.each do |key_mapping|
            next unless key_mapping.from.downcase == key.downcase

            key_to_use = key_mapping.to unless key_mapping.to.empty?
            output.detail("Using key_mapping from key #{key} to #{key_to_use}")
            break
          end

          key_to_use
        end
      end
    end
  end
end
