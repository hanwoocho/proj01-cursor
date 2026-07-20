class Room < ApplicationRecord
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }, allow_blank: true
end
