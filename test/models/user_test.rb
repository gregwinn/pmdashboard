require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be a valid User" do
    assert @user.valid?
  end
end
