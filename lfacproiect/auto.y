%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct checkengine {
    _Bool valoare;
    char* model;
    _Bool init;
}chkeng[200];
int nr_bool = 0;
int nr_bool_2 = 0;

struct masina{
 int valoare;
  char * model;
  char * marca;
  _Bool deja_declarata;
  _Bool este_constanta;

};

struct dacie{
    char* model;
    char* valoare;
    _Bool deja_declarata;
}dacii[200];
int nr_dacii=0;
int nr_dacii2 = 0;

struct masina masini[200];
int nr=0;
int nr_2=0;

struct functie {
  char * marca;
  char * model;
    char * argumente;
};

struct functie functii [200];
int f_nr=0;
int f_nr_2=0;

int expresie[200];
int n;

void declar_dacie_no_init(char* model)
{
    if(variabila_deja_declarata(model) != -1)
    {
        char eroare[200];
        sprintf(eroare, "deja avem dacia %s", model);
        yyerror(eroare);
        exit(0);
    }

    dacii[nr_dacii].model = strdup(model);
    dacii[nr_dacii].deja_declarata = 1;
    nr_dacii++;
}

void declar_dacie_init(char* model, char* val)
{
    if(variabila_deja_declarata(model) != -1)
    {
        char eroare[200];
        sprintf(eroare, "deja avem dacia %s", model);
        yyerror(eroare);
        exit(0);
    } 

    dacii[nr_dacii].model = strdup(model);
    dacii[nr_dacii].valoare = strdup(val);
    strcpy(dacii[nr_dacii].valoare, dacii[nr_dacii].valoare+1);
    dacii[nr_dacii].valoare[strlen(dacii[nr_dacii].valoare)-1] = NULL;
    dacii[nr_dacii].deja_declarata = 1;
    nr_dacii++;
}

int variabila_deja_declarata(char * model)
{
    for(int i=0 ; i<nr;i++)
    {
        if(strcmp(masini[i].model,model)==0)
            return i ;
    }
    for(int i = 0; i < nr_bool; i++)
    {
        if(strcmp(chkeng[i].model,model) == 0)
            return i;
    }
    for(int i = 0; i < nr_dacii; i++)
    {
        if(strcmp(model,dacii[i].model) == 0)
            return i;
    }
return -1;

}

void decl_bool_no_init(char* model)
{
    if(variabila_deja_declarata(model) != -1)
    {
        char eroare[200];
        sprintf(eroare, "checkEngine pentru %s deja existent", model);
        yyerror(eroare);
        exit(0);
    }
    chkeng[nr_bool].model = strdup(model);
    chkeng[nr_bool].init = 0;
    nr_bool++;
}

void decl_bool_init(char * model, char* val)
{
    if(variabila_deja_declarata(model) !=  -1)
    {
        char eroare[200];
        sprintf(eroare, "checkEngine pentru %s deja existent", model);
        yyerror(eroare);
        exit(0);
    }
    chkeng[nr_bool].model = strdup(model);
    if(strcmp(val,"true") == 0)
        chkeng[nr_bool].valoare = true;
    else
        chkeng[nr_bool].valoare = false;
    chkeng[nr_bool].init = 1;
    nr_bool++;
}

void declarare_fara_initializare(char* marca , char* model, _Bool este_constanta)
{
    if (variabila_deja_declarata(model) != -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s a mai fost declarata", model);
        yyerror(eroare);
        exit(0);
    }
    if (este_constanta == 1)
    {
        char eroare[200];
        sprintf(eroare, "nu putem declara o masina constanta  %s fara sa o initializam intai", model);
        yyerror(eroare);
        exit(0);
    }
    masini[nr].marca = strdup(marca);
    masini[nr].model = strdup(model);
    masini[nr].deja_declarata = 0;
    masini[nr].este_constanta = 0;
    nr++;
}

int deja_bool(char* model)
{
    for(int i = 0; i < nr_bool; i++)
    {
        if(strcmp(chkeng[i].model,model) == 0)
            return i;
    }
    return -1;
}

void assign_bool(char* model, char* val)
{
    int pos = deja_bool(model);
    if(pos == -1)
    {
        char eroare[200];
        sprintf(eroare, "checkEngine pentru %s nu este instalat");
        yyerror(eroare);
        exit(0);
    }

    if(strcmp(val,"true") == 0)
        chkeng[pos].valoare = 1;
    else
        chkeng[pos].valoare = 0;
}


