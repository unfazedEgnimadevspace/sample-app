require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"
    assert_select "input[type=file]"
     #Invalid Submission
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: ''}}
    end
     assert_select "div#error_explanation"
     assert_select 'a[href=?]', '/?page=2'
      #Valid Submission
      content = "I love ashe shey by barry jhay"
      image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
      assert_difference "Micropost.count", 1 do
        post microposts_path, params: { micropost: { content: content, image: image}}
      end
      assert assigns(:micropost).image.attached?
      assert_redirected_to root_url
      follow_redirect!
      assert_match content,response.body

      #Destroy micropost
      assert_select "a", text: 'delete'
      first_micropost = @user.microposts.paginate(page: 1).first
      assert_difference "Micropost.count", -1 do
        delete micropost_path(first_micropost)
      end
     #No delete link in another users home page
     get users_path(users(:archer))
     assert_select "a", text: "delete", count: 0
  end
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 micropost", response.body
    #create a micropost
    content2 = "Working with ruby on rails "
    other_user.microposts.create!(content: content2)
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body

  end
end
