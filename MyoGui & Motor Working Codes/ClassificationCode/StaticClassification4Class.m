clear all;
close all;
clc;


        dataUK =xlsread('Flexion21.xlsx','A1:N14013'); %%Flexion!
        
        dataEX =xlsread('Extension21.xlsx','A1:N16033'); %%Extension!
    
        dataRX =xlsread('Relax21.xlsx','A1:N14029'); %%Relax!

        dataFS =xlsread('Fist21.xlsx','A1:N14017'); %%Relax!


        isMarkedColumnUK=dataUK(:,14); % Son sütun yani 0 1 ler alýndý.
        MarkedIndexesUK=find(isMarkedColumnUK==1); % 1 olan indexler bulundu

        isMarkedColumnEX=dataEX(:,14); % Son sütun yani 0 1 ler alýndý.
        MarkedIndexesEX=find(isMarkedColumnEX==1); % 1 olan indexler bulundu

        isMarkedColumnRX=dataRX(:,14); % Son sütun yani 0 1 ler alýndý.
        MarkedIndexesRX=find(isMarkedColumnRX==1); % 1 olan indexler bulundu

        isMarkedColumnFS=dataFS(:,14); % Son sütun yani 0 1 ler alýndý.
        MarkedIndexesFS=find(isMarkedColumnFS==1); % 1 olan indexler bulundu



        datalengthUK=MarkedIndexesUK(2)-MarkedIndexesUK(1)+1; %Her hareket örneði için data sayýsý farklý. Max bulmaya çalýþacaðýz. Þuan sadece ilk hareket örneðinin uzunluðunu bulduk.
        for i=1:1:(length(MarkedIndexesUK)-1)    % Her hareket örneði için data uzunluklarýna baktýk. Maximum olaný bulup datalength deðiþkeni içine kaydettik.
            a = MarkedIndexesUK(i+1)-MarkedIndexesUK(i)+1;
            if a>datalengthUK
                datalengthUK = a;
            end
        end

        datalengthEX=MarkedIndexesEX(2)-MarkedIndexesEX(1)+1; %Her hareket örneði için data sayýsý farklý. Max bulmaya çalýþacaðýz. Þuan sadece ilk hareket örneðinin uzunluðunu bulduk.
        for i=1:1:(length(MarkedIndexesEX)-1)    % Her hareket örneði için data uzunluklarýna baktýk. Maximum olaný bulup datalength deðiþkeni içine kaydettik.
            a = MarkedIndexesEX(i+1)-MarkedIndexesEX(i)+1;
            if a>datalengthEX
                datalengthEX = a;
            end
        end

        datalengthRX=MarkedIndexesRX(2)-MarkedIndexesRX(1)+1; %Her hareket örneði için data sayýsý farklý. Max bulmaya çalýþacaðýz. Þuan sadece ilk hareket örneðinin uzunluðunu bulduk.
        for i=1:1:(length(MarkedIndexesRX)-1)    % Her hareket örneði için data uzunluklarýna baktýk. Maximum olaný bulup datalength deðiþkeni içine kaydettik.
            a = MarkedIndexesRX(i+1)-MarkedIndexesRX(i)+1;
            if a>datalengthRX
                datalengthRX = a;
            end
        end

        datalengthFS=MarkedIndexesFS(2)-MarkedIndexesFS(1)+1; %Her hareket örneði için data sayýsý farklý. Max bulmaya çalýþacaðýz. Þuan sadece ilk hareket örneðinin uzunluðunu bulduk.
        for i=1:1:(length(MarkedIndexesFS)-1)    % Her hareket örneði için data uzunluklarýna baktýk. Maximum olaný bulup datalength deðiþkeni içine kaydettik.
            a = MarkedIndexesFS(i+1)-MarkedIndexesFS(i)+1;
            if a>datalengthFS
                datalengthFS = a;
            end
        end

        EMGDataUK =  -99*ones(datalengthUK,8*(length(MarkedIndexesUK)-1)); % Her cycle için 8 emg sütunu tutan bir matris

        EMGDataEX =  -99*ones(datalengthEX,8*(length(MarkedIndexesEX)-1)); % Her cycle için 8 emg sütunu tutan bir matris

        EMGDataRX =  -99*ones(datalengthRX,8*(length(MarkedIndexesRX)-1)); % Her cycle için 8 emg sütunu tutan bir matris
        
        EMGDataFS =  -99*ones(datalengthFS,8*(length(MarkedIndexesFS)-1)); % Her cycle için 8 emg sütunu tutan bir matris
 


        for i=1:1:(length(MarkedIndexesUK)-1) % Yukarýdaki iki matrixin içini doldurduk. Artýk her hareket örneði için  8 sütun emg verisi  matrixte tutuldu.
            
            SingleMovementEMGUK = dataUK (MarkedIndexesUK(i):MarkedIndexesUK(i+1),2:9); %data matrisinin 8 emg sütunundan, markindexe göre veri çek    
            if(i==1)
            startEMGindexUK=i;
            end
            EMGDataUK(1:length(SingleMovementEMGUK),startEMGindexUK:startEMGindexUK+7) = SingleMovementEMGUK;
            startEMGindexUK=startEMGindexUK+8;
    
        end
        
        for i=1:1:(length(MarkedIndexesEX)-1) % Yukarýdaki iki matrixin içini doldurduk. Artýk her hareket örneði için  8 sütun emg verisi  matrixte tutuldu.
            
            SingleMovementEMGEX = dataEX (MarkedIndexesEX(i):MarkedIndexesEX(i+1),2:9); %data matrisinin 8 emg sütunundan, markindexe göre veri çek    
            if(i==1)
            startEMGindexEX=i;
            end
            EMGDataEX(1:length(SingleMovementEMGEX),startEMGindexEX:startEMGindexEX+7) = SingleMovementEMGEX;
            startEMGindexEX=startEMGindexEX+8;
    
        end

        for i=1:1:(length(MarkedIndexesRX)-1) % Yukarýdaki iki matrixin içini doldurduk. Artýk her hareket örneði için  8 sütun emg verisi  matrixte tutuldu.
            
            SingleMovementEMGRX = dataRX (MarkedIndexesRX(i):MarkedIndexesRX(i+1),2:9); %data matrisinin 8 emg sütunundan, markindexe göre veri çek    
            if(i==1)
            startEMGindexRX=i;
            end
            EMGDataRX(1:length(SingleMovementEMGRX),startEMGindexRX:startEMGindexRX+7) = SingleMovementEMGRX;
            startEMGindexRX=startEMGindexRX+8;
    
        end

        for i=1:1:(length(MarkedIndexesFS)-1) % Yukarýdaki iki matrixin içini doldurduk. Artýk her hareket örneði için  8 sütun emg verisi  matrixte tutuldu.
            
            SingleMovementEMGFS = dataFS (MarkedIndexesFS(i):MarkedIndexesFS(i+1),2:9); %data matrisinin 8 emg sütunundan, markindexe göre veri çek    
            if(i==1)
            startEMGindexFS=i;
            end
            EMGDataFS(1:length(SingleMovementEMGFS),startEMGindexFS:startEMGindexFS+7) = SingleMovementEMGFS;
            startEMGindexFS=startEMGindexFS+8;
    
        end


        [mUK,nUK] = size(EMGDataUK);  % Yine up ve down movement hareketlerini EMG verileri için yapacaðýz. Ýlk 8 EMG up movement, diðer 8 down movement olacak.

        oUK=1; %Tek sayýlar kol kaldýrma için, çiftler indirme için. Onu sayar
        jUK=1; %Up moves emg içinde döner.
        kUK=1; %Down moves emg içinde döner



        [mEX,nEX] = size(EMGDataEX);  % Yine up ve down movement hareketlerini EMG verileri için yapacaðýz. Ýlk 8 EMG up movement, diðer 8 down movement olacak.

        oEX=1; %Tek sayýlar kol kaldýrma için, çiftler indirme için. Onu sayar
        jEX=1; %Up moves emg içinde döner.
        kEX=1; %Down moves emg içinde döner



        [mRX,nRX] = size(EMGDataRX);  % Yine up ve down movement hareketlerini EMG verileri için yapacaðýz. Ýlk 8 EMG up movement, diðer 8 down movement olacak.

        oRX=1; %Tek sayýlar kol kaldýrma için, çiftler indirme için. Onu sayar
        jRX=1; %Up moves emg içinde döner.
        kRX=1; %Down moves emg içinde döner


        [mFS,nFS] = size(EMGDataFS);  % Yine up ve down movement hareketlerini EMG verileri için yapacaðýz. Ýlk 8 EMG up movement, diðer 8 down movement olacak.

        oFS=1; %Tek sayýlar kol kaldýrma için, çiftler indirme için. Onu sayar
        jFS=1; %Up moves emg içinde döner.
        kFS=1; %Down moves emg içinde döner

        for i=1:8:nUK  %n=8*alýnan örnek sayýsý! i deðiþkeni EMGData içinde döner
    
            if (rem(oUK,2)==1) % o tek sayý ise:   YANÝ KOL KALDIRMA HAREKETÝ ÝSE 
            UpMovesEMGUK(:,jUK:jUK+7) = EMGDataUK(:,i:i+7);
            jUK=jUK+8;
            else %o çift sayý ise: KOL ÝNDÝRME HAREKETÝ ÝSE
            DownMovesEMGUK(:,kUK:kUK+7) = EMGDataUK(:,i:i+7);
            kUK=kUK+8;
            end
            oUK=oUK+1;
    
        end

        for i=1:8:nEX  %n=8*alýnan örnek sayýsý! i deðiþkeni EMGData içinde döner
    
            if (rem(oEX,2)==1) % o tek sayý ise:   YANÝ KOL KALDIRMA HAREKETÝ ÝSE 
            UpMovesEMGEX(:,jEX:jEX+7) = EMGDataEX(:,i:i+7);
            jEX=jEX+8;
            else %o çift sayý ise: KOL ÝNDÝRME HAREKETÝ ÝSE
            DownMovesEMGEX(:,kEX:kEX+7) = EMGDataEX(:,i:i+7);
            kEX=kEX+8;
            end
            oEX=oEX+1;
    
        end

        for i=1:8:nRX  %n=8*alýnan örnek sayýsý! i deðiþkeni EMGData içinde döner
    
            if (rem(oRX,2)==1) % o tek sayý ise:   YANÝ KOL KALDIRMA HAREKETÝ ÝSE 
            UpMovesEMGRX(:,jRX:jRX+7) = EMGDataRX(:,i:i+7);
            jRX=jRX+8;
            else %o çift sayý ise: KOL ÝNDÝRME HAREKETÝ ÝSE
            DownMovesEMGRX(:,kRX:kRX+7) = EMGDataRX(:,i:i+7);
            kRX=kRX+8;
            end
            oRX=oRX+1;
    
        end


        for i=1:8:nFS  %n=8*alýnan örnek sayýsý! i deðiþkeni EMGData içinde döner
    
            if (rem(oFS,2)==1) % o tek sayý ise:   YANÝ KOL KALDIRMA HAREKETÝ ÝSE 
            UpMovesEMGFS(:,jFS:jFS+7) = EMGDataFS(:,i:i+7);
            jFS=jFS+8;
            else %o çift sayý ise: KOL ÝNDÝRME HAREKETÝ ÝSE
            DownMovesEMGFS(:,kFS:kFS+7) = EMGDataFS(:,i:i+7);
            kFS=kFS+8;
            end
            oFS=oFS+1;
    
        end

         
