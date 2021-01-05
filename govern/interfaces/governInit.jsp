<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="weaver.formmode.setup.ModeRightInfoThread"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="com.alibaba.fastjson.JSON" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.alibaba.fastjson.serializer.SerializerFeature" %>
<%@ page import="weaver.govern.service.GovernInitService" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
//--------删除汇报.催办.变更.项目模块流程转数据的内容--------
rs.execute("delete from mode_workflowtomodesetdetail where mainid in (select id from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办汇报'))");
rs.execute("delete from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办汇报')");
rs.execute("delete from mode_workflowtomodesetdetail where mainid in (select id from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办任务变更'))");
rs.execute("delete from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办任务变更')");
rs.execute("delete from mode_workflowtomodesetdetail where mainid in (select id from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办任务催办'))");
rs.execute("delete from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办任务催办')");
rs.execute("delete from mode_workflowtomodesetdetail where mainid in (select id from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办项目'))");
rs.execute("delete from mode_workflowtomodeset where modeid=(select id from modeinfo where modename = '督办项目')");
//------------新增菜单表数据start------------
//------------新增菜单表数据start------------
int id = 0;
GovernInitService gis = new GovernInitService();
ModeRightInfoThread modeRightInfoThread = new ModeRightInfoThread();
rs.execute("select id from modeinfo where modename = '督办任务类型'");
if(rs.next()){
	id = Util.getIntValue(rs.getString("id"),0);
}
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'2018政府工作报告',1,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'2018十件民生实事',1,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'群众投诉',0,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'提议案',0,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'会议纪要',0,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'重大项目',0,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'领导批示',0,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'重点工作',0,1)");
rs.execute("insert into uf_governor_categor (formmodeid,objname,isUsed,modedatacreater)values("+id+",'重大决策',0,1)");

modeRightInfoThread = new ModeRightInfoThread();
modeRightInfoThread.setModeId(id);
modeRightInfoThread.setRebulidFlag("governRebuild");
modeRightInfoThread.setSession(session);
modeRightInfoThread.resetModeRight();


rs.execute("select id from modeinfo where modename = '督办任务来源'");
if(rs.next()){
	id = Util.getIntValue(rs.getString("id"),0);
}
rs.execute("insert into uf_governor_source (formmodeid,sourceName,isUsed,modedatacreater)values("+id+",'会议决议',0,1)");
rs.execute("insert into uf_governor_source (formmodeid,sourceName,isUsed,modedatacreater)values("+id+",'中央精神',0,1)");
rs.execute("insert into uf_governor_source (formmodeid,sourceName,isUsed,modedatacreater)values("+id+",'上级发文',0,1)");
rs.execute("insert into uf_governor_source (formmodeid,sourceName,isUsed,modedatacreater)values("+id+",'领导指示',0,1)");
rs.execute("insert into uf_governor_source (formmodeid,sourceName,isUsed,modedatacreater)values("+id+",'上级要求',0,1)");

modeRightInfoThread = new ModeRightInfoThread();
modeRightInfoThread.setModeId(id);
modeRightInfoThread.setRebulidFlag("governRebuild");
modeRightInfoThread.setSession(session);
modeRightInfoThread.resetModeRight();


rs.execute("select id from modeinfo where modename = '督办菜单设置'");
if(rs.next()){
	id = Util.getIntValue(rs.getString("id"),0);
}
String lxid = "";
String lyid = "";
String cdid = "";
String sxid = "";
String qxid = "";
rs.execute("SELECT * FROM mode_customsearch WHERE customname = '督办任务类型'");
if(rs.next()){
	lxid = rs.getString("id");
}
rs.execute("SELECT * FROM mode_customsearch WHERE customname = '督办来源维护'");
if(rs.next()){
	lyid = rs.getString("id");
}
rs.execute("SELECT * FROM mode_customsearch WHERE customname = '督办菜单设置'");
if(rs.next()){
	cdid = rs.getString("id");
}
rs.execute("SELECT * FROM mode_customsearch WHERE customname = '督办菜单设置'");
if(rs.next()){
	cdid = rs.getString("id");
}
rs.execute("SELECT * FROM mode_customtree WHERE treename = '督办菜单'");
if(rs.next()){
	sxid = rs.getString("id");
}
rs.execute("SELECT * FROM mode_customsearch WHERE customname = '菜单权限设置'");
if(rs.next()){
	qxid = rs.getString("id");
}


rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'督办中心','share-alt','',0,'','',1,1)");
String pid = gis.getPid();
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'我的督办','','/govern/spa/index1.html#/formmode/governor',0,'"+pid+"','',1,2)");
//rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'组织督办','','/govern/spa/index1.html#/formmode/governor',0,'"+pid+"','',1,3)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'任务中心','usergroup-add','',0,'','',1,2)");
pid = gis.getPid();
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'主办任务','','/govern/spa/index1.html#/formmode/task?dealtype=0',0,'"+pid+"','',1,4)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'协办任务','','/govern/spa/index1.html#/formmode/task?dealtype=1',0,'"+pid+"','',1,5)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'任务下发','','/govern/spa/index1.html#/formmode/distribution',0,'"+pid+"','',1,3)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'系统设置','setting','',0,'','',1,3)");
pid = gis.getPid();
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'督办触发设置','','/govern/spa/index1.html#/formmode/actionSet',0,'"+pid+"','',1,6)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'督办类型设置','','/formmode/search/CustomSearchBySimple.jsp?customid="+lxid+"',0,'"+pid+"','',1,7)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'督办来源设置','','/formmode/search/CustomSearchBySimple.jsp?customid="+lyid+"',0,'"+pid+"','',1,8)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'菜单维护','','/formmode/search/CustomSearchBySimple.jsp?customid="+cdid+"',0,'"+pid+"','',1,9)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'菜单结构','','/formmode/tree/ViewCustomTree.jsp?id="+sxid+"',0,'"+pid+"','',1,10)");
rs.execute("insert into uf_govern_menuset (formmodeid,menuName,icon,linkUrl,showType,pMenu,isUsed,modedatacreater,sort)values("+id+",'菜单权限维护','','/formmode/search/CustomSearchBySimple.jsp?customid="+qxid+"',0,'"+pid+"','',1,11)");

modeRightInfoThread = new ModeRightInfoThread();
modeRightInfoThread.setModeId(id);
modeRightInfoThread.setRebulidFlag("governRebuild");
modeRightInfoThread.setSession(session);
modeRightInfoThread.resetModeRight();


rs.execute("select id from modeinfo where modename = '督办菜单权限设置'");
if(rs.next()){
	id = Util.getIntValue(rs.getString("id"),0);
}
rs.execute("select * from uf_govern_menuset");
while(rs.next()){
	String menuid = rs.getString("id");
	rs1.execute("insert into uf_govern_permiss (formmodeid,menuId,showType,seclevel,modedatacreater)values("+id+",'"+menuid+"',0,10,1)");
	String menuName = rs.getString("menuName");
	if(menuName.equals("系统设置")){
		rs1.execute("update uf_govern_permiss set showType =  5,showRole = '2' where menuid = '"+menuid+"'");	
	}
}
modeRightInfoThread = new ModeRightInfoThread();
modeRightInfoThread.setModeId(id);
modeRightInfoThread.setRebulidFlag("governRebuild");
modeRightInfoThread.setSession(session);
modeRightInfoThread.resetModeRight();

//------------新增菜单表数据end------------
//------------新增菜单表数据end------------

//------------接口动作start------------
rs.execute("select count(1) cou from actionsetting where actionclass='weaver.govern.interfaces.GovernorPostponeAction'");
if(rs.next()){
	int count = Util.getIntValue(rs.getString("cou"));
	if(count==0){
		rs.execute("insert into actionsetting(actionname,actionclass,actionshowname) values ('GovernorPostponeAction','weaver.govern.interfaces.GovernorPostponeAction','GovernorPostponeAction')");
		rs.execute("insert into actionsetting(actionname,actionclass,actionshowname) values ('TaskSplitAction','weaver.govern.interfaces.TaskSplitAction','TaskSplitAction')");
		rs.execute("insert into actionsetting(actionname,actionclass,actionshowname) values ('GovernorInitAction','weaver.govern.interfaces.GovernorInitAction','GovernorInitAction')");
		}
}
//------------接口动作end------------

//------------初始化设置表信息start------------
String setModeid = "";//督办设置模块id
String setFormid = "";//督办设置表单id
String projectModeid = "";//督办项目模块id
String projectFormid = "";//督办项目表单id
String taskModeid = "";//督办任务模块id
String taskFormid = "";//督办任务表单id
String operaterModeid = "";//督办操作者模块id
String operaterFormid = "";//督办操作者表单id
String splitModeid = "";//分解模块id
String splitFormid = "";//分解表单id
	
