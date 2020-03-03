namespace :users do
  desc "Calcula rankings"
  task calcular_ranking: :environment do
    users = User.all.sort_by { |u| u.puntaje * -1 }
    rank = 0
    users.each do |user|
      rank += 1
      user.update rank: rank
    end
  end
end