%TAKE ABSOLUTE OF EMG DATA

        UpMovesEMGUK=abs(UpMovesEMGUK);  %Artýk elimizde Up ve Down movements için ABSOLUTE EMG verileri var. Fakat her cycle için farklý datalength. Biri 200, biri 230, biri 300 bunu 100 yapacaz.
        DownMovesEMGUK=abs(DownMovesEMGUK);

        UpMovesEMGEX=abs(UpMovesEMGEX);  %Artýk elimizde Up ve Down movements için ABSOLUTE EMG verileri var. Fakat her cycle için farklý datalength. Biri 200, biri 230, biri 300 bunu 100 yapacaz.
        DownMovesEMGEX=abs(DownMovesEMGEX);

        UpMovesEMGRX=abs(UpMovesEMGRX);  %Artýk elimizde Up ve Down movements için ABSOLUTE EMG verileri var. Fakat her cycle için farklý datalength. Biri 200, biri 230, biri 300 bunu 100 yapacaz.
        DownMovesEMGRX=abs(DownMovesEMGRX);

        UpMovesEMGFS=abs(UpMovesEMGFS);  %Artýk elimizde Up ve Down movements için ABSOLUTE EMG verileri var. Fakat her cycle için farklý datalength. Biri 200, biri 230, biri 300 bunu 100 yapacaz.
        DownMovesEMGFS=abs(DownMovesEMGFS);


