#!/usr/bin/env ruby

class Parser

	token 	
		TRUE FALSE READ WRITE IDENTIFIER NUMBER NOT OR AND 
		EMPTY_CANVAS CANVAS MORE_EQUAL LESS_EQUAL INEQUAL MORE 
		LESS EQUAL EXCLAMATION_MARK PERCENT AT PLUS MINUS 
		TIMES OBELUS COLON PIPE DOLLAR APOSTROPHE AMPERSAND 
		VIRGUILE LCURLY RCURLY LBRACKET RBRACKET LPARENTHESIS 
		RPARENTHESIS INTERROGATION_MARK SEMI_COLON DOUBLE_DOT
	rule

	#Programa Principal
	PROGRAM 
	: ESTRUCT { result = [:ESTRUCT,val[1]]; return result }
	;

	# Estructura 
	ESTRUCT
	: LCURLY DEC PIPE INSTR RCURLY { result = [[:DEC,val[1]],[:INSTR,val[2]]] }
	| LCURLY INSTR RCURLY  		   { result = [:INSTR,val[0]] }
	;

	# Declaraciones
	DEC
	: DEC TIPO LISTIDENT  	{ result = [[:DEC,val[2],[:TIPO,val[0]],[:LISTIDENT,val[1]]]] }
	| TIPO LISTIDENT 	 	{ result = [[:TIPO,val[0],[:LISTIDENT,val[1]]]] }
	;

	# Tipos 
	TIPO
	: EXCLAMATION_MARK  { result = :BOOL } 
	| PERCENT  			{ result = :INTEGER } 
	| AT 				{ result = :LIENZO }
	;

	# Identificadores
	LISTIDENT
	: LISTIDENT IDENTIFIER  { result = [[:LISTIDENT,val[0],[:IDENTIFIER,val[1]]]] }
	| IDENTIFIER 		   	{ result = [:IDENTIFIER,val[0]] }
	;

	# Instrucciones
	INSTR
	: ASSIGN 	{ result = [:ASSIGN,val[0]] }
	| SEC 		{ result = [:SEC, val[0]] }
	| ENTR 		{ result = [:ENTR, val[0]] }
	| SAL 		{ result = [:SAL,val[0]] }
	| CONDIC 	{ result = [:CONDIC,val[0]] }
	| ITERIND 	{ result = [:ITERIND,val[0]] }
	| ITERDET 	{ result = [:ITERDET,val[0]] }
	| ESTRUCT 	{ result = [:ESTRUCT,val[0]] }
	;

	#Asignacion
	ASSIGN
	: IDENTIFIER EQUAL EXPR { result = [[:IDENTIFIER,val[0]],[:EXPR,val[2]]] }
	;

	#Secuenciacion
	SEC
	: INSTR SEMI_COLON SEC  { result = [[:INSTR,val[0]],[:SEC,val[2]]] }
	| INSTR  				{ result = [:INSTR,val[0]] }
	;

	# Entrada
	ENTR
	: READ IDENTIFIER { result = [:READ,[:IDENTIFIER,val[1]]] }
	;

	#Salida
	SAL
	: WRITE EXPR { result = [:WRITE,[:IDENTIFIER,val[1]]] }
	;

	#Condicional
	CONDIC
	: LPARENTHESIS EXPR INTERROGATION_MARK INSTR RCURLY 			{ result = [[:EXPR,val[1]],[:INSTR,val[3]]] }
	| LPARENTHESIS EXPR INTERROGATION_MARK INSTR COLON INSTR RCURLY { result = [[:EXPR,val[1]],[:INSTR,val[3]],[:INSTR,val[5]]] }
	;

	#Iteracion indeterminada
	ITERIND
	: LBRACKET EXPR PIPE INSTR RBRACKET { result = [[:EXPR,val[1]],[:INSTR,val[3]]] }
	;

	#Iteracion determinada
	ITERDET
	: LBRACKET EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET 					{ result = [[:EXPR,val[1]],[:EXPR,val[3]],[:INSTR,val[5]]] }
	| LBRACKET IDENTIFIER COLON EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET 	{ result = [[:IDENTIFIER,val[1]],[:EXPR,val[3]],[:EXPR,val[5]],[:INSTR,val[7]]] }
	;

	#Expresiones Aritmeticas
	EXPR
	: EXPR PLUS EXPR 				{ result = [:PLUS,val[0],val[2]] }
	| EXPR MINUS EXPR 				{ result = [:MINUS,val[0],val[2]] }
	| EXPR TIMES EXPR 				{ result = [:TIMES,val[0],val[2]] }
	| EXPR OBELUS EXPR 				{ result = [:OBELUS,val[0],val[2]] } 
	| EXPR PERCENT EXPR 			{ result = [:PERCENT,val[0],val[2]] }
	| MINUS EXPR 					{ result = [:MINUS,val[1]] }
	| EXPR AND EXPR 				{ result = [:AND,val[0],val[2]] }
	| EXPR OR EXPR 					{ result = [:OR,val[0],val[2]] }
	| NOT EXPR 						{ result = [:NOT,val[1]] }
	| EXPR LESS EXPR 				{ result = [:LESS,val[0],val[2]] }
	| EXPR LESS_EQUAL EXPR 			{ result = [:LESS_EQUAL,val[0],val[2]] }
	| EXPR MORE EXPR 				{ result = [:MORE,val[0],val[2]] } 
	| EXPR MORE_EQUAL EXPR 			{ result = [:MORE_EQUAL,val[0],val[2]] }
	| EXPR EQUAL EXPR 				{ result = [:EQUAL,val[0],val[2]] }
	| EXPR INEQUAL EXPR 			{ result = [:INEQUEAL,val[0],val[2]] }
	| EXPR AMPERSAND EXPR 			{ result = [:AMPERSAND,val[0],val[2]] } 
	| EXPR VIRGUILE EXPR 			{ result = [:VIRGUILE,val[0],val[2]] }
	| DOLLAR EXPR 					{ result = [:DOLLAR,val[1]] }
	| EXPR APOSTROPHE 				{ result = [:APOSTROPHE,val[1]] }
	| VALORES 						{ result = [:VALORES,val[0]] }
	;

	VALORES
	: NUMEROS 	{ result = [:NUMEROS,val[0]]}
	| BOOLEAN 	{ result = [:BOOLEAN,val[0]]}
	| LIENZO 	{ result = [:LIENZO,val[0]]}
	| VARIABLE 	{ result = [:VARIABLE,val[0]]}
	;

	NUMEROS
	: NUMBER 	{ result = [:NUMBER,val[0]]}
	;

	BOOLEAN
	: TRUE 	{ result = [:TRUE,val[0]] }
	| FALSE { result = [:FALSE,val[0]] }
	;

	LIENZO
	: CANVAS { result = [:CANVAS,val[0]] }
	;

	VARIABLE
	: IDENTIFIER { result = :IDENTIFIER,val[0]}
	;

end

---- inner 

	def initialize(tokens)
		@tokens = tokens
	end

	def parser
		do_parse
	end

	def next_token
		@tokens.next_token
	end