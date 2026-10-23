%{
#include <stdio.h>
%}

%option yylineno

%%

"int"       { printf("INT: %s\n", yytext); }
"double"    { printf("DOUBLE: %s\n", yytext); }
"main"      { printf("MAIN: %s\n", yytext); }
"if"        { printf("IF: %s\n", yytext); }
"else"      { printf("ELSE: %s\n", yytext); }
"print"     { printf("PRINT: %s\n", yytext); }
"get"       { printf("GET: %s\n", yytext); }
"while"     { printf("WHILE: %s\n", yytext); }
"void"      { printf("VOID: %s\n", yytext); }
[A-Z][a-zA-Z0-9_]*  { printf("ID: %s\n", yytext); }
[0-9]+"."[0-9]+ {
    printf("DOUBLE_LITERAL: %s\n", yytext);
}

[0-9]+ {
    printf("INT_LITERAL: %s\n", yytext);
}

"+"         { printf("PLUS: %s\n", yytext); }
"-"         { printf("MINUS: %s\n", yytext); }
"*"         { printf("TIMES: %s\n", yytext); }
"/"         { printf("DIV: %s\n", yytext); }
"="         { printf("ASG: %s\n", yytext); }
"=="        { printf("EQ: %s\n", yytext); }
"<>"        { printf("NE: %s\n", yytext); }
"<="        { printf("LE: %s\n", yytext); }
">="        { printf("GE: %s\n", yytext); }
"<"         { printf("LT: %s\n", yytext); }
">"         { printf("GT: %s\n", yytext); }

"("         { printf("LPAREN: %s\n", yytext); }
")"         { printf("RPAREN: %s\n", yytext); }
"{"         { printf("OP: %s\n", yytext); }
"}"         { printf("CL: %s\n", yytext); }
","         { printf("COMMA: %s\n", yytext); }
\"([^\"\\\n]|\\.)*\" {
    printf("STRING_LITERAL: %s\n", yytext);
}

"!"[^!\n]*"!"    { /* Ignore comments */ }
"!"[^!\n]*       {
    printf("Lexical Error: Unterminated comment at line %d\n", yylineno);
}

[ \t\r\n]+  { /* Ignore whitespace */ }

[0-9]+[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Lexical Error: Invalid identifier '%s' at line %d\n",
           yytext, yylineno);
}

[a-z][a-zA-Z0-9_]* {
    printf("Lexical Error: Invalid identifier '%s' at line %d\n",
           yytext, yylineno);
}

. {
    printf("Lexical Error: Invalid character '%s' at line %d\n",
           yytext, yylineno);
}

%%

int main(void)
{
    yylex();
    return 0;
}
