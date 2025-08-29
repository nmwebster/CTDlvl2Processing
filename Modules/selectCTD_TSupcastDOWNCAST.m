close all
clear all

addpath Modules

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STATIC DEFINITIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outFILE = 'PS0909.ascii';
hdrFILE = 'PS0909.hdr';
INSTRUMENT = 'SBE911';
VESSEL = 'PS';
CRUISE = 'PS0909';
PI = 'Weingartner';
PROJECT = 'BEST Moorings';
AGENCY = 'NSF';
REGION = 'Bering Sea';
DATARESTRICTIONS = 'n';
CTDvariables  = strvcat('Temperature [ITS-90, deg C]',...% unique variable names found in CNV file header: these are the columns to plot
                        'Salinity [PSU]',...
                        'Density [sigma-t, Kg/m^3 ]'); 
SELECTsensors = strvcat('Temperature',...
                         'Salinity',...
                         'Density',...
                         'Oxygen',...
                         'SBE 43 [ml/l]',...
                         'Fluorescence',...
                         'PAR/Irradiance',...
                         'SPAR',...
                         'Altimeter [m]'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
promptFORupcastDOWNCAST = 1; % set to 1 to have manual selection of upcast/downcast
CTDinterpolate = 1; % set to 1 to interpolate file after initial plot
printEPS = 0; % set to 1 to send output to files
printPNG = 1; % set to 1 to send output to files
maxPRESSURE = 10000; % % maximum pressure of plots
UPdown = 2;  % set to 1 to take the downcast, 0 to take the upcast, 2 to plot both
nROW = 1; % number of subplot rows 
nCOL = 3; % number of subplot columns 
plotSELECTsensors = 0; % run this loop to plot out all profiles selected in SELECTsensors
maxPRESSURE_SS = 300; 
UPdown_SS = 1;  % set to 1 to take the downcast, 0 to take the upcast.
nCOL_SS = 2; % number of columns to print
nROW_SS = 4; % number of data rows to print
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VARIABLE NAME AND FORMAT DEFINITIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: For all variables within the CNV file, all NAMES and FORMATS 
% must be listed below. Order of appearance is not important.
%....NAME ...........................................FORMAT....
VARIABLEnameFORMAT = [ '' ...
'Consecutive Station Number                          %4i   ';...
'prDM: Pressure, Digiquartz [db]                     %9.3f ';...
't090C: Temperature [ITS-90, deg C]                  %8.4f ';...
't190C: Temperature, 2 [ITS-90, deg C]               %8.4f ';...
'c0S/m: Conductivity [S/m]                           %9.6f ';...
'c1S/m: Conductivity, 2 [S/m]                        %9.6f ';...
'sbeox0ML/L: Oxygen, SBE 43 [ml/l]                   %9.5f ';...
'flECO-AFL: Fluorescence, Wetlab ECO-AFL/FL [mg/m^3] %8.4f ';...
'par: PAR/Irradiance, Biospherical/Licor             %9.3f ';...
'spar: SPAR/Surface Irradiance                       %9.3f ';...
'altM: Altimeter [m]                                 %8.3f ';...
'latitude: Latitude [deg]                            %11.5f';...
'longitude: Longitude [deg]                          %11.5f';...
'pumps: Pump Status                                  %2i   ';...
'nbf: Bottles Fired                                  %2i   ';...
'sigma-t00: Density [sigma-t, Kg/m^3 ]               %8.4f ';...
'sigma-t11: Density, 2 [sigma-t, Kg/m^3 ]            %8.4f ';...
'sal00: Salinity [PSU]                               %8.4f ';...
'sal11: Salinity, 2 [PSU]                            %8.4f ';...
'flag: flag                                          %8.4f '];

if plotSELECTsensors, % run this loop to plot out all profiles selected in 
    plotCTDprofiles(SELECTsensors,maxPRESSURE_SS,UPdown_SS,nCOL_SS,nROW_SS);
end

[mANC,nANC] = size(CTDvariables); % # of variables
a = dir('CNVfiles/*.cnv'); % find all .cnv files in the subdirectory CNVfiles

for INfile = 1:length(a) % loop through each file
    FILEtitle = a(INfile).name; % name of the file to work on
    w = findstr(FILEtitle,'_'); % find _'s
    if ~isempty(w), % if any _'s found, replace with -'s
        FILEtitle(w) = '-';
    end
    [H,D] = sbehead([BASEPATH a(INfile).name]); % read in header (H) and data (D) from .cnv file
    [m,n] = size(H); % size of header data matrix
        Y1 = [];
        nNAME = 0;
        lat = 0;
        lon = 0;
        gmttime = 0;
        depth = 0;
        stnname = 0;
        COLUMNnames = '% 1: Consecutive Station Number';
    for XY = 1:m % loop through header rows
        if findstr(H(XY,:),'# name '), % look for the column defining rows that start with "# name"
            nNAME = nNAME + 1; % number of columns in datafile
            w = findstr(H(XY,:),' ');
            if findstr(H(XY,:),'Pressure'), % look for the Pressure row
                Y1 = str2num(H(XY,w(2):w(3)))+1; % the column of the Pressure data
                Y1L = deblank(H(XY,w(5):end)); % the label of the Pressure data
            end
            for XY2 = 1:mANC, % look for the CTDvariables variables
                if findstr(H(XY,:),deblank(CTDvariables(XY2,:))); % if CTDvariables variable XY2 is found in row XY of header H,
                    eval(['X' num2str(XY2) ' = str2num(H(XY,w(2):w(3)))+1;']); % find the column that the data sits in
                    eval(['X' num2str(XY2) 'L = deblank(H(XY,w(5):end));']); % find the label to use for the data
                end
            end
            eqs = findstr(H(XY,:),'=');
            COLUMNnames = strvcat(COLUMNnames,['% ' num2str(nNAME+1) ': ' strtrim(H(XY,eqs+1:end))]);
        end
        line1 = deblank(H(XY,:));
        if findstr(line1,'NMEA Latitude'), lon = 1; LON = [ num2str(str2num(line1(19:20)) + str2num(line1(21:length(line1)-2))/60) ',']; end
       	if findstr(line1,'NMEA Longitude'), lat = 1; LAT = [ num2str(-str2num(line1(20:22)) - str2num(line1(23:length(line1)-2))/60) ',']; end
       	if findstr(line1,'NMEA UTC (Time)'), gmttime = 1; GMTDATETIME = [line1(20:length(line1)) ',']; end
        if findstr(line1,'** Station:'), stnname = 1; STNNAME = strtrim(line1(12:end)); end
    end
        if ~lon, LON = -999.999999; end
        if ~lat, LAT = 99.999999; end
        if ~gmttime, GMTDATETIME = 'MMM DD YYYY HH:MM:SS'; end
        if ~depth, DEPTH = NaN; end
        if ~stnname, STNNAME = FILEtitle(1:end-4); end
        
        w = find(D(:,Y1) == max(D(:,Y1))); % maximum Pressure in cast
        if UPdown == 1, % select the upcast or the downcast
            D = D(1:w,:);
        elseif UPdown == 0,
            D = D(end:-1:w,:);
            D = sortrows(D,Y1);
        end
        
        if max(D(:,Y1)) > maxPRESSURE, % retain only data less than or equal to the MAXPRESSURE specified above
            D = D(find(D(:,Y1) <= maxPRESSURE),:);
        end

        wMAX = find(D(:,Y1) == max(D(:,Y1)));
        
        figure(1); clf % open figure and plot the data
        for XY2 = 1:mANC
            subplot(nROW,nCOL,XY2);
                eval(['V = X' num2str(XY2) ';']);
                eval(['VL = X' num2str(XY2) 'L;']);
                
                plot(D(1:wMAX,V),D(1:wMAX,Y1),'k-'); hold on
                plot(D(1:wMAX,V),D(1:wMAX,Y1),'r.');
                plot(D(wMAX:end,V),D(wMAX:end,Y1),'k-'); hold on
                plot(D(wMAX:end,V),D(wMAX:end,Y1),'b.');
                set(gca,'ydir','reverse','fontweight','bold','fontsize',8)
                ylabel('Pressure (db)','fontweight','bold','fontsize',8)
                xlabel(VL,'fontweight','bold','fontsize',8) % label the x-data
                grid on
                box on
        end
            
        st = suptitle([FILEtitle]); % label the page with the filename
        set(st,'fontweight','bold','fontsize',16)

        if printEPS, % print the figure to an EPS file and a PNG file
           eval(['print -depsc2 Plots/' FILEtitle(1:end-4) '_TS.eps'])
        end
        if printPNG, % print the figure to an EPS file and a PNG file
           eval(['print -dpng -r150 Plots/' FILEtitle(1:end-4) '_TS.png'])
        end
        
       if promptFORupcastDOWNCAST
           ud = input(['Keep Upcast (0, blue) or Downcast (1, red, default)? ']);
       else
           ud = 1;
       end
       
       if isempty(ud), ud = 1; end
       if ud,
            D = [D(1:wMAX,:)]; % assumes we need to add a zero depth row
        else
            D = [D(end:-1:wMAX,:)]; % assumes we need to add a zero depth row
        end
         
       firstGOOD = D(1,Y1);          % constant extrapolation up to surface from first bin 
       if firstGOOD > 0,
       for inx = firstGOOD-1:-1:0,
           D = [D(1,:); D];
           D(1,Y1) = inx;
           D(1,end) = 1;          % set flag to extrapolated
       end
       end
 
       % CSN = str2num(FILEtitle(end-5:end-4));    % consecutive station number
       % CSN = str2num(FILEtitle(1:2));    % consecutive station number
        CSN = INfile; % temporarily assign a consecutive station number
        D = [CSN*ones(size(D(:,1))) D];

        [m,n] = size(COLUMNnames);
        outfmt = '';
        warning('off','MATLAB:dispatcher:InexactCaseMatch')
        for in = 1:m,
            wc = findstr(COLUMNnames(in,:),':');
            VARrow = strmatch(strtrim(COLUMNnames(in,wc(1)+1:end)), VARIABLEnameFORMAT);
            if ~isempty(VARrow),
                outfmt = [outfmt strtrim(VARIABLEnameFORMAT(VARrow,53:end)) ' '];
            end
        end
        outfmt = [outfmt(1:end-1) '\n'];

        if INfile == 1, 
            percents = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
            fid = fopen([outFILE],'w');
            fid2 = fopen([hdrFILE],'w');
            COLUMNnames = strvcat(['% Data File Name: ' outFILE],['% Header Data File Name: ' hdrFILE],percents,'% Data File Column Contents:',COLUMNnames);
            fprintf(fid,'%s\n',percents);
            [m,n] = size(COLUMNnames);
            for XY = 1:m,
                fprintf(fid,'%s\n',COLUMNnames(XY,:)');
            end
            fprintf(fid,'%s\n',percents);
            fprintf(fid,'%s\n',['% Output format = ' outfmt]);
            H = strvcat(percents,'% SeaBird CNV File Header: ',H);
            H = strvcat(percents,'% Data Flag Definition:','% 0 = Data Untouched','% 1 = Data columns are extrapolated (typically at top or bottom of water column)','% 2 = Primary T and/or S data are interpolated (typically at mid-water column depth)',H);
            [m,n] = size(H);
            for XY = 1:m,
                fprintf(fid,'%s\n',['% ' H(XY,:)]);
            end
        else
            fid = fopen([outFILE],'a');            
            fid2 = fopen([hdrFILE],'a');
        end
        fprintf(fid,outfmt,D');
        fclose(fid);
    
        HDRSTRING1 = [num2str(CSN) ', ' upper(STNNAME)  ', ' GMTDATETIME LAT LON num2str(DEPTH) ', ' FILEtitle ', '];
        HDRSTRING2 = [INSTRUMENT ', ' VESSEL ', ' CRUISE ', ' PI ', ' PROJECT ', ' AGENCY ', ' REGION ', ' DATARESTRICTIONS];
        fprintf(fid2,'%s\n',[HDRSTRING1 HDRSTRING2]);
        fclose(fid2);
end

if CTDinterpolate,
    Interp_CTD(outFILE(1:end-6));
end