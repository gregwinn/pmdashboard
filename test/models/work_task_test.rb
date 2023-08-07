require "test_helper"

class WorkTaskTest < ActiveSupport::TestCase
  def setup
    @work_task = work_tasks(:one)
    @sub_task = work_tasks(:two)
  end

  test "should be valid" do
    assert @work_task.valid?
  end

  test "title should be present" do
    @work_task.title = nil
    assert_not @work_task.valid?
  end

  test "description should be present" do
    @work_task.description = nil
    assert_not @work_task.valid?
  end

  test "due date should not be in the past" do
    @work_task.due_date = Date.yesterday
    assert_not @work_task.valid?
  end

  test "should return true when task has subtasks" do
    assert @work_task.has_subtasks?
  end

  test "should return true when task has a parent" do
    assert @sub_task.has_parent?
  end

end
