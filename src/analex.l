%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "sintacticoBison.tab.h"
%}

/* Patrones básicos */
DIGIT      [0-9]
OCTETO     {DIGIT}{1,3}

/* IP válida */
IPV4       {OCTETO}"."{OCTETO}"."{OCTETO}"."{OCTETO}

/* Cualquier cosa que parezca intento de IP pero incorrecto → capturar TODA LA LÍNEA */
BADLINE    [0-9\.]+

%%

{IPV4} {
    strncpy(yylval.dir, yytext, sizeof(yylval.dir));
    return DIRECCION;
}

{BADLINE} {
    strncpy(yylval.dir, yytext, sizeof(yylval.dir));
    return INVALIDA;
}

"chmod" {
    yylval.reservada = strdup(yytext);
    return CHMOD;
}

{DIGIT}+ {
    yylval.number = atoi(yytext);
    return ENTERO;
}

"\n"    return SALTO;
.       return OTHER;

%%

int yywrap() { return 1; }
