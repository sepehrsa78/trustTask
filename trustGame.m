%% Refreshing the Workspace
sca
close all
clear
clear global
clc

addpath('funcs', 'imgs', 'imgs/intro')
path = pwd;
%% Subject Information

prompt      = {'Subject Name:', 'Demo:', 'Gender:', 'Age:', 'Save Data:'};
dlgtitle    = 'Subject Information';
dims        = [1 35];
answer      = inputdlg(prompt, dlgtitle, dims);
%% Declare Golabal Variables

global params

params.isFirst      = true;
params.respToBeMade = true;
params.isAllowed    = false;
params.isBlockEnd   = false;
params.isSave       = false;
params.cond         = reshape(repmat({'comp', 'human'}, [35 1]), [70, 1]);
%% Task Parameters and Constants

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 3);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

if answer{2, 1} == '1'
    numTrials = 10;
    realTrls  = 204;
    nBlock    = 1;
else
    nBlock     = 1;
    numTrials  = 204;
end

for timT = 1:numTrials
    fix(timT) = (4000 + randi(300)) / 1000;
end

% Paradigm Constants

durations.fixation   = fix;
durations.intro      = 2;
durations.present    = 8;


monitorHeight   = 200;                                                      % in milimeters
monitorDistance = 270;                                                      % in milimeters

screenNumber    = 0;
resolution      = Screen('Resolution', screenNumber);
screenWidth     = resolution.width;
screenHeight    = resolution.height;
pixelDepth      = resolution.pixelSize;
screenHz        = resolution.hz;
nScreenBuffers  = 2;

% Keyboard Information

keyBoard.escapeKey = KbName('ESCAPE');
keyBoard.leftKey   = KbName('LeftArrow');
keyBoard.rightKey  = KbName('RightArrow');

% Color

colors.in  = hex2rgb('#5EFB6E');
colors.out = hex2rgb('#728FCE');

dist            = ang2pix(10, monitorDistance, monitorHeight / screenHeight);
penWidthPixels  = dist / 25;
%% Psychtoolbox Initialization

[window, windowRect] = PsychImaging(...
    'OpenWindow', ...
    screenNumber, ...`
    BlackIndex(screenNumber), ...
    floor([0, 0, screenWidth, screenHeight] / 1), ...
    pixelDepth, ...
    nScreenBuffers, ...
    [], ...
    [], ...
    kPsychNeed32BPCFloat...
    );

icon = 'per.png';
graphPresent(window, dist, 'left', colors, center, icon, penWidthPixels)


ifi                = Screen('GetFlipInterval', window);
isiTimeFrames      = round(durations.fixation / ifi);
waitframes         = 1;
Screen('TextSize', window, 24);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
SetMouse(0, 0);

topPriorityLevel    = MaxPriority(window);
[xCenter, yCenter]  = RectCenter(windowRect);
center.xCenter      = xCenter;
center.yCenter      = yCenter;

fixCross = [xCenter - 2, yCenter - 10, xCenter + 2, yCenter + 10; ...
    xCenter - 10, yCenter - 2, xCenter + 10, yCenter + 2];
fixCrossColor = WhiteIndex(screenNumber);
fixInf.shape = fixCross;
fixInf.color = fixCrossColor;
%% Loading the Conditions

% outValue.p1Bet =
% outValue.p2Bet = 
% outValue.p1Rec = 
% outValue.p2Rec =
% outValue.p1Equ =
% outValue.p2Equ = 


%% Creating the Condition Map


stimOrder = randperm(numTrials);

for iTrial = 1:numTrials
    trialSet(iTrial).trialKeys = params.cond{iTrial};
    trialSet(iTrial).fimgName  = [];
    trialSet(iTrial).fimgTex   = [];
    trialSet(iTrial).simgName  = [];
    trialSet(iTrial).simgTex   = [];

end
block(iBlock).trialSet = block(iBlock).trialSet(stimOrder);
for iTrial = 1:numTrials
    block(iBlock).trialSet(iTrial).Order = stimOrder(iTrial);
end


