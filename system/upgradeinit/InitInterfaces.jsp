<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.io.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<script language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
StringBuffer sqlsb = new StringBuffer();

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelNames("567,17530,20873",user.getLanguage());//版本升级初始化
String needfav ="1";
String needhelp ="";
//action初始化

RecordSet.executeSql("update initservicexmlstate set actioninterface=0");
RecordSet.executeSql("update initservicexmlstate set browser=0");

//browser
int searchbyname=0;
int customid=0;
String searchbynamemessage="";
String customidmessage="";
String sql;
if (RecordSet.getDBType().equalsIgnoreCase("oracle")) {
    sql = "SELECT COUNT(1) FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'DATASHOWSET' AND COLUMN_NAME = 'SEARCHBYNAME' ";
} else {
    sql = "select count(1) from syscolumns where id=object_id(datashowset) and name=searchByName ";
}

boolean bool = RecordSet.executeSql(sql);
if(bool && RecordSet.next() && Util.getIntValue(RecordSet.getString(1))==1){
	searchbyname=1;
}else{
	if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
		searchbynamemessage = "alter table datashowset add searchByName varchar2(4000);";
	}else{
		searchbynamemessage = "alter table datashowset add searchByName varchar(4000);";
	}
}
if (RecordSet.getDBType().equalsIgnoreCase("oracle")) {
    sql = "SELECT COUNT(1) FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'DATASHOWSET' AND COLUMN_NAME = 'CUSTOMID' ";
} else {
    sql = "select count(1) from syscolumns where id=object_id(datashowset) and name=customid ";
}
bool = RecordSet.executeSql(sql);
if(bool && RecordSet.next() && Util.getIntValue(RecordSet.getString(1))==1){
	customid = 1;
}else{
	if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
		customidmessage = "alter table datashowset add customid int";
	}else{
		customidmessage = "alter table datashowset add customid int";
	}
}


//action
sqlsb = new StringBuffer();
if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
    sqlsb.append("select COUNT(id) from workflowactionset ");
    sqlsb.append(" where instr(actionname,'action.',1,1) = 1 ");
    sqlsb.append(" or instr(interfaceid,'action.',1,1)=1");
}else{
    sqlsb.append("select COUNT(id) from workflowactionset ");
    sqlsb.append(" where charindex('action.',actionname)=1");
    sqlsb.append(" or charindex('action.',interfaceid)=1");
}
RecordSet.executeSql(sqlsb.toString());
RecordSet.next();
int oldactioncount = Util.getIntValue(RecordSet.getString(1));//旧Action的个数

//action.xml,非windows系统需要将编码重置为UTF-8
Properties prop = System.getProperties();
String os = prop.getProperty("os.name");
//System.out.println("system:"+os+"---"+os.toLowerCase()+"==="+os.toLowerCase().startsWith("win"));

//webservice
sqlsb = new StringBuffer();
if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
    sqlsb.append("select COUNT(id) from wsformactionset t  ");
    sqlsb.append(" where not exists (");
    sqlsb.append("     select 1 from wsformactionset t1 join wsregiste t2 ");
    sqlsb.append("      on t1.wsurl = to_char(t2.id) where t.id=t1.id");
    sqlsb.append(" )");
}else{
    sqlsb.append("select COUNT(id) from wsformactionset t  ");
    sqlsb.append(" where not exists (");
    sqlsb.append("     select 1 from wsformactionset t1 join wsregiste t2 ");
    sqlsb.append("      on t1.wsurl = convert(varchar(1000),t2.id) where t.id=t1.id");
    sqlsb.append(" )");
}
RecordSet.executeSql(sqlsb.toString());
RecordSet.next();
int oldwebservicecount = Util.getIntValue(RecordSet.getString(1));//旧Webservice的个数

//DML
sqlsb = new StringBuffer();
if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
    sqlsb.append(" select count(1) from formactionset a, formactionsqlset b ");
    sqlsb.append(" where a.id = b.actionid and a.formid < 0 ");
    sqlsb.append(" and instr(b.actiontable, -a.formid) = 0 ");
}else{
    sqlsb.append(" select count(1) from formactionset a, formactionsqlset b ");
    sqlsb.append(" where a.id = b.actionid and a.formid < 0 ");
    sqlsb.append(" and charindex(cast(-a.formid as varchar), b.actiontable) = 0 ");
}
RecordSet.executeSql(sqlsb.toString());
RecordSet.next();
int errordmlcount = Util.getIntValue(RecordSet.getString(1));//数据有误的DML接口个数

