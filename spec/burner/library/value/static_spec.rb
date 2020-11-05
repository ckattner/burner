# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Value::Static do
  let(:value)      { 'Some Random Value' }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new }
  let(:register)   { 'register_a' }

  subject { described_class.make(name: 'test', register: register, value: value) }

  describe '#perform' do
    it 'sets value' do
      subject.perform(output, payload)

      expect(payload[register]).to include(value)
    end
  end
end
