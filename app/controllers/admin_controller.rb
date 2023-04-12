class AdminController < ApplicationController
  def show
    @top_customers = Customer.top_five_customers
  end
end