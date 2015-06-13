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
	verifyEstruct(ast.get_estruct)
	
end

def verifyEstruct(estruct)
	verifyDeclaration(estruct.get_dec)
	$table.print_actual
	verifyInstr(estruct.get_instr)
	#$table.endscope
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
	end
end

def verifyWrite(expr)
	if expr.class == EXPR_VALUE
		symbol = expr.get_expr.get_symbol
		puts "#{symbol}"
		if symbol == :CANVAS || symbol == :EMPTY_CANVAS
			puts "Somos nosotros"
			puts "Valor #{symbol} con valor #{expr.get_expr.get_value}"
		elsif
			symbol == :IDENTIFIER
			if $table.contains(expr.get_expr.get_value)
				type = $table.lookup(expr.get_expr.get_value)
				puts "#{type}"
				if type == :LIENZO
					puts "Somos nosotros"
					puts "Valor #{symbol} con valor #{expr.get_expr.get_value}"
				else
					puts "Tipo identificador invalido"
				end
			else
				puts "Identificador no contenido en la tabla de simbolos"
			end
		else
			puts "Tipo expr invalida"
		end
	elsif expr.class == EXPR_BIN
		arit = expr.get_arit
		case arit
		when :AMPERSAND, :VIRGUILE 
			exprs = expr.get_expr
			verifyWrite(exprs[0])
			verifyWrite(exprs[1])
		else
			puts "Operacion binaria lienzo invalida"
		end

	elsif expr.class == EXPR_UNARIA
		arit = expr.get_arit
		case arit
		when :DOLLAR, :APOSTROPHE 
			puts "Entra"
			verifyWrite(expr.get_expr)

		else
			puts "Operacion unaria lienzo invalida"
		end
	elsif expr.class == EXPR_PARENTHESIS
		verifyWrite(expr.get_expr)
	else
		puts "Tipo de expression invalida distinta de lienzo"
	end
end

def verifyRead(expr)
	if expr.class == EXPR_VALUE
		symbol = expr.get_expr.get_symbol
		puts "#{symbol}"
		symbol == :IDENTIFIER
		if $table.contains(expr.get_expr.get_value)
			type = $table.lookup(expr.get_expr.get_value)
			puts "#{type}"
			if type == :NUMBER || type == :BOOLEAN
				puts "Somos nosotros"
				puts "Valor #{symbol} con valor #{expr.get_expr.get_value}"
			else
				puts "Tipo identificador invalido"
			end
		else
			puts "Identificador no contenido en la tabla de simbolos"
		end
	else
		puts "Tipo de expression invalida distinta de identificador booleano o numero"
	end
end