      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "testeTemp".
       author. "Leticia Fausto".
       installation. "PC".
       date-written. 31/07/2020.
       date-compiled. 31/07/2020.



      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

      *>   Declaração do arquivo
           select arqTemp assign to "arqTemp.txt"      *>assosiando arquivo lógico (nome dado ao arquivo dentro do pmg vom o arquivo fisico)
           organization is line sequential                   *>forma de organização dos dados
           access mode is sequential                         *>forma de acesso aos dados
           lock mode is automatic                            *>tratamento de dead lock - evita perda de dados em ambiemtes multi-usuários
           file status is ws-fs-arqTemp.                  *>file status (o status da ultima operação)









       i-o-control.

      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqTemp.

       01 fd-temperaturas.
          05 fd-temp                               pic s9(02)v99.


      *>----Variaveis de trabalho
       working-storage section.

       77  ws-fs-arqTemp                           pic 9(02). *>file status é obrigatorio sempre


       01 ws-temperaturas occurs 30.
          05 ws-temp                               pic s9(02)v99.

       77 ws-media-temp                            pic s9(02)v99.
       77 ws-temp-total                            pic s9(03)v99.


       77 ws-dia                                   pic 9(02).
       77 ws-ind-temp                              pic 9(02).

       77 ws-sair                                  pic x(01).
       77 ws-msn                                   pic x(27).


      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.

      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.

           open input arqTemp.      *>qualquer coisa diferente de 0 é erro. tratamento simples de erro
           if ws-fs-arqTemp  <> 00 then
               move "erro na abertura do arquivo"   to ws-msn
               display ws-msn
               perform finaliza
           end-if


           perform varying ws-dia from 1 by 1 until ws-fs-arqTemp = 10
                                                     or ws-dia > 30

               read arqTemp  into  ws-temperaturas(ws-dia)
                   if ws-fs-arqTemp  <> 00
                   and ws-fs-arqTemp <> 10 then
                       move "erro na leitura do arquivo"   to ws-msn
                       display ws-msn
                       perform finaliza
                   end-if

           end-perform

           close arqTemp.
           if ws-fs-arqTemp  <> 00 then
               move "erro no fechar arquivo"   to ws-msn
               display ws-msn
               perform finaliza
           end-if





           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.

      *>   chamando rotina de calculo da média de temp.
           perform calc-media-temp

      *>    menu do sistema
           perform until ws-sair = "S"
                      or ws-sair = "s"
               display erase

               display "Dia a ser testado: "
               accept ws-dia

               if  ws-dia >= 1
               and ws-dia <= 30 then
                   if ws-temp(ws-dia) > ws-media-temp then
                           display "A media de temperatura eh:" ws-media-temp
                           display "A temperatura do dia " ws-dia " esta acima da media."
                           display "Temperatura = " ws-temp(ws-dia)
                   else
                   if ws-temp(ws-dia) < ws-media-temp then
                           display "A media de temperatura eh:" ws-media-temp
                           display "A temperatura do dia " ws-dia " esta abaixo da media."
                           display "Temperatura = " ws-temp(ws-dia)
                   else
                           display "A temperatura do dia " ws-dia " esta na media."
                   end-if
                   end-if
               else
                   display "Dia fora do intervalo valido (1 -30)"
               end-if

               display "'T'estar outra temperatura"
               display "'S'air"
               accept ws-sair
           end-perform
           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Calculo da média de temperatura
      *>------------------------------------------------------------------------
       calc-media-temp section.

           move 0 to ws-temp-total
           perform varying ws-ind-temp from 1 by 1 until ws-ind-temp > 30
               compute ws-temp-total = ws-temp-total + ws-temp(ws-ind-temp)
           end-perform

           compute ws-media-temp = ws-temp-total/30

           .
       calc-media-temp-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.
           Stop run
           .
       finaliza-exit.
           exit.













