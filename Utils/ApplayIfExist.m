function ApplayIfExist( struct, field, handle, type)

    if(isfield(struct, field) && ~isempty(struct.field))
        set(handle, type, struct.(field));
    end
end