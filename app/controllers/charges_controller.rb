class ChargesController < ApplicationController
  require 'stripe'

  def create
    @user = current_user
    if @user.customerid.nil?
      customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken],
      plan: 1
      )
      @user.update_attributes(customerid: customer.id)
    else
      customer = Stripe::Customer.retrieve(current_user.customerid)
      customer.subscriptions.create(:plan => 1)
    end

    flash[:notice] = "Thanks for purchasing a Premium Membership, #{current_user.email}! Enjoy the ability to make private Wikis."
    @user.update_attributes(role: 1)
    redirect_to user_path(current_user)

  rescue Stripe::CardError
    flash.now[:alert] = "There was a problem. Please try again."
    redirect_to new_charge_path
  end

  def destroy
    Stripe.api_key
    customer = Stripe::Customer.retrieve(current_user.customerid)
    subscription_id = customer.subscriptions.data.first.id
    customer.subscriptions.retrieve(subscription_id).delete

    ch = Stripe::Charge.all(customer: customer.id)
    charge_id = ch.data.first.id

    re = Stripe::Refund.create(
      charge: charge_id,
      amount: 1000
      )

    @user = current_user
    @wikis = @user.wikis
    @wikis.update_all(private: false)
    @user.update_attributes(role: 0)
    redirect_to user_path(current_user)

    flash[:notice] = "You successfully downgraded your account."

  rescue Stripe::InvalidRequestError
    flash.now[:alert] = "There was a problem."
    redirect_to wiki_path
  end

  def new
    @stripe_btn_data = {
     email: current_user.email,
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership - #{current_user.email}",
     amount: 1500
   }
  end

end
