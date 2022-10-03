input string   em3    ="----------- Vectors Settings -------------";  // ---
input int      countNumbersAfterPoint = 8; // Count Numbers After Point in Vectors
input int      maVectorCount = 3; //Moving Avarege for vector OHLC

input string   em4    ="----------- Save Settings -------------";  // ---

   
input bool     dealTypeInvert           =false; // invers type of deal
input bool     isSave           =true; // Save Data In File
input bool     isSaveOverwrite  =true; // Overwrite when save
input string   fileName         ="EURUSD_M5_MACD";
input int      countCandlesForSaveM1 = 100; // Bars M1
input int      countCandlesForSaveM5 = 124; // Bars M5
input int      countCandlesForSaveM15 = 58; // Bars M15
input int      countCandlesForSaveM30 = 58; // Bars M30
input int      countCandlesForSaveH1 = 24; // Bars H1
input int      countCandlesForSaveH4 = 15; // Bars H4
input int      countCandlesForSaveD1 = 5; // Bars D1
//input int      countCandlesForSaveW1 = 3; // Bars W1
//input int      countCandlesForSaveMN1 = 2; // Bars MN1

int            handleMacdM1  = INVALID_HANDLE;
int            handleMacdM5  = INVALID_HANDLE;
int            handleMacdM15 = INVALID_HANDLE;
int            handleMacdM30 = INVALID_HANDLE;
int            handleMacdH1  = INVALID_HANDLE;
int            handleMacdH4  = INVALID_HANDLE;
int            handleMacdD1  = INVALID_HANDLE;
int            handleMacdW1  = INVALID_HANDLE;
int            handleMacdMN1 = INVALID_HANDLE;

int            handleMaM1  = INVALID_HANDLE;
int            handleMaM5  = INVALID_HANDLE;
int            handleMaM15 = INVALID_HANDLE;
int            handleMaM30 = INVALID_HANDLE;
int            handleMaH1  = INVALID_HANDLE;
int            handleMaH4  = INVALID_HANDLE;
int            handleMaD1  = INVALID_HANDLE;
int            handleMaW1  = INVALID_HANDLE;
int            handleMaMN1 = INVALID_HANDLE;

double         bufferMacdBarsTMP[];
double         bufferMacdSignalTMP[];
double         bufferMaSignalTMP[];

int tmpHandleMA = INVALID_HANDLE;

int magicCounterTMP[];

