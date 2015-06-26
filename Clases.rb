#!/usr/bin/env ruby
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
#  26/06/2015

# Clases utilizadas por el parser para crear el arbol sintactico abstracto

# Clase que representa la regla del programa principal
class S 
	def initialize(symbol,estruct)
		@symbol= symbol
		@estruct = estruct
	end

	def get_estruct
		return @estruct
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

	def get_instr
		return @estruct[1]
	end
end

# Clase que representa la regla de las posibles instrucciones dentro de la estructura del programa
class INSTR
	def initialize(symbol1,instr1,symbol2=nil,instr2=nil)
		@symbol= [symbol1, symbol2]
		@instr = [instr1,instr2]
	end

	def get_instr
		return @instr
	end

	def get_symbol
		return @symbol
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
		return @values[1]
	end

	def get_listident
		return @values[2]
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
end

#Clase que representa la regla de asignacion de las instrucciones del programa
class ASSIGN
	def initialize(symbol1,variable,symbol2,expr)
		@symbol = [symbol1,symbol2]
		@values = [variable,expr]
	end

	def get_symbol
		return @symbol
	end

	def get_values
		return @values
	end
end

#Clase que representa la regla de write o read de las instrucciones del programa
class WRITE_READ
	def initialize(symbol,expr)
		@symbol = symbol
		@write = [expr]
	end

	def get_instr
		return @write[0]
	end

	def get_symbol
		return @symbol
	end
end

#Clase que representa la regla de condicion if-then-else de las instrucciones del programa
class CONDITIONAL
	def initialize(symbol1,expr,symbol2,instr1,symbol3=nil,instr2=nil)
		@symbol = [symbol1,symbol2,symbol3]
		@values = [expr,instr1,instr2]
	end

	def get_symbol
		return @symbol
	end

	def get_values
		return @values
	end
end

#Clase que representa la regla de iteracion indeterminada while-do de las instrucciones del programa
class ITERIND
	def initialize(symbol1,expr,symbol2,instr)
		@symbol = [symbol1,symbol2]
		@values = [expr,instr]
	end

	def get_symbol
		return @symbol
	end

	def get_values
		return @values
	end
end

#Clase que representa la regla de iteracion determinada de las instrucciones del programa
class ITERDET
	def initialize(symbol=nil,var=nil,symbol1,expr1,symbol2,expr2,symbol3,instr)
		@symbol = [symbol,symbol1,symbol2,symbol3]
		@values = [var,expr1,expr2,instr]
	end

	def get_symbol
		return @symbol
	end

	def get_values
		return @values
	end
end

#Clase que representa la regla de expresiones parentizadas
class EXPR_PARENTHESIS
	def initialize(symbol,expr)
		@symbol = symbol
		@expr_parenthesis = expr
	end

	def get_symbol
		return @symbol
	end

	def get_expr
		return  @expr_parenthesis
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

	def get_eval(operation, expr1,expr2)
		case operation
		when :PLUS
			return expr1 + expr2
		when :MINUS
			return expr1 - expr2
		when :DIVISION
			if expr2 == 0
				puts "ERROR: division por cero no permitida"
				$error = true
				return 0
			else
				return expr1 / expr2
			end
		when :MULTIPLY
			return expr1 * expr2
		when :PERCENT
			if expr2 == 0
				puts "ERROR: division por cero no permitida"
				$error = true
				return 0
			else
				return expr1.modulo(expr2)
			end
		when :AND 
			return expr1 && expr2
		when :OR 
			return expr1 || expr2 
		when :AMPERSAND
			if expr1[0].length == expr2[0].length 
				return expr1+expr2
			else
				return nil
			end
		when :VIRGUILE
			if expr1.length == 1 and expr2.length == 1
				return [expr1[0]+expr2[0]]
			elsif expr1.length == expr2.length
				aux = []
				for i in 0..expr1.length-1
					aux << expr1[i]+expr2[i]
				end
				return aux
			else
				return nil
			end
		when :LESS
			return expr1 < expr2
		when :LESS_EQUAL
			return expr1 <= expr2
		when :MORE
			return expr1 > expr2
		when :MORE_EQUAL
			return expr1 >= expr2
		when :EQUAL
			return expr1 == expr2
		when :INEQUAL
			return expr1 != expr2
		end
	end

	def get_arit
		return @arit
	end

	def get_val
		return @val
	end

	def get_symbol
		return @symbol
	end

	def get_expr
		return  @expr
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

	def get_eval(operation, expr1)
		case operation
		when :MINUS_UNARY
			return -1*expr1 
		when :DOLLAR 
			aux = []
			filas = expr1.length
			columnas = expr1[0].length
			for i in 0 .. filas-1
				a = ""
				for j in 0.. columnas-1
					a = a + " "
				end
				aux << a
			end
			for i in 0..expr1.length-1
				for j in 0 ..expr1[i].length-1
					if expr1[i][j] == "_"
						aux[i][j] = "|"
					elsif expr1[i][j] == "-"
						aux[i][j] = "|"
					elsif expr1[i][j] == "\\"
						aux[i][j] = "/"
					elsif expr1[i][j] == "|"
						aux[i][j] = "_"
					elsif expr1[i][j] == "/"
						aux[i][j] = "\\"
					end
				end
			end
			return aux
		when :APOSTROPHE 
			aux = []
			filas = expr1.length
			columnas = expr1[0].length
			for i in 0 .. columnas-1
				a = ""
				for j in 0.. filas-1
					a = a + " "
				end
				aux << a
			end
			for i in 0 .. columnas-1
				for j in 0.. filas-1
					aux[i][j] = expr1[j][i]
				end
			end
			return aux
		when :NOT
			return !expr1
		end
	end

	def get_arit
		return @arit
	end

	def get_val
		return @val
	end

	def get_symbol
		return @symbol
	end
	
	def get_expr
		return  @expr
	end
end

#Clase que representa la regla de valores posibles de las expresiones
class EXPR_VALUE
	def initialize(symbol,expr_value)
		@symbol = symbol
		@expr_value = expr_value
	end

	def get_symbol
		return @symbol
	end
	
	def get_expr
		return  @expr_value
	end
end

#Clase que representa la regla de valores (lienzos, booleanos, numeros o identificadores)
class VALUE
	def initialize(symbol,value)
		@symbol = symbol
		@value = value
	end

	def get_symbol
		return @symbol
	end
	
	def get_value
		return  @value
	end
end