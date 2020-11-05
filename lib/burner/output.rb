# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # A Pipeline execution can write main output, which is really an outline to whats happening,
  # step-by-step.  This is not meant to replace or be true logging, but serve more as a summary
  # for each of the jobs.  Each job can decide what it would like to include in this summary
  # and leverage an instance of this class for inclusion of that information.
  class Output
    RULER_LENGTH = 80

    attr_reader :id, :job_count, :outs

    def initialize(id: SecureRandom.uuid, outs: [$stdout])
      @id        = id
      @outs      = Array(outs)
      @job_count = 1
    end

    def ruler
      write('-' * RULER_LENGTH)

      self
    end

    def title(message)
      write("[#{job_count}] #{message}")

      @job_count += 1

      self
    end

    def detail(message)
      write("  - #{message}")

      self
    end

    def write(message)
      raw("[#{id} | #{Time.now.utc}] #{message}")

      self
    end

    def complete(time_in_seconds)
      detail("Completed in: #{time_in_seconds.round(3)} second(s)")

      self
    end

    private

    def raw(message)
      outs.each { |out| out.puts(message) }

      self
    end
  end
end
