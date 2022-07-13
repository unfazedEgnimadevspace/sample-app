require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @baseurl = 'Ruby on Rails Tutorial Sample App'
  end
  test "should get root" do
    get root_path
    assert_response :success
    assert_select 'title', "Home | #{@baseurl}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select 'title', "Help | #{@baseurl}"
  end
  test "should get about page" do 
    get about_path
    assert_response :success
    assert_select 'title', "About | #{@baseurl}"
  end
  test 'Should get contact page' do
    get contact_path
    assert_response :success
    assert_select 'title',  "Contact | #{@baseurl}"
  end
end
