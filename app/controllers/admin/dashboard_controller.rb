class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  layout  'admin/layouts/application'
  def index

    @trucks = Truck.all.count
    @extras = Extra.all.count
  end


  def updatestate

    if(params[:type] == 'service')
      @item = Service.find(params[:iditem])
      if(params[:idstate] == '0')
        @item.state = 1
      else
        @item.state = 0
      end
      if @item.save
        redirect_to admin_services_path
      end
    end



    if(params[:type] == 'truck')
      @item = Truck.find(params[:iditem])
      if(params[:idstate] == '0')
        @item.state = 1
      else
        @item.state = 0
      end
      if @item.save
        redirect_to admin_truck_path
      end
    end



    if(params[:type] == 'extra')
      @item = Extra.find(params[:iditem])
      if(params[:idstate] == '0')
        @item.state = 1
      else
        @item.state = 0
      end
      if @item.save
        redirect_to admin_extras_path
      end
    end

  end
end
