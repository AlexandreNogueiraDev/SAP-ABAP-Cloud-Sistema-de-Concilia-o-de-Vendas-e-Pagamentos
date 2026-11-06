# SAP ABAP Cloud — Sistema de Conciliação de Vendas e Pagamentos

## Sobre o projeto

Este projeto consiste em um sistema de conciliação de vendas e pagamentos desenvolvido utilizando **SAP ABAP Cloud**, com o objetivo de aplicar conceitos de desenvolvimento back-end, modelagem de dados e construção de serviços OData.

A aplicação permite cadastrar, consultar, atualizar e excluir registros de vendas, além de calcular automaticamente o status da conciliação de acordo com os valores da venda e do pagamento.

O projeto foi desenvolvido como parte dos meus estudos em desenvolvimento SAP, com foco na aplicação prática de conceitos da arquitetura RAP (RESTful ABAP Programming Model).

## Tecnologias utilizadas

- SAP ABAP Cloud
- SAP BTP Trial
- Eclipse com ABAP Development Tools (ADT)
- CDS Views
- RESTful ABAP Programming Model (RAP)
- OData V4
- Postman
- SQL / Modelagem de dados

## Arquitetura

O projeto utiliza a arquitetura RAP, organizada em camadas:

```text
Z_ALE_CONCILIACAO
│
├── ZTALE_VENDA
│   └── Tabela de persistência
│
├── ZI_ALE_VENDA
│   └── CDS Interface View
│
├── ZBP_I_ALE_VENDA
│   └── Behavior Pool
│       └── LHC_Venda
│           ├── Determination: calcularStatus
│           └── Validation: validarValores
│
├── ZC_ALE_VENDA
│   └── CDS Projection View
│
├── ZC_ALE_VENDA
│   └── Projection Behavior Definition
│
├── ZSD_ALE_VENDA
│   └── Service Definition
│
├── ZSB_ALE_VENDA
│   └── Service Binding OData V4
│
└── ZCL_ALE_CARGA_VENDAS
    └── Classe auxiliar para carga de dados
```

### Camadas do sistema

**Persistência:** a tabela `ZTALE_VENDA` armazena os dados das vendas e pagamentos.

**Interface:** a CDS View `ZI_ALE_VENDA` representa os dados e serve como base para o comportamento da aplicação.

**Comportamento:** a Behavior Pool `ZBP_I_ALE_VENDA` implementa as regras de negócio, incluindo o cálculo do status e a validação dos valores.

**Projeção:** a CDS View `ZC_ALE_VENDA` expõe os campos necessários para consumo do serviço.

**Exposição:** a Service Definition `ZSD_ALE_VENDA` e a Service Binding `ZSB_ALE_VENDA` disponibilizam a aplicação por meio de OData V4.

## Funcionalidades

- Cadastro de vendas e pagamentos.
- Consulta dos registros cadastrados.
- Atualização de informações.
- Exclusão de registros.
- Geração automática de UUID para identificação da conciliação.
- Cálculo automático do status.
- Validação de valores financeiros.
- Exposição das operações por meio de serviço OData V4.

## Regras de negócio

O status da conciliação é calculado automaticamente conforme os valores da venda e do pagamento.

| Condição | Status |
|---|---|
| Pagamento igual a zero | `NAO PAGO` |
| Pagamento igual ao valor da venda | `CONCILIADO` |
| Pagamento menor que o valor da venda | `PENDENTE` |
| Pagamento maior que o valor da venda | `DIVERGENTE` |

Também foram implementadas validações para impedir:

- Valores de venda menores ou iguais a zero.
- Valores de pagamento negativos.

Essas validações são executadas durante a gravação, impedindo que dados inválidos sejam persistidos.

## Modelo de dados

A tabela `ZTALE_VENDA` possui os seguintes campos:

| Campo | Descrição |
|---|---|
| `CLIENT` | Mandante SAP |
| `ID_CONCILIACAO` | Identificador UUID da conciliação |
| `ID_VENDA` | Identificador da venda |
| `VALOR_VENDA` | Valor total da venda |
| `VALOR_PAGO` | Valor recebido |
| `MOEDA` | Moeda dos valores financeiros |
| `DATA_PAGAMENTO` | Data do pagamento |
| `STATUS` | Situação da conciliação |

## Testes da API

A API foi testada utilizando o Postman, com autenticação OAuth 2.0 e operações de leitura e modificação.

### Endpoint

```text
/sap/opu/odata4/sap/zsb_ale_venda/srvd/sap/zsd_ale_venda/0001/Vendas
```

A URL completa depende do host do ambiente SAP BTP.

### Consultar vendas — GET

```http
GET {HOST}/sap/opu/odata4/sap/zsb_ale_venda/srvd/sap/zsd_ale_venda/0001/Vendas
```

Retorna os registros cadastrados.

### Criar venda — POST

```http
POST {HOST}/sap/opu/odata4/sap/zsb_ale_venda/srvd/sap/zsd_ale_venda/0001/Vendas
```

Exemplo de corpo:

```json
{
    "id_venda": "3",
    "valor_venda": 250.00,
    "valor_pago": 250.00,
    "moeda": "BRL",
    "data_pagamento": "2026-11-06"
}
```

O identificador UUID e o status são gerados automaticamente pelo sistema.

### Atualizar pagamento — PATCH

```http
PATCH {HOST}/sap/opu/odata4/sap/zsb_ale_venda/srvd/sap/zsd_ale_venda/0001/Vendas({ID_UUID})
```

Exemplo de corpo:

```json
{
    "valor_pago": 100.00,
    "moeda": "BRL"
}
```

Após a atualização, o sistema recalcula o status da conciliação.

### Excluir venda — DELETE

```http
DELETE {HOST}/sap/opu/odata4/sap/zsb_ale_venda/srvd/sap/zsd_ale_venda/0001/Vendas({ID_UUID})
```

Remove o registro identificado pelo UUID.

## Testes realizados

Durante o desenvolvimento, foram realizados testes para verificar:

- Consulta de registros via GET.
- Criação de registros via POST.
- Atualização de valores via PATCH.
- Exclusão de registros via DELETE.
- Geração automática de UUID.
- Atualização automática do status.
- Bloqueio de valores inválidos.
- Persistência dos dados após as operações.

## Aprendizados

O desenvolvimento deste projeto permitiu aprofundar conhecimentos em:

- Desenvolvimento back-end com SAP ABAP Cloud.
- Modelagem e persistência de dados.
- CDS Views e arquitetura RAP.
- Implementação de determinations e validations.
- Criação e consumo de serviços OData V4.
- Autenticação OAuth 2.0.
- Testes de APIs com Postman.
- Implementação de regras de negócio.

## Próximas melhorias

- Implementar controle de autorização.
- Melhorar o tratamento de erros.
- Desenvolver uma interface de usuário para consulta e gerenciamento das conciliações.
- Expandir as regras de negócio para cenários de conciliação mais complexos.

## Autor

Desenvolvido por **Alexandre Nogueira** como projeto de estudo e prática em SAP ABAP Cloud.
