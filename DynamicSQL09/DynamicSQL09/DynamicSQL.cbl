      $SET SQL(dbman=ODBC)
       identification division.
       program-id. DynamicSQL.
       environment    division.
       configuration  section.
       special-names. decimal-point is comma.
       input-output   section.
       file-control.
       data division.
       working-storage section.
       EXEC SQL INCLUDE SQLCA END-EXEC.
       01 ws-database  pic x(15).
       01 ws-user      pic x(15).
       01 ws-senha     pic x(15).
       01 opcao        pic 9(01) value zeros.
       01 espera       pic x(01) value spaces.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC
       01 comando-sql             pic x(255) value spaces.

       01 sqlregistro-clientes.
         02 sqlcodigo-clientes         pic x(10).
         02 sqlnome-clientes           pic x(50).
         02 sqlendereco-clientes       pic x(50).
         02 sqlbairro-clientes         pic x(50).
         02 sqlpais-clientes           pic x(50).
         02 sqlcidade-clientes         pic x(50).
         02 sqlestado-clientes         pic x(02).
         02 sqlpatrimonio-clientes     pic 9(09)v99.
         02 sqldatacadastro-clientes   pic x(08).
         02 sqlsituacao-clientes       pic x(10).

       EXEC SQL END DECLARE SECTION END-EXEC

       procedure division.
       inicio.
           initialize espera
           display erase at 0101
           display "Dynamic SQL - Clientes" at 0401.
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
           display "Conectou OK = CONEXAO" at 0501.
       criandodados.
           move "DYNAMIC"               to sqlcodigo-clientes
           move "NOME DYNAMIC"          to sqlnome-clientes
           move "ENDERECO"              to sqlendereco-clientes
           move "BAIRRO"                to sqlbairro-clientes
           move "BRASIL"                to sqlpais-clientes
           move "SAO PAULO"             to sqlcidade-clientes
           move "SP"                    to sqlestado-clientes
           move "1"                     to sqlpatrimonio-clientes
           move "20110101"              to sqldatacadastro-clientes
           move "LEGAL"                 to sqlsituacao-clientes.
       executando.
           move "INSERT INTO CLIENTES VALUES (?,?,?,?,?,?,?,?,?,?)"
                                     to comando-sql

           EXEC SQL
                PREPARE DYNAMIC_SQL FROM :comando-sql
           END-EXEC
           display "PREPARE ............." at 0701
           if sqlcode not = 0
                display "Erro: Nao conseguiu PREPARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if

           EXEC SQL
                EXECUTE DYNAMIC_SQL USING :sqlcodigo-clientes,
                                          :sqlnome-clientes,
                                          :sqlendereco-clientes,
                                          :sqlbairro-clientes,
                                          :sqlpais-clientes,
                                          :sqlcidade-clientes,
                                          :sqlestado-clientes,
                                          :sqlpatrimonio-clientes,
                                          :sqldatacadastro-clientes,
                                          :sqlsituacao-clientes
           END-EXEC
           display "EXECUTE ............." at 0901
           if sqlcode not = 0
                display "Erro: Nao conseguiu EXECUTE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if.

       desconectando.
           EXEC SQL
                COMMIT
           END-EXEC
           display "Commit    OK= CONEXAO" at 1101
           if sqlcode not = 0
                display "Erro: Nao conseguiu COMMIT " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if

           EXEC SQL
                DISCONNECT all
           END-EXEC
           display "DisconnectOK= CONEXAO" at 1301
           accept espera at 2401
           exit program
           stop run.
       end program DynamicSQL.