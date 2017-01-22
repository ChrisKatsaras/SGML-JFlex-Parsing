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

blankspace = [ |\r|\n|\t]+
letter = [a-zA-Z]
digit = [0-9]
word = ({letter}|{digit})*{letter}({letter}|{digit})*
number = ("-"|"+")?{digit}+("."{digit}+)?
apostrophized = {word}+"'"{word}+("'"{word}+)*
hyphenApostrophized = ({word}"-"{apostrophized}|{word}"-"{word}"-"{apostrophized})
hyphen = {word}"-"{word}("-"{word})*
punctuation = [^ \r\n\ta-zA-Z0-9"<"">"]
%%
   
/*
   This section contains regular expressions and actions, i.e. Java
   code, that will be executed when the scanner matches the associated
   regular expression. */
   

{blankspace}	{/*Skip over whitespace*/}
"<"{blankspace}*[0-9a-zA-Z"-""_"][0-9a-zA-Z"-""_"]*{blankspace}*">" { 
												//for(i=0;i<yytext.length();i++) {

												//}
												return new Token(Token.OPEN, yytext(), yyline, yycolumn); 
											}
"</"{blankspace}*[0-9a-zA-Z"-""_"][0-9a-zA-Z"-""_"]*{blankspace}*">"	{   

												return new Token(Token.CLOSE, yytext(), yyline, yycolumn); 
											}									
{word}										{ return new Token(Token.WORD, yytext(), yyline, yycolumn); }
{number}									{ return new Token(Token.NUMBER, yytext(), yyline, yycolumn); }
{apostrophized}								{ return new Token(Token.APOSTROPHIZED, yytext(), yyline, yycolumn); }
{hyphenApostrophized}						{ return new Token(Token.APOSTROPHIZED, yytext(), yyline, yycolumn); }
{hyphen}									{ return new Token(Token.HYPHEN, yytext(), yyline, yycolumn); }
{punctuation}								{ return new Token(Token.PUNCTUATION, yytext(), yyline, yycolumn); }

