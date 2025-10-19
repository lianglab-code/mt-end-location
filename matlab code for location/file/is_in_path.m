function onPath = is_in_path(folder)
% src: 
% https://www.mathworks.com/matlabcentral/answers/86740-how-can-i-determine-if-a-directory-is-on-the-matlab-path-programmatically

pathCell = regexp(path, pathsep, 'split');
if ispc  % Windows is not case-sensitive
    onPath = any(strcmpi(folder, pathCell));
else
    onPath = any(strcmp(folder, pathCell));
end

