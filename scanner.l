%{
#include <stdio.h>
#include "y.tab.h"

extern int lexical_errors;
%}

%option yylineno noyywrap

%%

"int"       { return INT; }
"double"    { return DOUBLE; }
"main"      { return MAIN; }
"if"        { return IF; }
"else"      { return ELSE; }
"print"     { return PRINT; }
"get"       { return GET; }
"while"     { return WHILE; }
"void"      { return VOID; }

"=="        { return EQ; }
"<>"        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"<"         { return LT; }
">"         { return GT; }
"="         { return ASG; }

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIV; }

"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return OP; }
"}"         { return CL; }
","         { return COMMA; }

[0-9]+"."[0-9]+ { return DOUBLE_LITERAL; }
[0-9]+          { return INT_LITERAL; }

\"([^\"\\\n]|\\.)*\" { return STRING_LITERAL; }

[A-Z][a-zA-Z0-9_]* { return ID; }

"!"[^!\n]*"!" { /* Ignore comments */ }

[ \t\r\n]+ { /* Ignore whitespace */ }

[0-9]+[a-zA-Z_][a-zA-Z0-9_]* {
    fprintf(stderr,
        "Lexical error at line %d: invalid identifier '%s'\n",
        yylineno, yytext);
    lexical_errors++;
    return LEX_ERROR;
}

[a-z][a-zA-Z0-9_]* {
    fprintf(stderr,
        "Lexical error at line %d: invalid identifier '%s'\n",
        yylineno, yytext);
    lexical_errors++;
    return LEX_ERROR;
}

"!"[^!\n]* {
    fprintf(stderr,
        "Lexical error at line %d: unterminated comment\n",
        yylineno);
    lexical_errors++;
    return LEX_ERROR;
}

. {
    fprintf(stderr,
        "Lexical error at line %d: invalid character '%s'\n",
        yylineno, yytext);
    lexical_errors++;
    return LEX_ERROR;
}

%%
int lexical_errors = 0;
