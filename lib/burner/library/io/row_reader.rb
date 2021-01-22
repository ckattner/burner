# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'open_file_base'

module Burner
  module Library
    module IO
      # Iterates over an array of objects, extracts a filepath from a key in each object,
      # and attempts to load the file's content for each record.  The file's content will be
      # stored at the specified data_key. By default missing paths or files will be
      # treated as hard errors.  If you wish to ignore these then pass in true for
      # ignore_blank_path and/or ignore_file_not_found.
      #
      # Expected Payload[register] input: array of objects.
      # Payload[register] output: array of objects.
      class RowReader < JobWithRegister
        class FileNotFoundError < StandardError; end

        DEFAULT_DATA_KEY = 'data'
        DEFAULT_PATH_KEY = 'path'

        attr_reader :binary,
                    :data_key,
                    :disk,
                    :ignore_blank_path,
                    :ignore_file_not_found,
                    :path_key,
                    :resolver

        def initialize(
          binary: false,
          data_key: DEFAULT_DATA_KEY,
          disk: {},
          ignore_blank_path: false,
          ignore_file_not_found: false,
          name: '',
          path_key: DEFAULT_PATH_KEY,
          register: DEFAULT_REGISTER,
          separator: ''
        )
          super(name: name, register: register)

          @binary                = binary || false
          @data_key              = data_key.to_s
          @disk                  = Disks.make(disk)
          @ignore_blank_path     = ignore_blank_path || false
          @ignore_file_not_found = ignore_file_not_found || false
          @path_key              = path_key.to_s
          @resolver              = Objectable.resolver(separator: separator)

          freeze
        end

        def perform(output, payload)
          records = array(payload[register])

          output.detail("Reading path_key: #{path_key} for #{payload[register].length} records(s)")
          output.detail("Storing read data in: #{path_key}")

          payload[register] = records.map.with_index(1) do |object, index|
            load_data(object, index, output)
          end
        end

        private

        def assert_and_skip_missing_path?(path, index, output)
          missing_path            = path.to_s.empty?
          blank_path_raises_error = !ignore_blank_path

          if missing_path && blank_path_raises_error
            output.detail("Record #{index} is missing a path, raising error")

            raise ArgumentError, "Record #{index} is missing a path"
          elsif missing_path
            output.detail("Record #{index} is missing a path")

            true
          end
        end

        def assert_and_skip_file_not_found?(path, index, output)
          does_not_exist              = !disk.exist?(path)
          file_not_found_raises_error = !ignore_file_not_found

          if file_not_found_raises_error && does_not_exist
            output.detail("Record #{index} path: '#{path}' does not exist, raising error")

            raise FileNotFoundError, "#{path} does not exist"
          elsif does_not_exist
            output.detail("Record #{index} path: '#{path}' does not exist, skipping")

            true
          end
        end

        def load_data(object, index, output)
          path = resolver.get(object, path_key)

          return object if assert_and_skip_missing_path?(path, index, output)
          return object if assert_and_skip_file_not_found?(path, index, output)

          data = disk.read(path, binary: binary)

          resolver.set(object, data_key, data)

          object
        end
      end
    end
  end
end
