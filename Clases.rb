# Clases a ser Tomadas para el arbol sintactico

class S 
	def initialize(estruct)
		@estruct = [estruct]

	end

	def print_tree
		puts "Arbol: "
		@estruct.each do |estruct|
			estruct.print_tree
		end
	end
end

class ESTRUCT 
	def initialize(dec=nil,instr)
		@estruct = [dec,instr]
	end

	def print_tree
		puts "| ESTRUCT: "
		@estruct.each do |estruct|
			if estruct != nil
				estruct.print_tree
			end
		end
	end
end

class INSTR
	def initialize(instr1=nil,instr2)
		@instr = [instr1,instr2]
	end

	def print_tree
		puts "| | INSTR: "
		@instr.each do |instr|
			if instr != nil
				instr.print_tree
			end
		end
	end
end

class WRITE
	def initialize(expr)
		@write = [expr]
	end

	def print_tree
		puts "| | | WRITE: "
		@write.each do |write|
			write.print_tree
		end
	end
end

class EXPR_IDENT
	def initialize(identf)
		@expr = [identf]
	end

	def print_tree
		puts "| | | | EXPR: "
		@expr.each do |expr|
			if expr != nil
				expr.print_tree
			end
		end
	end
end

class IDENTIF
	def initialize(val)
		@identif = [val]
	end

	def print_tree
		puts "| | | | | IDENTIF: "
		@identif[0].print_tree
	end
end

class LIEN
	def initialize(canvas)
		@canvas = canvas
	end

	def print_tree
		print "| | | | | | LIENZO: "
		puts "#{@canvas}"
	end
end