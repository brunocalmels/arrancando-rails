require "spec_helper"
require "rails_helper"
require "rake"

describe "scheduled maintenance tasks" do
  let(:destroy_old_notifications) do
    Rake.application.invoke_task "scheduled_maintenance:destroy_old_notifications"
  end

  let(:destroy_old_chat_messages) do
    Rake.application.invoke_task "scheduled_maintenance:destroy_old_chat_messages"
  end

  let(:perform_all_tasks) do
    Rake.application.invoke_task "scheduled_maintenance:all"
  end

  before do
    Rake.application.rake_require "tasks/scheduled_maintenance"
    Rake::Task.define_task(:environment)
  end

  context "when performing maintenance tasks" do
    it "removes old notifications" do
      5.times do
        FactoryBot.create(:notificacion)
      end
      Notificacion.take(2).each do |notif|
        notif.update created_at: Time.zone.now - 3.months - 1.day
      end
      expect do
        destroy_old_notifications
      end.to change(Notificacion, :count).by(-2)
    end

    it "removes old chat messages" do
      5.times do
        FactoryBot.create(:mensaje_chat)
      end
      MensajeChat.take(2).each do |msje|
        msje.update created_at: Time.zone.now - 3.months - 1.day
      end
      expect do
        destroy_old_chat_messages
      end.to change(MensajeChat, :count).by(-2)
    end
  end
end
