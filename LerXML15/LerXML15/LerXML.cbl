       Identification division.
       Program-id. LerXML.
       environment division.
       configuration section.
       special-names. decimal-point is comma.
       input-output section.
       file-control.
       select arquivoxml
              assign to "C:\CursoCobol\LerXML\XMLExemplo.XML"
              file status is estado
              organization is line sequential.
       Data division.
       fd arquivoxml
           label record is standard.
       01 registro-arquivoxml       pic x(2000).
       Working-storage section.
       01 estado                    pic x(02).
       01 resposta                  pic x.

       01 current-element           pic x(30).
       01 valorunitario             computational pic 999v99 value 0.
       01 display-unitario          pic $zz9.99.

       Procedure division.
       arquivo.
           display erase at 0101
           open input arquivoxml
           if estado not = "00"
              display "Arquivo XML Nao existe: " at 2301 estado
              accept resposta at 2401
              stop run
           end-if.
       lendo.
           read arquivoxml at end
              go fim.

           XML parse registro-arquivoxml
                     processing procedure xml-handler thru
                                          xml-handler-exit
           End-XML
           go lendo.

       xml-handler section.
           Evaluate XML-Event
           When 'START-OF-ELEMENT'
             Display 'Start element tag: {' XML-Text '}'
             Move XML-Text to current-element
           When 'CONTENT-CHARACTERS'
             Display 'Content characters: {' XML-Text '}'
             evaluate current-element
             When 'vUnTrib'
              Compute ValorUnitario = function numval-c(XML-Text)
             End-evaluate
           When 'END-OF-ELEMENT'
             Display 'End element tag: {' XML-Text '}'
             Move spaces to current-element
           When 'VERSION-INFORMATION'
             Display 'Version: {' XML-Text '}'
           When 'ENCODING-DECLARATION'
             Display 'Encoding: {' XML-Text '}'
           When 'STANDALONE-DECLARATION'
             Display 'Standalone: {' XML-Text '}'
           When 'ATTRIBUTE-NAME'
             Display 'Attribute name: {' XML-Text '}'
           When 'ATTRIBUTE-CHARACTERS'
             Display 'Attribute value characters: {' XML-Text '}'
           When 'COMMENT'
             Display 'Comment: {' XML-Text '}'
           End-evaluate
           .
       xml-handler-exit.
           exit.
       fim.
           Move ValorUnitario to Display-Unitario
           Display '---> Informacao do XML - Valor Unitario :   '
                         Display-Unitario
           accept resposta
           close arquivoxml
           stop run.
       End program LerXML.