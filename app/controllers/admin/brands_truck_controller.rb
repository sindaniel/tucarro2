class Admin::BrandsTruckController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  add_breadcrumb 'Tipos de camion', :admin_type_truck_index_path, :options => { :title =>'Inicio' }

  def index
    @type = TypeTruck.find_by_id(params[:type_truck_id])
    @brands = BrandTruck.where(type_truck_id: params[:type_truck_id]).all

    add_breadcrumb @type.name, :admin_type_truck_brands_truck_index_path, :options => { :title =>'Inicio' }
  end


  def new



    @type = TypeTruck.find_by_id(params[:type_truck_id])
    @brand = BrandTruck.new(:type_truck_id => @type )
    add_breadcrumb @type.name, :admin_type_truck_brands_truck_index_path, :options => { :title =>'Inicio' }
    add_breadcrumb 'Agregar'
  end

  def create

    @brand = BrandTruck.new(allowed_params)
    @brand.type_truck_id = params[:type_truck_id]
    if @brand.save
      flash[:notice] = 'Información agregada correctamente'
      redirect_to admin_type_truck_brands_truck_index_path
    else
      render 'new'
    end


  end

  def edit
    @type = TypeTruck.find_by_id(params[:type_truck_id])
    @brand = BrandTruck.find(params[:id])
    add_breadcrumb @type.name, :admin_type_truck_brands_truck_index_path, :options => { :title =>'Inicio' }
    add_breadcrumb 'Editar'
  end

  def update

    @brand = BrandTruck.find(params[:id])

    if @brand.update_attributes(allowed_params)
      flash[:notice] = 'Información actualizada correctamente'
      redirect_to admin_type_truck_brands_truck_index_path
    else
      render 'new'
    end


  end

  def destroy

    @brand = BrandTruck.find(params[:id])
    if @brand.destroy
      flash[:notice] = 'Información eliminada correctamente'
      redirect_to admin_type_truck_brands_truck_index_path
    else
      render 'new'
    end


  end

  private
  def allowed_params
    params.require(:brand_truck).permit(:name)
  end
end