char * bool_si(char* bex1, char* bex2)
{
    if(strcmp(bex1,"false") == 0 || strcmp(bex2,"false") == 0)
        return "false";
    return "true";
}

char* bool_sau(char* bex1, char* bex2)
{
    if(strcmp(bex1,"true") == 0 || strcmp(bex2,"true") == 0)
        return "true";
    return "false";
}

char* bool_expr(char* model)
{
    int pos = deja_bool(model);
    if(pos == -1)
    {
        char eroare[200];
        sprintf(eroare, "checkEngine pentru %s nu este instalat");
        yyerror(eroare);
        exit(0);
    }

    if(chkeng[pos].valoare)
        return "true";
    return "false";
}

void declarare_cu_initilizarea_valorii(char* marca , char* model,int valoare, _Bool este_constanta)
{
    if (variabila_deja_declarata(model) != -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s este deja declarata", model);
        yyerror(eroare);
        exit(0);
    }
    masini[nr].marca = strdup(marca);
    masini[nr].model = strdup(model);
    masini[nr].valoare = valoare;
    masini[nr].deja_declarata= 1;
    masini[nr].este_constanta= este_constanta;
  nr++;
}


void declarare_cu_initializarea_a_variabilei(char* marca, char* model, char* masina, _Bool este_constanta)
{
    if (variabila_deja_declarata(model) != -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s este deja declarata", model);
        yyerror(eroare);
        exit(0);
    }
    int pozitie = variabila_deja_declarata(masina);
    if (pozitie == -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu poate fi initializata cu o masina care nu exista %s", model, masina);
        yyerror(eroare);
        exit(0);
    }
    if (strcmp(marca, masini[pozitie].marca) != 0)
    {
        char eroare[200];
        sprintf(eroare, "masina %s trebuie sa fie de aceeasi marca cu  %s", model, masini[pozitie].model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].deja_declarata == 0)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu poate fi initializata cu o masina fara valoare %s", model, masini[pozitie].model);
        yyerror(eroare);
        exit(0);
    }
    masini[nr].marca = strdup(marca);
    masini[nr].model = strdup(model);
    masini[nr].valoare = masini[pozitie].valoare;
    masini[nr].deja_declarata = 1;
    masini[nr].este_constanta = este_constanta;
nr++;
}
int valoarea_variabilei(char* model)
{
    int pozitie = variabila_deja_declarata(model);
    if (pozitie == -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu este declarata", model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].deja_declarata == 0)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu are nicio valoare data", model);
        yyerror(eroare);
        exit(0);
    }
    return masini[pozitie].valoare;
}

