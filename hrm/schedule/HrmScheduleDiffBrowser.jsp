<%@ page import = "weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page" />
<jsp:useBean id = "WorkflowComInfo" class = "weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String id = Util.null2String(request.getParameter("id"));
String diffname = Util.null2String(request.getParameter("diffname"));
String diffdesc = Util.null2String(request.getParameter("diffdesc"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String salaryitem = Util.null2String(request.getParameter("salaryitem"));
String difftype = Util.null2String(request.getParameter("difftype"));
String difftime = Util.null2String(request.getParameter("difftime"));
String salaryable = Util.null2String(request.getParameter("salaryable"));
String counttype = Util.null2String(request.getParameter("counttype"));
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames(difftype.equals("1")?"1881":"6159",user.getLanguage())%>");
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
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(difftype.equals("1")?1881:6159,user.getLanguage());
String needfav ="1";
String needhelp ="";

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!diffname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where diffname like '%";
		sqlwhere += Util.fromScreen2(diffname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and diffname like '%";
		sqlwhere += Util.fromScreen2(diffname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!diffdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where diffdesc like '%";
		sqlwhere += Util.fromScreen2(diffdesc,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and diffdesc like '%";
		sqlwhere += Util.fromScreen2(diffdesc,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!workflowid.equals("")&&!workflowid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflowid =";
		sqlwhere += Util.fromScreen2(workflowid,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and workflowid =";
		sqlwhere += Util.fromScreen2(workflowid,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!salaryitem.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where salaryitem =";
		sqlwhere += Util.fromScreen2(salaryitem,user.getLanguage());
		sqlwhere += " ";
	}
	else{
		sqlwhere += " and salaryitem =";
		sqlwhere += Util.fromScreen2(salaryitem,user.getLanguage());
		sqlwhere += " ";
	}
}
if(!difftype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where difftype ="+Util.fromScreen2(difftype,user.getLanguage());		
	}
	else{
		sqlwhere += " and difftype ="+Util.fromScreen2(difftype,user.getLanguage());		
	}
}
if(!difftime.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where difftime ="+Util.fromScreen2(difftime,user.getLanguage());		
	}
	else{
		sqlwhere += " and difftime ="+Util.fromScreen2(difftime,user.getLanguage());		
	}
}
if(!salaryable.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where salaryable ="+Util.fromScreen2(salaryable,user.getLanguage());		
	}
	else{
		sqlwhere += " and salaryable ="+Util.fromScreen2(salaryable,user.getLanguage());		
	}
}

if(!counttype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where counttype ="+Util.fromScreen2(counttype,user.getLanguage());		
	}
	else{
		sqlwhere += " and counttype ="+Util.fromScreen2(counttype,user.getLanguage());		
	}
}


%>
<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="HrmScheduleDiffBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input class=inputstyle type=hidden name=difftype value="<%=difftype%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btnCancel_Onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onblur="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=diffname value='<%=diffname%>'></wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=100%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<!--<TH width=20%>说明</TH>
<TH width=15%>工作流</TH>
<TH width=15%>相关工资项目</TH>-->
<!--<TH width=40%><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></TH>-->
<!--
<TH width=10%>相关时间</TH>
<TH width=5%>薪资计算</TH>
<TH width=10%>计算类型</TH>-->
<%
int i=0;
sqlwhere = "select * from HrmScheduleDiff "+sqlwhere;
rs.execute(sqlwhere);
while(rs.next()){
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
	<TD style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
	<TD><%=rs.getString("diffname")%></TD>
<!--	<TD><%=rs.getString("diffdesc")%></TD>	
	<TD><%=WorkflowComInfo.getWorkflowname(""+rs.getInt("workflowid"))%></TD>
	<td><%=Util.toScreen(SalaryComInfo.getSalaryname(rs.getString("salaryitem")),user.getLanguage())%></td>
-->	
<!--	<TD>
	  <%if(rs.getString("difftype").equals("1")){%><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%><%}%>	  <%if(rs.getString("difftype").equals("0")){%><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%><%}%>
	</TD>-->
<!--	
	<td>
	  <%if(rs.getString("difftime").equals("0")){%><%=SystemEnv.getHtmlLabelName(380,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%><%}%> 
          <%if(rs.getString("difftime").equals("1")){%><%=SystemEnv.getHtmlLabelName(458,user.getLanguage())%><%}%>
          <%if(rs.getString("difftime").equals("2")){%><%=SystemEnv.getHtmlLabelName(370,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371,user.getLanguage())%><%}%>	
        </td>
        <td>
          <% if(rs.getString("salaryable").equals("1")){%>
            <%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
          <% } else {%>
            <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%> <% } %>
        </td>
        <td>
          <% if(rs.getString("counttype").equals("0")){%><%=SystemEnv.getHtmlLabelName(452,user.getLanguage())%><%}%>
          <% if(rs.getString("counttype").equals("1")){%><%=SystemEnv.getHtmlLabelName(459,user.getLanguage())%><%}%>
        </td>
-->        
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
	//alert(jQuery("#BrowseTable").find("tr").length)
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
