#!/usr/bin/env ruby
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	31/05/2015

# Archivo main del proyecto

class Symbol
	def initialize(symbol, identifier)
		@symbol = symbol
		@identifier = identifier
		@value = nil
	end

	def get_symbol
		return @symbol
	end

	def get_identifier
		return @identifier
	end

	def get_value
		return @value
	end

	def change_symbol(symbol)
		@symbol = symbol
	end

	def change_identifier(identifier)
		@identifier = identifier
	end

	def change_value(value)
		@value = value
	end

end
