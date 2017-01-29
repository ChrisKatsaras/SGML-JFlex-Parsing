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

%{
  private static ArrayList<String> stack = new ArrayList<String>(); //Stack allows us to keep track of open tags and match them with coresponding close tags
  int toOutput; //Represents whether or not the token should be written to output.txt
%};
    
%eofval{
	//Prints any unmatched open tags to the user when end of file is reached
	if(!stack.isEmpty()) {
		System.out.println("Unmatched open tags left are: "+ stack);
	}
  return null;
%eofval};

blankspace = [ |\r|\n|\t]+ //Whitespace
letter = [a-zA-Z] //Singular upcase or lowercase letter
digit = [0-9] //Single digit
word = ({letter}|{digit})*{letter}({letter}|{digit})* //A string of characters and letters e.g mp3 or 123abc
number = ("-"|"+")?{digit}+("."{digit}+)? //positive or negative real/integers
apostrophized = ({letter}|{digit})+"'"({letter}|{digit})+("'"({letter}|{digit})+)* //Words with apostrophies e.g O'Rielly 
hyphenApostrophized = (({letter}|{digit})+"-"{apostrophized}|({letter}|{digit})+"-"({letter}|{digit})+"-"{apostrophized}) //Hyphenated words with apostrophies
hyphen = ({letter}|{digit})+"-"({letter}|{digit})+("-"({letter}|{digit})+)* //Hyphenated words 
punctuation = [^ \r\n\ta-zA-Z0-9"<"">"] //Anything that does not fall under that categories above

%%

/*
   This section contains regular expressions and actions, i.e. Java
   code, that will be executed when the scanner matches the associated
   regular expression. */
   

{blankspace}	{/*Skip over whitespace*/}
"<"{blankspace}*[0-9a-zA-Z"-""_"][0-9a-zA-Z"-""_"]*{blankspace}*([0-9a-zA-Z"-""_"][0-9a-zA-Z"-""_"]*{blankspace}*"="{blankspace}*"\""[0-9a-zA-Z"-""_"][0-9a-zA-Z"-""_"]*"\"")?{blankspace}*">" { 

												int i;
												int begin = 0;
												int end = 0;
												String openTag = yytext();
												String trimmedTag;
												toOutput = 0;

												//Iterate through open tag until a letter,digit, - or _ is found.
												//One one is found, this will represent the beginning of the token
												for(i=0;i<openTag.length();i++) {

													if((openTag.charAt(i) >= 'a' && openTag.charAt(i) <= 'z')) {
														begin = i;
														break;
													}
													if((openTag.charAt(i) >= 'A' && openTag.charAt(i) <= 'Z')) {
														begin = i;
														break;
													}
													if((openTag.charAt(i) >= '0' && openTag.charAt(i) <= '9')) {
														begin = i;
														break;
													}
													if((openTag.charAt(i) == '_' && openTag.charAt(i) == '-')) {
														begin = i;
														break;
													}
												}

												//Iterate rest of open tag to find the end which will be signified with either whitespace or >
												for(i=begin;i<openTag.length();i++) {

													if(openTag.charAt(i) == ' ' || openTag.charAt(i) == '>') {
														end = i;
														break;
													}	
												}	
												trimmedTag = openTag.substring(begin,end); //Replaces the original token with trimmed version
												trimmedTag = trimmedTag.toUpperCase(); //Ensures that tag name is converted to uppercase
												
												//If the open tag matches any of the relevant tag names, then flag it to be written to output.txt
												if(trimmedTag.equals("TEXT") || trimmedTag.equals("DATE") || trimmedTag.equals("DOC") || trimmedTag.equals("DOCNO") || trimmedTag.equals("HEADLINE") || trimmedTag.equals("LENGTH")) {
													toOutput = 1;
												}
												//If the open tag is <P> then we must check the previous open tag on the stack to ensure it is relevant
												if(trimmedTag.equals("P")) {
													String previousTag = stack.get(stack.size()-1);
													if(previousTag.equals("TEXT") || previousTag.equals("DATE") || previousTag.equals("DOC") || previousTag.equals("DOCNO") || previousTag.equals("HEADLINE") || previousTag.equals("LENGTH")) {
														toOutput = 1;
													} else {
														toOutput = 0;
													}
												}
												stack.add(trimmedTag); //Push tag to stack

												return new Token(Token.OPEN, trimmedTag, yyline, yycolumn,toOutput); 
											}

