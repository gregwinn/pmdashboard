require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be a valid User" do
    assert @user.valid?
  end

  test "should have a valid full name" do
    assert_equal "Michael Scott", @user.full_name
  end

  test "should have a valid role" do
    assert_equal "pm", @user.role
  end

  test "should have projects" do
    assert @user.projects.any?
  end
end
