       identification division.
       program-id. PrimeiroProgramaCobol01.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 resposta pic x(01) value spaces.
       
       

       procedure division.
       
       Display "Comando Display=Mostra a Mensagem na Tela" at 1001
       Accept resposta at 2301

           goback.

       end program PrimeiroProgramaCobol01.