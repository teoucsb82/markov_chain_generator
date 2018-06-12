class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.all
  end

  def create
    @user = User.create(user_params)
    respond_with(@user)
  end

  def show
    @user = User.find(params[:id])
    @markov_chain = @user.markov_chain
    respond_with(@user)
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
