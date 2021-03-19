class User < ApplicationRecord
  validates :login,
            :provider,
            presence: true

  validates :login,
            uniqueness: true

  has_one :access_token, dependent: :destroy
end
