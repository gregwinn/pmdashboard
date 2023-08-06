class Project < ApplicationRecord
  belongs_to :user
  has_many :work_tasks, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
  validate :due_date_cannot_be_in_the_past, on: [:create, :update]

  def due_date_cannot_be_in_the_past
    formatted_date = due_date.strftime("%Y-%m-%d") rescue nil
    if due_date.present? && formatted_date.to_date <= Date.today
      errors.add(:due_date, "must be greater than today")
    end
  end
end
