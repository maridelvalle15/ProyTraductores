#!/usr/bin/env ruby
# encoding: utf-8
#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
#  26/06/2015

require "./Table.rb"
require "./TableSymbol.rb"

$tables = Table.new() 	# Definir una varible global llamada tabla
$alcance = 0			# Definir una varible global llamada alcance
$ftables = []			# Definir una varible global llamada ftabl
$error = false			# Definir una varible global llamada error

# Luego de realizar parseo, se comienza a crear el arbol abstracto sintactico. 
def evalAST(ast)
	evalEstruct(ast.get_estruct)
end

# Chequea la estructura del programa (declaraciones e instrucciones). 
# Finaliza la tabla
def evalEstruct(estruct)
	evalDeclaration(estruct.get_dec)
	if !$error
		#Se va insertando la tabla actual y su alcance a la varible global ftable
		$ftables << [$tables.get_actual,$alcance]
		evalInstr(estruct.get_instr)
		if !$error
			$tables.endscope
			$alcance -= 1
		end
	end
end

# Chequea las declaraciones del programa
def evalDeclaration(declaration)
	# Si hay declaracon, llama recursivamente a la funcion
	if declaration != nil
		evalDeclaration(declaration.get_dec)
		# Obtiene el tipo de la variable declarada
		type = declaration.get_type.get_symbol
		# evalua la lista de identificadores
		if !$error
			evalListident(type,declaration.get_listident)
		end
	end
end

# Chequea la lista de identificadores (variables)
def evalListident(type,listident)
	# Si no obtiene nada, llama recursivamente a la funcion
	if listident.get_listident != nil
		if !$error
			evalListident(type,listident.get_listident)
		end
	end
	# Obtiene la variable declarada
	variable = listident.get_variable
	# Inserta la variable en la tabla junto con el tipo correspondiente 
	# Al ser una tabla de hash, la clave es la variable y el valor el tipo 
	if type == :CANVAS
		$error = $tables.insert(type,variable.get_value,nil)
	else
		$error = $tables.insert(type,variable.get_value,nil)
	end
end

# evalua quer instruccion esta leyendo
def evalInstr(instr)
	# En caso que sea read o write
	if !$error
		if instr.class == WRITE_READ
			symbol = instr.get_symbol
			case symbol
			# evalua la estructura del write
			when :WRITE
				evalWrite(instr.get_instr)
			# evalua la estructura del read
			when :READ
				evalRead(instr.get_instr)
			end
		# En caso que sea una instruccion
		elsif instr.class == INSTR
			instrs = instr.get_instr
			symbols = instr.get_symbol
			# Iteracion auxiliar para recorrer la instruccion
			for i in 0..1
				# Si efectivamente hay algo que chequear
				if !$error
					if symbols[i] != nil
						case symbols[i]
						# evalua la estructura de la instruccion
						when :INSTR
							evalInstr(instrs[i])
						# evalua la estructura del programa, en este caso se agrega
						# una tabla
						when :ESTRUCT
							$tables.addscope
							$alcance += 1
							evalEstruct(instrs[i])
						# evalua la estructura de la asignacion
						when :ASSIGN
							evalAssign(instrs[i])
						# evalua la estructura del condicional
						when :CONDIC
							evalConditional(instrs[i])
						# evalua la estructura de la iteracion indeterminada
						when :ITERIND
							evalIterInd(instrs[i])
						# evalua la estructura de la iteracion determinada
						when :ITERDET
							evalIterDet(instrs[i])
						end
					end
				end
			end
		end
	end
end

# Chequea las asignaciones del programa
def  evalAssign(instr)
	values = instr.get_values
	identif = values[0].get_value
	# Si al buscar en la tabla, la variable no ha sido declarada, 
	# devuelve un mensaje
	symbol_expr = evalExpression(values[1])
	if !$error
		if symbol_expr[0] == :INTEGER
			$tables.update(symbol_expr[0],identif,symbol_expr[1])
		elsif  symbol_expr[0] == :CANVAS
			$tables.update(symbol_expr[0],identif,symbol_expr[1])
		else
			$tables.update(symbol_expr[0],identif,symbol_expr[1])
		end
	end
end

# evaluar la estructura del write
def evalWrite(expr)
	symbol = evalExpression(expr)
	puts symbol[1]
end

# evalua la estructura del read
def evalRead(expr)
	evalIdentifierINT_BOOL(expr)
end

# Chequea la estructura de los identificadores booleanos y/o enteros
def evalIdentifierINT_BOOL(expr)
	identif = expr.get_value
	# evalua en la tabla que el identificador corresponda con entero o 
	# booleano, o que simplemente no se encuentre en la tabla
	type = $tables.lookup(identif)
	if type[0] == :INTEGER
		print "Introduzca un numero entero: "
		input = $stdin.readline
		case input
		when /^[0-9][0-9]*/ 
			input = input.to_i
			if input > 2147483647 || input < -2147483647
				puts "ERROR: overflow entrada de numero de 32 bits erroneo"
				$error = true
			elsif input < 2147483647 && input > -2147483647
				$tables.update(type[0],identif,input)
			end
		else
			puts "ERROR: entrada incorrecta se espera un INTEGER"
			$error = true
		end

	elsif type[0] == :BOOLEAN
		print "Introduzca un booleano true or false: "
		input = $stdin.readline
		if input.downcase == "true\n"
			$tables.update(type[0],identif,true) 
		elsif input.downcase == "false\n"
			$tables.update(type[0],identif,false)
		else
			puts "ERROR: entrada incorrecta se espera un #{type[0]}"
			$error = true
		end
	end
