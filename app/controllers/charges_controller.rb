class ChargesController < ApplicationController

  #before_action :restrict_access

  def new
  end

  #[POST] /charges
  def charges
    @amount = params[:amount] * 100

    require "stripe"
    Stripe.api_key = "sk_test_2zAoySXFkpjLn2wxGw8ujRyu"

    response = Stripe::Charge.create(
      :amount => @amount,
      :currency => "usd",
      :source => params[:tokenId],  # obtained with Stripe.js
      #:bank_address => params[:address],
      #:bank_name => params[:bank_name],
      #:bank_ifsc => params[:ifsc],
      #:routing_number => params[:routing]
    )

    # #logger.info "#{response.id}"
    @res = response.id
    if response.status == "succeeded"
      user = User.where(contact: params[:contact]).first
      if user.cridets.present?
        sum = user.cridets + @amount
        user.update(:cridets => sum)
        user.accounts.create(:amount => @amount, :response_id => @res, :transcation => DateTime.now.to_s(:db))
      else user.update(:cridets => @amount)
        user.accounts.create(:amount => @amount, :response_id => @res, :transcation => DateTime.now.to_s(:db))       end
    end
    #    [{:response_id => response[:id], :amount => response[:amount]}]
    render json: {status: "SUCCESS", message: "Payment success", data: response}, status: :ok
  end

  #[POST] bank/details
  def update_bank_details
    user = User.where(contact: params[:contact]).first
    user.update(:bank_address => params[:address], :bank_name => params[:bank_name], :bank_ifsc => params[:ifsc], :routing_number => params[:routing])
    render json: {status: "SUCCESS", message: "Bank Details Updated"}, status: :ok
  end

  def recharge
    user = User.where(contact: params[:contact]).first
    #@cat = user.accounts.first.response_id
    @amount = params[:amount] * 100
    #@charge = params[:charge]

    #   require 'stripe'
    #   Stripe.api_key = 'sk_test_2zAoySXFkpjLn2wxGw8ujRyu'

    #   refund = Stripe::Refund.create({
    #     charge: @cat
    # })

    require "stripe"
    Stripe.api_key = "sk_test_2zAoySXFkpjLn2wxGw8ujRyu"
    Stripe.api_version = "2019-02-19"

    refund = Stripe::Payout.create({
      :amount => @amount, # amount in cents
      :currency => "usd",
      #:recipient => user.id,
      #card: card_id,
      statement_descriptor: "JULY SALES",
    })

    if refund.status == "succeeded"
      minus = user.accounts.first.amount - @amount
      user.accounts.update(:amount => minus)
    end

    render json: {status: "SUCCESS", message: "Payment success", data: refund}, status: :ok
  end
end
