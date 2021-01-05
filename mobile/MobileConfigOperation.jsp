
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.zip.*"%>
<%@ page import="java.io.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if (!HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

FileUpload fu = new FileUpload(request,false);
String homeLogo = "";
String licenseFile = "";
String flag = Util.null2String(fu.getParameter("flag"));
String deleteHomeLogoFlag = Util.null2String(fu.getParameter("deleteHomeLogoFlag"));
if(deleteHomeLogoFlag.equals("1")){
	int logofileid = Util.getIntValue(fu.uploadFiles("HomeLogo"));
	if(logofileid>0){
		rs.executeSql("select * from mobileconfig where mc_type = 1 and mc_name = 'target'");
		if(rs.next()){
			rs.executeSql("update mobileconfig set mc_value = '"+logofileid+"' where mc_type = 1 and mc_name = 'target'");
		} else {
			rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_name,mc_value) values(1,null,'target','"+logofileid+"')");
		}
	} else {
		rs.executeSql("delete from mobileconfig where mc_type = 1 and mc_name = 'target'");
	}
}

String headerTxt = Util.null2String(fu.getParameter("headerTxt"));
String footerTxt = Util.null2String(fu.getParameter("footerTxt"));
String xmlRpcUrl = Util.null2String(fu.getParameter("XmlRpcUrl"));

rs.executeSql("select * from mobileconfig where mc_type = 2 and mc_name = 'target'");
if(rs.next()){
	rs.executeSql("update mobileconfig set mc_value = '"+headerTxt+"' where mc_type = 2 and mc_name = 'target'");
} else {
	rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_name,mc_value) values(2,null,'target','"+headerTxt+"')");
}

rs.executeSql("select * from mobileconfig where mc_type = 3 and mc_name = 'target'");
if(rs.next()){
	rs.executeSql("update mobileconfig set mc_value = '"+footerTxt+"' where mc_type = 3 and mc_name = 'target'");
} else {
	rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_name,mc_value) values(3,null,'target','"+footerTxt+"')");
}

rs.executeSql("select * from mobileconfig where mc_type = 4 and mc_name = 'target'");
if(rs.next()){
	rs.executeSql("update mobileconfig set mc_value = '"+xmlRpcUrl+"' where mc_type = 4 and mc_name = 'target'");
} else {
	rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_name,mc_value) values(4,null,'target','"+xmlRpcUrl+"')");
}

String mobilemodule[] = fu.getParameters("usr_module"); 
String mobilescope[] = fu.getParameters("usr_scope"); 
String mobilevalue[] = fu.getParameters("usr_value"); 

if(mobilemodule!=null&&mobilemodule.length>0){
	rs.executeSql("delete from mobileconfig where mc_type = 8");
	rs.next();
	for(int i=0;i<mobilemodule.length;i++){
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values(8,"+mobilemodule[i]+","+Util.getIntValue(mobilescope[i],0)+",'target','"+mobilevalue[i]+"')");
	}
}

int moduleConfigsCount = Util.getIntValue(fu.getParameter("configTotal"));
String[] moduleConfigIds = fu.getParameters("config_ids");
String[] configTypes = fu.getParameters("config_types");
String[] configScopes = fu.getParameters("config_scopes");
String[] configTargets = fu.getParameters("config_targets");
String[] configTypeids = fu.getParameters("config_typeids");
String[] configFlowids = fu.getParameters("config_flowids");
String[] configNodeids = fu.getParameters("config_nodeids");
String[] configFroms = fu.getParameters("config_froms");
String[] configFromids = fu.getParameters("config_fromids");
String[] configIncludereplays = fu.getParameters("config_includereplays");
String[] configLabels = fu.getParameters("config_labels");
String[] configModules = fu.getParameters("config_modules");
String[] configVisibles = fu.getParameters("config_visibles");
String[] configIndexs = fu.getParameters("config_indexs");

String[] configDeleteIconFlags = fu.getParameters("config_deleteiconflags");
String[] configIconIndexs = fu.getParameters("config_iconindexs");
String[] configIconIds = fu.getParameters("config_iconids");
String[] configIconFiles = configIconIndexs!=null?new String[configIconIndexs.length]:null;
for(int i=0;configIconIndexs!=null&&i<configIconIndexs.length;i++){
	configIconFiles[i] = "config_iconfile_" + configIconIndexs[i];
}
String[] configIconFileIds = configIconFiles!=null?fu.uploadFiles(configIconFiles):null;

