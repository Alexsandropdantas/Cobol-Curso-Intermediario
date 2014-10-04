      $SET SQL
       identification division.
       program-id. TesteConexaoMysql02.

       environment division.
       configuration section.

       data division.

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
           display "Opcoes:" at 0201
           display "0.Sair                              " at 0401
           display "1.Conexao por ODBC direto pelo Cobol" at 0501
           display "2.Conexao Via Prompt                " at 0601
           display "3.Conexao Via DSN                   " at 0701
           display "4.Resetar Conexao                   " at 0801
           display "5.Desconectar                       " at 0901
           accept opcao at 0209 with prompt
           if opcao = 1 go direto.
           if opcao = 2 go viaprompt.
           if opcao = 3 go conectardsn.
           if opcao = 4 go resetar.
           if opcao = 5 go desconectar.
           if opcao = 0 stop run.
           go inicio.
       direto.
           display erase at 0101
           display "Testar Conexão Com Banco de Dados:" at 0201
           display "Nome ODBC: " at 0401
           display "Usuário  : " at 0501
           display "Senha    : " at 0601
           accept ws-database at 0414
           accept ws-user     at 0514
           accept ws-senha    at 0614

           EXEC SQL
               CONNECT TO :ws-database
                     USER :ws-user
                    USING :ws-senha
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go inicio
           end-if
           display ".Teste OK" at 1010

           display "Fim." at 2310

           accept espera at 2301
           go inicio.
       desconectar.
           EXEC SQL
               DISCONNECT CURRENT
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go inicio
           end-if
           display ".Desconectado OK" at 1110

           display "Fim." at 2310

           accept espera at 2301
           go inicio.
       resetar.
           EXEC SQL
               CONNECT RESET
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu resetar " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go inicio
           end-if
           display ".Reset OK" at 1110

           display "Fim." at 2310

           accept espera at 2301
           go inicio.

       viaprompt.
           display erase at 0101
           display "Testar Conexão Via Prompt" at 0201

           EXEC SQL
               CONNECT WITH PROMPT
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go inicio
           end-if
           display ".Teste OK" at 1010

           display "Fim." at 2310

           accept espera at 2301
           go inicio.
       conectardsn.
           move spaces to comando-sql
           String "DRIVER={MySQL ODBC 5.1 Driver};"
                  "SERVER=localhost;"
                  "DATABASE=World;"
                  "UID=root;"
                  "PWD=root;"
                  "PORT=3306;"
                  "OPTION=3;"
           delimited by size into comando-sql
           end-string

           EXEC SQL
                CONNECT DSN :COMANDO-sql
           END-EXEC

           if sqlcode not = 0
                display "Erro: Nao conseguiu conectar " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go inicio
           end-if
           display ".Teste OK" at 1010

           display "Fim." at 2310

           accept espera at 2301
           go inicio.
           

       end program Program1.
       
       
       
       
       
       