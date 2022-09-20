%% Refreshing the Workspace
sca
close all
clear
clear global
clc

addpath('funcs', 'imgs', 'imgs/intro', 'imgs/intro/hum', 'utils')
path = pwd;
rand('seed', sum(100 * clock));
%% Subject Information

prompt      = {'Subject Name:', 'Subject ID:', 'Demo:', 'Eye Tracker', 'Gender:', 'Age:', 'Player 1 or 2:', 'Save Data:'};
dlgtitle    = 'Subject Information';
dims        = [1 35];
answer      = inputdlg(prompt, dlgtitle, dims);
%% Declare Golabal Variables

global params

params.isFirst      = true;
params.respToBeMade = false;
params.isAllowed    = false;
params.isSave       = true;

%% Task Parameters and Constants

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 3);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

if answer{3, 1} == '1'
    numTrials = 10;
    realTrls  = 72;
else
    numTrials  = 72;
end
if answer{7, 1} == '2'
    numTrials = 36
end

if answer{7, 1} == '1'
    params.cond         = reshape(repmat({'comp', 'human'}, [36 1]), [72, 1]);
    params.pos          = reshape(repmat({'left', 'right'}, [18 2]), [72, 1]);
else
    params.cond         = repmat({'human'}, [36 1]);
    params.pos          = reshape(repmat({'left', 'right'}, [18 1]), [36, 1]);
end


for timT = 1:numTrials
    fixate(timT) = (4000 + randi(300)) / 1000;
end

% Paradigm Constants

durations.fixation   = fixate;
durations.intro      = 2;
durations.present    = 8;
% durations.miss       = 1;


monitorHeight   = 200;                                                      % in milimeters
monitorDistance = 200;                                                      % in milimeters

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

dist            = ang2pix(13, monitorDistance, monitorHeight / screenHeight);
penWidthPixels  = dist / 25;
icons.person     = 'per.png';
icons.computer   = 'computer.png';
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
fixInf.shape = fixCross';
fixInf.color = fixCrossColor;
%% Loading the Values & Images

stimDir       = 'imgs/intro/hum';
humanFaces    = deblank(natsortfiles(string(ls(fullfile(pwd, stimDir, '*.png')))));
computerImage = icons.computer;
numID         = extractBetween(humanFaces, '_', '.png');

valueTable = readtable('payoffs2.xlsx', 'Format', 'auto', 'ReadVariableNames', true);
if answer{7, 1} == '1'
    valueTable = vertcat(valueTable, valueTable);
else
    humanFaces = humanFaces(1:36);
    numID      = numID(1:36);
end

stimNames    = [humanFaces; computerImage];
stimTextures = containers.Map;
stimInfo     = containers.Map;

pat = "human_" + digitsPattern + ".png";
deg = 7;
for stim  = 1:size(stimNames, 1)
    if contains(stimNames(stim, :), 'computer')
        [~, ~, stimImg] = imread(stimNames(stim, :));
    else
        stimImg                                = imread(stimNames(stim, :));
    end
    imgSize                                = size(stimImg);
    ratio                                  = imgSize(1) / imgSize(2);
    iWidth                                 = ang2pix(deg, monitorDistance, monitorHeight / screenHeight);
    iHeight                                = ratio * iWidth;
    stimImg                                = imresize(stimImg, [iHeight, iWidth]);
    stimInfo(char(stimNames(stim, :)))     = stimImg;
    stimTextures(char(stimNames(stim, :))) = Screen('MakeTexture', window, stimImg);
end

elemSizes.humanHeight = size(stimInfo('human_1.png'), 1);
elemSizes.humanWidth  = size(stimInfo('human_1.png'), 2);
elemSizes.compHeight  = size(stimInfo('computer.png'), 1);
elemSizes.compWidth   = size(stimInfo('computer.png'), 2);
%% Creating the Condition Map

stimOrder = randperm(numTrials);
params.cond = params.cond(stimOrder);
params.pos  = params.pos(stimOrder);

