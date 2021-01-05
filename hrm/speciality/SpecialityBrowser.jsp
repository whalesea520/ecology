<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
	<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("803",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->SpecialityBrowser.jsp");
		}
		var parentWin = null;
		var dialog = null;
		try{
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
		}
		catch(e){}
	</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(803,user.getLanguage());
String needfav ="1";
String needhelp ="";
if(user == null){
	user = new User();
	user.setLanguage(7);
}
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,7);
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,7);
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where description like '%";
		sqlwhere += Util.fromScreen2(description,7);
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and description like '%";
		sqlwhere += Util.fromScreen2(description,7);
		sqlwhere += "%'";
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
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SpecialityBrowser.jsp" method=post>
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onblur="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=name value='<%=name%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name=description value='<%=description%>'></wea:item>
	</wea:group>
</wea:layout>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=70%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
<TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmSpeciality "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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
	<TD style="display:none"><%=RecordSet.getString(1)%></TD>
	<TD><%=RecordSet.getString("name")%></TD>
	<TD><%=RecordSet.getString("description")%></TD>
	
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
    	returnValue(dialog,window.parent.parent,$(this).find("td:first").text(),$(this).find("td:first").next().text().replace(/,/g, "，"),1);
		})
})


function submitClear()
{
   	returnValue(dialog,window.parent.parent,"","",1);
}


function returnValue(dialog,opWin,ids,names,type){
	try {
		if (dialog) {
			
			if(type==1){
				try {
					dialog.callback({
						id : ids,
						name : names
					});
				} catch (e) {
				}
				try {
					dialog.close({
						id : ids,
						name : names
					});
				} catch (e) {
				}
			}else{
				try {
					dialog.close();
				} catch (e) {
				}
			}
			
		} else {
			doSetValue(opWin,ids,names,type);
		}
	} catch (e) {
		doSetValue(opWin,ids,names,type);
	}
}
function doSetValue(opWin,ids,names,type){
	try {
		var dialogflag = (typeof (systemshowModalDialog) == 'undefined' && !!!window.showModalDialog);
		dialogflag = (dialogflag || systemshowModalDialog);
		
		if(type==1){
			if (dialogflag) {
				try {
					opWin.opener.dialogReturnValue = {
						id : ids,
						name : names
					};
				} catch (_96e) {
				}
			}
			opWin.returnValue = {
				id : ids,
				name : names
			};
		}
		if (dialogflag) {
			try {
				opWin.opener.closeHandle();
			} catch (_96e) {
			}
		}
		opWin.close();
	} catch (e) {
		if (type == 1) {
			opWin.returnValue = {
				id : ids,
				name : names
			};
		}
		opWin.close();
	}
}
  
</script>
</BODY></HTML>
