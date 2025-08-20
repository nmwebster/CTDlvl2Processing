function ctdstatic_create_settings_file

global CTDstatic

fileName = CTDstatic.paramFileOut;
filePath = CTDstatic.paramPathOut;

fileTxT = strrep(fileName,'.m','.txt');
fileID = fopen(fullfile(filePath,fileTxT),'w');

% Write settings file
fprintf(fileID,'%% Settings Script for CTD Project Processing\n\n');

fprintf(fileID,'%% DIRECTORY INFORMATION \n\n');
fprintf(fileID,'PARAMS.indir = ''%s'';\n',CTDstatic.verify.indir.String);
fprintf(fileID,'PARAMS.outdir = ''%s'';\n',CTDstatic.verify.outdir.String);
fprintf(fileID,'PARAMS.outafname = ''%s'';\n',CTDstatic.verify.outafname.String);
fprintf(fileID,'PARAMS.outhfname = ''%s'';\n\n',CTDstatic.verify.outhfname.String);

fprintf(fileID,'CTDstatic.indir = ''%s'';\n',CTDstatic.verify.indir.String);
fprintf(fileID,'CTDstatic.outdir = ''%s'';\n',CTDstatic.verify.outdir.String);
fprintf(fileID,'CTDstatic.outafname = ''%s'';\n',CTDstatic.verify.outafname.String);
fprintf(fileID,'CTDstatic.outhfname = ''%s'';\n\n\n',CTDstatic.verify.outhfname.String);


fprintf(fileID,'%% CTD STATIC PARAMETERS \n\n');
fprintf(fileID,'PARAMS.vess = ''%s'';\n',CTDstatic.verify.vess.String);
fprintf(fileID,'PARAMS.cruise = ''%s'';\n',CTDstatic.verify.cruise.String);
fprintf(fileID,'PARAMS.project = ''%s'';\n',CTDstatic.verify.project.String);
fprintf(fileID,'PARAMS.instrument = ''%s'';\n',CTDstatic.verify.instrument.String);
fprintf(fileID,'PARAMS.pi = ''%s'';\n',CTDstatic.verify.pi.String);
fprintf(fileID,'PARAMS.agency = ''%s'';\n',CTDstatic.verify.agency.String);
fprintf(fileID,'PARAMS.region = ''%s'';\n',CTDstatic.verify.region.String);
fprintf(fileID,'PARAMS.datares = ''%s'';\n',CTDstatic.verify.datares.String);
fprintf(fileID,'PARAMS.timeoff = %1i;\n',str2num(CTDstatic.verify.timeoff.String));
fprintf(fileID,'PARAMS.year = %1i ;\n',str2num(CTDstatic.verify.year.String));
fprintf(fileID,'PARAMS.updown = %1i ;\n',CTDstatic.verify.updown.Value);
fprintf(fileID,'PARAMS.interp = %1i ;\n',CTDstatic.verify.interp.Value);
fprintf(fileID,'PARAMS.extrap = %1i ;\n',CTDstatic.verify.extrap.Value);
fprintf(fileID,'PARAMS.eps = %1i ;\n',CTDstatic.verify.eps.Value);
fprintf(fileID,'PARAMS.png = %1i ;\n',CTDstatic.verify.png.Value);
fprintf(fileID,'PARAMS.compbot = %1i ;\n',CTDstatic.verify.compbot.Value);
fprintf(fileID,'PARAMS.compcnv = %1i ;\n',CTDstatic.verify.compcnv.Value);
fprintf(fileID,'PARAMS.pltsel = %1i ;\n',CTDstatic.verify.pltsel.Value);
fprintf(fileID,'PARAMS.nROW = %1i ;\n',str2num(CTDstatic.verify.nROW.String));
fprintf(fileID,'PARAMS.nCOL = %1i ;\n',str2num(CTDstatic.verify.nCOL.String));
fprintf(fileID,'PARAMS.maxPRESSURE = %1i ;\n',str2num(CTDstatic.verify.maxPRESSURE.String));
fprintf(fileID,'PARAMS.nROW_SS = %1i ;\n',str2num(CTDstatic.verify.nROW_SS.String));
fprintf(fileID,'PARAMS.nCOL_SS = %1i ;\n',str2num(CTDstatic.verify.nCOL_SS.String));
fprintf(fileID,'PARAMS.maxPRESSURE_SS = %1i ;\n',str2num(CTDstatic.verify.maxPRESSURE_SS.String));
fprintf(fileID,'PARAMS.SSsel = %1i ;\n',CTDstatic.verify.SSsel.Value);
fprintf(fileID,'PARAMS.UPdown_SS = %1i ;\n',str2num(CTDstatic.verify.UPdown_SS.String));
fprintf(fileID,'PARAMS.dupeCNV = %1i ;\n',CTDstatic.verify.dupeCNV.Value);
fprintf(fileID,'PARAMS.addNMEA = %1i ;\n',CTDstatic.verify.addNMEA.Value);
fprintf(fileID,'PARAMS.botDep = %1i ;\n',CTDstatic.verify.botDep.Value);
fprintf(fileID,'PARAMS.botFor = ''%s'' ;\n',CTDstatic.verify.botFor.String);
fprintf(fileID,'PARAMS.depLat = ''%s'' ;\n',CTDstatic.verify.depLat.String);
fprintf(fileID,'PARAMS.pltDat = %1i ;\n',str2num(CTDstatic.verify.pltDat.String));
if ~isempty(CTDstatic.verify.excluDat.String)
    fprintf(fileID,'PARAMS.excluDat = %1i ;\n',str2num(CTDstatic.verify.excluDat.String));
