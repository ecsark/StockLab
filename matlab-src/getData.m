clear;
stockIDList ={'600000','600004','600005','600006','600007','600008','600009'};
%stockIDList = {'600004','600005'};

for i = 1:size(stockIDList,2)
    stockID = cell2mat(stockIDList(i));
    [date,clicksum] = getClick(stockID,100000);
    [volume, amount, endprice, breakpoints] = getExchange(stockID,date);
    [wDate, wClickSum, wVolume, wAmount, wEndPrice] = rmBreak(date, clicksum, volume, amount, endprice, breakpoints);
    
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
    figure(i)    
    plot(ds,(wClickSum-min(wClickSum)).*ratioClick,'m-',ds,(wEndPrice-min(wEndPrice)).*ratioEndPrice,'-.^')
    title(stockID)
end;
