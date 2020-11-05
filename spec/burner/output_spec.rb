# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::Output do
  let(:id)      { '123' }
  let(:out)     { StringOut.new }
  let(:message) { 'Ar Ye Matey!' }

  subject { described_class.new(id: id, outs: out) }

  describe '#ruler' do
    it 'outputs id' do
      subject.ruler

      expect(out.read).to include(id)
    end

    it 'outputs horizontal line' do
      subject.ruler

      expect(out.read).to include('-' * 80)
    end
  end

  describe '#title' do
    before(:each) do
      subject.title(message)
    end

    it 'outputs id' do
      expect(out.read).to include(id)
    end

    it 'outputs job id' do
      expect(out.read).to include('[1]')
    end

    it 'outputs message' do
      expect(out.read).to include(message)
    end
  end

  describe '#detail' do
    before(:each) do
      subject.detail(message)
    end

    it 'outputs id' do
      expect(out.read).to include(id)
    end

    it 'does not output job id' do
      expect(out.read).not_to include('[1]')
    end

    it 'outputs message' do
      expect(out.read).to include(message)
    end
  end

  describe '#write' do
    before(:each) do
      subject.write(message)
    end

    it 'outputs id' do
      expect(out.read).to include(id)
    end

    it 'does not output job id' do
      expect(out.read).not_to include('[1]')
    end

    it 'outputs message' do
      expect(out.read).to include(message)
    end
  end

  describe '#complete' do
    let(:seconds) { 0.55555 }

    before(:each) do
      subject.complete(seconds)
    end

    it 'outputs id' do
      expect(out.read).to include(id)
    end

    it 'does not output job id' do
      expect(out.read).not_to include('[1]')
    end

    it 'outputs message' do
      expect(out.read).to include('Completed in: 0.556 second(s)')
    end
  end
end
