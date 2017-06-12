function relative_path = fullpath_to_relative(relative_to_path, full_path)
relative_path = [];
C1 = strsplit(full_path,{'\', '/'});
C1 = C1(cellfun(@(x)~isempty(x), C1));
C2 = strsplit(relative_to_path,{'\', '/'});
C2 = C2(cellfun(@(x)~isempty(x), C2));
isequale = true;
i = 1;
if ( C1{1}(1) ~= C2{1}(1) )
    relative_path = full_path;
    return
end
while ((isequale) && (i <= min(length(C1), length(C2))))
    if ( ~strcmpi(C1{i} , C2{i} ) )
        isequale = false;
    else
        i = i+1;
    end
end
if  (i > length(C2))
    relative_path = './';
else
    for k = i:length(C2)
        relative_path = [relative_path, '../'];
    end
end
for k = i:length(C1)
    relative_path = [relative_path, C1{k}, '/'];
end


end