#!/usr/bin/env ruby
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	30/05/2015

# Clases utilizadas por el parser para crear el arbol sintactico abstracto

# Clase que representa la regla del programa principal
class S 
	def initialize(symbol,estruct)
		@symbol= symbol
		@estruct = [estruct]

	end

	def print_tree(num)
		@estruct.each do |estruct|
			estruct.print_tree(num)
		end
	end
end

# Clase que representa la regla de la estructura del programa
# representado por { DEC | INSTR } o { INSTR }
class ESTRUCT 
	def initialize(symbol1=nil,declaration=nil,symbol2,instr)
		@symbol = [symbol1,symbol2]
		@estruct = [declaration,instr]
	end

	def get_dec 
		return @estruct[0]
	end 

	def print_tree(num)
		@estruct[1].print_tree(num)
	end
end

# Clase que representa la regla de las posibles instrucciones dentro de la estructura del programa
class INSTR
	def initialize(symbol1,instr1,symbol2=nil,instr2=nil)
		@symbol= [symbol1, symbol2]
		@instr = [instr1,instr2]
	end

	def print_tree(num)
		@instr.each do |instr|
			if instr != nil
				if @symbol[0] != :INSTR 
					for i in 1..num
						print "| "
					end
					print @symbol[0]
					puts ": "
					instr.print_tree(num+1)	
				else
					instr.print_tree(num)
				end
			end
		end
	end
end

#Clase que representa la regla de declaraciones de identificadores
class DECLARATION
	def initialize(symbol1=nil,declaration=nil,symbol2,type,symbol3,listident)
		@symbol = [symbol1,symbol2,symbol3]
		@values = [declaration,type,listident]
	end

	def get_dec
		return @values[0]
	end

	def get_type
		return @values[1].get_symbol
	end

	def get_listident
		return @values[2]
	end

	def print_tree(num)
		for i in 0..2
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

#Clase que representa la regla de los diferentes tipos de identificadores de las declaraciones 
class TYPE
	def initialize(symbol,type)
		@symbol = symbol
		@type = type
	end

	def get_symbol
		return @symbol
	end

	def print_tree(num)
		for i in 1..num
			print "| "
		end
		print @symbol  
		print ": "
		puts @type
	end
end

#Clase que representa la regla de la lista de identificaciones de las declaraciones
class LISTIDENT 
	def initialize(symbol1=nil,listident=nil,symbol2,variable)
		@symbol = [symbol1,symbol2]
		@values = [listident,variable]
	end

	def get_listident
		return @values[0]
	end

	def get_variable
		return @values[1]
	end

	def print_tree(num)
		for i in 0..1
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end
				print @symbol[i]
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

#Clase que representa la regla de asignacion de las instrucciones del programa
class ASSIGN
	def initialize(symbol1,variable,symbol2,expr)
		@symbol = [symbol1,symbol2]
		@values = [variable,expr]
	end

	def print_tree(num)

		for i in 0..1
			for j in 1..num
				print "| "
			end
			print @symbol[i]  
			puts ": "
			@values[i].print_tree(num+1)
		end
	end
end

#Clase que representa la regla de write o read de las instrucciones del programa
class WRITE_READ
	def initialize(symbol,expr)
		@symbol = symbol
		@write = [expr]
	end

	def print_tree(num)
		
		@write.each do |write|
			for i in 1..num
				print "| "
			end
			print @symbol  
			puts ": "
			write.print_tree(num+1)
		end
	end
end

#Clase que representa la regla de condicion if-then-else de las instrucciones del programa
class CONDITIONAL
	def initialize(symbol1,expr,symbol2,instr1,symbol3=nil,instr2=nil)
		@symbol = [symbol1,symbol2,symbol3]
		@values = [expr,instr1,instr2]
	end

	def print_tree(num)
		for i in 0..2
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

#Clase que representa la regla de iteracion indeterminada while-do de las instrucciones del programa
class ITERIND
	def initialize(symbol1,expr,symbol2,instr)
		@symbol = [symbol1,symbol2]
		@values = [expr,instr]
	end

	def print_tree(num)
		for i in 0..1
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

#Clase que representa la regla de iteracion determinada de las instrucciones del programa
class ITERDET
	def initialize(symbol=nil,var=nil,symbol1,expr1,symbol2,expr2,symbol3,instr)
		@symbol = [symbol,symbol1,symbol2,symbol3]
		@values = [var,expr1,expr2,instr]
	end

	def print_tree(num)
		for i in 0..3
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

#Clase que representa la regla de expresiones parentizadas
class EXPR_PARENTHESIS
	def initialize(symbol,expr)
		@symbol = symbol
		@expr_parenthesis = expr
	end

	def print_tree(num)
		@expr_parenthesis.print_tree(num)
	end
end

#Clase que representa la regla de expresiones binarias
class EXPR_BIN
	def initialize(symbol,val,symbol1,expr1,symbol2,expr2)
		@arit = symbol
		@val = val
		@symbol = [symbol1,symbol2]
		@expr = [expr1,expr2]
	end

	def print_tree(num)
		for k in 1..num
			print "| "
		end
		print "OPERATION: "  
		puts @val

		for i in 0..1
			@expr[i].print_tree(num+1)
		end
	end
end

#Clase que representa la regla de expresiones unarias
class EXPR_UNARIA
	def initialize(symbol,val,symbol1,expr1)
		@arit = symbol
		@val = val
		@symbol = symbol1
		@expr = expr1
	end

	def print_tree(num)
		for k in 1..num
			print "| "
		end
		print "SIGNO: "  
		puts @val
		@expr.print_tree(num+1)
	end
end

#Clase que representa la regla de valores posibles de las expresiones
class EXPR_VALUE
	def initialize(symbol,expr_value)
		@symbol = symbol
		@expr_value = expr_value
	end

	def print_tree(num)
		@expr_value.print_tree(num)
	end
end

#Clase que representa la regla de valores (lienzos, booleanos, numeros o identificadores)
class VALUE
	def initialize(symbol,value)
		@symbol = symbol
		@value = value
	end

	def get_value
		return @value
	end

	def print_tree(num)
		for i in 1..num
			print "| "
		end 
		if @symbol == :CANVAS 
			print @symbol  
			print ": "
			puts "#{@value}"
		elsif @symbol == :TRUE 
			print @symbol  
			print ": "
			puts "#@value"
		elsif @symbol == :FALSE 
			print @symbol  
			print ": "
			puts "#{@value}"
		elsif @symbol == :NUMBER 
			print @symbol  
			print ": "
			puts "#{@value}"
		elsif @symbol == :IDENTIFIER
			print @symbol  
			print ": "
			puts "#{@value}"
		elsif @symbol == :EMPTY_CANVAS
			print @symbol  
			print ": "
			puts "#{@value}"
		end
	end
end