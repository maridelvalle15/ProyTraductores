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

# Clases utilizadas por el parser para crear el arbol sintactico abstracto

# Clase que representa la regla del programa principal

require "./Table.rb"
require "./TableSymbol.rb"

$table = Table.new() # Definir una varible global llamada tabla
$nivel = 0
$ftable = []
$error = false

# Luego de realizar parseo, se comienza a crear el arbol abstracto sintactico. 
# Debe verificar la estructura del programa
def verifyAST(ast)
	ast.print_tree(0)
	puts
	verifyEstruct(ast.get_estruct)
	if !$error
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
		$ftable << [$table.get_actual,$nivel]
		verifyInstr(estruct.get_instr)
		if !$error
			$table.endscope
			$nivel -= 1
		end
	end
end

# Chequea las declaraciones del programa
def verifyDeclaration(declaration)
	if declaration == nil
	# Si hay declaracon, llama recursivamente a la funcion
	elsif declaration != nil
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
					$nivel += 1
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
		puts "Identificador #{identif} no declarado"
		return nil
	# Si lo consigue, verifica que la asignacion corresponda con el tipo
	else 
		symbol_identif = $table.lookup(identif)
		symbol_expr = verifyExpression(values[1])
		if symbol_identif == symbol_expr
			puts "Comparacion asignacion correcta"
		else
			puts "Comparacion asignacion incorrecta"
		end
	end
end

# Verificar la estructura del write
def verifyWrite(expr)
	symbol= verifyExpression(expr)
	# Unicamente se pueden escribir lienzos
	if symbol==:CANVAS
		#puts "Comparacion asignacion correcta"
	else
		puts "instrucción`write`espera tipo`CANVAS`y obtuvo`#{symbol}."
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
		puts "Tipo de expression invalida distinta de identificador booleano o numero"
		return nil
	end
end

# Verifica la estructura de los condicionales
def verifyConditional(expr)
	symbol = expr.get_symbol
	values = expr.get_values
	# Los identificadores unicamente pueden ser booleanos o numeros
	if verifyExpression(values[0]) == :BOOLEAN
		verifyInstr(values[1])
		if values[2] != nil
			verifyInstr(values[2])
		end
	else
		puts "Tipo de expression invalida distinta de identificador booleano o numero"
		return nil
	end
end

# Verifica la iteracion indeterminada
def verifyIterInd(expr)
	symbol = expr.get_symbol
	values = expr.get_values
	# Los identificadores unicamente pueden ser booleanos o numeros
	if verifyExpression(values[0]) == :BOOLEAN
		verifyInstr(values[1])
		if values[2] != nil
			verifyInstr(values[2])
		end
	else
		puts "Tipo de expression invalida distinta de identificador booleano o numero"
		return nil
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
		if !$table.lookup(identif)
			puts "Identificador #{identif} no declarado"
			return nil
		# Busca el identificador en la tabla y chequea el tipo (entero)
		else 
			symbol1 = $table.lookup(identif)
			if symbol1 == :INTEGER
				if symbol2 == :INTEGER and symbol3 ==:INTEGER
					verifyInstr(values[3])
				# En caso que no se cumpla que ambas expresiones sean aritmeticas
				else 
					puts "No son expressiones aritmeticas"
				end
			else
				puts "Tipo de expression invalida distinta de identificador numero"
				return nil
			end
		end
	else
		if symbol2 == :INTEGER && symbol3 ==:INTEGER
			verifyInstr(values[3])
		# En caso que no se cumpla que ambas expresiones sean aritmeticas
		else 
			puts "No son expressiones aritmeticas"
		end
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
				puts "Identificador #{identif} no declarado"
				return nil
			else 
				symbol = $table.lookup(identif)
				#puts symbol
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
			#puts symbol1
			symbol2 = verifyExpression(exprs[1])
			#puts symbol2
			if symbol1 == :INTEGER and symbol2 == :INTEGER
				return symbol1
			else
				puts "Las expressiones integer no concuerdan"
			end
		when :AND, :OR
			symbol1 = verifyExpression(exprs[0])
			#puts symbol1
			symbol2 = verifyExpression(exprs[1])
			#puts symbol2
			if symbol1 == :BOOLEAN and symbol2 == :BOOLEAN
				return symbol1
			else
				puts "Las expressiones boolean no concuerdan"
			end
		when :AMPERSAND, :VIRGUILLE
			#puts "ENTRA"
			symbol1 = verifyExpression(exprs[0])
			#puts symbol1
			symbol2 = verifyExpression(exprs[1])
			#puts symbol2
			if symbol1 == :CANVAS and symbol2 == :CANVAS
				return symbol1
			else
				puts "Las expressiones canvas no concuerdan"
			end
		when :LESS, :LESS_EQUAL, :MORE, :MORE_EQUAL, :EQUAL, :INEQUAL
			symbol1 = verifyExpression(exprs[0])
			#puts symbol1
			symbol2 = verifyExpression(exprs[1])
			#puts symbol2
			if symbol1 == symbol2 
				return :BOOLEAN
			else
				puts "Las expressiones igualdad no concuerdan"
			end
		else
			puts "ERROR"
		end
	# Caso que sea una expresion unaria
	elsif expr.class == EXPR_UNARIA
		arit = expr.get_arit
		# Verifica las expresiones unarias aritmeticas
		# Para cada caso, chequea que sean correctas
		case arit
		when :MINUS_UNARY
			symbol1 = verifyExpression(exprs)
			#puts symbol1
			if symbol1 == :INTEGER
				return symbol1
			else
				puts "Las expressiones integer no es valida"
			end
		when :DOLLAR, :APOSTROPHE
			symbol1 = verifyExpression(exprs)
			#puts symbol1
			if symbol1 == :CANVAS
				return symbol1
			else
				puts "Las expressiones canvas no concuerdan"
			end
		when :NOT
			symbol1 = verifyExpression(exprs)
			#puts symbol1
			if symbol1 == :BOOLEAN
				return symbol1
			else
				puts "Las expressiones canvas no concuerdan"
			end
		end
	# En caso de conseguir expresiones parentizadas, verifica la expresion
	elsif expr.class == EXPR_PARENTHESIS
		return verifyExpression(exprs)
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
			puts "Tipo identificador #{identif} invalido"
			return nil
		end
	else
		puts "Identificador #{identif} no contenido en la tabla de simbolos"
		return nil
	end
end