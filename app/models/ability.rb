# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can :manage, :all if user.pm?

    if user.pm?
      can :update, WorkTask do |work_task|
        work_task.project.user_id == user.id
      end
      can :create, User
    end

    if user.employee?
      can :manage, User do |u|
        u.id == user.id
      end

      can :update, WorkTask do |work_task|
        work_task.user_assignment_id == user.id
      end
      can :update, WorkTask do |work_task|
        if work_task.status_changed?
          (work_task.status == 'working' || work_task.status == 'needs_review') && work_task.user_assignment_id == user.id
        else
          work_task.user_id == user.id && work_task.status != 'done'
        end
      end
    end

  end
end
