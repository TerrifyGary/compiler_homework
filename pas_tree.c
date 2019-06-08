#include <stdio.h>
#include <stdlib.h>
#include "pascal.h"
#include "pas_tree.h"

// for declaring arrays
int amode = 0;
int aind = 1;
int www = 0;

pEXP *create_exp()
{
	pEXP *tmp;
	tmp = (struct p_exp *)malloc(sizeof(struct p_exp));
	if (tmp)
	{
		tmp->exp_id = eMIN;
		tmp->name[0] = '\0';
		tmp->val = 0;
		tmp->exp1 = NULL;
		tmp->exp2 = NULL;
		tmp->next = NULL;
	}
	return tmp;
}

pSTM *create_stm()
{
	pSTM *tmp;
	tmp = (struct p_stm *)malloc(sizeof(struct p_stm));
	if (tmp)
	{
		tmp->stm_id = sMIN;
		tmp->exp1 = NULL;
		tmp->exp2 = NULL;
		tmp->stm1 = NULL;
		tmp->stm2 = NULL;
		tmp->next = NULL;
	}
	return tmp;
}

void free_exp(pEXP *p)
{
	if (p)
	{
		if (p->exp1)
			free_exp(p->exp1);
		if (p->exp2)
			free_exp(p->exp2);
		if (p->next)
			free_exp(p->next);
		free(p);
	}
}

void free_stm(pSTM *p)
{
	if (p)
	{
		if (p->exp1)
			free_exp(p->exp1);
		if (p->exp2)
			free_exp(p->exp2);
		if (p->stm1)
			free_stm(p->stm1);
		if (p->stm2)
			free_stm(p->stm2);
		if (p->next)
			free_stm(p->next);
		free(p);
	}
}

void print_exp(pEXP *p)
{
	pEXP *te;
	if (p)
	{
		switch (p->exp_id)
		{
		case eMOREID:
			fprintf(stderr, "eMOREID\n");
			fprintf(yyout, ", %s", p->name);
			if (amode)
			{
				fprintf(yyout, "[%d]", aind);
			}
			print_exp(p->next);
			break;

		case eARRTYPE:
			fprintf(stderr, "eARRTYPE\n");
			amode = 1;
			print_exp(p->exp1);
			print_exp(p->exp2);
			break;

		case eINRANGE:
			fprintf(stderr, "eINRANGE\n");
			aind = (p->exp1->val) - (p->val);
			break;

		case eINT:
			fprintf(stderr, "eINT\n");
			fprintf(yyout, "int ");
			break;

		case eBOOL:
			fprintf(stderr, "eBOOL\n");
			fprintf(yyout, "int ");
			break;

		case eMOREINVAR:
			fprintf(stderr, "eMOREINVAR\n");
			print_exp(p->exp1);
			print_exp(p->exp2);
			break;

		case eMOREOUTVAL:
			fprintf(stderr, "eMOREOUTVA\n");
			fprintf(yyout, ", ");
			print_exp(p->exp1);
			print_exp(p->next);
			break;

		case eEXPRESS:
			fprintf(stderr, "eEXPRESS\n");
			print_exp(p->exp1);
			print_exp(p->exp2);
			print_exp(p->next);
			break;

		case eSIMEXPRE:
			fprintf(stderr, "eSIMEXPRE\n");
			print_exp(p->exp1);
			print_exp(p->exp2);
			print_exp(p->next);
			break;

		case eADDTERM:
			fprintf(stderr, "eADDTERM\n");
			print_exp(p->exp1);
			print_exp(p->exp2);
			print_exp(p->next);
			break;

		case eTERM:
			fprintf(stderr, "eTERM\n");
			print_exp(p->exp1);
			print_exp(p->exp2);
			break;

		case eMULTIFAC:
			fprintf(stderr, "eMULTIFAC\n");
			print_exp(p->exp1);
			print_exp(p->exp2);
			print_exp(p->next);
			break;

		case eLPRP:
			fprintf(stderr, "eLPRP\n");
			fprintf(yyout, "( ");
			print_exp(p->exp1);
			fprintf(yyout, ")");
			break;

		case eNOT:
			fprintf(stderr, "eNOT\n");
			fprintf(yyout, "!");
			print_exp(p->exp1);
			break;

		case eADD:
			fprintf(stderr, "eADD\n");
			fprintf(yyout, "+");
			break;

		case eMINUS:
			fprintf(stderr, "eMINUS\n");
			fprintf(yyout, "-");
			break;

		case eNOSIGN:
			fprintf(stderr, "eNOSIGN\n");
			fprintf(yyout, " ");
			break;

		case eOR:
			fprintf(stderr, "eOR\n");
			fprintf(yyout, "|");
			break;

		case eTIMES:
			fprintf(stderr, "eTIMES\n");
			fprintf(yyout, "*");
			break;

		case eDIV:
			fprintf(stderr, "eDIV\n");
			fprintf(yyout, "/");
			break;

		case eAND:
			fprintf(stderr, "eAND\n");
			fprintf(yyout, "&");
			break;

		case eINDEXVAR:
			fprintf(stderr, "eINDEXVAR\n");
			fprintf(yyout, "%s", p->exp1->name);
			fprintf(yyout, "[");
			print_exp(p->exp2);
			fprintf(yyout, "]");
			break;

		case eNUM:
			fprintf(stderr, "eNUM\n");
			fprintf(yyout, "%d", p->val);
			break;

		case eCC:
			fprintf(stderr, "eCC\n");
			fprintf(yyout, "%s", p->name);
			break;

		case eTRUE:
			fprintf(stderr, "eTRUE\n");
			fprintf(yyout, "1");
			break;

		case eFALSE:
			fprintf(stderr, "eFALSE\n");
			fprintf(yyout, "0");
			break;

		case eEQ:
			fprintf(stderr, "eEQ\n");
			fprintf(yyout, "==");
			break;

		case eNE:
			fprintf(stderr, "eNE\n");
			fprintf(yyout, "!=");
			break;

		case eLT:
			fprintf(stderr, "eLT\n");
			fprintf(yyout, "<");
			break;

		case eGT:
			fprintf(stderr, "eGT\n");
			fprintf(yyout, ">");
			break;

		case eLE:
			fprintf(stderr, "eLE\n");
			fprintf(yyout, "<=");
			break;

		case eGE:
			fprintf(stderr, "eGE\n");
			fprintf(yyout, ">=");
			break;

		case eID:
			fprintf(stderr, "eID\n");
			fprintf(yyout, "%s", p->name);
			break;

		case eVARDEC:
			fprintf(stderr, "eVARDEC\n");
			fprintf(yyout, "%s", p->name);
			if (amode)
				fprintf(yyout, "[%d]", aind);
			print_exp(p->exp1);
			break;

		default:
			fprintf(stderr, "******* An error in expressions!\n");
			break;
		}
	}
}

