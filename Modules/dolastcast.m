function dolastcast


global  D w1 num in2 lx wx l1 l2
	
	
	in2 = 0;
	l1 = 1;
	l2 = 100;
	if num > 1,
		num = num - 1;
	else
		num = 1;
	end	
	disp(['Showing Cast #' num2str(w1(num))]); disp(' ');
	
	wx = find(D(:,1) == w1(num));
	lx = ceil(length(wx)/100);

	dosubsection

	