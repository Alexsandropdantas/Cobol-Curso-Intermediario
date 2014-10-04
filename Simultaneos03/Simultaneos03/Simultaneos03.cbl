      $SET SQL

       identification division.
       program-id. Simultaneos03.


       working-storage section.
      * Aqui vamos descrever definições de SQLCODE
      *      padrão para conexões com bancos de dados para Microfocus
       EXEC SQL 
           INCLUDE SQLCA 
       END-EXEC
      * Variáveis que serão utilizadas:
       01 ws-database  pic x(15).
       01 ws-user      pic x(15).
       01 ws-senha     pic x(15).
       01 opcao        pic 9(01) value zeros.
       01 espera       pic x(01) value spaces.
       01 comando-sql  pic x(99) value spaces.
       procedure division.
       inicio.
           initialize opcao espera
           display erase at 0101
           display "Conexoes Simultaneas" at 0401.
       conectando.
           EXEC SQL
               CONNECT TO "DBCBL" AS "CONEXAO1"
                     USER "root" USING "root"
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar 1 " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql disconnect all end-exec
                stop run
           end-if
           display "Conectou OK = CONEXAO1" at 0601

           EXEC SQL
               CONNECT TO "DBCBL2" AS "CONEXAO2"
                     USER "root" USING "root"
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar 2 " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql disconnect all end-exec
                stop run
           end-if
           display "Conectou OK = CONEXAO2" at 0801.

       criandotabela.
           EXEC SQL CREATE TABLE TESTE1
              (caracteres    CHAR(10))
           END-EXEC

           if sqlcode not = 0
                display "Erro: Nao conseguiu criar tabela " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql disconnect all end-exec
                stop run
           end-if
           display "Create   OK = CONEXAO2" at 1001.

       mudandoconexao.
           EXEC SQL
                   SET CONNECTION conexao1
           END-EXEC

           EXEC SQL CREATE TABLE TESTE2
              (caracteres    CHAR(10))
           END-EXEC

           if sqlcode not = 0
                display "Erro: Nao conseguiu criar tabela " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql disconnect all end-exec
                stop run
           end-if
           display "Create   OK = CONEXAO1" at 1201.

       desconectando.
           EXEC SQL
                DISCONNECT conexao1
           END-EXEC
           display "DisconnectOK= CONEXAO1" at 1401

           EXEC SQL
                DISCONNECT conexao2
           END-EXEC
           display "DisconnectOK= CONEXAO2" at 1601

           accept espera at 2301.

       end program Simultaneos03.