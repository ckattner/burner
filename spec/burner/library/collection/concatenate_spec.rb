# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Concatenate do
  let(:value1)      { [1] }
  let(:value2)      { nil }
  let(:value3)      { 3 }
  let(:string_out)  { StringIO.new }
  let(:output)      { Burner::Output.new(outs: [string_out]) }
  let(:register1)   { 'register1' }
  let(:register2)   { 'register2' }
  let(:register3)   { 'register3' }
  let(:to_register) { 'register4' }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        register1 => value1,
        register2 => value2,
        register3 => value3
      }
    )
  end

  subject do
    described_class.make(
      name: 'test',
      from_registers: [register1, register2, register3],
      to_register: to_register
    )
  end

  describe '#perform' do
    it 'copies value in register' do
      subject.perform(output, payload)

      expect(payload[to_register]).to eq([1, 3])
    end
  end
end
