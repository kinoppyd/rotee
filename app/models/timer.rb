class Timer < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :list
end
