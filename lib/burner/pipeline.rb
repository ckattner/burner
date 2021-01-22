# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'job_set'
require_relative 'output'
require_relative 'payload'
require_relative 'step'

module Burner
  # The root package.  A Pipeline contains the job configurations along with the steps.  The steps
  # reference jobs and tell you the order of the jobs to run.  If steps is nil then all jobs
  # will execute in their declared order.
  class Pipeline
    acts_as_hashable

    attr_reader :steps

    def initialize(jobs: [], steps: nil)
      @steps = JobSet
               .new(jobs)
               .jobs(steps)
               .map { |job| Step.new(job) }
    end

    # The main entry-point for kicking off a pipeline.
    def execute(output: Output.new, payload: Payload.new)
      output.write("Pipeline started with #{steps.length} step(s)")

      output_params(payload.params, output)
      output.ruler

      time_in_seconds = Benchmark.measure do
        steps.each do |step|
          step.perform(output, payload)

          if payload.halt_pipeline?
            output.detail('Payload was halted, ending pipeline.')
            break
          end
        end
      end.real.round(3)

      output.ruler
      output.write("Pipeline ended, took #{time_in_seconds} second(s) to complete")

      payload
    end

    private

    def output_params(params, output)
      if params.keys.any?
        output.write('Parameters:')
      else
        output.write('No parameters passed in.')
      end

      params.each { |key, value| output.detail("#{key}: #{value}") }
    end
  end
end
