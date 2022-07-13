require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  test "should get new" do
    get signup_path
    assert_response :success
  end
  test "should redirect to login when trying to edit without been logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  test 'should redirect to login_path when trying to update without being logged in ' do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  test ' should redirect user to root_path when trying to edit if logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  test 'should redirect user to root_path when trying to update if logged as wrong user 'do
    log_in_as(@other_user)
    patch  user_path(@user), params: { user: { name: @user.name, email: @user.email}}
    assert flash.empty?
    assert_redirected_to root_url
  end
  test 'redirected to home page when trying to access the home page without being logged in' do
    get users_path
    assert_redirected_to login_url
  end
  test "The admin attributes is not editable through the web " do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {user: {password: 'password', password_confirmation: 'password', admin: true}}
    assert_not @other_user.reload.admin?
  end
  test "Should redirect to login url when trying to delete without been logged in" do
    assert_no_difference 'User.count'do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  test 'Should redirect destroy when trying to delete as a non-admin user' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  test "Should redirect following when not logged in " do
    get following_user_path(@user)
    assert_redirected_to login_url
  end
  test "Should redirect followers when not logged in "do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
