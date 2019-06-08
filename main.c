#include <stdio.h>
#include <string.h>
#include "pascal.h"
#include "pas_tree.h"
#include "pas_yacc.h"

char pas_name[16];
int pas_val;
pSTM* program = NULL;

int main(int argc,char *argv[]) {
    int p, i;
    char fname[20];

    if (argc == 2) {
        yyin = fopen(argv[1],"r");
	if (yyin) { // Source file is opened.
	    p = yyparse();
	    if (p) { //Parsing fails
		printf("pas2c: Parsing failed! ******\n");
	    } else { //Parsing succeeds
		printf("pas2c: Parsing succeeded!\n");
		strcpy( fname, argv[1] );
		for (i=0; (fname[i]!='.') && (fname[i]!='\0'); i++);
		fname[i++] = '.';
		fname[i++] = 'c';
		fname[i++] = '\0';
		yyout = fopen( fname, "w" );
		print_stm( program );
		fclose( yyout );
		printf("pas2c: %s is generated!\n", fname);
	    }
	}
	fclose( yyin );
    } else {
        printf("pas2c syntax: [pas2c source_file_name]\n");
    }
}
