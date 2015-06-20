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

# Arbol de Tabla de Simbolos
class TableSymbol
	# Crea un nodo (tabla de hash)
	def initialize
		@symbols = Hash.new()
		@father = nil
		@son = nil
	end


	# Cambia el padre del nodo
	def change_father(father)
		@father = father
	end

	# Cambia el hijo del nodo
	def change_son(son)
		@son = son
	end

	# Obtiene el padre del nodo
	def get_father()
		return @father 
	end

	# Obtiene el hijo del nodo
	def get_son()
		return @son 
	end

	# Inserta un elemento en la tabla a menos que ya lo encuentre
	def insert(symbol, identifier,value)
		if !@symbols.has_key?(identifier)
			@symbols[identifier] = [symbol,value]
			return false
		else
			puts "Identificador: #{identifier}, declarado dos veces en un mismo alcance:"
			return true
		end
	end

	# Elimina un elemento de la tabla a menos que no lo encuentre
	def delete(identifier)
		if @symbols.has_key?(identifier)
			@symbols.delete(identifier)
		else
			puts "Identificador: #{identifier}, no se encuentra en ningun alcance"
		end
	end

	# Actualiza un elemento de la tabla a menos que ya se encuentre
	def update(symbol,identifier,value)
		if @symbols.has_key?(identifier)
			@symbols[identifier] = [symbol,value]
		else
			puts "Identificador: #{identifier}, no se encuentra en ningun alcance"
		end
	end

	# Devuelve el identificador de la variable que se encuentra en la tabla
	def contains(identifier)
		return  @symbols.has_key?(identifier)
	end

	# Busca un elemento en la tabla
	def lookup(identifier)
		if @symbols.has_key?(identifier)
			return @symbols[identifier]
		else
			print "Identificador: #{identifier}, no se encuentra en ningun alcance"
		end
	end

	# Devuelve el valor del nodo (tabla)
	def get_symbols
		return @symbols
	end

	# Imprime el arbol. La clave (variable) y el valor (tipo)
	def print_symbols(num)
		for i in 0..num-1 do print "    " end
		@symbols.each  {|key,value| print "#{value}: #{key},  "}
	end
end