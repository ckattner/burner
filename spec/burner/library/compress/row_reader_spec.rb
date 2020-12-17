# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'zip_helper'

describe Burner::Library::Compress::RowReader do
  let(:value) do
    [
      {
        path: 'hello.txt',
        data: 'Hello World!'
      },
      {
        path: 'a/b/c/foobar.txt',
        data: 'foobar'
      },
    ]
  end

  let(:string_out)        { StringIO.new }
  let(:output)            { Burner::Output.new(outs: [string_out]) }
  let(:register)          { 'register_a' }
  let(:payload)           { Burner::Payload.new(registers: { register => value }) }
  let(:ignore_blank_path) { false }
  let(:ignore_blank_data) { false }

  subject do
    described_class.make(
      ignore_blank_data: ignore_blank_data,
      ignore_blank_path: ignore_blank_path,
      name: 'test',
      register: register
    )
  end

  describe '#perform' do
    it 'creates zip' do
      subject.perform(output, payload)

      actual              = payload[register]
      decompressed_actual = decompress(actual)

      expected = {
        'hello.txt' => 'Hello World!',
        'a/b/c/foobar.txt' => 'foobar'
      }

      expect(decompressed_actual).to eq(expected)
    end

    context 'with blank paths' do
      let(:value) do
        [
          {
            path: '',
            data: 'Hello World!'
          },
          {
            path: 'a/b/c/foobar.txt',
            data: 'foobar'
          },
        ]
      end

      context 'ignoring blank paths' do
        let(:ignore_blank_path) { true }

        it 'creates zip' do
          subject.perform(output, payload)

          actual              = payload[register]
          decompressed_actual = decompress(actual)

          expected = {
            'a/b/c/foobar.txt' => 'foobar'
          }

          expect(decompressed_actual).to eq(expected)
        end
      end

      context 'not ignoring blank paths' do
        it 'raises ArgumentError' do
          expect { subject.perform(output, payload) }.to raise_error(ArgumentError)
        end
      end
    end

    context 'when ignoring blank data' do
      let(:ignore_blank_data) { true }

      let(:value) do
        [
          {
            path: 'hello1.txt',
            data: nil
          },
          {
            path: 'hello2.txt',
            data: ''
          },
          {
            path: 'a/b/c/foobar.txt',
            data: 'foobar'
          },
        ]
      end

      it 'creates zip' do
        subject.perform(output, payload)

        actual              = payload[register]
        decompressed_actual = decompress(actual)

        expected = {
          'a/b/c/foobar.txt' => 'foobar'
        }

        expect(decompressed_actual).to eq(expected)
      end
    end
  end
end
