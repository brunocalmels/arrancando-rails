namespace :users do
  desc "Calcula rankings historicos"
  task calcular_ranking: :environment do
    User.all.update rank: 0
    users = User.rankeables.sort_by { |u| u.puntaje * -1 }
    rank = 0
    users.each do |user|
      rank += 1
      user.update rank: rank
    end
  end

  desc "Calcula rankings mensuales"
  task calcular_ranking_mensual: :environment do
    User.all.update rank_mensual: 0
    users = User.rankeables.sort_by { |u| u.puntaje_mensual * -1 }
    # users = User.rankeables.sort_by { |u| u.puntaje_last_month * -1 }
    rank = 0
    users.each do |user|
      rank += 1
      user.update rank_mensual: rank
    end
  end
end
