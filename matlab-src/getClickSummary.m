clear;

%setup environment
directory = '/home/ecsark/Documents/Lab/StockLab/';
addpath(genpath(directory));
summarydb = strcat(directory,'CLICK_SUMMARY.db');
conn = database(summarydb,'','','org.sqlite.JDBC',strcat('jdbc:sqlite:',summarydb));
setdbprefs('DataReturnFormat','cellarray');

%fetch stock list
prices = dir(strcat(directory,'price/*.CSV'));
priceList = [];
for i = 1:size(prices,1)
    parts = regexp(prices(i).name,'Z|H|\.','split');
    priceList = [priceList; parts(2)];    
end;
curs = exec(conn, 'SELECT DISTINCT stockid FROM click');
result = fetch(curs);
result = result.data;
stockList = intersect(result(:,1:1),priceList);


%iterate through the list and process each stock
for i = 1:size(stockList,1)
    stockID = cell2mat(stockList(i))
    sql = strcat('SELECT * FROM click WHERE stockid ="',stockID,'" ORDER BY date');
    curs = exec(conn,sql);
    result = fetch(curs);
    result = result.Data;
    date = datevec(cell2mat(result(:,1:1)),'yyyy-mm-dd');
    date = date(:,1:3)';
    ssum = [cell2mat(result(:,3:3)),cell2mat(result(:,4:4))]';
    [volume, amount, endprice, breakpoints] = getExchange(stockID,date);
    [wDate, wSum, wVolume, wAmount, wEndPrice] = rmBreak(date, ...
        ssum, volume, amount, endprice, breakpoints);
    ds = 1:size(wAmount,2);
    wClickSum = wSum(1:1,:);
    ratioClick = 1000/(max(wClickSum)-min(wClickSum));
    ratioEndPrice = 1000/(max(wEndPrice)-min(wEndPrice));
    f = figure(i);
    plot(ds,(wClickSum-min(wClickSum)).*ratioClick,'m-v',ds, ...
        (wEndPrice-min(wEndPrice)).*ratioEndPrice,'-.^')
    title(stockID)
    print(i,'-dpng',strcat(directory,'fig/',stockID,'.png'))
    close(f)
end;

conn.close();