%% ARTIK ELÝMÝZDE HER UPMOVE VE DOWNMOVE ÝÇÝN 1 SÜTUN TETA, 8 SÜTUN EMG DATASI VAR. FAKAT BUNLAR FARKLI BOYUTLARDA! 
%% RESAMPLING VEYA INTERPOLASYON KULLANARAK BOYUTLARINI AYNI HALE GETÝRELÝM:


        UpMovesEMGUK;     %datalength x 8n  matris  n=hareket sayýsý þuan 10
        UpMovesEMGEX;
        UpMovesEMGRX;
        UpMovesEMGFS;




%% INTERPOLASYON ÝLE AYNI BOYUTA ÇEKELIM (BURADA ÞÖYLE BÝR PROBLEM VAR HER MOVE ÝÇÝN SAMPLING TIME DEGISIR. 15ms,20ms,10ms


        [rowsueUK,columnsueUK] = size(UpMovesEMGUK); %%Önce 99'larý kes, sonra ilk 300 data (1.5s) için 20 datada bir(100ms'de bir) max bul. Böylece 15 satýrlýk yeni matris oluþtur.
        NewUpMovesEMGUK = -99*ones(15,columnsueUK);

        [rowsueEX,columnsueEX] = size(UpMovesEMGEX);
        NewUpMovesEMGEX = -99*ones(15,columnsueEX);

        [rowsueRX,columnsueRX] = size(UpMovesEMGRX);
        NewUpMovesEMGRX = -99*ones(15,columnsueRX);

        [rowsueFS,columnsueFS] = size(UpMovesEMGFS); %%Önce 99'larý kes, sonra ilk 300 data (1.5s) için 20 datada bir(100ms'de bir) max bul. Böylece 15 satýrlýk yeni matris oluþtur.
        NewUpMovesEMGFS = -99*ones(15,columnsueFS);




        for i=1:1:columnsueUK %HER UP MOVE ÝÇÝN 1 ITERASYON ÝLE EMG ALINACAK
     
            indexes99=find(UpMovesEMGUK(:,i)==99);
            UpMoveEMGUK=UpMovesEMGUK(:,i);
            UpMoveEMGUK(indexes99)=[];
            y=UpMoveEMGUK;

            NewUpMovesEMGUK(1,i)=max(y(1:20))
            NewUpMovesEMGUK(2,i)=max(y(21:40))
            NewUpMovesEMGUK(3,i)=max(y(41:60))
            NewUpMovesEMGUK(4,i)=max(y(61:80));
            NewUpMovesEMGUK(5,i)=max(y(81:100));
            NewUpMovesEMGUK(6,i)=max(y(101:120));
            NewUpMovesEMGUK(7,i)=max(y(121:140));
            NewUpMovesEMGUK(8,i)=max(y(141:160));
            NewUpMovesEMGUK(9,i)=max(y(161:180)); 
            NewUpMovesEMGUK(10,i)=max(y(181:200));
            NewUpMovesEMGUK(11,i)=max(y(201:220));
            NewUpMovesEMGUK(12,i)=max(y(221:240));
            NewUpMovesEMGUK(13,i)=max(y(241:260));
            NewUpMovesEMGUK(14,i)=max(y(261:280));
            NewUpMovesEMGUK(15,i)=max(y(281:300));
                   
        end


         for i=1:1:columnsueEX %HER UP MOVE ÝÇÝN 1 ITERASYON ÝLE EMG ALINACAK
     
            indexes99=find(UpMovesEMGEX(:,i)==99);
            UpMoveEMGEX=UpMovesEMGEX(:,i);
            UpMoveEMGEX(indexes99)=[];
            y=UpMoveEMGEX;

            NewUpMovesEMGEX(1,i)=max(y(1:20)); 
            NewUpMovesEMGEX(2,i)=max(y(21:40));
            NewUpMovesEMGEX(3,i)=max(y(41:60));
            NewUpMovesEMGEX(4,i)=max(y(61:80));
            NewUpMovesEMGEX(5,i)=max(y(81:100));
            NewUpMovesEMGEX(6,i)=max(y(101:120));
            NewUpMovesEMGEX(7,i)=max(y(121:140));
            NewUpMovesEMGEX(8,i)=max(y(141:160));
            NewUpMovesEMGEX(9,i)=max(y(161:180)); 
            NewUpMovesEMGEX(10,i)=max(y(181:200));
            NewUpMovesEMGEX(11,i)=max(y(201:220));
            NewUpMovesEMGEX(12,i)=max(y(221:240));
            NewUpMovesEMGEX(13,i)=max(y(241:260));
            NewUpMovesEMGEX(14,i)=max(y(261:280));
            NewUpMovesEMGEX(15,i)=max(y(281:300));
                   
         end


        for i=1:1:columnsueRX %HER UP MOVE ÝÇÝN 1 ITERASYON ÝLE EMG ALINACAK
     
            indexes99=find(UpMovesEMGRX(:,i)==99);
            UpMoveEMGRX=UpMovesEMGRX(:,i);
            UpMoveEMGRX(indexes99)=[];
            y=UpMoveEMGRX;

            NewUpMovesEMGRX(1,i)=max(y(1:20)); 
            NewUpMovesEMGRX(2,i)=max(y(21:40));
            NewUpMovesEMGRX(3,i)=max(y(41:60));
            NewUpMovesEMGRX(4,i)=max(y(61:80));
            NewUpMovesEMGRX(5,i)=max(y(81:100));
            NewUpMovesEMGRX(6,i)=max(y(101:120));
            NewUpMovesEMGRX(7,i)=max(y(121:140));
            NewUpMovesEMGRX(8,i)=max(y(141:160));
            NewUpMovesEMGRX(9,i)=max(y(161:180)); 
            NewUpMovesEMGRX(10,i)=max(y(181:200));
            NewUpMovesEMGRX(11,i)=max(y(201:220));
            NewUpMovesEMGRX(12,i)=max(y(221:240));
            NewUpMovesEMGRX(13,i)=max(y(241:260));
            NewUpMovesEMGRX(14,i)=max(y(261:280));
            NewUpMovesEMGRX(15,i)=max(y(281:300));
                   
        end     



        for i=1:1:columnsueFS %HER UP MOVE ÝÇÝN 1 ITERASYON ÝLE EMG ALINACAK
     
            indexes99=find(UpMovesEMGFS(:,i)==99);
            UpMoveEMGFS=UpMovesEMGFS(:,i);
            UpMoveEMGFS(indexes99)=[];
            y=UpMoveEMGFS;

            NewUpMovesEMGFS(1,i)=max(y(1:20))
            NewUpMovesEMGFS(2,i)=max(y(21:40))
            NewUpMovesEMGFS(3,i)=max(y(41:60))
            NewUpMovesEMGFS(4,i)=max(y(61:80));
            NewUpMovesEMGFS(5,i)=max(y(81:100));
            NewUpMovesEMGFS(6,i)=max(y(101:120));
            NewUpMovesEMGFS(7,i)=max(y(121:140));
            NewUpMovesEMGFS(8,i)=max(y(141:160));
            NewUpMovesEMGFS(9,i)=max(y(161:180)); 
            NewUpMovesEMGFS(10,i)=max(y(181:200));
            NewUpMovesEMGFS(11,i)=max(y(201:220));
            NewUpMovesEMGFS(12,i)=max(y(221:240));
            NewUpMovesEMGFS(13,i)=max(y(241:260));
            NewUpMovesEMGFS(14,i)=max(y(261:280));
            NewUpMovesEMGFS(15,i)=max(y(281:300));
                   
        end
  
                                   
        
        NewUpMovesEMGUK;
        NewUpMovesEMGEX;
        NewUpMovesEMGRX;
        NewUpMovesEMGFS;


                             

        
        

