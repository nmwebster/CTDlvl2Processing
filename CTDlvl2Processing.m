% CTDlvl2Processing
% CTD processing code developed by Seth L. Danielson, University of Alaska
% Fairbanks; conversion to GUI-based input instead of hard-coded options
% developed by Nicole M. Webster, University of Alaska Fairbanks, 2025

close all
clear all

%navigate your starting path to "CTD" folder that contains the following
%folders:
%'BTLfiles' with your raw *.btl files from CTD
%'CNVfiles' with your raw *.cnv files from CTD
%'Modules' which contains the dependent scripts

global CTDstatic PARAMS

addpath Modules

guiCTD

%last update: 2/20/26 nmwebster
    % if you run into error "unrecognized function or variable 'X3'
    % check that your CTDvariable strings in 'complileCTD.m' lines 21-23
    % match strings used in your CTD cnv files
    % density is the usual culprit
% Ava test
