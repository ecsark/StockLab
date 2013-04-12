clear;
%stockIDList ={'600000','600004','600005','600006','600007','600008', ...
%    '600009','600010','600011',};
%stockIDList = {'600005'};

directory = '/home/ecsark/Documents/Lab/StockLab/';

addpath(genpath(directory));

stockList = getStockList(directory);



for i = 1:size(stockList,2)
    %stockID = cell2mat(stockIDList(i));
    stockID = cell2mat(stockList(i));
    [date,clicksum] = getClick(stockID,100000);
    [volume, amount, endprice, breakpoints] = getExchange(stockID,date);
    [wDate, wClickSum, wVolume, wAmount, wEndPrice] = rmBreak(date, ...
        clicksum, volume, amount, endprice, breakpoints);
    
    %{
    ds = cellstr('');
    
    for j = 1:size(wDate,2)
        ds = [ds,strcat(int2str(wDate(1,j)),'-',int2str(wDate(2,j)),'-',int2str(wDate(3,j)))];
    end;
    
    ds = ds(:,1:size(ds,2));
    %}
    
    ds = 1:size(wAmount,2);
    ratioClick = 1000/(max(wClickSum)-min(wClickSum));
    ratioEndPrice = 1000/(max(wEndPrice)-min(wEndPrice));
    f = figure(i);
    plot(ds,(wClickSum-min(wClickSum)).*ratioClick,'m-v',ds, ...
        (wEndPrice-min(wEndPrice)).*ratioEndPrice,'-.^')
    title(stockID)
    print(i,'-dpng',strcat(directory,'fig/',stockID,'.png'))
    close(f)
    stockID
end;
