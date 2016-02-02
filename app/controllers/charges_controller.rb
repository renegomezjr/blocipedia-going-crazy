class ChargesController < ApplicationController
  def create
    customer = Stripe::Customer.create(
    email: current_user.email,
    card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
    customer: customer.id,
    amount: 1500,
    description: "Premium Membership - #{current_user.email}",
    currency: 'usd'
    )

    flash[:notice] = "Thanks for purchasing a Premium Membership, #{current_user.email}! Enjoy the ability to make private Wikis."
    @user = current_user
    @user.update_attributes(role: 1)
    redirect_to user_path(current_user)

  rescue Stripe::CardError => e
    flash.now[:alert] = e.message
    redirect_to new_charge_path
  end

  def new
    @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "Premium Membership - #{current_user.email}",
     amount: 1500
   }
  end

end
