# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Cli do
  let(:args) do
    [
      File.join('spec', 'fixtures', 'pipeline.yaml'),
      'param1=abc',
      'param2=def'
    ]
  end

  subject { described_class.new(args) }

  describe '#initialize' do
    it 'reads and loads yaml' do
      expect(subject.pipeline.steps.length).to eq(2)
      expect(subject.pipeline.steps.map(&:name)).to eq(%w[nothing bedtime])
    end
  end

  describe '#execute' do
    it 'calls Pipeline#execute' do
      payload = subject.payload

      expect(subject.pipeline).to receive(:execute).with(payload: payload)

      subject.execute
    end
  end
end
