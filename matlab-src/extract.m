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