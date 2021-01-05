create table mode_toolbar_search(
	id int primary key identity(1,1),
	isUsedSearch  int,
	searchName varchar(100) ,
	searchField varchar(50),
	imageSource varchar(20),
	imageId int,
	imageUrl varchar(500),
    showOrder int,
	mainid  int,
	serachtype int,
)
go
