# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::Collection::Zip do
  let(:base_data)     { %w[hello bugs] }
  let(:with_data)     { %w[world bunny] }
  let(:string_out)    { StringIO.new }
  let(:output)        { Burner::Output.new(outs: [string_out]) }
  let(:base_register) { 'register_b' }
  let(:with_register) { 'register_c' }
  let(:register)      { 'register_a' }

  let(:payload) do
    Burner::Payload.new(
      registers: {
        base_register => base_data,
        with_register => with_data
      }
    )
  end

  subject do
    described_class.make(
      name: 'test',
      base_register: base_register,
      with_register: with_register,
      register: register
    )
  end

  describe '#perform' do
    before(:each) { subject.perform(output, payload) }

    it 'sets single zipped array on register' do
      expected = [
        %w[hello world],
        %w[bugs bunny]
      ]

      expect(payload[register]).to eq(expected)
    end

    describe 'output' do
      specify 'contains base_data register name and record count' do
        expect(string_out.string).to include("#{base_register} (#{base_data.length} record(s))")
      end

      specify 'contains with_data register name and record count' do
        expect(string_out.string).to include("#{with_register} (#{with_data.length} record(s))")
      end
    end
  end
end
