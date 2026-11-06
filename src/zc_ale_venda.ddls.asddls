@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projeção de Vendas'

define root view entity ZC_ALE_VENDA
  provider contract transactional_query
  as projection on ZI_ALE_VENDA
{
  key id_conciliacao,
      id_venda,
      valor_venda,
      valor_pago,
      moeda,
      data_pagamento,
      status
}
