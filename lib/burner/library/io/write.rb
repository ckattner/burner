# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'open_file_base'

module Burner
  module Library
    module IO
      # Write value to disk.  By default, written files are also logged as WrittenFile
      # instances to the Payload#side_effects array.  You can pass in
      # supress_side_effect: true to disable this behavior.
      #
      # Expected Payload[register] input: anything.
      # Payload[register] output: whatever was passed in.
      class Write < OpenFileBase
        attr_reader :supress_side_effect

        def initialize(
          path:,
          binary: false,
          disk: {},
          name: '',
          register: DEFAULT_REGISTER,
          supress_side_effect: false
        )
          @supress_side_effect = supress_side_effect || false

          super(
            binary: binary,
            disk: disk,
            name: name,
            path: path,
            register: register
          )
        end

        def perform(output, payload)
          logical_filename  = job_string_template(path, output, payload)
          physical_filename = nil

          output.detail("Writing: #{logical_filename}")

          time_in_seconds = Benchmark.measure do
            physical_filename = disk.write(logical_filename, payload[register], binary: binary)
          end.real

          output.detail("Wrote to: #{physical_filename}")

          return if supress_side_effect

          output.detail("Saving to side effects: #{logical_filename}")

          side_effect = SideEffects::WrittenFile.new(
            logical_filename: logical_filename,
            physical_filename: physical_filename,
            time_in_seconds: time_in_seconds
          )

          payload.add_side_effect(side_effect)
        end
      end
    end
  end
end
