
AUCTableSimple = AUCTable;
for row = 2:size(AUCTableSimple,1)
    for column = 2:size(AUCTableSimple,2)
        
        indicesComma = findstr(AUCTableSimple{row,column},',');
        AUCTableSimple{row,column}= str2num(AUCTableSimple{row,column}(indicesComma(1)+1:indicesComma(2)-1));
    end
end



OPTROCPTTableSimple = OPTROCPTTable;
for row = 2:size(OPTROCPTTableSimple,1)
    for column = 2:size(OPTROCPTTableSimple,2)
        
        indicesComma = findstr(OPTROCPTTableSimple{row,column},',');
        OPTROCPTTableSimple{row,column}= str2num(OPTROCPTTableSimple{row,column}(indicesComma(1)+1:indicesComma(2)-1));
    end
end
