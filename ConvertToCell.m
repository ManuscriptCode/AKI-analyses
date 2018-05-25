function c = ConvertToCell( data, indexNum, rows )
a = data(rows,indexNum);
b = dataset2cell(a);
c = b(2:end);


end

