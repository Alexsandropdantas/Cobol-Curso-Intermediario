       Identification division.
       Program-id. BibliotecasRotinas.
       Working-storage Section.
       01 cbl-os-flags             pic x(4) comp-5.
       01 cbl-os-size              pic x(4) comp-5.
       01 cbl-acess-mode           pic x    comp-x.
       01 cbl-deny-mode            pic x    comp-x.
       01 cbl-device               pic x    comp-x.
       01 file-handle              pic x(4) comp-5.
       01 file-details.
          03 cbl-fe-filesize       pic x(8) comp-x.
          03 cbl-fe-filedate.
             05 cbl-fe-day         pic x    comp-x.
             05 cbl-fe-month       pic x    comp-x.
             05 cbl-fe-year        pic x(2) comp-x.
          03 cbl-fe-filetime.
             05 cbl-fe-hours       pic x    comp-x.
             05 cbl-fe-minutes     pic x    comp-x.
             05 cbl-fe-seconds     pic x    comp-x.
             05 cbl-fe-hundredths  pic x    comp-x.
       01 result                   pic x    comp-x.
       01 function-code            pic x    comp-x.
       01 parameter.
          03 name-len              pic x    comp-x.
          03 name-prg              pic x(07).

       01 descricao                pic x(100).
       01 descricao2               pic x(100).

       01 status-code              pic x(2) comp-5.
       01 file-status              pic xx comp-x.
       01 redefines file-status.
            03 fs-byte-1  pic x.
            03 fs-byte-2  pic x.

       01 datetime                 pic 9(04).

       01 xcblt-os-info-params.
          03 xcblte-osi-length                pic x(2) comp-x value 28.
          03 xcblte-osi-os-type               pic x comp-x.
          03 xcblte-osi-os-version            pic x(4) comp-x.
          03 xcblte-osi-dbcs-support          pic x comp-x.
          03 xcblte-osi-char-coding           pic x comp-x.
          03 xcblte-osi-country-id            pic x(2) comp-x.
          03 xcblte-osi-code-page             pic x(2) comp-x.
          03 xcblte-osi-process-type          pic x comp-x.
          03 xcblte-osi-rts-capabilities      pic x(4) comp-x.
          03 xcblte-osi-product               pic x(2) comp-x.
          03 xcblte-osi-product-version       pic x(2) comp-x.
          03 xcblte-osi-product-revision      pic x(2) comp-x.
          03 xcblte-osi-product-sp            pic x(2) comp-x.
          03 xcblte-osi-fixpack               pic x(2) comp-x.
       01 numerico                 pic 9(05).

       01 xcblt-screen-position.
          03 xcblte-scrp-row       pic x comp-x.
          03 xcblte-scrp-col       pic x comp-x.
       01 character-buffer         pic x(2000).
       01 string-length            pic x(0010).

       01 resposta                 pic x.
       Procedure Division.
       Exemplos.
           display erase at 0101

           set cbl-os-flags to zero
           call "CBL_GET_CURRENT_DIR" using by value cbl-os-flags
                                      by value       cbl-os-size
                                      by reference   descricao
                                      returning      status-code
           display "Diretorio Corrente.....: " at 0201 descricao
           display "Status.................: " at 0301 status-code

           move "C:\CursoCobol" to descricao
           call "CBL_CREATE_DIR" using          descricao
                                 returning      status-code
           display "Diretorio Criado.......: " at 0501 descricao
           display "Status.................: " at 0601 status-code

           move "C:\CursoCobol\CBL_CREATE_DIR" to descricao
           call "CBL_CREATE_DIR" using          descricao
                                 returning      status-code
           display "Diretorio Criado.......: " at 0501 descricao
           display "Status.................: " at 0601 status-code

           move "C:\CursoCobol\CBL_CREATE_DIR" to descricao
           call "CBL_CHANGE_DIR" using          descricao
                                 returning      status-code
           display "Diretorio Corrente.....: " at 0801 descricao
           display "Status.................: " at 0901 status-code

      *Capturando os caracteres da tela...
           move 0 to xcblte-scrp-row xcblte-scrp-col
           call "CBL_READ_SCR_CHARS" using xcblt-screen-position
                                           character-buffer
                                           string-length
                                 returning status-code

           move "ARQUIVO.TXT" to descricao
           move "1" to cbl-acess-mode
           move "0" to cbl-deny-mode
           move "0" to cbl-device
           call "CBL_CREATE_FILE" using          descricao
                                                 cbl-acess-mode
                                                 cbl-deny-mode
                                                 cbl-device
                                                 file-handle
           display "Arquivo Criado.........: " at 1101 descricao
           display "Status.................: " at 1201 file-handle

           move "ARQUIVO.TXT" to descricao
           call "CBL_CHECK_FILE_EXIST" using     descricao
                                                 file-details
                                       returning status-code
           display "Verificando Dados......: " at 1401 descricao
           move cbl-fe-hours    to datetime
           display "Hora...................: " at 1501 datetime
           move cbl-fe-minutes  to datetime
           display "Minuto.................: " at 1601 datetime

           display "Crie agora um arquivo em: " at 2001
           display " C:\CursoCobol\CBL_CREATE_DIR\" at 2101
           display "Invente um nome/extensao.Depois Enter." at 2201
           accept resposta at 2301

           display erase at 0101
           initialize descricao descricao2
           display "Digite o nome do arquivo criado:" at 0201
           accept descricao2 at 0234
           string "C:\CursoCobol\CBL_CREATE_DIR\" delimited by size
                  descricao2                      delimited spaces
                  into                            descricao
           move "C:\CursoCobol\CBL_CREATE_DIR\ARQUIVO.TTT" to descricao2
           call "CBL_COPY_FILE"   using          descricao
                                                 descricao2
                                  returning      status-code
           display "Arquivo Copiado Para...: " at 1801 descricao2
           display "Status.................: " at 1901 status-code
           accept resposta at 2301

           display erase at 0101
           display "Executando Notepag." at 0201
           move 35        to function-code
           move 07        to name-len
           move "NOTEPAD" to name-prg
           call x"91"  using result
                             function-code
                             parameter

           accept resposta at 2301

           display erase at 0101
           display "Executando CBL_GET_OS_INFO" at 0201
           call "CBL_GET_OS_INFO" using xcblt-os-info-params
                              returning status-code

           display "Codigo do Pais........: " at 0301
                                    xcblte-osi-country-id
           display "Codigo do Pagina......: " at 0401
                                    xcblte-osi-code-page
           display "Codigo do Produto.....: " at 0501
                                    xcblte-osi-product
           move xcblte-osi-os-type to numerico
           display "Sist.Operacional Tipo.: " at 0601
                                    numerico
              *> 131 "Windows systems"
              *> 128 "COBOL system on UNIX"
              *>     "Unknown OS!"

           accept resposta at 2301

           display erase at 0101

      *Gravando os caracteres da tela...
           move 0 to xcblte-scrp-row xcblte-scrp-col
           call "CBL_WRITE_SCR_CHARS" using xcblt-screen-position
                                            character-buffer
                                            string-length
                                  returning status-code

           accept resposta at 2301
          stop run
           .
       End Program BibliotecasRotinas.