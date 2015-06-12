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
	#verifyInstr(estruct.get_instr)
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
	if listident.get_listident == nil
		variable = listident.get_variable
		$table.insert(type,variable.get_value)
		$table.print
	elsif listident.get_listident != nil
		verifyListident(type,listident.get_listident)
	end
end