[rows,columns]=size(NewUpMovesEMGUK); %rows=15 


internal_emg_1FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows); %10'a 15 lik bir matrix. 10 tane flexion cycle var. Her cyle da 15 noktada (100ms'da bir) data var!
internal_emg_2FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);
internal_emg_3FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);
internal_emg_4FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);
internal_emg_5FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);
internal_emg_6FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);
internal_emg_7FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);
internal_emg_8FX = zeros(length(NewUpMovesEMGUK(1,:))/8,rows);




for j = 1 : 1: rows  %15
    
    for i = 1 : 1 : length(NewUpMovesEMGUK(1,:))/8 %49
        
        internal_emg_1FX(i,j) = NewUpMovesEMGUK(j,1+(i-1)*8);
        internal_emg_2FX(i,j) = NewUpMovesEMGUK(j,2+(i-1)*8);
        internal_emg_3FX(i,j) = NewUpMovesEMGUK(j,3+(i-1)*8);
        internal_emg_4FX(i,j) = NewUpMovesEMGUK(j,4+(i-1)*8);
        internal_emg_5FX(i,j) = NewUpMovesEMGUK(j,5+(i-1)*8);
        internal_emg_6FX(i,j) = NewUpMovesEMGUK(j,6+(i-1)*8);
        internal_emg_7FX(i,j) = NewUpMovesEMGUK(j,7+(i-1)*8);
        internal_emg_8FX(i,j) = NewUpMovesEMGUK(j,8+(i-1)*8);
        
    end       
