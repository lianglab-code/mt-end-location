function writecsv(mat,fname)
%% WRITECSV writes 2d matrix to a csv file
% writecsv(mat,fname)

% INPUT:
% mat: 2d matrix
% fname: output filename

dim = {size(mat)};
if numel(dim{1})~=2
    error('only 2d matrix is supported');
    return;
end

[M,N] = size(mat);

fileID = fopen(fname,'w');
FORMAT = [repmat('%g,',[1 N-1]) '%g\n'];
for ii = 1:M
    fprintf(fileID,FORMAT,mat(ii,:));
end
fclose(fileID);
