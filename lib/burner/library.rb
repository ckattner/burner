# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'job_with_register'

require_relative 'library/echo'
require_relative 'library/nothing'
require_relative 'library/sleep'

require_relative 'library/collection/arrays_to_objects'
require_relative 'library/collection/coalesce'
require_relative 'library/collection/concatenate'
require_relative 'library/collection/graph'
require_relative 'library/collection/group'
require_relative 'library/collection/nested_aggregate'
require_relative 'library/collection/number'
require_relative 'library/collection/objects_to_arrays'
require_relative 'library/collection/shift'
require_relative 'library/collection/transform'
require_relative 'library/collection/unpivot'
require_relative 'library/collection/validate'
require_relative 'library/collection/values'
require_relative 'library/collection/zip'

require_relative 'library/compress/row_reader'

require_relative 'library/deserialize/csv'
require_relative 'library/deserialize/json'
require_relative 'library/deserialize/yaml'

require_relative 'library/io/exist'
require_relative 'library/io/read'
require_relative 'library/io/row_reader'
require_relative 'library/io/write'

require_relative 'library/serialize/csv'
require_relative 'library/serialize/json'
require_relative 'library/serialize/yaml'

require_relative 'library/value/copy'
require_relative 'library/value/nest'
require_relative 'library/value/static'
require_relative 'library/value/transform'
