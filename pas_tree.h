
// Tags for parse trees.

#define sMIN 0
#define sPROG 1
#define sBLOCK 2
#define sVARDECS 3
#define sMOREVD 4
#define sVARDEC 5
#define sPRODECS 6
#define sPROC 7
#define sCOMSTMT 8
#define sMORESTM 9
#define sASSTATE 10
#define sPROSTATE 11
#define sRESTATE 12
#define sWRISTATE 13
#define sIFSTATE 14
#define sWHILEST 15
#define sMAX 16

#define eMIN 0
#define eMOREID 1
#define eARRTYPE 2
#define eINRANGE 3
#define eINT 4
#define eBOOL 5
#define eMOREINVAR 6
#define eMOREOUTVAL 7
#define eEXPRESS 8
#define eSIMEXPRE 9
#define eADDTERM 10
#define eTERM 11
#define eMULTIFAC 12
#define eLPRP 13
#define eNOT 14
#define eADD 15
#define eMINUS 16
#define eNOSIGN 17
#define eOR 18
#define eTIMES 19
#define eDIV 20
#define eAND 21
#define eINDEXVAR 22
#define eNUM 23
#define eCC 24
#define eTRUE 25
#define eFALSE 26
#define eEQ 27
#define eNE 28
#define eLT 29
#define eGT 30
#define eLE 31
#define eGE 32
#define eID 33
#define eVARDEC 34
#define eMAX 35

// Data structures

typedef struct p_exp {
  int exp_id;
  char name[16];
  int  val;
  struct p_exp *exp1;
  struct p_exp *exp2;
  struct p_exp *next;
} pEXP;

typedef struct p_stm {
  int stm_id;
  struct p_exp *exp1;
  struct p_exp *exp2;
  struct p_stm *stm1;
  struct p_stm *stm2;
  struct p_stm *next;
} pSTM;

// Function interface

extern pEXP* create_exp();
extern pSTM* create_stm();
extern void free_exp( pEXP* );
extern void free_stm( pSTM* );
extern void print_exp( pEXP* );
extern void print_stm( pSTM* );

extern pSTM* program;

