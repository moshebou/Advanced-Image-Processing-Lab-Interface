function RenameExperiment( experiment_name, new_experiment_name )
curr_pwd = pwd;
TL = load('./TopicList.mat');
dflt = load('./defaults.mat');
TopicList = TL.TopicList;
default = dflt.default;
TopicList_fieldnames = fieldnames(TopicList);
for i = 1 : length(TopicList_fieldnames)
    if ( 0 < sum(strcmp(TopicList.(TopicList_fieldnames{i}), experiment_name)))
        experiment_folder = (TopicList_fieldnames{i});
        TopicList.(TopicList_fieldnames{i}){strcmpi(TopicList.(TopicList_fieldnames{i}), experiment_name)} = new_experiment_name;
    end
end

    prev_expr = experiment_name;
    prev_expr(prev_expr==' ')= '_';
    prev_expr(prev_expr==',')= '';
    prev_expr(prev_expr=='&')= '_';
    prev_expr(prev_expr==':')= [];
    prev_expr(prev_expr=='-')= [];
    
    curr_expr = new_experiment_name;
    curr_expr(curr_expr==' ')= '_';
    curr_expr(curr_expr==',')= '';
    curr_expr(curr_expr=='&')= '_';
    curr_expr(curr_expr==':')= [];
    curr_expr(curr_expr=='-')= [];
    default.(curr_expr) = default.(prev_expr);
    default = rmfield(default, prev_expr);
save('./defaults.mat', 'default');
save('./TopicList.mat', 'TopicList');
experiment_folder(experiment_folder=='_') = ' ';
experiment_folder(2:end) = lower(experiment_folder(2:end));
experiment_folder(end+1) = '/';
    funcStr_old = experiment_name;
    funcStr_old = funcStr_old(funcStr_old~=' ');
    funcStr_old = funcStr_old(funcStr_old~=',');
    funcStr_old = funcStr_old(funcStr_old~='&');
    funcStr_old(funcStr_old=='/') = '_';
    funcStr_old(funcStr_old=='-') = '_';
    funcStr_old(funcStr_old==':') = '';
    funcStr_old_file = [ funcStr_old, '_mb.m'];
    
    funcStr_new = new_experiment_name;
    funcStr_new = funcStr_new(funcStr_new~=' ');
    funcStr_new = funcStr_new(funcStr_new~=',');
    funcStr_new = funcStr_new(funcStr_new~='&');
    funcStr_new(funcStr_new=='/') = '_';
    funcStr_new(funcStr_new=='-') = '_';
    funcStr_new(funcStr_new==':') = '';
    funcStr_new_file = [ funcStr_new, '_mb.m'];
cd ( ['../', experiment_folder])
copyfile(funcStr_old_file, funcStr_new_file);
delete(funcStr_old_file);
text = fileread([ '../', experiment_folder, funcStr_new_file]);
fid = fopen(funcStr_new_file);
text = strrep(text, funcStr_old, funcStr_new);
fprintf(fid ,text);
fclose(fid);
cd(curr_pwd);

end

function scd = ScriptCurrentDirectory
    scd = mfilename('fullpath');
    scd = scd(1:end - length(mfilename));
end