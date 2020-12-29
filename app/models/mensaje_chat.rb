class MensajeChat < ApplicationRecord
  belongs_to :grupo_chat, inverse_of: :mensaje_chats
  belongs_to :user

  validates :mensaje, presence: true
end
