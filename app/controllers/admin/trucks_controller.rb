class Admin::TrucksController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  add_breadcrumb 'Camiones', :admin_trucks_path, :options => { :title =>'Inicio' }



  def index
    @trucks = Truck.all
    respond_to do |format|
      format.html {}
      format.json { render json: @trucks, :include =>[:state, :type_truck, :brand_truck, :customer] }
    end


  end
  def show

  end

  def new

    @truck = Truck.new
    add_breadcrumb 'Agregar'
  end

  def create

    @truck = Truck.new(allowed_params)
    if @truck.save
      flash[:notice] = 'Información agregada correctamente'
      redirect_to admin_trucks_path
    else
      render 'new'
    end


  end

  def edit
    @truck = Truck.find(params[:id])
  end

  def update


    @truck = Truck.find(params[:id])


    if @truck.update_attributes(allowed_params)
      flash[:notice] = 'Información actualizada correctamente'
      redirect_to admin_trucks_path
    else
      render 'new'
    end


  end

  def destroy
    @truck = Truck.find(params[:id])
    if @truck.destroy
      flash[:notice] = 'Información eliminada correctamente'
      redirect_to admin_trucks_path
    else
      render 'new'
    end
  end



  def removePicture

    imagen =  params[:imagen]
    id =  params[:idTruck]

    @truck = Truck.find(id)
    @truck.instance_eval('picture'+imagen).destroy
    if @truck.save
      respuesta = [:respuesta=>true ]
    else
      respuesta = [:respuesta=>false ]
    end


    render json: respuesta




  end


  def permit!
    each_pair do |key, value|
      convert_hashes_to_parameters(key, value)
      self[key].permit! if self[key].respond_to? :permit!
    end

    @permitted = true
    self
  end


  private
  def allowed_params
    #params.require(:truck).permit(:nombre, :quintarueda)
      params.require(:truck).permit!
  end



end
