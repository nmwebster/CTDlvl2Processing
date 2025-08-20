function compile_ctd_BOTTLE(PROGRAM, cruise)

global PARAMS

%BASE_path = ['~/projects/CTD/BTLfiles/']; %Seth's hardcoded path for mac
BASE_path = [PARAMS.indir '\BTLfiles\'];
addpath BTLfiles

Months = 'JanFebMarAprMayJunJulAugSepOctNovDec';

%keyboard 

files = dir(BASE_path);
BTL = [];
for in = 1:length(files)
    if ~isempty(findstr(files(in).name,'.btl')),
        BTL = strvcat(BTL,files(in).name(1:findstr(files(in).name,'.btl')-1));
    end
end
  
%%%%%%%%%%%%%%%%%%%%%

%HEADER = 'Cruise,Station,Type,Date_Time,Longitude_[decimal_degrees_east],Latitude_[decimal_degrees_north],Bot. Depth [m],Cast_Number,Pressure_[dbar],Bottle_Number,Temperature_[C],Temperature2_[C],Conductivity_[S/m],Conductivity2_[S/m],Voltage0_[V],Voltage1_[V],Voltage2_[V],Voltage3_[V],Voltage4_[V],Voltage5_[V],Voltage6_[V],Voltage7_[V],Fluorescence_[mg/m3],BeamAttenuation_[1/m],BeamTransmission_[%],Oxygen_[umol/kg],Oxygen2_[umol/kg],PAR_[umol_photons/m2/sec],Altimeter_[m],SUNA,LISST,JulianDays_[days],Salinity_[psu],Salinity2_[psu],Density_[kg/m3_sigmat],Density2_[kg/m3_sigmat]';
HEADER = 'Cruise,Station,Type,Date_Time,Longitude_[decimal_degrees_east],Latitude_[decimal_degrees_north],Bot. Depth [m],Bottle_Number,Cast_Number,Pressure_[dbar],Depth_[m],Temperature_[C],Temperature2_[C],Conductivity_[S/m],Conductivity2_[S/m],Voltage0_[V],Voltage1_[V],Voltage2_[V],Voltage3_[V],Voltage4_[V],Voltage5_[V],Voltage6_[V],Voltage7_[V],Fluorescence_[mg/m3],BeamAttenuation_[1/m],BeamTransmission_[%],Oxygen_[umol/kg],Oxygen2_[umol/kg],PAR_[umol_photons/m2/sec],Altimeter_[m],JulianDays_[days],Salinity_[psu],Salinity2_[psu],Density_[kg/m3_sigmat],Density2_[kg/m3_sigmat]';
HEADER = ['Cruise,Station,Type,Date_Time,Longitude_[decimal_degrees_east],Latitude_[decimal_degrees_north],Bot. Depth [m],Bottle_Number' ',' PARAMS.outfmtHead];

   fid3 = fopen([PROGRAM '_' cruise '_ctdBottleData_L2_v1.csv'],'w');
   fprintf(fid3,'%s\r\n',HEADER)
   fclose(fid3);
   [m,n] = size(BTL);

    STATIONS = [];
    NAMES = [];
    STNAME = [];
    STGD = [];
    fid = fopen([cruise '.hdr'],'r');
   
    while ~0, 
        line1 = fgetl(fid);
        if ~isstr(line1), break, end
        if isempty(strfind(line1(1),'%')),
        coms = findstr(line1,',');
       % DATE1 = datenum(['0' line1(coms(2)+1:coms(4)-1)],'mm/dd/yyyy,HH:MM:SS');
       % DATE2 = datestr(DATE1,'mmm dd yyyy HH:MM:SS');
       DATE2 = line1(coms(2)+1:coms(3)-1);
       DATE2 = strtrim(DATE2);
       ST = [str2num(line1(1:coms(1)-1)) str2num(line1(coms(4)+1:coms(5)-1)) str2num(line1(coms(3)+1:coms(4)-1)) str2num(line1(coms(5)+1:coms(6)-1))];

       if length(ST) == 4,
            STATIONS = [STATIONS; str2num(line1(1:coms(1)-1)) str2num(line1(coms(4)+1:coms(5)-1)) str2num(line1(coms(3)+1:coms(4)-1)) str2num(line1(coms(5)+1:coms(6)-1))];
       else
            STATIONS = [STATIONS; str2num(line1(1:coms(1)-1)) str2num(line1(coms(4)+1:coms(5)-1)) str2num(line1(coms(3)+1:coms(4)-1)) NaN];
       end
       
        NAMES = strvcat(NAMES,[line1(coms(1)+1:coms(2)-1) ' ' DATE2]);
        STNAME = strvcat(STNAME, line1(coms(1)+1:coms(2)-1));
        STGD = [STGD; STATIONS(end,:) str2num(datestr(datenum(DATE2),'yyyy mm dd HH MM SS'))];
        DATE1 = []; DATE2 = [];
        end
    end
    fclose(fid); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for in = 1:m
   disp(['File ' num2str(in) ' = ' strtrim(BTL(in,:)) ]);
   D = [];
   fid = fopen([BASE_path deblank(BTL(in,:)) '.btl'],'r');
   fid3 = fopen([PROGRAM '_' cruise '_ctdBottleData_L2_v1.csv'],'a');

   if fid > 0,
   while 1,
       line1 = fgetl(fid);
       if ~isstr(line1), break,end
       if findstr(line1,'(avg)'),
            line2 = fgetl(fid); 
            line3 = fgetl(fid); 
            line4 = fgetl(fid); 
 
            CSN = str2num(BTL(in,end-2:end));

            w = find(STATIONS(:,1) == CSN);

            Date_Time = datestr(datenum(STGD(w,5:10)),31);
            Date_Time(11) = 'T';
            Type = 'B';
            SNAME = strtrim(STNAME(w,:));
            wx = strfind(SNAME,' ');
            wy = setxor(1:length(SNAME), wx);
            SNAME = SNAME(wy);
            
            line1c = regexprep(line1,'(\s+)',','); % replace white spaces with commas
            wc = strfind(line1c,',');
            
            %keyboard
            %fprintf(fid3,'%s,%s,%s,%s,%12.6f,%11.6f,%5i,%4i,%3i,%s,%s\r\n',cruise, SNAME, Type, Date_Time, STGD(w,2:4),str2num(line1(1:11)),CSN,line1(69:end-15),line1(25:68) );
            fprintf(fid3,'%s,%s,%s,%s,%12.6f,%11.6f,%5i,%4i,%3i,%s,%s\r\n',cruise, SNAME, Type, Date_Time, STGD(w,2:4),str2num(line1c(wc(1):wc(2))),CSN,line1c(wc(9)+1:wc(end-1)-1),line1c(wc(5)+1:wc(9)-1));
        end
   end
   fclose(fid);
   fclose(fid3);
   end
end