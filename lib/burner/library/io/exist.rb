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
      # Check to see if a file exists.  If short_circuit is set to true and the file
      # does not exist then the job will return false and short circuit the pipeline.
      #
      # Note: this does not use Payload#registers.
      class Exist < Job
        attr_reader :path, :short_circuit

        def initialize(name:, path:, short_circuit: false)
          super(name: name)

          raise ArgumentError, 'path is required' if path.to_s.empty?

          @path          = path.to_s
          @short_circuit = short_circuit || false
        end

        def perform(output, payload)
          compiled_path = job_string_template(path, output, payload)

          exists = File.exist?(compiled_path)
          verb   = exists ? 'does' : 'does not'

          output.detail("The path: #{compiled_path} #{verb} exist")

          # if anything but false is returned then the pipeline will not short circuit.
          payload.halt_pipeline if short_circuit && !exists
        end
      end
    end
  end
end
