# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Burner::JobSet do
  let(:jobs) { [{ name: :nothing }] }

  subject { described_class.new(jobs) }

  describe '#initialize' do
    it 'raises a DuplicateJobNameError if jobs have the same name' do
      jobs = [
        { name: :nothing1 },
        { name: :nothing2 },
        { name: :nothing3 },
        { name: :nothing3 }
      ]

      error_constant = Burner::JobSet::DuplicateJobNameError
      expect { described_class.new(jobs) }.to raise_error(error_constant)
    end
  end

  describe '#jobs' do
    context 'when names is null' do
      let(:names) { nil }

      it 'returns all jobs' do
        actual = subject.jobs(names)

        expect(actual).to eq(subject.jobs)
      end
    end

    context 'when names is empty array' do
      let(:names) { [] }

      it 'returns empty array' do
        actual = subject.jobs(names)

        expect(actual).to eq([])
      end
    end

    context 'when names is a string' do
      let(:names) { 'nothing' }

      it 'returns array with single job' do
        actual   = subject.jobs(names)
        expected = [subject.jobs.first]

        expect(actual).to eq(expected)
      end
    end

    context 'when names is a symbol' do
      let(:names) { :nothing }

      it 'returns array with single job' do
        actual   = subject.jobs(names)
        expected = [subject.jobs.first]

        expect(actual).to eq(expected)
      end
    end

    context 'when a name does not correspond to a job' do
      let(:names) { %i[nada] }

      it 'raises JobNotFoundError' do
        error = Burner::JobSet::JobNotFoundError

        expect { subject.jobs(names) }.to raise_error(error)
      end
    end
  end
end
