function out = rectMaker(pos, gap, imageWidth, imageHeight, xCenter, yCenter)

baseRect            = [0 0 imageWidth imageHeight];
switch pos
    case 'right'
        rightRect = [xCenter + gap, yCenter - imageHeight / 2,...
            xCenter + gap + imageWidth, yCenter + imageHeight / 2];
        [xRight, yRight]    = RectCenterd(rightRect);
        selectionRectRight  = CenterRectOnPointd(baseRect, xRight, yRight);
        out                 = rightRect;
    case 'left'
        leftRect  = [xCenter - gap - imageWidth, yCenter - imageHeight / 2,...
            xCenter - gap, yCenter + imageHeight / 2];
        [xLeft, yLeft]      = RectCenterd(leftRect);
        selectionRectLeft   = CenterRectOnPointd(baseRect, xLeft, yLeft);
        out                 = leftRect;
    case 'center'
        centRect  = [xCenter - imageWidth, yCenter - imageHeight / 2,...
            xCenter, yCenter + imageHeight / 2];
        [xCent, yCent]      = RectCenterd(centRect);
        selectionRectLeft   = CenterRectOnPointd(baseRect, xCent, yCent);
        out                 = centRect;
end
end







