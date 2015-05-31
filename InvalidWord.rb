#!/usr/bin/env ruby
#
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	3/05/1993

# Se crea en caso de encontrar un caracter no aceptado por el lenguaje Lanscii

class InvalidWord
	
	# Inicializa los atributos de la clase
	def initialize(value,nline,ncolumn)
		@value = value 		# Valor del caracter
		@nline = nline 		# Linea del archivo en donde se encuentra el caracter
		@ncolumn = ncolumn 	# Columna del archivo en donde se encuentra el caracter
	end

	# Devuelve el valor del caracter
	def get_value
		return @value
	end

	# Devuelve el numero de la linea del archivo en donde se encuentra el caracter
	def get_nline
		return @nline
	end

	# Devuelve el numero de la columna del archivo en donde se encuentra el caracter
	def get_ncolumn
		return @ncolumn
	end
end