INSERT INTO HtmlLabelIndex(id,Indexdesc)
  select h.indexid, h.labelname
    from htmllabelinfo h
   where not exists (select * from HtmlLabelIndex i where i.id = h.indexid)
     and h.languageid = 7
GO
