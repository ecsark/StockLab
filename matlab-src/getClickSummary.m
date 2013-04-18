clear;

%setup environment
directory = '/home/ecsark/Documents/Lab/StockLab/';
addpath(genpath(directory));
summarydb = strcat(directory,'CLICK_SUMMARY.db');
conn = database(summarydb,'','','org.sqlite.JDBC',strcat('jdbc:sqlite:',summarydb));
setdbprefs('DataReturnFormat','cellarray');

%fetch stock list
prices = dir(strcat(directory,'price/*.txt'));
priceList = [];
for i = 1:size(prices,1)
    parts = regexp(prices(i).name,'Z|H|\.','split');
    priceList = [priceList; parts(2)];    
end;
curs = exec(conn, 'SELECT DISTINCT stockid FROM click');
result = fetch(curs);
result = result.data;
stockList = intersect(result(:,1:1),priceList);

corrupted = [];

%iterate through the list and process each stock
for i = 1:size(stockList,1)
    stockID = cell2mat(stockList(i))
    sql = strcat('SELECT * FROM click WHERE stockid ="',stockID,'"');
    curs = exec(conn,sql);
    result = fetch(curs);
    result = result.Data;
    sdate = datevec(cell2mat(result(:,1:1)),'yyyy-mm-dd');
    sdate = sdate(:,1:3);
    
    csvName = strcat('SZ', stockID,'.txt');
    if(strcmp(stockID(1:1),'6')==1)
        csvName = strcat('SH', stockID,'.txt');
    end;
    priceHistory = importdata(csvName);

    pdate = datevec(num2str(priceHistory(:,1:1)),'yyyymmdd');
    [date,ipdate,isdate] = intersect(pdate(:,1:3),sdate,'rows');
    
    if size(date,1) == 0
        corrupted = [corrupted;stockID];
        continue;
    end;
    
    sql = strcat('SELECT clicksum, replysum, gap FROM click WHERE stockid ="',...
        stockID,'" ORDER BY date');
    curs = exec(conn,sql);
    result = fetch(curs);
    result = result.Data;
    summary = [cell2mat(result(:,1:1)),cell2mat(result(:,2:2)),cell2mat(result(:,3:3))];
    summary = summary(isdate,:);
    stats = priceHistory(ipdate,2:8);
    
    % summary col[1]:clicksum
    % summary col[2]:replysum
    % summary col[3]:gap
    % stats col[1]: openprice
    % stats col[2]: highestprice
    % stats col[3]: lowestprice
    % stats col[4]: endprice
    % stats col[5]: amount
    % stats col[6]: value
    %! !!these columns have to be divided by stats col[7] for comparison!!
    
    %mark the gap
    marker = [];
    for j = 1:size(summary,1)
        if summary(j,3)>1
            marker = [marker,j];
        end;
    end;
    
    cast = setdiff((1:size(summary,1)),marker);
    
    %uncertain result if first data's gap>1
    road = [];
    marker = [1,marker];
    for k = 2:size(marker,2)
        if marker(k) - marker(k-1) > 1
            road = [road, marker(k)-k+1];
        end;
    end;
    road = [road,size(cast,2)];
    
    clickSum = summary(cast,1:1);
    endPrice = stats(cast,4:4)./stats(cast,7:7);
    
    ratioClick = 1000/(max(clickSum)-min(clickSum));
    ratioEndPrice = 1000/(max(endPrice)-min(endPrice));
    f = figure(i);
    ds = 1:size(clickSum,1);
    ax = axes('Parent',f,'XTickLabel',datestr(datenum(date(cast,:)),'yyyy-mm-dd'),'XTick',ds);
    rotateticklabel(ax);
    box(ax,'on');
    hold(ax,'all');
    begin = 1;
    plotclick = (clickSum-min(clickSum)).*ratioClick;
    plotprice = (endPrice-min(endPrice)).*ratioEndPrice;
    for k = 1:size(road,2)
        range = begin:road(k);
        plot(range, plotclick(range,1:1),'r-v');
        plot(range, plotprice(range,1:1),'b-^');
        begin = road(k)+1;
    end;
    title(stockID);
    print(i,'-dpng',strcat(directory,'fig/',stockID,'.png'));
    close(f);
end;

conn.close();

corrupted