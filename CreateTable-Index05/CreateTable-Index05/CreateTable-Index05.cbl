      $SET SQL()
       identification division.
       program-id. CreateTable-Index05.


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
       
       menugeral.
           initialize opcao espera
           display erase at 0101
           display "Criando Tabelas e Indices" at 0101
           display "1-Criar Tabela" at 0201
           display "2-Criar Indice" at 0301
           display "3-Alterar Tabela" at 0401
           display "Opcao:" at 0501
           accept opcao at 0507
           if opcao = 1 go criartabela.
           if opcao = 2 go criarindice.
           if opcao = 3 go alterartabela.
           if opcao = 0
              exit program
              stop run.
           go menugeral.
           
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
           display "Conectou OK = CONEXAO" at 1001.
           
       criartabela.
           initialize opcao espera
           display erase at 0101
           display "Criando Tabela" at 0401

           perform conectando.
           
       createtable.
           EXEC SQL
                CREATE TABLE CLIENTES
                    (codigo       char(10),
                     nome         char(50) not null unique,
                     endereco     char(50),
                     bairro       char(50),
                     pais         char(50) default "BRASIL",
                     cidade       char(50),
                     estado       char(02),
                     patrimonio   decimal(11,2),
                     datacadastro date,
                     situacao     char(10),
                     primary key  (codigo))
           END-EXEC

           if sqlcode not = 0
      *           Codigo -1050 tabela ja existe num Create Table
              if sqlcode = -1050
                EXEC SQL
                     DROP TABLE CLIENTES
                END-EXEC
                if sqlcode not = 0
                 display "Erro: Nao conseguiu drop tabela " at 1510
                 display sqlcode at 1610
                 display sqlerrmc at 1710
                 accept espera at 2301
                 exec sql DISCONNECT ALL end-exec
                 exit program
                 stop run
                else
                 go createtable
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
           display "Criou Tab1 OK." at 1101.
       2o-createtable.
           EXEC SQL
                   CREATE TABLE TesteTabela1
                         SELECT * FROM city WHERE population < 50000
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu criar 2 " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           display "Criat Tab2 OK." at 1201.
           
       3o-createtable.
           EXEC SQL
                   CREATE TABLE TesteTabela2 Like TesteTabela1
           END-EXEC
           if sqlcode not = 0
                display "Erro: Nao conseguiu criar 3 " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exit program
                stop run
           end-if
           display "Criat Tab3 OK." at 1301
           perform desconectando
           go menugeral.
           
       desconectando.
           EXEC SQL
                DISCONNECT all
           END-EXEC
           display "DisconnectOK= CONEXAO" at 2001
           accept espera at 2101.
           
       criarindice.
           initialize opcao espera
           display erase at 0101
           display "Criando Indice" at 0401

           perform conectando.
           
       createindex.
           EXEC SQL
                CREATE INDEX CLIENTES_INDEX1
                       ON CLIENTES
                       (situacao ASC)
           END-EXEC
           if sqlcode not = 0
      *           Codigo -1061 index ja existe
              if sqlcode = -1061
                EXEC SQL
                     DROP INDEX CLIENTES_INDEX1 ON CLIENTES
                END-EXEC
                if sqlcode not = 0
                 display "Erro: Nao conseguiu drop index " at 1510
                 display sqlcode at 1610
                 display sqlerrmc at 1710
                 accept espera at 2301
                 exec sql DISCONNECT ALL end-exec
                 exit program
                 stop run
                else
                 go criarindice
                end-if
              else
                display "Erro: Nao conseguiu criar index " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql DISCONNECT ALL end-exec
                exit program
                stop run
              end-if
           end-if
           display "Criou Index OK" at 1101.
           
       createindex2.
           EXEC SQL
                CREATE INDEX CLIENTES_INDEX2
                       ON CLIENTES
                       (cidade ASC)
           END-EXEC
           if sqlcode not = 0
      *           Codigo -1061 index ja existe
              if sqlcode = -1061
                EXEC SQL
                     DROP INDEX CLIENTES_INDEX2 ON CLIENTES
                END-EXEC
                if sqlcode not = 0
                 display "Erro: Nao conseguiu drop index " at 1510
                 display sqlcode at 1610
                 display sqlerrmc at 1710
                 accept espera at 2301
                 exec sql DISCONNECT ALL end-exec
                 exit program
                 stop run
                else
                 go createindex2
                end-if
              else
                display "Erro: Nao conseguiu criar index " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql DISCONNECT ALL end-exec
                exit program
                stop run
              end-if
           end-if
           display "Criou Index2 OK" at 1201
           perform desconectando
           go menugeral.
           
       alterartabela.
           initialize opcao espera
           display erase at 0101
           display "Alterar Tabela" at 0401

           perform conectando.
           
       altertable.
           EXEC SQL
                ALTER TABLE CLIENTES
                     change endereco endereco char(80);
           END-EXEC

           if sqlcode not = 0
                display "Erro: Nao conseguiu alterar tabela " at 1510
                display sqlcode at 1610
                display sqlerrmc at 1710
                accept espera at 2301
                exec sql DISCONNECT ALL end-exec
                exit program
                stop run
           end-if
           display "Alter Tab OK" at 1101.
           perform desconectando
           go menugeral.

       end program CreateTable-Index05.