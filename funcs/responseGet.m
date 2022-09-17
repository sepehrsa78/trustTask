function [trialSet, flag] = responseGet(player, trialSet, iTrial, window, dist, colors, center, icons, penWidthPixels, respRect, durations, timer, keyBoard, fixInf, flag)

while toc(timer) - trialSet(iTrial).scenOnset < durations.present
    [~, ~, buttons, ~, ~, ~] = GetMouse(window);
    if buttons(2)
        sca;
        break
    end
    while flag
        if toc(timer) - trialSet(iTrial).scenOnset > durations.present && isempty(trialSet(iTrial).subResp)
            flag = false;
            DrawFormattedText(window, 'Missed', 'center', 'center', [1 0 0]);
            Screen('Flip', window)
            WaitSecs(durations.miss);
        end
        [~, ~, keyCode] = KbCheck;
        if keyCode(keyBoard.escapeKey)
            subResp = 'break';
            ShowCursor;
            sca;
            return
        elseif keyCode(keyBoard.leftKey)
            trialSet(iTrial).respTime = toc(timer);
            trialSet(iTrial).subResp  = 'left';
            flag = false;
            switch player
                case '1'
                    coef = 8;
                    switch trialSet(iTrial).pos
                        case 'left'
                            trialSet(iTrial).decision = 'out';
                            [xResp, yResp] = RectCenterd(respRect.out);

                        case 'right'
                            trialSet(iTrial).decision = 'in';
                            [xResp, yResp] = RectCenterd(respRect.in);
                    end
                case '2'
                    coef = 3;
                    switch trialSet(iTrial).pos
                        case 'left'
                            trialSet(iTrial).decision = 'reciprocity';
                            [xResp, yResp] = RectCenterd(respRect.recip);

                        case 'right'
                            trialSet(iTrial).decision = 'betrayal';
                            [xResp, yResp] = RectCenterd(respRect.betray);
                    end
            end

            graphPresent(player, trialSet, iTrial, window, dist, colors, center, icons, penWidthPixels);
            Screen('DrawDots', window, [xResp; dist / coef + yResp], dist / 14, [1 1 1], [], 3);
            Screen('Flip', window);


        elseif keyCode(keyBoard.rightKey)
            trialSet(iTrial).respTime = toc(timer);
            trialSet(iTrial).subResp  = 'right';
            flag = false;
            switch player
                case '1'
                    coef = 8;
                    switch trialSet(iTrial).pos
                        case 'left'
                            trialSet(iTrial).decision = 'in';
                            [xResp, yResp] = RectCenterd(respRect.in);

                        case 'right'
                            trialSet(iTrial).decision = 'out';
                            [xResp, yResp] = RectCenterd(respRect.out);
                    end
                case '2'
                    coef = 3;
                    switch trialSet(iTrial).pos
                        case 'left'
                            trialSet(iTrial).decision = 'betrayal';
                            [xResp, yResp] = RectCenterd(respRect.betray);

                        case 'right'
                            trialSet(iTrial).decision = 'reciprocity';
                            [xResp, yResp] = RectCenterd(respRect.recip);
                    end
            end

            graphPresent(player, trialSet, iTrial, window, dist, colors, center, icons, penWidthPixels);
            Screen('DrawDots', window, [xResp; dist / coef + yResp], dist / 14, [1 1 1], [], 3);
            Screen('Flip', window);
        end
    end
end

trialSet(iTrial).RT = trialSet(iTrial).respTime - trialSet(iTrial).scenOnset;

Screen('Flip', window);

Screen('FillRect', window, fixInf.color, fixInf.shape);
Screen('Flip', window);

trialSet(iTrial).fixOnset = toc(timer);
WaitSecs(durations.fixation(iTrial));

Screen('Flip', window);
end