Map configs = new HashMap();
List configorders = new ArrayList();
int maxscope = 0;
for(int i=0;i<moduleConfigsCount;i++){
	int id = Util.getIntValue(moduleConfigIds[i]);
	int type = Util.getIntValue(configTypes[i]);
	int scope = Util.getIntValue(configScopes[i]);
	String target = configTargets[i];
	String typeids = configTypeids[i];
	String flowids = configFlowids[i];
	String nodeids = configNodeids[i];
	String from = configFroms[i];
	String fromid = configFromids[i];
	String includereplay = configIncludereplays[i];
	String label = new String(Util.null2String(configLabels[i]).getBytes("ISO8859_1"),"UTF-8");
	String module = configModules[i];
	
	String visible = "0";
	for(int p=0;configVisibles!=null&&p<configVisibles.length;p++){
		if(Util.getIntValue(configVisibles[p])==scope){
			visible = "1";
			break;
		}
	}
	
	String deleteIconFlag = configDeleteIconFlags[i];
	int iconfileid = 0;
	if(deleteIconFlag.equals("1")){
		iconfileid = Util.getIntValue(configIconFileIds[i]);
	} else {
		iconfileid = Util.getIntValue(configIconIds[i]);
	}
	
	int index = Util.getIntValue(configIndexs[i]);
	if(id>0&&scope>maxscope) maxscope = scope;
	Map configdata = new HashMap();
	configdata.put("id",id+"");
	configdata.put("type",type+"");
	configdata.put("module",module+"");
	configdata.put("scope",scope+"");
	
	configdata.put("target",target+"");
	configdata.put("from",from+"");
	configdata.put("fromid",fromid+"");
	configdata.put("includereplay",includereplay+"");
	
	configdata.put("typeids",typeids+"");
	configdata.put("flowids",flowids+"");
	configdata.put("nodeids",nodeids+"");
	
	configdata.put("label",label+"");

	configdata.put("visible",visible+"");

	configdata.put("index",index+"");
	
	if(iconfileid>0) configdata.put("icon",iconfileid+"");
	
	String key = (index<10?"0"+index:index+"")+"_"+i;
	
	configs.put(key,configdata);
	configorders.add(key);
}
Collections.sort(configorders,String.CASE_INSENSITIVE_ORDER);
rs.executeSql("delete from mobileconfig where mc_type = 5");
rs.next();
for(int i=0;i<configorders.size();i++){
	String key = (String)configorders.get(i);
	//String index = (i+1)+"";
	Map configdata = (Map) configs.get(key);
	String index = (String)configdata.get("index");
	String id = (String)configdata.get("id");
	String type = (String)configdata.get("type");
	String module = (String)configdata.get("module");
	String scope = (String)configdata.get("scope");
	String icon = (String)configdata.get("icon");
	if(type==null||"".equals(type)||"null".equals(type)) continue;
	if(module==null||"".equals(module)||"null".equals(module)) continue;
	if(scope==null||"".equals(scope)||"null".equals(scope)) continue;
	
	if(Util.getIntValue(id)==0) scope = (++maxscope)+"";
	
	if(configdata.get("target")!=null&&!"".equals(configdata.get("target"))&&!"null".equals(configdata.get("target")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'target','"+configdata.get("target")+"')");
	
	if(configdata.get("typeids")!=null&&!"".equals(configdata.get("typeids"))&&!"null".equals(configdata.get("typeids")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'typeids','"+configdata.get("typeids")+"')");
	if(configdata.get("flowids")!=null&&!"".equals(configdata.get("flowids"))&&!"null".equals(configdata.get("flowids")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'flowids','"+configdata.get("flowids")+"')");
	if(configdata.get("nodeids")!=null&&!"".equals(configdata.get("nodeids"))&&!"null".equals(configdata.get("nodeids")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'nodeids','"+configdata.get("nodeids")+"')");

	if(configdata.get("label")!=null&&!"".equals(configdata.get("label"))&&!"null".equals(configdata.get("label")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'label','"+configdata.get("label")+"')");

	if(configdata.get("visible")!=null&&!"".equals(configdata.get("visible"))&&!"null".equals(configdata.get("visible")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'visible','"+configdata.get("visible")+"')");

	if(configdata.get("index")!=null&&!"".equals(configdata.get("index"))&&!"null".equals(configdata.get("index")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'index','"+index+"')");
	
	if(configdata.get("icon")!=null&&!"".equals(configdata.get("icon"))&&!"null".equals(configdata.get("icon")))
		rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_scope,mc_name,mc_value) values("+type+","+module+","+scope+",'icon','"+icon+"')");
}

rs.executeSql("select * from mobileconfig where mc_type = 0 and mc_name = 'target'");
if(rs.next()){
	rs.executeSql("update mobileconfig set mc_value = '"+(new Date()).getTime()+"' where mc_type = 0 and mc_name = 'target'");
} else {
	rs.executeSql("insert into mobileconfig(mc_type,mc_module,mc_name,mc_value) values(0,null,'target','"+(new Date()).getTime()+"')");
}
%>
<script type="text/javascript">
alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
location.href = '/mobile/MobileConfig.jsp';
</script>