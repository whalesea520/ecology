CREATE TABLE DocHandwrittenColor ( 
    id int NOT NULL ,
    nameCn varchar(40) NULL,
    nameEn varchar(40) NULL,
    hexRGB char(7) NULL
)  
GO

insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(1,'红色','red','#FF0000')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(2,'蓝色','blue','#0000FF')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(3,'绿色','green','#008000')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(4,'紫罗兰','blueviolet','#8A2BE2')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(5,'粉红','pink','#FFC0CB')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(6,'深红(暗深红色)','crimson','#DC143C')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(7,'青绿','turquoise','#40E0D0')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(8,'鲜绿(酸橙色)','lime','#00FF00')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(9,'青色','cyan','#00FFFF')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(10,'深蓝(暗蓝色)','darkblue','#00008B')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(11,'深黄(暗黄褐色)','darkkhaki','#BDB76B')
GO
insert into DocHandwrittenColor(id,nameCn,nameEn,hexRGB)  values(12,'灰色-50%(暗灰色)','darkgray','#A9A9A9')
GO


CREATE TABLE DocHandwrittenDetail ( 
    id int identity (1, 1) NOT NULL ,
    docId int NULL,
    docEditionId int NULL,
    userName varchar(40) NULL,
    colorId int NULL
)  
GO
