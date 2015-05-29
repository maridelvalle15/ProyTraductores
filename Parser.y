#!/usr/bin/env ruby



class Parser

	prechigh
		left SEMI_COLON
		left INTERROGATION_MARK
		left COLON
		left DOUBLE_DOT
		left PIPE
		nonassoc MINUS_UNARY # - unario 
		left MULTIPLY DIVISION PERCENT
		left PLUS MINUS
		nonassoc LESS_EQUAL LESS MORE MORE_EQUAL
		nonassoc EQUAL INEQUAL
		right NOT
		left AND
		left OR
		right APOSTROPHE 
		left DOLLAR
		left VIRGUILE AMPERSAND
	preclow


	token 	
		TRUE FALSE READ WRITE IDENTIFIER NUMBER NOT OR AND 
		EMPTY_CANVAS CANVAS MORE_EQUAL LESS_EQUAL INEQUAL MORE 
		LESS EQUAL EXCLAMATION_MARK PERCENT AT PLUS MINUS 
		MULTIPLY DIVISION COLON PIPE DOLLAR APOSTROPHE AMPERSAND 
		VIRGUILE LCURLY RCURLY LBRACKET RBRACKET LPARENTHESIS 
		RPARENTHESIS INTERROGATION_MARK SEMI_COLON DOUBLE_DOT
	rule

	#Programa principal
	S 
	: ESTRUCT { result = S.new(val[0]); result.print_tree}
	;

	# Estructura 
	ESTRUCT
	: LCURLY DEC PIPE INSTR RCURLY { result = ESTRUCT.new(val[1],val[3]) }
	| LCURLY INSTR RCURLY  		   { result = ESTRUCT.new(nil,val[1]) }  
	;

	# Declaraciones
	DEC
	: DEC TIPO LISTIDENT  	
	| TIPO LISTIDENT 	 	
	;

	# Tipos 
	TIPO
	: EXCLAMATION_MARK  
	| PERCENT  			
	| AT 				
	;

	# Identificadores
	LISTIDENT
	: LISTIDENT VARIABLE  
	| VARIABLE 		   	
	;

	#Variable
	VARIABLE 
	: IDENTIFIER
	;

	# Instrucciones
	INSTR
	: INSTR SEMI_COLON INSTR 
	| ASSIGN 	 		
	| IN  		
	| OUT  						 { result = INSTR.new(nil,val[0]) }
	| CONDIC 	
	| ITERIND 	
	| ITERDET 	
	| ESTRUCT 	
	;

	#Asignacion
	ASSIGN
	: VARIABLE EQUAL EXPR 
	;

	# Entrada
	IN
	: READ VARIABLE 
	;

	#Salida
	OUT
	: WRITE EXPR 				{ result = WRITE.new(val[1]) }
	;

	#Condicional
	CONDIC
	: LPARENTHESIS EXPR INTERROGATION_MARK INSTR RPARENTHESIS  			
	| LPARENTHESIS EXPR INTERROGATION_MARK INSTR COLON INSTR RPARENTHESIS 
	;

	#Iteracion indeterminada
	ITERIND
	: LBRACKET EXPR PIPE INSTR RBRACKET
	;

	#Iteracion determinada
	ITERDET
	: LBRACKET EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET 
	| LBRACKET VARIABLE COLON EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET 
	;

	#Expresiones Aritmeticas
	EXPR
	: IDENTIF 							{result = EXPR_IDENT.new(val[0])}
	| EXPR PLUS EXPR 
	| EXPR MINUS EXPR
 	| EXPR MULTIPLY EXPR
 	| EXPR DIVISION EXPR
	| EXPR PERCENT EXPR
	| MINUS EXPR =MINUS_UNARY
	| LPARENTHESIS EXPR RPARENTHESIS
	| EXPR AND EXPR
 	| EXPR OR EXPR
	| NOT EXPR
	| EXPR AMPERSAND EXPR
	| EXPR VIRGUILE EXPR
	| DOLLAR EXPR
	| EXPR APOSTROPHE 
	| EXPR LESS  EXPR
	| EXPR LESS_EQUAL EXPR
	| EXPR MORE EXPR
	| EXPR MORE_EQUAL EXPR
	| EXPR EQUAL EXPR
	| EXPR INEQUAL EXPR
	;

	IDENTIF
	: NUM
	| BOOL
	| LIEN 		{result = IDENTIF.new(val[0])}
	| VARIABLE
	;

	NUM 
	: NUMBER
	;

	BOOL
	: TRUE
	| FALSE
	;

	LIEN
	: CANVAS  	{ result = LIEN.new(val[0])}
	;

end

---- inner 

require "./Clases.rb"

	def initialize(tokens)
		@tokens = tokens
	end

	def parser
		do_parse
	end

	def next_token
		@tokens.next_token
	end