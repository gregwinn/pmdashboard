class Task < ApplicationRecord
  belongs_to :user, :project
  belongs_to :parent, class_name: "Task", optional: true
  has_many :subtasks, class_name: "Task", foreign_key: "parent_id", dependent: :destroy
end
