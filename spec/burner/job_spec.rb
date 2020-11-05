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
  let(:string_out) { StringOut.new }
  let(:output)     { Burner::Output.new(outs: string_out) }
  let(:payload)    { Burner::Payload.new(params: params) }

  subject { described_class.make(name: :test) }

  describe '#initialize' do
    it 'assigns name' do
      expect(subject.name).to eq('test')
    end
  end

  describe '#perform' do
    it 'outputs message' do
      subject.perform(output, payload)

      expect(string_out.read).to include('#perform not implemented')
    end
  end
end
