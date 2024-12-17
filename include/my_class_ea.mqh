//+------------------------------------------------------------------+
//|                                              my_expert_class.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//| CLASS DECLARATION                                                |
//+------------------------------------------------------------------+
class MyExpert
  {
   //--- private members
private:
   int               Magic_No;   //Expert Magic Number
   double            LOTS;       //Lots or volume to Trade
   double            ADX_min;    //ADX Minimum value
   int               ADX_handle; //ADX Handle
   int               MA_handle;  //Moving Average Handle
   double            plus_DI[];  //array to hold ADX +DI values for each bars
   double            minus_DI[]; //array to hold ADX -DI values for each bars
   double            MA_val[];   //array to hold Moving Average values for each bars
   double            ADX_val[];  //array to hold ADX values for each bars
   double            Closeprice; //variable to hold the previous bar closed price 
   MqlTradeRequest   trequest;   //MQL5 trade request structure to be used for sending our trade requests
   MqlTradeResult    tresult;    //MQL5 trade result structure to be used to get our trade results
   string            symbol;     //variable to hold the current symbol name
   ENUM_TIMEFRAMES   period;     //variable to hold the current timeframe value
   string            Errormsg;   //variable to hold our error messages
   int               Errcode;    //variable to hold our error codes
   //--- Public member/functions
public:
   void              MyExpert();                                  //Class Constructor
   void              setSymbol(string syb){symbol = syb;}         //function to set current symbol
   void              setPeriod(ENUM_TIMEFRAMES prd){period = prd;}//function to set current symbol timeframe/period
   void              setCloseprice(double prc){Closeprice=prc;}   //function to set prev bar closed price
   void              setLOTS(double lot){LOTS=lot;}               //function to set The Lot size to trade
   void              setMagic(int magic){Magic_No=magic;}         //function to set Expert Magic number
   void              setadxmin(double adx){ADX_min=adx;}          //function to set ADX Minimum values
   void              doInit(int adx_period,int ma_period);        //function to be used at our EA intialization
   void              doUninit();                                  //function to be used at EA de-initialization
   bool              checkBuy();                                  //function to check for Buy conditions
   bool              checkSell();                                 //function to check for Sell conditions
   void              openBuy(ENUM_ORDER_TYPE otype,double askprice,double SL,
                             double TP,int dev,string comment=""); //function to open Buy positions
   void              openSell(ENUM_ORDER_TYPE otype,double bidprice,double SL,
                              double TP,int dev,string comment=""); //function to open Sell positions

   //--- Protected members
protected:
   void              showError(string msg, int ercode);           //function for use to display error messages
   void              getBuffers();                                //function for getting Indicator buffers
  };   // end of class declaration




//+------------------------------------------------------------------+
//| Definition of our Class/member functions                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  This CLASS CONSTRUCTOR                                          |
//|  *Does not have any input parameters                             |
//|  *Initilizes all the necessary variables                         |                 
//+------------------------------------------------------------------+
void MyExpert::MyExpert()
  {
//---initialize all necessary variables
   ZeroMemory(trequest);
   ZeroMemory(tresult);
   ZeroMemory(ADX_val);
   ZeroMemory(MA_val);
   ZeroMemory(plus_DI);
   ZeroMemory(minus_DI);
   Errormsg="";
   Errcode=0;
  }
  
//+------------------------------------------------------------------+
//|  SHOWERROR FUNCTION                                              |
//|  *Input Parameters - Error Message, Error Code                   |
//+------------------------------------------------------------------+
void MyExpert::showError(string msg,int ercode)
  {
   Alert(msg,"-error:",ercode,"!!"); // display error
  }
  
//+------------------------------------------------------------------+
//|  GETBUFFERS FUNCTION                                             |                   
//|  *No input parameters                                            |
//|  *Uses the class data members to get indicator's buffers         |
//+------------------------------------------------------------------+
void MyExpert::getBuffers()
  {
   if(CopyBuffer(ADX_handle,0,0,3,ADX_val)<0 || CopyBuffer(ADX_handle,1,0,3,plus_DI)<0
      || CopyBuffer(ADX_handle,2,0,3,minus_DI)<0 || CopyBuffer(MA_handle,0,0,3,MA_val)<0)
     {
      Errormsg="Error copying indicator Buffers";
      Errcode = GetLastError();
      showError(Errormsg,Errcode);
     }
  }
  
///+-----------------------------------------------------------------------+
//| OUR PUBLIC FUNCTIONS                                                  |
//+-----------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| DOINIT FUNCTION                                                  |
//| *Takes the ADX indicator's Period and Moving Average indicator's |
//| period as input parameters                                       |
//| *To be used in the OnInit() function of our EA                   |                                            
//+------------------------------------------------------------------+
void MyExpert::doInit(int adx_period,int ma_period)
  {
//--- get handle for ADX indicator
   ADX_handle=iADX(symbol,period,adx_period);
//--- get the handle for Moving Average indicator
   MA_handle=iMA(symbol,period,ma_period,0,MODE_EMA,PRICE_CLOSE);
//--- what if handle returns Invalid Handle
   if(ADX_handle<0 || MA_handle<0)
     {
      Errormsg="Error Creating Handles for indicators";
      Errcode=GetLastError();
      showError(Errormsg,Errcode);
     }
//--- set Arrays as series
//--- the ADX values arrays
   ArraySetAsSeries(ADX_val,true);
//--- the +DI value arrays
   ArraySetAsSeries(plus_DI,true);
//--- the -DI value arrays
   ArraySetAsSeries(minus_DI,true);
//--- the MA values arrays
   ArraySetAsSeries(MA_val,true);
  }
  
