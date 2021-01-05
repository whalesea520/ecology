update extandHpTheme set subcompanyid = 1 where id = (select MIN(id) from extandHpTheme where  templateId=1)
/