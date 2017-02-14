# Ranking-Scientists

The functions included in this repo can be used either individually or combined to create a set of outstanding scientists amongst 
a large pool of scientists based on given attributes. The attributes can be chosen from a set of bibliometric indexes calculated by the 
function AllIndexesCalc.m (http://www.sciencedirect.com/science/article/pii/S1751157715200399). 

However the skylineSFS function can be used also individually to produce the skyline set from a pool of data using pre-sorting. 
Also the AllIndexesCalc.m function can be used on its own to calculated any of the afforementioned bibliometric indexes.

Start with three cell arrays containing the citations for each publication in a scientists portfolio, the year of publication and number of 
co-authors. The ith cell in its of the cell arrays corresponds to the ith scientist and publications must be placed in the same corresponding order, e.g.: citations{i,1}=[10 7 9 12]      years{i,1}=[1990 1986 1992 1991] number_of_authors{i,1}=[3 3 2 3]
This collection of cell arrays indicates that for scientist i, their article published in 1990 with 3 authors collected 10 citations so far, the publication of scientist i  published in 1986 collected 7 citations so far and had 3 co-authors, etc.

The following piece of code displays a basic pipeline use of the functions given the aforementioned cell arrays:
>>citationsMat=CellIntoMat(citations)
>>yearsMat=CellIntoMat(years)
>>number_of_authorsMat=CellIntoMat(number_of_authors)
>>ids=[1:1:size(citationsMat,1)] % simply assigning ids to the instances (aka scientists) of our dataset
>>[ AllIndexes ] = AllIndexesCalc(ids,citationsMat,yearsMat,number_of_authorsMat )
>>ChosenAttributes=[6 8 10] % choose the respective columns from the AllIndexes matrix that correspond to the indexes we want as attributes %%for the skyline calculation
>>[ top_authors ] = ChooseAttributesForSkyline( AllIndexes,ChosenAttributes )

In the example above the function SkylineSFS is called from the ChooseAttributesForSkyline.m, but it can be also used individually.

The list of bibliometric indexes can be found in IndexesDescription.png. There is one more index added, called the fractal dimension and it is calculated using the boxcount method. The code and further analysis of this metric will be included in a future repository.
