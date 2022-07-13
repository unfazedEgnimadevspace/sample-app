class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :followers, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
def show
 
  @user = User.find(params[:id])
  redirect_to root_url and return unless @user.activated?
  @microposts = @user.microposts.paginate(page: params[:page])

end 
def index
  @users = User.where(activated: true).paginate(page: params[:page])
  end
  

def new
  @user = User.new
end
def create
  @user = User.new(user_params)
  if @user.save
    @user.send_activation_email
    flash[:success] = "Please Check your email to activate your account"
    redirect_to root_url
  else
    render 'new'
  end
end
 
def edit
  @user = User.find(params[:id])

end
def destroy
  User.find(params[:id]).destroy
  flash[:success] = "User  deleted sucessfully"
  redirect_to users_path
end




def update
 @user = User.find(params[:id])
 if @user.update(user_params)
  flash[:success] = "Profile Updated"
  redirect_to @user
 else
  render 'edit'
 end
end




def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless current_user?(@user)
end

def admin_user
  redirect_to(root_url) unless current_user.admin?
end
def following
  @title = "Following"
  @user = User.find_by(id: params[:id])
  @users = @user.following
  render 'show_follow'
end
  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers
    render 'show_follow'
  end


 private
   def user_params
     params.require(:user).permit(:name,:email, :password, :password_confirmation)
   end
end
    