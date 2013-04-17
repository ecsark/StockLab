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
    sql = strcat('SELECT * FROM click WHERE stockid ="',stockID,'"');
    curs = exec(conn,sql);
    result = fetch(curs);
    result = result.Data;
    sdate = datevec(cell2mat(result(:,1:1)),'yyyy-mm-dd');
    sdate = sdate(:,1:3);
    
    csvName = strcat('SZ', stockID,'.CSV');
    if(strcmp(stockID(1:1),'6')==1)
        csvName = strcat('SH', stockID,'.CSV');
    end;
    priceHistory = csvread(csvName);

    pdate = datevec(num2str(priceHistory(:,1:1)),'yyyymmdd');
    [date,ipdate,isdate] = intersect(pdate(:,1:3),sdate,'rows');
    
    sql = strcat('SELECT clicksum, replysum FROM click WHERE stockid ="',...
        stockID,'" ORDER BY date');
    curs = exec(conn,sql);
    result = fetch(curs);
    result = result.Data;
    summary = [cell2mat(result(:,1:1)),cell2mat(result(:,2:2))];
    summary = summary(isdate,:);
    stats = priceHistory(ipdate,2:7);
    
    % summary col[1]:clicksum
    % summary col[2]:replysum
    % stats col[1]: openprice
    % stats col[2]: highestprice
    % stats col[3]: lowestprice
    % stats col[4]: endprice
    % stats col[5]: amount
    % stats col[6]: value
    
    clickSum = summary(:,1:1);
    endPrice = stats(:,4:4);
    
    ratioClick = 1000/(max(clickSum)-min(clickSum));
    ratioEndPrice = 1000/(max(endPrice)-min(endPrice));
    f = figure(i);
    ds = 1:size(clickSum,1);
    ax = axes('Parent',f,'XTickLabel',datestr(datenum(date),'yyyy-mm-dd'),'XTick',ds);
    rotateticklabel(ax);
    box(ax,'on');
    hold(ax,'all');
    plot(ds,(clickSum-min(clickSum)).*ratioClick,'m-v',ds, ...
        (endPrice-min(endPrice)).*ratioEndPrice,'-.^')
    title(stockID)
    print(i,'-dpng',strcat(directory,'fig/',stockID,'.png'))
    close(f)
end;

conn.close();