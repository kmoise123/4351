package Parse;
import ErrorMsg.ErrorMsg;

%% 

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{
private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
  errorMsg.error(pos,s);
}

private void err(String s) {
  err(yychar,s);
}

private java_cup.runtime.Symbol tok(int kind) {
    return tok(kind, null);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
    return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

private ErrorMsg errorMsg;

Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg=e;
}

%}

%eofval{
	{
	 return tok(sym.EOF, null);
        }
%eofval}       

%state COMMENT
%state STRING
%state ERROR
%{
  private int comment_count =0;
  private string "";
%}

%%

<YYINITIAL> " " {}
<YYINITIAL,COMMENT> \n  {newline();}

<YYINITIAL> "while" {return tok(sym.WHILE);}
<YYINITIAL> "for" {return tok(sym.FOR);}
<YYINITIAL> "to" {return tok(sym.TO);}
<YYINITIAL> "break" {return tok(sym.BREAK);}
<YYINITIAL> "let" {return tok(sym.LET);}
<YYINITIAL> "in" {return tok(sym.IN);}
<YYINITIAL> "end" {return tok(sym.END);}
<YYINITIAL> "function" {return tok(sym.FUNCTION);}
<YYINITIAL> "var" {return tok(sym.VAR);}
<YYINITIAL> "type" {return tok(sym.TYPE);}
<YYINITIAL> "array" {return tok(sym.ARRAY);}
<YYINITIAL> "if" {return tok(sym.IF);}
<YYINITIAL> "then" {return tok(sym.THEN);}
<YYINITIAL> "else" {return tok(sym.ELSE);}
<YYINITIAL> "do" {return tok(sym.DO);}
<YYINITIAL> "of" {return tok(sym.OF);}
<YYINITIAL> "nil" {return tok(sym.NIL);}


<YYINITIAL> "," {return tok(sym.COMMA,null);}
<YYINITIAL> ":" {return tok(sym.COLON,null);}
<YYINITIAL> ";" {return tok(sym.SEMICOLON,null);}
<YYINITIAL> "(" {return tok(sym.LPAREN,null);}
<YYINITIAL> ")" {return tok(sym.RPAREN,null);}
<YYINITIAL> "[" {return tok(sym.LBRACK,null);}
<YYINITIAL> "]" {return tok(sym.RBRACK,null);}
<YYINITIAL> "{" {return tok(sym.LBRACE,null);}
<YYINITIAL> "}" {return tok(sym.RBRACE,null);}
<YYINITIAL> "." {return tok(sym.DOT,null);}
<YYINITIAL> "+" {return tok(sym.PLUS,null);}
<YYINITIAL> "-" {return tok(sym.MINUS,null);}
<YYINITIAL> "*" {return tok(sym.TIMES,null);}
<YYINITIAL> "/" {return tok(sym.DIVIDE,null);}
<YYINITIAL> "=" {return tok(sym.EQ,null);}
<YYINITIAL> "<>" {return tok(sym.NEQ,null);}
<YYINITIAL> "<" {return tok(sym.LT,null);}
<YYINITIAL> "<=" {return tok(sym.LE,null);}
<YYINITIAL> ">" {return tok(sym.GT,null);}
<YYINITIAL> ">=" {return tok(sym.GE,null);}
<YYINITIAL> "&" {return tok(sym.AND,null);}
<YYINITIAL> "|" {return tok(sym.OR,null);}
<YYINITIAL> ":=" {return tok(sym.ASSIGN,null);}

<YYINITIAL> [0-9]+ {return tok(sym.INT, yytext());}
<YYINITIAL> [a-zA-Z][a-zA-Z0-9]* {return tok(sym.ID),yytext();}

<YYINITIAL> "/*" {yybegin(COMMENT);comment_count=comment_count+1;}
<COMMENT> "/*" {comment_count=comment_count+1;}
<COMMENT> "*/" {
  comment_count=comment_count-1;
  if(comment_count==0){
    yybegin(YYINITIAL);
  }
}

<YYINITIAL> \" {string ="";yybegin(STRING);}
<STRING> \" {return tok(sym.STRING),string; yybegin(YYINITIAL);}

<YYINITIAL,COMMENT> . { err("Illegal character: " + yytext()); }
