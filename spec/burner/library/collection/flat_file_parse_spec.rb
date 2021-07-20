# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::FlatFileParse do
  let(:arrays) do
    [
      %w[id first last middle],
      %w[1 captain kangaroo james i should not be in the results],
      %w[2 twisted sister dee]
    ]
  end

  let(:key_mappings) do
    [
      {
        from: 'first',
        to: 'first_name'
      },
      {
        from: 'last',
        to: 'last_name'
      },
      {
        from: 'id',
        to: 'id_number'
      },
      {
        from: 'phone',
        to: 'cell_phone'
      }
    ]
  end

  let(:objects) do
    [
      {
        'first_name' => 'captain',
        'id_number' => '1',
        'last_name' => 'kangaroo',
        'middle' => 'james',
      },
      {
        'first_name' => 'twisted',
        'id_number' => '2',
        'last_name' => 'sister',
        'middle' => 'dee',
      }
    ]
  end

  let(:objects_no_key_mappings) do
    [
      {
        'first' => 'captain',
        'id' => '1',
        'last' => 'kangaroo',
        'middle' => 'james',
      },
      {
        'first' => 'twisted',
        'id' => '2',
        'last' => 'sister',
        'middle' => 'dee',
      }
    ]
  end

  let(:string_out)         { StringIO.new }
  let(:output)             { Burner::Output.new(outs: [string_out]) }
  let(:register)           { 'register_a' }
  let(:keys_register)      { 'headers' }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        register => arrays.dup
      }
    )
  end

  subject do
    described_class.make(
      keys_register: keys_register,
      register: register,
      key_mappings: key_mappings
    )
  end

  describe '#perform' do
    context 'with key mappings' do
      before { subject.perform(output, payload) }

      it 'sets main register to objects as hashes not arrays' do
        expect(payload[register]).to eq(objects)
      end

      it 'sets keys_register to the first array entry' do
        expect(payload[keys_register]).to eq(%w[id_number first_name last_name middle])
      end

      it 'keys register doesn\'t include extra mapped key' do
        expect(payload[keys_register]).not_to eq(
          %w[id_number first_name last_name middle cell_phone]
        )
      end

      it 'outputs how many objects will be filtered' do
        expect(string_out.string).to include('Mapping 2 array(s)')
      end

      it 'outputs keys' do
        expect(string_out.string).to include('first_name')
        expect(string_out.string).to include('last_name')
        expect(string_out.string).to include('id_number')
        expect(string_out.string).to include('middle')
      end
    end

    context 'without key mappings' do
      let(:key_mappings) { [] }

      before { subject.perform(output, payload) }

      it 'sets main register to objects as hashes not arrays' do
        expect(payload[register]).to eq(objects_no_key_mappings)
      end

      it 'sets keys_register to the first array entry' do
        expect(payload[keys_register]).to eq(%w[id first last middle])
      end

      it 'keys register doesn\'t include extra mapped key' do
        expect(payload[keys_register]).not_to eq(%w[id first last middle cell_phone])
      end

      it 'outputs how many objects will be filtered' do
        expect(string_out.string).to include('Mapping 2 array(s)')
      end

      it 'outputs keys' do
        expect(string_out.string).to include('first')
        expect(string_out.string).to include('last')
        expect(string_out.string).to include('id')
        expect(string_out.string).to include('middle')
      end
    end
  end
end