void print_stm(pSTM *p)
{
	pEXP *te;
	pSTM *ts;
	if (p)
	{
		switch (p->stm_id)
		{
		case sPROG:
			fprintf(stderr, "sPROG\n");
			fprintf(yyout, "#include <stdio.h>\n\n");
			print_stm(p->stm1);
			print_stm(p->stm2);
			fprintf(yyout, "int main() {\n");
			print_stm(p->next);
			fprintf(yyout, "}\n");
			break;

		case sBLOCK:
			fprintf(stderr, "sBLOCK\n");
			fprintf(yyout, "{\n");
			print_stm(p->stm1);
			print_stm(p->stm2);
			print_stm(p->next);
			fprintf(yyout, "}\n");
			break;

		case sVARDECS:
			fprintf(stderr, "sVARDECS\n");
			print_stm(p->stm1);
			print_stm(p->next);
			break;

		case sMOREVD:
			fprintf(stderr, "sMOREVD\n");
			print_stm(p->stm1);
			print_stm(p->next);
			break;

		case sVARDEC:
			fprintf(stderr, "sVARDEC\n");
			print_exp(p->exp2);
			print_exp(p->exp1);
			fprintf(yyout, ";\n");
			amode = 0;
			break;

		case sPRODECS:
			fprintf(stderr, "sPRODECS\n");
			print_stm(p->stm1);
			print_stm(p->next);
			break;

		case sPROC:
			fprintf(stderr, "sPROC\n");
			fprintf(yyout, "void ");
			print_exp(p->exp1);
			fprintf(yyout, "()\n");
			print_stm(p->next);
			fprintf(yyout, "\n");
			break;

		case sCOMSTMT:
			fprintf(stderr, "sCOMSTMT\n");
			print_stm(p->stm1);
			print_stm(p->stm2);
			break;

		case sMORESTM:
			fprintf(stderr, "sMORESTM\n");
			print_stm(p->stm1);
			print_stm(p->next);
			break;

		case sASSTATE:
			fprintf(stderr, "sASSTATE\n");
			print_exp(p->exp1);
			fprintf(yyout, "=");
			print_exp(p->exp2);
			fprintf(yyout, ";\n");
			break;

		case sPROSTATE:
			fprintf(stderr, "sPROSTATE\n");
			print_exp(p->exp1);
			fprintf(yyout, "();\n");
			break;

		case sRESTATE:
			fprintf(stderr, "sRESTATE\n");
			fprintf(yyout, "scanf(\"%%d\", &");
			print_exp(p->exp1);
			fprintf(yyout, ");\n");
			break;

		case sWRISTATE:
			fprintf(stderr, "sWRISTATE\n");
			fprintf(yyout, "printf(");
			fprintf(yyout, "\"%%d\\n\",");
			www = 1;
			print_exp(p->exp1);
			print_exp(p->exp2);
			fprintf(yyout, ");\n");
			www = 0;
			break;

		case sIFSTATE:
			fprintf(stderr, "sIFSTATE\n");
			fprintf(yyout, "if");
			print_exp(p->exp1);
			print_stm(p->stm1);
			print_stm(p->next);
			break;

		case sWHILEST:
			fprintf(stderr, "sWHILEST\n");
			fprintf(yyout, "while");
			print_exp(p->exp1);
			fprintf(yyout, "{\n");
			print_stm(p->next);
			fprintf(yyout, "}\n");
			break;

		default:
			fprintf(stderr, "******* An error in statements!\n");
			break;
		}
	}
}