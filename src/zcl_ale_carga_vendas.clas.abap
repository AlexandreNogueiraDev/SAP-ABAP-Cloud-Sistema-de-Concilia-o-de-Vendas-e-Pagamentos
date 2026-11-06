CLASS zcl_ale_carga_vendas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_ale_carga_vendas IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA ls_venda TYPE ztale_venda.

    TRY.

        " Gerar identificador único
        ls_venda-id_conciliacao =
          cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_uuid_error.

        out->write( 'Erro ao gerar UUID!' ).
        RETURN.

    ENDTRY.

    " Preencher dados da venda
    ls_venda-id_venda = '0000000002'.
    ls_venda-valor_venda = '150.00'.
    ls_venda-valor_pago = '150.00'.
    ls_venda-moeda = 'BRL'.
    ls_venda-data_pagamento = '20261105'.
    ls_venda-status = 'CONCILIADO'.

    " Inserir no banco
    INSERT ztale_venda FROM @ls_venda.

    IF sy-subrc = 0.

      out->write( 'Venda inserida com sucesso!' ).
      out->write( ls_venda-id_conciliacao ).

    ELSE.

      out->write( 'Erro ao inserir venda!' ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.

