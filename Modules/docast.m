function docast
 

global D  w w1 num in2 lx wx l1 l2 
	
	in2 = 0;
	l1 = 1;
	l2 = 100;

	num = num + 1;
	if num > w, num = w; end
	disp(['Showing Cast #' num2str(w1(num))]); disp(' ');
	wx = find(D(:,1) == w1(num));
	if ~isempty(wx),
		done = 1;
	end
	lx = ceil(length(wx)/100);
    
	dosubsection
	