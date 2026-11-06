CLASS lhc_Venda DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Venda
      RESULT result.

    METHODS calcularStatus
      FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Venda~calcularStatus.

    METHODS validarValores
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR Venda~validarValores.

ENDCLASS.


CLASS lhc_Venda IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD calcularStatus.

    READ ENTITIES OF zi_ale_venda IN LOCAL MODE
      ENTITY Venda
      FIELDS ( valor_venda valor_pago )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_vendas).

    MODIFY ENTITIES OF zi_ale_venda IN LOCAL MODE
      ENTITY Venda
      UPDATE FIELDS ( status )
      WITH VALUE #(
        FOR ls_venda IN lt_vendas
        (
          %tky = ls_venda-%tky

          status = COND #(
            WHEN ls_venda-valor_pago = 0
              THEN 'NAO PAGO'

            WHEN ls_venda-valor_pago = ls_venda-valor_venda
              THEN 'CONCILIADO'

            WHEN ls_venda-valor_pago < ls_venda-valor_venda
              THEN 'PENDENTE'

            ELSE 'DIVERGENTE'
          )
        )
      ).

  ENDMETHOD.


  METHOD validarValores.

    READ ENTITIES OF zi_ale_venda IN LOCAL MODE
      ENTITY Venda
      FIELDS ( valor_venda valor_pago )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_vendas).

    LOOP AT lt_vendas INTO DATA(ls_venda).

      IF ls_venda-valor_venda <= 0
         OR ls_venda-valor_pago < 0.

        APPEND VALUE #(
          %tky = ls_venda-%tky
        ) TO failed-venda.

        APPEND VALUE #(
          %tky = ls_venda-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'A venda deve ser maior que zero e o pagamento nao pode ser negativo.'
          )
        ) TO reported-venda.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
