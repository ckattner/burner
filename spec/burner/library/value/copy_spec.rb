# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Value::Copy do
  let(:value)         { 'Some Random Value' }
  let(:string_out)    { StringIO.new }
  let(:output)        { Burner::Output.new(outs: [string_out]) }
  let(:payload)       { Burner::Payload.new(registers: { from_register => value }) }
  let(:from_register) { 'register_a' }
  let(:to_register)   { 'register_b' }

  subject do
    described_class.make(
      name: 'test',
      from_register: from_register,
      to_register: to_register
    )
  end

  describe '#perform' do
    it 'copies value in register' do
      subject.perform(output, payload)

      expect(payload[to_register]).to eq(value)
    end
  end
end
