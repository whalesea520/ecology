ALTER TABLE HrmRoles ADD  isdefault char(1) NULL /*是否是系统初始化的角色*/
GO

UPDATE HrmRoles SET isdefault = 1 WHERE ID <=11 /*更新系统初始化的角色的isdefault字段 为1
            只更新id<11的角色，因为后边的有可能是打包上去的，Id 不能确定
                        1           公司管理员
                        2           系统管理员
                        3           文档管理员
                        4           人力资源管理员
                        5           财务管理员
                        6           财务人员
                        7           资产管理员
                        8           CRM管理员
                        9           项目管理员
                        10          工作流管理员
                        11          会议室管理员*/
GO
