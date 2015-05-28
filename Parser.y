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
	: DEC TIPO LISTIDENT  	{ result = [[:DEC,val[2]],[:TIPO,val[0]],[:LISTIDENT,val[1]]] }
	| TIPO LISTIDENT 	 	{ result = [[:TIPO,val[0]],[:LISTIDENT,val[1]]] }
	;

	# Tipos 
	TIPO
	: EXCLAMATION_MARK  { result = :BOOL } #Duda si colocar el tipo
	| PERCENT  			{ result = :INTEGER } 
	| AT 				{ result = :CANVAS }
	;

	# Identificadores
	LISTIDENT
	: LISTIDENT IDENTIFIER  { result = [[:LISTIDENT,val[1]],[:IDENTIFIER,val[0]]] }
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
	| INCOR 	{ result = [:INCOR,val[0]]}
	| ESTRUCT 	{ result = [:ESTRUCT,val[0]] }
	;

	#Asignacion
	ASSIGN
	: IDENTIFIER EQUAL EXPR { result = [[:IDENTIFIER,val[0]],[:EXPR,val[2]]] }
	;

	#Secuenciacion
	SEC
	: INSTR SEMI_COLON SEC  { result = [[:INSTR,val[0]],[:SEC,val[2]] }
	| INSTR  				{ result = [:INSTR,val[0]] }
	;

	# Entrada
	ENTR
	: READ IDENTIFIER { result = [:READ,[:IDENTIFIER,val[1]]] }
	;

	#Salida
	SAL
	: WRITE EXPR { result = [:WRITE,[:IDENTIFIER,val[1]]]] }
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
	: LBRACKET EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET { result = }
	| LBRACKET IDENTIFIER COLON EXPR DOUBLE_DOT EXPR PIPE INSTR RBRACKET { result = }
	;

	# Incorporacion de alcance
	INCOR
	: LCURLY LISTADEC PIPE INSTR RCURLY { result = }
	| LCURLY INSTR RCURLY { result = }
	;

	#Incorporacion de alcance
	LISTADEC
	: DEC { result = }
	;

	#Expresiones 
	EXPR
	: EXPRARIT { result = }
	| EXPRBOOL { result = }
	| EXPRRELAC { result = }
	| EXPRLIENZ { result = }
	;

	#Expresiones Aritmeticas
	EXPRARIT
	: NUMBER PLUS NUMBER { result = }
	| NUMBER MINUS NUMBER { result = }
	| NUMBER TIMES NUMBER { result = }
	| NUMBER OBELUS NUMBER { result = } 
	| NUMBER PERCENT NUMBER { result = }
	| MINUS NUMBER { result = }
	;

	#Expresiones Booleanas
	EXPRBOOL
	: TRUE AND FALSE { result = }
	| FALSE AND TRUE { result = }
	| TRUE OR FALSE { result = }
	| FALSE OR TRUE { result = }
	| NOT TRUE { result = }
	| NOT FALSE { result = }
	;

	#Expresiones relacionales
	EXPRRELAC
	: EXPRARIT LESS EXPRARIT { result = }
	| EXPRARIT LESS_EQUAL EXPRARIT { result = }
	| EXPRARIT MORE EXPRARIT { result = }
	| EXPRARIT MORE_EQUAL EXPRARIT { result = }
	| EXPRARIT EQUAL EXPRARIT { result = }
	| EXPRARIT INEQUAL EXPRARIT { result = }
	| EXPRBOOL AND EXPRBOOL { result = }
	| EXPRBOOL OR EXPRBOOL { result = }
	| EXPRLIENZ EQUAL EXPRLIENZ { result = }
	| EXPRLIENZ INEQUAL EXPRLIENZ { result = }
	;

	#Expresiones sobre liensos
	EXPRLIENZ
	: CANVAS AMPERSAND CANVAS { result = } 
	| CANVAS VIRGUILE CANVAS { result = } 
	| DOLLAR CANVAS { result =  }
	| CANVAS APOSTROPHE { result = }
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