
# Guia de Uso para o EA_Teste

## Introdução
O **EA_Teste** é um Expert Advisor (EA) desenvolvido para a plataforma MetaTrader 5. Ele utiliza um conjunto de ferramentas modulares, incluindo sinais baseados no indicador RSI, trailing stop com o Parabolic SAR e gerenciamento de risco com lotes fixos. Este guia explicará como configurar e operar o EA de forma eficiente.

---

## Pré-requisitos
1. **Plataforma MetaTrader 5** instalada.
2. **Conta de negociação habilitada para o ativo desejado**.
3. Familiaridade básica com configurações de robôs de negociação.

---

## Instalação
1. Copie o arquivo `EA_Teste.mq5` para o diretório:
   ```
   <MetaTrader5>/MQL5/Experts/
   ```
2. Abra o MetaEditor e compile o arquivo para garantir que não há erros.
3. No MetaTrader 5, adicione o EA a um gráfico do ativo desejado.

---

## Configurações do Robô

### Parâmetros Gerais
| Parâmetro               | Descrição                                                                 | Valor Padrão |
|-------------------------|---------------------------------------------------------------------------|--------------|
| `Expert_Title`          | Nome do robô mostrado no terminal.                                       | "EA_Teste"   |
| `Expert_MagicNumber`    | Número mágico para identificar ordens abertas pelo robô.                 | 5478         |
| `Expert_EveryTick`      | Define se o robô será atualizado em cada tick ou a cada novo candle.     | `false`      |

### Configurações de Sinais
| Parâmetro               | Descrição                                                                 | Valor Padrão |
|-------------------------|---------------------------------------------------------------------------|--------------|
| `Signal_ThresholdOpen`  | Limite mínimo para abertura de ordens (0-100).                          | 10           |
| `Signal_ThresholdClose` | Limite mínimo para fechamento de ordens (0-100).                        | 10           |
| `Signal_RSI_PeriodRSI`  | Período do indicador RSI.                                               | 8            |
| `Signal_RSI_Applied`    | Tipo de preço usado no cálculo do RSI (fechamento, abertura, etc.).      | Fechamento   |

### Configurações de Trailing Stop
| Parâmetro                  | Descrição                                           | Valor Padrão |
|----------------------------|---------------------------------------------------|--------------|
| `Trailing_ParabolicSAR_Step` | Incremento na aceleração do Parabolic SAR.        | 0.02         |
| `Trailing_ParabolicSAR_Maximum` | Taxa máxima de aceleração do Parabolic SAR.      | 0.2          |

### Configurações de Gerenciamento de Risco
| Parâmetro               | Descrição                                                                 | Valor Padrão |
|-------------------------|---------------------------------------------------------------------------|--------------|
| `Money_FixLot_Percent`  | Percentual do saldo da conta a ser arriscado por negociação.             | 10.0         |
| `Money_FixLot_Lots`     | Volume fixo de lote para negociações.                                    | 0.1          |

---

## Operação

1. **Carregue o EA em um gráfico**: Escolha o ativo e o período desejados.
2. **Configure os parâmetros**: Ajuste os valores dos inputs conforme sua estratégia.
3. **Ative o robô**: Certifique-se de que a negociação automática está habilitada no MetaTrader 5.

O robô usará os sinais configurados para abrir negociações e aplicará trailing stop e gerenciamento de risco automaticamente.

---

## Notas e Recomendações
- **Teste em conta demo**: Antes de usar em uma conta real, teste o EA em um ambiente simulado para garantir que ele se comporta como esperado.
- **Ajuste parâmetros regularmente**: O mercado é dinâmico, e os parâmetros podem precisar de ajustes para melhorar a eficiência.
- **Acompanhe os resultados**: Monitore regularmente os resultados para identificar oportunidades de otimização.

---

## Observações
- Este robô possui lógica de funcionamento baseado em contas do tipo **Netting**. Em contas de tipo **Hedge**, poderá ter comportamentos imprevisíveis e diferentes do esperado.
- Há diferenças entre o mercado de Forex e o mercado da B3:
  - No **Forex**, o ideal é que o lote seja redefinido para variável do tipo decimal com valor padrão de **0.01**.
  - No mercado **B3** (bolsa brasileira), o valor do lote deve ser um número inteiro com múltiplos de **100**, sendo este o valor mínimo.
- Este robô é para fins educacionais, **não é indicação ou sugestão de investimento**.
- Sugerimos fortemente a realização do curso ["Crie Robôs com MQL5 e Programação Orientada a Objetos - POO"](https://crieseurobocommql5.wordpress.com) para a melhor compreensão deste Expert Advisor.

---

## Suporte
Se encontrar problemas ou tiver dúvidas, visite:
[https://crieseurobocommql5.wordpress.com](https://crieseurobocommql5.wordpress.com)

---

**Versão:** 1.00  
**Autor:** rafaelfvcs
