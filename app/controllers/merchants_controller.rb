class MerchantsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
    @top_customers = @merchant.top_five_customers
  end
end