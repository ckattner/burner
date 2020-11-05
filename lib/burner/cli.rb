# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'pipeline'

module Burner
  # Process a single string as a Pipeline.  This is mainly to back the command-line interface.
  class Cli
    attr_reader :payload, :pipeline

    def initialize(args)
      path      = args.first
      params    = extract_cli_params(args)
      config    = read_yaml(path)
      @pipeline = Burner::Pipeline.make(jobs: config['jobs'], steps: config['steps'])
      @payload  = Payload.new(params: params)

      freeze
    end

    def execute
      pipeline.execute(payload: payload)
    end

    private

    def read_yaml(path)
      yaml = IO.read(path)

      YAML.safe_load(yaml)
    end

    def extract_cli_params(args)
      args[1..-1].each_with_object({}) do |arg, memo|
        parts = arg.to_s.split('=')

        memo[parts.first] = parts.last
      end
    end
  end
end
