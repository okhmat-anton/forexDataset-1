
//--- input parameters
input string   em1    ="----------- MACD Settings -------------";  // ---
input int      fastEma=15;
input int      slowEma=34;
input int      macdSma=9;

int            handleMacd = INVALID_HANDLE;

double         bufferMacdBars[];
double         bufferMacsSignal[];


int IndicatorSignal(){
   double macdBar0, macdBar1, macdBar2;
   double macdSignal0, macdSignal1, macdSignal2;
   
   if(handleMacd==INVALID_HANDLE){
      printf("INVALID_HANDLE is "+handleMacd+"="+INVALID_HANDLE);
      // create indicator before start
      printf("TRY create MACD handle");
      handleMacd=iMACD(NULL,0,fastEma,slowEma,macdSma,PRICE_CLOSE);
      if(handleMacd==NULL){
         printf("Error creating MACD indicator");
      }else{
         printf("MACD handle created");
      }
   }
   
   // check count calculated bars
   /*if(BarsCalculated(handleMacd)<20){
      printf("ERROR No bars calculated, handleMacd="+handleMacd);
      return noSignal;
   }*/
   
   if(CopyBuffer(handleMacd,0,0,3,bufferMacdBars)!=3 || CopyBuffer(handleMacd,1,0,3,bufferMacsSignal)!=3){
      printf("ERROR Cant copy data to buffer, handleMacd="+handleMacd);
      return noSignal;
   }
   
   macdBar0 = bufferMacdBars[0];
   macdBar1 = bufferMacdBars[1];
   macdBar2 = bufferMacdBars[2];
      
   macdSignal0 = bufferMacsSignal[0];
   macdSignal1 = bufferMacsSignal[1];
   macdSignal2 = bufferMacsSignal[2];    
   
   // printf("BUY "+macdBar0+">"+macdSignal0+" && "+macdBar1+">"+macdSignal1+" && "+macdBar2+"<"+macdSignal2);  
   // printf("SELL "+macdBar0+"<"+macdSignal0+" && "+macdBar1+"<"+macdSignal1+" && "+macdBar2+">"+macdSignal2);     
   
   if(macdBar0>macdSignal0 && macdBar1>macdSignal1 && macdBar2<macdSignal2){
      return buySignal;
   }
   if(macdBar0<macdSignal0 && macdBar1<macdSignal1 && macdBar2>macdSignal2){
      return sellSignal;
   }
   
   return 0;
}