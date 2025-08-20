function saveD(D)

global D DD cruise COLS HEADER PARAMS

%%%% Load in station header data and generate station name and date matrices
    STATIONS = [];
    NAMES = [];
    STGD = [];
    STATION_NAME = [];
    STATION_DATE = [];
    FILE_INSTRUMENT_PLATFORM = [];
    fid = fopen([cruise '.hdr'],'r');
   
    while ~0,
        line1 = fgetl(fid);
        if ~isstr(line1), break, end
        if isempty(strfind(line1(1),'%')),
        coms = findstr(line1,',');
       DATE2 = line1(coms(2)+1:coms(3)-1);
       DATE2 = strtrim(DATE2);
       ST = [str2num(line1(1:coms(1)-1)) str2num(line1(coms(4)+1:coms(5)-1)) str2num(line1(coms(3)+1:coms(4)-1)) str2num(line1(coms(5)+1:coms(6)-1))];
       if length(ST) == 4,
            STATIONS = [STATIONS; str2num(line1(1:coms(1)-1)) str2num(line1(coms(4)+1:coms(5)-1)) str2num(line1(coms(3)+1:coms(4)-1)) str2num(line1(coms(5)+1:coms(6)-1))];
       else
            STATIONS = [STATIONS; str2num(line1(1:coms(1)-1)) str2num(line1(coms(4)+1:coms(5)-1)) str2num(line1(coms(3)+1:coms(4)-1)) NaN];
       end
       
        NAMES = strvcat(NAMES,[line1(coms(1)+1:coms(2)-1) ' ' DATE2]);
        STATION_NAME = strvcat(STATION_NAME,deblank(line1(coms(1)+1:coms(2)-1)));
        DATE3 = datenum(DATE2);
        DATE4 = datestr(DATE3,'yyyy-mm-ddTHH:MM:SS');
        STATION_DATE = strvcat(STATION_DATE,DATE4);
        FILE_INSTRUMENT_PLATFORM = strvcat(FILE_INSTRUMENT_PLATFORM, [line1(coms(6)+1:coms(9)-1)]);
        STGD = [STGD; STATIONS(end,:) str2num(datestr(datenum(DATE2),'yyyy mm dd HH MM SS'))];
        DATE1 = []; DATE2 = [];
        end
    end
    fclose(fid); 
    
  %  keyboard 

    goodSTNS = unique(D(:,1));
    S2 = [];
    N2 = [];
    FIP = [];
    SD = [];
    STGD2 = [];
    CDI = [];
    SN = [];
    for inx = 1:length(goodSTNS)
        where = find(STATIONS(:,1) == goodSTNS(inx));
        S2 = [S2; STATIONS(where,:)];
        N2 = [N2; NAMES(where,:)];
        FIP = [FIP; FILE_INSTRUMENT_PLATFORM(where,:)];
        SD = [SD; STATION_DATE(where,:)];
        SN = [SN; STATION_NAME(where,:)];
        STGD2 = [STGD2; STGD(where,:)];
        STATIONNUM = ['00' num2str(STATIONS(where,1))];
        CDI = strvcat(CDI, [cruise '_' STATIONNUM(end-2:end) '_' strtrim(STATION_NAME(where,:))]);
    end
    STATION_DATE = SD;
    STATION_NAME = SN;
    FILE_INSTRUMENT_PLATFORM = FIP;
    STGD = STGD2;
  
%%%% Note matrix D contains columns 1-CS 2-PR 3-T1 4-S1 5-Sigt1 6-FLAG

%%%% Check to see if we really want to write out files
        button = questdlg('Save Data ??','Save Data','Yes','No','No');
        
if strcmp(button,'Yes') 
        eval(['load ' cruise '.ascii']);
        Dpro = eval([ cruise ';']);
        Dpro = sortrows(Dpro, [COLS(1) COLS(2)]);
        D = sortrows(D, [1 2]);

%%%% Recompute SigmaT and DeltaD for archive purposes 
    DELTAD = NaN*ones(size(D(:,1)));
    for num = 1:max(D(:,1)) % recompute sigma-t and DELTA-D
		wherecast = [];
		wherecast = find(D(:,1) == num);
		if ~isempty(wherecast),
            Sigt = sw_pden(D(wherecast,4),D(wherecast,3),D(wherecast,2),0)-1000;
            D(wherecast,5) = Sigt;
            DELTAD(wherecast,1) = sw_gpan(D(wherecast,5), D(wherecast,4),D(wherecast,2))/10;
		end
    end

%%%% Check to see if the datasets remain as original    
    if sum(sum(Dpro(:,COLS(1:2))-D(:,1:2))) ~= 0, 
        disp([' *** Original and modified files do not line up. ***']); 
        beep; pause(.1); beep; pause(.1); beep;
        keyboard; 
    end

%%%%% Replace modified T, S, Sig-t and FLAG in original dataset
    Dpro(:,COLS(3:6)) = D(:,[3:6]); 

