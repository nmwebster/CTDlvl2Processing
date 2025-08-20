function  eT
global  D  w1 num  wx

Dorig = D;
maxDep = max(D(wx,2));
oksofar=1;

dlgPrompts={['Input Depth for New Temperature:'],['Input Temperature Value at Depth:']};
dlgTitle='Input new depth and Temperature:';
dlgLines=1;
dlgDefaults={['0'],['5']};
dlgInput=inputdlg(dlgPrompts,dlgTitle,dlgLines,dlgDefaults);

newDep = str2num(dlgInput{1});
newTem = str2num(dlgInput{2});

  if ~isempty(newDep)	
	if newDep < 0,
		display(['Depth must be in range 0 to ' num2str(maxDep)]);
		oksofar = 0;
  	elseif newDep > maxDep,
		display(['Depth must be in range 0 to ' num2str(maxDep)]);
		oksofar = 0;
        end
  else
	oksofar=0;
  end
  if ~isempty(newTem)	
	if newTem < 0,
		display(['Temperature must be in range 0 to 40']);
		oksofar = 0;
  	elseif newTem > 40,
		display(['Temperature must be in range 0 to 40']);
		oksofar = 0;
        end
  else
	oksofar=0;
  end

if oksofar,
	subplot(1,3,2)

	y(1) = wx(find(abs(D(wx,2)-newDep) == min(abs(D(wx,2)-newDep))));
	dpth(1) = D(y(1),3);

	X = [dpth y];
	
	D(X(1,2),3) = newTem;
	D(X(1,2),6) = 1;
	
	wherecast = find(D(:,1) == w1(num));
	Sigt = sw_pden(D(wherecast,4), D(wherecast,3), D(wherecast,2),0)-1000;
	D(wherecast,5) = Sigt;
	
	plotv

	button = questdlg('  Keep input??  ','Keep new data?','Yes','No','No');
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