String wfid1 = "";//汇报流程id
String wfid2 = "";//催办流程id
String wfid3 = "";//变更流程id
String wfid4 = "";//立项流程id
rs.execute("select * from workflow_base where workflowname like '督办汇报流程%' and workflowdesc='督办汇报流程(key=20180228)'");
if(rs.next()){
	wfid1 = Util.null2String(rs.getString("id"));
}
rs.execute("select * from workflow_base where workflowname like '任务催办流程%' and workflowdesc='任务催办流程(key=20180228)'");
if(rs.next()){
	wfid2 = Util.null2String(rs.getString("id"));
}

rs.execute("select * from workflow_base where workflowname like '督办任务变更流程%' and workflowdesc='督办任务变更流程(key=20180228)'");
if(rs.next()){
	wfid3 = Util.null2String(rs.getString("id"));
}

rs.execute("select * from workflow_base where workflowname like '督办立项流程%' and workflowdesc='督办立项流程(key=20180228)'");
if(rs.next()){
	wfid4 = Util.null2String(rs.getString("id"));
}

rs.execute("select m.id,m.formid from modeinfo m,workflow_bill w where m.formid = w.id and m.modename='督办设置' and w.tablename='uf_govern_setting'");
if(rs.next()){
	setModeid = Util.null2String(rs.getString("id"));
	setFormid = Util.null2String(rs.getString("formid"));
}

rs.execute("select m.id,m.formid from modeinfo m,workflow_bill w where m.formid = w.id and m.modename='督办项目' and w.tablename='uf_governor_project'");
if(rs.next()){
	projectModeid = Util.null2String(rs.getString("id"));
	projectFormid = Util.null2String(rs.getString("formid"));
}

rs.execute("select m.id,m.formid from modeinfo m,workflow_bill w where m.formid = w.id and m.modename='督办任务' and w.tablename='uf_governor_task'");
if(rs.next()){
	taskModeid = Util.null2String(rs.getString("id"));
	taskFormid = Util.null2String(rs.getString("formid"));
}

rs.execute("select m.id,m.formid from modeinfo m,workflow_bill w where m.formid = w.id and m.modename='督办操作者' and w.tablename='uf_govern_operatros'");
if(rs.next()){
	operaterModeid = Util.null2String(rs.getString("id"));
	operaterFormid = Util.null2String(rs.getString("formid"));
}

rs.execute("select m.id,m.formid from modeinfo m,workflow_bill w where m.formid = w.id and m.modename='任务分解' and w.tablename='uf_tasksplit'");
if(rs.next()){
	splitModeid = Util.null2String(rs.getString("id"));
	splitFormid = Util.null2String(rs.getString("formid"));
}

if(!"".equals(wfid1)){
	rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
			+"values ('"+setModeid+"','1','0','督办汇报流程','1','汇报','uf_governor_task','1','"+wfid1+"')");
	rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
			+"values ('"+setModeid+"','1','0','督办汇报流程-督办','1','督办','uf_governor_task','2','"+wfid1+"')");
	rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
			+"values ('"+setModeid+"','1','0','督办汇报流程-会办','1','会办','uf_governor_task','3','"+wfid1+"')");
	rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
			+"values ('"+setModeid+"','1','0','督办汇报流程-退办','1','退办','uf_governor_task','4','"+wfid1+"')");
	rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
		+"values ('"+setModeid+"','1','0','督办汇报流程-升办','1','升办','uf_governor_task','5','"+wfid1+"')");
}
if(!"".equals(wfid2)){
	rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
		+"values ('"+setModeid+"','1','0','任务催办','1','催办','uf_governor_task','6','"+wfid2+"')");
}
if(!"".equals(wfid3)){
rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
		+"values ('"+setModeid+"','1','0','任务延期申请','1','延期','uf_governor_task','7','"+wfid3+"')");
rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
		+"values ('"+setModeid+"','1','0','任务废弃申请','1','取消','uf_governor_task','8','"+wfid3+"')");
rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,topic,enable,name,tablename,settype,flowid)"
		+"values ('"+setModeid+"','1','0','任务变更申请','1','变更','uf_governor_task','9','"+wfid3+"')");
}
String projectLink = "/formmode/view/AddFormMode.jsp?type=0&modeId="+projectModeid+"&formId="+projectFormid+"&";
String taskLink = "/formmode/view/AddFormMode.jsp?type=0&modeId="+taskModeid+"&formId="+taskFormid+"&";
rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,projectLink,enable,name,tablename,taskLink,settype,projectflowid,projectmodeid,operatermodeid,taskmodeid)"
		+"values ('"+setModeid+"','1','0','"+projectLink+"','1','基本','uf_governor_task','"+taskLink+"','10','"+wfid4+"','"+projectModeid+"','"+operaterModeid+"','"+taskModeid+"')");

rs.execute("insert into uf_govern_setting (formmodeid,modedatacreater,modedatacreatertype,enable,name,tablename,settype,splitModeid)"
		+"values ('"+setModeid+"','1','0','1','任务分解','uf_governor_task','11','"+splitModeid+"')");
//------------初始化设置表信息end------------


//------------初始化字段对照关系start------------
//汇报相关
Map<String,String> map = new HashMap<String,String>();
map.put("taskprocess","Processing");
map.put("attachment","attach");
map.put("detail","reason");
map.put("topic","taskName");
map.put("taskName","id");
map.put("progress","progress");
map.put("schedule","schedule");
map.put("superiors","superiors");//全部上级任务 
map.put("Taskapprover","Taskapprover");//全部上级责任人

gis.initTriggerField("1,2,3,4,5",map);


//催办相关

map = new HashMap<String,String>();
map.put("taskprocess","status");
map.put("attachment","attach");
map.put("superior","superior");
map.put("detail","reason");
map.put("urgency","urgency");
map.put("topic","taskName");
map.put("remark","remark");
map.put("unit","unit");
map.put("coordinator","coordinator");
map.put("reason","reason");
map.put("taskName","id");
map.put("category","category");
map.put("startDate","startDate");
map.put("endDate","endDate");
map.put("taskName","taskName");
map.put("governoName","project");
map.put("task","id");
map.put("source","source");
map.put("sponsor","sponsor");
map.put("responsible","responsib");
map.put("tel","tel");
map.put("leaders","leaders");

gis.initTriggerField("6",map);

//变更相关
map = new HashMap<String,String>();
map.put("leaders","leaders");
map.put("goals","goals");
map.put("superior","superior");
map.put("category","category");
map.put("coordinator","coordinator");
map.put("responcomp","responcomp");
map.put("source","source");
map.put("supervisionCode","supervisionCode");
map.put("delayDate","endDate");
map.put("sponsor","sponsor");
map.put("taskName","taskName");
map.put("task","id");
map.put("taskType","taskType");
map.put("status","status");
map.put("project","project");
map.put("importance","importance");
map.put("responsib","responsib");
map.put("urgency","urgency");
map.put("remark","remark");
map.put("startDate","startDate");
map.put("endDate","endDate");
map.put("reportq","reportq");
map.put("weekre","weekre");
map.put("monthre","monthre");
map.put("secondre","secondre");

gis.initTriggerField("7,8,9",map);

//分解设置
gis.initSplitField();
//------------初始化字段对照关系end------------





//------------流程转数据设置start------------
//初始化流程转数据设置信息 
String reportModeid = "";// 督办汇报模块id
String postponeModeid = "";// 督办任务变更模块id
String pressModeid = "";// 督办任务催办模块id 
rs.execute("select * from modeinfo where modename = '督办汇报'");
if(rs.next()){
	reportModeid = Util.null2String(rs.getString("id"));
}
rs.execute("select * from modeinfo WHERE modename = '督办任务变更'");
if(rs.next()){
	postponeModeid = Util.null2String(rs.getString("id"));
}
rs.execute("select * from modeinfo WHERE modename = '督办任务催办'");
if(rs.next()){
	pressModeid = Util.null2String(rs.getString("id"));
}
//汇报流程转数据 
rs.execute("insert into mode_workflowtomodeset (modeid,workflowid,modecreater,modecreaterfieldid,isenable,formtype,maintableopttype)"
		+"values ("+reportModeid+", "+wfid1+" , 1 , 0 , 1 ,'maintable','1')");
