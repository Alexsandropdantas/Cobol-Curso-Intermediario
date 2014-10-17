      $SET SQL() TRACE
       identification division.
       environment    division.
       configuration  section.
       special-names. decimal-point is comma.
       input-output   section.
       file-control.
       data division.
       working-storage section.
       01 registro                  pic 9(10).

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 ws-database  pic x(15).
       01 ws-user      pic x(15).
       01 ws-senha     pic x(15).
       01 opcao        pic 9(01) value zeros.
       01 espera       pic x(01) value spaces.
       01 comando-sql  pic x(99) value spaces.

       procedure division.
       inicio.
           display "Ready Trace"
           ready trace
           initialize espera registro.
       conectando.
           EXEC SQL
               CONNECT TO "DBCBL" AS "CONEXAO"
                     USER "root" USING "root"
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           display "Conectou OK = CONEXAO".
       verview.
           initialize registro.
       openview.
           EXEC SQL
                DECLARE CURSORVIEW CURSOR FOR
                   SELECT * FROM LINGUAGENS
           END-EXEC

           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if.
       opencursor.
           EXEC SQL
                OPEN CURSORVIEW
           END-EXEC.
       closecursor.
           EXEC SQL
                CLOSE CURSORVIEW
           END-EXEC.
       desconectar.
           EXEC SQL
                DISCONNECT all
           END-EXEC
           display "DisconnectOK= CONEXAO"
           display "Enter Finaliza..."
           accept espera
           exit program
           stop run.