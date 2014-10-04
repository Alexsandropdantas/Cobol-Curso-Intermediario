       identification division.
       program-id. clientes.
       environment division.
       configuration section.
       special-names. decimal-point is comma.
       input-output section.
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
       77 espera                    pic x(01).
       01 opcao                     pic 9(01).
       procedure division.
       abrindo.
           open i-o clientes
           if fs-estado not = "00"
             if fs-estado = "35" or "05"
                   close clientes
                   open output clientes
                   close clientes
                   go abrindo
             else
                   display "Erro ao abrir :" at 2101 fs-estado
                   close clientes
                   accept espera at 2201
                   exit program
             end-if
           end-if.
       menugeral.
           display erase at 0101
           display "1.Incluir Clientes" at 0201
           display "2.Alterar Clientes" at 0301
           display "0.Sair" at 0401
           display "Opcao:" at 0501
           accept opcao at 0507
           if opcao = 1
              go incluir
           else
           if opcao = 2
              go alterar
           else
           if opcao = 0
              close clientes
              exit program
              stop run
           else
              go menugeral.
       incluir.
           display erase at 0101
           display "Cadastrando Clientes" at 0101
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
       incluir-codigo.
           initialize registro-clientes
           accept codigo-clientes at 0229
           if codigo-clientes = spaces
              go menugeral
           end-if
           read clientes not invalid key
              display "Cliente Ja Existe (Pressione Enter)" at 2001
              accept espera at 2201
              go incluir
           end-read
           accept nome-clientes at 0329
           accept endereco-clientes at 0429
           accept bairro-clientes at 0529
           accept pais-clientes at 0629
           accept cidade-clientes at 0729
           accept estado-clientes at 0829
           accept patrimonio-clientes at 0929
           accept datacadastro-clientes at 1029
           accept situacao-clientes at 1129
           write registro-clientes invalid key
              display "Erro ao gravar Cliente" at 2001
                      " Estado: " fs-estado
              accept espera at 2201
              go incluir
           end-write
           go incluir.
       alterar.
           perform incluir.
       alterar-codigo.
           initialize registro-clientes
           accept codigo-clientes at 0229
           if codigo-clientes = spaces
              go menugeral
           end-if
           read clientes invalid key
              display "Cliente Nao Existe (Pressione Enter)" at 2001
              accept espera at 2201
              go alterar
           end-read
           accept nome-clientes at 0329 with update
           accept endereco-clientes at 0429 with update
           accept bairro-clientes at 0529 with update
           accept pais-clientes at 0629 with update
           accept cidade-clientes at 0729 with update
           accept estado-clientes at 0829 with update
           accept patrimonio-clientes at 0929 with update
           accept datacadastro-clientes at 1029 with update
           accept situacao-clientes at 1129 with update
           rewrite registro-clientes invalid key
              display "Erro ao gravar Cliente" at 2001
                      " Estado: " fs-estado
              accept espera at 2201
              go alterar
           end-rewrite
           go alterar.

       end program clientes.