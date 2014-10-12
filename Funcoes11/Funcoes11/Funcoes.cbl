      $SET MS"2"
       identification division.
       program-id. Funcoes.
       environment division.
       configuration section.
       special-names. decimal-point is comma.
       input-output section.
       file-control.
       working-storage section.
       01 resposta                pic x(01) value spaces.
       01 opcao                   pic 9(02) value zeros.

       01 valores                 pic 9(10) value zeros.
       01 texto                   pic x(30) value spaces.
       01 resultado               pic 9(10) value zeros.
       01 resultadotexto          pic x(40) value spaces.

       01 data-dia                pic 9(06).
       01 data-century            pic 9(08).
       01 dia-da-semana           pic 9(10).

       01 Campos.
            10 Total-Campos             PIC 9(02).
            10 Subscrito.
                15 Info occurs 5 times  PIC 9(02).
       procedure division.
       executando-funcoes.
           display erase at 0101

           move 01 to info(1)
           move 02 to info(2)
           move 03 to info(3)
           move 04 to info(4)
           move 08 to info(5)
           compute resultado = function sum (info(all))
           display "Funcao SUM............... .:" at 0301 resultado

           move "Texto53689768" to texto
           move function reverse (texto) to resultadotexto
           display "Funcao REVERSE............:" at 0401 resultadotexto

           accept data-dia from date
           display "Data do Dia...............:" at 0501 data-dia

           compute data-century =
              FUNCTION DATE-TO-YYYYMMDD (data-dia)
           display "Data do Dia com YYYYMMDD..:" at 0601 data-century

           move function when-compiled to resultadotexto
           display "Funcao When-Compiled......:" at 0701 resultadotexto

           move function length (opcao) to resultado
           display "Funcao Length OPCAO.......:" at 0801 resultado

           move function length (campos) to resultado
           display "Funcao Length Campos......:" at 0901 resultado

           accept dia-da-semana from day-of-week.
           display "Dia da Semana.............:" at 1001 dia-da-semana

           accept dia-da-semana from day.
           display "Dia.......................:" at 1101 dia-da-semana

           move "TeXTo PAra TRAnsformar" to texto
           move function lower-case (texto) to resultadotexto
           display "Funcao Lower-case.........:" at 1201 resultadotexto

           move "TeXTo PAra TRAnsformar" to texto
           move function upper-case (texto) to resultadotexto
           display "Funcao Upper-case.........:" at 1301 resultadotexto
           .
       encerra.
           display ".Fim." at 2301
           accept resposta at 2401
           exit program
           stop run
           .