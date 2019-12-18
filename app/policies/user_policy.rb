class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

    def rol_
      resolve
    end

    def rol_admin
      User.admins
    end

    def rol_normal
      User.normales
    end
  end

  def update?
    record == user || user.admin?
  end
end
