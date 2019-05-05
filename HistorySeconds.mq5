//+------------------------------------------------------------------+
//|                                               HistorySeconds.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"

string fileDate = "";
int fileHandle = INVALID_HANDLE;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    //--- create timer
    EventSetTimer(1);
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    //--- destroy timer
    EventKillTimer();
    
    FileClose(fileHandle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
    // display datetime on chart window
    string date_time = TimeToString(TimeLocal(), TIME_DATE | TIME_MINUTES | TIME_SECONDS);
    StringReplace(date_time, ".", "/");
    Comment(date_time);
    
    string ask = DoubleToString(SymbolInfoDouble(Symbol(),SYMBOL_ASK), _Digits);
    string bid = DoubleToString(SymbolInfoDouble(Symbol(),SYMBOL_BID), _Digits);
    
    // create filehandle
    string date = TimeToString(TimeLocal(), TIME_DATE);
    StringReplace(date, ".", "");
    string new_file_date = date;
    
    if (fileDate != new_file_date) {
        // close file
        if (fileHandle != INVALID_HANDLE) {
            FileClose(fileHandle);
        }
    
        fileDate = new_file_date;
        
        string broker_name = AccountInfoString(ACCOUNT_COMPANY);
        string file_name = broker_name + "_" + fileDate + "_" + Symbol() + ".csv";
        fileHandle = FileOpen(file_name, FILE_WRITE | FILE_CSV, ",");
    }
    
    FileWrite(fileHandle, date_time, ask, bid);
}
