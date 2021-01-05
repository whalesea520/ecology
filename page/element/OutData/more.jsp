
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<!--QC286164  [80][90]外部数据元素-more页面右键菜单问题 start-->
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
	<!--QC286164  [80][90]外部数据元素-more页面右键菜单问题 end-->
    <style type="text/css">
    thead {display:none}
    </style>
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("81512",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->more.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>
<%
String eid = Util.null2String(request.getParameter("eid"));
String tabid = Util.null2String(request.getParameter("tabid"));
String titlename = SystemEnv.getHtmlLabelName(81512,user.getLanguage());
String PageConstId ="OutData_More_"+eid+"_"+tabid; //QC287886  [80][90]外部数据元素-more页面右键菜单【显示列定制】数量与对应tab页数量不匹配
%>
<BODY>
<div>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(81512,user.getLanguage()) %>"/>  
	</jsp:include>
    <DIV align=right>
	<!--QC286164  [80][90]外部数据元素-more页面右键菜单问题 start-->
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String typename = Util.null2String(request.getParameter("typename"));
if(tabid.equals("")){
    User userForTabid = (User)request.getSession(true).getAttribute("weaver_user@bean");
    if(userForTabid!=null){
        rs.execute("select currenttab from hpcurrenttab where eid="+eid
                + " and userid="
                + userForTabid.getUID()
                + " and usertype="
                + userForTabid.getType());
        if(rs.next()){
            tabid =rs.getString("currenttab");
            PageConstId ="OutData_More_"+eid+"_"+tabid;
        }

    }else{

        rs.execute("select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by tabId");

        if(rs.next()){
            //System.out.println("2******"+tabid);
            PageConstId ="OutData_More_"+eid+"_"+tabid;
        }

    }
}
String type = "";
String title = "";
int clos = 0;
String selType = "select type,title from hpOutDataTabSetting where eid = "+eid+" and tabid = "+tabid;
rs.executeSql(selType);

if(rs.next()) {
	type = rs.getString("type");
	title = rs.getString("title"); //QC294399 [80][90]外部数据元素-tab页点击more后显示页面建议加上tab页名称
} else {
	selType = "select * from hpOutDataTabSetting where eid = "+eid+" order by tabid";
	rs.executeSql(selType);
	if(rs.next()) {
		//取已存在的第一个tab页的值
		tabid = rs.getString("tabid");
		type = rs.getString("type");
	}
}
if("1".equals(type)) {
	ArrayList<String> sourceidList = new ArrayList<String>();
	String selField = "select sourceid from hpOutDataSettingAddr where eid = "+eid+" and tabid = "+tabid;
	rs2.executeSql(selField);
	while(rs2.next()) {
		sourceidList.add(rs2.getString("sourceid"));
		
	}
	
	for(int i = 0; i < sourceidList.size(); i++) {
		rs2.executeSql("SELECT * FROM datashowparam where mainid="+sourceidList.get(i)+" order by id");
		int tempCount = rs2.getCounts();
		if(clos < tempCount) {
			clos = tempCount;
		}
	}
} else {
	String selField = "select * from hpOutDataSettingField where eid = "+eid+" and tabid = "+tabid;
	rs2.executeSql(selField);
	if(0 != rs2.getCounts()) {
		clos = rs2.getCounts();	
	}
	
}

String tableString=""+
					   "<table  datasource=\"weaver.page.element.compatible.PageMore.getOutDataMore\" sourceparams=\"eid:"+eid+"+tabid:"+tabid+"\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" tabletype=\"none\">"+
					   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   "<head>";
int width = clos == 0 ? 100:(int)(100/clos);
for(int i = 0; i < clos; i++) {	
	tableString = tableString + "<col width=\""+width+"%\"  text=\""+SystemEnv.getHtmlLabelName(6002,user.getLanguage())+""+(i+1)+"\" column=\"col"+(i+1)+"\"/>";
}						 
tableString = tableString +"</head>"+"</table>";

%>
    </DIV>
    <form>
    	<TABLE width="100%">
		    <tr>
		        <td valign="top">  
		        <input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
		           	<wea:SplitPageTag  tableString='<%=tableString%>' mode="run" />
		        </td>
		    </tr>
		</TABLE>
    </form>
</div>

</BODY>
</HTML>
<!--QC286164  [80][90]外部数据元素-more页面右键菜单问题 start-->
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<!--QC286164  [80][90]外部数据元素-more页面右键菜单问题 end-->
<script type="text/javascript">
    jQuery(document).ready(function () {
        $("#objName").text('<%=title%>');//QC294399 [80][90]外部数据元素-tab页点击more后显示页面建议加上tab页名称
    });
</SCRIPT>
