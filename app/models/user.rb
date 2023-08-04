class User < ApplicationRecord
  has_many :projects

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  # User roles
  enum role: %i[employee pm]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :employee
  end

end
