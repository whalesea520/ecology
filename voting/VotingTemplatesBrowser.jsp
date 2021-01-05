<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-01 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
	String subject = Util.null2String(request.getParameter("subject"));

	String sqlwhere = " istemplate = '1'  and createrid="+ user.getUID();
	if(!subject.equals("")){
			sqlwhere += " and subject like '%" + subject +"%' ";
	}

	String sqlstr = "select * from voting where " + sqlwhere+" order by id desc" ;
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(15109,user.getLanguage())+SystemEnv.getHtmlLabelName(33144,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	</HEAD>
	<BODY>
<div class="zDialog_div_content" style="width:100%;height:100%">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="VotingTemplatesBrowser.jsp" method="post">
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

<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item> 
			  <input class=inputstyle name="subject" value="<%=subject%>">
			</wea:item>
		</wea:group>
	</wea:layout>

</FORM>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%></TH>      
	  <TH width=60%><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%></TH>      
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
      </tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String bsubject = Util.toScreen(RecordSet.getString("subject"),user.getLanguage());
	String bdescr = Util.toScreen(RecordSet.getString("descr"),user.getLanguage());
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
	<TD><%=bsubject%></TD>
	<TD><%=bdescr%></TD>
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
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.close();">
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
var click_flag = "1";
jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:eq(1)").text()};
			if(returnjson.id){
				if(click_flag == "1"){ //防止重复提交
					click_flag = "0"
					document.SearchForm.action = "VotingCopyOperation.jsp?ids="+returnjson.id+"&istempatea=0&type=importVoting";
			    	document.SearchForm.submit();
			    }
			}else{
				click_flag = "1";
			}
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})

  
function btncancel_onclick(){
	parentDialog.close();
}
</script>
</BODY></HTML>
