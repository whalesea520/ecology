delete from HtmlLabelIndex where id=21218 
GO
delete from HtmlLabelInfo where indexid=21218 
GO
INSERT INTO HtmlLabelIndex values(21218,'流程督办') 
GO
INSERT INTO HtmlLabelInfo VALUES(21218,'流程督办',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21218,'Workflow superintend',8) 
GO
delete from HtmlLabelIndex where id=21219 
GO
delete from HtmlLabelInfo where indexid=21219 
GO
INSERT INTO HtmlLabelIndex values(21219,'督办者') 
GO
INSERT INTO HtmlLabelInfo VALUES(21219,'督办者',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21219,'Urger',8) 
GO
delete from HtmlLabelIndex where id=21220 
GO
delete from HtmlLabelInfo where indexid=21220 
GO
INSERT INTO HtmlLabelIndex values(21220,'督办设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21220,'督办设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21220,'Urger setting',8) 
GO
delete from HtmlLabelIndex where id=21223 
GO
delete from HtmlLabelInfo where indexid=21223 
GO
INSERT INTO HtmlLabelIndex values(21223,'督办') 
GO
INSERT INTO HtmlLabelInfo VALUES(21223,'督办',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21223,'superintend',8) 
GO

delete from HtmlLabelIndex where id=21225 
GO
delete from HtmlLabelInfo where indexid=21225 
GO
INSERT INTO HtmlLabelIndex values(21225,'是否可查看流程内容') 
GO
INSERT INTO HtmlLabelInfo VALUES(21225,'是否可查看流程内容',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21225,'Can see workflow infomation or not',8) 
GO
delete from HtmlLabelIndex where id=21229 
GO
delete from HtmlLabelInfo where indexid=21229 
GO
INSERT INTO HtmlLabelIndex values(21229,'允许查看') 
GO
delete from HtmlLabelIndex where id=21230 
GO
delete from HtmlLabelInfo where indexid=21230 
GO
INSERT INTO HtmlLabelIndex values(21230,'禁止查看') 
GO
delete from HtmlLabelIndex where id=21231 
GO
delete from HtmlLabelInfo where indexid=21231 
GO
INSERT INTO HtmlLabelIndex values(21231,'流程内容查看权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(21229,'允许查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21229,'Can see',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21230,'禁止查看',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21230,'Cann''t see',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21231,'流程内容查看权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21231,'See right of workflow infomation',8) 
GO
delete from HtmlLabelIndex where id=21235 
GO
delete from HtmlLabelInfo where indexid=21235 
GO
INSERT INTO HtmlLabelIndex values(21235,'流程类型：点击该流程类型“监控设置”栏所对应的复选框，该流程类型下的所有流程会自动展开并全部选中（不选中），') 
GO
delete from HtmlLabelIndex where id=21240 
GO
delete from HtmlLabelInfo where indexid=21240 
GO
INSERT INTO HtmlLabelIndex values(21240,'如果是设置为可查看流程内容，则所有流程的“监控设置”也会跟随选中。') 
GO
delete from HtmlLabelIndex where id=21237 
GO
delete from HtmlLabelInfo where indexid=21237 
GO
INSERT INTO HtmlLabelIndex values(21237,'流程：点击该流程所属流程类型前面的加号“＋”展开流程类型，然后，点击该流程“监控设置”栏所对应的复选框，如果设置为可监控，') 
GO
delete from HtmlLabelIndex where id=21238 
GO
delete from HtmlLabelInfo where indexid=21238 
GO
INSERT INTO HtmlLabelIndex values(21238,'则所属的流程类型也会选中；如果设置为不可监控，则该流程的“是否可查看流程内容”也会跟随变为不可查看。') 
GO
delete from HtmlLabelIndex where id=21239 
GO
delete from HtmlLabelInfo where indexid=21239 
GO
INSERT INTO HtmlLabelIndex values(21239,'所有流程：点击表头“是否可查看流程内容”前的复选框，流程树会全部选中（不选中），如果流程树没有全部展开过会自动全部展开；') 
GO
delete from HtmlLabelIndex where id=21243 
GO
delete from HtmlLabelInfo where indexid=21243 
GO
INSERT INTO HtmlLabelIndex values(21243,'流程：点击该流程所属流程类型前面的加号“＋”展开流程类型，然后，点击该流程“是否可查看流程内容”栏所对应的复选框，') 
GO
delete from HtmlLabelIndex where id=21245 
GO
delete from HtmlLabelInfo where indexid=21245 
GO
INSERT INTO HtmlLabelIndex values(21245,'右键功能，展开流程树中所有的流程类型。') 
GO
delete from HtmlLabelIndex where id=21246 
GO
delete from HtmlLabelInfo where indexid=21246 
GO
INSERT INTO HtmlLabelIndex values(21246,'右键功能，收缩流程树中所有的流程类型。') 
GO
delete from HtmlLabelIndex where id=21234 
GO
delete from HtmlLabelInfo where indexid=21234 
GO
INSERT INTO HtmlLabelIndex values(21234,'如果设置为不可监控，则所有流程的“是否可查看流程内容”也会跟随变为不可查看。') 
GO
delete from HtmlLabelIndex where id=21233 
GO
delete from HtmlLabelInfo where indexid=21233 
GO
INSERT INTO HtmlLabelIndex values(21233,'所有流程：点击表头“监控设置”前的复选框，流程树会全部选中（不选中），如果流程树没有全部展开过流程树将会自动全部展开；') 
GO
delete from HtmlLabelIndex where id=21241 
GO
delete from HtmlLabelInfo where indexid=21241 
GO
INSERT INTO HtmlLabelIndex values(21241,'流程类型：点击该流程类型“是否可查看流程内容”栏所对应的复选框，该流程类型下的所有流程会自动展开并全部选中（不选中），') 
GO
delete from HtmlLabelIndex where id=21249 
GO
delete from HtmlLabelInfo where indexid=21249 
GO
INSERT INTO HtmlLabelIndex values(21249,'2.如果流程类型下没有流程即使是选中该类型保存，再次进入编辑监控设置时该流程类型也会显示为不选中。') 
GO
delete from HtmlLabelIndex where id=21236 
GO
delete from HtmlLabelInfo where indexid=21236 
GO
INSERT INTO HtmlLabelIndex values(21236,'如果设置为不可监控，则该流程类型下的所有流程的“是否可查看流程内容”也会跟随变为不可查看。') 
GO
delete from HtmlLabelIndex where id=21244 
GO
delete from HtmlLabelInfo where indexid=21244 
GO
INSERT INTO HtmlLabelIndex values(21244,'如果是设置为可查看流程内容，则该流程的“监控设置”也会跟随选中并且所属流程类型的也会跟随选中。') 
GO
delete from HtmlLabelIndex where id=21247 
GO
delete from HtmlLabelInfo where indexid=21247 
GO
INSERT INTO HtmlLabelIndex values(21247,'“编辑”监控设置时：') 
GO
delete from HtmlLabelIndex where id=21248 
GO
delete from HtmlLabelInfo where indexid=21248 
GO
INSERT INTO HtmlLabelIndex values(21248,'1.如果流程类型下有一个流程设为可以监控，则该流程类型都显示为选中。') 
GO
delete from HtmlLabelIndex where id=21232 
GO
delete from HtmlLabelInfo where indexid=21232 
GO
INSERT INTO HtmlLabelIndex values(21232,'“新建”监控设置时可选择流程监控人，默认为当前操作人；“编辑”监控设置时流程监控人只做显示，不能修改。') 
GO
delete from HtmlLabelIndex where id=21242 
GO
delete from HtmlLabelInfo where indexid=21242 
GO
INSERT INTO HtmlLabelIndex values(21242,'如果是设置为可查看流程内容，则该类型下的所有流程的“监控设置”也会跟随选中。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21232,'“新建”监控设置时可选择流程监控人，默认为当前操作人；“编辑”监控设置时流程监控人只做显示，不能修改。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21232,'"New" monitor setup process monitoring option, the default for the current operation; "edit" monitor setup process monitoring only people that can not be changed.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21233,'所有流程：点击表头“监控设置”前的复选框，流程树会全部选中（不选中），如果流程树没有全部展开过流程树将会自动全部展开；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21233,'All workflow: Click on the first table "monitor setting" before the check box, all workflows will be selected tree (not selected), if not all processes started off tree tree will be automatically processes all started;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21234,'如果设置为不可监控，则所有流程的“是否可查看流程内容”也会跟随变为不可查看。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21234,'If set to be monitoring, all processes "Can see workflow infomation or not" will be followed into view.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21235,'流程类型：点击该流程类型“监控设置”栏所对应的复选框，该流程类型下的所有流程会自动展开并全部选中（不选中），',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21235,'Workflow types: Click on the type of workflow "monitor setting" column corresponding to the box, the workflow of all types of workflow will be automatically started and all selected (not selected),',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21236,'如果设置为不可监控，则该流程类型下的所有流程的“是否可查看流程内容”也会跟随变为不可查看。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21236,'If set to be monitoring, then the workflow of all types of workflow "Can see workflow infomation or not" will be followed into view.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21237,'流程：点击该流程所属流程类型前面的加号“＋”展开流程类型，然后，点击该流程“监控设置”栏所对应的复选框，如果设置为可监控，',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21237,'Workflow: Click on the type of workflow workflow in front of their plus "+" type process started, and then click on the workflow "monitor setting" column corresponding to the box, if configured to monitor,',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21238,'则所属的流程类型也会选中；如果设置为不可监控，则该流程的“是否可查看流程内容”也会跟随变为不可查看。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21238,'the type of process which will be elected ;If set to be monitoring, the workflow "Can see workflow infomation or not" will be followed into view.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21239,'所有流程：点击表头“是否可查看流程内容”前的复选框，流程树会全部选中（不选中），如果流程树没有全部展开过会自动全部展开；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21239,'All workflow: Click on the first table "Can see workflow infomation or not" before the check box, all workflows will be selected tree (not selected), if not all tree workflow will be automatically started off all started;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21240,'如果是设置为可查看流程内容，则所有流程的“监控设置”也会跟随选中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21240,'If it is set to workflow content can be read, all the workflows "monitor setting" will follow the elections.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21241,'流程类型：点击该流程类型“是否可查看流程内容”栏所对应的复选框，该流程类型下的所有流程会自动展开并全部选中（不选中），',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21241,'Workflow types: Click on the type of workflow "Can see workflow infomation or not" column corresponding to the box, the workflows of all types of workflow will be automatically started and all selected (not selected),',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21242,'如果是设置为可查看流程内容，则该类型下的所有流程的“监控设置”也会跟随选中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21242,'if it is configured to workflow content Show , then the workflow of all types of "monitor setting" will follow the elections.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21243,'流程：点击该流程所属流程类型前面的加号“＋”展开流程类型，然后，点击该流程“是否可查看流程内容”栏所对应的复选框，',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21243,'Workflow: Click on the type of workflow workflow in front of their plus "+" type workflow started, and then click on the workflow "Can see workflow infomation or not" column corresponding to the box,',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21244,'如果是设置为可查看流程内容，则该流程的“监控设置”也会跟随选中并且所属流程类型的也会跟随选中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21244,'if it is set up to workflow content can be read, that workflow "monitor setting" will follow their workflow and selected types of elections will follow.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21245,'右键功能，展开流程树中所有的流程类型。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21245,'Right functions, processes start the process all tree types.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21246,'右键功能，收缩流程树中所有的流程类型。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21246,'Right functions, all the contraction process in the process of tree types.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21247,'“编辑”监控设置时：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21247,'"Edit" monitor setting:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21248,'1.如果流程类型下有一个流程设为可以监控，则该流程类型都显示为选中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21248,'1. If there is a type of workflow can be set to monitor, the type of show that the workflow is selected.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21249,'2.如果流程类型下没有流程即使是选中该类型保存，再次进入编辑监控设置时该流程类型也会显示为不选中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21249,'2. Type if the workflow is not even selected processes of this type of preservation, re-entry into the editorial monitor setting will be displayed for the type of workflow is not selected.',8) 
GO