String messages = "<font color=red>\u5df2\u521d\u59cb\u5316\u6216\u65e0\u65e7\u7248\u672c\u6570\u636e</font>";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{确定,javascript:doSubmit(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mnav18_wev8.png"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("567,17530,20873",user.getLanguage())%>'/>
</jsp:include>

<form id="proform" name="proform" method="post" action="InitInterfacesOperation.jsp">
<input type=hidden name="operate" id="operate">
<wea:layout type="2col">
	<!-- 集成中心 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(32269,user.getLanguage()) %>" >
	  <wea:item>Action<%=SystemEnv.getHtmlLabelName(32363,user.getLanguage()) %></wea:item>
	  <wea:item>
	  <%if(oldactioncount > 0){//Action表中有旧版本数据，不需要初始化%>
		    <input type="button" value="<%=SystemEnv.getHtmlLabelNames("20873,563",user.getLanguage()) %>" id="action_init" class="e8_btn" _type="action" onclick="upgradeInit(this)">
	  <%}else{%>
		    <%=messages %><%-- 无旧版本数据，不需要初始化操作 --%>
	  <%}%>
	  <%if(!os.toLowerCase().startsWith("win")){//非windows系统%>
	  		<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>&nbsp;action.xml&nbsp;<%=SystemEnv.getHtmlLabelName(1321,user.getLanguage()) %>" id="action_xml" class="e8_btn" _type="actionxml" onclick="upgradeInit(this)">
	  <%} %>
	  </wea:item>
	  
	  <wea:item>Webservice<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage()) %></wea:item>
	  <wea:item>
	  <%if(oldwebservicecount > 0){//Action表中有旧版本数据，不需要初始化%>
		    <input type="button" value="<%=SystemEnv.getHtmlLabelNames("20873,563",user.getLanguage()) %>" id="action_init" class="e8_btn" _type="webservice" onclick="upgradeInit(this)">
	  <%}else{%>
		    <%=messages %><%-- 无旧版本数据，不需要初始化操作 --%>
	  <%}%>
	  </wea:item>
	  
	  <wea:item>DML<%=SystemEnv.getHtmlLabelName(32363,user.getLanguage()) %></wea:item>
	  <wea:item>
	  <%if(errordmlcount > 0){%>
		    <input type="button" value="<%=SystemEnv.getHtmlLabelNames("20873,563",user.getLanguage()) %>" id="dml_init" class="e8_btn" _type="dml" onclick="upgradeInit(this)">
	  <%}else{%>
		    <%=messages %><%-- 无旧版本数据，不需要初始化操作 --%>
	  <%}%>
	  </wea:item>
	  
	  <wea:item>初始化数据展现集成</wea:item>
	  <wea:item>
		     <%if(searchbyname == 1&&customid==1){//searchbyname字段存在%>
		    <%=messages %>
	  <%}else{%>
		    请再数据库中执行以下脚本<%=searchbynamemessage %><%=customidmessage %>。并重启服务
	  <%}%>
	  </wea:item>
	   <wea:item>初始化action</wea:item>
	  <wea:item>
		    <input type="button" value="<%=SystemEnv.getHtmlLabelNames("20873,563",user.getLanguage()) %>" id="actioninit" class="e8_btn" _type="initaction" onclick="initaction(this)">
	  </wea:item>
	</wea:group>
</wea:layout>
</form>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>

</BODY>
<script type="text/javascript">
function upgradeInit(obj){
	enableAllmenu();
	jQuery(".e8_btn").attr("disabled",true);
	var operate = jQuery(obj).attr("_type");
	jQuery("#operate").val(operate);
	proform.submit();
}
function initaction(obj){
Dialog.alert("请重启resin服务!");
}

jQuery(document).ready(function () {
showEle("loginidspanStr");
})
</script>
</HTML>