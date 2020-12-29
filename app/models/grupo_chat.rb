class GrupoChat < ApplicationRecord
  has_many :mensaje_chats, dependent: :destroy, inverse_of: :grupo_chat

  validates :nombre, presence: true
  validates :simbolo, presence: true
  validates :color, presence: true
end