//催办流程转数据
rs.execute("insert into mode_workflowtomodeset (modeid,workflowid,modecreater,modecreaterfieldid,isenable,formtype,maintableopttype)"
		+"values ("+pressModeid+", "+wfid2+" , 1 , 0 , 1 ,'maintable','1')");
//变更流程转数据
rs.execute("insert into mode_workflowtomodeset (modeid,workflowid,modecreater,modecreaterfieldid,isenable,formtype,maintableopttype)"
		+"values ("+postponeModeid+", "+wfid3+" , 1 , 0 , 1 ,'maintable','1')");
//立项流程转数据
rs.execute("insert into mode_workflowtomodeset (modeid,workflowid,modecreater,modecreaterfieldid,isenable,formtype,maintableopttype)"
		+"values ("+projectModeid+", "+wfid4+" , 1 , 0 , 1 ,'maintable','1')");
String mainid= "";
rs.execute("select * from  mode_workflowtomodeset where modeid = " + projectModeid);
if(rs.next()){
	mainid = rs.getString("id");
}
rs.execute("insert into mode_workflowtomodesetopt (mainid,detailtablename)"
		+"values ("+mainid+",'uf_governor_project_dt1')");

//汇报相关
map = new HashMap<String,String>();
map.put("attachment","attachment");
map.put("reportDate","reportDate");
map.put("taskName","taskName");
map.put("taskprocess","taskprocess");
map.put("topic","topic");
map.put("type","type");
map.put("detail","detail");
map.put("operator","operator");
map.put("flowid","flowid");   //请求ID
String reporttablename = "uf_govern_report";

gis.initWorkflowToModeset(reportModeid,reporttablename,map);

//催办相关
map = new HashMap<String,String>();
map.put("reminder","reminder");
map.put("source","source");
map.put("responcomp","responcomp");
map.put("sponsor","sponsor");
map.put("responsible","responsible");
map.put("leaders","leaders");
map.put("category","category");
map.put("attach","attach");
map.put("taskName","taskName");
map.put("tel","tel");
map.put("remark","remark");
map.put("reason","reason");
map.put("coordinator","coordinator");
map.put("goals","goals");
map.put("task","task");
map.put("flowid","flowid");   //请求ID
String presstablename = "uf_governor_press";

gis.initWorkflowToModeset(pressModeid,presstablename,map);

//变更相关
map = new HashMap<String,String>();
map.put("endDate","endDate");
map.put("changeType","changeType");
map.put("taskName","taskName");
map.put("coordinator","coordinator");
map.put("reason","reason");
map.put("startDate","startDate");
map.put("remark","remark");
map.put("sponsor","sponsor");
map.put("project","project");
map.put("delayDate","delayDate");
String postponetablename = "uf_govern_postpone";

gis.initWorkflowToModeset(postponeModeid,postponetablename,map);

//立项相关
map = new HashMap<String,String>();
map.put("superior","superior");
map.put("tel","tel");
map.put("xiebbm","xiebbm");
map.put("responcomp","responcomp");
map.put("supervisionCode","supervisionCode");
map.put("leaders","leaders");
map.put("source","source");
map.put("urgency","urgency");
map.put("endDate","endDate");
map.put("responsible","responsible");
map.put("presenter","handler");
map.put("unit","unit");
map.put("xiebbmfzr","xiebbmfzr");
map.put("attach","attach");
map.put("goals","goals");
map.put("sponsor","responsible");
map.put("category","category");
map.put("classification","classification");
map.put("startDate","startDate");
map.put("flowid","flowid");   //请求ID
map.put("governoName","pname"); 
String projecttablename = "uf_governor_project";

gis.initWorkflowToModeset(projectModeid,projecttablename,map);
map = new HashMap<String,String>();
map.put("startDate","startDate");
map.put("endDate","endDate");
map.put("sponsor","sponsor");
map.put("stageContent","stageContent");
map.put("stageName","stageName");
map.put("coordinator","coordinator");

gis.initWorkflowToModesetproject(projectModeid,map);

//-------------流程转数据设置end-------------
Map returnmap = new HashMap();
returnmap.put("message","");
returnmap.put("success",true);
response.setContentType("application/x-www-form-urlencoded; charset=utf-8");
response.getWriter().write(JSON.toJSONString(returnmap,SerializerFeature.DisableCircularReferenceDetect));
response.getWriter().flush();
response.getWriter().close();
%>