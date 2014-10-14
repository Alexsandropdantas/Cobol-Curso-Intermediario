       identification division.
       program-id. MergeArquivos.
       environment division.
       configuration section.
       special-names. decimal-point is comma.
       input-output section.
       file-control.
       select arquivo1
              assign to "C:\CursoCobol\MergeArquivos\arquivo1.txt"
              file status is estado-arquivo1
              organization is line sequential.
       select arquivo2
              assign to "C:\CursoCobol\MergeArquivos\arquivo2.txt"
              file status is estado-arquivo2
              organization is line sequential.
       select organizado assign to "arquivoorganizado.txt"
              file status is estado-organizado
              organization is line sequential.
       select temporario assign to "temporario.tmp".
       data division.
       fd arquivo1
           label record is standard.
       01 registro-arquivo1.
           02 chave-arquivo1.
              03 codigo-arquivo1   pic 9(04).
           02 nome-arquivo1        pic x(40).
       fd arquivo2
           label record is standard.
       01 registro-arquivo2.
           02 chave-arquivo2.
              03 codigo-arquivo2   pic 9(04).
           02 nome-arquivo2        pic x(40).
       fd organizado
           label record is standard.
       01 registro-organizado.
           02 chave-organizado.
              03 codigo-organizado pic 9(04).
           02 nome-organizado      pic x(40).
       sd temporario.
       01 registro-temporario.
           02 chave-temporario.
             03 codigo-temporario  pic 9(04).
           02 nome-temporario      pic x(40).
       working-storage section.
       01 linha                    pic 99.
       01 estado-organizado        pic xx.
       01 estado-arquivo1          pic xx.
       01 estado-arquivo2          pic xx.

       01 resposta                 pic x(01) value spaces.
       01 opcao                    pic 9(02) value zeros.
       procedure division.
       testandoarquivos.
           open input arquivo1
           if estado-arquivo1 not = "00"
              display "Arquivo arquivo1 Com Problema Estado " at 2301
                           estado-arquivo1
              accept resposta at 2380
              stop run
           end-if
           close arquivo1.
           open input arquivo2
           if estado-arquivo1 not = "00"
              display "Arquivo arquivo2 Com Problema Estado " at 2301
                           estado-arquivo2
              accept resposta at 2380
              stop run
           end-if
           close arquivo2.
       gerando-merge.
           MERGE Temporario
                 ON ASCENDING KEY codigo-temporario, nome-temporario
                 USING arquivo1, arquivo2
                 GIVING organizado.
       listar.
           display erase at 0101
           display "Codigo      Nome " at 0101.
       listar-start.
           open input organizado
           if estado-organizado not = "00"
              display "Arquivo organizado Com Problema Estado " at 2301
                           estado-organizado
              accept resposta at 2380
              stop run
           end-if
           move 01 to linha.
       listar-le.
           read organizado at end
                 go listar-fim.
           add 1 to linha
           display codigo-organizado at line linha column 01
           display nome-organizado at line linha column 08

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
           close organizado
           exit program
           stop run.
       end program MergeArquivos.