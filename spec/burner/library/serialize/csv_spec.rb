# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Serialize::Csv do
  let(:value) do
    [
      %w[id first last],
      %w[1 captain kangaroo],
      %w[2 twisted sister]
    ]
  end

  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }

  subject { described_class.make(name: 'test', register: register) }

  describe '#perform' do
    it 'serializes and sets value' do
      subject.perform(output, payload)

      expected = "id,first,last\n1,captain,kangaroo\n2,twisted,sister\n"

      expect(payload[register]).to eq(expected)
    end
  end
end
