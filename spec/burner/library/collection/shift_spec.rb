# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Shift do
  let(:value)      { %w[a b c] }
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:register)   { 'register_a' }
  let(:payload)    { Burner::Payload.new(registers: { register => value }) }

  subject { described_class.make(name: 'test', amount: amount, register: register) }

  describe '#perform' do
    context 'when amount is 1' do
      let(:amount) { 1 }

      it 'skips entries' do
        subject.perform(output, payload)

        expected = %w[b c]

        expect(payload[register]).to eq(expected)
      end
    end

    context 'when amount is 2' do
      let(:amount) { 2 }

      it 'skips entries' do
        subject.perform(output, payload)

        expected = %w[c]

        expect(payload[register]).to eq(expected)
      end
    end

    context 'when amount is 3' do
      let(:amount) { 3 }

      it 'skips entries' do
        subject.perform(output, payload)

        expected = []

        expect(payload[register]).to eq(expected)
      end
    end
  end
end
