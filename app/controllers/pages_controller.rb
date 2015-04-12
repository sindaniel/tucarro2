class PagesController < ApplicationController
  layout 'index', :only => [ :index ]
  def index

    @types = TypeTruck.all
  end


  def getbrands

    if params[:id] == '0'
      @brands = BrandTruck.all
    else
      @brands = Truck.where(type_truck_id: params[:id])
      #@brands = BrandTruck.where(type_truck_id: params[:id]).all
    end


    render json: @brands, :include =>[:brand_truck]
  end



  def camiones

    @types = TypeTruck.all
    @p = params


    if(params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)
      @trucks = Truck.all.page(params[:page])
    end


    #busqueda de un parametro
    if(!params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)

        if TypeTruck.where(link_rewrite: params[:param1]).exists?
          types = TypeTruck.find_by_link_rewrite(params[:param1])
          @trucks = Truck.where(type_truck_id: types.id).all.page(params[:page])
        end


        if BrandTruck.where(link_rewrite: params[:param1]).exists?
          brand = BrandTruck.find_by_link_rewrite(params[:param1])
          @trucks = Truck.where(brand_truck_id: brand.id).all.page(params[:page])
        end


        if State.where(link_rewrite: params[:param1]).exists?
          state = State.find_by_link_rewrite(params[:param1])
          @trucks = Truck.where(state_id: state.id).all.page(params[:page])
        end

    end




    #busqueda de dos parametro
    if(!params[:param1].nil? && !params[:param2].nil? && params[:param3].nil?)
      @p1 = nil
      @p2 = nil


      if TypeTruck.where(link_rewrite: params[:param1]).exists?
        @p1 = 'type'
      end


      if BrandTruck.where(link_rewrite: params[:param1]).exists?
        @p1 = 'brand'
      end


      if State.where(link_rewrite: params[:param1]).exists?
        @p1 = 'state'
      end


      if TypeTruck.where(link_rewrite: params[:param2]).exists?
        @p2 = 'type'
      end


      if BrandTruck.where(link_rewrite: params[:param2]).exists?
        @p2 = 'brand'
      end


      if State.where(link_rewrite: params[:param2]).exists?
        @p2 = 'state'
      end



      if @p1 == 'type' &&  @p2 == 'brand'
        type = TypeTruck.find_by_link_rewrite(params[:param1])
        brand = BrandTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, brand_truck_id: brand.id).all.page(params[:page])
      end


      if @p1 == 'brand' &&  @p2 == 'type'
        brand = BrandTruck.find_by_link_rewrite(params[:param1])
        type = TypeTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, brand_truck_id: brand.id).all.page(params[:page])
      end

      if @p1 == 'type' &&  @p2 == 'state'
        type = TypeTruck.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, state_id: state.id).all.page(params[:page])
      end


      if @p1 == 'state' &&  @p2 == 'type'
        state = State.find_by_link_rewrite(params[:param1])
        type = TypeTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, state_id: state.id).all.page(params[:page])
      end

      if @p1 == 'state' &&  @p2 == 'brand'
        state = State.find_by_link_rewrite(params[:param1])
        brand = BrandTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(brand_truck_id: brand.id, state_id: state.id).all.page(params[:page])
      end


      if @p1 == 'brand' &&  @p2 == 'state'
        brand = BrandTruck.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(brand_truck_id: brand.id, state_id: state.id).all.page(params[:page])
      end



    end



    if(!params[:param1].nil? && !params[:param2].nil? && !params[:param3].nil?)

      brand = BrandTruck.find_by_link_rewrite(params[:param3])
      state = State.find_by_link_rewrite(params[:param1])
      type = TypeTruck.find_by_link_rewrite(params[:param2])

      if !brand.nil? && !state.nil? && !type.nil?
        @trucks = Truck.where(brand_truck_id: brand.id, state_id: state.id, type_truck_id: type.id).all.page(params[:page])
      end



    end




  end



  def camion
    @truck = Truck.find_by_id(params[:id])
  end
end
