class AccountsController < ApplicationController

  def index
    @accounts = Account.all
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    #@user = User.where(id: params[:user_id]).first
    #@user = User.find(params[:account][:user_id])
    @user = User.where(first_name: params[:account][:user_id]).first
    @new_amount = params[:account][:amount]
      @total = @user.cridets + @new_amount.to_f
        @user.update(:cridets => @total)
    @account.user_id = @user.id
    @account.save
    
    redirect_to accounts_path
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    @user = User.find(params[:account][:user_id])
      @new_amount = params[:account][:amount]
        @total = @user.cridets - @new_amount.to_f
        @user.update(:cridets => @total)
    @account.update(account_params)
    redirect_to accounts_path
  end





  private

  def account_params
   params.require(:account).permit(:amount, :user_id, :transcation, :response_id)
  end
end
