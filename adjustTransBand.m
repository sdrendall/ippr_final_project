function DIFF = adjustTransBand(PTregion,DIFF)
[Ii,Ij] = size(DIFF);
for i = 1:Ii
    for j = 1:Ij
        if PTregion(i,j) == 1
            DIFF(i,j) = 0;
        end
    end
end

end