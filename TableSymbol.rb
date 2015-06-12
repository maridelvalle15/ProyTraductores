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


class TableSymbol
	def initialize
		@symbols = Hash.new()
		@father = nil
		@son = nil
	end

	def change_father(father)
		@father = father
	end

	def change_son(son)
		@son = son
	end

	def get_father()
		return @father 
	end

	def get_son()
		return @son 
	end


	def insert(symbol, identifier)
		if !@symbols.has_key?(identifier)
			@symbols[identifier] = [symbol,nil]
		else
			puts "Elemento ya encontrado en la tabla"
		end
	end

	def delete(identifier)
		if @symbols.has_key?(identifier)
			@symbols.delete(identifier)
		else
			puts "Elemento no se encuentra en la tabla"
		end
	end

	def update(symbol,identifier,value)
		if @symbols.has_key?(identifier)
			@symbols[identifier] = [symbol,value]
		else
			puts "Elemento ya encontrado en la tabla"
		end
	end

	def contains(identifier)
		return  @symbols.has_key?(identifier)
	end

	def lookup(identifier)
		if @symbols.has_key?(identifier)
			return @symbols[identifier]
		else
			print "Elemento no se encontra en la tabla"
		end
	end

	def get_symbols
		return @symbols
	end

	def print_symbols
		@symbols.each { |key,value| puts "#{key} => #{value}"}
	end
end