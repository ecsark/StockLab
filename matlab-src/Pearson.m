clear;
address = '/home/ecsark/Documents/Lab/StockLab/CLICK_SUMMARY.db';
conn = database(address,'','','org.sqlite.JDBC',strcat('jdbc:sqlite:',address));
setdbprefs('DataReturnFormat','cellarray');
temp=[];

sql='select date from click where stockId=''000001'' ';
curs=exec(conn,sql);
curs=fetch(curs);
cDate=cell2mat(curs.data);
for i=1:size(cDate,1)
    temp=[temp,(datevec(cDate(i,1:10),'yyyy-mm-dd'))'];
end
for i=1:3
    date(i,:)=temp(i,:);
end

sql='select distinct stockid from click';
curs=exec(conn,sql);
curs = fetch(curs);
result=curs.data;
stockNum=size(result,1);
%for
stockId=result(1);
sql=strcat('select clicksum from click where stockId=',' ''',stockId,'''') ;
sql=cell2mat(sql);
stockId=cell2mat(stockId);
curs=exec(conn,sql);
curs=fetch(curs);
click=(curs.data)';
click=cell2mat(click);


volume = zeros(1,size(date,2));
amount =  zeros(1,size(date,2));
price = zeros(1,size(date,2));

csvName = strcat('SZ', stockId,'.CSV');
priceHistory = csvread(csvName);


j=1;

for i=1:size(priceHistory,1)
    dd = priceHistory(i,1);
    dy = floor(dd/10000);
    dd = dd - dy*10000;
    dm = floor(dd/100);
    dd = dd - dm*100;
    if (dy<date(1,j) || dm<date(2,j) || dd<date(3,j))
        continue;
    else
        while (dy>date(1,j) || dm>date(2,j) || dd>date(3,j))
            j= j+1;
        end;
        volume(1,j) = priceHistory(i,6);
        amount(1,j) = priceHistory(i,7);
        price(1,j) = priceHistory(i,5);
        j = j+1;
        if j > size(date,2)
            break;
        end;
    end;
end;



wClick = [];
wVolume = [];
wAmount = [];
wPrice = [];

for i=1:size(volume,2)
    if volume(1,i)~=0
        wVolume = [wVolume,volume(1,i)];
        wClick = [wClick, click(1,i)];
        wAmount = [wAmount, amount(1,i)];
        wPrice = [wPrice, price(1,i)];
    end;
end;
