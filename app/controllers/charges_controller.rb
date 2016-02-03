class ChargesController < ApplicationController
  require 'stripe'

  def create

    customer = Stripe::Customer.create(
    email: current_user.email,
    card: params[:stripeToken],
    plan: 1
    )

    flash[:notice] = "Thanks for purchasing a Premium Membership, #{current_user.email}! Enjoy the ability to make private Wikis."
    @user = current_user
    @user.update_attributes(role: 1)
    redirect_to user_path(current_user)

  rescue Stripe::CardError => e
    flash.now[:alert] = e.message
    redirect_to new_charge_path
  end

  def downgrade
    customer = Stripe::Customer.retrieve(current_user.email)
    subscription_id = customer.subscriptions.data.first.id
    customer.subscriptions.retrieve(subscription_id).delete
    user.update_attributes(role: 0)
    redirect_to user_path(current_user)

    flash[:notice] = "You successfully downgraded your account."

  rescue Stripe::InvalidRequestError => e
    flash.now[:alert] = e.message
    redirect_to edit_user_registration_path(current_user)
  end

  def new
    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership - #{current_user.email}",
     amount: 1500
   }
  end

end
