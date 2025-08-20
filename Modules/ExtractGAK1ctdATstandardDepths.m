function ExtractGAL1ctdATstandardDepths(cruise)

global PARAMS

cruise = deblank(cruise);

fid = fopen([cruise '_newGAK1.dat'],'w');
fclose(fid);

for in = 1:1
    fid = fopen([PARAMS.outdir '\' cruise '.all.ctd_stn_names'],'r');
    fid2 = fopen([PARAMS.outdir '\' cruise '.all.ctd_stations'],'r');
    CS = [];
    YR = [];
    MO = [];
    DY = [];  
    HR = [];
    MI = [];
    SE = [];
    FY = [];

    while 1,
        line1 = fgetl(fid);
        line2 = fgetl(fid2);
 
        if ~isstr(line1), break,end
        line1 = strtrim(line1);
        
        blnks = findstr(line1,' ');
        if blnks(1) >= 4, 
            blnkstop = blnks(1);
        else
            blnkstop = 8;
        end
        if strcmp(fliplr(deblank(fliplr(deblank(line1(1:blnkstop))))),'GAK1'),
            
            line1 = strtrim(line1);
            where = findstr(line1,' ');
            theDATE = strtrim(line1(where(1):end));
            DN = datenum(theDATE);
            DS = datestr(DN,'yyyy mm dd HH MM SS');
            DS = str2num(DS);
            YR = DS(1);
            MO = DS(2);
            DY = DS(3);
            HR = DS(4);
            MI = DS(5);
            SE = DS(6);
            
            line2 = str2num(line2);  
            CS = [CS; line2(1)];
            
            bl = ones(size(MO));
            year_jdate = julian([YR+1 bl bl 0*bl 0*bl 0*bl]) - julian([YR bl bl 0*bl 0*bl 0*bl]);
            ctd_jdate = julian([YR MO DY HR MI SE]) - julian([YR bl bl 0*bl 0*bl 0*bl]);
            frac_year = YR + ctd_jdate./year_jdate;
            
            FY = [FY; frac_year];
        end
    end
    fclose(fid);
    fclose(fid2);

    eval(['load ' PARAMS.outdir '\' cruise '.all.ctd_casts']);
    eval(['D = ' cruise '_all;']);
     
    LEVEL = [0 10 20 30 50 75 100 150 200 250];
    
    for inx = 1:length(CS),
          where = find(D(:,1) == CS(inx));
          DD = D(where,:);
          Sigt = sw_dens0(DD(:,4), DD(:,3))-1000; % sigma-t goes into database, not sigma-theta
          DelD = sw_gpan(DD(:,4), DD(:,3),DD(:,2))/10;
          DD(:,5:6) = [Sigt DelD];
          for iny = 1:length(LEVEL)
              where = find(DD(:,2) == LEVEL(iny));
              if ~isempty(where),
                  fid = fopen([cruise '_newGAK1.dat'],'a');
                  fprintf(fid,'%10.5f, %5.1f, %6.3f, %6.3f, %6.3f, %9.6f, %16s, %3i  \n',FY(inx),LEVEL(iny),DD(where,3:6),['% ' upper(cruise)],CS(inx));
                  fclose(fid);
              end
          end
    end
end
