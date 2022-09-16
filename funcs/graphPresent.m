function graphPresent(window, dist, outPos, colors, center, icon, penWidthPixels)

gap = 150;

Screen('TextSize', window, floor(dist / 10));
switch outPos
    case 'left'
        xDist = dist;
    case 'right'
        xDist = -1 * dist;
end
xCenter = center.xCenter;
yCenter = center.yCenter;

[~, ~, alphachannel] = imread(icon);
alphachannel = imresize(alphachannel, [100 * (dist / 265), 100 * (dist / 265)]);
pOne = Screen('MakeTexture', window, alphachannel);
pOneH = size(alphachannel, 1);
pOneW = size(alphachannel, 2);

coOrdinates.outDots  = [xCenter - 2 * xDist, xCenter; yCenter + dist - gap, yCenter - dist - gap];
coOrdinates.inDots   = [xCenter + 2 * xDist, xCenter, xCenter + xDist; yCenter + dist - gap, yCenter + dist - gap, yCenter - gap];
coOrdinates.outLines = [coOrdinates.outDots, coOrdinates.outDots(:, 2), coOrdinates.inDots(:, 3)];
coOrdinates.inLines  = [coOrdinates.inDots(:, 3), coOrdinates.inDots(:, 2), coOrdinates.inDots(:, 3), coOrdinates.inDots(:, 1)];

baseRect   = [0 0 dist / 1.7 dist / 2.5];
pOneRect = [xCenter - pOneW / 2, yCenter - pOneH / 2 - dist / 1.5 - gap,...
            xCenter + pOneH / 2, yCenter + pOneH / 2 - dist / 1.5 - gap];
pTwoRect = [coOrdinates.inDots(1, 3) - pOneW / 2, coOrdinates.inDots(2, 3) - pOneH / 2 + dist / 2.5,...
            coOrdinates.inDots(1, 3) + pOneH / 2, coOrdinates.inDots(2, 3) + pOneH / 2 + dist / 2.5];
p1Rect    = [coOrdinates.outDots(1, 2), coOrdinates.outDots(2, 2) - dist / 6,...
            coOrdinates.outDots(1, 2), coOrdinates.outDots(2, 2) - dist / 6];
p2Rect    = [coOrdinates.inDots(1, 3) + xDist / 4, coOrdinates.inDots(2, 3),...
            coOrdinates.inDots(1, 3) + xDist / 4, coOrdinates.inDots(2, 3)];

inRect     = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 3) - xDist / 5, coOrdinates.inDots(2, 3) - dist / 2)
outRect    = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 3) - 2 * xDist + xDist / 5, coOrdinates.inDots(2, 3) - dist / 2);

youRect    = pOneRect;
youRect([2 4]) = youRect([2 4]) + dist / 5; 
otherRect    = pTwoRect;
otherRect([2 4]) = otherRect([2 4]) + dist / 5;

sVRect   = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 1), coOrdinates.inDots(2, 1) + dist / 3);
r1VRect  = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 2), coOrdinates.inDots(2, 2) + dist / 3);
p1VRect  = CenterRectOnPointd(baseRect, coOrdinates.outDots(1, 1), coOrdinates.outDots(2, 1) + dist / 3);

tVRect   = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 1), coOrdinates.inDots(2, 1) + dist);
r2VRect  = CenterRectOnPointd(baseRect, coOrdinates.inDots(1, 2), coOrdinates.inDots(2, 2) + dist);
p2VRect  = CenterRectOnPointd(baseRect, coOrdinates.outDots(1, 1), coOrdinates.outDots(2, 1) + dist);



DrawFormattedText(window, 'IN', 'center', 'center', colors.out, [], [], [], [], [], inRect);
DrawFormattedText(window, 'OUT', 'center', 'center', colors.out, [], [], [], [], [], outRect);
Screen('DrawTexture', window, pOne, [], pOneRect, 0, [], [], colors.out);
Screen('DrawTexture', window, pOne, [], pTwoRect, 0, [], [], colors.in);
DrawFormattedText(window, 'YOU', 'center', 'center', colors.out, [], [], [], [], [], youRect);
DrawFormattedText(window, sprintf('#%i', 3), 'center', 'center', colors.in, [], [], [], [], [], otherRect);
DrawFormattedText(window, 'P1', 'center', 'center', colors.out, [], [], [], [], [], p1Rect);
DrawFormattedText(window, sprintf('P2 (#%i)', 3), 'center', 'center', colors.in, [], [], [], [], [], p2Rect);
Screen('DrawLines', window, coOrdinates.outLines, 10, colors.out)
Screen('DrawLines', window, coOrdinates.inLines, 10, colors.in)
Screen('DrawDots', window, coOrdinates.outDots, 15, colors.out, [], 3)
Screen('DrawDots', window, coOrdinates.inDots, 15, colors.in, [], 3)



Screen('FrameRect', window, colors.out, sVRect, penWidthPixels);
Screen('FrameRect', window, colors.out, r1VRect, penWidthPixels);
Screen('FrameRect', window, colors.out, p1VRect, penWidthPixels);

Screen('FrameRect', window, colors.in, tVRect, penWidthPixels);
Screen('FrameRect', window, colors.in, r2VRect, penWidthPixels);
Screen('FrameRect', window, colors.in, p2VRect, penWidthPixels);


Screen('Flip', window)

end


