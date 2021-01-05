ALTER function [getPinYin](@str nvarchar(4000)) 
 returns nvarchar(4000) 
 as begin 
 declare
 @v_index INT ,
 @v_midindex INT ,
 @v_wordbit   INT ,
 @v_wordlength INT,
 @word nchar(1),
 @PY nvarchar(4000)
 SET @v_index = CHARINDEX('~`~`',@str);
 SET @v_midindex = CHARINDEX('`~`',@str,@v_index+4);
 SET @v_wordbit = datalength(@str);
 SET @v_wordlength = len(@str);
 set @PY='' 
 if (@v_index < 0 AND @v_wordbit<>@v_wordlength )
      SET @str = @str;
 else if @v_index >0
      SET @str = SUBSTRING(@str, @v_index + 6, @v_midindex - @v_index - 6);
 else
      return @str;   
 while len(@str)>0 begin 
 set @word=left(@str,1)
 set @PY=@PY+(case when unicode(@word) between 19968 and 19968+20901 then ( select top 1 PY from ( select 'A' as PY,N'òˆ' as word union all select 'B',N'²¾' union all select 'C',N'åe' union all select 'D',N'ùz' union all select 'E',N'˜Þ' union all select 'F',N'öv' union all select 'G',N'ÄB' union all select 'H',N'‰þ' union all select 'J',N'”h' union all select 'K',N'·i' union all select 'L',N'÷w' union all select 'M',N'”æ' union all select 'N',N'–þ' union all select 'O',N'a' union all select 'P',N'ÆØ' union all select 'Q',N'‡Ý' union all select 'R',N'úU' union all select 'S',N'ÎR' union all select 'T',N'»X' union all select 'W',N'úF' union all select 'X',N'èR' union all select 'Y',N'í' union all select 'Z',N'…ø' ) T where word>=@word collate Chinese_PRC_CS_AS_KS_WS order by PY ASC ) else @word end) set @str=right(@str,len(@str)-1) end return @PY end 
 GO