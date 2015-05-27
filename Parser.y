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
	
	PROGRAM 
	: LCURLY BLOQUE RCURLY {result = [:BLOQUE,val[1]]; return result}
	;

	# Estructura Del Programa

	BLOQUE
	: DEC PIPE INSTR  { result = [[:DEC,val[0]],[:INSTR,val[1]]] }
	| INSTR  { result = [:INSTR,val[0]]}
	;


	# Declaraciones
	DEC
	: TIPO LISTIDENT DEC { result = [[:TIPO,val[0],[:LISTIDEN,val[1]]]+[:DEC,val[2]] }
	| TIPO LISTIDENT { result = [[:TIPO,val[1]] }
	;

	# Tipos 
	TIPO
	: EXCLAMATION_MARK { result = }
	| PERCENT  {result =} 
	| AT {result =}
	;

	# Identificadores
	LISTIDENT
	: IDENTIFIER LISTIDENT {result = }
	| IDENTIFIER 		   {result = }
	;

	# Instrucciones
	INSTR
	: ASSIGN { result = }
	| SEC { result = }
	| ENTR { result = }
	| SAL { result = val[0]}
	| CONDIC { result = }
	| ITERIND { result = }
	| ITERDET { result = }
	| INCOR { result = }
	| PROGRAM {result = val[0]}
	;

	#Asignacion
	ASSIGN
	: IDENTIFIER EQUAL EXPR { result = [:IDENTIFIER, val[0],:EQUAL,val[1]]}
	;

	#Secuenciacion
	SEC
	: INSTR SEMI_COLON SEC { result = }
	| INSTR
	;

	# Entrada
	ENTR
	: READ IDENTIFIER { result = }
	;

	#Salida
	SAL
	: WRITE EXPR { result = val[1]}
	;

	#Condicional
	CONDIC
	: LPARENTHESIS EXPR INTERROGATION_MARK INSTR RCURLY { result = }
	| LPARENTHESIS EXPR INTERROGATION_MARK INSTR COLON INSTR RCURLY { result = }
	;

	#Iteracion indeterminada
	ITERIND
	: LBRACKET EXPR PIPE INSTR RBRACKET { result = }
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
	: EXPRARIT { result = val[0] }
	| EXPRBOOL { result = }
	| EXPRRELAC { result = }
	| EXPRLIENZ { result = }
	;

	#Expresiones Aritmeticas
	EXPRARIT
	: NUMBER PLUS NUMBER { result = val[0] + val[2]}
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
	| DOLLAR CANVAS { result = [val[0],val[1]] }
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