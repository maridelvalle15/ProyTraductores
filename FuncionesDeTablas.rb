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
# 	14/06/2015

# Clases utilizadas por el parser para crear el arbol sintactico abstracto

# Clase que representa la regla del programa principal

require "./Table.rb"
require "./TableSymbol.rb"

$table = Table.new() 	# Definir una varible global llamada tabla
$alcance = 0			# Definir una varible global llamada alcance
$ftable = []			# Definir una varible global llamada ftabla
$error = false			# Definir una varible global llamada error

# Luego de realizar parseo, se comienza a crear el arbol abstracto sintactico. 
# Debe verificar la estructura del programa
def verifyAST(ast)
	verifyEstruct(ast.get_estruct)
	if !$error
		#Si no hay errores se imprime toda la tabla de simbolos 
		puts "Table de simbolos: "
		$ftable.each do |ftable|
			ftable[0].print_symbols(ftable[1])
			puts
		end
	end
end

# Chequea la estructura del programa (declaraciones e instrucciones). 
# Finaliza la tabla
def verifyEstruct(estruct)
	verifyDeclaration(estruct.get_dec)
	if !$error
		#Se va insertando la tabla actual y su alcance a la varible global ftable
		$ftable << [$table.get_actual,$alcance]
		verifyInstr(estruct.get_instr)
		if !$error
			$table.endscope
			$alcance -= 1
		end
	end
end

# Chequea las declaraciones del programa
def verifyDeclaration(declaration)
	# Si hay declaracon, llama recursivamente a la funcion
	if declaration != nil
		verifyDeclaration(declaration.get_dec)
		# Obtiene el tipo de la variable declarada
		type = declaration.get_type.get_symbol
		# Verifica la lista de identificadores
		if !$error
			verifyListident(type,declaration.get_listident)
		end
	end
end

# Chequea la lista de identificadores (variables)
def verifyListident(type,listident)
	# Si no obtiene nada, llama recursivamente a la funcion
	if listident.get_listident != nil
		if !$error
			verifyListident(type,listident.get_listident)
		end
	end
	# Obtiene la variable declarada
	variable = listident.get_variable
	# Inserta la variable en la tabla junto con el tipo correspondiente 
	# Al ser una tabla de hash, la clave es la variable y el valor el tipo 
	$error = $table.insert(type,variable.get_value)
end

# Verifica quer instruccion esta leyendo
def verifyInstr(instr)
	# En caso que sea read o write
	if instr.class == WRITE_READ
		symbol = instr.get_symbol
		case symbol
		# Verifica la estructura del write
		when :WRITE
			verifyWrite(instr.get_instr)
		# Verifica la estructura del read
		when :READ
			verifyRead(instr.get_instr)
		end
	# En caso que sea una instruccion
	elsif instr.class == INSTR
		instrs = instr.get_instr
		symbols = instr.get_symbol
		# Iteracion auxiliar para recorrer la instruccion
		for i in 0..1
			# Si efectivamente hay algo que chequear
			if symbols[i] != nil
				case symbols[i]
				# Verifica la estructura de la instruccion
				when :INSTR
					verifyInstr(instrs[i])
				# Verifica la estructura del programa, en este caso se agrega
				# una tabla
				when :ESTRUCT
					$table.addscope
					$alcance += 1
					verifyEstruct(instrs[i])
				# Verifica la estructura de la asignacion
				when :ASSIGN
					verifyAssign(instrs[i])
				# Verifica la estructura del condicional
				when :CONDIC
					verifyConditional(instrs[i])
				# Verifica la estructura de la iteracion indeterminada
				when :ITERIND
					verifyIterInd(instrs[i])
				# Verifica la estructura de la iteracion determinada
				when :ITERDET
					verifyIterDet(instrs[i])
				end
			end
		end
	end
end