end





internal_emg_1EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows); %10'a 15 lik bir matrix. 10 tane flexion cycle var. Her cyle da 15 noktada (100ms'da bir) data var!
internal_emg_2EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);
internal_emg_3EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);
internal_emg_4EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);
internal_emg_5EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);
internal_emg_6EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);
internal_emg_7EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);
internal_emg_8EX = zeros(length(NewUpMovesEMGEX(1,:))/8,rows);




for j = 1 : 1: rows  %15
    
    for i = 1 : 1 : length(NewUpMovesEMGUK(1,:))/8 %49
        
        internal_emg_1EX(i,j) = NewUpMovesEMGEX(j,1+(i-1)*8);
        internal_emg_2EX(i,j) = NewUpMovesEMGEX(j,2+(i-1)*8);
        internal_emg_3EX(i,j) = NewUpMovesEMGEX(j,3+(i-1)*8);
        internal_emg_4EX(i,j) = NewUpMovesEMGEX(j,4+(i-1)*8);
        internal_emg_5EX(i,j) = NewUpMovesEMGEX(j,5+(i-1)*8);
        internal_emg_6EX(i,j) = NewUpMovesEMGEX(j,6+(i-1)*8);
        internal_emg_7EX(i,j) = NewUpMovesEMGEX(j,7+(i-1)*8);
        internal_emg_8EX(i,j) = NewUpMovesEMGEX(j,8+(i-1)*8);
        
    end       
