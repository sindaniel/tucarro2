class PagesController < ApplicationController
  def index
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
   if !params[:camion]['type'].nil?

     @t = TypeTruck.find_by_id(params[:camion]['type'])
     nombreTipo = @t.name.downcase.gsub! ' ', '-'
     nombreTiop = I18n.transliterate(nombreTiop)
     idTipo = @t.id

   end


   if !params[:camion]['brand'].nil?

     @m = BrandTruck.find_by_id(params[:camion]['brand'])
     @nombreMarca = @m.name.downcase.gsub! ' ', '-'
     @nombreMarca = I18n.transliterate(@nombreMarca)
     idTipo = @m.id

   end



  end
end
