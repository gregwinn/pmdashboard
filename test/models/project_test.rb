require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  def setup
    @project = projects(:one)
  end

  test "should be valid" do
    assert @project.valid?
  end

  test "name should be present" do
    @project.title = nil
    assert_not @project.valid?
  end

  test "description should be present" do
    @project.description = nil
    assert_not @project.valid?
  end

  test "due date should not be in the past" do
    @project.due_date = Date.yesterday
    assert_not @project.valid?
  end

  test "should have tasks" do
    assert @project.work_tasks.any?
  end

end