# Chequea las asignaciones del programa
def  verifyAssign(instr)
	symbol = instr.get_symbol
	values = instr.get_values
	identif = values[0].get_value
	# Si al buscar en la tabla, la variable no ha sido declarada, 
	# devuelve un mensaje
	if !$table.lookup(identif)
		puts "Instrucción `ASSIGN` Identificador: #{identif}, no declarado en la tabla de simbolos"
		$error = true
	# Si lo consigue, verifica que la asignacion corresponda con el tipo
	else 
		symbol_identif = $table.lookup(identif)
		symbol_expr = verifyExpression(values[1])
		if symbol_identif == symbol_expr
			##puts "Comparacion asignacion correcta"
		elsif symbol_expr == :UNKNOW
			$error = true
		else
			print "Instrucción `ASSIGN` espera tipos iguales, tipos " 
			puts "#{symbol_identif} y #{symbol_expr} encontrados."
			$error = true
		end
	end
end

# Verificar la estructura del write
def verifyWrite(expr)
	symbol= verifyExpression(expr)
	# Unicamente se pueden escribir lienzos
	if symbol==:CANVAS
		#puts "Comparacion asignacion correcta"
	elsif symbol==:UNKNOW
		$error = true
	else
		puts "Instrucción `WRITE` espera  una expresion tipo `CANVAS` y obtuvo #{symbol}."
		$error = true
	end
end

# Verifica la estructura del read
def verifyRead(expr)
	# Unicamente se pueden leer enteros o booleanos
	if expr.class == VALUE
		symbol = expr.get_symbol
		if symbol == :IDENTIFIER
			verifyIdentifierINT_BOOL(expr)
		end
	else
		puts "Instrucción `READ` espera una expresion tipo `BOOLEAN` o `INTEGER` " 
		$error = true
	end
end

# Chequea la estructura de los identificadores booleanos y/o enteros
def verifyIdentifierINT_BOOL(expr)
	identif = expr.get_value
	# Verifica en la tabla que el identificador corresponda con entero o 
	# booleano, o que simplemente no se encuentre en la tabla
	if $table.contains(identif)
		type = $table.lookup(identif)
		if type == :INTEGER || type == :BOOLEAN
		else
			print "Instrucción `READ` Identificador: #{identif}, con tipo "
			puts "distinto `BOOLEAN` o `INTEGER`"
			$error = true
		end
	else
		puts "Identificador: #{identif}, no contenido en la tabla de simbolos"
		$error = true
	end
end
# Verifica la estructura de los condicionales
def verifyConditional(expr)
	symbol = expr.get_symbol
	values = expr.get_values
	type_expr = verifyExpression(values[0])
	# Los identificadores unicamente pueden ser booleanos o numeros
	if type_expr == :BOOLEAN
	elsif type_expr == :UNKNOW
		$error = true
	else
		puts "Instrucción `CONDITIONAL` expresion tipo #{type_expr} encontrada, se espera tipo `BOOLEAN`"
		$error = true
	end
	verifyInstr(values[1])
	if values[2] != nil
		verifyInstr(values[2])
	end
end

# Verifica la iteracion indeterminada
def verifyIterInd(expr)
	symbol = expr.get_symbol
	values = expr.get_values
	type_expr = verifyExpression(values[0])
	# Los identificadores unicamente pueden ser booleanos o numeros
	if type_expr == :BOOLEAN
	elsif type_expr ==:UNKNOW
		$error = true
	else
		puts "Instrucción `ITERIND` expresion tipo #{type_expr} encontrada, se espera tipo `BOOLEAN`"
		$error = true
	end
	verifyInstr(values[1])
	if values[2] != nil
		verifyInstr(values[2])
	end
end

# Verifica la iteracion determinada
def verifyIterDet(expr)
	symbol = expr.get_symbol
	values = expr.get_values
	symbol2 = verifyExpression(values[1])
	symbol3 = verifyExpression(values[2])
	# Chequea que el identificador se encuentre en la tabla de simbolos, es 
	# decir, que este declarado
	if values[0] != nil
		identif = values[0].get_value
		$table.addscope
		$table.insert(:INTEGER,identif)
		$ftable << [$table.get_actual,$alcance]
		if symbol2 == :INTEGER and symbol3 ==:INTEGER
		# En caso que no se cumpla que ambas expresiones sean aritmeticas
		else 
			puts "Instrucción `ITERDET` expresiones con tipos diferentes a INTEGER"
			$error = true
		end
		verifyInstr(values[3])
		$table.endscope
	else
		#$table.addscope
		#$table.insert(:INTEGER,)
		if symbol2 == :INTEGER && symbol3 ==:INTEGER
		# En caso que no se cumpla que ambas expresiones sean aritmeticas
		else 
			puts "Instrucción `ITERDET` expresiones con tipos diferentes a INTEGER "
			$error = true
		end
		verifyInstr(values[3])
	end