void initIndicatorsForVectors(){
   if(isSave){
      if(handleMacdM1==INVALID_HANDLE){
         handleMacdM1=iMACD(NULL,PERIOD_M1,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaM1=iMA(NULL,PERIOD_M1,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdM5==INVALID_HANDLE){
         handleMacdM5=iMACD(NULL,PERIOD_M5,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaM5=iMA(NULL,PERIOD_M5,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdM15==INVALID_HANDLE){
         handleMacdM15=iMACD(NULL,PERIOD_M15,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaM15=iMA(NULL,PERIOD_M15,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdM30==INVALID_HANDLE){
         handleMacdM30=iMACD(NULL,PERIOD_M30,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaM30=iMA(NULL,PERIOD_M30,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdH1==INVALID_HANDLE){
         handleMacdH1=iMACD(NULL,PERIOD_H1,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaH1=iMA(NULL,PERIOD_H1,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdH4==INVALID_HANDLE){
         handleMacdH4=iMACD(NULL,PERIOD_H4,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaH4=iMA(NULL,PERIOD_H4,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdD1==INVALID_HANDLE){
         handleMacdD1=iMACD(NULL,PERIOD_D1,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaD1=iMA(NULL,PERIOD_D1,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      /* net dannih na graficke
      if(handleMacdW1==INVALID_HANDLE){
         handleMacdW1=iMACD(NULL,PERIOD_W1,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaW1=iMA(NULL,PERIOD_W1,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }
      if(handleMacdMN1==INVALID_HANDLE){
         handleMacdMN1=iMACD(NULL,PERIOD_MN1,fastEma,slowEma,macdSma,PRICE_CLOSE);
         handleMaMN1=iMA(NULL,PERIOD_MN1,maVectorCount,0,MODE_SMA,PRICE_CLOSE);
      }*/
   }
}

// privedet massiv k vektoram
string buildVectorsFromData(double &inputArray[]){
   
      int countInArray = ArraySize(inputArray);
      double returnArray[]; ArrayResize(returnArray,countInArray); 
   
   // ne ponytno - peredat velichinu otklonenia ot proshlogo ili ot srednego po viborke ili smeshat eto vmeste
   // srednee po viborke dly stochasticheskih indicatorov
      double maximum = inputArray[ArrayMaximum(inputArray)]; // 1 in result
      double minimum = inputArray[ArrayMinimum(inputArray)]; // -1 in result
      double difference = (maximum-MathAbs(minimum))/2; // 0 in result
      double size100percent = maximum-difference; 
      
      for(int i=0; i<countInArray; i++){
         returnArray[i] = NormalizeDouble((inputArray[i]-difference)/size100percent,countNumbersAfterPoint);
      }
      
   return arrayToString(returnArray);
}


string get_OHLC_MACD_MA(ENUM_TIMEFRAMES period, datetime timeIn, int countBars){
   
   int tmpHandle = INVALID_HANDLE;
   int tmpHandleMA = INVALID_HANDLE;
   switch(period){
      case PERIOD_M1:
         tmpHandle = handleMacdM1;
         tmpHandleMA = handleMaM1;
         break;
      case PERIOD_M5:
         tmpHandle = handleMacdM5;
         tmpHandleMA = handleMaM5;
         break;
      case PERIOD_M15:
         tmpHandle = handleMacdM15;
         tmpHandleMA = handleMaM15;
         break;
      case PERIOD_M30:
         tmpHandle = handleMacdM30;
         tmpHandleMA = handleMaM30;
         break;
      case PERIOD_H1:
         tmpHandle = handleMacdH1;
         tmpHandleMA = handleMaH1;
         break;
      case PERIOD_H4:
         tmpHandle = handleMacdH4;
         tmpHandleMA = handleMaH4;
         break;
      case PERIOD_D1:
         tmpHandle = handleMacdD1;
         tmpHandleMA = handleMaD1;
         break;
      case PERIOD_W1:
         tmpHandle = handleMacdW1;
         tmpHandleMA = handleMaW1;
         break;
      case PERIOD_MN1:
         tmpHandle = handleMacdMN1;
         tmpHandleMA = handleMaMN1;
         break;
      default:
         printf("Cant find period");
         return "";
         break;
   }
   
   int startBar = iBarShift(NULL,period,timeIn, true);
   
   //printf("===========>"+CopyBuffer(tmpHandle,0,timeIn,countBars,bufferMacdBarsTMP));
   if(CopyBuffer(tmpHandle,0,timeIn,countBars,bufferMacdBarsTMP)!=countBars){
      printf(" PERIOD_W1="+PERIOD_W1+" PERIOD_MN1="+PERIOD_MN1+" PERIOD_D1="+PERIOD_D1+" PERIOD_H4="+PERIOD_H4);
      printf("timeIn="+timeIn+" countBars="+countBars+" period="+period);
      printf("Error saving of data 0 - !=countBars. Error = "+GetLastError());
   }
   
   if(CopyBuffer(tmpHandle,1,timeIn,countBars,bufferMacdSignalTMP)!=countBars){
      printf(" PERIOD_W1="+PERIOD_W1+" PERIOD_MN1="+PERIOD_MN1+" PERIOD_D1="+PERIOD_D1+" PERIOD_H4="+PERIOD_H4);
      printf("timeIn="+timeIn+" countBars="+countBars+" period="+period);
      printf("Error saving of data 1 - !=countBars. Error = "+GetLastError());
      return "";
   }
   
   double tmpMACD[]; ArrayResize(tmpMACD, countBars*2);
   ArrayCopy(tmpMACD,bufferMacdBarsTMP);
   ArrayCopy(tmpMACD,bufferMacdSignalTMP,countBars);
   
   
   double tmpOHLC[]; ArrayResize(tmpOHLC, countBars*4);
   double tmpArrayO[]; ArrayResize(tmpArrayO, countBars);
   double tmpArrayH[]; ArrayResize(tmpArrayH, countBars);
   double tmpArrayC[]; ArrayResize(tmpArrayC, countBars);
   double tmpArrayL[]; ArrayResize(tmpArrayL, countBars);
   
   if(CopyBuffer(tmpHandleMA,0,timeIn,countBars,bufferMaSignalTMP)!=countBars){
      printf("timeIn="+timeIn+" countBars="+countBars+" period="+period);
      printf("Error saving of data MA 0 - !=countBars. Error = "+GetLastError());
      return "";
   }
   
   CopyClose(NULL,period,timeIn,countBars, tmpArrayC);
   for(int i=0; i<countBars; i++){
      tmpArrayC[i] = tmpArrayC[i]-bufferMaSignalTMP[i]; // otklonenie ot MA
   }
   ArrayCopy(tmpOHLC,tmpArrayC);
   
   CopyOpen(NULL,period,timeIn,countBars, tmpArrayO);
   for(int i=0; i<countBars; i++){
      tmpArrayO[i] = tmpArrayO[i]-bufferMaSignalTMP[i]; // otklonenie ot MA
   }
   ArrayCopy(tmpOHLC,tmpArrayO,countBars);
   
   CopyHigh(NULL,period,timeIn,countBars, tmpArrayH);
   for(int i=0; i<countBars; i++){
      tmpArrayH[i] = tmpArrayH[i]-bufferMaSignalTMP[i]; // otklonenie ot MA
   }
   ArrayCopy(tmpOHLC,tmpArrayH,countBars);
   
   CopyLow(NULL,period,timeIn,countBars, tmpArrayL);
   for(int i=0; i<countBars; i++){
      tmpArrayL[i] = tmpArrayL[i]-bufferMaSignalTMP[i]; // otklonenie ot MA
   }
   ArrayCopy(tmpOHLC,tmpArrayL,countBars);
   
   return buildVectorsFromData(tmpMACD)+","+buildVectorsFromData(tmpOHLC);
}


void saveDataToFile(){
         // Check all results of positions and save in file
      if (isSave && MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_OPTIMIZATION)) { 
      
         printf("*** TESTER DEINIT - SAVE VECTOR START ***");
         
         int fileHandlerData, fileHandlerResult;
         
         string fileNameData = fileName+"_data.txt";
         string fileNameResult = fileName+"_result.txt";
         
         if(FileIsExist(fileNameData, FILE_COMMON)){  FileDelete(fileNameData, FILE_COMMON); }
         if(FileIsExist(fileNameResult, FILE_COMMON)){  FileDelete(fileNameResult, FILE_COMMON); }
         
         if((fileHandlerData = FileOpen(
            fileNameData,  // имя файла
            FILE_WRITE|FILE_TXT|FILE_COMMON,          // комбинация флагов
            ',',         // разделитель
            CP_UTF8      // кодовая страница
            ))==INVALID_HANDLE){
                  printf("INVALID_HANDLE fileHandlerData="+fileHandlerData);
            }                
         
         if((fileHandlerResult = FileOpen(
               fileNameResult,  // имя файла
               FILE_WRITE|FILE_TXT|FILE_COMMON,          // комбинация флагов
               ',',         // разделитель
               CP_UTF8      // кодовая страница
               ))==INVALID_HANDLE
             ){
                  printf("INVALID_HANDLE fileHandlerResult="+fileHandlerResult);
            }
         
         HistorySelect(0,TimeCurrent());
   
         uint totalDeals = HistoryDealsTotal();
         
         ulong    ticketTmp=0;
         ulong    ticketIn=0;
         ulong    ticketOut=0;
         
         int   dealTypeIn;
         int   dealTypeOut;
         
         double   priceIn;
         datetime timeIn;
         string   symbolIn;
         long     typeIn;
         long     entryIn;
         
         double   priceOut;
         double   profitOut;
         datetime timeOut;
         long     typeOut;
         long     entryOut;
         
         long positionId;
         
         int printTotal = 0;
         
         printf("totalDeals="+totalDeals);
         
         ArrayResize(magicCounterTMP, totalDeals*2);
         ArrayFill(magicCounterTMP,0,totalDeals*2,0);
         
         for(uint i=0;i<totalDeals;i++){
            //--- try to get deals ticket
            if((ticketTmp = HistoryDealGetTicket(i))>0){
               positionId = HistoryDealGetInteger(ticketTmp,DEAL_POSITION_ID);
               int magicTMP;
               magicTMP = HistoryDealGetInteger(ticketTmp,DEAL_POSITION_ID);
               
               if(magicCounterTMP[magicTMP]==0){
                  magicCounterTMP[magicTMP] = 1;
               }else{
                  // position already added
                  continue;
               }
               
               // printf("ticketTmp="+ticketTmp+" price="+price+" positionId="+positionId);
               
               if(HistorySelectByPosition(positionId)){
                  if((ticketIn = HistoryDealGetTicket(0))>0){
                     dealTypeIn = HistoryDealGetInteger(ticketIn,DEAL_TYPE);
                     priceIn =HistoryDealGetDouble(ticketIn,DEAL_PRICE);
                     timeIn  =(datetime)HistoryDealGetInteger(ticketIn,DEAL_TIME);
                     symbolIn=HistoryDealGetString(ticketIn,DEAL_SYMBOL);
                     typeIn  =HistoryDealGetInteger(ticketIn,DEAL_TYPE);
                     entryIn =HistoryDealGetInteger(ticketIn,DEAL_ENTRY);
                  }
                  if((ticketOut = HistoryDealGetTicket(3))>0){
                     priceOut =HistoryDealGetDouble(ticketOut,DEAL_PRICE);
                     timeOut  =(datetime)HistoryDealGetInteger(ticketOut,DEAL_TIME);
                     typeOut  =HistoryDealGetInteger(ticketOut,DEAL_TYPE);
                     entryOut =HistoryDealGetInteger(ticketOut,DEAL_ENTRY);
                     profitOut =HistoryDealGetDouble(ticketOut,DEAL_PROFIT);
                  }
                  
                  if(priceIn && timeIn && symbolIn==Symbol()){
                     //--- create price object
                     //string dealType = "BUY";
                     //if(dealTypeIn==1){
                     //   dealType = "SELL";
                     //}
                    // printf("TradeHistory_Deal_"+string(ticketIn)+" time="+timeIn+" "+dealType+" priceIn="+price+"
                    // priceOut="+priceOut+" symbol="+symbol+" entry="+entry+" entryOut="+entryOut+" profit="+profitOut);
                     printTotal++;
                     
                     int result = profitOut>0 ? 2 : (profitOut<0 ? 1 : 0);
                     FileWrite(fileHandlerResult, 
                        dealTypeIn+""+ result);
                     
                     
                     FileWrite(fileHandlerData,
                        get_OHLC_MACD_MA(PERIOD_M1, timeIn,countCandlesForSaveM1),
                        get_OHLC_MACD_MA(PERIOD_M5, timeIn,countCandlesForSaveM5),
                        get_OHLC_MACD_MA(PERIOD_M15, timeIn,countCandlesForSaveM15),
                        get_OHLC_MACD_MA(PERIOD_M30, timeIn,countCandlesForSaveM30),
                        get_OHLC_MACD_MA(PERIOD_H1, timeIn,countCandlesForSaveH1),
                        get_OHLC_MACD_MA(PERIOD_H4, timeIn,countCandlesForSaveH4),
                        get_OHLC_MACD_MA(PERIOD_D1, timeIn,countCandlesForSaveD1)
                       // get_OHLC_MACD_MA(PERIOD_W1, timeIn,countCandlesForSaveW1),
                       // get_OHLC_MACD_MA(PERIOD_MN1, timeIn,countCandlesForSaveMN1)
                     );
                          
                  }
               }else{
                  printf("NO POSITION NUMBER");
               }
               
            
            }
            // update back list
            HistorySelect(0,TimeCurrent());
            
         }
         // printf("Total trades "+printTotal);
         
         FileClose(fileHandlerResult);
         FileClose(fileHandlerData);
      }
}

string arrayToString(double &array[]){
   int arraySize = ArraySize(array);
   string returnString = "";
   bool firstElement = true;
   for(int i=0; i<arraySize; i++){
      returnString += firstElement==true ? array[i] : ","+array[i];
      if(firstElement) firstElement=false;
   }
   return returnString;
}