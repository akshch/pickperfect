class CategoriesController < ApplicationController

  before_action :restrict_access, only: [:index1, :category_game, :category_check]


# [POST] category/game
#category related games
def category_game
  @user = User.where(contact: params[:contact]).first
    category = @user.categories
      temp = []
    category.each do |x|
      x.games.each do |game|
        temp.push(id: game.id, name: game.name, description: game.description, location: game.location, credits_required: game.credits_required, expiry: game.expiry, avatar: game.avatar_url )
      end
    end
    render json: {status: 'SUCCESS', message: 'user-games', data: temp.uniq}, status: :ok
end

  # [POST] /category/
  def index1
    category = Category.all
    temp = []
    category.each do |category|
        temp.push(id: category.id, title: category.title)
    end
    render json: {status: 'SUCCESS', message:' Categories', data:temp},status: :ok
end


#[POST] /category/check
def category_check
  if User.where(contact: params[:contact]).length > 0
   @user = User.where(contact: params[:contact]).first
    category = @user.categories
    temp = []
     category.each do |category|
      temp.push(id: category.id, title: category.title)
     end
     render json: {status: 'SUCCESS', message: '200', data:temp},status: :ok 
    else
    category = Category.all
    response = []
    category.each do |category|
      response.push(id: category.id, title: category.title)
    end
    render json: {status: 'SUCCESS', message:'100', data:response},status: :ok 
  end
end


  def index
    @categories = Category.all
    @category = Category.new
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to categories_path
  end

  def edit 
    @category = Category.find(params[:id])
  end

  def update
   @category = Category.find(params[:id])
   @category.update(category_params)
   redirect_to categories_path
  end

  def destroy
   @category = Category.find(params[:id])
   @category.destroy
   redirect_to categories_path
  end
  private

  def category_params
    params.require(:category).permit(:title)
  end

end
