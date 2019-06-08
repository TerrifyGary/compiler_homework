#define LMIN 0
#define DIV 1
#define OR 2
#define AND 3
#define NOT 4
#define IF 5
#define THEN 6
#define ELSE 7
#define OF 8
#define WHILE 9
#define DO 10
#define BG 11
#define END 12
#define READ 13
#define WRITE 14
#define VAR 15
#define ARRAY 16
#define PROC 17
#define PROG 18
#define INT 19
#define BOOL 20
#define TRUE 21
#define FALSE 22
#define ADD 23
#define MINUS 24
#define TIMES 25
#define EQ 26
#define NE 27
#define LT 28
#define GT 29
#define LE 30
#define GE 31
#define LP 32
#define RP 33
#define LSP 34
#define RSP 35
#define ASSIGN 36
#define DOT 37
#define COMMA 38
#define SEMI 39
#define COLON 40
#define DOTDOT 41
#define ID 42
#define NUM 43
#define CC 44
#define LMAX 45


extern int yylex();
extern FILE *yyin;

extern char pas_name[16];
extern int pas_val;



