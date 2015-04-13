class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  def index

    @trucks = Truck.all.count
    @extras = Extra.all.count
  end
end
