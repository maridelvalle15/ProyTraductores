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

require "./Symbol.rb"

class Table
	def initialize
		@symbols = []
	end

	def insert(symbol, identifier)
		symbol = Symbol.new(symbol, identifier)
		@symbols << symbol
	end

	def delete(identifier)
		@symbols.each do |symbol|
			if symbol.get_identifier == identifier
				@symbols.delete(symbol)
			end
		end
	end

	def update(symbol,identifier)
		@symbols.each do |symbol|
			if symbol.get_identifier == identifier 
				symbol.change_symbol(symbol)
			end
		end
	end

	def is_in(identifier)
		@symbols.each do |symbol|
			if  symbol.get_identifier == identifier 
				return true
			end
		end
		return false
	end

	def get_value(identifier)
		@symbols.each do |symbol|
			if  symbol.get_identifier == identifier 
				return symbol.get_valuer
			end
		end
	end
end
