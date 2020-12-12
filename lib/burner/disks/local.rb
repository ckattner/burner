# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  class Disks
    # Operations against the local file system.
    class Local
      acts_as_hashable

      # Check to see if the passed in path exists within the local file system.
      # It will not make assumptions on what the 'file' is, only that it is recognized
      # by Ruby's File class.
      def exist?(path)
        File.exist?(path)
      end

      # Open and read the contents of a local file.  If binary is passed in as true then the file
      # will be opened in binary mode.
      def read(path, binary: false)
        File.open(path, read_mode(binary), &:read)
      end

      # Open and write the specified data to a local file.  If binary is passed in as true then
      # the file will be opened in binary mode.  It is important to note that if the file's
      # directory structure will be automatically created if it does not exist.
      def write(path, data, binary: false)
        ensure_directory_exists(path)

        File.open(path, write_mode(binary)) { |io| io.write(data) }

        path
      end

      private

      def ensure_directory_exists(path)
        dirname = File.dirname(path)

        return if File.exist?(dirname)

        FileUtils.mkdir_p(dirname)

        nil
      end

      def write_mode(binary)
        binary ? 'wb' : 'w'
      end

      def read_mode(binary)
        binary ? 'rb' : 'r'
      end
    end
  end
end
