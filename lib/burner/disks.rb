# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'disks/local'

module Burner
  # A factory to register and emit instances that conform to the Disk interface with requests
  # the instance responds to: #exist?, #read, and #write.  See an example implementation within
  # the lib/burner/disks directory.
  #
  # The benefit to this pluggable disk model is a consumer application can decide which file
  # backend to use and how to store files.  For example: an application may choose to use
  # some cloud provider with their own file store implementation.  This can be wrapped up
  # in a Disk class and registered here and then referenced in the Pipeline's IO jobs.
  class Disks
    acts_as_hashable_factory

    register 'local', '', Disks::Local
  end
end
