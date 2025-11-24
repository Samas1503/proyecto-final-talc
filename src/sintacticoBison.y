%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    int yyerror(const char *s);

    int validarIP(char *ip);
    void clasificarIP(char *ip);
%}

/* TOKENS */
%token CHMOD DIRECCION INVALIDA PUNTO ENTERO SALTO OTHER

%union {
    char dir[20];
    int number;
    char *reservada;
}

%type <dir> DIRECCION INVALIDA
%type <number> ENTERO
%type <reservada> CHMOD

%%

prog:
      INSTRUCCIONES
;

INSTRUCCIONES:
      /* vacío */
    | INSTRUCCION SALTO INSTRUCCIONES
;

INSTRUCCION:
      DIRECCION
        {
            if (validarIP($1)) clasificarIP($1);
        }
    | INVALIDA
        {
            printf("Error: formato inválido (%s)\n", $1);
        }
    | ENTERO
        { printf("(entero) %d\n", $1); }
    | CHMOD
        { printf("(cmd) %s\n", $1); }
    | OTHER
        { printf("Error: token desconocido\n"); }
;

%%

int validarIP(char *ip) {
    int a,b,c,d;
    if (sscanf(ip, "%d.%d.%d.%d", &a,&b,&c,&d) != 4) {
        printf("Error: formato inválido (%s)\n", ip);
        return 0;
    }

    if (a>255 || b>255 || c>255 || d>255 ||
        a<0 || b<0 || c<0 || d<0) {
        printf("Error: octeto fuera de rango (%s)\n", ip);
        return 0;
    }

    return 1;
}

void clasificarIP(char *ip) {
    int a,b,c,d;
    sscanf(ip, "%d.%d.%d.%d", &a,&b,&c,&d);

    printf("%s → ", ip);

    if (a >= 1 && a <= 126) {
        printf("Clase A – %s\n", (a == 10 ? "Privada" : "Pública"));
    }
    else if (a >= 128 && a <= 191) {
        printf("Clase B – %s\n",
            (a == 172 && (b>=16 && b<=31) ? "Privada" : "Pública"));
    }
    else if (a >= 192 && a <= 223) {
        printf("Clase C – %s\n",
            (a == 192 && b == 168 ? "Privada" : "Pública"));
    }
    else {
        printf("Clase D/E\n");
    }
}

int yyerror(const char *s) {
    printf("Error sintáctico: %s\n", s);
    return 0;
}

int main() {
    yyparse();
    return 0;
}
