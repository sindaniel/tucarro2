class Admin::OfferscustomersController < ApplicationController


  before_action :authenticate_user!
  layout  'admin/layouts/application'
  add_breadcrumb 'Clientes', :admin_customers_path, :options => { :title =>'Inicio' }

  def index

    @offers = Offercustomer.where(:customer_id => params[:customer_id])
    @user = Customer.find_by_id(params[:customer_id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
