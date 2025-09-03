function dupe_ctd_CNV(cruise,addNMEA,botDep,botFormat)

% To create dupe CNV files that model Level 1 CNV files produced by SBE
% Data Processing, but use Level 2 corrected data. For easy importation
% into ODV software.

% cruise = 'ISC202306NPSOC';
% addNMEA = 1; 
% botDep = 1;
% botFormat = 'Bottom Depth';

global PARAMS
BASE_path = [PARAMS.outdir '/'];
%addpath CNVfiles
if not(isfolder([PARAMS.outdir '/CNVdupeLvl2']))
    mkdir([PARAMS.outdir '/CNVdupeLvl2'])
end
addpath([PARAMS.outdir '/CNVdupeLvl2']);

a = dir([PARAMS.outdir '/CNVfiles/*.cnv']); % find all .cnv files in the subdirectory CNVfiles

bigData = [cruise '.ascii'];
D = load(bigData,"-ascii");

for INfile = 1:length(a) % loop through each file
    FILEtitle = a(INfile).name; % name of the file to work on
    fid1 = fopen([PARAMS.indir '/CNVfiles/' FILEtitle],'r');

    OUTfile = ([BASE_path 'CNVdupeLvl2/' FILEtitle]);
    fid2 = fopen(OUTfile,'a');

    [H,~] = sbehead([BASE_path '/CNVfiles/' FILEtitle]); % read in header (H) and data (D) from .cnv file
    [m,n] = size(H);
    while 1
         lineIN = fgetl(fid1);
         if ~isstr(lineIN), break, end
         if findstr(lineIN,'*END*'), fprintf(fid2,'%s \r\n',lineIN); break, end

         if findstr(lineIN,'System UpLoad Time')      %something to indentify the line before the NMEA string lines
             if addNMEA
                fprintf(fid2,'%s \r\n',lineIN); % print the line before the NMEA string lines
                
                for XY = 1:m                        % extract lat/long from header info
                                      
                    w = findstr(H(XY,:),' ');
                    
                    if findstr(H(XY,:),'Latitude') % look for the Latitude row                      
                        lat = str2num(H(XY,w(2):end));
                        deg = floor(lat);
                        min = (lat - abs(deg))*60;
                        if deg > 0
                            compass = 'N';
                        else
                            compass = 'S';
                        end
                        latstr = (['* NMEA Latitude = ' num2str(abs(deg)) ' ' num2str(min) ' ' compass]);
                    end
                    
                    if findstr(H(XY,:),'Longitude') % look for the Longitude row
                        long = str2num(H(XY,w(2):end));
                        deg = floor(abs(long));
                        %deg = -floor(long); %use this one for ISC202306NPSOC b/c forgot negatives when typing longitudes
                        min = (abs(long) - abs(deg))*60;
                        if long > 0
                            compass = 'E';
                        else
                            compass = 'W';
                        end
                        %keyboard
                        longstr = (['* NMEA Longitude = ' num2str(abs(deg)) ' ' num2str(min) ' ' compass]);
                    end

                    if findstr(H(XY,:),'System UpLoad Time')
                        date = H(XY,w(5)+1:w(8)-1);
                        time = H(XY,w(8)+1:end);
                        timestr =(['* NMEA UTC (Time) = ' date '  ' time]);
                    end
                end
                fprintf(fid2,'%s \r\n',latstr);
                fprintf(fid2,'%s \r\n',longstr);
                fprintf(fid2,'%s \r\n',timestr);
             end
         elseif findstr(lineIN,botFormat)
            if botDep
               lineIN = strrep(lineIN,botFormat,'Bottom Depth [m]:');
            end
            fprintf(fid2,'%s \r\n',lineIN);       
         else   % for all other header lines
             fprintf(fid2,'%s \r\n',lineIN);
         end
    end
    
    wcast = find(D(:,1) == INfile);
    castData = D(wcast,2:end);
    %fprintf(fid2,'%9.3f %9.3f %8.4f %8.4f %9.6f %9.6f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %9.3f %8.4f %9.3f %9.3f %9.3f %8.3f %10.6f %8.4f %8.4f %9.6f %9.6f %8.4f\n',castData');
    fprintf(fid2,PARAMS.outfmt(5:end),castData'); % start at position 5 because the CSN isn't output in these dupe files so no %4i to start off

end

fclose(fid1);
fclose(fid2);