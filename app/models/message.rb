class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :body, presence: true, length: { maximum: 2000 }

  after_create_commit -> { broadcast_append_later_to room, target: "messages", partial: "messages/message", locals: { message: self } }
end
