class Admin::ServicesController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  add_breadcrumb 'Tipo de servicio', :admin_type_service_index_path, :options => { :title =>'Inicio' }


  
  def index
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
