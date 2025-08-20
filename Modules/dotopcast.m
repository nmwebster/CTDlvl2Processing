function dotopcast
global D w1 num in2 lx wx l1 l2

	in2 = 0;
	l1 = 1;
	l2 = 100;
	disp(['Showing Cast #' num2str(num)]); disp(' ');

	wx = find(D(:,1) == w1(num));
	lx = ceil(length(wx)/100);

	dosubsection