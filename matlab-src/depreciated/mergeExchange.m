function [pdate,pstat,breakpoints] = mergeExchange(stockID,date)

csvName = strcat('SZ', stockID,'.CSV');
if(strcmp(stockID(1:1),'6')==1)
    csvName = strcat('SH', stockID,'.CSV');
end;

priceHistory = csvread(csvName);

pdate = datevec(num2str(priceHistory(:,1:1)),'yyyymmdd');
pdate = intersect(pdate(:,1:3),date,'rows');


po = 6;

end