for iTrial = 1:numTrials
    trialSet(iTrial).trialKeys  = params.cond{iTrial};
    trialSet(iTrial).pos        = params.pos{iTrial};
    trialSet(iTrial).otherID    = double(numID(iTrial));
    if all(answer{7, 1} == '1' & strcmp(string(trialSet(iTrial).trialKeys), "comp"))
        trialSet(iTrial).otherImage = stimTextures(char(computerImage));
    else
        trialSet(iTrial).otherImage = stimTextures(char(humanFaces(iTrial, :)));
    end
    trialSet(iTrial).sValue     = valueTable.S(iTrial);
    trialSet(iTrial).tValue     = valueTable.T(iTrial);
    trialSet(iTrial).r1Value    = valueTable.R1(iTrial);
    trialSet(iTrial).r2Value    = valueTable.R2(iTrial);
    trialSet(iTrial).p1Value    = valueTable.P1_P2(iTrial);
    trialSet(iTrial).p2Value    = valueTable.P1_P2(iTrial);
    trialSet(iTrial).introOnset = [];
    trialSet(iTrial).scenOnset  = [];
    trialSet(iTrial).respTime   = [];
    trialSet(iTrial).fixOnset   = [];
    trialSet(iTrial).subResp    = [];
    trialSet(iTrial).RT         = [];
    trialSet(iTrial).decision   = [];
end
stimOrder = randperm(numTrials);
trialSet = trialSet(stimOrder);
for iTrial = 1:numTrials
    trialSet(iTrial).Order = stimOrder(iTrial);
end
%% Eye Tracker Initialization

eyetracker = true;
if answer{4, 1} == '1'
    eye_calibration(eyetracker, windowRect, window, strcat("sub", answer{2, 1}, "_"));
    if eyetracker
        SimpleGazeTracker('StartRecording', 'block', 0.1);
    end
end
%% Task Body

timer = tic;
iTrial = 0;
params.isAllowed = true;

while iTrial <= numTrials

    if params.isFirst
        Prompt_Start = 'Start the Task';
        DrawFormattedText(window, Prompt_Start,...
            'center', 'center', WhiteIndex(screenNumber) / 2);
        Screen('Flip', window);
        KbStrokeWait;
        Screen('Flip', window);
        params.isFirst = false;
    end

    if params.isAllowed
        iTrial = iTrial + 1;
    end

    if iTrial > numTrials
        params.isAllowed  = false;
        break
    end

    introRect = [xCenter - elemSizes.humanWidth / 2, yCenter + elemSizes.humanHeight / 1.6,...
        xCenter + elemSizes.humanWidth / 2, yCenter + elemSizes.humanHeight / 1.6];
    if strcmp(trialSet(iTrial).trialKeys, 'comp')
        Screen('DrawTexture', window, trialSet(iTrial).otherImage, [], [], 0, [], [], colors.in);
        DrawFormattedText(window, sprintf('#%i', trialSet(iTrial).otherID), 'center', 'center', colors.in, ...
            [], [], [], [], [], introRect);
        Screen('Flip', window);
        WaitSecs(durations.intro);
    else
        if answer{7, 1} == '1'
            DrawFormattedText(window, sprintf('#%i', trialSet(iTrial).otherID), 'center', 'center', colors.in, ...
                [], [], [], [], [], introRect);
        else
            DrawFormattedText(window, sprintf('#%i', trialSet(iTrial).otherID), 'center', 'center', colors.out, ...
                [], [], [], [], [], introRect);
        end
        Screen('DrawTexture', window, trialSet(iTrial).otherImage, [], [], 0);
        Screen('Flip', window);
        trialSet(iTrial).introOnset = toc(timer);
        WaitSecs(durations.intro);
    end

    respRect = graphPresent(answer{7, 1}, trialSet, iTrial, window, dist, colors, center, icons, penWidthPixels);
    Screen('Flip', window);
    trialSet(iTrial).scenOnset = toc(timer);

    params.respToBeMade = true;
    [trialSet, params.respToBeMade] = responseGet(answer{7, 1}, trialSet, iTrial, window, dist, colors, center, icons, ...
        penWidthPixels, respRect, durations, timer, keyBoard, fixInf, params.respToBeMade);
end

if ~ params.isAllowed
    Prompt_Start = 'Task Finished';
    DrawFormattedText(window, Prompt_Start,...
        'center', 'center', WhiteIndex(screenNumber) / 2);
    Screen('Flip', window);
    WaitSecs(1);
    sca;
end

if ~ isempty(answer{8, 1}) && answer{8, 1} ~= '1'
    params.isSave  = false;
end
%% Close eyetracker

if answer{4, 1} == '1'
    if eyetracker
        close_eyetrack(eyetracker);
    end
end

%% Save Data

if answer{8, 1} == '1' && params.isSave
    if ~exist(fullfile(path, 'results', ['sub_' answer{2, 1}]))
        mkdir(fullfile(path, 'results', ['sub_' answer{2, 1}]))
    end
    if answer{3, 1} == '1'
        save(fullfile(path, 'results', ['sub_' answer{2, 1}], ['sub_' answer{2, 1}, '_demo_data.mat']))
    else
        save(fullfile(path, 'results', ['sub_' answer{2, 1}], ['sub_' answer{2, 1}, '_data.mat']))
    end
end










