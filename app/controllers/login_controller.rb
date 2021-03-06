# The login functions allow users to log in (what enables them
# to mantain a list of saved theorems), new users to registrate
# and logged users to log out.
class LoginController < ApplicationController
  before_filter :authorize, :except => [:login, :add_user]
 
  # Add a new user to the database.
  def add_user
    if request.get?
      @user = User.new
    else
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "User #{@user.name} created"
        redirect_to(:action => 'login')
      else
        flash[:notice] = "User alread exists!"
      end      
    end
  end

  # Display the login form and wait for user to
  # enter a name and password. Then it validates
  # these, adding the user object to the session,
  # if authorized.
  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login
      if logged_in_user
        session[:user_id] = logged_in_user.id
        redirect_to :controller => "proof", :action => "new"
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  # Log out by clearing the user entry in the session.
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller => "proof", :action => "new")
  end
end
