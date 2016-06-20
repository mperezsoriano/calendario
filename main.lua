local calendario = require 'calendario'

local nuevoCalendario = calendario:new ("Calendario", 2)
nuevoCalendario.x = 200
nuevoCalendario.y = 100
nuevoCalendario:activaBotones ()
nuevoCalendario:actualizaCabecera (2, 10)
nuevoCalendario:crearMatrizDias ()
nuevoCalendario:creaDiasDelMes ()
