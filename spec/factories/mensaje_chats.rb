FactoryBot.define do
  factory :mensaje_chat do
    grupo_chat do
      if GrupoChat.any?
        GrupoChat.all.sample
      else
        FactoryBot.create(:grupo_chat)
      end
    end
    user do
      if User.any?
        User.all.sample
      else
        FactoryBot.create(:user)
      end
    end
    mensaje { "MyText" }
  end
end
