function  iTS
global D w1 num wx 

Dorig = D;

subplot(1,3,2)
disp('Click twice on Salinity subplot to get interpolation endpoints.'); disp(' ');

a = ginput(2);

y(1) = min(wx(find(abs(D(wx,2)-a(1,2)) == min(abs(D(wx,2)-a(1,2))))));
dpth(1) = D(y(1),2);
y(2) = max(wx(find(abs(D(wx,2)-a(2,2)) == min(abs(D(wx,2)-a(2,2))))));
dpth(2) = D(y(2),2);

X = [dpth' y'];
X = sortrows(X,1);

if X(2,2)-X(1,2) == 0,
	disp('Points must be separated by at least 1 sample.'); disp(' ');
else

	if X(1,1) == 0, 
		D(X(1,2):X(2,2),3) = D(X(2,2),3);
		D(X(1,2):X(2,2)-1,6) = 1;
		D(X(1,2):X(2,2),4) = D(X(2,2),4);
		D(X(1,2):X(2,2)-1,6) = 1;
		change = 1;
	elseif X(2,2)-X(1,2) == 1,
		if X(2,2) == max(wx),
			D(X(2,2),3) = D(X(1,2),3);
			D(X(2,2),6) = 1;
			D(X(2,2),4) = D(X(1,2),4);
			D(X(2,2),6) = 1;
			change = 1;
		else
			disp('Points must be separated by at least 1 sample.'); disp(' ');
			change = 0;
		end
	else
		%incr = (D(X(2,2),3)-D(X(1,2),3))/(X(2,1)-X(1,1));
		%xinc =(X(1,2):X(2,2))-X(1,2);
		%D(X(1,2):X(2,2),3) = D(X(1,2),3)+incr*xinc';
		D(X(1,2):X(2,2),3) = interp1(D(X(1:2,2),2),D(X(1:2,2),3),D(X(1,2):X(2,2),2));
        D(X(1,2)+1:X(2,2)-1,6) = 2;
		D(X(1,2):X(2,2),4) = interp1(D(X(1:2,2),2),D(X(1:2,2),4),D(X(1,2):X(2,2),2));
        D(X(1,2)+1:X(2,2)-1,6) = 2;
		change = 1;
	end

%%%

	if change,	
		wherecast = find(D(:,1) == w1(num));
		Sigt = sw_pden(D(wherecast,4), D(wherecast,3), D(wherecast,2),0)-1000;
		D(wherecast,5) = Sigt;
	
		plotv

   		button = questdlg('Keep interpolation??','Keep Interpolation','Yes','No','No');
    		if strcmp(button,'Yes')
        		disp('Changes kept.')
			Dorig = D;
    		elseif strcmp(button,'No')
        		disp('Changes undone.'); disp(' ');
			D = Dorig;	
			Sigt = sw_pden(D(:,4), D(:,3), D(:,2),0)-1000;
			D(:,5) = Sigt;
			plotv
			disp('Changes undone.')
    		end
	end
end