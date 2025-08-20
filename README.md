# CTDlvl2Processing
A MATLAB package for completing level 2 processing on Sea-Bird Scientific CTD level 1 data files. 

At the UAF-Oceans Lab, headed by <a href="https://www.uaf.edu/cfos/people/faculty/detail/seth-danielson.php">Dr. Seth L. Danielson</a>, we define the following CTD data levels:

Level 0: Raw .hex, .hdr, and .bl files from SeaSave interface when running a Sea-Bird 9/11 CTD system <br/>
Level 1: Processed output files (.cnv and .btl) from SBEDataProcessing workflow (based on your own .psa settings files) <br/>
Level 2: Summary files, plots, and interpolated finalized data files for archival and use in larger oceanographic data analyses <br/>

To run, download the 'CTDlvl2Processing' and 'compileCTD' scripts, as well as the 'Modules' folder. Create a master folder accessible to MATLAB that contains these files, as well as three additional folders within that master folder: </br>
1: 'CNVfiles' which contains your Level 1 Processed Sea-Bird Scientific *.cnv files. </br>
2: 'BTLfiles' which contains your Level 1 Processed Sea-Bird Scientific *.btl files. </br>
3: 'Plots' which should be empty </br>
