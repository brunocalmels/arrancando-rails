namespace :scheduled_maintenance do
  desc "Performs all maintenance tasks"
  task all: :environment do
    Rake::Task["scheduled_maintenance:destroy_old_notifications"].invoke
    Rake::Task["scheduled_maintenance:destroy_old_chat_messages"].invoke
  end

  desc "Removes notifications older than 3 months"
  task destroy_old_notifications: :environment do
    Notificacion
      .where("created_at < ?", Time.zone.now - DB_RECORDS_LIFETIME)
      .destroy_all
  end

  desc "Removes chat messages older than 3 months"
  task destroy_old_chat_messages: :environment do
    MensajeChat
      .where("created_at < ?", Time.zone.now - DB_RECORDS_LIFETIME)
      .destroy_all
  end
end
