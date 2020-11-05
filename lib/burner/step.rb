# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # A wrapper to execute a job (in the context of a Pipeline.)
  class Step
    extend Forwardable

    SEPARATOR = '::'

    private_constant :SEPARATOR

    attr_reader :job

    def_delegators :job, :name

    def initialize(job)
      raise ArgumentError, 'job is required' unless job

      @job = job

      freeze
    end

    def perform(output, payload)
      output.title("#{job.class.name}#{SEPARATOR}#{job.name}")

      time_in_seconds = Benchmark.measure do
        job.perform(output, payload)
      end.real.round(3)

      output.complete(time_in_seconds)
    end
  end
end
