function CompareStruct(StructA, StructB, header)
    fn_A = (fieldnames(StructA));
    for i=1:length(fn_A)
        if ( ~isfield(StructB, fn_A{i}))
            error(['field  ' header '.' header fn_A{i} ' of the first struct does not exist in the second struct']);
        end
        switch class(StructA.(fn_A{i}))
            case {'double', 'single', 'uint8', 'uint16', 'uint64'}
                if ( length(StructB.(fn_A{i})) ~= length(StructA.(fn_A{i})) )
                    error(['field  ' header '.' header fn_A{i} ' of the first struct has different length from the field in the second struct']);
                end
                if  (sum(StructB.(fn_A{i}) - StructA.(fn_A{i})) ~=0)
                    error(['field  ' header '.' header fn_A{i} ' of the first struct has different values from the field in the second struct']);
                end
            case {'char'}
                if ( ~setcmp(StructB.(fn_A{i}), StructA.(fn_A{i})))
                    error(['field  ' header '.' fn_A{i} ' of the first struct has different string from the second struct']);
                end
            case {'struct'}
                CompareStruct(StructA, StructB, [header '.' fn_A{i}]);
            case {'cell', 'function_handle'}
                warning('cannot compare cells');
        end
    end
end
