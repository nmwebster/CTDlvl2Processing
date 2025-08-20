function HelpStrings = ctdstatic_get_help_strings


HelpStrings.indirHelp = 'Input directory where CTD files are stored with BTLfiles and CNVfiles subfolders';

HelpStrings.outdirHelp = 'Output directory where summary CTD files will be stored';

HelpStrings.outafnameHelp = 'Base file name of output ASCII file. Include file extension *.ascii in your name.';

HelpStrings.outhfnameHelp = 'Base file name of output header file. Include file extension *.hdr in your name.';

HelpStrings.vessHelp = 'Ship from which the CTD was deployed';

HelpStrings.cruiseHelp = 'Cruise identifier alphanumeric code';

HelpStrings.projectHelp = 'Broader project this CTD data is part of';

HelpStrings.instrumentHelp = 'Equipment model used to collect CTD data (usually SBE9)';

HelpStrings.piHelp = 'Primary Investigator on record';

HelpStrings.agencyHelp = 'Funding agency (i.e. NPS, NSF, etc)';

HelpStrings.regionHelp = 'ex. Gulf of Alaska, Chukchi Sea, etc.';

HelpStrings.dataresHelp = 'Indicate yes (y) or no (n)';

HelpStrings.timeoffHelp = 'Number of hours to convert to GMT if needed, otherwise 0';

HelpStrings.yearHelp = 'Year of data collection';

HelpStrings.updownHelp = 'Select for manual selection of upcast/downcast. If not selected, downcasts will be chosen for all casts by default.';

HelpStrings.interpHelp = 'Select to manually interpolate CNV data after intial plot.';

HelpStrings.extrapHelp = 'Select to just extrapolate across missing bins. Or set to pressure level bin for all casts to be treated equally.';

HelpStrings.epsHelp = 'Select to to send output to EPS files.';

HelpStrings.pngHelp = 'Select to to send output to PNG files.';

HelpStrings.compbotHelp = 'Select to create a bottle summary file.';

HelpStrings.compcnvHelp = 'Select to choose upcast/downcast and combine into one file. REQUIRED for summary ascii and hdr files to output.';

HelpStrings.pltselHelp = 'Select to plot out all profiles selected in SELECTsensors.';

HelpStrings.pltOpHelp = 'Visual configuration options for plots. Select Sensors options only apply when Plot SELECT Sensors is checked.';

HelpStrings.interpOpHelp = 'These options only apply when Data Interpolation is checked.';

HelpStrings.dupeCNVHelp = 'Select to create Seabird-esque CNV files for each cast with interpolated data.';

HelpStrings.addNMEAHelp = 'Select if NMEA was not streamed to the deckbox but you want to create NMEA position header strings (and columns in the csv) based on the header information. Only applies if *Create Interpolated Cast CNVs* is selected.';

HelpStrings.botDepHelp = 'Select if bottom depth header line was NOT formatted exactly as *Bottom Depth [m]*, this option will fix it to make ODV import of final CNVs smooth. Only applies if *Create Interpolated Cast CNVs* is selected.';

HelpStrings.botForHelp = 'Enter the full string that was used for bottom depth in your header.';

HelpStrings.depLatHelp = 'Enter (exactly as written) the latitude used by Seabird to compute Depth. Example header line = depSM: Depth [salt water, m], lat = 58.50. So you would enter 58.50.';

HelpStrings.pltHelp = 'Enter 1 to plot the downcast, 0 to take the upcast, 2 to plot both together.';

HelpStrings.sspltHelp = 'Enter 1 to plot the downcast, 0 to take the upcast.';

HelpStrings.excluHelp = 'Enter list of columns to exclude from CNV file (if any), separated by commas.';


