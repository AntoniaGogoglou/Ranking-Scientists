function [ top_authors ] = ChooseAttributesForSkyline( AllIndexes, ChosenAttributes )
AllIndexes(isnan(AllIndexes))=0;
% turn indexes table into ranks -> aka a form of normalization
AllRanks=zeros(size(AllIndexes,1),size(AllIndexes,2));
AllRanks(:,1)=AllIndexes(:,1);
for i=2:1:size(AllIndexes,2)
    if (i<29&i~=6)|i>32
        [~,Ranks]=ismember(AllIndexes(:,i),sort(unique(sort(AllIndexes(:,i))),'descend'));
    else
        [~,Ranks]=ismember(AllIndexes(:,i),sort(unique(sort(AllIndexes(:,i))))); 
    end
    AllRanks(:,i)=Ranks;
end

forskyline=[AllIndexes(:,1) AllRanks(:,ChosenAttributes)];
top_authors=Skyline(forskyline);




end

