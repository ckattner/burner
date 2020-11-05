# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # The input for all Job#perform methods.  The main notion of this object is its 'registers'
  # attribute.  This registers attribute is a key-indifferent hash, accessible on Payload using
  # the brackets setter and getter methods.  This is dynamic and weak on purpose and is subject
  # to whatever the Job#perform methods decides it is.  This definitely adds an order-of-magnitude
  # complexity to this whole library and lifecycle, but I am not sure there is any other way
  # around it: trying to build a generic, open-ended processing pipeline to serve almost
  # any use case.
  #
  # The side_effects attribute can also be utilized as a way for jobs to emit any data in a more
  # structured/additive manner.  The initial use case for this was for Burner's core IO jobs to
  # report back the files it has written in a more structured data way (as opposed to simply
  # writing some information to the output.)
  #
  # The 'time' attribute is important in that it should for the replaying of pipelines and jobs.
  # Instead of having job's utilizing Time.now, Date.today, etc... they should rather opt to
  # use this value instead.
  class Payload
    attr_reader :params,
                :registers,
                :side_effects,
                :time

    def initialize(
      params: {},
      registers: {},
      side_effects: [],
      time: Time.now.utc
    )
      @params       = params || {}
      @registers    = {}
      @side_effects = side_effects || []
      @time         = time || Time.now.utc

      add_registers(registers)
    end

    # Add a side effect of a job.  This helps to keep track of things jobs do outside of its
    # register mutations.
    def add_side_effect(side_effect)
      tap { side_effects << side_effect }
    end

    # Set a register's value.
    def []=(key, value)
      set(key, value)
    end

    # Retrieve a register's value.
    def [](key)
      registers[key.to_s]
    end

    # Set halt_pipeline to true.  This will indicate to the pipeline to stop all
    # subsequent processing.
    def halt_pipeline
      @halt_pipeline = true
    end

    # Check and see if halt_pipeline was called.
    def halt_pipeline?
      @halt_pipeline || false
    end

    private

    def set(key, value)
      registers[key.to_s] = value
    end

    def add_registers(registers)
      (registers || {}).each { |k, v| set(k, v) }
    end
  end
end
