require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    @micropost = @user.microposts.build(content: 'Lorem Ipsum')
    end
    
  test "micropost should be valid" do
    assert @micropost.valid?
  end
  test 'micropost should invalid if there is no user id 'do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  test "content should be invalid if empty" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end
  test 'micropost content should be atleast 140 characters' do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  test 'order should be the most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
