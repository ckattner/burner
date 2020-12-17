# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::IO::RowReader do
  let(:path)                  { File.join('spec', 'fixtures', 'basic.txt') }
  let(:string_out)            { StringIO.new }
  let(:output)                { Burner::Output.new(outs: [string_out]) }
  let(:register)              { 'register_a' }
  let(:ignore_blank_path)     { false }
  let(:ignore_file_not_found) { false }

  let(:file_data) do
    [
      { path: File.join('spec', 'fixtures', 'basic.txt') },
      { path: File.join('spec', 'fixtures', 'cars.csv') }
    ]
  end

  let(:payload) do
    Burner::Payload.new(registers: { register => file_data })
  end

  subject do
    described_class.make(
      ignore_blank_path: ignore_blank_path,
      ignore_file_not_found: ignore_file_not_found,
      name: 'test',
      register: register
    )
  end

  describe '#perform' do
    it "sets payload's value to file contents" do
      subject.perform(output, payload)

      actual = payload[register].map { |o| o['data'] }

      expected = [
        "I was read in from disk.\n",
        "make,model,year\njeep,wrangler,1991\nhonda,accord,2000\n"
      ]

      expect(actual).to eq(expected)
    end

    context 'when missing paths' do
      let(:file_data) do
        [
          { path: File.join('spec', 'fixtures', 'basic.txt') },
          { path: File.join('spec', 'fixtures', 'cars.csv') },
          { path: '' }
        ]
      end

      it 'raises ArgumentError' do
        expect { subject.perform(output, payload) }.to raise_error(ArgumentError)
      end
    end

    context 'when missing files' do
      let(:file_data) do
        [
          { path: File.join('spec', 'fixtures', 'basic.txt') },
          { path: File.join('spec', 'fixtures', 'cars.csv') },
          { path: 'does_not_exist.txt' },
        ]
      end

      it 'raises FileNotFoundError' do
        constant = Burner::Library::IO::RowReader::FileNotFoundError

        expect { subject.perform(output, payload) }.to raise_error(constant)
      end
    end

    context 'when ignoring missing paths and files' do
      let(:ignore_blank_path)     { true }
      let(:ignore_file_not_found) { true }

      let(:file_data) do
        [
          { path: File.join('spec', 'fixtures', 'basic.txt') },
          { path: File.join('spec', 'fixtures', 'cars.csv') },
          { path: '' },
          { path: 'does_not_exist.txt' },
        ]
      end

      it 'sets contents to nil' do
        subject.perform(output, payload)

        actual = payload[register].map { |o| o['data'] }

        expected = [
          "I was read in from disk.\n",
          "make,model,year\njeep,wrangler,1991\nhonda,accord,2000\n",
          nil,
          nil
        ]

        expect(actual).to eq(expected)
      end
    end
  end
end
