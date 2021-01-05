
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<!-- modified by wcd 2014-06-17 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page"/>
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<%
	String sqlwhere ="";
	String name = Util.null2String(request.getParameter("name"));
	if (!name.equals("")){ 
		sqlwhere = " where b.jobtitlename like '%"+name+"%' ";
	}
	String sqlstr = "select a.* from HrmCareerInvite a left join HrmJobTitles b on a.careername = b.id " + sqlwhere ;
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(366,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			try{
				parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("366",user.getLanguage())%>");
			}catch(e){}
			var parentWin = null;
			var dialog = null;
			try{
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
			}catch(e){}
		</script>
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<FORM NAME=SearchForm STYLE="margin-bottom:0" action="InviteBrowser.jsp" method=post>
			<input class=inputstyle type=hidden name=sqlwhere value="">
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
				RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				%>
				<BUTTON class=btn accessKey=1 onclick="window.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
				<%
				RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				%>	
				<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
			<div class="zDialog_div_content">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td>
						</td>
						<td class="rightSearchSpan" style="text-align:right;">
							<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<wea:layout type="2col">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
						<wea:item><input class=inputstyle name=name value='<%=name%>'></wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</FORM>
		<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="width:100%;margin-top:0">
		  <COLGROUP>  
		  <COL width="10%">
		  <COL width="10%">
		  <COL width="10%">
		  <COL width="10%">
		  <COL width="10%">
		  <COL width="10%">
		  <COL width="10%">
		  <TR class=DataHeader>
			<TH  colspan=7><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></TH>
		  </TR>
		  <TR class=DataHeader>    
			<TH><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(1861,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%></TH>
			<TH><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH>
			</tr><TR class=Line><TH colspan="8" ></TH></TR>

		<%
		int i= 0;
		rs.executeSql(sqlstr);
		while(rs.next()) {
			String id = rs.getString("id") ;
			String careername = Util.toScreen(rs.getString("careername"),user.getLanguage()) ;
			String careerpeople = Util.null2String(rs.getString("careerpeople")) ;
			String careersex = Util.null2String(rs.getString("careersex")) ; 
			String careeredu = Util.null2String(rs.getString("careeredu")) ;
			String createrid = Util.null2String(rs.getString("createrid")) ;
			String createdate = Util.null2String(rs.getString("createdate"));
			String planid = Util.null2String(rs.getString("careerplanid")) ;
			String careersexstr="";
			if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
			else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
			else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(763,user.getLanguage());
			String careeredustr=EducationLevelComInfo.getEducationLevelname(careeredu);
			String thecareername = Util.getIntValue(careername) == -1 ? careername : JobTitlesComInfo.getJobTitlesname(careername);

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
		   <TD style="display:none"><a href='#'><%=id%></a></TD>
			<TD><%=thecareername%> </TD>
			<TD style="display:none"><%=careername%></TD>
			<TD><%=careerpeople%></TD>
			<TD><%=careersexstr%></TD>
			<TD><%=careeredustr%></TD>
			<TD><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></TD>
			<TD><%=createdate%></TD>
			<TD><%=CareerPlanComInfo.getCareerPlantopic(planid)%></TD>
			</TR>
		<%}%>
		</TABLE>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
					var returnjson = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
					if(dialog){
						dialog.callback(returnjson);
					}else{ 
					  window.parent.returnValue  = returnjson;
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
				  window.parent.returnValue  = returnjson;
				  window.parent.close();
				}
			}
		</script>
	</BODY>
</HTML>
