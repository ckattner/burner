# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Value::Nest do
  let(:value)      { 'Some Random Value' }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }
  let(:register)   { 'register_a' }
  let(:key)        { 'abcd' }

  subject { described_class.make(register: register, key: key) }

  describe '#perform' do
    it 'sets value' do
      subject.perform(output, payload)

      expect(payload[register]).to eq({ key => value })
    end
  end
end
