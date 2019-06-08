%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "pascal.h"
	#include "pas_tree.h"
%}
%token PROG PROC BG END INT BOOL TRUE
%token LP RP LSP RSP FALSE CC
%token DOT SEMI VAR ARRAY OF DOTDOT
%token IF THEN READ WRITE WHILE DO
%token ELSE ASSIGN COMMA COLON ID NUM
%left OR AND
%left NOT
%left EQ NE LT GT LE GE
%left ADD MINUS
%left DIV TIMES

%union{ pSTM* sm;
        pEXP* ex;
        int   nu;
	char* sr;
      }

%type <sm> prog
%type <sm> block
%type <sm> vardecs
%type <sm> morevd
%type <sm> vardec
%type <sm> prodecs
%type <sm> proc
%type <sm> stmts
%type <sm> comstmt
%type <sm> morestm
%type <sm> stmt
%type <sm> simstmt
%type <sm> asstate
%type <sm> prostate
%type <sm> restate
%type <sm> wristate
%type <sm> strstmt
%type <sm> ifstate
%type <sm> whilest
%type <ex> moreid
%type <ex> type
%type <ex> arrtype
%type <ex> inrange
%type <ex> simtype
%type <ex> moreinvar
%type <ex> invar
%type <ex> outvalue
%type <ex> moreoutval
%type <ex> express
%type <ex> simexpre
%type <ex> addterm
%type <ex> term
%type <ex> multifac
%type <ex> factor
%type <ex> constant
%type <ex> relatop
%type <ex> sign
%type <ex> addoper
%type <ex> multiop
%type <ex> variable
%type <ex> indexvar
%type <nu> NUM
%type <sr> CC
%type <sr> ID

%expect 1 

%%
prog 	:	PROG ID SEMI block DOT
		{ program = $4;
		  program->stm_id = sPROG;
		  program->exp1 = create_exp();
		  program->exp1->exp_id = eID;
		  strcpy(program->exp1->name, $2);
		  $$ = program;
		}
	|
		{ program = NULL;
		  $$ = program;
		}
	;

block	:	vardecs prodecs stmts
		{ $$ = create_stm();
		  $$->stm_id = sBLOCK;
		  $$->stm1 = $1;
		  $$->stm2 = $2;
		  $$->next = $3;
		}
	;

vardecs	:	VAR vardec SEMI morevd
		{ $$ = create_stm();
		  $$->stm_id = sVARDECS;
		  $$->stm1 = $2;
		  $$->next = $4;
		}
	|
		{ $$ = NULL; 
		}
	;

morevd	:	vardec SEMI morevd
		{ $$ = create_stm();
		  $$->stm_id = sMOREVD;
		  $$->stm1 = $1;
		  $$->next = $3;
		}
	|
		{ $$ = NULL; 
		}
	;

vardec	:	ID moreid COLON type
		{ $$ = create_stm();
		  $$->stm_id = sVARDEC;
		  $$->exp1 = create_exp();
		  $$->exp1->exp_id = eVARDEC;
		  strcpy($$->exp1->name, $1);
		  $$->exp1->exp1 = $2;
		  $$->exp2 = $4; 
		}
	;

moreid	:	COMMA ID moreid
		{ $$ = create_exp();
		  $$->exp_id = eMOREID;
		  strcpy($$->name, $2);
		  $$->next = $3; 
		}
	|
		{ $$ = NULL; 
		}
	;

type	:	simtype
		{ $$ = $1;
		}
	|	arrtype
		{ $$ = $1;
		}
	;

arrtype	:	ARRAY LSP inrange RSP OF simtype
		{ $$ = create_exp();
		  $$->exp_id = eARRTYPE;
		  $$->exp1 = $3;
		  $$->exp2 = $6;
		}
		;

inrange	:	NUM DOTDOT NUM
		{ $$ = create_exp();
		  $$->exp_id = eINRANGE;
		  $$->val = $1;
		  $$->exp1 = create_exp();
		  $$->exp1->exp_id = eNUM;
		  $$->exp1->val = $3;
		}
	;

simtype	:	INT
		{ $$ = create_exp();
		  $$->exp_id = eINT;
		}
	|	BOOL
		{ $$ = create_exp();
		  $$->exp_id = eBOOL;
		}
	;

