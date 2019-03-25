class UsersController < ApplicationController

  before_action :restrict_access, only: [:user_category_edit, :user_category, :category_user, :question_answer, :testing_image]

  require 'json'

  # [post] /user/
  def create
    if User.where(contact: params[:contact]).length > 0
      @user = User.where(contact: params[:contact]).first
      @user.access_token = SecureRandom.hex
      @user.update_attributes(user_params)
      message = 'User Updated'
    else
      @user = User.new(user_params)
      @user.access_token = SecureRandom.hex
      @user.save
      message = 'User Created'
    end
    if @user.save || @user.update_attributes(user_params)
      render json: {status: 'SUCCESS', message:message, data:@user, :methods => [:avatar_url]}, status: :ok 
    else
      render json: {status: 'ERROR', message:'User not found', data:@user.errors}, status: :unprocessable_entity
    end
  end

  # [POST] /user/category
  #creates user categories
  def user_category
    @user = User.where(contact: params[:contact]).first
      params[:category_ids].each do |category|
        @user.user_categories.create!(category_id: category, user_id: @user.id)
      end
   render json: {status: 'SUCCESS', message: 'user-data', data: 'category saved'}, status: :ok
  end
  
  # [GET] /category/user   
  #toshowuserscategories
  def category_user
    @user = User.where(contact: params[:contact]).first
    category = @user.categories
    temp = []
      category.each do |x|
      temp.push(title: x.title)
      end
    render json: {status: 'SUCCESS', message: 'user-categories', data: temp, :methods => [:avatar_url]}, status: :ok
  end
  
# [POST]  /user/category/edit
#to edit user categories
  def user_category_edit
    @user = User.where(contact: params[:contact]).first
    @user.categories.destroy_all
    params[:category_ids].each do |category|
      @user.user_categories.create!(category_id: category, user_id: @user.id)
    end
    render json: {status: 'SUCCESS', message: 'user-categories', data: 'categories updated'}, status: :ok
  end

  # [POST] /question/answer
# def question_answer
#   User.where(contact: params[:contact]).first
#  score = 0
#   params[:submitted_choices].each do |x|
#     question = Question.where(question: x[:question]).first
#      @answer = Answer.where(answer: x[:answer]).first
#        correct = question.answers.where(is_correct: true).first
#        if correct == @answer
#         score+= 1
#        end
#   end
#   render json: {status: 'SUCCESS', message: 'user-categories', data: score}, status: :ok

# end

# [POST] /question/answer
def question_answer
  user = User.where(contact: params[:contact]).first
    v = user.cridets
  game = Game.find(params[:game_id])
    @u = game.credits_required
  amount = v - @u
  user.update(cridets: amount)
  user.accounts.create(amount: amount, response_id: game.name, transcation: DateTime.now.to_s(:db) )
  @date = DateTime.now.strftime("%Q")
    params[:submitted_choices].each do |q|
      @result = Submission.create(user_id: user.id, game_id: game.id, question_id: q[:question], answer_id: q[:answer], submissionid: @date )
    end
   render json: {status: 'SUCCESS', data: "Submitted"}, status: :ok
end

#[POST] /calculate
def calculate
  answer = []
  game = Game.find(params[:game_id])
  game.question_ids.each do |ans|
    answer.push(Question.find(ans).answers.where(is_correct: true).first.id)
  end

  @winner = []


  temp = []
  
  Submission.where(game_id: game.id).each do |submitted|
    @submission_id = submitted.submissionid
    @array = []
    Submission.where(submissionid: @submission_id).each do |f|
      @array.push(f.answer_id)
    end 
    if answer.sort == @array.sort
      @winner.push(user: submitted.user_id, game: submitted.game_id)
    end 
    @array = []
  end
  render json: {status: 'SUCCESS', data: @winner.sample}, status: :ok

end


def testing_image
  #byebug
  data = ActiveSupport::JSON.decode(params[:name]).symbolize_keys
  if User.where(contact: data[:contact]).length > 0
    user = User.where(contact: data[:contact]).first
    user.update(avatar: params[:avatar])
   render json: {status: 'SUCCESS', message: 'user-categories', data: "temp", :methods => [:avatar_url]}, status: :ok
  end
end
  
  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :gender, :date_of_birth, :avatar, :contact, {category_ids: []} )
  end
end