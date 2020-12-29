class MensajeChat < ApplicationRecord
  belongs_to :grupo_chat, inverse_of: :mensaje_chats
  belongs_to :user

  validates :mensaje, presence: true

  scope :last_first, -> { order(created_at: :desc) }

  paginates_per 50
end
