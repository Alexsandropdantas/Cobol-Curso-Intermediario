      $SET SQL()
       identification division.
       program-id. Triggers.
       environment    division.
       configuration  section.
       special-names. decimal-point is comma.
       input-output   section.
       file-control.
       data division.
       working-storage section.
       01 registro                  pic 9(10).

      * Aqui vamos descrever definições de SQLCODE
      *      padrão para conexões com bancos de dados para Microfocus
       EXEC SQL INCLUDE SQLCA END-EXEC.
      * Variáveis que serão utilizadas:
       01 ws-database  pic x(15).
       01 ws-user      pic x(15).
       01 ws-senha     pic x(15).
       01 opcao        pic 9(01) value zeros.
       01 espera       pic x(01) value spaces.
       01 comando-sql  pic x(99) value spaces.

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
         02 sqlsituacao-clientes       pic x(10).

       01 sqllog.
         02 sqlcodigo-log              pic x(10).
         02 sqldata-log                pic x(10).
         02 sqlhora-log                pic x(08).
       EXEC SQL END DECLARE SECTION END-EXEC.

       procedure division.
       inicio.
           initialize espera registro
           display erase at 0101
           display "Triggers - Clientes" at 0401.
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
           display "0.Sair                               " at 0701
           display "1.Criar Tabela para Resultado Trigger" at 0801
           display "2.Criar Trigger                      " at 0901
           display "3.Inserir algo na tabela original    " at 1001
           display "4.Ver Tabela de Resultado Trigger    " at 1101
           display "Opcao:" at 1201
           accept opcao at 1207
           if opcao = 0 go desconectar.
           if opcao = 1 go criartabela.
           if opcao = 2 go criartrigger.
           if opcao = 3 go insertdados.
           if opcao = 4 go verlog.
           go opcoes.
       criartabela.
           EXEC SQL
                CREATE TABLE LOGCLIENTES
                    (codigo       char(10),
                     datacriacao  date,
                     horacriacao  time)
           END-EXEC
           if sqlcode not = 0
      *           Código -1050 tabela já existe num Create Table
              if sqlcode = -1050
                EXEC SQL
                     DROP TABLE LOGCLIENTES
                END-EXEC
                if sqlcode not = 0
                 display "Erro: Nao conseguiu drop tabela " at 1510
                 display sqlcode at 1610
                 display sqlerrmc at 1710
                 accept espera at 2301
                 exec sql DISCONNECT ALL end-exec
                 stop run
                else
                 go criartabela
                end-if
              else
                display "Erro: Nao conseguiu criar tabela " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql DISCONNECT ALL end-exec
                stop run
              end-if
           end-if
           display "Criou Tab OK= CONEXAO" at 2201
           accept espera at 2301
           go opcoes.
       criartrigger.
           EXEC SQL
                CREATE TRIGGER LOGCLIENTES
                  AFTER INSERT ON CLIENTES
                  FOR EACH ROW
                  BEGIN
                    INSERT INTO LOGCLIENTES
                    SET codigo=NEW.codigo,
                        datacriacao=NOW(),
                        horacriacao=NOW();
                  END;
           END-EXEC
           if sqlcode not = 0
      *            SQLCODE = -1235 trigger ja existe
              if sqlcode = -1235
                EXEC SQL
                     DROP TRIGGER LOGCLIENTES
                END-EXEC
                if sqlcode not = 0
                 display "Erro: Nao conseguiu drop trigger " at 1510
                 display sqlcode at 1610
                 display sqlerrmc at 1710
                 accept espera at 2301
                 exec sql DISCONNECT ALL end-exec
                 stop run
                else
                 go criartrigger
                end-if
              else
                display "Erro: Nao conseguiu Create Trigger " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                display erase at 1510
              end-if
           end-if

           if sqlcode not = 0
                display "Erro: Nao conseguiu Create Trigger " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if.
           display "Create TriggerOK= CONEXAO" at 2201
           accept espera at 2301
           go opcoes.
       insertdados.
           display erase at 1510
           display "Codigo do Usuario para Inserir: " at 1510
           initialize sqlregistro-clientes
           accept sqlcodigo-clientes at 1542
           if sqlcodigo-clientes = zeros
                 go opcoes
           end-if
           move sqlcodigo-clientes to sqlnome-clientes
                                      sqlendereco-clientes
                                      sqlcodigo-clientes
                                      sqlnome-clientes
                                      sqlendereco-clientes
                                      sqlbairro-clientes
                                      sqlpais-clientes
                                      sqlcidade-clientes
                                      sqlestado-clientes
           move "OK"               to sqlsituacao-clientes

           EXEC SQL
               INSERT INTO clientes
                           (codigo,
                            nome,
                            endereco,
                            bairro,
                            pais,
                            cidade,
                            estado,
                            situacao)
               VALUES
                           (:sqlcodigo-clientes,
                            :sqlnome-clientes,
                            :sqlendereco-clientes,
                            :sqlbairro-clientes,
                            :sqlpais-clientes,
                            :sqlcidade-clientes,
                            :sqlestado-clientes,
                            :sqlsituacao-clientes)
           END-EXEC
           if sqlcode not = 0
      *            SQLCODE = -1062 duplicate key
              if sqlcode = -1062
                 display "Codigo de Cliente Ja Existe. Enter." at 2201
                 accept espera at 2301
                 go insertdados
              else
                display "Erro: Nao conseguiu INSERT " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                display erase at 1510
              end-if
           end-if
           EXEC SQL
                COMMIT
           END-EXEC
           display "Insert        OK= CONEXAO" at 2201
           accept espera at 2301
           go opcoes.
       verlog.
           initialize registro
           EXEC SQL
                DECLARE CURSORLOG CURSOR FOR
                   SELECT * FROM LOGCLIENTES
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
                OPEN CURSORLOG
           END-EXEC

           perform until sqlcode not = zeros
               EXEC SQL
                    FETCH CURSORLOG INTO
                           (:sqlcodigo-log,
                            :sqldata-log,
                            :sqlhora-log)
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
                display "Codigo Cliente............: " at 1601
                                sqlcodigo-log
                display "Data Log..................: " at 1701
                                sqldata-log
                display "Hora Log..................: " at 1801
                                sqlhora-log

                accept espera at 2301
               end-if

           end-perform

           EXEC SQL
                CLOSE CURSORLOG
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

       end program Triggers.