void asignare_valoare(char* model, int valoare)
{
    int pozitie = variabila_deja_declarata(model);
    if (pozitie == -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu a fost declarata anterior", model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].este_constanta == 1)
    {
        char eroare[200];
        sprintf(eroare, "nu putem modifica o masina constanta ,odata definita asa ramane! %s", model);
        yyerror(eroare);
        exit(0);
    }
    masini[pozitie].valoare = valoare;
    masini[pozitie].deja_declarata = 1;
}

void incrementare_sau_decrementare(char* model, char* operator)
{
    int pozitie = variabila_deja_declarata(model);
    if (pozitie == -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu a fost declarata anterior", model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].deja_declarata == 0)
    {
        char eroare[200];
        sprintf(eroare, "masinii %s nu i a fost data nicio valoare", model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].este_constanta == 1)
    {
        char eroare[200];
        sprintf(eroare, "nu putem modifica o masina constanta ,odata definita asa ramane! %s ", model);
        yyerror(eroare);
        exit(0);
    }
    if (strcmp(operator, "++") == 0) masini[pozitie].valoare++;
    if (strcmp(operator, "--") == 0) masini[pozitie].valoare--;
}

void asignare_numar_cu_operator(char* model, int valoare, char* operator)
{
    int pozitie = variabila_deja_declarata(model);
    if (pozitie == -1)
    {
        char eroare[200];
        sprintf(eroare, "masina %s nu a fost declarata anterior", model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].deja_declarata == 0)
    {
        char eroare[200];
        sprintf(eroare, "masinii %s nu i a fost data nicio valoare", model);
        yyerror(eroare);
        exit(0);
    }
    if (masini[pozitie].este_constanta == 1)
    {
        char eroare[200];
        sprintf(eroare, "nu putem modifica o masina constanta ,odata definita asa ramane! %s ", model);
        yyerror(eroare);
        exit(0);
    }
    if (strcmp(operator, "+=") == 0) masini[pozitie].valoare += valoare;
    if (strcmp(operator, "-=") == 0) masini[pozitie].valoare -= valoare;
    if (strcmp(operator, "*=") == 0) masini[pozitie].valoare *= valoare;
    if (strcmp(operator, "/=") == 0) masini[pozitie].valoare /= valoare;
}

int functie_deja_declarata(char* model, char* argumente)
{
    for (int i = 0; i < f_nr; i++)
    {
        if ((strcmp(functii[i].model, model) == 0) && (strcmp(functii[i].argumente, argumente) == 0)) return i;
    }
    return -1;
}

void declarare_functie (char* marca, char* model, char* argumente)
{
    if (strlen(argumente) >= 2) argumente[strlen(argumente) - 2] = 0;
    if (functie_deja_declarata(model, argumente) != -1)
    {
        char eroare[200];
        sprintf(eroare, "nu putem declara inca odata functia  %s cu acelelasi argumente si acelasi tip de masina", model);
        yyerror(eroare);
        exit(0);
    }
    functii[f_nr].marca = marca;
    functii[f_nr].model = model;
    functii[f_nr].argumente = argumente;
    f_nr++;
}

int dacie_deja(char* model)
{
    for(int i = 0; i < nr_dacii; i++)
    {
        if(strcmp(model,dacii[i].model) == 0)
            return i;
    }
    return -1;
}

void concat(char* model1, char* model2)
{
    int pos1 = dacie_deja(model1);
    int pos2 = dacie_deja(model2);
    if(pos1 == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model1);
        yyerror(eroare);
        exit(0);
    }

    if(pos2 == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model2);
        yyerror(eroare);
        exit(0);
    }

    strcat(dacii[pos1].valoare,dacii[pos2].valoare);
}

int leng(char* model)
{
    int pos = dacie_deja(model);
    if(pos == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model);
        yyerror(eroare);
        exit(0);
    }

    return strlen(dacii[pos].valoare);
}

int compar(char* model1, char* model2)
{
    int pos1 = dacie_deja(model1);
    int pos2 = dacie_deja(model2);
    if(pos1 == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model1);
        yyerror(eroare);
        exit(0);
    }

    if(pos2 == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model2);
        yyerror(eroare);
        exit(0);
    }

    return strcmp(dacii[pos1].valoare,dacii[pos2].valoare);
}

int contain(char* model1, char* model2)
{
    int pos1 = dacie_deja(model1);
    int pos2 = dacie_deja(model2);
    if(pos1 == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model1);
        yyerror(eroare);
        exit(0);
    }

    if(pos2 == -1)
    {
        char eroare[200];
        sprintf(eroare, "nu avem dacia %s", model2);
        yyerror(eroare);
        exit(0);
    }

    if(strstr(dacii[pos2].valoare,dacii[pos1].valoare) != NULL)
    {
        return 1;
    }

    return 0;
}

char* tip_returnare_functie (char* model, char* argumente)
{
    if (strlen(argumente) >= 2) argumente[strlen(argumente) - 2] = 0;
    int pozitie = functie_deja_declarata(model, argumente);
    if (pozitie == -1)
    {
        char eroare[200];
        sprintf(eroare, "functia  %s nu exista", model);
        yyerror(eroare);
        exit(0);
    }
    char* marca = malloc(200);
    strcpy(marca, functii[pozitie].marca);
    return marca;
}

