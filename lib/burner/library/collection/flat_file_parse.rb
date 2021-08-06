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
      # job and ArraysToObjects is that this one does not require mappings and instead
      # will use the first entry as the array of keys to positionally map to.
      # If key mappings are specified then the keys register will only contain
      # the keys that are mapped. The register will still contain mapped and unmapped keys.
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
      #
      #  {
      #     from: 'first',
      #     to: 'first_name'
      #  }
      #  {
      #     from: 'iban',
      #     to: 'iban_number'
      #  }
      # ]
      # Then the register will now be:
      #   [{ 'id' => 1, 'first_name' => frank, 'last' => rizzo }]
      #
      # And the keys_register will now contain:
      #   ['first_name']
      #
      # Since 'last' did not have a key mapping entry it does not exist in the keys register.
      # In addition, even though 'iban' does have a key mapping it does not exist in the
      # register's payload, so it also does not exist in the keys register.
      #
      # Expected Payload[register] input: array of arrays.
      # Payload[register] output: An array of hashes.
      # Payload[keys_register] output; An array of key names.
      class FlatFileParse < JobWithDynamicKeys
        def perform(output, payload)
          objects     = array(payload[register])
          keys        = array(objects.shift)
          count       = objects.length
          mapped_keys = update_keys_using_mappings(keys, output)

          payload[register]      = objects.map { |object| transform(object, mapped_keys, output) }
          payload[keys_register] = get_mapped_keys(mapped_keys)

          output.detail("Mapping #{count} array(s)")

          output.detail("Mapping keys register array to: #{payload[keys_register].join(', ')}")
        end

        private

        def transform(object, keys, output)
          object.each_with_object({}).with_index do |(value, memo), index|
            next if index >= keys.length

            key_hash = keys[index]

            key = key_hash[:unmapped_key_name]

            mapped_key = key_hash[:mapped_key_name]

            key = mapped_key if mapped_key

            resolver.set(memo, key, value)

            output.detail("Using key #{key}")
          end
        end

        def get_mapped_keys(mapped_keys)
          keys = []

          mapped_keys.each do |mapped_key_hash|
            mapped_key = mapped_key_hash[:mapped_key_name]

            keys.push(mapped_key) if mapped_key
          end

          keys
        end

        def update_keys_using_mappings(keys, output)
          updated_keys = []

          keys.each do |key|
            if key_mappings.count.positive?
              mapped_key_name = find_key_name_to_use_from_mappings(key, output)

              key_hash = { unmapped_key_name: key, mapped_key_name: mapped_key_name }

              key_hash[:mapped_key_name] = nil if key == mapped_key_name
            else
              key_hash = { unmapped_key_name: key, mapped_key_name: key }
            end

            updated_keys.push(key_hash)
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
