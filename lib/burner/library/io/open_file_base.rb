# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Burner
  module Library
    module IO
      # Common configuration/code for all IO Job subclasses that open a file.
      class OpenFileBase < JobWithRegister
        attr_reader :binary, :disk, :path

        def initialize(path:, binary: false, disk: {}, name: '', register: DEFAULT_REGISTER)
          super(name: name, register: register)

          raise ArgumentError, 'path is required' if path.to_s.empty?

          @binary = binary || false
          @disk   = Disks.make(disk)
          @path   = path.to_s

          freeze
        end
      end
    end
  end
end