%%%% near-surface extrapolations applied to all other columns
    [m,n] = size(Dpro);
    otherCOLS = setdiff(1:n,COLS);
    for num = 1:max(D(:,1)) % recompute sigma-t and DELTA-D
		wherecast = [];
		wherecast = find(Dpro(:,1) == num);
		if ~isempty(wherecast),
            wG = find(Dpro(wherecast,COLS(6)) == 0);
            wE = find(Dpro(wherecast,COLS(2)) < Dpro(wherecast(wG(1)),COLS(2)));
            for in = 1:length(wE),
                Dpro(wherecast(wE(in)),otherCOLS) = Dpro(wherecast(wG(1)),otherCOLS);
            end
		end
    end
    
%%%% assemble output formats for writing.

    [m,n] = size(HEADER);
    FMTrow = strmatch('% Output format =',HEADER);
    outfmt = HEADER(FMTrow,:);
    w = findstr(outfmt,'='); 
    outfmt = strtrim(outfmt(w+1:end));  

    w = strfind(outfmt,' ');
    w = [1 w];
    outfmtCSV= '';
    for in = 1:length(w)-1,
        outfmtCSV = [outfmtCSV ',' outfmt(w(in):w(in+1)-1) ];
    end
    outfmtCSV= ['%s, ' outfmtCSV(2:end) ',' outfmt(w(end):end-2) ', '];

    fid = fopen([cruise '.ascii'],'w');  
    [m,n] = size(HEADER);
    for inO = 1:m
        fprintf(fid,'%s\n',HEADER(inO,:));     
    end
    
    fid2 = fopen([cruise '_profiles.ascii'],'w');  
    [m,n] = size(HEADER);
    for inO = 1:m
        fprintf(fid2,'%s\n',HEADER(inO,:));     
    end
   
    fprintf(fid2,'%s \r\n','Year, Month, Day, Hour, Minute, Second, Bottom Depth [m], Longitude [deg], Latitude [deg], Station Number, Pressure Digiquartz [db], Depth [m], Temperature [ITS-90 deg C], Temp2 [ITS-90 deg C], Conductivity [S/m], Cond2 [S/m], V0 [V], V1 [V], V2 [V], V3 [V], V4 [V], V5 [V], V6 [V], V7 [V], Fluorescence [mg/m^3], Beam Attenuation [1/m], Beam Transmission [%], Oxygen [umol/kg], Oxy2 [umol/kg], PAR, Alt [m], JD, Salinity [PSU], Sal2 [PSU], Density [sigma-t kg/m^3], Den2 [sigma-t kg/m^3], flag');

