#!/usr/bin/env ruby
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	08/06/2015

# Archivo main del proyecto

require "./TableSymbol.rb"

class Table
	def initialize
		@actual = TableSymbol.new()
	end

	def insert(symbol, identifier)
		@actual.insert(symbol, identifier)
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

	def update(symbol,identifier,value)
		aux = @actual
		while aux != nil do
			if aux.contains(identifier)
				aux2 = aux.get_symbols
				array = aux2[identifier]
				if array[0] == symbol
					aux.update(symbol,identifier,value)
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

	def print_actual
		@actual.print_symbols
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

=begin
tabla = Table.new()
tabla.insert(:INT,3)
tabla.insert(:INT,6)
tabla.print_actual()
tabla.addscope()
tabla.insert(:MIa,3)
tabla.print()
puts
tabla.delete(3)
tabla.print()
puts
tabla.endscope()
tabla.insert(:MEGA,55)
tabla.print()
puts
=begin
tabla.addscope()
tabla.insert(:DACA,554)
tabla.print()
puts
tabla.update(:DACA,554,1)
tabla.print()
puts tabla.contains(554)
puts tabla.contains(6)
puts tabla.contains("andres")
print tabla.lookup(554)
puts
print tabla.lookup(6)
puts

#tabla.delete(3)
#tabla.delete(3)
#tabla.print_actual()
#hola.insert(:INT,hola);
=end