prodecs	:	proc SEMI prodecs
		{ 
			$$ = create_stm();
			$$ -> stm_id = sPRODECS;
			$$ -> stm1 = $1;
			$$ -> next = $3;
		}
	|
		{ 
			$$ = NULL;
		}
	;

proc	:	PROC ID SEMI block
		{ 
			$$ = create_stm();
			$$ -> stm_id = sPROC;
			$$ -> next = $4;
			$$ -> exp1 = create_exp();
			$$ -> exp1 -> exp_id = eID;
			strcpy($$->exp1->name , $2);
		}
	;

stmts	:	comstmt
		{ 
			$$ = $1;
		}
	;

comstmt	:	BG stmt morestm END
		{ 
			$$ = create_stm();
			$$ -> stm_id = sCOMSTMT;
			$$ -> stm1 = $2;
			$$ -> stm2 = $3;
		}
	;

morestm	:	SEMI stmt morestm
		{ 
			$$ = create_stm();
			$$ -> stm_id = sMORESTM;
			$$ -> stm1 = $2;
			$$ -> next = $3;	
		}
	|
		{ 
			$$ = NULL;
		}
	;

stmt	:	simstmt
		{ 
			$$ = $1;
		}
	|	strstmt
		{ 
			$$ = $1;
		}
	;

simstmt :	asstate
		{ 
			$$ = $1;
		}
	|	prostate
		{ 
			$$ = $1;
		}
	|	restate
		{
			$$= $1;
		}
	|	wristate
		{
			$$ = $1;
		}
	;

asstate :	variable ASSIGN express
		{ 
			$$ = create_stm();
			$$ -> stm_id = sASSTATE;
			$$ -> exp1 = $1;
			$$ -> exp2 = $3;
		}
	;

prostate:	ID
		{ 
			$$ = create_stm();
			$$ -> stm_id = sPROSTATE;
			$$ -> exp1 = create_exp();
			$$ -> exp1 -> exp_id = eID;
			strcpy($$->exp1->name,$1);
		}
	;

restate	:	READ LP invar moreinvar RP
		{ 
			$$ = create_stm();
			$$ -> stm_id = sRESTATE;
			$$ -> exp1 = $3;
			$$ -> exp2 = $4;
		}
	;

moreinvar :	COMMA invar moreinvar
		{ 
			$$ = create_exp();
			$$ -> exp_id = eMOREINVAR;
			$$ -> exp1 = $2;
			$$ -> next = $3;
		}
	|
		{ 
			$$ = NULL;
		}
	;

invar	:	variable
		{
			$$ = $1;
		}
	;

wristate:	WRITE LP outvalue moreoutval RP
		{
			$$ = create_stm();
			$$ -> stm_id = sWRISTATE;
			$$ -> exp1 = $3;
			$$ -> exp2 = $4;
		}
	;

outvalue:	express
		{ 
			$$ = $1;
		}
	;

moreoutval:	COMMA outvalue moreoutval
		{ 
			$$ = create_exp();
			$$ -> exp_id = eMOREOUTVAL;
			$$ -> exp1 = $2;
			$$ -> next = $3;
		}
	|
		{ 
			$$ = NULL;
		}
	;

strstmt :	comstmt
		{ 
			$$ = $1;
		}
	|	ifstate
		{ 
			$$ = $1;
		}
	|	whilest
		{ 
			$$ = $1;
		}
	;

ifstate	:	IF express THEN stmt
		{ 
			$$ = create_stm();
			$$ -> stm_id = sIFSTATE;
			$$ -> exp1 = $2;
			$$ -> next = $4;
		}
	|	IF express THEN stmt ELSE stmt
		{ 
			$$ = create_stm();
			$$ -> stm_id = sIFSTATE;
			$$ -> exp1 = $2;
			$$ -> stm1 = $4;
			$$ -> next = $6;
		}
	;

whilest :	WHILE express DO stmt
		{ 
			$$ = create_stm();
			$$ -> stm_id = sWHILEST;
			$$ -> exp1 = $2;
			$$ -> next = $4;
		}
	;

express :	simexpre
		{ 
			$$ = $1;
		}
	|	simexpre relatop simexpre
		{ 
			$$ = create_exp();
			$$ -> exp_id = eEXPRESS;
			$$ -> exp1 = $1;
			$$ -> exp2 = $2;
			$$ -> next = $3;
		}
	;

