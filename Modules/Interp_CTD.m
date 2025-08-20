function Interp_CTD(cruisename)
% function Interp_ctd(cruise)
%
% To run, syntax like Interp_ctd('VB1') where data is in VB1.ascii
%

 global D HRD HRDD DD w w1 num in2 lx wx l1 l2  cruise COLS HEADER

 % D will have columns: 1-CS 2-PR 3-T1 4-S1 5-Sigt1 6-FLAG 7-Delta-D
 
BASEPATH = ['.\'];             % for PC !!!!

cruise = cruisename;
      
eval(['load ' cruise '.ascii']);
Dpro = eval([ cruise ';']);
%eval(['load ' cruise 'RAW.ascii']);
%Draw = eval([ cruise 'RAW;']);
Draw = eval([ cruise ';']);

fid = fopen([cruise '.ascii'],'r');
HEADER = '';
while 1,
    line1 = fgetl(fid);
    if ~isstr(line1), break, end
    wc = findstr(line1,':');
    we = findstr(line1,'*END*');
    HEADER = strvcat(HEADER,line1);
    if ~isempty(we), break, end
    if any(findstr(line1,': Consecutive Station Number')) & isempty(findstr(line1,'name')),
        COLS(1) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Pressure, Digiquartz [db]')) & isempty(findstr(line1,'name')),
        COLS(2) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Pressure, Strain Gauge [db]')) & isempty(findstr(line1,'name')),
        COLS(2) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Temperature [ITS-90, deg C]')) & isempty(findstr(line1,'name')),
        COLS(3) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Absolute Salinity [g/kg]')) & isempty(findstr(line1,'name')),
        COLS(4) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Salinity, Practical [PSU]')) & isempty(findstr(line1,'name')),
        COLS(4) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'density, TEOS-10 [sigma-0, kg/m^3 ]')) & isempty(findstr(line1,'name')),
        COLS(5) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Density [sigma-t, kg/m^3 ]')) & isempty(findstr(line1,'name')),
        COLS(5) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Density [density, kg/m^3]')) & isempty(findstr(line1,'name')),
        COLS(5) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Density [sigma-t, Kg/m^3 ]')) & isempty(findstr(line1,'name')),
        COLS(5) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'Density [sigma-theta, kg/m^3]')) & isempty(findstr(line1,'name')),
        COLS(5) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'flag: flag')) & isempty(findstr(line1,'name')),
        COLS(6) = str2num(line1(3:wc(1)-1));
    elseif any(findstr(line1,'flag:     ')) & isempty(findstr(line1,'name')),
        COLS(6) = str2num(line1(3:wc(1)-1));
    end    
end
fclose(fid);
 
%eval(['! cp ' cruise '.ascii ' cruise '.ascii_orig']) %mac
eval(['! copy ' cruise '.ascii ' cruise '.ascii_orig'])  %pc


% COLUMNS OF DATA MATRIX D =  1=CS, 2=PR, 3=T1, 4=S1, 5=Sigt1, 6=FLAG  
D  = Dpro(:,COLS); % CS PR T1 S1 Sigt1 FLAG  CHECK THESE EACH TIME!!
HRD = Draw(:,COLS);
DD = D; % run this and next line if no secondary; if secondary uncomment the following two lines
HRDD = HRD;
%DD = Dpro(:,[COLS([1 2]) COLS([3 4 5])+1 COLS(6)]); % assumes secondary T, S & SIgT are one col past primary
%HRDD = Draw(:,[COLS([1 2]) COLS([3 4 5])+1 COLS(6)]);

clear Dpro DDpro DDraw where

% compute potential density
D = sortrows(D,[1 2]);
Sigt = sw_pden(D(:,4), D(:,3), D(:,2),0)-1000;
D(:,5) = Sigt;
DD = sortrows(DD,[1 2]);
Sigt2 = sw_pden(DD(:,4), DD(:,3), DD(:,2),0)-1000;
DD(:,5) = Sigt2;


%HRD = sortrows(HRD,[1 2]);
Sigt = sw_pden(HRD(:,4), HRD(:,3), HRD(:,2),0)-1000;
HRD(:,5) = Sigt;
%HRDD = sortrows(HRDD,[1 2]);
Sigt2 = sw_pden(HRDD(:,4), HRDD(:,3), HRDD(:,2),0)-1000;
HRDD(:,5) = Sigt2;

where = find(diff(D(:,1)));
w1 = [D(where,1); D(length(D(:,1)),1)];
w = length(w1);
	
 num = 0;
 in2 = 0;
  lx = 0;
  wx = 1;
  l1 = 1;
  l2 = 100;
		
figure(1); 
clf; 
set(gcf,'Position',[10 150 1260 820]);

docast

ha = uicontrol('Style', 'pushbutton', 'String', 'Zoom Out','fontname','times','fontweight','bold',...
	 'Position', [1150 725 100 50],'Callback', 'zoomout');
hb = uicontrol('Style', 'pushbutton', 'String', 'Zoom In','fontname','times','fontweight','bold',...
	 'Position', [1150 650 100 50],'Callback', 'zoomdpths');
hc = uicontrol('Style', 'pushbutton', 'String', 'Interpolate T','fontname','times','fontweight','bold',...
 	'Position', [1150 575 100 50],'Callback', 'iT');
hd = uicontrol('Style', 'pushbutton', 'String', 'Interpolate S','fontname','times','fontweight','bold',...
 	'Position', [1150 500 100 50],'Callback', 'iS');
he = uicontrol('Style', 'pushbutton', 'String', 'Interpolate T&S','fontname','times','fontweight','bold',...
 	'Position', [1150 425 100 50],'Callback', 'iTS');
hf = uicontrol('Style', 'pushbutton', 'String', 'Top of Cast','fontname','times','fontweight','bold',...
 	'Position', [1150 350 100 50],'Callback', 'dotopcast');
hg = uicontrol('Style', 'pushbutton', 'String', 'Next Subsection','fontname','times','fontweight','bold',...
 	'Position', [1150 275 100 50],'Callback', 'dosubsection');  
hh = uicontrol('Style', 'pushbutton', 'String', 'Next Cast','fontname','times','fontweight','bold',...
	'Position', [1150 200 100 50],'Callback', 'docast');
hi = uicontrol('Style', 'pushbutton', 'String', 'Previous Cast','fontname','times','fontweight','bold',...
 	'Position', [1150 125 100 50],'Callback', 'dolastcast');

hj = uicontrol('Style', 'pushbutton', 'String', 'Quit','fontname','times','fontweight','bold',...
 	'Position', [10 725 100 50],'Callback', 'saveD; close all');
hk = uicontrol('Style', 'pushbutton', 'String', 'Save Changes','fontname','times','fontweight','bold',...
 	'Position', [10 650 100 50],'Callback', 'saveD');
hl = uicontrol('Style', 'pushbutton', 'String', 'Print','fontname','times','fontweight','bold',...
 	'Position', [10 575 100 50],'Callback', 'orient landscape; print -dpsc2 -noui ctd.ps; !lpr -Pcps ctd.ps');
ho = uicontrol('Style', 'pushbutton', 'String', 'Swap Sensors','fontname','times','fontweight','bold',...
 	'Position', [10 500 100 50],'Callback', 'swapTSsensors');
hm = uicontrol('Style', 'pushbutton', 'String', 'Enter T Value','fontname','times','fontweight','bold',...
 	'Position', [10 200 100 50],'Callback', 'eT');
hn = uicontrol('Style', 'pushbutton', 'String', 'Enter S Value','fontname','times','fontweight','bold',...
 	'Position', [10 125 100 50],'Callback', 'eS');

