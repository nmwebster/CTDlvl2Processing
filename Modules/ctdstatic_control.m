function ctdstatic_control(action)
% Do something in response to GUI window update action:

global CTDstatic PARAMS

if strcmp(action, '')

% Change Directory Settings:

elseif strcmp(action,'indirSel')
    CTDstatic.verify.indir.String = uigetdir(CTDstatic.indir,'Select Directory With CTD Files');
    CTDstatic.indir = CTDstatic.verify.indir.String;
    PARAMS.indir = CTDstatic.verify.indir.String;

elseif strcmp(action,'outdirSel')
    CTDstatic.verify.outdir.String = uigetdir(CTDstatic.outdir,'Select Directory for LTSA Output Files');
    CTDstatic.outdir = CTDstatic.verify.outdir.String;
    PARAMS.outdir = CTDstatic.verify.outdir.String;

% Directory Settings:

elseif strcmp(action,'setindir')
    PARAMS.indir = get(CTDstatic.verify.indir,'String');

elseif strcmp(action,'setoutdir')
    PARAMS.outdir = get(CTDstatic.verify.outdir, 'String');

elseif strcmp(action,'setoutafname')
    PARAMS.outafname = get(CTDstatic.verify.outafname, 'String');

elseif strcmp(action,'setouthfname')
    PARAMS.outhfname = get(CTDstatic.verify.outhfname, 'String');


% First Column Settings:

elseif strcmp(action,'setvess')
    PARAMS.vess = get(CTDstatic.verify.vess,'String');

elseif strcmp(action,'setcruise')
    PARAMS.cruise = get(CTDstatic.verify.cruise,'String');

elseif strcmp(action,'setproject')
    PARAMS.project = get(CTDstatic.verify.project,'String');

elseif strcmp(action,'setinstrument')
    PARAMS.instrument = get(CTDstatic.verify.instrument,'String');

elseif strcmp(action,'setpi')
    PARAMS.pi = get(CTDstatic.verify.pi,'String');

% Second Column Settings:

elseif strcmp(action,'setagency')
    PARAMS.agency = get(CTDstatic.verify.agency,'String');

elseif strcmp(action,'setregion')
    PARAMS.region = get(CTDstatic.verify.region,'String');

elseif strcmp(action,'setdatares')
    PARAMS.datares = get(CTDstatic.verify.datares,'String');

elseif strcmp(action,'settimeoff')
    PARAMS.timeoff = str2num(get(CTDstatic.verify.timeoff,'String'));

elseif strcmp(action,'setyear')
    PARAMS.year = str2num(get(CTDstatic.verify.year,'String'));

% Option settings
elseif strcmp(action,'setupdown')
    PARAMS.updown = get(CTDstatic.verify.updown,'Value');

elseif strcmp(action,'setinterp')
    PARAMS.interp = get(CTDstatic.verify.interp,'Value');
    if CTDstatic.verify.interp.Value == 1
        CTDstatic.verify.interpOp.Visible = 'on';
        CTDstatic.verify.dupeCNV.Visible = 'on';
        CTDstatic.verify.dupeCNVTxt.Visible = 'on';
        CTDstatic.verify.interpOpTxt.Visible = 'on';
        CTDstatic.verify.addNMEA.Visible = 'on';
        CTDstatic.verify.addNMEATxt.Visible = 'on';  
        CTDstatic.verify.botDep.Visible = 'on';
        CTDstatic.verify.botDepTxt.Visible = 'on';
        CTDstatic.verify.botFor.Visible = 'on';
        CTDstatic.verify.botForTxt.Visible = 'on';
    else
        CTDstatic.verify.interpOp.Visible = 'off';
        CTDstatic.verify.dupeCNV.Visible = 'off';
        CTDstatic.verify.dupeCNVTxt.Visible = 'off';
        CTDstatic.verify.interpOpTxt.Visible = 'off';
        CTDstatic.verify.addNMEA.Visible = 'off';
        CTDstatic.verify.addNMEATxt.Visible = 'off';
        CTDstatic.verify.botDep.Visible = 'off';
        CTDstatic.verify.botDepTxt.Visible = 'off';
        CTDstatic.verify.botFor.Visible = 'off';
        CTDstatic.verify.botForTxt.Visible = 'off';
    end

elseif strcmp(action,'setdupeCNV')
    PARAMS.dupeCNV = get(CTDstatic.verify.dupeCNV,'Value');

