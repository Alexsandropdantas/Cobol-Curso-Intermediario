      $SET SQL()
       identification division.
       program-id. View.
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

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 wfiltro      pic x(03).

       01 wcodigo      pic x(03).
       01 wnome        pic x(52).
       01 wpopulacao   pic 9(11).
       01 wlinguagem   pic x(30).
       EXEC SQL END DECLARE SECTION END-EXEC.

       procedure division.
       inicio.
           initialize espera registro
           display erase at 0101
           display "Criando Views" at 0401.
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
       opcoes.
           display erase at 0701
           display "0.Sair                  " at 0701
           display "1.Criar View Linguagens " at 0801
           display "2.Ver View com Filtro   " at 0901
           display "Opcao:" at 1001
           accept opcao at 1007
           if opcao = 0 go desconectar.
           if opcao = 1 go criarview.
           if opcao = 2 go verview.
           go opcoes.
       criarview.
           EXEC SQL
                CREATE VIEW LINGUAGENS
                   AS
                     SELECT a.code,a.name,a.population,b.language
                     FROM country a, countrylanguage b
                     where a.code = b.countrycode
                       and b.isofficial = 'T';
           END-EXEC
           if sqlcode not = 0
      *           Código -1050 tabela já existe num Create View
              if sqlcode = -1050
                EXEC SQL
                     DROP VIEW linguagens
                END-EXEC
                if sqlcode not = 0
                 display "Erro: Nao conseguiu drop view " at 1510
                 display sqlcode at 1610
                 display sqlerrmc at 1710
                 accept espera at 2301
                 exec sql DISCONNECT ALL end-exec
                 stop run
                else
                 go criarview
                end-if
              else
                display "Erro: Nao conseguiu criar view " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql DISCONNECT ALL end-exec
                stop run
              end-if
           end-if
           display "Criou View OK." at 2201
           accept espera at 2301
           go opcoes.
       verview.
           initialize registro wfiltro
           display "Pais a mostrar: " at 1301
           accept wfiltro at 1317

           EXEC SQL
                DECLARE CURSORVIEW CURSOR FOR
                   SELECT * FROM LINGUAGENS WHERE CODE = :wfiltro
           END-EXEC

           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if

           EXEC SQL
                OPEN CURSORVIEW
           END-EXEC

           perform until sqlcode not = zeros
               EXEC SQL
                    FETCH CURSORVIEW INTO
                           (:wcodigo,
                            :wnome,
                            :wpopulacao,
                            :wlinguagem)
               END-EXEC
               if sqlcode not = 0 and sqlcode not = 100
                  display "Erro: Nao conseguiu Fetch " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  exit program
                  stop run
               end-if

               if sqlcode not = 100
                add 1 to registro

                display erase at 1501

                display "Dados do Registro: " at 1501 registro
                display "Codigo Pais...............: " at 1601
                                wcodigo
                display "Nome Pais.................: " at 1701
                                wnome
                display "Populacao.................: " at 1801
                                wpopulacao
                display "Linguagem.................: " at 1901
                                wlinguagem

                accept espera at 2301
               end-if

           end-perform

           EXEC SQL
                CLOSE CURSORVIEW
           END-EXEC

           go opcoes.

       desconectar.
           EXEC SQL
                DISCONNECT all
           END-EXEC
           display "DisconnectOK= CONEXAO" at 2201
           accept espera at 2301
           exit program
           stop run.

       end program View.