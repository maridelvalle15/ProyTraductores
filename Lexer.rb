#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	30/04/2015

require "./Token.rb"

class Lexer
	def initialize
		@tokens = Array.new
		@invalids = Array.new
	end

	def print
		@tokens.each do |token|
			puts "token #{token.get_type} value (#{token.get_value}) at line: #{token.get_nline}, column: #{token.get_ncolumn}" 
		end
	end
	def read(file)
		nline = 0
		comment = false
		# El else del case no me sirve. Se me ocurre usar un booleano asi tipo el de comment
		# Con ese booleano entramos en un if para ver si hay error, y hacer break de los case o algo asi
		# A menos que logremos arreglar eso
		file.each_line do |line|
			nline +=1
			ncolumn = 1

			while line != ""				
				case line
				when /^\{\-/
					comment = true
					word = line[/^\{\-/]
					line = line.partition(word).last
					ncolumn += word.size()

				when /^\-\}/
					comment = false
					word = line[/^\-\}/]
					line = line.partition(word).last
					ncolumn += word.size()

				when /^(true|false|\\\/|\/\\|\^)/
					word = line[/^(true|false|\\\/|\/\\|\^)/]
					line = line.partition(word).last
					if !comment then
						if word == "true" then
							@tokens << Token.new("TRUE",word,nline,ncolumn)
						elsif word == "false" then
							@tokens << Token.new("FALSE",word,nline,ncolumn)
						elsif word == "\^" then
							 @tokens << Token.new("BOOLEAN OPERATION",word,nline,ncolumn)
						elsif word == "\\\/" then
							@tokens << Token.new("BOOLEAN OPERATION",word,nline,ncolumn)
						elsif word == "\/\\" then
							@tokens << Token.new("BOOLEAN OPERATION",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()

				when /^(read|write)/
					word = line[/^(read|write)/]
					line = line.partition(word).last
					if !comment then
						if word == "read"
							@tokens << Token.new("READ",word,nline,ncolumn)
						elsif word == "write"
							@tokens << Token.new("WRITE",word,nline,ncolumn)
					 	end
					 end
					 ncolumn += word.size()
					 
				when /^[a-zA-Z][a-zA-Z0-9_]*/
					word = line[/^[a-zA-Z][a-zA-Z0-9_]*/]
					line = line.partition(word).last
					if !comment then
						@tokens << Token.new("INDENTIFIER",word,nline,ncolumn)
					end
					ncolumn += word.size()

				when /^[0-9][0-9]*/
					word = line[/^[0-9][0-9]*/]
					line = line.partition(word).last
					if !comment then
						@tokens << Token.new("NUMBER",word,nline,ncolumn)
					end
					ncolumn += word.size()
					
				when /^(<(\||\\|\/|\-|\_|\s)>|#)/
					word = line[/^(<(\||\\|\/|\-|\_|\s)>|#)/]
					line = line.partition(word).last
					if !comment then
						if word == "#" then 
							@tokens << Token.new("CANVAS",word,nline,ncolumn)
						else
							@tokens << Token.new("CANVAS",word[1],nline,ncolumn)
						end
					end
					ncolumn += word.size()

				when /^>=/
					word = line[/^>=/]
					line = line.partition(word).last
					if !comment then
						if word == ">="
							@tokens << Token.new("MORE EQUAL",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()
				when /^<=/
					word = line[/^<=/]
					line = line.partition(word).last
					if !comment then
						if word == "<="
							@tokens << Token.new("LESS EQUAL",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()
				when /^!=/
					word = line[/^!=/]
					line = line.partition(word).last
					if !comment then
						if word == "!="
							@tokens << Token.new("INEQUAL",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()
				
				when /^>/
					word = line[/^>/]
					line = line.partition(word).last
					if !comment then
						if word == ">"
							@tokens << Token.new("MORE",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()
				when /^</
					word = line[/^</]
					line = line.partition(word).last
					if !comment then
						if word == "<"
							@tokens << Token.new("LESS",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()
				when /^=/
					word = line[/^=/]
					line = line.partition(word).last
					if !comment then
						if word == "="
							@tokens << Token.new("EQUAL",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()
				
				when /^[!%@]/
					word = line[/^[!%@]/]
					line = line.partition(word).last
					if !comment then
						if word == "!"
							@tokens << Token.new("EXCLAMATION MARK",word,nline,ncolumn)
						elsif word == "%"
							@tokens << Token.new("PERCENT",word,nline,ncolumn)
						elsif word == "@"
							@tokens << Token.new("AT",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()

				when /^(\+|-|\*|\/)/
					word = line[/^(\+|-|\*|\/)/]
					line = line.partition(word).last
					if !comment then
						if word == "\+"
							@tokens << Token.new("PLUS",word,nline,ncolumn)
						elsif word == "-"
							@tokens << Token.new("MINUS",word,nline,ncolumn)
						elsif word == "\*"
							@tokens << Token.new("TIMES",word,nline,ncolumn)
						elsif word == "\/"
							@tokens << Token.new("OBELUS",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()

				when /^[:|$']/
					word = line[/^[:|$']/]
					line = line.partition(word).last
					if !comment then
						if word == ":"
							@tokens << Token.new("COLON",word,nline,ncolumn)
						elsif word == "|"
							@tokens << Token.new("PIPE",word,nline,ncolumn)
						elsif word == "$"
							@tokens << Token.new("DOLLAR",word,nline,ncolumn)
						elsif word == "'"
							@tokens << Token.new("APOSTROPHE",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()

				when /^[\{\}\[\]\(\)\?;]/
					word = line[/^[\{\}\[\]\(\)\?;]/]
					line = line.partition(word).last
					if !comment then
						if word == "{"
							@tokens << Token.new("LCURLY",word,nline,ncolumn)
						elsif word == "}"
							@tokens << Token.new("RCURLY",word,nline,ncolumn)
						elsif word == "["
							@tokens << Token.new("LBRACKET",word,nline,ncolumn)
						elsif word == "]"
							@tokens << Token.new("RBRACKET",word,nline,ncolumn)
						elsif word == "("
							@tokens << Token.new("LPARENTHESIS",word,nline,ncolumn)
						elsif word == ")"
							@tokens << Token.new("RPARENTHESIS",word,nline,ncolumn)
						elsif word == "?"
							@tokens << Token.new("INTERROGATION MARK",word,nline,ncolumn)
						elsif word == ";"
							@tokens << Token.new("SEMI COLON",word,nline,ncolumn)
						end
					end
					ncolumn += word.size()

				when /^\s/
					line = line.partition(/^\s/).last
					ncolumn += 1
				end
			end
		end	
	end
end