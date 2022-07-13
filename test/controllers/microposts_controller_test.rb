require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end
  test 'should redirect to login url when trying to create micropost without being logged in' do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: 'Lorem ipsum'}}
    end
    assert_redirected_to login_url
  end

  test "should redirect to login url when trying to delete micropost without being logged in " do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  test 'should redirect destroy for wrong users'do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
