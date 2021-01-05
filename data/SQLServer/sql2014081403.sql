create   function   f_GetPy(@str   nvarchar(4000)) 
returns   nvarchar(4000) 
as 
begin 
declare   @strlen   int,@re   nvarchar(4000) 
declare   @t   table(chr   nchar(1)   collate   Chinese_PRC_CI_AS,letter   nchar(1)) 
insert   into   @t(chr,letter) 
    select   'ß¹ ', 'A '   union   all   select   '°Ë ', 'B '   union   all 
    select   'àê ', 'C '   union   all   select   '…ö ', 'D '   union   all 
    select   'ŠŠ ', 'E '   union   all   select   '·¢ ', 'F '   union   all 
    select   'ê¸ ', 'G '   union   all   select   'îþ ', 'H '   union   all 
    select   'Ø¢ ', 'J '   union   all   select   'ßÇ ', 'K '   union   all 
    select   'À¬ ', 'L '   union   all   select   '‡` ', 'M '   union   all 
    select   '’‚ ', 'N '   union   all   select   'àÞ ', 'O '   union   all 
    select   'Šr ', 'P '   union   all   select   'Æß ', 'Q '   union   all 
    select   '…ß ', 'R '   union   all   select   'Øí ', 'S '   union   all 
    select   'Ëû ', 'T '   union   all   select   'ŒÜ ', 'W '   union   all 
    select   'Ï¦ ', 'X '   union   all   select   'Ñ¾ ', 'Y '   union   all 
    select   'Ž‰ ', 'Z ' 
    select   @strlen=len(@str),@re= ' ' 
    while   @strlen> 0 
    begin 
        select   top   1   @re=letter+@re,@strlen=@strlen-1 
            from   @t   a   where   chr <=substring(@str,@strlen,1) 
            order   by   chr   desc 
        if   @@rowcount=0 
            select   @re=substring(@str,@strlen,1)+@re,@strlen=@strlen-1 
    end 
    return(@re) 
end
GO