end






internal_emg_1RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows); %10'a 15 lik bir matrix. 10 tane flexion cycle var. Her cyle da 15 noktada (100ms'da bir) data var!
internal_emg_2RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);
internal_emg_3RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);
internal_emg_4RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);
internal_emg_5RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);
internal_emg_6RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);
internal_emg_7RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);
internal_emg_8RX = zeros(length(NewUpMovesEMGRX(1,:))/8,rows);




for j = 1 : 1: rows  %15
    
    for i = 1 : 1 : length(NewUpMovesEMGRX(1,:))/8 %49
        
        internal_emg_1RX(i,j) = NewUpMovesEMGRX(j,1+(i-1)*8);
        internal_emg_2RX(i,j) = NewUpMovesEMGRX(j,2+(i-1)*8);
        internal_emg_3RX(i,j) = NewUpMovesEMGRX(j,3+(i-1)*8);
        internal_emg_4RX(i,j) = NewUpMovesEMGRX(j,4+(i-1)*8);
        internal_emg_5RX(i,j) = NewUpMovesEMGRX(j,5+(i-1)*8);
        internal_emg_6RX(i,j) = NewUpMovesEMGRX(j,6+(i-1)*8);
        internal_emg_7RX(i,j) = NewUpMovesEMGRX(j,7+(i-1)*8);
        internal_emg_8RX(i,j) = NewUpMovesEMGRX(j,8+(i-1)*8);
        
    end       
end



internal_emg_1FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows); %10'a 15 lik bir matrix. 10 tane flexion cycle var. Her cyle da 15 noktada (100ms'da bir) data var!
internal_emg_2FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);
internal_emg_3FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);
internal_emg_4FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);
internal_emg_5FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);
internal_emg_6FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);
internal_emg_7FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);
internal_emg_8FS = zeros(length(NewUpMovesEMGFS(1,:))/8,rows);




for j = 1 : 1: rows  %15
    
    for i = 1 : 1 : length(NewUpMovesEMGFS(1,:))/8 %49
        
        internal_emg_1FS(i,j) = NewUpMovesEMGFS(j,1+(i-1)*8);
        internal_emg_2FS(i,j) = NewUpMovesEMGFS(j,2+(i-1)*8);
        internal_emg_3FS(i,j) = NewUpMovesEMGFS(j,3+(i-1)*8);
        internal_emg_4FS(i,j) = NewUpMovesEMGFS(j,4+(i-1)*8);
        internal_emg_5FS(i,j) = NewUpMovesEMGFS(j,5+(i-1)*8);
        internal_emg_6FS(i,j) = NewUpMovesEMGFS(j,6+(i-1)*8);
        internal_emg_7FS(i,j) = NewUpMovesEMGFS(j,7+(i-1)*8);
        internal_emg_8FS(i,j) = NewUpMovesEMGFS(j,8+(i-1)*8);
        
    end       
end








figure
for i=1:1:10
plot(internal_emg_2FX(i,:),internal_emg_7FX(i,:),'*r')
hold on
plot(internal_emg_2EX(i,:),internal_emg_7EX(i,:),'ob')
plot(internal_emg_2FS(i,:),internal_emg_7FS(i,:),'sm')
plot(internal_emg_2RX(i,:),internal_emg_7RX(i,:),'vk')
end
title('FLEXION EXTENSION AND DO NOTHING (150x3=450 data)')
xlabel('EMG 2');
ylabel('EMG 7');