void tabel_simboluri(char* scope)
{
    FILE* descriptor_fisier = fopen("tabel_de_simboluri.txt", "a");
    fprintf(descriptor_fisier, "variabile %s : ", scope);
    for (int i = nr_2; i < nr; i++) fprintf (descriptor_fisier, "[%s] %s , ", masini[i].marca,masini[i].model);
    nr_2 = nr;
    for(int i = nr_bool_2; i < nr_bool; i++) fprintf(descriptor_fisier, "[checkEngine] %s , ", chkeng[i].model);
    nr_bool_2 = nr_bool;
    for(int i = nr_dacii2; i < nr_dacii; i++) fprintf(descriptor_fisier, "[dacia] %s , ", dacii[i].model);
    nr_dacii2 = nr_dacii;
    fprintf(descriptor_fisier, "\n");
    fprintf(descriptor_fisier, "functii %s : ", scope);
    for (int i = f_nr_2; i < f_nr; i++) fprintf (descriptor_fisier,"[%s] %s , ", functii[i].marca ,functii[i].model);
    f_nr_2 = f_nr;
    fprintf (descriptor_fisier, "\n\n");
    fclose(descriptor_fisier);
}

void ADAOS (int x){

expresie[n++]=x;

}

void AFISARE (){

for(int i=0;i<n;i++)
{
     printf("valoarea expresiei  %d este %d\n", i + 1, expresie[i]);
}

for(int i=0; i <nr_dacii; i++)
{
    printf("valoarea daciei %s este %s\n", dacii[i].model, dacii[i].valoare);
}

for(int i = 0; i < nr_bool; i++)
{
    printf("checkEngine pentru %s este %d\n", chkeng[i].model, chkeng[i].valoare);

}

}


%}

%token PRINCIPAL CONSTANT PRODUCATOR IF DACIASTRING TESLACHAR ELSE WHILE FOR AFISEAZA CLASA PLUSEGAL MINUSEGAL INMULTIREEGAL IMPARTIREEGAL INCREMENTARE DECREMENTARE SI SAU EGALEGAL NONEGAL MMEGAL MEGAL MM M NON EGAL ACOLADADESCHISA ACOLADAINCHISA ROTUNDADESCHISA ROTUNDAINCHISA PATRATADESCHISA PATRATAINCHISA PUNCTVIRGULA VIRGULA PLUS MINUS INMULTIRE IMPARTIRE PUNCT PROPOZITIE CARACTER IDENTIFICATOR NUMAR BOOL TRUE FALSE SIB SAUB CONCATS LEN COMP ISIN
%start correct

%left VIRGULA
%left SAU
%left SI
%left PLUS MINUS
%left INMULTIRE IMPARTIRE
%left NON
%left INCREMENTARE DECREMENTARE
%left SAUB
%left SIB
%left CONCATS
%left COMP
%left ISIN

%union
{
    int num;
    char* str;
}

%type <num> expresie NUMAR
%type <str> PRODUCATOR DACIASTRING TESLACHAR IDENTIFICATOR INCREMENTARE DECREMENTARE PLUSEGAL MINUSEGAL INMULTIREEGAL IMPARTIREEGAL parameteri argumente apelare_functie stiva_apelare PROPOZITIE CARACTER
%type <str> bexpresie TRUE FALSE
%%

correct : program {printf("program perfect\n"); AFISARE();}
        ;


program : clase declaratii main
        | declaratii main
        | clase main
        | main
        ;

inceput_main : PRODUCATOR PRINCIPAL argumente {tabel_simboluri("global");}
             ;

clase : clasa
        | clase clasa
        ;

clasa : CLASA IDENTIFICATOR ACOLADADESCHISA declaratii ACOLADAINCHISA PUNCTVIRGULA {tabel_simboluri($2);}
      | CLASA IDENTIFICATOR ACOLADADESCHISA ACOLADAINCHISA PUNCTVIRGULA {tabel_simboluri($2);}


declaratii : declaratie
             | declaratii declaratie
             ;

