//+------------------------------------------------------------------+
//|                                                    Dataset-1.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, United Ideas Solutions Inc."
#property link      "https://www.okhmat-robotics.com"
#property version   "1.00"

#define noSignal 0
#define buySignal 1
#define sellSignal 2


#include "signal.mqh"
#include "deals.mqh"
#include "vectorLib.mqh"

void OnInit(){
   initIndicatorsForVectors();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
      saveDataToFile();
}
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick(){
   // only every open of candle
   if(iVolume(Symbol(),0,0)==1){
         int signal = IndicatorSignal();
         if(signal==buySignal){
            if(!dealTypeInvert){
               trade(buySignal);
            }else{
               trade(sellSignal); // check other
            }
         }
         if(signal==sellSignal){
            if(!dealTypeInvert){
               trade(sellSignal);
            }else{
               trade(buySignal); // check other
            }
         }
     }
}