"</"{blankspace}*[0-9a-zA-Z"-""_"][0-9a-zA-Z"-""_"]*{blankspace}*">" {

												int i;
												int begin = 0;
												int end = 0;
												int error = 0;
												int tempToOutput = toOutput;
												String closeTag = yytext();
												String trimmedTag;

												//Iterate through close tag until a letter,digit, - or _ is found.
												//One one is found, this will represent the beginning of the token
												for(i=0;i<closeTag.length();i++) {

													if((closeTag.charAt(i) >= 'a' && closeTag.charAt(i) <= 'z')) {
														begin = i;
														break;
													}
													if((closeTag.charAt(i) >= 'A' && closeTag.charAt(i) <= 'Z')) {
														begin = i;
														break;
													}
													if((closeTag.charAt(i) >= '0' && closeTag.charAt(i) <= '9')) {
														begin = i;
														break;
													}
													if((closeTag.charAt(i) == '_' && closeTag.charAt(i) == '-')) {
														begin = i;
														break;
													}
												}

												//Iterate rest of close tag to find the end which will be signified with either whitespace or >
												for(i=begin;i<closeTag.length();i++) {

													if(closeTag.charAt(i) == ' ' || closeTag.charAt(i) == '>') {
														end = i;
														break;
													}	
												}

												trimmedTag = closeTag.substring(begin,end); //Replaces the original token with trimmed version
												trimmedTag = trimmedTag.toUpperCase(); //Ensures that tag name is converted to uppercase
												
												//If the close tag does not match the top open tag on the stack then report error to user
												if(!stack.get(stack.size()-1).equals(trimmedTag)) {
													System.out.println("Open tag does not match closing tag named "+trimmedTag);
													error = 1;

												} else {
													stack.remove(stack.size()-1); //Otherwise, remove top open tag from stack
												}

												//If the stack isn't empty, check to see if the top tag is relevant. Set priority accordingly
												if(stack.size() >= 1){	
											
													if(stack.get(stack.size()-1).equals("TEXT") || stack.get(stack.size()-1).equals("DATE") || stack.get(stack.size()-1).equals("DOC") || stack.get(stack.size()-1).equals("DOCNO") || stack.get(stack.size()-1).equals("HEADLINE") || stack.get(stack.size()-1).equals("LENGTH") || stack.get(stack.size()-1).equals("P")) {
														toOutput = 1;
													} else {
														toOutput = 0;
													}
												}

												//If the close tag did not match the open tag then we must return the error token so we can output to error.txt
												if(error == 1) {
													return new Token(Token.ERROR, trimmedTag, yyline, yycolumn, -1);
												} else {
													return new Token(Token.CLOSE, trimmedTag, yyline, yycolumn,tempToOutput);
												}
												 
											}									
{word}										{ return new Token(Token.WORD, yytext(), yyline, yycolumn,toOutput); }
{number}									{ return new Token(Token.NUMBER, yytext(), yyline, yycolumn,toOutput); }
{apostrophized}								{ return new Token(Token.APOSTROPHIZED, yytext(), yyline, yycolumn,toOutput); }
{hyphenApostrophized}						{ return new Token(Token.APOSTROPHIZED, yytext(), yyline, yycolumn,toOutput); }
{hyphen}									{ return new Token(Token.HYPHEN, yytext(), yyline, yycolumn,toOutput); }
{punctuation}								{ return new Token(Token.PUNCTUATION, yytext(), yyline, yycolumn,toOutput); }