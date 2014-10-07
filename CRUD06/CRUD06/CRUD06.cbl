      $SET SQL()

       identification division.
       program-id.    clientes.
       environment    division.
       configuration  section.
       special-names. decimal-point is comma.
       input-output   section.
       file-control.
           select clientes assign to disk organization is indexed
             access mode is dynamic file status fs-estado
             record key is codigo-clientes.
       data division.
       fd clientes
           label record is standard
           value of file-id
                "C:\CursoCobol\BaseNativaCobol\CLIENTES.ARQ".
       01 registro-clientes.
         02 codigo-clientes         pic x(10).
         02 nome-clientes           pic x(50).
         02 endereco-clientes       pic x(50).
         02 bairro-clientes         pic x(50).
         02 pais-clientes           pic x(50).
         02 cidade-clientes         pic x(50).
         02 estado-clientes         pic x(02).
         02 patrimonio-clientes     pic 9(09)v99.
         02 datacadastro-clientes   pic 9(08).
         02 situacao-clientes       pic x(10).
       working-storage section.
       77 fs-estado                 pic x(02).
       01 registro                  pic 9(10).

       01 data-clientes             pic 9(08).
       01 filler redefines data-clientes.
          03 dia-clientes           pic 9(02).
          03 mes-clientes           pic 9(02).
          03 ano-clientes           pic 9(04).
       01 valor                     pic zzz.zzz.zz9,99.

      * Aqui vamos descrever definições de SQLCODE
      *      padrão para conexões com bancos de dados para Microfocus
       EXEC SQL INCLUDE SQLCA END-EXEC.
      * Variáveis que serão utilizadas:
       01 ws-database  pic x(15).
       01 ws-user      pic x(15).
       01 ws-senha     pic x(15).
       01 opcao        pic 9(02) value zeros.
       01 opcao-sn     pic x(01) value spaces.
       01 espera       pic x(01) value spaces.
       01 comando-sql  pic x(99) value spaces.

       01 data-teste.
          03 ano-teste pic 9(04).
          03 mes-teste pic 9(02).
          03 dia-teste pic 9(02).

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 sqlregistro-clientes.
         02 sqlcodigo-clientes         pic x(10).
         02 sqlnome-clientes           pic x(50).
         02 sqlendereco-clientes       pic x(50).
         02 sqlbairro-clientes         pic x(50).
         02 sqlpais-clientes           pic x(50).
         02 sqlcidade-clientes         pic x(50).
         02 sqlestado-clientes         pic x(02).
         02 sqlpatrimonio-clientes     pic 9(09)v99.
         02 sqldatacadastro-clientes   pic x(10).
         02 filler redefines sqldatacadastro-clientes.
            03 sqlano                  pic 9(04).
            03 filler                  pic x(01).
            03 sqlmes                  pic 9(02).
            03 filler                  pic x(01).
            03 sqldia                  pic 9(02).
         02 sqlsituacao-clientes       pic x(10).

       01 sqlcountry.
         02 codex                      pic x(30).
         02 namex                      pic x(30).
         02 continent                  pic x(30).
         02 region                     pic x(30).
         02 surfacearea                pic x(30).
         02 indepyear                  pic x(30).
         02 population                 pic x(30).
         02 lifeexpectancy             pic x(30).

       EXEC SQL END DECLARE SECTION END-EXEC.

       procedure division.
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
           end-if.
       menugeral.
           initialize espera opcao
           display erase at 0101
           display "01-Insert da base Cobol para o DB" at 0201
           display "02-Select da tabela CLIENTES" at 0301
           display "03-Select da tabela COUNTRY" at 0401
           display "04-Update do DB" at 0501
           display "05-Delete do DB" at 0601

           display "11-Insert por accept para o DB" at 0801
           display "12-Selecionar e alterar um registro no DB" at 0901
           display "13-Selecionar e excluir um registro no DB" at 1001

           display "20-Verificar e Atualizar Dados" at 1301
           display "       COBOL -> DB" at 1401

           display "21-Verificar e Incluir" at 1501
           display "       DB    -> COBOL" at 1601

           display "00-Sair" at 1801
           display "Opcao:" at 1901
           accept opcao at 1907
           if opcao = 01 go insert-db.
           if opcao = 02 go select-clientes.
           if opcao = 03 go select-country.
           if opcao = 04 go update-db.
           if opcao = 05 go delete-db.

           if opcao = 11 go insert-accept-db.
           if opcao = 12 go select-update.
           if opcao = 13 go select-delete.

           if opcao = 20 go cobol-to-db.
           if opcao = 21 go db-to-cobol.

           if opcao = 00 go desconectando.
           go menugeral.
       insert-db.
           initialize espera
           display erase at 0101
           display "Insert da base Cobol para o DB" at 0101.
       abrindo.
           initialize registro registro-clientes
           open input clientes
           if fs-estado not = "00"
                   display "Erro ao abrir :" at 2101 fs-estado
                   close clientes
                   accept espera at 2201
                   exit program
                   stop run
           end-if
           start clientes key is >= codigo-clientes invalid key
                   go fechando
           end-start.
       lendo.
           read clientes next at end
                   go fechando
           end-read

           add 1 to registro

           display "No.Registro Lido : " at 0801 registro
           display "Dados do Registro: " at 0901
           display registro-clientes     at 1001.
       movendo.
           move codigo-clientes         to sqlcodigo-clientes
           move nome-clientes           to sqlnome-clientes
           move endereco-clientes       to sqlendereco-clientes
           move bairro-clientes         to sqlbairro-clientes
           move pais-clientes           to sqlpais-clientes
           move cidade-clientes         to sqlcidade-clientes
           move estado-clientes         to sqlestado-clientes
           move patrimonio-clientes     to sqlpatrimonio-clientes
           move datacadastro-clientes   to sqldatacadastro-clientes
           move situacao-clientes       to sqlsituacao-clientes.
       inserindo.
           EXEC SQL
               INSERT INTO clientes
                           (codigo,
                            nome,
                            endereco,
                            bairro,
                            pais,
                            cidade,
                            estado,
                            patrimonio,
                            datacadastro,
                            situacao)
               VALUES
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlpatrimonio-clientes,
                            :sqldatacadastro-clientes,
                            :sqlsituacao-clientes)
           END-EXEC.
       testando.
           if sqlcode not = 0
      *            SQLCODE = -1062 duplicate key
              if sqlcode = -1062
                 close clientes
                 EXEC SQL
                      DELETE FROM CLIENTES
                 END-EXEC
                 if sqlcode not = 0
                    display "Erro: Nao conseguiu DELETE " at 1510
                    display sqlcode at 1610
                    display sqlerrmc at 1710
                    accept espera at 2301
                    exit program
                    stop run
                 end-if
                 go abrindo
              else
                display "Erro: Nao conseguiu INSERT registro:" at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                display erase at 1510
              end-if
           end-if.
       voltando.
           go lendo.
       fechando.
           close clientes.
       comitando.
           EXEC SQL
                COMMIT
           END-EXEC
           display "Commit    OK= CONEXAO" at 2201
           if sqlcode not = 0
                display "Erro: Nao conseguiu COMMIT " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           accept espera at 2401.
       fim-insert-db.
           go menugeral.
       desconectando.
           EXEC SQL
                DISCONNECT all
           END-EXEC
           display "DisconnectOK= CONEXAO" at 2301
           accept espera at 2401
           exit program
           stop run.
       insert-accept-db.
           initialize espera
           display erase at 0101
           display "Insert por accept apra o DB" at 0101.
       monta-tela.
           display "Codigo Cliente............: " at 0201
           display "Nome Cliente..............: " at 0301
           display "Endereco Cliente..........: " at 0401
           display "Bairro Cliente............: " at 0501
           display "Pais Cliente..............: " at 0601
           display "Cidade Cliente............: " at 0701
           display "Estado Cliente............: " at 0801
           display "Patrimonio Cliente........: " at 0901
           display "Data Cadastro Cliente.....: " at 1001
           display "Situacao Cliente..........: " at 1101.
       limpa-dados.
           move spaces to sqlcodigo-clientes   sqlnome-clientes
                          sqlendereco-clientes sqlbairro-clientes
                          sqlpais-clientes     sqlcidade-clientes
                          sqlestado-clientes   sqldatacadastro-clientes
                          sqlsituacao-clientes

           move zeros                   to sqlpatrimonio-clientes.
       accept-todos.
           accept sqlcodigo-clientes at 0229 with update
           accept sqlnome-clientes at 0329 with update
           accept sqlendereco-clientes at 0429 with update
           accept sqlbairro-clientes at 0529 with update
           accept sqlpais-clientes at 0629 with update
           accept sqlcidade-clientes at 0729 with update
           accept sqlestado-clientes at 0829 with update
           accept valor at 0929 with update
           move valor to sqlpatrimonio-clientes
           accept data-clientes at 1029 with update
           string ano-clientes delimited size
                           "/" delimited size
                  mes-clientes delimited size
                           "/" delimited size
                  dia-clientes delimited size
                          into sqldatacadastro-clientes
           accept sqlsituacao-clientes at 1129 with update

           perform inserindo
           if sqlcode not = 0
                display "Erro: Nao conseguiu insert " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go insert-accept-db
           end-if
           perform comitando
           go menugeral.
       select-clientes.
           initialize espera registro
           display erase at 0101
           display "Select da tabela CLIENTES" at 0101.
       declarando-clientes.
           EXEC SQL
                DECLARE CURSORCLIENTES CURSOR FOR
                   SELECT * FROM CLIENTES
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if.
       abrindo-clientes.
           EXEC SQL
                OPEN CURSORCLIENTES
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu OPEN " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if.
       lendocursor-clientes.
           perform until sqlcode not = zeros
              EXEC SQL
                    FETCH CURSORCLIENTES INTO
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlpatrimonio-clientes,
                            :sqldatacadastro-clientes,
                            :sqlsituacao-clientes)
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

                display "Dados do Registro: " at 0801 registro
                display "Codigo Cliente............: " at 0901
                                sqlcodigo-clientes
                display "Nome Cliente..............: " at 1001
                                sqlnome-clientes
                display "Endereco Cliente..........: " at 1101
                                sqlendereco-clientes
                display "Bairro Cliente............: " at 1201
                                sqlbairro-clientes
                display "Pais Cliente..............: " at 1301
                                sqlpais-clientes
                display "Cidade Cliente............: " at 1401
                                sqlcidade-clientes
                display "Estado Cliente............: " at 1501
                                sqlestado-clientes
                display "Patrimonio Cliente........: " at 1601
                                sqlpatrimonio-clientes
                display "Data Cadastro Cliente.....: " at 1701
                                sqldatacadastro-clientes
                display "Situacao Cliente..........: " at 1801
                                sqlsituacao-clientes

                accept espera at 2301
               end-if

           end-perform.
       fechando-clientes.
           EXEC SQL
                CLOSE CURSORCLIENTES
           END-EXEC
           go menugeral.
       select-country.
           initialize espera registro
           display erase at 0101
           display "Select da tabela COUNTRY" at 0101.
       declarando-country.
           EXEC SQL
                DECLARE CURSORCOUNTRY CURSOR FOR
                   SELECT code,name,continent,region,surfacearea,
                          indepyear,population,lifeexpectancy
                   FROM COUNTRY
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if.
       abrindo-country.
           EXEC SQL
                OPEN CURSORCOUNTRY
           END-EXEC.
       lendocursor-country.
           perform until sqlcode not = zeros and sqlcode not = 1
               EXEC SQL
                    FETCH CURSORCOUNTRY INTO
                           (:codex,
                            :namex,
                            :continent,
                            :region,
                            :surfacearea,
                            :indepyear,
                            :population,
                            :lifeexpectancy)
               END-EXEC

               add 1 to registro

               display "Dados do Registro: " at 0801 registro
               display "Codex.....................: " at 0901
                               codex
               display "Namex.....................: " at 1001
                               namex
               display "Continent.................: " at 1101
                               continent
               display "Region....................: " at 1201
                               region
               display "Surfacearea...............: " at 1301
                               surfacearea
               display "Indepyear.................: " at 1401
                               indepyear
               display "Population................: " at 1501
                               population
               display "Lifeexpectancy............: " at 1601
                               lifeexpectancy

               accept espera at 2301
               if registro = 10
                  move 9999 to sqlcode
               end-if

           end-perform.
       fechando-country.
           EXEC SQL
                CLOSE CURSORCOUNTRY
           END-EXEC
           go menugeral.
       update-db.
           initialize espera
           display erase at 0101
           display "Update do DB" at 0101.
       alterando.
           EXEC SQL
                UPDATE CLIENTES
                   SET SITUACAO = 'OK'
                 WHERE ESTADO = 'PR'
           END-EXEC
           display "Linhas Afetadas: " at 0840 sqlerrd(3)
           if sqlcode not = 0
                display "Erro: Nao conseguiu Update " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           display "Update OK." at 0801
           accept espera at 2401.
       commitar.
           display "Commitar? S ou N" at 1201
           initialize opcao-sn
           accept opcao-sn at 1220
           if opcao-sn = "S" or "s"
              perform comitando
              go menugeral
           else
           if opcao-sn = "N" or "n"
              perform commitarnao
              go menugeral
           else
              go commitar.
       commitarnao.
           EXEC SQL
                ROLLBACK
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu Rollback " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           display "Rollback OK" at 2301
           accept espera at 2401.
       delete-db.
           initialize espera
           display erase at 0101
           display "Delete do DB" at 0101.
       deletando.
           EXEC SQL
                DELETE FROM CLIENTES
                 WHERE CODIGO = '3'
           END-EXEC
           display "Linhas Afetadas: " at 1040 sqlerrd(3)
           if sqlcode not = 0
                display "Erro: Nao conseguiu Delete " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           display "Delete OK" at 1001
           accept espera at 2401
           go commitar.
       select-update.
           initialize espera
           display erase at 0101
           display "Selecionar e alterar um registro no DB" at 0101

           perform monta-tela
           perform limpa-dados

           accept sqlcodigo-clientes at 0229 with update
           if sqlcodigo-clientes = spaces
                 go menugeral
           end-if.
       select-update-procurando.
           EXEC SQL
                DECLARE CURSORDADOS CURSOR FOR
                   SELECT * FROM CLIENTES WHERE CODIGO =
                                   :sqlcodigo-clientes
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go select-update
           end-if

           EXEC SQL
                OPEN CURSORDADOS
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu OPEN " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go select-update
           end-if

           EXEC SQL
                    FETCH CURSORDADOS INTO
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlpatrimonio-clientes,
                            :sqldatacadastro-clientes,
                            :sqlsituacao-clientes)
           END-EXEC
           if sqlcode = 100
                  display "Nao encontrou o registro " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  perform fechacursordados
                  go select-update
           end-if

           if sqlcode not = 0
                  display "Erro: Nao conseguiu Fetch " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  perform fechacursordados
                  go select-update
           end-if

           accept sqlnome-clientes at 0329 with update
           accept sqlendereco-clientes at 0429 with update
           accept sqlbairro-clientes at 0529 with update
           accept sqlpais-clientes at 0629 with update
           accept sqlcidade-clientes at 0729 with update
           accept sqlestado-clientes at 0829 with update
           accept sqlpatrimonio-clientes at 0929 with update
           accept sqldatacadastro-clientes at 1029 with update
           accept sqlsituacao-clientes at 1129 with update.
       fechacursordados.
           EXEC SQL
                CLOSE CURSORDADOS
           END-EXEC.
       select-update-confirmar.
           display "Atualizar os dados? S ou N" at 1201
           initialize opcao-sn
           accept opcao-sn at 1270
           if opcao-sn = "S" or "s"
              go select-update-atualizar
           else
           if opcao-sn = "N" or "n"
              go select-update
           else
              go select-update-confirmar.
       select-update-atualizar.
           EXEC SQL
                UPDATE CLIENTES
                       SET
                         nome = :sqlnome-clientes,
                         endereco = :sqlendereco-clientes,
                         bairro = :sqlbairro-clientes,
                         pais = :sqlpais-clientes,
                         cidade = :sqlcidade-clientes,
                         estado = :sqlestado-clientes,
                         patrimonio = :sqlpatrimonio-clientes,
                         datacadastro = :sqldatacadastro-clientes,
                         situacao = :sqlsituacao-clientes
                       WHERE CODIGO = :sqlcodigo-clientes
                       LIMIT 1
           END-EXEC
           if sqlcode not = 0 and sqlcode not = 100
                display "Erro: Nao conseguiu UPDATE  " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                perform commitarnao
                go select-update
           end-if
           perform comitando
           go select-update.
       select-delete.
           initialize espera
           display erase at 0101
           display "Selecionar e excluir um registro no DB" at 0101

           perform monta-tela
           perform limpa-dados

           accept sqlcodigo-clientes at 0229 with update
           if sqlcodigo-clientes = spaces
                 go menugeral
           end-if.
       select-delete-procurando.
           EXEC SQL
                DECLARE CURSORDADOS1 CURSOR FOR
                   SELECT * FROM CLIENTES WHERE CODIGO =
                                   :sqlcodigo-clientes
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go select-delete
           end-if

           EXEC SQL
                OPEN CURSORDADOS1
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu OPEN " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                perform fechacursordados1
                go select-delete
           end-if

           EXEC SQL
                    FETCH CURSORDADOS1 INTO
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlpatrimonio-clientes,
                            :sqldatacadastro-clientes,
                            :sqlsituacao-clientes)
           END-EXEC
           if sqlcode = 100
                  display "Nao encontrou o registro " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  perform fechacursordados1
                  go select-delete
           end-if

          if sqlcode not = 0
                  display "Erro: Nao conseguiu Fetch " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  perform fechacursordados1
                  go select-delete
           end-if

           display sqlnome-clientes at 0329
           display sqlendereco-clientes at 0429
           display sqlbairro-clientes at 0529
           display sqlpais-clientes at 0629
           display sqlcidade-clientes at 0729
           display sqlestado-clientes at 0829
           display sqlpatrimonio-clientes at 0929
           display sqldatacadastro-clientes at 1029
           display sqlsituacao-clientes at 1129.
       fechacursordados1.
           EXEC SQL
                CLOSE CURSORDADOS1
           END-EXEC.
       select-delete-confirmar.
           display "Excluir os dados? S ou N" at 1201
           initialize opcao-sn
           accept opcao-sn at 1270
           if opcao-sn = "S" or "s"
              go select-delete-atualizar
           else
           if opcao-sn = "N" or "n"
              go select-delete
           else
              go select-delete-confirmar.
       select-delete-atualizar.
           EXEC SQL
                DELETE FROM CLIENTES
                       WHERE CODIGO = :sqlcodigo-clientes
                       LIMIT 1
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DELETE  " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go select-delete
           end-if
           perform comitando
           go select-delete.
       cobol-to-db.
           initialize espera
           display erase at 0101
           display "Verificar e Atualizar Dados" at 0101

           initialize registro
           initialize registro-clientes
           open input clientes
           if fs-estado not = "00"
                   display "Erro ao abrir :" at 2101 fs-estado
                   close clientes
                   accept espera at 2201
                   exit program
                   stop run
           end-if
           start clientes key is >= codigo-clientes invalid key
                   go cobol-to-db-fechando
           end-start.
       cobol-to-db-lendo.
           read clientes next at end
                   go cobol-to-db-fechando
           end-read

           add 1 to registro

           display "No.Registro Lido : " at 0801 registro
           display "Codigo           : " at 0901 codigo-clientes

           move codigo-clientes to sqlcodigo-clientes

           EXEC SQL
                DECLARE CURSORDADOS2 CURSOR FOR
                   SELECT * FROM CLIENTES WHERE CODIGO =
                                   :sqlcodigo-clientes
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go cobol-to-db-inserindo
           end-if

           EXEC SQL
                OPEN CURSORDADOS2
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu OPEN " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go cobol-to-db-inserindo
           end-if

           EXEC SQL
                    FETCH CURSORDADOS2 INTO
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlpatrimonio-clientes,
                            :sqldatacadastro-clientes,
                            :sqlsituacao-clientes)
           END-EXEC
           if sqlcode = 100
                perform fechacursordados2
                go cobol-to-db-inserindo
           end-if
           if sqlcode not = 0
                  display "Erro: Nao conseguiu Fetch " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  perform fechacursordados2
                  go cobol-to-db-inserindo
           end-if.
       fechacursordados2.
           EXEC SQL
                CLOSE CURSORDADOS2
           END-EXEC.
       cobol-to-db-testando.
           move sqlano to ano-teste
           move sqlmes to mes-teste
           move sqldia to dia-teste

           if nome-clientes not = sqlnome-clientes or
              endereco-clientes not = sqlendereco-clientes or
              bairro-clientes not = sqlbairro-clientes or
              pais-clientes not = sqlpais-clientes or
              cidade-clientes not = sqlcidade-clientes or
              estado-clientes not = sqlestado-clientes or
              patrimonio-clientes not = sqlpatrimonio-clientes or
              situacao-clientes not = sqlsituacao-clientes or
              datacadastro-clientes not = data-teste
                   go cobol-to-db-update
           end-if.
       continuando.
           go cobol-to-db-lendo.
       cobol-to-db-fechando.
           close clientes
           go menugeral.
       cobol-to-db-inserindo.
           perform movendo
           perform inserindo
           if sqlcode not = 0
                display "Erro: Nao conseguiu INSERT registro:" at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                display erase at 1510
                EXEC SQL
                     ROLLBACK
                END-EXEC
                go cobol-to-db-lendo
           end-if
           EXEC SQL
                COMMIT
           END-EXEC
           go cobol-to-db-lendo.
       cobol-to-db-update.
           perform movendo
           EXEC SQL
                UPDATE CLIENTES
                       SET
                         nome = :sqlnome-clientes,
                         endereco = :sqlendereco-clientes,
                         bairro = :sqlbairro-clientes,
                         pais = :sqlpais-clientes,
                         cidade = :sqlcidade-clientes,
                         estado = :sqlestado-clientes,
                         patrimonio = :sqlpatrimonio-clientes,
                         datacadastro = :sqldatacadastro-clientes,
                         situacao = :sqlsituacao-clientes
                       WHERE CODIGO = :sqlcodigo-clientes
                       LIMIT 1
           END-EXEC
           if sqlcode not = 0 and sqlcode not = 100
                display "Erro: Nao conseguiu UPDATE  " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                EXEC SQL
                     ROLLBACK
                END-EXEC
                go cobol-to-db-lendo
           end-if
           EXEC SQL
                COMMIT
           END-EXEC
           go cobol-to-db-lendo.
       db-to-cobol.
           initialize espera registro
           display erase at 0101
           display "Verificar e Incluir" at 0101.
       db-to-cobol-declaracao.
           initialize registro registro-clientes
           open i-o clientes
           if fs-estado not = "00"
                   display "Erro ao abrir :" at 2101 fs-estado
                   close clientes
                   accept espera at 2201
                   exit program
                   stop run
           end-if

           EXEC SQL
                DECLARE CURSORCLIENTES1 CURSOR FOR
                   SELECT * FROM CLIENTES
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go db-to-cobol-fim
           end-if

           EXEC SQL
                OPEN CURSORCLIENTES1
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu DECLARE " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                go db-to-cobol-fim
           end-if

           perform until sqlcode not = zeros
              EXEC SQL
                    FETCH CURSORCLIENTES1 INTO
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlpatrimonio-clientes,
                            :sqldatacadastro-clientes,
                            :sqlsituacao-clientes)
              END-EXEC
              if sqlcode not = 0 and sqlcode not = 100
                  display "Erro: Nao conseguiu Fetch " at 1510
                  display sqlcode at 1610
                  display sqlerrmc at 1710
                  accept espera at 2301
                  go db-to-cobol-fim
              end-if

              if sqlcode not = 100
                initialize registro-clientes
                move sqlcodigo-clientes to codigo-clientes
                read clientes invalid key
                     perform write-clientes
                end-read
              end-if

           end-perform.

       db-to-cobol-fim.
           EXEC SQL
                CLOSE CURSORCLIENTES1
           END-EXEC

           close clientes
           go menugeral.
       write-clientes.
           move sqlcodigo-clientes         to codigo-clientes
           move sqlnome-clientes           to nome-clientes
           move sqlendereco-clientes       to endereco-clientes
           move sqlbairro-clientes         to bairro-clientes
           move sqlpais-clientes           to pais-clientes
           move sqlcidade-clientes         to cidade-clientes
           move sqlestado-clientes         to estado-clientes
           move sqlpatrimonio-clientes     to patrimonio-clientes

           move sqlano to ano-teste
           move sqlmes to mes-teste
           move sqldia to dia-teste

           move data-teste                 to datacadastro-clientes
           move sqlsituacao-clientes       to situacao-clientes

           write registro-clientes invalid key
               display "Erro ao salvar clientes = " at 2301 fs-estado
               accept espera at 2370
           end-write.

       end program clientes.