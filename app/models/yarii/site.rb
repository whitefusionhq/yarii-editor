module Yarii
  class Site < ApplicationRecord
    def self.table_name_prefix
      'yarii_'
    end
  end
end
