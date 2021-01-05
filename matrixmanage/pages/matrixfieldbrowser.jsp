
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
  var dialog = null;
  try{
  	dialog = parent.parent.getDialog(parent);
  }catch(e){}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name = Util.null2String(request.getParameter("name"));
String descr = Util.null2String(request.getParameter("descr"));
String sqlwhere = " where 1=1 ";
String fieldtype=Util.null2String(request.getParameter("fieldtype"));
String matrixid=Util.null2String(request.getParameter("matrixid"));
//默认取值字段
if("".equals(fieldtype)){
	fieldtype="1";
}

int ishead = 0;
if(!name.equals("")){
		sqlwhere += " and fieldname like '%" + name +"%' ";
}
if(!descr.equals("")){
		sqlwhere += " and displayname like '%" + descr +"%' ";
}
if(!"".equals(matrixid)){
	sqlwhere+="  and  matrixid='"+matrixid+"'";	
}

sqlwhere+="  and  fieldtype='"+fieldtype+"'";

String sqlstr = "select id,fieldname as name,displayname as descr "+
			    "from MatrixFieldInfo " + sqlwhere ;
%>
<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="matrixfieldbrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
<input class=inputstyle type=hidden name=matrixid value="<%=matrixid%>">
<input class=inputstyle type=hidden name=fieldtype value="<%=fieldtype%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:form_rest(),_self} " ;
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
	    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name="descr" id="descr" value='<%=descr%>'></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%></wea:item>
		<wea:item><input class=inputstyle name="name" id="name" value='<%=name%>'></wea:item>
		
	</wea:group>
</wea:layout>
</FORM>

<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:30px" width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%></TH>
<TH width=70%><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
<%
int i=0;
RecordSet.execute(sqlstr);
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
	<TD  style="padding-left: 13px"><%=RecordSet.getString("descr")%></TD>
	<TD style="padding-left: 13px"><%=RecordSet.getString("name")%></TD>
	
	
</TR>
<%}%>
</TABLE>
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

function form_rest(){
    $("#descr").val("");
    $("#name").val("");
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
