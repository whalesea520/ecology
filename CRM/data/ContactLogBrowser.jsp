<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
char flag=2;

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
if(!"".equals(sqlwhere)){
	CustomerID = sqlwhere.substring(sqlwhere.indexOf("CustomerID")+"CustomerID".length()+1);
}
if(CustomerID.equals("")){
	CustomerID="0";
}

if(!"".equals(sqlwhere)){
	sqlwhere = sqlwhere.replace("where"," and");
}

String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();

String crmId = CustomerID;

String sql = "" ;

if (RecordSet.getDBType().equals("oracle"))
	sql = " SELECT id, begindate, begintime, description, name " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
        + " WHERE a.id = b.workid" 
		+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmId + ",%'"
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
else if (RecordSet.getDBType().equals("db2"))
	sql = " SELECT id, begindate, begintime, description, name " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
        + " WHERE a.id = b.workid" 
		+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmId + ",%'"
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
else
	sql = "SELECT id, begindate , begintime, description, name " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid" 
		+ " AND (',' + a.crmid + ',') LIKE '%," + crmId + ",%'" 
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
sql += " ORDER BY begindate DESC, begintime DESC";
RecordSet.executeSql(sql);

%>
<BODY scroll="auto">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("82535",user.getLanguage()) %>'/>
</jsp:include>

<DIV  style="display:none">
<BUTTON class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>


<div class="zDialog_div_content">

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcProductBrowser.jsp" method=post>
  <input type="hidden" name="pagenum" value=''>
  <wea:layout type="table" attributes="{'cols':'3','layoutTableId':'BrowseTable'}" needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
		
		
		<%while(RecordSet.next()){ 
			 String attributes = "{'id':'"+RecordSet.getString("id")+"'}";
		%>
			<wea:item attributes='<%=attributes %>'><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></wea:item>
			<wea:item><%=Util.toScreen(RecordSet.getString("description"),user.getLanguage())%></wea:item>
			<wea:item><%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%></wea:item>
		<%} %>
		</wea:group>
	</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear()">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>


<script type="text/javascript">

var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
})


function BrowseTable_onclick(e){

  var e=e||event;
  var target=e.srcElement||e.target;
	
  if( target.nodeName =="TD"||target.nodeName =="A"  ){
      var returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).attr("id"),name:jQuery(jQuery(target).parents("tr")[0].cells[0]).text()};
		if(dialog){
			dialog.callback(returnValue);
		}else{
	       window.parent.returnValue  = returnValue;
	       window.parent.close();
		}
	}
}


function submitClear()
{
	var returnValue = {id:"",name:""};
	if(dialog){
		dialog.callback(returnValue);
	}else{
       window.parent.returnValue  = returnValue;
       window.parent.close();
	}
	
}

</script>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>        
</BODY></HTML>


