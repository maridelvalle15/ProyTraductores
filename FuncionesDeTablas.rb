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

require "./Table.rb"
require "./TableSymbol.rb"

$table = Table.new() # Definir una varible global llamada tabla

def verifyAST(ast)
	ast.print_tree(0)
	puts
	verifyEstruct(ast.get_estruct)
end

def verifyEstruct(estruct)
	verifyDeclaration(estruct.get_dec)
	puts "Tabla Actual"
	$table.print_actual
	puts
	verifyInstr(estruct.get_instr)
	$table.endscope
end

def verifyDeclaration(declaration)
	if declaration == nil
		return nil
	elsif declaration != nil
		verifyDeclaration(declaration.get_dec)
		type = declaration.get_type.get_symbol
		verifyListident(type,declaration.get_listident)
	end
end

def verifyListident(type,listident)
	if listident.get_listident != nil
		verifyListident(type,listident.get_listident)
	end
	variable = listident.get_variable
	$table.insert(type,variable.get_value)
end

def verifyInstr(instr)
	if instr.class == WRITE_READ
		symbol = instr.get_symbol
		case symbol
		when :WRITE
			verifyWrite(instr.get_instr)
		when :READ
			verifyRead(instr.get_instr)
		end
	elsif instr.class == INSTR
		
		instrs = instr.get_instr
		symbols = instr.get_symbol
		for i in 0..1
			if symbols[i] != nil
				case symbols[i]
				when :INSTR
					verifyInstr(instrs[i])
				when :ESTRUCT
					$table.addscope
					verifyEstruct(instrs[i])
				when :ASSIGN
					verifyAssign(instrs[i])
				when :CONDIC
					verifyConditional(instrs[i])
				when :ITERIND
					verifyIterInd(instrs[i])
				when :ITERDET
					verifyIterDet(instrs[i])
				end
			end
		end
	end
end

def  verifyAssign(instr)
	symbol = instr.get_symbol
	values = instr.get_values
	identif = values[0].get_value
	if !$table.lookup(identif)
		puts "Identificador #{identif} no declarado"
		return nil
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

def verifyWrite(expr)
	symbol= verifyExpression(expr)
	if symbol==:CANVAS
		puts "Comparacion asignacion correcta"
	else
		puts "Comparacion asignacion incorrecta"
	end
end

def verifyRead(expr)
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

def verifyConditional(expr)
	symbol = expr.get_symbol
	values = expr.get_values
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

def verifyIterInd(expr)
	symbol = expr.get_symbol
	values = expr.get_values
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

def verifyIterDet(expr)
	symbol = expr.get_symbol
	values = expr.get_values
	symbol2 = verifyExpression(values[1])
	symbol3 = verifyExpression(values[2])
	if values[0] != nil
		identif = values[0].get_value
		if !$table.lookup(identif)
			puts "Identificador #{identif} no declarado"
			return nil
		else 
			symbol1 = $table.lookup(identif)
			if symbol1 == :INTEGER
				if symbol2 == :INTEGER and symbol3 ==:INTEGER
					verifyInstr(values[3])
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
		else 
			puts "No son expressiones aritmeticas"
		end
	end
end

def verifyExpression(expr)
	exprs = expr.get_expr
	if expr.class == EXPR_VALUE
		symbol = exprs.get_symbol
		identif = exprs.get_value
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
	elsif expr.class == EXPR_BIN
		arit = expr.get_arit
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
			puts symbol1
			symbol2 = verifyExpression(exprs[1])
			puts symbol2
			if symbol1 == symbol2 
				return :BOOLEAN
			else
				puts "Las expressiones igualdad no concuerdan"
			end
		else
			puts "ERROR"
		end
	elsif expr.class == EXPR_UNARIA
		arit = expr.get_arit
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
	elsif expr.class == EXPR_PARENTHESIS
		return verifyExpression(exprs)
	end
end

def verifyIdentifierINT_BOOL(expr)
	identif = expr.get_value
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