legend('FLEXION','EXTENSION','FIST','DO NOTHING');
grid on


classfxx1=internal_emg_2FX';
classfxx2=internal_emg_7FX';

classexx1=internal_emg_2EX';
classexx2=internal_emg_7EX';

classfsx1=internal_emg_2FS';
classfsx2=internal_emg_7FS';

classrxx1=internal_emg_2RX';
classrxx2=internal_emg_7RX';



classFXEMG2=classfxx1(:); %column vector haline geldi
classFXEMG7=classfxx2(:);

classEXEMG2=classexx1(:); %column vector haline geldi
classEXEMG7=classexx2(:);

classFSEMG2=classfsx1(:); %column vector haline geldi
classFSEMG7=classfsx2(:);

classRXEMG2=classrxx1(:); %column vector haline geldi
classRXEMG7=classrxx2(:);



a=[classFXEMG2;classFSEMG2;classRXEMG2;classEXEMG2];
b=[classFXEMG7;classFSEMG7;classRXEMG7;classEXEMG7];

Y = ones(600,2);
Y(1:150,1:2)=0;
Y(151:300,1)=0;
Y(301:450,2)=0;


trainingdata=[a,b,Y];

figure
plot(trainingdata(1:150,1),trainingdata(1:150,2),'*r')
hold on
plot(trainingdata(151:300,1),trainingdata(151:300,2),'*b')
plot(trainingdata(301:450,1),trainingdata(301:450,2),'*k')
plot(trainingdata(451:600,1),trainingdata(451:600,2),'*m')
legend('FLEXION','FIST','RELAX','EXTENSION')






















%% NN APPLICATION





         %% simple idea to get the code in run

% Epsilon 


%% User input
number_of_hidden_layer_node = 2;
number_of_output_layer_node = 2;
H = 4;
K = 2; 
I = 3;
%%% CLASSIFICATION Problem
%% Backpropagation Algorithm

%% Writing the dataset on the graph
class3_tr=trainingdata;
variable = class3_tr;

length_of_class = length(variable(:,1))/4;

figure
plot(variable(1:length_of_class,1),variable(1:length_of_class,2),'+')
hold on
plot(variable(length_of_class+1:2*length_of_class,1),variable(length_of_class+1:2*length_of_class,2),'o')
hold on
plot(variable(2*length_of_class+1:3*length_of_class,1),variable(2*length_of_class+1:3*length_of_class,2),'*')
hold on
plot(variable(3*length_of_class+1:4*length_of_class,1),variable(3*length_of_class+1:4*length_of_class,2),'x')

% Denotes Number of Training Examples
%N is for the FOR cycle
N = length(class3_tr);

% We define the error as N elemented series
error = 1;

error_func = ones(N,1);

error = sum(error_func);

%% Input values are arranged.
X0 = ones(4*length_of_class,1);                 % for bias input

X1 = variable(:,1);                             % for first input
X2 = variable(:,2);                             % for second input

Y_general = variable(:,3:4)';                    % target values

X_general_unnormalized = [X0 X1 X2];
X_general = [X0 mat2gray(X1) mat2gray(X2)]';     % normalization in order to provide better convergence


%parameters are arranged before calculations

%Weights for our system will be defined through using randi

epsilon = 0.00001;
learning_rate = 1;
alfa = 0.5;

error_previous = 1;

% coefficient initialization

%% (1) define parametric coefficients, the reason is that user can change the dimensions of the layers,
%% (2) paving the way for creating for loops
W = randi([5 10],H,I)./100;
W_previous = randi([5 10],H,I)./100;
V = randi([5 10],K,H)./100;
V_previous = randi([5 10],K,H)./100;

% W = zeros(H,I);
% W_previous = randi([5 10],H,I)./100;
% V = zeros(K,H);
% V_previous = randi([5 10],K,H)./100;

%% (1) delta (d_W, d_V) and its real values (W,V) must be the same dimesions to each other
d_W = zeros(H,I);
d_V = zeros(K,H);

% temp variables including model values

%% (1) sigmoidal function and the total output must be arranged properly with the outputs of them:
%% z -> sigmoid function, so H output are produced. N - training set
z = zeros(H,N);
%% y -> total function, so K output are produced. N - training set
y = zeros(K,N);

