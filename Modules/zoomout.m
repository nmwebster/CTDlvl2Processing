function zoomout

global D wx l1 l2

Dorig = D;

if l2-l1<100,
	l1 = floor(l1/100)*100;
	l2 = ceil(l2/100)*100;
else
    l1 = min(D(wx,2));
    l2 = max(D(wx,2));
end

	plotv

