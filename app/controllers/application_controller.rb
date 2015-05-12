class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    end
  end



  def toSql(vars)
    puts '----'
  puts vars
    puts '----'
    string = ''
    wheres =[]
    cuenta = 0
    vars.each do |var|



      if var[0].include? ('kilometraje')


        if var[1].split('-')[0].to_i == 100001


          string += 'kilometraje >= 100001 '
          wheres.push('kilometraje >= 100001 ')

        else if var[1].split('-')[0] == 0
               string += 'kilometraje = 0'
               wheres.push('kilometraje = 0')

       else
         valores = var[1].split('-')
         wheres.push('kilometraje >='+valores[2]+' AND kilometraje <='+valores[4])
         string +='kilometraje >='+valores[2]+' AND kilometraje <='+valores[4]

       end


    end


      else


        cuenta = cuenta+1

        if vars.count != cuenta
          string += var[0]+'='+var[1].to_s+' AND '
        else
          string += var[0]+'='+var[1].to_s
        end

        wheres.push(var[0]+'='+var[1].to_s)





      end




    end

    wheres.push('active = 1 ')


    c = 0
    string = ''
    string = ''
    wheres.each do |w|
      c = c+1

      if(c != wheres.count())
        string += w+' and '
      else
        string += w
      end


    end


    string


  end



  def toUrl(vars)
    url = ''
    cuenta = 0

    if vars.count > 1


      vars.each do |var|
        if(cuenta==0)
          url += var+'_'
        else
          if vars.count != cuenta
            url += var+'_'
          else
            url += var
          end

        end
        cuenta = cuenta+1

      end


    else
      url = vars[0]
    end
    url
  end




  def removerParametroPrincipal(url, parametro)

    url = url.sub(parametro, '')
    url

  end


  def agregarParametroPrincipal(url, parametro, slash)

    urlExplode = url.split('_')
    if slash
      newUrl = urlExplode[0]+'/'+parametro
    else
      newUrl = urlExplode[0]+parametro
    end




    cuenta = 0

    urlExplode.each do |item|

      if cuenta > 0

        if cuenta != urlExplode.count
          newUrl += '_'+item
        else

        end
      end

      cuenta = cuenta+1

    end
     newUrl



  end


  def agregarParametroSegundarios(url, llave, valor, slash)

    if slash
      if url.include? ('_')
        url += ''
      else
        url += '/'
      end


    end

    if url.include? '_'
      url += '_'+llave+'_'+valor
    else
      url += '_'+llave+'_'+valor
    end
    url

  end

  helper_method :toUrl, :removerParametroPrincipal, :agregarParametroPrincipal, :agregarParametroSegundarios

end
