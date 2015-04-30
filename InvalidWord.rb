#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	29/04/1993

class InvalidWord
	def initialize(value,nline,ncolumn)
		@value = value
		@nline = nline
		@ncolumn = ncolumn
	end

	def get_value
		return @value
	end

	def get_nline
		return @nline
	end

	def get_ncolumn
		return @ncolumn
	end
end