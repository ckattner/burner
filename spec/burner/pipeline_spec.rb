# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

class ParseCsv < Burner::JobWithRegister
  def perform(_output, payload)
    payload[register] = CSV.parse(payload[register], headers: true).map(&:to_h)

    nil
  end
end
Burner::Jobs.register('parse_csv', ParseCsv)

describe Burner::Pipeline do
  let(:params)     { { name: 'Funky' } }
  let(:string_out) { StringIO.new }
  let(:output)     { Burner::Output.new(outs: [string_out]) }
  let(:payload)    { Burner::Payload.new(params: params) }
  let(:register)   { 'register_a' }

  let(:jobs) do
    [
      { name: :nothing1 },
      { name: :nothing2 },
      { name: :nothing3 }
    ]
  end

  let(:steps) do
    %i[nothing1 nothing2 nothing3]
  end

  subject { described_class.make(jobs: jobs, steps: steps) }

  context 'when steps is not passed in (nil)' do
    subject { described_class.make(jobs: jobs) }

    it 'uses all declared jobs in their positional order.' do
      expect(subject.steps.map(&:name)).to eq(steps.map(&:to_s))
    end
  end

  describe '#execute' do
    it 'execute all steps' do
      subject.execute(output: output, payload: payload)

      expect(string_out.string).to include('::nothing1')
      expect(string_out.string).to include('::nothing2')
      expect(string_out.string).to include('::nothing3')
    end

    it 'outputs params' do
      subject.execute(output: output, payload: payload)

      expect(string_out.string).to include('Parameters:')
    end

    it 'does not output params' do
      subject.execute(output: output)

      expect(string_out.string).not_to include('Parameters:')
      expect(string_out.string).to     include('No parameters passed in.')
    end

    it 'short circuits when Payload#halt_pipeline? returns true' do
      pipeline = {
        jobs: [
          { name: :nothing1 },
          {
            name: :check,
            type: 'b/io/exist',
            short_circuit: true,
            path: 'does_not_exist_123.t'
          },
          { name: :nothing2 }
        ],
        steps: %i[nothing1 check nothing2]
      }

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      expect(string_out.string).not_to include('nothing2')
      expect(string_out.string).to     include('Payload was halted, ending pipeline.')
    end
  end

  describe 'README examples' do
    specify 'json-to-yaml converter' do
      pipeline = {
        jobs: [
          {
            name: :read,
            type: 'b/io/read',
            path: '{input_file}'
          },
          {
            name: :output_id,
            type: 'b/echo',
            message: 'The job id is: {__id}'
          },
          {
            name: :output_value,
            type: 'b/echo',
            message: 'The current value is: {__value}'
          },
          {
            name: :parse,
            type: 'b/deserialize/json'
          },
          {
            name: :convert,
            type: 'b/serialize/yaml'
          },
          {
            name: :write,
            type: 'b/io/write',
            path: '{output_file}'
          }
        ],
        steps: %i[
          read
          output_id
          output_value
          parse
          convert
          output_value
          write
        ]
      }

      params = {
        input_file: File.join('spec', 'fixtures', 'input.json'),
        output_file: File.join(TEMP_DIR, "#{SecureRandom.uuid}.yaml")
      }

      payload = Burner::Payload.new(params: params)

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      actual = File.open(params[:output_file], 'r', &:read)

      expect(actual).to eq("---\nname: Funky Chicken!\n")
    end

    specify 'json-to-yaml converter' do
      pipeline = {
        jobs: [
          {
            type: 'b/io/read',
            path: '{input_file}'
          },
          {
            type: 'b/echo',
            message: 'The job id is: {__id}'
          },
          {
            type: 'b/echo',
            message: 'The current value is: {__value}'
          },
          {
            type: 'b/deserialize/json'
          },
          {
            type: 'b/serialize/yaml'
          },
          {
            type: 'b/echo',
            message: 'The current value is: {__value}'
          },
          {
            type: 'b/io/write',
            path: '{output_file}'
          }
        ]
      }

      params = {
        input_file: File.join('spec', 'fixtures', 'input.json'),
        output_file: File.join(TEMP_DIR, "#{SecureRandom.uuid}.yaml")
      }

      payload = Burner::Payload.new(params: params)

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      actual = File.open(params[:output_file], 'r', &:read)

      expect(actual).to eq("---\nname: Funky Chicken!\n")
    end

    specify 'adding csv parsing job' do
      pipeline = {
        jobs: [
          {
            name: :read,
            type: 'b/io/read',
            path: '{input_file}',
            register: register
          },
          {
            name: :output_id,
            type: 'b/echo',
            message: 'The job id is: {__id}'
          },
          {
            name: :output_value,
            type: 'b/echo',
            message: 'The current value is: {__value}'
          },
          {
            name: :parse,
            type: 'parse_csv',
            register: register
          },
          {
            name: :convert,
            type: 'b/serialize/yaml',
            register: register
          },
          {
            name: :write,
            type: 'b/io/write',
            path: '{output_file}',
            register: register
          }
        ],
        steps: %i[
          read
          output_id
          output_value
          parse
          convert
          output_value
          write
        ]
      }

      params = {
        input_file: File.join('spec', 'fixtures', 'cars.csv'),
        output_file: File.join(TEMP_DIR, "#{SecureRandom.uuid}.yaml")
      }

      payload = Burner::Payload.new(params: params)

      Burner::Pipeline.make(pipeline).execute(output: output, payload: payload)

      actual = File.open(params[:output_file], 'r', &:read)

      expected_yaml = <<~YAML
        ---
        - make: jeep
          model: wrangler
          year: '1991'
        - make: honda
          model: accord
          year: '2000'
      YAML

      expect(actual).to eq(expected_yaml)
    end
  end

  describe 'other examples' do
    specify 'Collection::ArraysToObjects example' do
      config = {
        jobs: [
          {
            name: 'set',
            type: 'b/value/static',
            value: [
              [1, 'funky']
            ],
            register: register
          },
          {
            name: 'map',
            type: 'b/collection/arrays_to_objects',
            mappings: [
              { index: 0, key: 'id' },
              { index: 1, key: 'name' }
            ],
            register: register
          },
          {
            name: 'output',
            type: 'b/echo',
            message: 'value is currently: {__value}'
          },

        ],
        steps: %w[set map output]
      }

      payload = Burner::Payload.new
      described_class.make(config).execute(output: output, payload: payload)

      expected = [
        { 'id' => 1, 'name' => 'funky' }
      ]

      expect(payload[register]).to eq(expected)
    end

    specify 'Collection::ObjectsToArrays example' do
      config = {
        jobs: [
          {
            name: 'set',
            type: 'b/value/static',
            value: [
              { 'id' => 1, 'name' => 'funky' }
            ],
            register: register
          },
          {
            name: 'map',
            type: 'b/collection/objects_to_arrays',
            mappings: [
              { index: 0, key: 'id' },
              { index: 1, key: 'name' }
            ],
            register: register
          },
          {
            name: 'output',
            type: 'b/echo',
            message: 'value is currently: {__value}'
          },

        ]
      }

      payload = Burner::Payload.new
      described_class.make(config).execute(output: output, payload: payload)

      expected = [
        [1, 'funky']
      ]

      expect(payload[register]).to eq(expected)
    end
  end
end
