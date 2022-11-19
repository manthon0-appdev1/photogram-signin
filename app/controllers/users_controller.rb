class UsersController < ApplicationController

  def new_session_form
    render({:template => "users/signin_form.html.erb"})
  end
  def authenticate
    un = params.fetch("input_username")
    pw = params.fetch("input_password")

    user = User.where({:username => un}).first

    if user == nil
      redirect_to("/user_sign_in", {:alert => "No one"})
    else
      if user.authenticate(pw)
        session.store(:user_id, user.id)
      redirect_to("/")
      else
        redirect_to("/user_sign_in")
      end
    end
  end
  def new_registration_form
    render({:template => "users/signup_form.html.erb"})
  end
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")
    save_status = user.save
    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", {:notice => "Welcome"})    
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def toast_cookies
    reset_session
    redirect_to("/")
  end
  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
