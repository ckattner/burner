# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'jobs'

module Burner
  # This class understands how jobs fit together as a cohesive unit.  It does not know how to
  # use them, but it knows how to group them together in a logical manner following some simple
  # rules, such as:
  #   - Jobs in a set should have unique names (unless the name is blank)
  #   - Subsets of jobs can be extracted, by name, in constant time.
  class JobSet
    class DuplicateJobNameError < StandardError; end
    class JobNotFoundError < StandardError; end

    def initialize(jobs = [])
      @jobs = Jobs.array(jobs).freeze

      assert_unique_job_names
    end

    def jobs(names = nil)
      return @jobs unless names

      Array(names).map do |name|
        job = named_jobs_by_name[name.to_s]

        raise JobNotFoundError, "#{name} was not declared as a job" unless job

        job
      end
    end

    private

    def named_jobs_by_name
      @named_jobs_by_name ||= named_jobs.each_with_object({}) { |job, memo| memo[job.name] = job }
    end

    def named_jobs
      @named_jobs ||= @jobs.reject { |job| job.name == '' }
    end

    def assert_unique_job_names
      unique_job_names = Set.new

      named_jobs.each do |job|
        if unique_job_names.include?(job.name)
          raise DuplicateJobNameError, "job with name: #{job.name} already declared"
        end

        unique_job_names << job.name
      end

      nil
    end
  end
end
