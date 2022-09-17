function [respRect] = graphPresent(player, trialSet, iTrial, window, dist, colors, center, icon, penWidthPixels)

gap = 150;

you   = 'YOU';
other = sprintf('#%i', trialSet(iTrial).otherID);

Screen('TextSize', window, floor(dist / 10));
switch trialSet(iTrial).pos
    case 'left'
        xDist = dist;
    case 'right'
        xDist = -1 * dist;
end

xCenter = center.xCenter;
yCenter = center.yCenter;

[~, ~, perIco] = imread(icon.person);
perIco = imresize(perIco, [100 * (dist / 265), 100 * (dist / 265)]);
[~, ~, compIco] = imread(icon.computer);
compIco = imresize(compIco, [100 * (dist / 265), 100 * (dist / 265)]);
perIc  = Screen('MakeTexture', window, perIco);
compIc = Screen('MakeTexture', window, compIco);
pOneH  = size(perIco, 1);
pOneW  = size(perIco, 2);

coOrdinates.outDots  = [xCenter - 2 * xDist, xCenter; yCenter + dist - gap, yCenter - dist - gap];
coOrdinates.inDots   = [xCenter + 2 * xDist, xCenter, xCenter + xDist; yCenter + dist - gap, yCenter + dist - gap, yCenter - gap];
coOrdinates.outLines = [coOrdinates.outDots, coOrdinates.outDots(:, 2), coOrdinates.inDots(:, 3)];
coOrdinates.inLines  = [coOrdinates.inDots(:, 3), coOrdinates.inDots(:, 2), coOrdinates.inDots(:, 3), coOrdinates.inDots(:, 1)];

baseRect     = [0 0 dist / 1.7 dist / 2.5];

pOneIconRect = [xCenter - pOneW / 2, yCenter - pOneH / 2 - dist / 1.7 - gap,...
                xCenter + pOneH / 2, yCenter + pOneH / 2 - dist / 1.7 - gap];
pTwoIconRect = [coOrdinates.inDots(1, 3) - pOneW / 2, coOrdinates.inDots(2, 3) - pOneH / 2 + dist / 2.5,...
                coOrdinates.inDots(1, 3) + pOneH / 2, coOrdinates.inDots(2, 3) + pOneH / 2 + dist / 2.5];

p1NameRect    = [coOrdinates.outDots(1, 2), coOrdinates.outDots(2, 2) - dist / 6,...
                 coOrdinates.outDots(1, 2), coOrdinates.outDots(2, 2) - dist / 6];
p2NameRect    = [coOrdinates.inDots(1, 3) + xDist / 4, coOrdinates.inDots(2, 3),...
                 coOrdinates.inDots(1, 3) + xDist / 4, coOrdinates.inDots(2, 3)];

p1Rect   = p1NameRect;
p2Rect   = p2NameRect;
p1Color  = colors.out;
p2Color  = colors.in;
switch player
    case '1'      
        pOneRect     = pOneIconRect;
        pTwoRect     = pTwoIconRect;
        p1IconColor  = colors.out;
        p2IconColor  = colors.in;
        p1           = 'P1';
        p2           = sprintf('P2 (#%i)', trialSet(iTrial).otherID);
        switch trialSet(iTrial).trialKeys 
            case 'comp'
                pOne     = perIc;
                pTwo     = compIc;
            case 'human'
                pOne     = perIc;
                pTwo     = perIc;
        end

    case '2'
        pOneRect     = pTwoIconRect;
        pTwoRect     = pOneIconRect;
        p1IconColor  = colors.in;
        p2IconColor  = colors.out;
        p1           = sprintf('P1 (#%i)', trialSet(iTrial).otherID);
        p2           = 'P2';
        pOne         = perIc;
        pTwo         = perIc;
end



inRect     = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 3) - xDist / 5, coOrdinates.inDots(2, 3) - dist / 2);
outRect    = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 3) - 2 * xDist + xDist / 5, coOrdinates.inDots(2, 3) - dist / 2);

youRect    = pOneRect;
youRect([2 4]) = youRect([2 4]) + dist / 5; 
otherRect    = pTwoRect;
otherRect([2 4]) = otherRect([2 4]) + dist / 4;

sVRect   = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 1), coOrdinates.inDots(2, 1) + dist / 3);
r1VRect  = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 2), coOrdinates.inDots(2, 2) + dist / 3);
p1VRect  = CenterRectOnPointd(baseRect, coOrdinates.outDots(1, 1), coOrdinates.outDots(2, 1) + dist / 3);

tVRect   = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 1), coOrdinates.inDots(2, 1) + dist);
r2VRect  = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 2), coOrdinates.inDots(2, 2) + dist);
p2VRect  = CenterRectOnPointd(baseRect, coOrdinates.outDots(1, 1), coOrdinates.outDots(2, 1) + dist);

respRect.in     = inRect;
respRect.out    = outRect;
respRect.recip  = r2VRect;
respRect.betray = tVRect;


DrawFormattedText(window, 'IN', 'center', 'center', colors.out, [], [], [], [], [], inRect);
DrawFormattedText(window, 'OUT', 'center', 'center', colors.out, [], [], [], [], [], outRect);

Screen('DrawTexture', window, pOne, [], pOneRect, 0, [], [], p1IconColor);
DrawFormattedText(window, you, 'center', 'center', p1IconColor, [], [], [], [], [], youRect);
Screen('DrawTexture', window, pTwo, [], pTwoRect, 0, [], [], p2IconColor);
DrawFormattedText(window, other, 'center', 'center', p2IconColor, [], [], [], [], [], otherRect);

DrawFormattedText(window, p1, 'center', 'center', p1Color, [], [], [], [], [], p1Rect);
DrawFormattedText(window, p2, 'center', 'center', p2Color, [], [], [], [], [], p2Rect);

Screen('DrawLines', window, coOrdinates.outLines, 10, colors.out);
Screen('DrawLines', window, coOrdinates.inLines, 10, colors.in);
Screen('DrawDots', window, coOrdinates.outDots, 15, colors.out, [], 3);
Screen('DrawDots', window, coOrdinates.inDots, 15, colors.in, [], 3);


Screen('FrameRect', window, colors.out, sVRect, penWidthPixels);
DrawFormattedText(window, sprintf('%g', trialSet(iTrial).sValue), 'center', 'center', colors.out, [], [], [], [], [], sVRect);
Screen('FrameRect', window, colors.out, r1VRect, penWidthPixels);
DrawFormattedText(window, sprintf('%g', trialSet(iTrial).r1Value), 'center', 'center', colors.out, [], [], [], [], [], r1VRect);
Screen('FrameRect', window, colors.out, p1VRect, penWidthPixels);
DrawFormattedText(window, sprintf('%g', trialSet(iTrial).p1Value), 'center', 'center', colors.out, [], [], [], [], [], p1VRect);


Screen('FrameRect', window, colors.in, tVRect, penWidthPixels);
DrawFormattedText(window, sprintf('%g', trialSet(iTrial).tValue), 'center', 'center', colors.in, [], [], [], [], [], tVRect);
Screen('FrameRect', window, colors.in, r2VRect, penWidthPixels);
DrawFormattedText(window, sprintf('%g', trialSet(iTrial).r2Value), 'center', 'center', colors.in, [], [], [], [], [], r2VRect);
Screen('FrameRect', window, colors.in, p2VRect, penWidthPixels);
DrawFormattedText(window, sprintf('%g', trialSet(iTrial).p2Value), 'center', 'center', colors.in, [], [], [], [], [], p2VRect);

end


