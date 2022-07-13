require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:archer)
  end
  test 'get layout links for non-logged in users' do
    get root_path
    assert_template 'static_pages/home'
    assert_select  "a[href=?]" , root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path    
    get contact_path
    assert_select 'title', full_title('Contact')
  end
  test 'full title helper'  do
    assert_equal full_title,      'Ruby on Rails Tutorial Sample App'
    assert_equal full_title("Help"), 'Help | Ruby on Rails Tutorial Sample App'
  end
 
   test "Layout links for logged in users" do
    get login_path
    assert_template "sessions/new"
    log_in_as(@user)
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", "#", text: "Account"
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", logout_path  
     end

end
