------------------------------------------------------------
-- Version: 1.0
--
-- Copyright (C) Jondu Games 2016.
--
-- Clase para un calendario
------------------------------------------------------------
local _M = {}

function _M:new ()
	local fcalendario = require 'fcalendario'

	local menu = display.newGroup ()

	local barraFehas = display.newRect (menu, -20, 0, 140, 40)
	barraFehas.alpha = 0.1;
	local tMesActual = display.newText (menu, "Diciembre 2016", -20, 0, native.systemFont, 16)

	local iDecrementaMes = display.newRect (menu, -120, 0, 40, 40)
	iDecrementaMes.nombre = "bajar"; iDecrementaMes.alpha = 0.1
	local tDecrementaMes = display.newText (menu, "<", -120, 0, native.systemFont, 20)

	local iIncrementaMes = display.newRect (menu, 80, 0, 40, 40)
	iIncrementaMes.nombre = "subir"; iIncrementaMes.alpha = 0.1
	local tIncrementaMes = display.newText (menu, ">", 80, 0, native.systemFont, 20)
	local iCambio = display.newRect (menu, 137, 0, 65, 40)
	iCambio.nombre = 0; iCambio.alpha = 0.1
	local tCambio = display.newText (menu, "Ini", 137, 0, native.systemFont, 16)


	menu.x = 0
	menu.y = 0
	menu.numero = posicion
	menu.diaActual, menu.mesActual, menu.anoActual, menu.fechaActual = fcalendario:fechaActual ()
	menu.dia, menu.mes, menu.ano = menu.diaActual, menu.mesActual, menu.anoActual
	menu.diaFinal, menu.mesFinal, menu.anoFinal = menu.diaActual, menu.mesActual, menu.anoActual
	menu.diaInicial, menu.mesInicial, menu.anoInicial = menu.diaActual, menu.mesActual, menu.anoActual
	menu.dias = {}

	local function listenerDia (event)
		if event.phase == "began" then
			if iCambio.nombre == 1 then
				local menorActual = fcalendario.comparacionDosFechas (event.target.numero, menu.mesActual, menu.anoActual, menu.dia, menu.mes, menu.ano)
				local mayorInicial = fcalendario.comparacionDosFechas (menu.diaInicial, menu.mesInicial, menu.anoInicial, event.target.numero, menu.mesActual, menu.anoActual)
				if menorActual and mayorInicial then
					menu.diaFinal = event.target.numero
					menu.mesFinal = menu.mesActual
					menu.anoFinal = menu.anoActual
					menu:comprobacionFechas ()
				end
			else
				local menorFinal = fcalendario.comparacionDosFechas (event.target.numero, menu.mesActual, menu.anoActual, menu.diaFinal, menu.mesFinal, menu.anoFinal)
				if menorFinal then
					menu.diaInicial = event.target.numero
					menu.mesInicial = menu.mesActual
					menu.anoInicial = menu.anoActual
					menu:comprobacionFechas ()
				end
			end
		end
		return true
	end

	local function incrementaDecrementa (event)
		if event.target.nombre == "subir" then
			menu.mesActual = menu.mesActual + 1
			if menu.mesActual>12 then
				menu.mesActual = 1
				menu.anoActual = menu.anoActual + 1
			end
		else
			menu.mesActual = menu.mesActual - 1
			if menu.mesActual<1 then
				menu.mesActual = 12
				menu.anoActual = menu.anoActual - 1
			end
		end
		menu:actualizaCabecera ()
		menu:creaDiasDelMes ()
		return true
	end

	local function cambiaInicioFin (event)
		if iCambio.nombre == 1 then
			iCambio.nombre = 0
			tCambio.text = "Ini"
		else
			iCambio.nombre = 1
			tCambio.text = "Fin"
		end
		return true
	end

	function menu:comprobacionFechas ()
		for i=1,#self.dias do self.dias[i].imagen.alpha = 0.1
			if self.anoActual == self.anoFinal and self.mesActual == self.mesFinal then
				if self.dias[i].imagen.numero == self.diaFinal then
					self.dias[i].imagen.alpha = 0.4
				end
			end
			if self.anoActual == self.anoInicial and self.mesActual == self.mesInicial then
				if self.dias[i].imagen.numero == self.diaInicial then
					self.dias[i].imagen.alpha = 0.4
				end
			end
		end
	end

	function menu:actualizaCabecera ()
		tMesActual.text = fcalendario.nombreMes (self.mesActual).." "..self.anoActual
	end

	function menu:crearMatrizDias ()
		local tamano = 45
		local despX = 165; local despY = -10
		for i=1,6 do
			for j=1,7 do
				local num = (i-1)*7+j
				self.dias[num] = {}
				self.dias[num].imagen = display.newRect (menu, j*tamano-despX, i*tamano-despY, tamano-5, tamano-5)
				self.dias[num].imagen.alpha = 0.1
				self.dias[num].imagen.numero = 0
				self.dias[num].imagen:addEventListener ("touch", listenerDia)
				self.dias[num].texto = display.newText (menu, "0", j*tamano-despX, i*tamano-despY, native.systemFont, 16)
			end
		end
	end

	function menu:creaDiasDelMes ()
		local inicio, maxDias = fcalendario.diaComienzoDelMes (self.mesActual, self.anoActual-2000)
		local numDia = 0
		for i=1,#self.dias do
			if i>=inicio and i<inicio+maxDias then
				numDia = numDia + 1
			else
				numDia = 0
			end
			self.dias[i].imagen.numero = numDia
			self.dias[i].texto.text = numDia
			self.dias[i].imagen.isVisible = true
			self.dias[i].texto.isVisible = true
			if numDia==0 then
				self.dias[i].texto.text = numDia
				self.dias[i].imagen.isVisible = false
				self.dias[i].texto.isVisible = false
			end
		end
		self:comprobacionFechas ()
	end

	function menu:getFechas ()
		return {self.diaInicial, self.mesInicial, self.anoInicial, self.diaFinal, self.mesFinal, self.anoFinal}
	end

	function menu:getFechasCadena ()
		local inicio = self.anoInicial.."-"..string.format ("%02d", self.mesInicial).."-"..string.format ("%02d", self.diaInicial)
		local fin = self.anoFinal.."-"..string.format ("%02d", self.mesFinal).."-"..string.format ("%02d", self.diaFinal)
		return {inicio, fin}
	end

	function menu:visualizaOculta ()
		if self.y == 9999 then self.y = -220 else self.y = 9999 end
	end

	function menu:activaBotones ()
		iDecrementaMes:addEventListener ("tap", incrementaDecrementa)
		iIncrementaMes:addEventListener ("tap", incrementaDecrementa)
		iCambio:addEventListener ("tap", cambiaInicioFin)
	end

	function menu:desactivaBotones ()
		iDecrementaMes:removeEventListener ("tap", incrementaDecrementa)
		iIncrementaMes:removeEventListener ("tap", incrementaDecrementa)
		iCambio:removeEventListener ("tap", cambiaInicioFin)
	end

	return menu
end

return _M
