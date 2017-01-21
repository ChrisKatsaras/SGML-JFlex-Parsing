/*
  File Name: SGML.flex
  JFlex spec for SGML
*/
import java.util.*; 
%%
   
%class Lexer
%type Token
%line
%column

//Stack for parsing
%{
  private static ArrayList<String> stack = new ArrayList<String>();
%};
    
%eofval{
  return null;
%eofval};


   
%%
   
/*
   This section contains regular expressions and actions, i.e. Java
   code, that will be executed when the scanner matches the associated
   regular expression. */
   

"OPEN"             { return new Token(Token.OPEN, yytext(), yyline, yycolumn); }

