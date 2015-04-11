class Admin::BrandsTruckController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  def index
    @brands = BrandTruck.all
  end

  def show

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
