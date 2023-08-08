class User < ApplicationRecord
  has_many :projects
  has_many :work_tasks, foreign_key: :user_id # Tasks that this user created
  has_many :assigned_tasks, class_name: "WorkTask", foreign_key: "user_assignment_id"  # tasks assigned to this user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence:true, uniqueness: true

  # User roles
  enum role: %i[employee pm]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :employee
  end

  def full_name
    first = first_name.present? ? first_name : ""
    last = last_name.present? ? last_name : ""
    "#{first} #{last}".strip
  end

end
