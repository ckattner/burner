# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'data'

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
  #
  # The notion of params are somewhat conflated with registers here.  Both are hashes and both
  # serve as data stores. The difference is registers are really meant to be the shared-data
  # repository across jobs, while params are, more or less, the input into the _pipeline_.
  # It is debatable if mutation of the params should be allowed but the design decision was made
  # early on to allow for params to be mutable albeit with registers being the preferred mutable
  # store.
  class Payload
    attr_reader :side_effects,
                :time

    def initialize(
      params: {},
      registers: {},
      side_effects: [],
      time: Time.now.utc
    )
      @params       = Data.new(params)
      @registers    = Data.new(registers)
      @side_effects = side_effects || []
      @time         = time || Time.now.utc
    end

    # Backwards compatibility.  This allows for control over the underlying data structure
    # while still maintaining the same public API as before.
    def params
      @params.to_h
    end

    # Backwards compatibility.  This allows for control over the underlying data structure
    # while still maintaining the same public API as before.
    def registers
      @registers.to_h
    end

    # Law of Demeter: While params is an accessible hash, it is preferred that the
    # public class methods are used.
    def param(key)
      @params[key]
    end

    def update_param(key, value)
      tap { @params[key] = value }
    end

    # Add a side effect of a job.  This helps to keep track of things jobs do outside of its
    # register mutations.
    def add_side_effect(side_effect)
      tap { side_effects << side_effect }
    end

    # Set a register's value.
    def []=(key, value)
      @registers[key] = value
    end

    # Retrieve a register's value.
    def [](key)
      @registers[key]
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

    def params_and_registers_hash
      registers_hash = @registers.transform_keys { |key| "__#{key}_register" }
      params_hash    = @params.to_h

      params_hash.merge(registers_hash)
    end
  end
end
