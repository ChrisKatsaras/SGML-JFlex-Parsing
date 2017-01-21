class Token {

  public final static int OPEN = 0;
  

  public int m_type;
  public String m_value;
  public int m_line;
  public int m_column;
  
  Token (int type, String value, int line, int column) {
    m_type = type;
    m_value = value;
    m_line = line;
    m_column = column;
  }

  public String toString() {
    switch (m_type) {
      case OPEN:
        return "OPEN";
      default:
        return "UNKNOWN(" + m_value + ")";
    }
  }
}

