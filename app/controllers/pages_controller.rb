class PagesController < ApplicationController
  layout 'index', :only => [ :index ]
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


    if(!params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)
        types = TypeTruck.find_by_link_rewrite(params[:param1])
        if TypeTruck.where(link_rewrite: params[:param1]).exists?
          types = TypeTruck.find_by_link_rewrite(params[:param1])
          @trucks = Truck.where(type_truck_id: types.id).all
          @p = @trucks
        end
    end
  end
end
