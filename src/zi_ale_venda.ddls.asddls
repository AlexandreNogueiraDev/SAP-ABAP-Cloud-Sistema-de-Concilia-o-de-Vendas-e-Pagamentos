@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface de Vendas'

define root view entity ZI_ALE_VENDA
  as select from ztale_venda
{
  key id_conciliacao,

      id_venda,
      valor_venda,
      valor_pago,
      moeda,
      data_pagamento,
      status
}
