function [wDate, wClickSum, wVolume, wAmount, wEndPrice] = rmHoliday(date, clicksum, volume, amount, endprice)

wClickSum = [];
wVolume = [];
wAmount = [];
wEndPrice = [];
wDate = [];

for i=1:size(volume,2)
    if volume(1,i)~=0
        wVolume = [wVolume,volume(1,i)];
        wClickSum = [wClickSum, clicksum(1,i)];
        wAmount = [wAmount, amount(1,i)];
        wEndPrice = [wEndPrice, endprice(1,i)];
        wDate = [wDate, date(:,i)];
    end;
end;

end