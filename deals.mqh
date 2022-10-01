
input int MagicNumber          =12345;

input string   em2    ="----------- Trade Settings -------------"; // ---

input double   InpLots          =0.1; // Lots
input int      InpTakeProfit    =50;  // Take Profit (in pips)
input int      InpStopLoss      =15;  // Stop Loss (in pips)
// input int      InpTrailingStop  =30;  // Not work - Trailing Stop Level (in pips)

int magicCounter = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trade(int OrderType = 1){
   //--- подготовим запрос
   MqlTradeRequest req={};
   MqlTradeResult  res={};
   req.action      =TRADE_ACTION_DEAL;
   req.symbol      =_Symbol;
   req.magic       =MagicNumber;
   req.volume      =InpLots;
   req.deviation   =10;
   
   switch(OrderType){
      case 1:
         printf("Try buy 2");
         req.type        =ORDER_TYPE_BUY;
         req.price       =SymbolInfoDouble(req.symbol,SYMBOL_ASK);
         req.tp       =SymbolInfoDouble(req.symbol,SYMBOL_ASK)+InpTakeProfit*0.0001;
         req.sl       =SymbolInfoDouble(req.symbol,SYMBOL_ASK)-InpStopLoss*0.0001;
         req.comment     ="Buy using OrderSendAsync()";
         magicCounter++;
         req.magic = magicCounter;
         break;
      case 2:
         printf("Try sell 2");
         req.type        =ORDER_TYPE_SELL;
         req.price       =SymbolInfoDouble(req.symbol,SYMBOL_BID);
         req.tp       =SymbolInfoDouble(req.symbol,SYMBOL_ASK)-InpTakeProfit*0.0001;
         req.sl       =SymbolInfoDouble(req.symbol,SYMBOL_ASK)+InpStopLoss*0.0001;
         req.comment     ="Sell using OrderSendAsync()";
         magicCounter++;
         req.magic = magicCounter;
         break;
     }
     
   if(!OrderSendAsync(req,res)){
      Print(__FUNCTION__,": ошибка ",GetLastError(),", retcode = ",res.retcode); 
   }
}