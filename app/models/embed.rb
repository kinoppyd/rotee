class Embed < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :list

  KEY_GENERATOR = -> { SecureRandom.urlsafe_base64 }

  attribute :key, :string, default: KEY_GENERATOR

  def regenerate
    self.key = KEY_GENERATOR
  end
end
