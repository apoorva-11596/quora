class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:upvote, :edit_profile, :follow]
  def profile
    @user = User.find_by_id(params[:id])
    if @user.nil?
      redirect_to root_path
    end
  end

  def upvote
    u = current_user
    a = Answer.find(params[:id])
    if user_voted a
      a.upvotees.delete(u)
      a.votes= a.votes-1
      a.save
    else
      a.upvotees << u
      a.votes= a.votes+1
      a.save
    end
    redirect_to a.question
  end

  def questions_asked user
    Question.where(user_id: user.id)
  end

  def answers_given user
    Answer.where(user_id: user.id)
  end

  def save_profile
    user = User.find(params[:user][:id])
    user.name = params[:user][:name]
    user.number = params[:user][:number]
    user.description = params[:user][:description]
    if(not params[:user][:avatar].nil?)
      user.avatar = params[:user][:avatar]
    end
    user.save
    redirect_to user_profile_path(user.id)
  end

 

  def follow
    u = User.find_by_id(params[:profile_id])
    if(not u.nil?)
      if(user_following u)
          current_user.followees.delete(u)
      else
          current_user.followees << u
      end
      current_user.save
      redirect_to user_profile_path(u)
      return
    end
    redirect_to root_path
  end

  def user_following user
    if(user.followers.find_by_id(current_user.id).nil?)
      false
    else
      true
    end
  end
  helper_method :questions_asked, :answers_given , :user_image_url , :user_following

end
