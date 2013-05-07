function [wDate, wClickSum, wVolume, wAmount, wEndPrice] = rmBreak(date,...
    clicksum, volume, amount, endprice, breakpoints)

wClickSum = [];
wVolume = [];
wAmount = [];
wEndPrice = [];
wDate = [];

j=1;

for i=1:size(volume,2)
    if volume(1,i)~=0
        if j<=size(breakpoints,2) && i==breakpoints(1,j)
            j = j+1;
            continue;
        end;
        wVolume = [wVolume,volume(1,i)];
        wClickSum = [wClickSum, clicksum(:,i)];
        wAmount = [wAmount, amount(1,i)];
        wEndPrice = [wEndPrice, endprice(1,i)];
        wDate = [wDate, date(:,i)];
    end;
end;

end
