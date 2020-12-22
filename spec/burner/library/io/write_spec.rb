# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Library::IO::Write do
  let(:path)                { File.join(TEMP_DIR, "#{SecureRandom.uuid}.txt") }
  let(:params)              { { path: path } }
  let(:string_out)          { StringIO.new }
  let(:output)              { Burner::Output.new(outs: [string_out]) }
  let(:value)               { 'I should be written to disk.' }
  let(:register)            { 'register_a' }
  let(:supress_side_effect) { false }

  let(:payload) do
    Burner::Payload.new(params: params, registers: { register => value })
  end

  subject do
    described_class.make(
      name: 'test',
      path: '{path}',
      register: register,
      supress_side_effect: supress_side_effect
    )
  end

  describe '#perform' do
    before(:each) do
      subject.perform(output, payload)
    end

    it "writes payload's value to file" do
      actual = File.open(path, 'r', &:read)

      expect(actual).to eq(value)
    end

    it 'adds WrittenFile instance to Payload#side_effects' do
      expect(payload.side_effects.length).to                  eq(1)
      expect(payload.side_effects.first.logical_filename).to  eq(path)
      expect(payload.side_effects.first.physical_filename).to eq(path)
    end

    context 'when supressing side effect' do
      let(:supress_side_effect) { true }

      it 'does not add to Payload#side_effects' do
        expect(payload.side_effects).to be_empty
      end
    end
  end
end
