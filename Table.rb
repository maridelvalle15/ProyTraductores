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

class Table
	def initialize
		@symbols = Hash.new()
		@actual = @symbols
		@ant = @symbols
	end

	def insert(symbol, identifier)
		if !@symbols.has_key?(identifier)
			@symbols[identifier] = symbol
		else
			puts "Elemento ya encontrado en la table"
		end
	end

	def get_symbols
		return @symbols
	end

	def print_table
		puts @symbols
	end
end


hola = Table.new()
hola.insert(:INT,3)
puts "#{hola.get_symbols()}"
#hola.insert(:INT,hola);

