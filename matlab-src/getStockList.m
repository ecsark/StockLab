function stockList = getStockList(directory)

stocks = dir(strcat(directory,'click/CLICK6*.db'));
prices = dir(strcat(directory,'price/SH6*.CSV'));

priceList = [];

for i = 1:size(prices,1)
    parts = regexp(prices(i).name,'H|\.','split');
    priceList = [priceList, parts(2)];    
end;

stockList = [];

for i = 1:size(stocks,1)
    parts = regexp(stocks(i).name,'K|\.','split');
    for j = 1:size(priceList,2)
        if strcmp(parts(2),priceList(j))==1
            stockList = [stockList, parts(2)];
            break;
        end;
    end;
end;