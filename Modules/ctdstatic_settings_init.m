function ctdstatic_settings_init

global PARAMS CTDstatic

if isempty(PARAMS) == 1
    PARAMS.indir = [];
    PARAMS.outdir = [];
    PARAMS.outafname = [];
    PARAMS.outhfname = [];
    PARAMS.vess = [];
    PARAMS.cruise = [];
    PARAMS.project = [];
    PARAMS.instrument = [];
    PARAMS.pi = ['Webster'];
    PARAMS.agency = [];
    PARAMS.region = [];
    PARAMS.datares = [];
    PARAMS.timeoff = [];
    PARAMS.year = [];
    PARAMS.updown = 0;
    PARAMS.interp = 0;
    PARAMS.extrap = 0;
    PARAMS.eps = 0;
    PARAMS.png = 0;
    PARAMS.compbot = 0;
    PARAMS.compcnv = 1;
    PARAMS.pltsel = 0;
    PARAMS.nROW = 1;
    PARAMS.nCOL = 3;
    PARAMS.maxPRESSURE = 1000;
    PARAMS.nROW_SS = 2;
    PARAMS.nCOL_SS = 4;
    PARAMS.maxPRESSURE_SS = 300;
    PARAMS.SSsel = 1;
    PARAMS.UPdown_SS = 0;
    PARAMS.dupeCNV = 0;
    PARAMS.addNMEA = 0;
    PARAMS.botDep = 0;
    PARAMS.botFor = [];
    PARAMS.depLat = [];
    PARAMS.pltDat = 2;
    PARAMS.excluDat = [];
end

if isempty(CTDstatic) == 1
    CTDstatic.indir = [];
    CTDstatic.outdir = [];
    CTDstatic.outafname = [];
    CTDstatic.outhfname = [];
    CTDstatic.vess = [];
    CTDstatic.cruise = [];
    CTDstatic.project = [];
    CTDstatic.instrument = [];
    CTDstatic.pi = ['Webster'];
    CTDstatic.agency = [];
    CTDstatic.region = [];
    CTDstatic.datares = [];
    CTDstatic.timeoff = [];
    CTDstatic.year = [];
    CTDstatic.updown = [];
    CTDstatic.interp = [];
    CTDstatic.extrap = [];
    CTDstatic.eps = [];
    CTDstatic.png = [];
    CTDstatic.compbot = [];
    CTDstatic.compcnv = 1;
    CTDstatic.pltsel = [];
    CTDstatic.nROW = 1;
    CTDstatic.nCOL = 3;
    CTDstatic.maxPRESSURE = 1000;
    CTDstatic.nROW_SS = 2;
    CTDstatic.nCOL_SS = 4;
    CTDstatic.maxPRESSURE_SS = 300;
    CTDstatic.SSsel = 1;
    CTDstatic.UPdown_SS = 0;
    CTDstatic.dupeCNV = [];
    CTDstatic.addNMEA = [];
    CTDstatic.botDep = [];
    CTDstatic.botFor = [];
    CTDstatic.depLat = [];
    CTDstatic.pltDat = 2;
    CTDstatic.excluDat = [];
end