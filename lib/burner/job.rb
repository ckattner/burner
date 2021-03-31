# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  # Abstract base class for all job subclasses.  The only public method a subclass needs to
  # implement #perform(output, payload) and then you can register it for use using
  # the Burner::Jobs factory class method #register.  An example of a registration:
  #   Burner::Jobs.register('your_class', YourClass)
  class Job
    include Util::Arrayable
    acts_as_hashable

    attr_reader :name

    def initialize(name: '')
      @name = name.to_s
    end

    # There are only a few requirements to be considered a valid Burner Job:
    #   1. The class responds to #name
    #   2. The class responds to #perform(output, payload)
    #
    # The #perform method takes in two arguments: output (an instance of Burner::Output)
    # and payload (an instance of Burner::Payload).  Jobs can leverage output to emit
    # information to the pipeline's log(s).  The payload is utilized to pass data from job to job,
    # with its most important attribute being #registers.  The registers attribute is a mutable
    # and accessible hash per the individual job's context
    # (meaning of it is unknown without understanding a job's input and output value
    # of #registers.).  Therefore #register key values can mean anything
    # and it is up to consumers to clearly document the assumptions of its use.
    #
    # Returning false will short-circuit the pipeline right after the job method exits.
    # Returning anything else besides false just means "continue".
    def perform(output, _payload)
      output.detail("#perform not implemented for: #{self.class.name}")

      nil
    end

    protected

    def job_string_template(expression, output, payload)
      templatable_params = payload.params_and_registers_hash.merge(__id: output.id)

      Util::StringTemplate.instance.evaluate(expression, templatable_params)
    end
  end
end
