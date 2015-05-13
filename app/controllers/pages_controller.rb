class PagesController < ApplicationController
  layout 'index', :only => [ :index ]


  def index

    @types = TypeTruck.all

  end


  def getbrands

    if params[:id] == '0'
      #@brands = BrandTruck.all
      #render json: @brands

      @brands = BrandTruck.all
      render json: @brands

    else
      @brands = Truck.where(type_truck_id: params[:id]).group(:brand_truck_id)
      render json: @brands, :include =>[:brand_truck]
      #@brands = BrandTruck.where(type_truck_id: params[:id]).all
    end



  end



  def getbrandsextra

    if params[:id] == '0'
      #@brands = BrandTruck.all
      #render json: @brands

      @brands = BrandExtra.all
      render json: @brands

    else
      @brands = Extra.where(type_truck_id: params[:id]).group(:brand_extra_id)
      render json: @brands, :include =>[:brand_extra]
      #@brands = BrandTruck.where(type_truck_id: params[:id]).all
    end



  end

  def repuesto
    @extra = Extra.find_by_id(params[:id])
  end




  def repuestos


    if(params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)
      @extras = Extra.all.where(active: 1).page(params[:page])
    end



    #busqueda de un parametro
    if(!params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)

      if TypeTruck.where(link_rewrite: params[:param1]).exists?
        types = TypeTruck.find_by_link_rewrite(params[:param1])
        @extras = Extra.where(type_truck_id: types.id, active: 1).all.page(params[:page])
      end


      if BrandExtra.where(link_rewrite: params[:param1]).exists?
        brand = BrandExtra.find_by_link_rewrite(params[:param1])
        @extras = Extra.where(brand_extra_id: brand.id, active: 1).all.page(params[:page])
      end


      if State.where(link_rewrite: params[:param1]).exists?
        state = State.find_by_link_rewrite(params[:param1])
        @extras = Extra.where(state_id: state.id, active: 1).all.page(params[:page])
      end

    end





    #busqueda de dos parametro
    if(!params[:param1].nil? && !params[:param2].nil? && params[:param3].nil?)
      @p1 = nil
      @p2 = nil


      if TypeTruck.where(link_rewrite: params[:param1]).exists?
        @p1 = 'type'
      end


      if BrandExtra.where(link_rewrite: params[:param1]).exists?
        @p1 = 'brand'
      end


      if State.where(link_rewrite: params[:param1]).exists?
        @p1 = 'state'
      end


      if TypeTruck.where(link_rewrite: params[:param2]).exists?
        @p2 = 'type'
      end


      if BrandExtra.where(link_rewrite: params[:param2]).exists?
        @p2 = 'brand'
      end


      if State.where(link_rewrite: params[:param2]).exists?
        @p2 = 'state'
      end



      if @p1 == 'type' &&  @p2 == 'brand'
        type = TypeTruck.find_by_link_rewrite(params[:param1])
        brand = BrandExtra.find_by_link_rewrite(params[:param2])
        @extras = Extra.where(type_truck_id: type.id, brand_extra_id: brand.id, active: 1).all.page(params[:page])
      end


      if @p1 == 'brand' &&  @p2 == 'type'
        brand = BrandExtra.find_by_link_rewrite(params[:param1])
        type = TypeTruck.find_by_link_rewrite(params[:param2])
        @extras = Extra.where(type_truck_id: type.id, brand_extra_id: brand.id, active: 1).all.page(params[:page])
      end

      if @p1 == 'type' &&  @p2 == 'state'
        type = TypeTruck.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @extras = Extra.where(type_truck_id: type.id, state_id: state.id, active: 1).all.page(params[:page])
      end


      if @p1 == 'state' &&  @p2 == 'type'
        state = State.find_by_link_rewrite(params[:param1])
        type = TypeTruck.find_by_link_rewrite(params[:param2])
        @extras = Extra.where(type_truck_id: type.id, state_id: state.id, active: 1).all.page(params[:page])
      end

      if @p1 == 'state' &&  @p2 == 'brand'
        state = State.find_by_link_rewrite(params[:param1])
        brand = BrandExtra.find_by_link_rewrite(params[:param2])
        @extras = Extra.where(brand_extra_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])
      end


      if @p1 == 'brand' &&  @p2 == 'state'
        brand = BrandExtra.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @extras = Extra.where(brand_extra_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])
      end



    end





