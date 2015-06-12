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

require "./TableSymbol.rb"

def verificarTablas(ast,table)
	ast.print_tree(0)
	table.print
	print "entra"
	estruct = ast.get_estruct
	dec = estruct.get_dec
	if dec == nil
		decla = dec.get_dec
		type = dec.get_type
		listident = dec.get_listident
		if decla == nil
			symbol = type.get_symbol
			listident1 = listident.get_listident
			if listident == nil
				variable = listident.get_variable
				tabla.insert(type,variable)
			end
		end
	end
	tabla.print
end