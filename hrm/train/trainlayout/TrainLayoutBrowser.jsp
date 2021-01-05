<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("6128",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->TrainLayoutBrowser.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}catch(e){}
 </script>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String layoutname = Util.null2String(request.getParameter("layoutname"));
String layoutaim = Util.null2String(request.getParameter("layoutaim"));
String layoutcontent = Util.null2String(request.getParameter("layoutcontent"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!layoutname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutname like '%";
		sqlwhere += Util.fromScreen2(layoutname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and layoutname like '%";
		sqlwhere += Util.fromScreen2(layoutname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!layoutaim.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutaim like '%";
		sqlwhere += Util.fromScreen2(layoutaim,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and layoutaim like '%";
		sqlwhere += Util.fromScreen2(layoutaim,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!layoutcontent.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where layoutcontent like '%";
		sqlwhere += Util.fromScreen2(layoutcontent,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and layoutcontent like '%";
		sqlwhere += Util.fromScreen2(layoutcontent,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="TrainLayoutBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
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
	<wea:group context="" attributes="{'groupDisplay':'none','isColspan':'false'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=layoutname value='<%=layoutname%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=layoutcontent value='<%=layoutcontent%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=layoutaim value='<%=layoutaim%>'></wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></TH>
</tr><TR class=Line style="height:1px;"><TH colspan="4" style="padding:0;"></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmTrainLayout "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
  String id = RecordSet.getString("id");
  if(!TrainLayoutComInfo.canAddPlan(id,user.getUID()))continue;
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
	<TD style="display:none"><%=id%></TD>
	<TD><%=RecordSet.getString("layoutname")%></TD>
	<TD><%=RecordSet.getString("layoutcontent")%></TD>
	<TD><%=RecordSet.getString("layoutaim")%></TD>	
</TR>
<%}%>
</TABLE></FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<SCRIPT LANGUAGE="JavaScript">
function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.close();
	}
}

function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		dialog.callback(returnjson);
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){	
		var returnjson = {id:jQuery(this).find("td:first").text(),name:jQuery(this).find("td:first").next().text()};
		if(dialog){
			dialog.callback(returnjson);
		}else{ 
		  window.parent.returnValue  = returnjson;
		  window.parent.close();
		}
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			jQuery(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			jQuery(this).removeClass("Selected")
		})

})
</SCRIPT>
