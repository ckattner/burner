# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Burner
  module Library
    module IO
      # Write value to disk.
      #
      # Expected Payload[register] input: anything.
      # Payload[register] output: whatever was passed in.
      class Write < Base
        attr_reader :binary

        def initialize(name:, path:, binary: false, register: DEFAULT_REGISTER)
          super(name: name, path: path, register: register)

          @binary = binary || false

          freeze
        end

        def perform(output, payload)
          compiled_path = job_string_template(path, output, payload)

          ensure_directory_exists(output, compiled_path)

          output.detail("Writing: #{compiled_path}")

          time_in_seconds = Benchmark.measure do
            File.open(compiled_path, mode) { |io| io.write(payload[register]) }
          end.real

          side_effect = SideEffects::WrittenFile.new(
            logical_filename: compiled_path,
            physical_filename: compiled_path,
            time_in_seconds: time_in_seconds
          )

          payload.add_side_effect(side_effect)
        end

        private

        def ensure_directory_exists(output, compiled_path)
          dirname = File.dirname(compiled_path)

          return if File.exist?(dirname)

          output.detail("Outer directory does not exist, creating: #{dirname}")

          FileUtils.mkdir_p(dirname)

          nil
        end

        def mode
          binary ? 'wb' : 'w'
        end
      end
    end
  end
end
