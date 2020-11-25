# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Deserialize::Yaml do
  let(:value)      { "---\nname: Captain Jack Sparrow\n" }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }
  let(:register)   { 'register_a' }

  subject { described_class.make(name: 'test', register: register) }

  describe '#perform' do
    it 'de-serializes and sets value' do
      subject.perform(output, payload)

      expected = { 'name' => 'Captain Jack Sparrow' }

      expect(payload[register]).to eq(expected)
    end
  end
end
