------------------------------------------------------------
-- Version: 1.0
--
-- Copyright (C) Jondu Solutions 2016.
--
-- Funciones independientes
------------------------------------------------------------
local M ={}

	-- Si el año introducido es bisiestro retorna 1 y si no 0
	function M.determinaSiEsBisiesto (ano)
		local bisiesto = 0
		local ano = 2000 + ano
		if ano%4==0 or ano%100==0 or ano%400==0 then bisiesto = 1 end
		return bisiesto
	end

	-- Devuelve un vector que contiene los dias de cada mes del año
	function vectorDeDiasQueTieneUnMes (ano)
		local incremento = M.determinaSiEsBisiesto (ano)
	  local vMeses = {31, 28+incremento, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
		return vMeses
	end

	-- Esta funcion tiene por entrada una fecha en formato string del
	-- añomesdia y da como salida la fecha siguiente en el mismo formato
	function M.incrementaFecha (fecha)
	  local ano = tonumber (string.sub (fecha, 0, 2))
	  local mes = tonumber (string.sub (fecha, 3, 4))
	  local dia = tonumber (string.sub (fecha, 5, 6))
		local vMeses = ectorDeDiasQueTieneUnMes (ano)
	  local incremento = M.determinaSiEsBisiesto (ano)
	  dia = dia + 1
	  if dia > vMeses[mes] then
	    dia = 1
	    mes = mes + 1
	    if mes > 12 then
	      mes = 1
	      ano = ano +1
	    end
	  end
	  return tostring (ano*10000+mes*100+dia)
	end

	-- Esta funcion tiene como entrada un vector vacio, y una fecha inicial y
	-- otra final con el formato string añomesdia, y da como salida el vector
	-- con todas las fechas validas entre ambas
	function M.vEntreDosFechas (vectorFechas, fechaInicial, fechaFinal)
	  vectorFechas[#vectorFechas+1] = fechaInicial
		fechaInicial = M.incrementaFecha (fechaInicial)
		if fechaInicial == fechaFinal then
			vectorFechas[#vectorFechas+1] = fechaFinal
			return vectorFechas
		else
			M.vEntreDosFechas (vectorFechas, fechaInicial, fechaFinal)
		end
	end

	-- Esta funcion tiene como entrada un vctor de una dimension y se salida
	-- da el valor minimo y maximo encontrado
	function M.sacaMinimoMaximoVector (vector)
		local minimo,maximo = vector[1], vector[1]
		for i=1,#vector do
			if vector[i]<minimo then minimo = vector[i] end
			if vector[i]>maximo then maximo = vector[i] end
		end
		return minimo, maximo
	end

	-- Nos devuelve en que dia comienza un mes diendo 1- Lunes y 7 - Domingo y
	-- el numero de dias que tiene ese mes
	function M.diaComienzoDelMes (mes, ano)
		local vMeses = vectorDeDiasQueTieneUnMes (ano)
		local numeroDias = 30
		local bisiesto = 0
		local vCorreccion = {0,3,3,6,1,4,6,2,5,0,3,5}
		local comienzo = ((math.floor ((ano-1)/4) + (ano-1))%7) + vCorreccion[mes] + 1
		if vMeses[2] == 29 then bisiesto = 1 end
		if mes>2 then comienzo = comienzo + bisiesto end
		comienzo = comienzo%7
		if comienzo == 0 then comienzo = 7 end
		numeroDias = vMeses [mes]
		return comienzo, numeroDias
	end

	-- Nos devuelve un string con el mes en cuestion
	function M.nombreMes (numero)
		local meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"}
		return meses[numero]
	end

	-- Nos devuelve un el dia, el mes y el año asi como una fecha conjunta de todos
	function M.fechaActual ()
		local dia = tonumber (os.date("%d"))
		local mes = tonumber (os.date("%m"))
		local ano = 2000+tonumber (os.date("%y"))
		local fecha = os.date("%y")..os.date("%m")..os.date("%d")
		return dia, mes, ano, fecha
	end

	-- Esta funcion compara dos fechas para saber si una es mayor que la otra
	-- devuelve false en caso que la primera sea mayor que la segunda
	function M.comparacionDosFechas (diaInicial, mesInicial, anoInicial, diaFinal, mesFinal, anoFinal)
		local res = true
		if anoInicial<=anoFinal then
			if mesInicial<=mesFinal then
				if mesInicial == mesFinal then
					if diaInicial>diaFinal then
						res = false
					end
				end
			else
				res = false
			end
		else
			res = false
		end
		return res
	end

return M
