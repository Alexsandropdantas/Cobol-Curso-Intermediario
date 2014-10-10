      $SET MS"2"
      *SET RETRYLOCK
       identification division.
       program-id. LockMode.
       environment division.
       configuration section.
       special-names. decimal-point is comma.
       input-output section.
       file-control.
       select vendedores assign to disk
              organization is indexed
              access mode is dynamic
              file status estado-vendedores
              lock mode is automatic
              record key is chave-vendedores
              alternate record key is regiao = uf-vendedores,
                                     cidade-vendedores
              alternate record key is cidades = cidade-vendedores.
       select usuarios assign to disk
              organization is indexed
              access mode is dynamic
              file status estado-usuarios
              lock mode is manual
              record key is chave-usuarios.
       data division.
       fd vendedores
           label record is standard
           value of file-id
                "Vendedores.Arq".
       01 registro-vendedores.
           02 chave-vendedores.
              03 codigo-vendedores pic 9(3).
           02 nome-vendedores      pic x(40).
           02 uf-vendedores        pic x(02).
           02 cidade-vendedores    pic x(40).
       fd usuarios
           label record is standard
           value of file-id
                "Usuarios.Arq".
       01 registro-usuarios.
           02 chave-usuarios.
              03 codigo-usuarios   pic 9(3).
           02 nome-usuarios        pic x(40).
       working-storage section.
       01 linha                    pic 99.
       01 estado-vendedores.
            05 status-key-1     pic x.
            05 status-key-2     pic x.
            05 status-key-2-binary redefines status-key-2 pic 99 comp-x.

       01 estado-usuarios.
            05 usuari-key-1     pic x.
            05 usuari-key-2     pic x.
            05 usuari-key-2-binary redefines usuari-key-2 pic 99 comp-x.

       01 resposta                pic x(01) value spaces.
       01 opcao                   pic 9(02) value zeros.
       procedure division.
       testa-arquivo.
           open i-o vendedores
           if estado-vendedores not = "00"
             if estado-vendedores = "35" or "05"
                close vendedores
                open output vendedores
                close vendedores
                go testa-arquivo
             else
              display "Arquivo Vendedores Com Problema Estado " at 2301
                           estado-vendedores " "
                           status-key-2-binary
              accept resposta at 2380
              stop run
             end-if
           end-if.
           open i-o usuarios
           if estado-usuarios not = "00"
             if estado-usuarios = "35" or "05"
                close usuarios vendedores
                open output usuarios
                close usuarios
                go testa-arquivo
             else
              display "Arquivo Usuarios Com Problema Estado " at 2301
                           estado-usuarios " "
                           usuari-key-2-binary
              accept resposta at 2380
              stop run
             end-if
           end-if.
       menu-geral.
           display erase at 0101
           display "Programa Teste de Lock de Registros e Arquivos"
                                                  at 0101
           display "   Lock Automatic:Vendedores " at 0201
           display "01.Incluir                   " at 0301
           display "02.Consultar                 " at 0401
           display "03.Alterar                   " at 0501
           display "04.Lock de Arquivo           " at 0601
           display "05.Listar Clientes           " at 0701
           display "06.Alterar com IGNORE LOCK   " at 0801
           display "07.Alterar com WAIT   LOCK   " at 0901
           display "00.Sair                      " at 1101

           display "   Lock Manual:Usuarios      " at 0241
           display "11.Incluir                   " at 0341
           display "12.Alterar                   " at 0441
           display "13.Consultar Sem With Lock   " at 0541

           display "Opcao:                       " at 1301
           initialize opcao
           accept opcao at 1308
           if opcao = 1
              go incluir
           else
           if opcao = 2
              go consultar
           else
           if opcao = 3
              go alterar
           else
           if opcao = 4
              go openlock
           else
           if opcao = 5
              go listar
           else
           if opcao = 6
              go alterarignore
           else
           if opcao = 7
              go alterarwait
           else
           if opcao = 0
              close vendedores usuarios
              exit program
              stop run
           else
           if opcao = 11
              go incluirusuario
           else
           if opcao = 12
              go alterarusuario
           else
           if opcao = 13
              go consultasemwithlock
           else
             go menu-geral.
       mostra-tela.
           display erase at 0101
           display "Codigo Vendedor: " at 0501
           display "Nome   Vendedor: " at 0701
           display "Estado Vendedor: " at 0801
           display "Cidade Vendedor: " at 0901
           move zeros  to codigo-vendedores
           move spaces to nome-vendedores uf-vendedores
                          cidade-vendedores.
       incluir.
           perform mostra-tela

           accept codigo-vendedores at 0518
           if codigo-vendedores = zeros
              go menu-geral
           end-if

           read vendedores not invalid key
              display "Este Codigo Ja Existe ... Enter" at 2301
                            estado-vendedores
              accept resposta at 2380
              go incluir
           end-read

           accept nome-vendedores at 0718
           accept uf-vendedores at 0818
           accept cidade-vendedores at 0918

           write registro-vendedores invalid key
              display "Erro ao Gravar: " at 2301 estado-vendedores
              accept resposta at 2380
              go incluir
           end-write
           go incluir.
       consultar.
           perform mostra-tela

           accept codigo-vendedores at 0518
           if codigo-vendedores = zeros
              go menu-geral
           end-if

           read vendedores invalid key
              display "Este Codigo Nao Existe ... Enter" at 2301
                            estado-vendedores
              accept resposta at 2380
              go consultar
           end-read

           display "File-Status       : " at 1101 estado-vendedores
           display "File-Status Binary: " at 1201 status-key-2-binary

           display nome-vendedores at 0718
           display uf-vendedores at 0818
           display cidade-vendedores at 0918
           accept resposta at 2301
           go consultar.
       alterar.
           perform mostra-tela

           accept codigo-vendedores at 0518
           if codigo-vendedores = zeros
              go menu-geral
           end-if

           read vendedores invalid key
              display "Este Codigo Nao Existe ... Enter" at 2301
                            estado-vendedores
              accept resposta at 2380
              go alterar
           end-read

           display "File-Status       : " at 1101 estado-vendedores
           display "File-Status Binary: " at 1201 status-key-2-binary

           accept nome-vendedores at 0718 with update
           accept uf-vendedores at 0818 with update
           accept cidade-vendedores at 0918 with update

           rewrite registro-vendedores invalid key
              display "Erro ao ReGravar: " at 2301 estado-vendedores
              accept resposta at 2380
              go alterar
           end-rewrite
           go alterar.
       openlock.
           display erase at 0101
           display "Abrindo em modo LOCK" at 0101
           close vendedores
           open i-o vendedores with lock
           display "Arquivo Vendedores Com Estado: " at 0501
                           estado-vendedores " "
                           status-key-2-binary
           accept resposta at 2380
           close vendedores usuarios
           go testa-arquivo.
       listar.
           display erase at 0101
           display "Codigo      Nome " at 0101.
       listar-start.
           move zeros  to codigo-vendedores
           move spaces to nome-vendedores
           start vendedores key is >= chave-vendedores invalid key
                 go listar-fim
           end-start
           move 01 to linha.
       listar-le.
           read vendedores next at end
                 go listar-fim.
           add 1 to linha
           display codigo-vendedores at line linha column 01
           display nome-vendedores at line linha column 08

           if linha = 22
              go listar-para
           end-if

           go listar-le.
       listar-para.
           display "Enter para proxima tela." at 2301
           accept resposta at 2370
           perform listar
           move 1 to linha
           go listar-le.
       listar-fim.
           display "Enter Finaliza." at 2301
           accept resposta at 2370
           go menu-geral.
       alterarignore.
           perform mostra-tela

           accept codigo-vendedores at 0518
           if codigo-vendedores = zeros
              go menu-geral
           end-if

           read vendedores with ignore lock invalid key
              display "Este Codigo Nao Existe ... Enter" at 2301
                            estado-vendedores
              accept resposta at 2380
              go alterarignore
           end-read

           display "File-Status       : " at 1101 estado-vendedores
           display "File-Status Binary: " at 1201 status-key-2-binary

           accept nome-vendedores at 0718 with update

           rewrite registro-vendedores invalid key
              display "Erro ao ReGravar: " at 2301 estado-vendedores
              accept resposta at 2380
              go alterarignore
           end-rewrite
           go alterarignore.
       alterarwait.
           perform mostra-tela

           accept codigo-vendedores at 0518
           if codigo-vendedores = zeros
              go menu-geral
           end-if

           read vendedores with wait lock invalid key
              display "Este Codigo Nao Existe ... Enter" at 2301
                            estado-vendedores
              accept resposta at 2380
              go alterarwait
           end-read

           display "File-Status       : " at 1101 estado-vendedores
           display "File-Status Binary: " at 1201 status-key-2-binary

           accept nome-vendedores at 0718 with update

           rewrite registro-vendedores invalid key
              display "Erro ao ReGravar: " at 2301 estado-vendedores
              accept resposta at 2380
              go alterarwait
           end-rewrite
           go alterarwait.
       mostra-tela-usuarios.
           display erase at 0101
           display "Codigo Usuario : " at 0501
           display "Nome   Vendedor: " at 0701
           move zeros  to codigo-usuarios
           move spaces to nome-usuarios.
       incluirusuario.
           perform mostra-tela-usuarios

           accept codigo-usuarios at 0518
           if codigo-usuarios = zeros
              go menu-geral
           end-if

           read usuarios with lock not invalid key
              display "Este Codigo Ja Existe ... Enter" at 2301
                            estado-usuarios
              accept resposta at 2380
              go incluirusuario
           end-read

           accept nome-usuarios at 0718

           write registro-usuarios invalid key
              display "Erro ao Gravar: " at 2301 estado-usuarios
              accept resposta at 2380
              go incluirusuario
           end-write
           go incluirusuario.
       alterarusuario.
           perform mostra-tela-usuarios

           accept codigo-usuarios at 0518
           if codigo-usuarios = zeros
              go menu-geral
           end-if

           read usuarios with lock invalid key
              display "Este Codigo Nao Existe ... Enter" at 2301
                            estado-usuarios
              accept resposta at 2380
              go alterarusuario
           end-read

           display "File-Status       : " at 1101 estado-usuarios
           display "File-Status Binary: " at 1201 usuari-key-2-binary

           accept nome-usuarios at 0718 with update

           rewrite registro-usuarios invalid key
              display "Erro ao Gravar: " at 2301 estado-usuarios
              accept resposta at 2380
              go alterarusuario
           end-rewrite
           go alterarusuario.
       consultasemwithlock.
           perform mostra-tela-usuarios

           accept codigo-usuarios at 0518
           if codigo-usuarios = zeros
              go menu-geral
           end-if

           read usuarios invalid key
              display "Este Codigo Nao Existe ... Enter" at 2301
                            estado-usuarios
              accept resposta at 2380
              go consultasemwithlock
           end-read

           display "File-Status       : " at 1101 estado-usuarios
           display "File-Status Binary: " at 1201 usuari-key-2-binary

           display nome-usuarios at 0718
           accept resposta at 2301

           go consultasemwithlock.
       end program LockMode.