%%%% Write out ASCII and PROCESSED ASCII Files
          NC = NaN*ones(size(Dpro(:,1)));
          Dtemp = [NC NC NC NC NC NC NC NC NC Dpro];
          for in = 1:length(STGD(:,1))
              w = find(Dpro(:,1) == STGD(in,1));
              Dtemp(w,1:9) = ones(length(w),1)*[STGD(in,5:end) STGD(in,4) STGD(in,2:3) ];
          end
          outfmt2 = ['%4i %2i %2i %2i %2i %2i %6.1f %12.8f %12.8f ' outfmt];
 
          ws = strfind(outfmt2,' ');
          outfmt2(ws) = ',';
          fprintf(fid2,outfmt2,Dtemp'); %output data with dates
          fprintf(fid,outfmt,Dpro');   %output data without dates... 
    
            fc = fclose(fid);
            fc2 = fclose(fid2);
   
	        if fc == -1 | fid == -1,
		        disp('Save attempt failed.'); disp(' ')
	        else
	            disp(['Check "' cruise '.ascii" for full dataset.']); 
            end
    
%%%% Create and write out *.all.* files: just the P, T, S data
    disp(HEADER(1:30,:));
    FC = input(['From the header information above, what column is the fluorometer voltage in?? (CR [enter key] for no fluorometer)']);
    xtraCOLUMNS = [10 10 18 19 20 21];
   
        fid = fopen([cruise '.all.ctd_casts'],'w');
    if ~isempty(FC), 
        DOUT = [D(:,[1 2 3 4 5]) Dpro(:,FC)];
        fprintf(fid,'%6.1f %6.1f %8.3f %8.3f %8.3f %8.3f\n',DOUT'); 
    else
        DOUT = [D(:,[1 2 3 4 5]) NaN*D(:,1)];
        fprintf(fid,'%6.1f %6.1f %8.3f %8.3f %8.3f %8.3f\n',DOUT'); 
    end
        fclose(fid);
        disp(['Check "' cruise '.all.ctd_casts" for hydroplot data file.'])

    fid = fopen([cruise '.all.ctd_stations'],'w');
    fprintf(fid,'%6.1f %11.5f %12.5f %7.1f\n',S2(:,[1 3 2 4])');
    fclose(fid); 
    disp(['Check "' cruise '.all.ctd_stations" for station number, latitude, longitude and depth.'])

    fid = fopen([cruise '.all.ctd_stn_names'],'w');
    for inx = 1:length(goodSTNS)
        fprintf(fid,'%s \n',[N2(inx,:)]);
    end
    fclose(fid);
    disp(['Check "' cruise '.all.stn_names" for station name, date and time.'])
    
    fid = fopen([cruise '.all.dat'],'w');
    fprintf(fid,'%6.1f \n',goodSTNS');
    fclose(fid);
    disp(['Check "' cruise '.all.dat" for listing of all station numbers.'])
    disp(['Type dbcont once files are checked.'])
   keyboard
    PROGRAM = input('Input Program Name (no spaces, caps only): ','s');

%%%% Create mock seabird-esque CNV files but with level 2 processed data

    dupeCNV = PARAMS.dupeCNV; %create Seabird-esque CNV files for each cast with interpolated data.
    addNMEA = PARAMS.addNMEA; %if NMEA was not streamed to the deckbox but you want to create NMEA position header strings (and columns in the csv) based on the header information
    botDep = PARAMS.botDep; %if bottom depth header line was NOT formatted exactly as *Bottom Depth [m]*, this option will fix it to make ODV import of final CNVs smooth
    botFormat = PARAMS.botFor; %full string that was used for bottom depth in your header
    
    if dupeCNV == 1
        dupe_ctd_CNV(cruise,addNMEA,botDep,botFormat);
    end

%%%% Write out CSV Bottle archive for Research Workspace
    compileFORMAT_ctd_BOTTLE(PROGRAM, cruise);
    disp(['Check "' PROGRAM '_' cruise '_ctdBottleData_L2_v1.csv" for merged bottle trips, station names, etc.'])
    disp(['Type dbcont once files are checked.'])
    keyboard

%%%% Write out CSV CTD archive for Research Workspace
 
    fid3 = fopen([PROGRAM '_' cruise '_ctd_L2_v1.csv'],'w');  
    %fprintf(fid3,'%s \r\n',['Cruise,Station,Type,Date_Time,Longitude_[decimal_degrees_east],Latitude_[decimal_degrees_north],Bottom Depth [m],Cast,Pressure_[dbar],Depth_[m],Temperature_[C],Temperature2_[C],Conductivity_[S/m],Conductivity2_[S/m],Voltage0_[V],Voltage1_[V],Voltage2_[V],Voltage3_[V],Voltage4_[V],Voltage5_[V],Voltage6_[V],Voltage7_[V],Fluorescence_[mg/m^3],BeamAttenuation_[1/m],BeamTransmission_[%],Oxygen_[umol/kg],Oxygen_[umol/kg],PAR_[umol_photons/m2/sec],LISST200X,Salinity_[psu],Salinity_[psu],Density_[kg/m3_sigmat],Density_[kg/m3_sigmat], Flag, filename, instrument, platform, LOCAL_CDI_ID']);
    fprintf(fid3, '%s \r\n',['Cruise,Station,Type,Date_Time,Longitude_[decimal_degrees_east],Latitude_[decimal_degrees_north],Bottom Depth [m]' ',' PARAMS.outfmtHead ',' 'filename, instrument, platform, LOCAL_CDI_ID']);
    for in = 1:length(STGD(:,1))
          w = find(Dpro(:,1) == STGD(in,1));
          disp(['Writing Station ' num2str(in)]);
          for in2 = 1:length(w)
                 fprintf(fid3,[outfmtCSV '%s, %s \r\n'],[ cruise ',' strtrim(STATION_NAME(in,:)) ', C, ' STATION_DATE(in,:) ', ' num2str(STGD(in,2)) ', ' num2str(STGD(in,3)) ', ' num2str(STGD(in,4))  ], Dpro(w(in2),:),FIP(in,:),CDI(in,:));
          end
    end 
    fclose(fid3);
    disp(['Check "' PROGRAM '_' cruise '_ctd_L2_v1.csv" for CTD profile data.'])
    disp(['Type dbcont once files are checked.'])
    keyboard

%%%% put datafiles where they belong
    
    % below is hard-coded for Seth's Mac
    % eval(['!cp ' cruise '.all.ctd_stn_names ~/matlabSD/PLOT/Data/' cruise '.all.ctd_stn_names']);
    % eval(['!cp ' cruise '.all.ctd_stations  ~/matlabSD/PLOT/Data/' cruise '.all.ctd_stations']);
    % eval(['!cp ' cruise '.all.ctd_casts     ~/matlabSD/PLOT/Data/' cruise '.all.ctd_casts']);
    % eval(['!cp ' cruise '.all.dat           ~/matlabSD/PLOTS/Transects/' cruise '.all.dat']);
    % disp('Files *.all.* copied to PLOT/Data and PLOTS/Transects as appropriate.')
    
    eval(['!copy ' cruise '.all.ctd_stn_names ' PARAMS.outdir '\' cruise '.all.ctd_stn_names']);
    eval(['!copy ' cruise '.all.ctd_stations '  PARAMS.outdir '\' cruise '.all.ctd_stations']);
    eval(['!copy ' cruise '.all.ctd_casts '     PARAMS.outdir '\' cruise '.all.ctd_casts']);
    eval(['!copy ' cruise '.all.dat '           PARAMS.outdir '\' cruise '.all.dat']);
    disp('Files *.all.* copied to selected output directory as appropriate.')


%%%% Pull out GAK1 profile at standard depths
    ExtractGAK1ctdATstandardDepths(cruise);
else
    disp('No data saved.'); disp(' '); beep;
end
        