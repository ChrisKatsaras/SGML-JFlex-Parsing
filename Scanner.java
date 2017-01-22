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
      PrintWriter out = new PrintWriter("output.txt");
      while( (tok=scanner.getNextToken()) != null ){
        System.out.println(tok);
        out.println(tok);
      }
      out.close();
    }
    catch (Exception e) {
      System.out.println("Unexpected exception:");
      e.printStackTrace();
    }
  }
}
