class PagesController < ApplicationController
  def index

    @types = TypeTruck.all
  end


  def getbrands

    if params[:id].nil?
      @brands = BrandTruck.all
    else
      @brands = BrandTruck.where(type_truck_id: params[:id]).all
    end
    render json: @brands
  end



  def camiones

    @types = TypeTruck.all
  @p = params


  end
end
