FactoryBot.define do
  factory :mensaje_chat do
    grupo_chat { nil }
    user { nil }
    mensaje { "MyText" }
  end
end
