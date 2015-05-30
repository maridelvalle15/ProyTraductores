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
	: ESTRUCT { result = S.new(:S,val[0]); result.print_tree(0)}
	;

	# Estructura 
	ESTRUCT
	: LCURLY DEC PIPE INSTR RCURLY { result = ESTRUCT.new(:DEC,val[1],:INSTR,val[3]) }
	| LCURLY INSTR RCURLY  		   { result = ESTRUCT.new(nil,nil,:INSTR,val[1]) }  
	;

	# Declaraciones
	DEC
	: DEC TIPO LISTIDENT  			{result = DECLARATION.new(:DEC,val[0],:TIPO,val[1],:LISTIDENT,val[2])}
	| TIPO LISTIDENT 	 			{result = DECLARATION.new(nil,nil,:TIPO,val[0],:LISTIDENT,val[1])}
	;

	# Tipos 
	TIPO
	: EXCLAMATION_MARK  {result = TIPO.new(:BOOLEAN,val[0])}
	| PERCENT  			{result = TIPO.new(:INTEGER,val[0])}
	| AT 				{result = TIPO.new(:LIENZO,val[0])}
	;

	# Identificadores
	LISTIDENT
	: LISTIDENT VARIABLE {result = LISTIDENT.new(:LISTIDENT,val[0],:VARIABLE,val[1])}
	| VARIABLE 		   	 {result = LISTIDENT.new(nil,nil,:VARIABLE,val[0])}
	;

	#Variable
	VARIABLE 
	: IDENTIFIER 	{ result = IDENTIFICADOR.new(:IDENTIFIER,val[0])}
	;

	# Instrucciones
	INSTR
	: INSTR SEMI_COLON INSTR 	{ result = INSTR.new(:INSTR,val[0],:INSTR,val[2]) }
	| ASSIGN 	 				{ result = INSTR.new(:ASSIGN,val[0],nil,nil) }
	| READ VARIABLE   			{ result = WRITE_READ.new(:READ,val[1]) }
	| WRITE EXPR  				{ result = WRITE_READ.new(:WRITE,val[1]) }
	| CONDIC 					{ result = INSTR.new(:CONDIC,val[0],nil,nil) }
	| ITERIND 					{ result = INSTR.new(:ITERIND,val[0],nil,nil) }
	| ITERDET 					{ result = INSTR.new(:ITERDET,val[0],nil,nil) }
	| ESTRUCT 					{ result = INSTR.new(:ESTRUCT,val[0],nil,nil) }
	;

	#Asignacion
	ASSIGN
	: VARIABLE EQUAL EXPR 		{result = ASSIGN.new(:VARIABLE,val[0],:EXPR,val[2])}
	;
 
	#Condicional
	CONDIC
	: LPARENTHESIS EXPR INTERROGATION_MARK INSTR RPARENTHESIS  				{result = CONDITIONAL.new(:CONDITION,val[1],:THEN,val[3],nil,nil)}	
	| LPARENTHESIS EXPR INTERROGATION_MARK INSTR COLON INSTR RPARENTHESIS  	{result = CONDITIONAL.new(:CONDITION,val[1],:THEN,val[3],:ELSE,val[5])}
	;

	#Iteracion indeterminada
	ITERIND
	: LBRACKET EXPR PIPE INSTR RBRACKET {result = ITERIND.new(:WHILE,val[1],:DO,val[3])}
	;

	#Iteracion determinada
	ITERDET
	: LBRACKET EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET 				{result = ITERDET.new(nil,nil,:EXPR,val[1],:EXPR,val[3],:INSTR,val[5])}
	| LBRACKET VARIABLE COLON EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET  {result = ITERDET.new(:VARIABLE,val[1],:EXPR,val[3],:EXPR,val[5],:INSTR,val[7])}
	;

	#Expresiones Aritmeticas
	EXPR
	: IDENTIFICADOR 					{result = EXPR_IDENT.new(:IDENTIFICADOR,val[0])}
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

	IDENTIFICADOR
	: NUM 		{result = IDENTIF.new(:NUM,val[0])}
	| BOOL		{result = IDENTIF.new(:BOOL,val[0])}
	| LIEN 		{result = IDENTIF.new(:LIEN,val[0])}
	| VARIABLE 	{result = IDENTIF.new(:VARIABLE,val[0])}
	;

	NUM 
	: NUMBER	{ result = IDENTIFICADOR.new(:NUMBER,val[0])}
	;

	BOOL
	: TRUE		{ result = IDENTIFICADOR.new(:TRUE,val[0])}
	| FALSE		{ result = IDENTIFICADOR.new(:FALSE,val[0])}
	;

	LIEN
	: CANVAS  	{ result = IDENTIFICADOR.new(:CANVAS,val[0])}
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