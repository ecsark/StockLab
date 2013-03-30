volume = zeros(1,size(date,2));
amount =  zeros(1,size(date,2));
price = zeros(1,size(date,2));

csvName = strcat('SH', stockID,'.CSV');
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
        %volume = [volume, priceHistory(j,6)];
        %amount = [amount, priceHistory(j,7)];
        j = j+1;
        if j > size(date,2)
            break;
        end;
    end;
end;