end
# evalua la estructura de los condicionales
def evalConditional(expr) 
	symbol = expr.get_symbol
	values = expr.get_values
	type_expr = evalExpression(values[0])
	# Los identificadores unicamente pueden ser booleanos o numeros
	if !$error
		if type_expr[1] == true
			evalInstr(values[1])
		elsif type_expr[1] == false
			if values[2] != nil
				evalInstr(values[2])
			end
		end
	end
end

# evalua la iteracion indeterminada
def evalIterInd(expr) 
	symbol = expr.get_symbol
	values = expr.get_values
	type_expr = evalExpression(values[0])
	puts type_expr[1]
	# Los identificadores unicamente pueden ser booleanos o numeros
	if !$error
		while type_expr[1] do
			evalInstr(values[1])
			type_expr = evalExpression(values[0])
		end
	end
end

# evalua la iteracion determinada
def evalIterDet(expr) 
	symbol = expr.get_symbol
	values = expr.get_values
	symbol2 = evalExpression(values[1])
	if !$error
		symbol3 = evalExpression(values[2])
		if !$error
			if values[0] != nil
				identif = values[0].get_value
				$tables.addscope
				$tables.insert(:INTEGER,identif,symbol2[1])
				$ftables << [$tables.get_actual,$alcance]

				i  = $tables.lookup(identif)[1]
				max = [symbol3[1]-symbol2[1]+1,0].max
				while i < max do
					evalInstr(values[3])
					$tables.update(:INTEGER,identif,i+1)
					i = $tables.lookup(identif)[1]
				end
				$tables.endscope
			else
				i = symbol2[1]
				max = [symbol3[1]-symbol2[1]+1,0].max
				for j in i..max 
					evalInstr(values[3])
				end
			end
		end
	end
end

# evalua la estructura de la expresion
def evalExpression(expr)
	exprs = expr.get_expr
	if expr.class == EXPR_VALUE
		symbol = exprs.get_symbol
		identif = exprs.get_value
		if symbol == :IDENTIFIER
			symbol = $tables.lookup(identif)
			if symbol[1] != nil
				return symbol
			else
				puts "ERROR: variable `#{identif}` no inicializada"
				$error = true
				return [:UNKNOW,nil]
			end
		end
		return [symbol,identif] 

	# Caso que sea una expresion binaria
	elsif expr.class == EXPR_BIN
		arit = expr.get_arit
		symbol1 = evalExpression(exprs[0])
		symbol2 = evalExpression(exprs[1])
		# Chequea todos los tipos de expresiones binarias aritmeticas
		# Para cada caso, asegura que sean correctas
		if !$error
			case arit
			when :PLUS , :MINUS, :DIVISION, :MULTIPLY, :PERCENT
				expr_eval = expr.get_eval(arit,symbol1[1],symbol2[1])
				if !$error	
					if expr_eval > 2147483647 || expr_eval < -2147483647
						puts "ERROR: overflow numero de 32 bits excedido"
						$error = true
						return [:UNKNOW,nil]
					else
						return [symbol1[0],expr_eval]
					end
				end
			when :AND, :OR
				expr_eval = expr.get_eval(arit,symbol1[1],symbol2[1])
				return [symbol1[0],expr_eval]
			when :AMPERSAND, :VIRGUILE 
				expr_eval = expr.get_eval(arit,symbol1[1],symbol2[1])
				if expr_eval == nil
					if arit == :AMPERSAND 
						puts "ERROR: concatenacion vertical incorrecta tamano incompatible"
					else
						puts "ERROR: concatenacion horizontal incorrecta tamano incompatible"
					end
					$error = true
					return [:UNKNOW,nil]
				end
				return [symbol1[0],expr_eval]
			when :LESS, :LESS_EQUAL, :MORE, :MORE_EQUAL
				expr_eval = expr.get_eval(arit,symbol1[1],symbol2[1])
				return [:BOOLEAN,expr_eval]
			when :EQUAL, :INEQUAL
				expr_eval = expr.get_eval(arit,symbol1[1],symbol2[1])
				return [:BOOLEAN,expr_eval]
			end
		end
		# Caso que sea una expresion unaria
	elsif expr.class == EXPR_UNARIA
		arit = expr.get_arit
		symbol1 = evalExpression(exprs)
		# evalua las expresiones unarias aritmeticas
		# Para cada caso, chequea que sean correctas
		if !$error 
			case arit
			when :MINUS_UNARY
				expr_eval = expr.get_eval(arit,symbol1[1])
				return [symbol1[0],expr_eval]
			when :DOLLAR, :APOSTROPHE 
				expr_eval = expr.get_eval(arit,symbol1[1])
				return [symbol1[0],expr_eval]
			when :NOT
				expr_eval = expr.get_eval(arit,symbol1[1])
				return [symbol1[0],expr_eval]
			end
		end
	# En caso de conseguir expresiones parentizadas, evalua la expresion
	elsif expr.class == EXPR_PARENTHESIS
		return evalExpression(exprs)
	end
end