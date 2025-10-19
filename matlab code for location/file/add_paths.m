function add_paths(str)
    str = genpath(str);
    strs = strsplit(str, pathsep);
    for i = 1:numel(strs)
        if ~isempty(strs{i})
            tmpstr = [filesep,'.'];
            k = strfind(strs{i},tmpstr);
            if isempty(k)
                path(strs{i},path);
            end
        end
    end
end
