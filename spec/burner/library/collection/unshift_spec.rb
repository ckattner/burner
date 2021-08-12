# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Unshift do
  let(:register_value)          { [[1, 2, 3], [4, 5, 6]] }
  let(:string_out)              { StringIO.new }
  let(:output)                  { Burner::Output.new(outs: [string_out]) }
  let(:register)                { 'register_a' }
  let(:from_register_value_a)   { %w[a b c d e f] }
  let(:from_register_a)         { 'from_register' }
  let(:from_register_value_b)   { 20 }
  let(:from_register_b)         { 'from_register_b' }
  let(:from_register_value_c)   { 'This is a test' }
  let(:from_register_c)         { 'from_register_c' }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        from_register_a => from_register_value_a,
        from_register_b => from_register_value_b,
        from_register_c => from_register_value_c,
        register => register_value
      }
    )
  end

  describe '#perform' do
    subject do
      described_class.make(name: 'test', from_registers: [from_register_a],
                           register: register)
    end

    context 'when adding an array' do
      it 'prepends the array to the array of arrays' do
        subject.perform(output, payload)

        expected = [%w[a b c d e f], [1, 2, 3], [4, 5, 6]]

        not_expected = [[1, 2, 3], [4, 5, 6], %w[a b c d e f]]

        expect(payload[register]).to eq(expected)
        expect(payload[register]).not_to eq(not_expected)
      end
    end
  end

  describe '#perform' do
    subject do
      described_class.make(name: 'test', from_registers: [from_register_b],
                           register: register)
    end

    context 'when adding a number' do
      it 'prepends the number to the array of arrays' do
        subject.perform(output, payload)

        expected = [20, [1, 2, 3], [4, 5, 6]]

        expect(payload[register]).to eq(expected)
      end
    end
  end

  describe '#perform' do
    subject do
      described_class.make(name: 'test', from_registers: [from_register_c],
                           register: register)
    end

    context 'when adding a string' do
      it 'prepends the string to the array of arrays' do
        subject.perform(output, payload)

        expected = ['This is a test', [1, 2, 3], [4, 5, 6]]

        expect(payload[register]).to eq(expected)
      end
    end
  end

  describe '#perform' do
    subject { described_class.make(name: 'test', register: register) }

    context 'when adding no from_registers' do
      it 'nothing is prepended to the array of arrays' do
        subject.perform(output, payload)

        expected = [[1, 2, 3], [4, 5, 6]]

        expect(payload[register]).to eq(expected)
      end
    end
  end
end
