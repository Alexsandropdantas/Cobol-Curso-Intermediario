       identification division.
       program-id. Tag.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 resposta     pic x.

      *----- Criando = Clientes
       copy "tagcopy.cpy"
            replacing leading ==TAG== by ==clientes==.
      *----- Criando = Fornecedores
       copy "tagcopy.cpy"
            replacing leading ==TAG== by ==fornecedores==.

       procedure division.
           display erase at 0101
           move "JOAO" to clientes-nome fornecedores-nome
           display "Dados Movidos" at 0201
           accept resposta at 2301
           goback.

       end program Tag.