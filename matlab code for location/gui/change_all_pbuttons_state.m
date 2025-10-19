function change_all_pbuttons_state(pbutts, status)
%% CHANGE_ALL_PBUTTONS_STATE changes the status of every button
    for i = 1:numel(pbutts)
        set(pbutts(i), 'Enable', status);
    end
end