elseif strcmp(action,'setaddNMEA')
    PARAMS.addNMEA = get(CTDstatic.verify.addNMEA,'Value');

elseif strcmp(action,'setbotDep')
    PARAMS.botDep = get(CTDstatic.verify.botDep,'Value');

elseif strcmp(action,'setbotFor')
    PARAMS.botDep = get(CTDstatic.verify.botFor,'String');

elseif strcmp(action,'setextrap')
    PARAMS.extrap = get(CTDstatic.verify.extrap,'Value');

elseif strcmp(action,'seteps')
    PARAMS.eps = get(CTDstatic.verify.eps,'Value');

elseif strcmp(action,'setpng')
    PARAMS.png = get(CTDstatic.verify.png,'Value');    

elseif strcmp(action,'setcompbot')
    PARAMS.compbot = get(CTDstatic.verify.compbot,'Value'); 

elseif strcmp(action,'setcompcnv')
    PARAMS.compcnv = get(CTDstatic.verify.compcnv,'Value'); 

elseif strcmp(action,'setpltsel')
    PARAMS.pltsel = get(CTDstatic.verify.pltsel,'Value'); 

elseif strcmp(action,'setnROW')
    PARAMS.nROW = str2num(get(CTDstatic.verify.nROW,'String'));

elseif strcmp(action,'setnROW_SS')
    PARAMS.nROW_SS = str2num(get(CTDstatic.verify.nROW_SS,'String'));

elseif strcmp(action,'setnCOL')
    PARAMS.nCOL = str2num(get(CTDstatic.verify.nCOL,'String'));

elseif strcmp(action,'setnCOL_SS')
    PARAMS.nCOL_SS = str2num(get(CTDstatic.verify.nCOL_SS,'String'));

elseif strcmp(action,'setmaxPRESSURE')
    PARAMS.maxPRESSURE = str2num(get(CTDstatic.verify.maxPRESSURE,'String'));

elseif strcmp(action,'setmaxPRESSURE_SS')
    PARAMS.maxPRESSURE_SS = str2num(get(CTDstatic.verify.maxPRESSURE_SS,'String'));

elseif strcmp(action,'setSSsel')
    PARAMS.SSsel = get(CTDstatic.verify.SSsel,'Value');

elseif strcmp(action,'setUPdown_SS')
    PARAMS.UPdown_SS = str2num(get(CTDstatic.verify.UPdown_SS,'String'));

elseif strcmp(action,'setdepLat')
    PARAMS.depLat = str2num(get(CTDstatic.verify.depLat,'String'));

elseif strcmp(action,'setpltDat')
    PARAMS.pltDat = str2num(get(CTDstatic.verify.pltDat,'String'));

elseif strcmp(action,'setexcluDat')
    PARAMS.excluDat = str2num(get(CTDstatic.verify.excluDat,'String'));

% Running data:

elseif strcmp(action,'rundata')
    close(CTDstatic.fig)
    compileCTD;
    
% Loading settings:

elseif strcmp(action,'ctdstatic_settingsLoad')
    thisPath = mfilename('fullpath');
    settingsPath = fullfile(fileparts(fileparts(thisPath)));
        %'settings');% User interface retrieve file to open through a dialog box.
    dialogTitle1 = 'Open CTD Project Settings File';
    
    [CTDstatic.paramFile,CTDstatic.paramPath] = ...
        uigetfile(fullfile(settingsPath,'*.m*'),dialogTitle1);
    % Give user some feedback
    if isscalar(CTDstatic.paramFile)
        return    % User cancelled
    end
    if strfind(CTDstatic.paramFile,'.m')
        run(fullfile(CTDstatic.paramPath,CTDstatic.paramFile));
    else
        warning('Unknown file type detected.')
    end
    1;
    guiCTD
    
elseif strcmp(action,'ctdstatic_settingsSave')
    thisPath = mfilename('fullpath');
    settingsPath = fullfile(fileparts(fileparts(thisPath)));
        %'settings');% User interface retrieve file to open through a dialog box.
    dialogTitle2 = 'Save CTD Project Settings File';
    [CTDstatic.paramFileOut,CTDstatic.paramPathOut] = ...
        uiputfile(fullfile(settingsPath,'*.m'),dialogTitle2);
    
    % if the cancel button is pushed, then no file is loaded
    % so exit this script
    if 0 == CTDstatic.paramFileOut
        return
    end
    
    ctdstatic_create_settings_file
    
else
    warning('Action %s is unspecified.',action)
end
