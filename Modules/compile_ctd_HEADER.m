function compile_ctd_header(ship,cruise,marker,pi,projectname,agency,region,DQflag,DistributeFlag);

BASE_path = ['C:\projects\GLOBEC\CRUISES\' ship num2str(cruise) marker '\ctd\convertedprocessed\'];

files = dir(BASE_path);
CNV = [];
firstTIME = 1;
downcastONLY = 1;
for in = 1:length(files)
    if ~isempty(findstr(files(in).name,'.cnv')),
        CNV = strvcat(CNV,files(in).name(1:findstr(files(in).name,'.cnv')-1));
    end
end

[m,n] = size(CNV);
for in = 1:m
   D = ['SBE911+,']; 
   R = ['instrument,']; 
   F = ['character(6),'];
    botdep = 'NaN';
   file = deblank(CNV(in,:));
   fid = fopen([BASE_path file '.cnv'],'r');
   lon = 0;
   lat = 0;
   gmttime = 0;
   GMTTIME = [];
   if fid > 0,
   while 1,
       line1 = fgetl(fid);
       	if ~isstr(line1), break,end
       	if findstr(line1,'NMEA Latitude'), lon = 1; D = [D num2str(str2num(line1(19:20)) + str2num(line1(21:length(line1)-2))/60) ',']; R = [R ' lat,'];  F = [F ' double precision,']; end
       	if findstr(line1,'NMEA Longitude'), lat = 1; D = [D num2str(-str2num(line1(20:22)) - str2num(line1(23:length(line1)-2))/60) ',']; R = [R ' long,'];  F = [F ' double precision,']; end
       	if findstr(line1,'NMEA UTC (Time)'), gmttime = 1; D = [D line1(20:length(line1)) ',']; R = [R ' start_time,'];  F = [F ' time,']; end
       	if findstr(line1,'System UpLoad'), GMTTIME = line1(35:end);  D = [D line1(23:34) ',']; R = [R ' start_date,'];  F = [F ' date,']; end
        if findstr(lower(line1),'station'), 
            stnBLNK = findstr(line1,':'); 
            stnnm = deblank(upper(line1(stnBLNK+1:length(line1))))
            stnBLNK = findstr(stnnm,' '); 
            if ~isempty(stnBLNK),
                stnnm = stnnm(setxor(stnBLNK,1:length(stnnm)))
            end
        end
       	if findstr(lower(line1),'sonic'), Cp = findstr(line1,':'); botdep = line1(Cp+1:length(line1)); end
       	if findstr(lower(line1),'bottom depth'), Cp = findstr(line1,':'); botdep = line1(Cp+1:length(line1)); end
            
           
   end
     fclose(fid);
 
    if ~lon,
        D = [D ,'-99.9999,']; R = [R ' lat,'];  F = [F ' double precision,']; 
    end
    if ~lat,
        D = [D ,' -999.9999,']; R = [R ' long,'];  F = [F ' double precision,']; 
    end
    if ~gmttime,
        D = [D , ' ' GMTTIME ',']; R = [R ' start_time,'];  F = [F ' time,']; 
    end
    
	 % for hx cruise: 
     D = [D upper(ship(1:2)) ',' upper(ship) num2str(cruise) marker ',' stnnm ',' CNV(in,end-2:end) ',' botdep ', Weingartner, LTOP, NPRB, Gulf of Alaska, n, n']
	 %D = [D upper(ship(1:2)) ',' upper(ship) num2str(cruise) marker ',' stnnm ',' CNV(in,1:end) ',' botdep ', Weingartner, LTOP, NPRB, Gulf of Alaska, n, n'];
	 R = [R 'ship, cruise, sta_name, consec_sta, sonic_depth, pi, project, funding_agen, area, dqflag, distribute'];
 	 F = [F 'character(2), character(8), character(10), integer, character(4), character(20), character(20), character(40), character(20), character(30), character(30)'];
     fid = fopen([ship num2str(cruise) marker 'hdr.dat'],'a');
     fprintf(fid,'%s\n',D);
     fclose(fid);
 
     fid = fopen([ship num2str(cruise) marker 'hdr.fmt'],'a');
     fprintf(fid,'%s\n',R);
     fprintf(fid,'%s\n',F);
     fclose(fid);
    end

end