#con tres parametros repuesto
    if(!params[:param1].nil? && !params[:param2].nil? && !params[:param3].nil?)


      state = State.find_by_link_rewrite(params[:param1])
      type = TypeTruck.find_by_link_rewrite(params[:param2])
      brand = BrandExtra.find_by_link_rewrite(params[:param3])

      if !brand.nil? && !state.nil? && !type.nil?
        @extras = Extra.where(brand_extra_id: brand.id, state_id: state.id, type_truck_id: type.id, active: 1).all.page(params[:page])
      end




    end



  end





  def camiones

    #@types = TypeTruck.all
    #@p = params
    @fullbBase = 'http://104.131.26.112:3000'+request.fullpath
    @queryModelos = []
    @queryStates = []
    @queryTrucks = []
    @parametroPrincipal = false
    @muestroEstado = true
    @muestroMarca = true
    @mostrarKm = true
    @mostrarEstado = true
    @mostrarPlaca = true
    @mostrarPrice  = true




    if(params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)





      @trucks = Truck.all.where(active: 1).page(params[:page])


      @modelos = Truck.
          select('modelo, count(modelo) as total').
          group('modelo').
          order('modelo DESC')



      @estado = Truck.
          select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado')




      @km = Truck.
          select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5')




      @states = Truck.
          joins(:state).
          select('name, count(name) as total, states.link_rewrite').
          group('name').
          order('name DESC')



      @statesPlaca = Truck.
          joins('join states on states.id = trucks.placa_state_id',).
          select('name, count(name) as total, states.link_rewrite').
          group('name').
          order('name DESC')




      @brands = Truck.
          joins(:brand_truck).
          select('name, count(name) as total, brand_trucks.link_rewrite').
          group('name').
          order('name DESC')




    end


    #busqueda de un parametro
    if(!params[:param1].nil? && params[:param2].nil? && params[:param3].nil?)




      params[:param1current] =  params[:param1]

      if params[:param1current].include? '_'
        @url =  params[:param1current].split('_')

        params[:param1] =  @url[0]

        if @url.index('modelo')

          valor = @url[@url.index('modelo')+1]
          @queryModelos.push(['modelo', valor])
          @queryTrucks.push(['modelo',valor])
        end

      end




      if params[:param1current].include? '_'
        @url =  params[:param1current].split('_')

        params[:param1] =  @url[0]

        if @url.index('estado')
          @mostrarEstado = false
          valor = @url[@url.index('estado')+1]
          @queryModelos.push(['estado', valor])
          @queryTrucks.push(['estado',valor])
        end

      end



      if params[:param1current].include? '_'
        @url =  params[:param1current].split('_')

        params[:param1] =  @url[0]

        if @url.index('placa')
          @mostrarPlaca  = false
          valor = @url[@url.index('placa')+1]
          @queryModelos.push(['placa', valor])
          @queryTrucks.push(['placa',valor])

        end

      end




      if params[:param1current].include? '_'
        @url =  params[:param1current].split('_')

        params[:param1] =  @url[0]

        if @url.index('precio')
          @mostrarPrice  = false
          valor = @url[@url.index('precio')+1]
          @queryModelos.push(['precio', valor])
          @queryTrucks.push(['precio',valor])

        end

      end






      if params[:param1current].include? '_'

        @url =  params[:param1current].split('_')

        params[:param1] =  @url[0]

        if @url.index('kilometraje')
          @mostrarKm = false

          valor = @url[@url.index('kilometraje')+1]


         if (valor.to_i == 0)
               @queryModelos.push(['kilometraje', '0'])
               @queryTrucks.push(['kilometraje','0'])

         else  if(valor.to_i > 0 && valor.to_i < 100001)

                valores = valor.split('-')

                valor = '-kilometraje-'+valores[0]+'-kilometraje-'+valores[1]

                @queryModelos.push(['kilometraje', valor])
                @queryTrucks.push(['kilometraje',valor])
            else if (valor.to_i >= 100001)

                   @queryModelos.push(['kilometraje', '100001'])
                   @queryTrucks.push(['kilometraje','100001'])

                      end
            end
          end




        end

      end




        @trucks = Truck.where(toSql(@queryTrucks)).all.page(params[:page])


        if TypeTruck.where(link_rewrite: params[:param1]).exists?
          @parametroPrincipal = true
          types = TypeTruck.find_by_link_rewrite(params[:param1])

          @queryTrucks.push(['type_truck_id', types.id])
          @trucks = Truck.where(toSql(@queryTrucks)).all.page(params[:page])


          @queryModelos.push (['type_truck_id', types.id])



        end


        if BrandTruck.where(link_rewrite: params[:param1]).exists?
          @parametroPrincipal = true
          @muestroMarca = false
          brand = BrandTruck.find_by_link_rewrite(params[:param1])
          @queryTrucks.push(['brand_truck_id', brand.id])
          @trucks = Truck.where(toSql(@queryTrucks)).all.page(params[:page])


          @queryModelos.push (['brand_truck_id', brand.id])



        end


        if State.where(link_rewrite: params[:param1]).exists?
          state = State.find_by_link_rewrite(params[:param1])
          @parametroPrincipal = true
          @muestroEstado = false

          @queryTrucks.push(['state_id', state.id])
          @trucks = Truck.where(toSql(@queryTrucks)).all.page(params[:page])


          @queryModelos.push (['state_id', state.id])

        end



        @modelos = Truck.
            where(toSql(@queryModelos)).
            select('modelo, count(modelo) as total').
            group('modelo').
            order('modelo DESC')


        @states = Truck.
            joins(:state).
            where(toSql(@queryModelos)).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC')



      @brands = Truck.
          joins(:brand_truck).
          where(toSql(@queryModelos)).
          select('name, count(name) as total, brand_trucks.link_rewrite').
          group('name').
          order('name DESC')



      @km = Truck.
          select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
          where(toSql(@queryModelos))


      @estado = Truck.
          select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
          where(toSql(@queryModelos))


      @statesPlaca = Truck.
          joins('join states on states.id = trucks.placa_state_id',).
          select('name, count(name) as total, states.link_rewrite').
          group('name').
          order('name DESC').
          where(toSql(@queryModelos))






    end




    #busqueda de dos parametro
    if(!params[:param1].nil? && !params[:param2].nil? && params[:param3].nil?)
      @p1 = nil
      @p2 = nil
      @queryTrucks = []


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









      if @p1.include? 'type' and   @p1.include? 'type'


        puts params[:param2]

        type = TypeTruck.find_by_link_rewrite(params[:param1])
        brand = BrandTruck.find_by_link_rewrite(params[:param2].split('_')[0])


        ##nuevo##
        @queryTrucks.push(['type_truck_id', type.id])
        @queryTrucks.push(['brand_truck_id', brand.id])



        params[:param1current] =  params[:param2]


        if params[:param1current].include? '_'

          @url =  params[:param1current].split('_')

          params[:param2] =  @url[0]

          if @url.index('modelo')
            puts 'entro'
            valor = @url[@url.index('modelo')+1]
            @queryModelos.push(['modelo', valor])
            @queryTrucks.push(['modelo',valor])

          end
        else
          puts 'no entro'
        end








        @trucks = Truck.where(toSql(@queryTrucks)).all.page(params[:page])



        ##fin##



        @modelos = Truck.
            select('modelo, count(modelo) as total').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).
            group('modelo').
            order('modelo DESC')



        @estado = Truck.
            select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1)




        @km = Truck.
            select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1)




        @states = Truck.
            joins(:state).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1)



        @statesPlaca = Truck.
            joins('join states on states.id = trucks.placa_state_id',).
            select('name, count(name) as total, states.link_rewrite').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).
            group('name').
            order('name DESC')




        @brands = Truck.
            joins(:brand_truck).
            select('name, count(name) as total, brand_trucks.link_rewrite').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).
            group('name').
            order('name DESC')




      end


      if @p1 == 'brand' &&  @p2 == 'type'
        brand = BrandTruck.find_by_link_rewrite(params[:param1])
        type = TypeTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).all.page(params[:page])



        @modelos = Truck.
            select('modelo, count(modelo) as total').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).
            group('modelo').
            order('modelo DESC')



        @estado = Truck.
            select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1)




        @km = Truck.
            select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1)




        @states = Truck.
            joins(:state).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1)



        @statesPlaca = Truck.
            joins('join states on states.id = trucks.placa_state_id',).
            select('name, count(name) as total, states.link_rewrite').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).
            group('name').
            order('name DESC')




        @brands = Truck.
            joins(:brand_truck).
            select('name, count(name) as total, brand_trucks.link_rewrite').
            where(type_truck_id: type.id, brand_truck_id: brand.id, active: 1).
            group('name').
            order('name DESC')



      end

      if @p1 == 'type' &&  @p2 == 'state'
        type = TypeTruck.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, state_id: state.id, active: 1).all.page(params[:page])






        @modelos = Truck.
            select('modelo, count(modelo) as total').
            where(type_truck_id: type.id, state_id: state.id, active: 1).
            group('modelo').
            order('modelo DESC')



        @estado = Truck.
            select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
            where(type_truck_id: type.id, state_id: state.id, active: 1)




        @km = Truck.
            select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
            where(type_truck_id: type.id, state_id: state.id, active: 1)




        @states = Truck.
            joins(:state).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC').
            where(type_truck_id: type.id, state_id: state.id, active: 1)



        @statesPlaca = Truck.
            joins('join states on states.id = trucks.placa_state_id',).
            select('name, count(name) as total, states.link_rewrite').
            where(type_truck_id: type.id, state_id: state.id, active: 1).
            group('name').
            order('name DESC')




        @brands = Truck.
            joins(:brand_truck).
            select('name, count(name) as total, brand_trucks.link_rewrite').
            where(type_truck_id: type.id, state_id: state.id, active: 1).
            group('name').
            order('name DESC')




      end


      if @p1 == 'state' &&  @p2 == 'type'
        state = State.find_by_link_rewrite(params[:param1])
        type = TypeTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(type_truck_id: type.id, state_id: state.id, active: 1).all.page(params[:page])


        @modelos = Truck.
            select('modelo, count(modelo) as total').
            where(type_truck_id: type.id, state_id: state.id, active: 1).
            group('modelo').
            order('modelo DESC')



        @estado = Truck.
            select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
            where(type_truck_id: type.id, state_id: state.id, active: 1)




        @km = Truck.
            select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
            where(type_truck_id: type.id, state_id: state.id, active: 1)




        @states = Truck.
            joins(:state).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC').
            where(type_truck_id: type.id, state_id: state.id, active: 1)



        @statesPlaca = Truck.
            joins('join states on states.id = trucks.placa_state_id',).
            select('name, count(name) as total, states.link_rewrite').
            where(type_truck_id: type.id, state_id: state.id, active: 1).
            group('name').
            order('name DESC')




        @brands = Truck.
            joins(:brand_truck).
            select('name, count(name) as total, brand_trucks.link_rewrite').
            where(type_truck_id: type.id, state_id: state.id, active: 1).
            group('name').
            order('name DESC')


      end

      if @p1 == 'state' &&  @p2 == 'brand'
        state = State.find_by_link_rewrite(params[:param1])
        brand = BrandTruck.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])





        @modelos = Truck.
            select('modelo, count(modelo) as total').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page]).
            group('modelo').
            order('modelo DESC')



        @estado = Truck.
            select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])




        @km = Truck.
            select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])




        @states = Truck.
            joins(:state).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])



        @statesPlaca = Truck.
            joins('join states on states.id = trucks.placa_state_id',).
            select('name, count(name) as total, states.link_rewrite').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page]).
            group('name').
            order('name DESC')




        @brands = Truck.
            joins(:brand_truck).
            select('name, count(name) as total, brand_trucks.link_rewrite').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page]).
            group('name').
            order('name DESC')




      end


      if @p1 == 'brand' &&  @p2 == 'state'
        brand = BrandTruck.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @trucks = Truck.where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])



        @modelos = Truck.
            select('modelo, count(modelo) as total').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page]).
            group('modelo').
            order('modelo DESC')



        @estado = Truck.
            select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])




        @km = Truck.
            select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])




        @states = Truck.
            joins(:state).
            select('name, count(name) as total, states.link_rewrite').
            group('name').
            order('name DESC').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page])



        @statesPlaca = Truck.
            joins('join states on states.id = trucks.placa_state_id',).
            select('name, count(name) as total, states.link_rewrite').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page]).
            group('name').
            order('name DESC')




        @brands = Truck.
            joins(:brand_truck).
            select('name, count(name) as total, brand_trucks.link_rewrite').
            where(brand_truck_id: brand.id, state_id: state.id, active: 1).all.page(params[:page]).
            group('name').
            order('name DESC')



      end






      @modelos = Truck.
          where(toSql(@queryModelos)).
          select('modelo, count(modelo) as total').
          group('modelo').
          order('modelo DESC')


      @states = Truck.
          joins(:state).
          where(toSql(@queryModelos)).
          select('name, count(name) as total, states.link_rewrite').
          group('name').
          order('name DESC')



      @brands = Truck.
          joins(:brand_truck).
          where(toSql(@queryModelos)).
          select('name, count(name) as total, brand_trucks.link_rewrite').
          group('name').
          order('name DESC')



      @km = Truck.
          select('
          SUM(CASE WHEN kilometraje = 0 THEN 1 ELSE 0 END) AS price_range_1,
SUM(CASE WHEN kilometraje >= 1 and kilometraje <=25000 THEN 1 ELSE 0 END) AS price_range_2,
SUM(CASE WHEN kilometraje >= 25001 and kilometraje <=50000 THEN 1 ELSE 0 END) AS price_range_3,
SUM(CASE WHEN kilometraje >= 50001 and kilometraje <=100000 THEN 1 ELSE 0 END) AS price_range_4,
SUM(CASE WHEN kilometraje >100000 THEN 1 ELSE 0 END) AS price_range_5').
          where(toSql(@queryModelos))


      @estado = Truck.
          select('
          SUM(CASE WHEN estado = 0 THEN 1 ELSE 0 END) AS nuevo,
          SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS usado').
          where(toSql(@queryModelos))


      @statesPlaca = Truck.
          joins('join states on states.id = trucks.placa_state_id',).
          select('name, count(name) as total, states.link_rewrite').
          group('name').
          order('name DESC').
          where(toSql(@queryModelos))






    end





    #tres
    if(!params[:param1].nil? && !params[:param2].nil? && !params[:param3].nil?)

      brand = BrandTruck.find_by_link_rewrite(params[:param3])
      state = State.find_by_link_rewrite(params[:param1])
      type = TypeTruck.find_by_link_rewrite(params[:param2])

      if !brand.nil? && !state.nil? && !type.nil?
        @trucks = Truck.where(brand_truck_id: brand.id, state_id: state.id, type_truck_id: type.id, active: 1).all.page(params[:page])
      end



    end




  end



  def camion
    @truck = Truck.find_by_id(params[:id])
  end





  def servicios

    if(params[:param1].nil? && params[:param2].nil?)
      #@extras = Service.where(:state, true).all.page(params[:page])
      @services = Service.all.where(active: 1).page(params[:page])
    end




    #busqueda de un parametro
    if(!params[:param1].nil? && params[:param2].nil?)

      if TypeService.where(link_rewrite: params[:param1]).exists?
        types = TypeService.find_by_link_rewrite(params[:param1])
        @services = Service.where(type_service_id: types.id, active: 1).all.page(params[:page])
      end


      if State.where(link_rewrite: params[:param1]).exists?
        state = State.find_by_link_rewrite(params[:param1])
        @services = Service.where(state_id: state.id, active: 1).all.page(params[:page])
      end

    end




    #busqueda de dos parametro
    if(!params[:param1].nil? && !params[:param2].nil? && params[:param3].nil?)
      @p1 = nil
      @p2 = nil


      if Service.where(link_rewrite: params[:param1]).exists?
        @p1 = 'service'
      end


      if State.where(link_rewrite: params[:param2]).exists?
        @p2 = 'state'
      end


      if Service.where(link_rewrite: params[:param2]).exists?
        @p2 = 'service'
      end


      if State.where(link_rewrite: params[:param1]).exists?
        @p1 = 'state'
      end





      if @p1 == 'service' &&  @p2 == 'state'

        type = TypeService.find_by_link_rewrite(params[:param1])
        state = State.find_by_link_rewrite(params[:param2])
        @services = Service.where(type_service_id: type.id, state_id: state.id, active: 1).all.page(params[:page])
      end


      if @p1 == 'state' &&  @p2 == 'service'

        type = TypeService.find_by_link_rewrite(params[:param2])
        state = State.find_by_link_rewrite(params[:param1])
        @services = Service.where(type_service_id: type.id, state_id: state.id, active: 1).all.page(params[:page])
      end






    end






  end

  def servicio
    @service = Service.find_by_id(params[:id])
  end
end
