class User < ApplicationRecord
  has_secure_password

  has_many :messages, dependent: :destroy

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 2, maximum: 30 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "는 영문, 숫자, 밑줄만 사용할 수 있습니다" }
  validates :password, length: { minimum: 4 }, if: -> { password.present? }
end
