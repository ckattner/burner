# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

def decompress(data)
  data_by_name = {}
  io           = StringIO.new(data)

  Zip::InputStream.open(io) do |zip_io|
    while (entry = zip_io.get_next_entry)
      name = entry.name
      data = zip_io.read

      data_by_name[name] = data
    end
  end

  data_by_name
end
