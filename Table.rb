#!/usr/bin/env ruby
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	14/06/2015

# Archivo main del proyecto

require "./TableSymbol.rb"

class Table
	def initialize
		@actual = TableSymbol.new()
	end

	def insert(symbol, identifier)
		return @actual.insert(symbol, identifier)
	end

	def delete(identifier)
		aux = @actual
		while aux != nil do
			if aux.contains(identifier)
				aux.delete(identifier)
				break
			end
			aux = aux.get_father
		end
	end

	def update(symbol,identifier)
		aux = @actual
		while aux != nil do
			if aux.contains(identifier)
				aux2 = aux.get_symbols
				array = aux2[identifier]
				if array[0] == symbol
					aux.update(symbol,identifier)
					break
				end
			end
			aux = aux.get_father
		end
	end

	def contains(identifier)
		aux = @actual
		while aux != nil do
			if aux.contains(identifier)
				return true
			end
			aux = aux.get_father
		end
		return false
	end

	def lookup(identifier)
		aux = @actual
		while aux != nil do
			if aux.contains(identifier)
				return aux.lookup(identifier)
			end
			aux = aux.get_father
		end
		return false
	end


	def addscope
		new_table = TableSymbol.new()
		@actual.change_son(new_table)
		new_table.change_father(@actual)
		@actual = new_table
	end

	def endscope
		@actual = @actual.get_father()
	end

	def print_actual(num)
		@actual.print_symbols(num)
	end

	def get_actual
		return @actual
	end 

	def print 
		aux = @actual
		while aux != nil do
			puts "Tabla:"
			aux.print_symbols
			aux = aux.get_father()
		end
	end
end