//+------------------------------------------------------------------+
//|                                                     EA_Teste.mq5 |
//|                                                      rafaelfvcs@ |
//|                        https://crieseurobocommql5.wordpress.com/ |
//+------------------------------------------------------------------+
#property copyright "rafaelfvcs@"
#property link      "https://crieseurobocommql5.wordpress.com/"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>  // Biblioteca base para Experts no MT5

//--- Importa componentes modulares
#include <Expert\Signal\SignalRSI.mqh>  // Sinal baseado no indicador RSI
#include <Expert\Trailing\TrailingParabolicSAR.mqh>  // Trailing Stop Parabolic SAR
#include <Expert\Money\MoneyFixedLot.mqh>  // Gerenciamento de risco com lotes fixos

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
// Parâmetros configuráveis pelo usuário
input string             Expert_Title                 ="EA_Teste";  // Nome do robô
ulong                    Expert_MagicNumber           =5478;        // Número mágico para identificar ordens
bool                     Expert_EveryTick             =false;       // Atualizar em cada tick

// Parâmetros do sinal principal
input int                Signal_ThresholdOpen         =10;          // Limite de abertura do sinal [0...100]
input int                Signal_ThresholdClose        =10;          // Limite de fechamento do sinal [0...100]
input double             Signal_PriceLevel            =0.0;         // Nível de preço para executar a ordem
input double             Signal_StopLevel             =50.0;        // Stop Loss (em pontos)
input double             Signal_TakeLevel             =50.0;        // Take Profit (em pontos)
input int                Signal_Expiration            =4;           // Expiração de ordens pendentes (em candles)
input int                Signal_RSI_PeriodRSI         =8;           // Período do RSI
input ENUM_APPLIED_PRICE Signal_RSI_Applied           =PRICE_CLOSE; // Série de preços usada no RSI
input double             Signal_RSI_Weight            =1.0;         // Peso do RSI no sinal [0...1.0]

// Parâmetros do trailing stop
input double             Trailing_ParabolicSAR_Step   =0.02;        // Incremento de velocidade
input double             Trailing_ParabolicSAR_Maximum=0.2;         // Taxa máxima

// Parâmetros de gerenciamento de risco
input double             Money_FixLot_Percent         =10.0;        // Percentual de risco
input double             Money_FixLot_Lots            =0.1;         // Volume fixo

//+------------------------------------------------------------------+
//| Objeto global do expert                                          |
//+------------------------------------------------------------------+
CExpert ExtExpert;  // Instância do Expert Advisor

//+------------------------------------------------------------------+
//| Função de inicialização do robô                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inicializa o Expert Advisor
   if(!ExtExpert.Init(Symbol(), Period(), Expert_EveryTick, Expert_MagicNumber))
   {
      // Se falhar, exibe mensagem de erro e finaliza
      printf(__FUNCTION__+": erro ao inicializar o Expert");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }

   // Cria o sinal principal
   CExpertSignal *signal = new CExpertSignal;
   if(signal == NULL)
   {
      printf(__FUNCTION__+": erro ao criar sinal principal");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }

   // Configura parâmetros do sinal principal
   ExtExpert.InitSignal(signal);
   signal.ThresholdOpen(Signal_ThresholdOpen);
   signal.ThresholdClose(Signal_ThresholdClose);
   signal.PriceLevel(Signal_PriceLevel);
   signal.StopLevel(Signal_StopLevel);
   signal.TakeLevel(Signal_TakeLevel);
   signal.Expiration(Signal_Expiration);

   // Cria e configura o filtro RSI
   CSignalRSI *filter0 = new CSignalRSI;
   if(filter0 == NULL)
   {
      printf(__FUNCTION__+": erro ao criar filtro RSI");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }
   signal.AddFilter(filter0);
   filter0.PeriodRSI(Signal_RSI_PeriodRSI);
   filter0.Applied(Signal_RSI_Applied);
   filter0.Weight(Signal_RSI_Weight);

   // Cria e configura o trailing stop
   CTrailingPSAR *trailing = new CTrailingPSAR;
   if(trailing == NULL)
   {
      printf(__FUNCTION__+": erro ao criar trailing stop");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }
   if(!ExtExpert.InitTrailing(trailing))
   {
      printf(__FUNCTION__+": erro ao inicializar trailing stop");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }
   trailing.Step(Trailing_ParabolicSAR_Step);
   trailing.Maximum(Trailing_ParabolicSAR_Maximum);

   // Cria e configura o gerenciamento de risco
   CMoneyFixedLot *money = new CMoneyFixedLot;
   if(money == NULL)
   {
      printf(__FUNCTION__+": erro ao criar gerenciamento de risco");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }
   if(!ExtExpert.InitMoney(money))
   {
      printf(__FUNCTION__+": erro ao inicializar gerenciamento de risco");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }
   money.Percent(Money_FixLot_Percent);
   money.Lots(Money_FixLot_Lots);

   // Valida parâmetros e inicializa indicadores
   if(!ExtExpert.ValidationSettings() || !ExtExpert.InitIndicators())
   {
      printf(__FUNCTION__+": erro ao validar configurações ou inicializar indicadores");
      ExtExpert.Deinit();
      return(INIT_FAILED);
   }

   // Inicialização bem-sucedida
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Função de finalização do robô                                    |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ExtExpert.Deinit();  // Libera recursos do Expert
}

//+------------------------------------------------------------------+
//| Função de manipulação de ticks                                   |
//+------------------------------------------------------------------+
void OnTick()
{
   ExtExpert.OnTick();  // Processa eventos de tick
}

//+------------------------------------------------------------------+
//| Função de manipulação de negociações                             |
//+------------------------------------------------------------------+
void OnTrade()
{
   ExtExpert.OnTrade();  // Processa eventos de negociação
}

//+------------------------------------------------------------------+
//| Função de manipulação de eventos de timer                        |
//+------------------------------------------------------------------+
void OnTimer()
{
   ExtExpert.OnTimer();  // Processa eventos de timer
}
//+------------------------------------------------------------------+
