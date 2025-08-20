function compile_ctd_BOTTLE(cruise)

global PARAMS

%BASE_path = ['~/projects/CTD/BTLfiles/']; Seth hardcoded path for his mac
BASE_path = [PARAMS.indir '\BTLfiles\'];

Months = 'JanFebMarAprMayJunJulAugSepOctNovDec';

files = dir(BASE_path);
BTL = [];
for in = 1:length(files)
    if ~isempty(findstr(files(in).name,'.btl')),
        BTL = strvcat(BTL,files(in).name(1:findstr(files(in).name,'.btl')-1));
    end
end
 
   fid2 = fopen([cruise '_bottles.all'],'w');
   fclose(fid2);
   [m,n] = size(BTL);

for in = 1:m
   disp(['File ' num2str(in) ' = ' strtrim(BTL(in,:)) ]);
   D = [];
   fid = fopen([BASE_path deblank(BTL(in,:)) '.btl'],'r');
   fid2 = fopen([cruise '_bottles.all'],'a');
   if fid > 0,
   while 1,
       line1 = fgetl(fid);
       if ~isstr(line1), break,end
       if findstr(line1,'(avg)'),
            line2 = fgetl(fid); 
            line3 = fgetl(fid); 
            line4 = fgetl(fid); 
            fprintf(fid2,'%s %s\n',[BTL(in,end-2:end) ],line1);
            fprintf(fid2,'%s %s\n',[BTL(in,end-2:end) ],line2);
            fprintf(fid2,'%s %s\n',[BTL(in,end-2:end) ],line3);
            fprintf(fid2,'%s %s\n',[BTL(in,end-2:end) ],line4);
       end
   end
   fclose(fid);
   fclose(fid2);
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fid3 = fopen([cruise '_bottleTrips.dat'],'w');
   fclose(fid3);
   [m,n] = size(BTL);

for in = 1:m
   disp(['File ' num2str(in) ' = ' strtrim(BTL(in,:)) ]);
   D = [];
   fid = fopen([BASE_path deblank(BTL(in,:)) '.btl'],'r');
   fid3 = fopen([cruise '_bottleTrips.dat'],'a');
   if fid > 0,
   while 1,
       line1 = fgetl(fid);
       if ~isstr(line1), break,end
       if findstr(line1,'(avg)'),
            line2 = fgetl(fid); 
            line3 = fgetl(fid); 
            line4 = fgetl(fid); 
        %    fprintf(fid3,'%s %s\n',[BTL(in,end-2:end) ],[line1(1:11) datestr(datenum([line1(12:22) line2(14:24)]),'yyyy mm dd HH MM SS') line1(69:end-14) line1(25:68)] );
            fprintf(fid3,'%s %s\n',[BTL(in,:) ],[line1(1:11) datestr(datenum([line1(12:22) line2(14:24)]),'yyyy mm dd HH MM SS') line1(69:end-14) line1(25:68)] );
  %     keyboard 
       end
   end
   fclose(fid);
   fclose(fid3);
   end
end

