import java.io.*;
public class Scanner {
  private Lexer scanner = null;

  public Scanner( Lexer lexer ) {
    scanner = lexer; 
  }

  public Token getNextToken() throws java.io.IOException {
    return scanner.yylex();
  }

  public static void main(String argv[]) {

    try {
      Scanner scanner = new Scanner(new Lexer(new InputStreamReader(System.in)));
      Token tok = null;
      PrintWriter out = new PrintWriter("output.txt"); //Declares to filewriters. One for regular output and one for error output
      PrintWriter errorOut = new PrintWriter("error.txt");

      while( (tok=scanner.getNextToken()) != null ){
        //If token is relevant, output it to output file. Else if it is an error, output to error file
        if(tok.m_toOutput == 1){
          out.println(tok);
        } else if(tok.m_toOutput == -1) {

          errorOut.println("ERROR! Close tag "+tok+" does not match open tag!");
        }
      }
      out.close(); //Closes filewriters
      errorOut.close();
    }
    catch (Exception e) {
      System.out.println("Unexpected exception:");
      e.printStackTrace();
    }
  }
}
