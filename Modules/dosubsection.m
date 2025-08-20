function dosubsection

global  D in2 lx wx l1 l2 

    in2 = in2+1;

	if in2 > lx, in2 = lx; end

	if in2 == 1,
		if lx == 1;
           l1 = min(D(wx,2));
		   l2 = max(D(wx,2));
           %l1 = 0; l2 = length(wx);
        else
		   l1 = min(D(wx,2));
		   l2 = min(D(wx,2))+100;
           %l1 = 0; l2 = 100;
		end
	elseif in2 == lx, 
		l1 = max(D(wx,2))-100;
		l2 = max(D(wx,2));       
    else
        l1 = min(D(wx,2)) + 100*(in2-1)-5; 
        l2 = min(D(wx,2)) + 100*(in2)+5;
    end
 	
	plotv
    