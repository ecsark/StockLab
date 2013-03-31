function [volume,amount,endprice,breakpoints] = getExchange(stockID, date)

volume = zeros(1,size(date,2));
amount =  zeros(1,size(date,2));
endprice = zeros(1,size(date,2));
breakpoints = [];

csvName = strcat('SH', stockID,'.CSV');
priceHistory = csvread(csvName);

j=1;

firstRun = 1;
skip = 0;

for i=1:size(priceHistory,1)
    dd = priceHistory(i,1);
    dy = floor(dd/10000);
    dd = dd - dy*10000;
    dm = floor(dd/100);
    dd = dd - dm*100;
    if (dy<date(1,j) || dm<date(2,j) || dd<date(3,j)) 
        if firstRun==0
            skip = 1;
        end;
        continue;
    else
        firstRun = 0;
        while (dy>date(1,j) || dm>date(2,j) || dd>date(3,j))
            j= j+1;
        end;
        
        volume(1,j) = priceHistory(i,6);
        amount(1,j) = priceHistory(i,7);
        endprice(1,j) = priceHistory(i,5);
        
        if skip==1
            breakpoints = [breakpoints,j];
            skip = 0;
        end;
        
        j = j+1;
        if j > size(date,2)
            break;
        end;
    end;
end;

end