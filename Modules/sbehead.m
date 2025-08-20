function [header, data]= sbehead(file)
%function [header, data]= awihead(file)
% **** lesen eines AWI-Headers ****
% "file" ist ein String mit dem Namen der Datei
%        aus der die Daten gelesen werden sollen.
% header ist ein Textarray mit den Header Informationen
% data ist die eine Matrix mit den Daten

if nargin < 1
   error(' Funktion benoetigt nur 1 Eingabeargument ');
elseif ~isstr(file)
   error(' Eingabeargument muss ein String sein !!');
   end;
fid = fopen(file);
if fid==-1
   error('File nicht gefunden ? Pfad ? ');
   end;
ncols=0;
data=[];

% lesen bis ' #' Zeichen
no_line  = 0;
max_line = 0;
ex       = 0.1;
while(ex <1);
     str      = fgetl(fid);
     junk       = findstr(str,'END');
     ex = max([junk ex]);
     no_line  = no_line+1;
     max_line = max([max_line, length(str)]);
     eval(['str',num2str(no_line),'=str;']);
     end;

% Header schreiben
header = setstr(' '*ones(no_line, max_line));
  
for i=1 : no_line
    varname = ['str' num2str(i)];
    if ~isempty(eval(varname)),
        eval(['header(i, 1:length(' varname ')) = ' varname ';']);
    else
        eval(['header(i, 1:length(' varname ')) = ['' ''];']);        
    end
end
 
% Datenlesen
line         = fgetl(fid);
[data ncols] = sscanf(line,'%f');
data         = [data; fscanf(fid,'%f')];
eval ('data = reshape(data,ncols, length(data)/ncols)'';', '');

fclose(fid);
