function swapTSsensors
 

global D DD w w1 num in2 lx wx l1 l2 
	
	in2 = 0;
	l1 = 1;
	l2 = 100;

	num = num;
	
    wx = find(D(:,1) == w1(num));
    
    TEMP = D(wx,:);
    D(wx,:) = DD(wx,:);
    DD(wx,:) = TEMP;
    
    if num > w, num = w; end
	disp(['Swapped Sensors for this cast. Showing Cast #' num2str(w1(num))]); disp(' ');
	lx = ceil(length(wx)/100);
    
	dosubsection
	