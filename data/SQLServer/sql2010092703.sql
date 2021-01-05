Drop function getPinYin
GO

Create function dbo.getPinYin(@str nvarchar(4000)) 
returns nvarchar(4000) 
as 
begin 
  declare @word nchar(1),@PY nvarchar(4000) 
  set @PY='' 
  while len(@str)>0 
  begin 
    set @word=left(@str,1)  
    set @PY=@PY+(case when unicode(@word) between 19968 and 19968+20901 
               then (  
                     select top 1 PY  
                     from  
                     (  
                     select 'A' as PY,N'òˆ' as word 
                     union all select 'B',N'²¾' 
                     union all select 'C',N'åe' 
                     union all select 'D',N'ùz' 
                     union all select 'E',N'˜Þ' 
                     union all select 'F',N'öv' 
                     union all select 'G',N'ÄB' 
                     union all select 'H',N'‰þ' 
                     union all select 'J',N'”h' 
                     union all select 'K',N'·i' 
                     union all select 'L',N'÷w' 
                     union all select 'M',N'”æ' 
                     union all select 'N',N'–þ' 
                     union all select 'O',N'a' 
                     union all select 'P',N'ÆØ' 
                     union all select 'Q',N'‡Ý' 
                     union all select 'R',N'úU' 
                     union all select 'S',N'ÎR' 
                     union all select 'T',N'»X' 
                     union all select 'W',N'úF' 
                     union all select 'X',N'èR' 
                     union all select 'Y',N'í' 
                     union all select 'Z',N'…ø' 
                     ) T  
					 where word>=@word collate Chinese_PRC_CS_AS_KS_WS  
					 order by PY ASC 
                     )  
                     else @word  
                 end) 
    set @str=right(@str,len(@str)-1) 
  end 
  return @PY 
end
GO

ALTER Table HrmResource ADD pinyinlastname varchar(50)
GO

UPDATE HrmResource set pinyinlastname = lower(dbo.getPinYin(lastname))
GO

CREATE TRIGGER Tri_mobile_getpinyin ON HrmResource
FOR INSERT
AS
DECLARE @pinyinlastname VARCHAR(50)
DECLARE @id_1 int
begin
SELECT @id_1 = id,@pinyinlastname = lower(dbo.getPinYin(lastname)) FROM inserted
update HrmResource set pinyinlastname = @pinyinlastname where id = @id_1
end
GO
