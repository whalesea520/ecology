insert into extandHpTheme(templateId, subCompanyId) values(1, 1)
GO
insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(1,'ecology7', 'default',1,0)
GO
insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(1,'ecology7', 'green',1,0)
GO
insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(1,'ecology7', 'red',1,0)
GO
insert into extandHpThemeItem(extandHpThemeId, theme, skin, isopen, islock) values(1,'ecologyBasic', 'default',1,0)
GO
update SystemTemplate set extendtempletid=3,extendtempletvalueid=1 where id=1
GO