simexpre:	sign term addterm
		{ 
			$$ = create_exp();
			$$ -> exp_id = eSIMEXPRE;
			$$ -> exp1 = $1;
			$$ -> exp2 = $2;
			$$ -> next = $3;
		}
	;

addterm :	addoper term addterm
		{ 
			$$ = create_exp();
			$$ -> exp_id = eADDTERM;
			$$ -> exp1 = $1;
			$$ -> exp2 = $2;
			$$ -> next = $3;
		}
        |
		{ 
			$$ = NULL;
		}
	;

term	:	factor multifac
		{ 
			$$ = create_exp();
			$$ -> exp_id = eTERM;
			$$ -> exp1 = $1;
			$$ -> exp2 = $2;
		}
	;

multifac:	multiop factor multifac
		{ 
			$$ = create_exp();
			$$ -> exp_id = eMULTIFAC;
			$$ -> exp1 = $1;
			$$ -> exp2 = $2;
			$$ -> next = $3;
		}
        |
		{ 
			$$ = NULL;
		}
	;

factor	:	variable
		{ 
			$$ = $1;
		}
	|	constant
		{ 
			$$ = $1;
		}
	|	LP express RP
		{
			$$ = create_exp();
			$$ -> exp_id = eLPRP;
			$$ -> exp1 = $2;
		}
	|	NOT factor
		{ 
			$$ = create_exp();
			$$ -> exp_id = eNOT;
			$$ -> exp1 = $2;
		}
	;

constant:	NUM
		{ 
			$$ = create_exp();
			$$ -> exp_id = eNUM;
			$$ -> val = $1;
		}
	|	CC
		{
			$$ = create_exp();
			$$ -> exp_id = eCC;
			strcpy($$->name,$1);
		}
	| 	TRUE
		{ 
			$$ = create_exp();
			$$ -> exp_id = eTRUE;
		}
	| 	FALSE
		{ 
			$$ = create_exp();
			$$ -> exp_id = eFALSE;
		}
	;

relatop :	EQ
		{ 
			$$ = create_exp();
			$$ -> exp_id = eEQ;
		}
	|	NE
		{	
			$$ = create_exp();
			$$ -> exp_id = eNE;
		}
	|	LT
		{ 
			$$ = create_exp();
			$$ -> exp_id = eLT;
		}
	|	GT 
		{ 
			$$ = create_exp();
			$$ -> exp_id = eGT;
		}
	|	LE
		{ 
			$$ = create_exp();
			$$ -> exp_id = eLE;
		}
	|	GE
		{ 
			$$ = create_exp();
			$$ -> exp_id = eGE;
		}
	;

sign	:	ADD
		{
			$$ = create_exp();
			$$ -> exp_id = eADD;
		}
	|	MINUS
		{ 
			$$ = create_exp();
			$$ -> exp_id = eMINUS;
		}
	|
		{ 
			$$ = NULL;
		}
	;

addoper :	ADD
		{ 
			$$ = create_exp();
			$$ -> exp_id = eADD;
		}
	|	MINUS
		{ 
			$$ = create_exp();
			$$ -> exp_id = eMINUS;
		}
	|   OR
		{ 
			$$ = create_exp();
			$$ -> exp_id = eOR;
		}
	;

multiop :	TIMES
		{ 
			$$ = create_exp();
			$$ -> exp_id = eTIMES;
		}
	|	DIV
		{ 
			$$ = create_exp();
			$$ -> exp_id = eDIV;
		}
	|	AND
		{ 
			$$ = create_exp();
			$$ -> exp_id = eAND;
		}
	;

variable:	ID
		{ 
			$$ = create_exp();
			$$ -> exp_id = eID;
			strcpy($$->name,$1);
		}
	|	indexvar
		{
			$$ = $1;
		}
	;

indexvar: 	ID LSP express RSP
		{ 
			$$ = create_exp();
			$$ -> exp_id = eINDEXVAR;
			$$ -> exp1 = create_exp();
			$$ -> exp1 -> exp_id = eID;
			strcpy($$->exp1->name,$1);
			$$ -> exp2 = $3;
		}
	;


%%

// for version compatibility
int yyerror(char *s)
{
	printf("%s\n",s);
        return 1;
}

