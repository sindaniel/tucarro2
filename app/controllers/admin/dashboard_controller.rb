class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  def index
  end
end
