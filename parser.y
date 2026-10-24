%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylineno;
extern int lexical_errors;

int yylex(void);
void yyerror(const char *message);
%}

%token INT DOUBLE VOID MAIN IF ELSE PRINT GET WHILE
%token ID INT_LITERAL DOUBLE_LITERAL STRING_LITERAL
%token PLUS MINUS TIMES DIV ASG EQ NE LT LE GT GE
%token LPAREN RPAREN OP CL COMMA LEX_ERROR

%start Start_Program

%%

Start_Program
    : main_function other_functions
    ;

other_functions
    : /* empty */
    | other_functions other_function
    ;

main_function
    : INT MAIN LPAREN RPAREN OP statements CL
    ;

other_function
    : VOID ID LPAREN RPAREN OP statements CL
    ;

statements
    : statement
    | statements statement
    ;

statement
    : declaration
    | assignment
    | print_statement
    | get_statement
    | condition_statement
    | while_statement
    | function_call
    ;

declaration
    : type identifier_list
    ;

type
    : INT
    | DOUBLE
    ;

identifier_list
    : ID
    | identifier_list COMMA ID
    ;

assignment
    : ID ASG expression
    ;

expression
    : exp
    | exp EQ exp
    | exp NE exp
    | exp LT exp
    | exp LE exp
    | exp GT exp
    | exp GE exp
    ;

exp
    : term
    | exp PLUS term
    | exp MINUS term
    ;

term
    : factor
    | term TIMES factor
    | term DIV factor
    ;

factor
    : LPAREN exp RPAREN
    | INT_LITERAL
    | DOUBLE_LITERAL
    | STRING_LITERAL
    | ID
    ;

print_statement
    : PRINT LPAREN expression_list RPAREN
    ;

expression_list
    : expression
    | expression_list COMMA expression
    ;

get_statement
    : ID ASG GET LPAREN RPAREN
    ;

condition_statement
    : IF LPAREN expression RPAREN OP statements CL
    | IF LPAREN expression RPAREN OP statements CL ELSE OP statements CL
    ;

while_statement
    : WHILE LPAREN expression RPAREN OP statements CL
    ;

function_call
    : ID LPAREN RPAREN
    ;

%%

void yyerror(const char *message)
{
    fprintf(stderr, "Syntax error at line %d: %s\n", yylineno, message);
}

int main(int argc, char **argv)
{
    int parse_result;

    if (argc > 2) {
        fprintf(stderr, "Usage: %s [source_file.min]\n", argv[0]);
        return 2;
    }

    if (argc == 2) {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL) {
            perror(argv[1]);
            return 2;
        }
    }

    parse_result = yyparse();

    if (argc == 2 && yyin != NULL) {
        fclose(yyin);
    }

    if (parse_result == 0 && lexical_errors == 0) {
        printf("Syntax analysis successful.\n");
        return 0;
    }

    if (lexical_errors > 0) {
        fprintf(stderr, "Analysis failed: %d lexical error(s) found.\n",
                lexical_errors);
    }
    return 1;
}