end

fprintf(fileID,'CTDstatic.vess = ''%s'';\n',CTDstatic.verify.vess.String);
fprintf(fileID,'CTDstatic.cruise = ''%s'';\n',CTDstatic.verify.cruise.String);
fprintf(fileID,'CTDstatic.project = ''%s'';\n',CTDstatic.verify.project.String);
fprintf(fileID,'CTDstatic.instrument = ''%s'';\n',CTDstatic.verify.instrument.String);
fprintf(fileID,'CTDstatic.pi = ''%s'';\n',CTDstatic.verify.pi.String);
fprintf(fileID,'CTDstatic.agency = ''%s'';\n',CTDstatic.verify.agency.String);
fprintf(fileID,'CTDstatic.region = ''%s'';\n',CTDstatic.verify.region.String);
fprintf(fileID,'CTDstatic.datares = ''%s'';\n',CTDstatic.verify.datares.String);
fprintf(fileID,'CTDstatic.timeoff = %1i;\n',str2num(CTDstatic.verify.timeoff.String));
fprintf(fileID,'CTDstatic.year = %1i ;\n',str2num(CTDstatic.verify.year.String));
fprintf(fileID,'CTDstatic.updown = %1i ;\n',CTDstatic.verify.updown.Value);
fprintf(fileID,'CTDstatic.interp = %1i ;\n',CTDstatic.verify.interp.Value);
fprintf(fileID,'CTDstatic.extrap = %1i ;\n',CTDstatic.verify.extrap.Value);
fprintf(fileID,'CTDstatic.eps = %1i ;\n',CTDstatic.verify.eps.Value);
fprintf(fileID,'CTDstatic.png = %1i ;\n',CTDstatic.verify.png.Value);
fprintf(fileID,'CTDstatic.compbot = %1i ;\n',CTDstatic.verify.compbot.Value);
fprintf(fileID,'CTDstatic.compcnv = %1i ;\n',CTDstatic.verify.compcnv.Value);
fprintf(fileID,'CTDstatic.pltsel = %1i ;\n',CTDstatic.verify.pltsel.Value);
fprintf(fileID,'CTDstatic.nROW = %1i ;\n',str2num(CTDstatic.verify.nROW.String));
fprintf(fileID,'CTDstatic.nCOL = %1i ;\n',str2num(CTDstatic.verify.nCOL.String));
fprintf(fileID,'CTDstatic.maxPRESSURE = %1i ;\n',str2num(CTDstatic.verify.maxPRESSURE.String));
fprintf(fileID,'CTDstatic.nROW_SS = %1i ;\n',str2num(CTDstatic.verify.nROW_SS.String));
fprintf(fileID,'CTDstatic.nCOL_SS = %1i ;\n',str2num(CTDstatic.verify.nCOL_SS.String));
fprintf(fileID,'CTDstatic.maxPRESSURE_SS = %1i ;\n',str2num(CTDstatic.verify.maxPRESSURE_SS.String));
fprintf(fileID,'CTDstatic.SSsel = %1i ;\n',CTDstatic.verify.SSsel.Value);
fprintf(fileID,'CTDstatic.UPdown_SS = %1i ;\n',str2num(CTDstatic.verify.UPdown_SS.String));
fprintf(fileID,'CTDstatic.dupeCNV = %1i ;\n',CTDstatic.verify.dupeCNV.Value);
fprintf(fileID,'CTDstatic.addNMEA = %1i ;\n',CTDstatic.verify.addNMEA.Value);
fprintf(fileID,'CTDstatic.botDep = %1i ;\n',CTDstatic.verify.botDep.Value);
fprintf(fileID,'CTDstatic.botFor = ''%s'' ;\n',CTDstatic.verify.botFor.String);
fprintf(fileID,'CTDstatic.depLat = ''%s'' ;\n',CTDstatic.verify.depLat.String);
fprintf(fileID,'CTDstatic.pltDat = %1i ;\n',str2num(CTDstatic.verify.pltDat.String));
if ~isempty(CTDstatic.verify.excluDat.String)
    fprintf(fileID,'CTDstatic.excluDat = %1i ;\n\n\n',str2num(CTDstatic.verify.excluDat.String));
end

fclose(fileID);

% Rename File to Create M File
movefile(fullfile(filePath,fileTxT),fullfile(filePath,fileName), 'f')