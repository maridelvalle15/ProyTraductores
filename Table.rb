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


require "./TableSymbol.rb"

# Tabla de simbolos
class Table
	# inicializa la nueva tabla
	def initialize
		@actual = TableSymbol.new()
	end
	# Inserta un elemento nuevo a la tabla
	def insert(symbol, identifier,value)
		return @actual.insert(symbol, identifier,value)
	end
	# Elimina la tabla, cambia el padre en el arbol
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
	# Actualiza la tabla, actualiza el padre en el arbol
	def update(symbol,identifier,value)
		puts symbol
		puts identifier
		puts value
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
	# Verifica que la tabla se encuentre en el arbol
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
	# Busca la tabla en el arbol
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
	# Agrega un nuevo nodo al arbol
	def addscope
		new_table = TableSymbol.new()
		@actual.change_son(new_table)
		new_table.change_father(@actual)
		@actual = new_table
	end
	# Termina la tabla
	def endscope
		@actual = @actual.get_father()
	end
	# Imprime el arbol
	def print_actual(num)
		@actual.print_symbols(num)
	end
	# Devuelve la tabla actual
	def get_actual
		return @actual
	end 
	# Imprime la tabla actual
	def print 
		aux = @actual
		while aux != nil do
			puts "Tabla:"
			aux.print_symbols
			aux = aux.get_father()
		end
	end
end