declaratie : CONSTANT PRODUCATOR IDENTIFICATOR PUNCTVIRGULA {declarare_fara_initializare($2, $3, 1);}
            | PRODUCATOR IDENTIFICATOR PUNCTVIRGULA {declarare_fara_initializare($1, $2, 0);}
            | CONSTANT PRODUCATOR IDENTIFICATOR EGAL NUMAR PUNCTVIRGULA {declarare_cu_initilizarea_valorii($2, $3, $5, 1);}
            | PRODUCATOR IDENTIFICATOR EGAL NUMAR PUNCTVIRGULA {declarare_cu_initilizarea_valorii($1, $2, $4, 0);}
            | CONSTANT PRODUCATOR IDENTIFICATOR EGAL IDENTIFICATOR  {declarare_cu_initializarea_a_variabilei($2, $3, $5, 1);}
            | PRODUCATOR IDENTIFICATOR EGAL IDENTIFICATOR PUNCTVIRGULA {declarare_cu_initializarea_a_variabilei($1, $2, $4, 0);}
            | PRODUCATOR IDENTIFICATOR dimensiune PUNCTVIRGULA
            | PRODUCATOR IDENTIFICATOR argumente {declarare_functie($1, $2, $3);}
            | DACIASTRING IDENTIFICATOR PUNCTVIRGULA {declar_dacie_no_init($2);}
            | DACIASTRING IDENTIFICATOR EGAL PROPOZITIE PUNCTVIRGULA {declar_dacie_init($2,$4);}
            | TESLACHAR IDENTIFICATOR PUNCTVIRGULA {declarare_fara_initializare($1, $2 ,0);}
            | TESLACHAR IDENTIFICATOR EGAL CARACTER PUNCTVIRGULA{declarare_cu_initilizarea_valorii($1, $2, atoi($4), 0);}
            | BOOL IDENTIFICATOR PUNCTVIRGULA {decl_bool_no_init($2);}
            | BOOL IDENTIFICATOR EGAL IDENTIFICATOR PUNCTVIRGULA { decl_bool_init($2, $4);}
            | BOOL IDENTIFICATOR EGAL TRUE PUNCTVIRGULA {decl_bool_init($2, $4);}
            | BOOL IDENTIFICATOR EGAL FALSE PUNCTVIRGULA {decl_bool_init($2, $4);}
            ;

dimensiune : PATRATADESCHISA NUMAR PATRATAINCHISA
           | dimensiune PATRATADESCHISA NUMAR PATRATAINCHISA

main : inceput_main ACOLADADESCHISA blocuri_cod ACOLADAINCHISA {tabel_simboluri("princpial");}
     ;

argumente : ROTUNDADESCHISA ROTUNDAINCHISA {$$ = malloc(200); $$[0] = 0;}
     | ROTUNDADESCHISA parameteri ROTUNDAINCHISA {$$ = $2;}
     ;

parameteri : PRODUCATOR IDENTIFICATOR {$$ = $1; strcat($$, ", ");}
           | parameteri VIRGULA parameteri {$$ = $1; strcat($$, $3);}
           ;

blocuri_cod : bloc
       | ACOLADADESCHISA bloc ACOLADAINCHISA
       | blocuri_cod bloc
       ;

bloc : IF ROTUNDADESCHISA conditie ROTUNDAINCHISA declaratie_conditie PUNCTVIRGULA
      | IF ROTUNDADESCHISA conditie ROTUNDAINCHISA declaratie_conditie PUNCTVIRGULA ELSE declaratie_conditie PUNCTVIRGULA
      | IF ROTUNDADESCHISA conditie ROTUNDAINCHISA declaratie_conditie PUNCTVIRGULA ELSE ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA
      | IF ROTUNDADESCHISA conditie ROTUNDAINCHISA ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA
      | IF ROTUNDADESCHISA conditie ROTUNDAINCHISA ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA ELSE declaratie_conditie PUNCTVIRGULA
      | IF ROTUNDADESCHISA conditie ROTUNDAINCHISA ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA ELSE ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA
      | FOR ROTUNDADESCHISA declaratie_conditie PUNCTVIRGULA conditie PUNCTVIRGULA declaratie_conditie ROTUNDAINCHISA declaratie_conditie PUNCTVIRGULA
      | FOR ROTUNDADESCHISA declaratie_conditie PUNCTVIRGULA conditie PUNCTVIRGULA declaratie_conditie ROTUNDAINCHISA ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA
      | WHILE ROTUNDADESCHISA conditie ROTUNDAINCHISA declaratie_conditie PUNCTVIRGULA
      | WHILE ROTUNDADESCHISA conditie ROTUNDAINCHISA ACOLADADESCHISA declaratii_conditie ACOLADAINCHISA
      | declaratie_conditie PUNCTVIRGULA
      | declaratie
      ;

conditie : operand
          | operand M operand
          | operand MM operand
          | operand MEGAL operand
          | operand MMEGAL operand
          | operand EGALEGAL operand
          | operand NONEGAL operand
          | NON operand
          | conditie SI conditie
          | conditie SAU conditie
          | ROTUNDADESCHISA conditie ROTUNDAINCHISA
          ;