end

# Verifica la estructura de la expresion
def verifyExpression(expr)
	exprs = expr.get_expr
	if expr.class == EXPR_VALUE
		symbol = exprs.get_symbol
		identif = exprs.get_value
		# Si consigue un identificador, lo busca en la tabla para verificar que
		# se encuentre. Si no lo encuentra, es porque no fue declarado en el
		# programa
		if symbol == :IDENTIFIER
			if !$table.lookup(identif)
				puts "Identificador #{identif} no declarado en la tabla de simbolos"
				return :UNKNOW
			else 
				symbol = $table.lookup(identif)
			end
		end
		return symbol
	# Caso que sea una expresion binaria
	elsif expr.class == EXPR_BIN
		arit = expr.get_arit
		# Chequea todos los tipos de expresiones binarias aritmeticas
		# Para cada caso, asegura que sean correctas
		case arit
		when :PLUS , :MINUS, :DIVISION, :MULTIPLY, :PERCENT
			symbol1 = verifyExpression(exprs[0])
			symbol2 = verifyExpression(exprs[1])
			if symbol1 == :UNKNOW or symbol2 == :UNKNOW 
				return :UNKNOW
			elsif symbol1 == :INTEGER and symbol2 == :INTEGER
				return symbol1
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1} y #{symbol2}"
				return :UNKNOW
			end
		when :AND, :OR
			symbol1 = verifyExpression(exprs[0])
			symbol2 = verifyExpression(exprs[1])
			if symbol1 == :UNKNOW or symbol2 == :UNKNOW 
				return :UNKNOW
			elsif symbol1 == :BOOLEAN and symbol2 == :BOOLEAN
				return symbol1
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1} y #{symbol2}"
				return :UNKNOW
			end
		when :AMPERSAND, :VIRGUILLE
			symbol1 = verifyExpression(exprs[0])
			symbol2 = verifyExpression(exprs[1])
			if symbol1 == :UNKNOW or symbol2 == :UNKNOW 
				return :UNKNOW
			elsif symbol1 == :CANVAS and symbol2 == :CANVAS
				return symbol1
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1} y #{symbol2}"
				return :UNKNOW
			end
		when :LESS, :LESS_EQUAL, :MORE, :MORE_EQUAL, :EQUAL, :INEQUAL
			symbol1 = verifyExpression(exprs[0])
			symbol2 = verifyExpression(exprs[1])
			if symbol1 == :UNKNOW or symbol2 == :UNKNOW 
				return :UNKNOW
			elsif symbol1 == symbol2 
				return :BOOLEAN
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1} y #{symbol2}"
				return :UNKNOW
			end
		end
	# Caso que sea una expresion unaria
	elsif expr.class == EXPR_UNARIA
		arit = expr.get_arit
		# Verifica las expresiones unarias aritmeticas
		# Para cada caso, chequea que sean correctas
		case arit
		when :MINUS_UNARY
			symbol1 = verifyExpression(exprs)
			if symbol1 == :UNKNOW
				return symbol1
			elsif symbol1 == :INTEGER
				return symbol1
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1}"
				return :UNKNOW
			end
		when :DOLLAR, :APOSTROPHE
			symbol1 = verifyExpression(exprs)
			if symbol1 == :UNKNOW
				return symbol1
			elsif symbol1 == :CANVAS
				return symbol1
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1}"
				return :UNKNOW
			end
		when :NOT
			symbol1 = verifyExpression(exprs)
			if symbol1 == :UNKNOW
				return symbol1
			elsif symbol1 == :BOOLEAN
				return symbol1
			else
				puts "Operador #{arit} no funcionas con operadores #{symbol1}"
				return :UNKNOW
			end
		end
	# En caso de conseguir expresiones parentizadas, verifica la expresion
	elsif expr.class == EXPR_PARENTHESIS
		return verifyExpression(exprs)
	end
end