//+------------------------------------------------------------------+
//|  DOUNINIT FUNCTION                                               |
//|  *No input parameters                                            |
//|  *Used to release ADX and MA indicators handles                  |
//+------------------------------------------------------------------+
void MyExpert::doUninit()
  {
//--- release our indicator handles
   IndicatorRelease(ADX_handle);
   IndicatorRelease(MA_handle);
  }


//+------------------------------------------------------------------+
//| CHECKBUY FUNCTION                                                |
//| *No input parameters                                             |
//| *Uses the class data members to check for Buy setup              |
//| based on the defined trade strategy                              |
//| *Returns TRUE if Buy conditions are met or FALSE if not met      |
//+------------------------------------------------------------------+
bool MyExpert::checkBuy()
  {
/*
    Check for a Long/Buy Setup : MA increasing upwards, 
    previous price close above MA, ADX > ADX min, +DI > -DI
*/
   getBuffers();
//--- declare bool type variables to hold our Buy Conditions
   bool Buy_Condition_1=(MA_val[0]>MA_val[1]) && (MA_val[1]>MA_val[2]); // MA Increasing upwards
   
   bool Buy_Condition_2=(Closeprice>MA_val[1]);                         // previous price closed above MA
   
   bool Buy_Condition_3=(ADX_val[0]>ADX_min);                           // Current ADX value greater than minimum ADX value
   
   bool Buy_Condition_4=(plus_DI[0]>minus_DI[0]);                       // +DI greater than -DI
//--- Putting all together   
   if(Buy_Condition_1 && Buy_Condition_2 && Buy_Condition_3 && Buy_Condition_4)
     {
      return(true);
     }
   else
     {
      return(false);
     }
  }
  
//+------------------------------------------------------------------+
//| CHECKSELL FUNCTION                                               |
//| *No input parameters                                             |
//| *Uses the class data members to check for Sell setup             |
//|  based on the defined trade strategy                             |
//| *Returns TRUE if Sell conditions are met or FALSE if not met     |
//+------------------------------------------------------------------+
bool MyExpert::checkSell()
  {
/*
    Check for a Short/Sell Setup : MA decreasing downwards, 
    previous price close below MA, ADX > ADX min, -DI > +DI
*/
   getBuffers();
//--- declare bool type variables to hold our Sell Conditions
   bool Sell_Condition_1=(MA_val[0]<MA_val[1]) && (MA_val[1]<MA_val[2]);  // MA decreasing downwards
   bool Sell_Condition_2=(Closeprice < MA_val[1]);                         // Previous price closed below MA
   bool Sell_Condition_3=(ADX_val[0]>ADX_min);                            // Current ADX value greater than minimum ADX
   bool Sell_Condition_4=(plus_DI[0]<minus_DI[0]);                        // -DI greater than +DI

//--- putting all together
   if(Sell_Condition_1 && Sell_Condition_2 && Sell_Condition_3 && Sell_Condition_4)
     {
      return(true);
     }
   else
     {
      return(false);
     }
  }
  
//+------------------------------------------------------------------+
//| OPENBUY FUNCTION                                                 |
//| *Has Input parameters - order type, Current ASK price,           |
//|  Stop Loss, Take Profit, deviation, comment                      |
//| *Checks account free margin before pacing trade if trader chooses|
//| *Alerts of a success if position is opened or shows error        |
//+------------------------------------------------------------------+

void MyExpert::openBuy(ENUM_ORDER_TYPE otype,double askprice,double SL,double TP,int dev,string comment="")
  {
           
      trequest.action=TRADE_ACTION_DEAL;
      trequest.type=otype;
      trequest.volume=LOTS;
      trequest.price=askprice;
      trequest.sl=SL;
      trequest.tp=TP;
      trequest.deviation=dev;
      trequest.magic=Magic_No;
      trequest.symbol=symbol;
      trequest.type_filling=ORDER_FILLING_FOK;
      //--- send
      OrderSend(trequest,tresult);
      //--- check result
      if(tresult.retcode==10009 || tresult.retcode==10008) //Request successfully completed 
        {
         Alert("A Buy order has been successfully placed with Ticket#:",tresult.order,"!!");
        }
      else
        {
         Errormsg= "The Buy order request could not be completed";
         Errcode =GetLastError();
         showError(Errormsg,Errcode);
        }
     
  }

//+------------------------------------------------------------------+
//| OPENSELL FUNCTION                                                |
//| *Has Input parameters - order type, Current BID price, Stop Loss,|
//|  Take Profit, deviation, comment                                 |
//| *Checks account free margin before pacing trade if trader chooses|
//| *Alerts of a success if position is opened or shows error        |
//+------------------------------------------------------------------+
void MyExpert::openSell(ENUM_ORDER_TYPE otype,double bidprice,double SL,double TP,int dev,string comment="")
  {
//--- do check Margin if enabled

      trequest.action=TRADE_ACTION_DEAL;
      trequest.type=otype;
      trequest.volume=LOTS;
      trequest.price=bidprice;
      trequest.sl=SL;
      trequest.tp=TP;
      trequest.deviation=dev;
      trequest.magic=Magic_No;
      trequest.symbol=symbol;
      trequest.type_filling=ORDER_FILLING_FOK;
      //--- send
      OrderSend(trequest,tresult);
      //--- check result
      if(tresult.retcode==10009 || tresult.retcode==10008) //Request successfully completed 
        {
         Alert("A Sell order has been successfully placed with Ticket#:",tresult.order,"!!");
        }
      else
        {
         Errormsg= "The Sell order request could not be completed";
         Errcode =GetLastError();
         showError(Errormsg,Errcode);
        }
     
  }
//+----------------------------------------------------------------+