operand : IDENTIFICATOR
        | NUMAR
        | apelare_functie
        ;

declaratii_conditie : declaratie_conditie PUNCTVIRGULA
           | declaratii_conditie declaratie_conditie PUNCTVIRGULA
           ;

declaratie_conditie : IDENTIFICATOR EGAL expresie {asignare_valoare($1, $3);}
          | IDENTIFICATOR INCREMENTARE {incrementare_sau_decrementare($1, $2);}
          | IDENTIFICATOR DECREMENTARE {incrementare_sau_decrementare($1, $2);}
          | INCREMENTARE IDENTIFICATOR {incrementare_sau_decrementare($2, $1);}
          | DECREMENTARE IDENTIFICATOR {incrementare_sau_decrementare($2, $1);}
          | IDENTIFICATOR PLUSEGAL expresie {asignare_numar_cu_operator($1, $3, $2);}
          | IDENTIFICATOR MINUSEGAL expresie {asignare_numar_cu_operator($1, $3, $2);}
          | IDENTIFICATOR INMULTIREEGAL expresie {asignare_numar_cu_operator($1, $3, $2);}
          | IDENTIFICATOR IMPARTIREEGAL expresie {asignare_numar_cu_operator($1, $3, $2);}
          | IDENTIFICATOR CONCATS IDENTIFICATOR { concat($1,$3);}
          | apelare_functie
          | AFISEAZA ROTUNDADESCHISA expresie ROTUNDAINCHISA {ADAOS($3);}
          | declaratie_conditie VIRGULA declaratie_conditie
          | IDENTIFICATOR EGAL bexpresie {assign_bool($1, $3);}

          ;

expresie : expresie PLUS expresie {$$ = $1 + $3;}
     | expresie MINUS expresie {$$ = $1 - $3;}
     | expresie INMULTIRE expresie {$$ = $1 * $3;}
     | expresie IMPARTIRE expresie {$$ = $1 / $3;}
     | ROTUNDADESCHISA expresie ROTUNDAINCHISA {$$ = $2;}
     | NUMAR {$$ = $1;}
     | IDENTIFICATOR PATRATADESCHISA NUMAR PATRATAINCHISA {$$ = 0;}
     | IDENTIFICATOR PATRATADESCHISA NUMAR PATRATAINCHISA EGAL NUMAR PUNCTVIRGULA{$$=$6}
     | IDENTIFICATOR PUNCT IDENTIFICATOR {$$ = 0;}
     | IDENTIFICATOR {$$ = valoarea_variabilei($1);}
     | LEN IDENTIFICATOR {$$ = leng($2);}
     | IDENTIFICATOR COMP IDENTIFICATOR {$$ = compar($1,$3);}
     | IDENTIFICATOR ISIN IDENTIFICATOR {$$ = contain($1,$3);}
     ;

bexpresie : bexpresie SIB bexpresie { $$ = bool_si($1,$3);}
     | bexpresie SAUB bexpresie { $$ = bool_sau($1,$3);}
     | TRUE { $$ = $1;}
     | FALSE { $$ = $1;}


apelare_functie : IDENTIFICATOR ROTUNDADESCHISA stiva_apelare ROTUNDAINCHISA {$$ = tip_returnare_functie ($1, $3);}
             ;

stiva_apelare : expresie {$$ = malloc (200); strcpy($$, "int, ");}
          | apelare_functie {$$ = $1; strcat($$, ", ");}
          | stiva_apelare VIRGULA stiva_apelare {$$ = $1; strcat($$, $3);}
          ;

%%

int yyerror(char * s)
{
    printf("error: %s\n line: %d\n", s, yylineno);
}

int main(int argc, char** argv)
{
    if (argc > 1) yyin = fopen(argv[1], "r");
    FILE* descriptor_fisier = fopen("tabel_de_simboluri.txt", "w");
    fclose(descriptor_fisier);
    yyparse();
    descriptor_fisier = fopen("tabel_de_simboluri.txt", "a");
    fprintf(descriptor_fisier, "Functiile declarate sunt:\n");
    for (int i = 0; i < f_nr; i++)
    {
        fprintf(descriptor_fisier, "[%s] %s (%s)\n", functii[i].marca, functii[i].model, functii[i].argumente);
    }
    fclose(descriptor_fisier);
} 
