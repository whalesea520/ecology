ALTER table  HrmSearchMould  ADD datefield1 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefield2 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefield3 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefield4 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefield5 varchar(60)
go


ALTER table  HrmSearchMould  ADD datefieldto1 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefieldto2 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefieldto3 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefieldto4 varchar(60)
go

ALTER table  HrmSearchMould  ADD datefieldto5 varchar(60)
go


ALTER table  HrmSearchMould  ADD textfield1 varchar(100)
go

ALTER table  HrmSearchMould  ADD textfield2 varchar(100)
go

ALTER table  HrmSearchMould  ADD textfield3 varchar(100)
go

ALTER table  HrmSearchMould  ADD textfield4 varchar(100)
go

ALTER table  HrmSearchMould  ADD textfield5 varchar(100)
go

ALTER table  HrmSearchMould  ADD numberfield1 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfield2 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfield3 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfield4 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfield5 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfieldto1 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfieldto2 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfieldto3 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfieldto4 varchar(60)
go

ALTER table  HrmSearchMould  ADD numberfieldto5 varchar(60)
go


ALTER table  HrmSearchMould  ADD tinyintfield1 tinyint
go

ALTER table  HrmSearchMould  ADD tinyintfield2 tinyint
go

ALTER table  HrmSearchMould  ADD tinyintfield3 tinyint
go

ALTER table  HrmSearchMould  ADD tinyintfield4 tinyint
go

ALTER table  HrmSearchMould  ADD tinyintfield5 tinyint
go

create procedure HrmSearchMouldDefine_Update (@id_1 int, @dff01name varchar(60),@dff02name varchar(60),@dff03name varchar(60),@dff04name varchar(60),@dff05name varchar(60),@dff01nameto varchar(60),@dff02nameto varchar(60),@dff03nameto varchar(60),@dff04nameto varchar(60),@dff05nameto varchar(60), @nff01name varchar(60),@nff02name varchar(60),@nff03name varchar(60),@nff04name varchar(60),@nff05name varchar(60),@nff01nameto varchar(60),@nff02nameto varchar(60),@nff03nameto varchar(60),@nff04nameto varchar(60),@nff05nameto varchar(60), @tff01name varchar(100),@tff02name varchar(100),@tff03name varchar(100),@tff04name varchar(100),@tff05name varchar(100),@bff01name tinyint, @bff02name tinyint,@bff03name tinyint,@bff04name tinyint,@bff05name tinyint, @flag int output, @msg varchar(60) output) as update HrmSearchMould set datefield1 = @dff01name ,datefield2 = @dff02name ,datefield3 = @dff03name ,datefield4 = @dff04name ,datefield5 = @dff05name ,datefieldto1 = @dff01nameto ,datefieldto2 = @dff02nameto ,datefieldto3 = @dff03nameto ,datefieldto4 = @dff04nameto ,datefieldto5 = @dff05nameto ,numberfield1 = @nff01name ,numberfield2 = @nff02name ,numberfield3 = @nff03name ,numberfield4 = @nff04name ,numberfield5 = @nff05name ,numberfieldto1 = @nff01nameto ,numberfieldto2 = @nff02nameto ,numberfieldto3 = @nff03nameto ,numberfieldto4 = @nff04nameto ,numberfieldto5 = @nff05nameto ,textfield1 = @tff01name ,textfield2 = @tff02name ,textfield3 = @tff03name ,textfield4 = @tff04name ,textfield5 = @tff05name ,tinyintfield1 = @bff01name,tinyintfield2 = @bff02name,tinyintfield3 = @bff03name,tinyintfield4 = @bff04name,tinyintfield5 = @bff05name where id = @id_1
GO