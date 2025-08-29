function compile_ctd_BOTTLE(PROGRAM, cruise)

global PARAMS

%BASE_path = ['~/projects/CTD/BTLfiles/']; %Seth's hardcoded path for mac
BASE_path = [PARAMS.indir '/BTLfiles/'];
addpath(BASE_path)

Months = 'JanFebMarAprMayJunJulAugSepOctNovDec';

files = dir(BASE_path);
BTL = [];
for in = 1:length(files)
    if ~isempty(findstr(files(in).name,'.btl')),
        BTL = strvcat(BTL,files(in).name(1:findstr(files(in).name,'.btl')-1));
    end
end

fid3 = fopen([PARAMS.outdir '/' PROGRAM '_' cruise '_ctdBottleData_L2_v1.csv'],'w');
fclose(fid3)

%%%%%%%%%%%%%%%%%%% VARIABLES DERIVED FROM .HDR FILE %%%%%%%%%%%%%%%%%%%%%%

STATIONS = [];
NAMES = [];
STNAME = [];
STGD = [];
fid = fopen([PARAMS.outdir '/' cruise '.hdr'],'r');

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
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% BUILDING CSV SUMMARY FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n] = size(BTL);
hdr = 0;

for in = 1:m
   disp(['File ' num2str(in) ' = ' strtrim(BTL(in,:)) ]);
   D = [];
   fid = fopen([BASE_path deblank(BTL(in,:)) '.btl'],'r');
   fid3 = fopen([PARAMS.outdir '\' PROGRAM '_' cruise '_ctdBottleData_L2_v1.csv'],'a');

   if fid > 0,
   while 1,
       line1 = fgetl(fid);
       if ~isstr(line1), break,end
       if findstr(line1,'Bottle        Date')
          wdate = strfind(line1,'Date'); wdate = wdate + 4;
          wpres = strfind(line1,'PrDM'); wpres = wpres - 4;
          wscan = strfind(line1,'Scan'); wscan = wscan - 4;
           
          header = strtrim(line1(wdate:wscan)); header = strsplit(regexprep(header,'(\s+)',','),',');

          outfmtH = '';
          for ix = 1:length(header)
          % Creating Array of Variable CSV HEADERS for bottle csv summary files
            warning('off','MATLAB:dispatcher:InexactCaseMatch')
            VARrow = startsWith(string(PARAMS.VARIABLEnameFORMATheader),header(:,ix),'IgnoreCase',true);
            VARrow = find(VARrow == 1); VARrow = VARrow(1); 
            if ~isempty(VARrow),
                outfmtH = [outfmtH strtrim(PARAMS.VARIABLEnameFORMATheader(VARrow,62:end)) ','];  % change the 62 if the variable definition array got bigger
            else
                disp(['No corresponding column found for: ' strtrim(COLUMNnames(ix,:))])
                keyboard
            end
          end
          
          hdr = hdr + 1;

          if hdr == 1
                wp = strfind(outfmtH,'Pressure_[dbar]');
                derHead = outfmtH(1:wp-2);
                measHead = outfmtH(wp:end);
                HEADER = ['Cruise,Station,Type,Date_Time,Longitude_[decimal_degrees_east],Latitude_[decimal_degrees_north],Bot. Depth [m],Bottle_Number,Cast_Number' ',' measHead derHead];
                %fid3 = fopen([PARAMS.outdir '\' PROGRAM '_' cruise '_ctdBottleData_L2_v1.csv'],'a');
                fprintf(fid3,'%s\r\n',HEADER);
                %fclose(fid3);
          end
          
       end

       if findstr(line1,'(avg)')
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

            derVar = strtrim(line1(wdate:wpres)); derVar = regexprep(derVar,'(\s+)',','); % derived variables (ex. salinity, sigma-t, sigma-theta)
            measVar = strtrim(line1(wpres:wscan)); measVar = regexprep(measVar,'(\s+)',','); % measured variables (pressure column onwards)
            
            line1c = regexprep(line1,'(\s+)',','); % replace white spaces with commas
            wc = strfind(line1c,',');
            %fprintf(fid3,'%s,%s,%s,%s,%12.6f,%11.6f,%5i,%4i,%3i,%s,%s\r\n',cruise, SNAME, Type, Date_Time, STGD(w,2:4),str2num(line1(1:11)),CSN,line1(69:end-15),line1(25:68) );
            fprintf(fid3,'%s,%s,%s,%s,%12.6f,%11.6f,%5i,%4i,%3i,%s,%s\r\n',cruise, SNAME, Type, Date_Time, STGD(w,2:4),str2num(line1c(wc(1):wc(2))),CSN,measVar,derVar);
        end
   end
   fclose(fid);
   fclose(fid3);
   end
end