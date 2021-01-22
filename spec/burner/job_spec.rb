# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Job do
  let(:params)     { { name: 'Funky' } }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new(params: params) }
  let(:name)       { :test }

  subject { described_class.make(name: name) }

  describe '#initialize' do
    it 'assigns name' do
      expect(subject.name).to eq('test')
    end

    context 'when name is blank' do
      let(:name) { '' }

      it 'assigns blank string' do
        expect(subject.name).to eq('')
      end
    end

    context 'when name is null' do
      let(:name) { nil }

      it 'assigns blank string' do
        expect(subject.name).to eq('')
      end
    end
  end

  describe '#perform' do
    it 'outputs message' do
      subject.perform(output, payload)

      expect(string_out.string).to include('#perform not implemented')
    end
  end
end
