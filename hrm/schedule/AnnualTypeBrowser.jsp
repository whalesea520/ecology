<%@ page import = "weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-18 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page" />
<jsp:useBean id = "WorkflowComInfo" class = "weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("1881",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
  var parentWin = null;
  var dialog = null;
  try{
  	parentWin = parent.parent.getParentWindow(parent);
  	dialog = parent.parent.getDialog(parent);
  }catch(e){}
</script>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1881,user.getLanguage());
String needfav ="1";
String needhelp ="";

String leavetypeid = "";
String otherleavetypeid = "";
String sql = "select * from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType') ";
rs.executeSql(sql);
while(rs.next()){
  if(rs.getString("fieldname").toLowerCase().equals("leavetype")) leavetypeid = rs.getString("id");
  if(rs.getString("fieldname").toLowerCase().equals("otherleavetype")) otherleavetypeid = rs.getString("id");
}
%>
<BODY>
<div class="zDialog_div_content" style="width:100%;height:100%">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmScheduleDiffBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel_Onclick();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="btnCancel_Onclick();"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width: 100%">
<TR class=DataHeader>
<TH width=100%><%=SystemEnv.getHtmlLabelName(16070,user.getLanguage())%></TH>
<%
int i=0;
sql = "select fieldid,selectvalue,selectname,id from workflow_SelectItem where fieldid in (select id from workflow_billfield where billid = 180 and (fieldname = 'leaveType' or fieldname = 'otherLeaveType')) ";
rs.execute(sql);
while(rs.next()){
    if(rs.getString("fieldid").equals(leavetypeid)&&rs.getString("selectvalue").equals("4")) continue;
    String returnvalue = "";
	
	if(rs.getString("fieldid").equals(leavetypeid)) returnvalue= "leavetype_"+rs.getString("selectvalue");
	if(rs.getString("fieldid").equals(otherleavetypeid)) returnvalue= "otherleavetype_"+rs.getString("selectvalue");
	
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD style="display:none"><A HREF=#><%=returnvalue%></A></TD>
	<TD style="padding-left:15px"><%=rs.getString("selectname")%></TD>       
</TR>
<%}%>
</TABLE>
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
		}else{ 
		  window.parent.returnValue  = returnjson;
		  window.parent.close();
		}
		})
})


function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}
  
</script>
</BODY></HTML>