figure
iteration = 0;      % iteration number obtained
ax1 = subplot(3,1,1);
h1 = animatedline;   % iteration graph is produced with animation feature
ax2 = subplot(3,1,2);
h2 = animatedline;
ax3 = subplot(3,1,3);
h3 = animatedline;

%% comparing with the total error
while error > epsilon
    iteration = iteration + 1;
    %% initialize all delta values after the training session
    d_W = zeros(H,I);
    d_V = zeros(K,H);
    
    % training session is started
    for i = 1 : 1 : N
        
        % z value calculation

        for h = 1 : 1 : H
            
            z(h,i) = 1/(1 + exp(-W(h,:)*X_general(:,i)));  % 1x1 should be satisfied.
            
        end
        
        % y value calculation
        
        for k = 1 : 1 : K
            
             y(k,i) = 1/(1 + exp(-V(k,:)*z(:,i))); 
        end
        
        % delta v coefficient calculation
        
        %% d_V() = zeros(K,H);
        %% first k, second h loop are established
        for k = 1 : 1 : K
            
            for h = 1 : 1 : H
                
                d_V(k,h) = d_V(k,h) + learning_rate*(Y_general(k,i) - y(k,i))*z(h,i);
                
            end
            
        end
        
        % delta w coefficient calculation
        
        %% d_W() = zeros(H,I);
        %% first h, second in loop are established
        
        for h = 1 : 1 : H
            
            for in = 1 : 1 : I
                
                d_W(h,in) = d_W(h,in) + learning_rate*(Y_general(:,i) - y(:,i))'*V(:,h)*z(h,i)*(1 - z(h,i))*X_general(in,i);
                
            end
            
        end
        
        error_func(i,1) = sum(1/2*(Y_general(:,i) - y(:,i)).^2);
        
    end
    
    % we have to update the real weights(V,W) after the whole training process 
    % 
    

    
    error = sum(error_func)/N
    
%     if abs(error_previous - error) > 1e-5
%         learning_rate = learning_rate + 0.1;
%     else
%         learning_rate = learning_rate - 1e-6*learning_rate;
%     end
%     
%     
%     if abs(error_previous - error) > 1e-4
%         V = V + d_V/N + 0.1*V_previous/N;
%         W = W + d_W/N + 0.1*W_previous/N;
%     else 
%         V = V + d_V/N;
%         W = W + d_W/N;
%     end
    
    V = V + d_V/N;
    W = W + d_W/N;
    
    W_previous = d_W;
    V_previous = d_V;
    

    
%     y_axis_limit = abs(error);
%     
% %     xlim(ax1,[iteration - 50, iteration+50])
% %     ylim(ax1,[y_axis_limit/5 y_axis_limit*5]);
%     addpoints(h1,iteration,abs(error));
%     drawnow limitrate
%     
%     if sum(isinf(error_previous)) == 0
%         
%         y_axis_limit = error_previous - error;
% 
% %         xlim(ax2,[iteration - 50, iteration+50])
% %         if y_axis_limit > 0
% %             ylim(ax2,[y_axis_limit/5 y_axis_limit*5]);
% %         else
% %             ylim(ax2,[y_axis_limit*5 y_axis_limit/5]);
% %         end
%         addpoints(h2,iteration,error_previous-error);
%         drawnow limitrate
%         
%     end
%     %learning_rate = learning_rate - 10e-8;
%     addpoints(h3,iteration,learning_rate);
%     drawnow limitrate
% %     
%     error_previous = error;
    
    
end

figure
Y_plot = zeros(1,330);

Y_plot(1:150) = 0;
Y_plot(151:300) = 1;
Y_plot(301:450) = 2;
Y_plot(451:600) = 3;

plot(Y_plot)

y_model_plot = 2*y(1,:) + 1*y(2,:);

hold on
plot(y_model_plot)




%% NN APPLICATION




            input=X_general(:,82);





            W =     [5.0291   -5.2670  -15.4976
                    -5.4189    5.2935   17.6583
                    -1.1389   10.7807   -9.4813
                     1.4755  -19.6346   -4.5221];


            v =     [16.3143  -16.6521    0.3884    0.2534
                    3.8185  -10.2751   18.4193  -21.8494];

            z=zeros(4,1);
 
            z(1) = 1/(1 + exp(-W(1,:)*input));
            z(2) = 1/(1 + exp(-W(2,:)*input));
            z(3) = 1/(1 + exp(-W(3,:)*input));
            z(4) = 1/(1 + exp(-W(4,:)*input));


             y(1) = 1/(1 + exp(-V(1,:)*z)); 
             y(2) = 1/(1 + exp(-V(2,:)*z));




             
             





