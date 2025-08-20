function [header, data]= sbehead(file)
%function [header, data]= awihead(file)
% **** lesen eines AWI-Headers ****
% "file" ist ein String mit dem Namen der Datei
%        aus der die Daten gelesen werden sollen.
% header ist ein Textarray mit den Header Informationen
% data ist die eine Matrix mit den Daten


fid = fopen(file);

header = [];
data = [];
foundEND = 0;
while 1,
   line1 = fgetl(fid)
   if ~ischar(line1), break, end
   if ~foundEND,
       header = char(header, line1);
        if ~isempty(findstr(line1,'END')),
             foundEND = 1;
         end
   else
       data = char(data,line1);
   end
end

data = str2num(data);

fclose(fid);