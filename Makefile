pas2c: pas_yacc.o pas_lex.o main.o pas_tree.o 
	gcc -o pas2c pas_lex.o main.o pas_yacc.o pas_tree.o

debug:
	bison -d --report=all -o pas_yacc.c pas_yacc.y

pas_lex.o: pas_lex.c pascal.h pas_yacc.h pas_tree.h
	gcc -c pas_lex.c

pas_lex.c: pas_lex.l
	flex -opas_lex.c pas_lex.l

pas_yacc.o: pas_yacc.c pascal.h pas_yacc.h pas_tree.h
	gcc -c pas_yacc.c
	
pas_yacc.c: pas_yacc.y
	bison -d -opas_yacc.c pas_yacc.y
	
pas_yacc.h: pas_yacc.y
	bison -d -opas_yacc.c pas_yacc.y
	
pas_tree.o: pas_tree.c pas_tree.h
	gcc -c -o pas_tree.o pas_tree.c
	
main.o: main.c pascal.h pas_tree.h
	gcc -c main.c
	
clean:
	rm *.o pas2c pas_lex.c pas_yacc.c pas_yacc.h test?.c test?

test1.c: test1.pas
	./pas2c test1.pas

test1: test1.c
	gcc -o test1 test1.c

test2.c: test2.pas
	./pas2c test2.pas

test2: test2.c
	gcc -o test2 test2.c

test3.c: test3.pas
	./pas2c test3.pas

test3: test3.c
	gcc -o test3 test3.c

test4.c: test4.pas
	./pas2c test4.pas

test4: test4.c
	gcc -o test4 test4.c

test5.c: test5.pas
	./pas2c test5.pas

test5: test5.c
	gcc -o test5 test5.c

# hidden rules
.c:	.l
	flex -o$< $@
