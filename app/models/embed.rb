class Embed < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :list
end
