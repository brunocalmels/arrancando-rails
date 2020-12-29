class GrupoChatsController < ApplicationController
  before_action :set_grupo_chat, only: %i[show]

  def show
    @mensajes = @grupo_chat.mensaje_chats.last_first.page(params[:page])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grupo_chat
    @grupo_chat = GrupoChat.find(params[:id])
  end
end
