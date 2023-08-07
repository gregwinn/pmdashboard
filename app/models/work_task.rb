class WorkTask < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :parent, class_name: "WorkTask", optional: true
  has_many :subtasks, class_name: "WorkTask", foreign_key: "parent_id", dependent: :destroy
  # the user to whom the task is assigned
  belongs_to :user_assignment, class_name: "User", foreign_key: "user_assignment_id", optional: true

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
  validate :due_date_cannot_be_in_the_past, on: [:create, :update]

  # Delayed job is used to check if a task is overdue
  after_create :enqueue_job
  before_update :delete_and_reenqueue_job, if: :due_date_changed?
  before_destroy :delete_job

  # Status shows the progress of a work task
  enum status: %i[not_started working needs_review done late]
  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :not_started
  end

  # Work focus is a way to categorize work tasks
  enum work_focus: %i[development design business_research marketing sales other]
  after_initialize :set_default_work_focus, if: :new_record?

  def set_default_work_focus
    self.work_focus ||= :other
  end

  # Validate that a work task due date is not in the past
  def due_date_cannot_be_in_the_past
    formatted_date = due_date.strftime("%Y-%m-%d") rescue nil
    if due_date.present? && formatted_date.to_date <= Date.today
      errors.add(:due_date, "must be greater than today")
    end
  end

  # Always order ascending by due date unless otherwise specified
  default_scope { order(due_date: :asc) }

  # Scope to find top-level tasks only AKA not subtasks
  scope :top_level, -> { where(parent_id: nil) }

  # Check to see if a task has subtasks
  def has_subtasks?
    subtasks.any?
  end

  # Check to see if a task has a parent
  def has_parent?
    parent_id.present?
  end

  # Helper to see if an employee can change the status of a
  # task to something other than "working" or "needs_review"
  def can_employee_change_status?(new_status)
    %w[working needs_review].include?(new_status)
  end

  # Create new job to check if a task is overdue
  def enqueue_job
    jid = CheckTaskJob.perform_at(due_date.to_time.to_i, id)
    update_column(:sidekiq_job_id, jid)
  end
  # Delete the old job and create a new one
  def delete_and_reenqueue_job
    delete_job
    enqueue_job
  end
  # Delete the job if it exists
  def delete_job
    Sidekiq::ScheduledSet.new.find_job(sidekiq_job_id).try(:delete) if sidekiq_job_id
  end
end
