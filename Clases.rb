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

# Clases A hacer utilizas por el parser para crear el arbol AST

class S 
	def initialize(symbol,estruct)
		@symbol= symbol
		@estruct = [estruct]

	end

	def print_tree(num)
		@estruct.each do |estruct|
			estruct.print_tree(num)
		end
	end
end

class ESTRUCT 
	def initialize(symbol1=nil,dec=nil,symbol2,instr)
		@symbol = [symbol1,symbol2]
		@estruct = [dec,instr]
	end

	def print_tree(num)
		@estruct[1].print_tree(num)
	end
end

class INSTR
	def initialize(symbol1,instr1,symbol2=nil,instr2=nil)
		@symbol= [symbol1, symbol2]
		@instr = [instr1,instr2]
	end

	def print_tree(num)
		@instr.each do |instr|
			if instr != nil
				if @symbol[0] != :INSTR 
					for i in 1..num
						print "| "
					end
					print @symbol[0]
					puts ": "
					instr.print_tree(num+1)	
				else
					instr.print_tree(num)
				end
			end
		end
	end
end

class DECLARATION
	def initialize(symbol1=nil,dec=nil,symbol2,tipo,symbol3,listident)
		@symbol = [symbol1,symbol2,symbol3]
		@values = [dec,tipo,listident]
	end

	def print_tree(num)
		for i in 0..2
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

class TIPO
	def initialize(symbol,tipo)
		@symbol = symbol
		@tipo = tipo
	end

	def print_tree(num)
		for i in 1..num
			print "| "
		end
		print @symbol  
		print ": "
		puts @tipo
	end
end


class LISTIDENT 
	def initialize(symbol1=nil,listident=nil,symbol2,variable)
		@symbol = [symbol1,symbol2]
		@values = [listident,variable]
	end

	def print_tree(num)
		for i in 0..1
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end
				print @symbol[i]
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

class ASSIGN
	def initialize(symbol1,variable,symbol2,expr)
		@symbol = [symbol1,symbol2]
		@values = [variable,expr]
	end

	def print_tree(num)

		for i in 0..1
			for j in 1..num
				print "| "
			end
			print @symbol[i]  
			puts ": "
			@values[i].print_tree(num+1)
		end
	end
end

class WRITE_READ
	def initialize(symbol,expr)
		@symbol = symbol
		@write = [expr]
	end

	def print_tree(num)
		
		@write.each do |write|
			for i in 1..num
				print "| "
			end
			print @symbol  
			puts ": "
			write.print_tree(num+1)
		end
	end
end

class CONDITIONAL
	def initialize(symbol1,expr,symbol2,instr1,symbol3=nil,instr2=nil)
		@symbol = [symbol1,symbol2,symbol3]
		@values = [expr,instr1,instr2]
	end

	def print_tree(num)
		for i in 0..2
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

class ITERIND
	def initialize(symbol1,expr,symbol2,instr)
		@symbol = [symbol1,symbol2]
		@values = [expr,instr]
	end

	def print_tree(num)
		for i in 0..1
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end

class ITERDET
	def initialize(symbol=nil,var=nil,symbol1,expr1,symbol2,expr2,symbol3,instr)
		@symbol = [symbol,symbol1,symbol2,symbol3]
		@values = [var,expr1,expr2,instr]
	end

	def print_tree(num)
		for i in 0..3
			if @symbol[i] != nil
				for j in 1..num
					print "| "
				end 
				print @symbol[i]  
				puts ": "
				@values[i].print_tree(num+1)
			end
		end
	end
end


class EXPR_IDENT
	def initialize(symbol,identf)
		@symbol = symbol
		@expr = [identf]
	end

	def print_tree(num)
		@expr.each do |expr|
			if expr != nil
				expr.print_tree(num)
			end
		end
	end
end

class EXPR_BIN
	def initialize(symbol,val,symbol1,expr1,symbol2,expr2)
		@arit = symbol
		@val = val
		@symbol = [symbol1,symbol2]
		@expr = [expr1,expr2]
	end

	def print_tree(num)
		for k in 1..num
			print "| "
		end
		print "OPERATION: "  
		puts @val

		for i in 0..1
			@expr[i].print_tree(num+1)
		end
	end
end

class EXPR_UNARIA
	def initialize(symbol,val,symbol1,expr1)
		@arit = symbol
		@val = val
		@symbol = symbol1
		@expr = expr1
	end

	def print_tree(num)
		for k in 1..num
			print "| "
		end
		print "SIGNO: "  
		puts @val
		@expr.print_tree(num+1)
	end
end

class IDENTIF
	def initialize(symbol,val)
		@symbol = symbol
		@identif = [val]
	end

	def print_tree(num)
		@identif[0].print_tree(num)
	end
end


class IDENTIFICADOR
	def initialize(symbol,identificador)
		@symbol = symbol
		@identificador = [identificador]
	end

	def print_tree(num)
		for i in 1..num
			print "| "
		end 
		if @symbol == :CANVAS 
			print @symbol  
			print ": "
			puts "#{@identificador[0]}"
		elsif @symbol == :TRUE 
			print @symbol  
			print ": "
			puts "#{@identificador[0]}"
		elsif @symbol == :FALSE 
			print @symbol  
			print ": "
			puts "#{@identificador[0]}"
		elsif @symbol == :NUMBER 
			print @symbol  
			print ": "
			puts "#{@identificador[0]}"
		elsif @symbol == :IDENTIFIER
			print @symbol  
			print ": "
			puts "#{@identificador[0]}"
		elsif @symbol == :EMPTY_CANVAS
			print @symbol  
			print ": "
			puts "#{@identificador[0]}"
		end
	end
end