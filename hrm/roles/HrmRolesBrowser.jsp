<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-01 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String rolesname = Util.null2String(request.getParameter("rolesname"));
	String rolesmark = Util.null2String(request.getParameter("rolesmark"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	int ishead = 0;
	if(!sqlwhere.equals("")) ishead = 1;
	if(!rolesname.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
		}
		else 
			sqlwhere += " and rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
	}
	if(!rolesmark.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
		}
		else
			sqlwhere += " and rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
	}
	String sqlstr = "select * from HrmRoles " + sqlwhere+" order by rolesmark" ;
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript">
			try{
				parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33401",user.getLanguage())%>");
			}catch(e){
				if(window.console)console.log(e+"-->HrmRolesBrowser.jsp");
			}
		  var parentWin = null;
		  var dialog = null;
		  try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		  }catch(e){}
		</script>
	</HEAD>
	<BODY>
<div class="zDialog_div_content" style="width:100%;height:100%">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="HrmRolesBrowser.jsp" method="post">
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
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
				<input type=button class="e8_btn_top" onclick="javascript:document.SearchForm.submit();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></wea:item>
			<wea:item> 
			  <input class=inputstyle name=rolesmark value="<%=rolesmark%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
			<wea:item> 
			  <input class=inputstyle name=rolesname value="<%=rolesname%>">
			</wea:item>
		</wea:group>
	</wea:layout>
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>

</FORM>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TH>      
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TH>      
	  <TH width=65%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String rolesmarks = Util.toScreen(RecordSet.getString("rolesmark"),user.getLanguage());
	String rolesnames = Util.toScreen(RecordSet.getString("rolesname"),user.getLanguage());
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
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD style="padding:0px 5px 0px 12px"><%=rolesmarks%></TD>
	<TD style="padding:0px 5px 0px 12px"><%=rolesnames%></TD>
</TR>
<%}
%>

</TABLE>
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
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:eq(1)").text()};
			if(dialog){
				dialog.callback(returnjson);
			}else{
				window.parent.returnValue = returnjson;
		  	window.parent.close();
			}
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{
		window.parent.returnValue = returnjson;
  	window.parent.close();
	}
}
  
	function btncancel_onclick(){
		if(dialog){
			dialog.closeByHand();
		}else{
	  	window.parent.close();
		}
	}
</script>
</BODY></HTML>
