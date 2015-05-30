# Clases a ser Tomadas para el arbol sintactico

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
		@estruct.each do |estruct|
			if estruct != nil
				estruct.print_tree(num)
			end
		end
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
				instr.print_tree(num)
			end
		end
	end
end

class WRITE
	def initialize(symbol,expr)
		@symbol = symbol
		@write = [expr]
	end

	def print_tree(num)
		print @symbol  
		puts ": "
		@write.each do |write|
			for i in 1..num
				print "| "
			end
			write.print_tree(num+1)
		end
	end
end

class EXPR_IDENT
	def initialize(symbol,identf)
		@symbol = symbol
		@expr = [identf]
	end

	def print_tree(num)
		print @symbol  
		puts ": "
		@expr.each do |expr|
			if expr != nil
				for i in 1..num
					print "| "
				end
				expr.print_tree(num+1)
			end
		end
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
		end
	end
end

