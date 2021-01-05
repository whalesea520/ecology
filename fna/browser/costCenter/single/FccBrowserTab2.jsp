<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>   
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<% 
String from = Util.null2String(request.getParameter("from"));
int uid=user.getUID();

String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String sqltag=Util.null2String(request.getParameter("sqltag"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String fieldid = Util.null2String(request.getParameter("fieldid"));


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
		try{
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("515",user.getLanguage())%>");
		}catch(e){
			if(window.console)console.log(e+"-->SingleSearch.jsp");
		}
		var dialog = null;
		try{
			dialog = parent.parent.parent.getDialog(parent.parent);
		}catch(ex1){}
</script>

</HEAD>

<BODY>
	<FORM id=SearchForm name=SearchForm STYLE="margin-bottom:0" action="/fna/browser/costCenter/single/FccBrowserList.jsp" method=post target="frame2">
	<input class=inputstyle type=hidden name=sqltag value=<%=sqltag%>>
	<input class=inputstyle type=hidden name=from value=<%=from%>>
	<input class=inputstyle type=hidden name=workflowid value=<%=workflowid%>>
	<input class=inputstyle type=hidden name=fieldid value=<%=fieldid%>>
	<input type="hidden" name="isinit" value="1"/>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	BaseBean baseBean_self = new BaseBean();
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<button type="button" class=btnSearch accessKey=S style="display:none" id=btnsub onclick="btnsub_onclick();"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<BUTTON class=btnReset accessKey=T style="display:none" id=reset type="button" onclick="reset_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<button type="button" class=btnok accessKey=1 style="display:none" onclick="btncancel_onclick();" id=btnok ><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<button type="button" class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
		
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="document.SearchForm.btnsub.click()" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item><!-- 成本中心 -->
		<wea:item><input class=inputstyle name=fccname id=fccname ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></wea:item><!-- 编码 -->
		<wea:item><input class=inputstyle name=fcccode id=fcccode ></wea:item>
	</wea:group>
</wea:layout>
<input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
<input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
<input class=inputstyle type="hidden" name="tabid" >
<input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function reset_onclick(){
	document.SearchForm.fccname.value=""
	document.SearchForm.fcccode.value=""
}
function btnsub_onclick(){
    $("input[name=tabid]").val(2);
    document.SearchForm.submit();
}
function btnclear_onclick(){
   var returnjson = {id:"",name:""};
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){}
		try{
			dialog.close(returnjson);
		}catch(e){}
	}else{
		window.parent.returnValue = returnjson;
		window.parent.close();
	}
}
function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close();
	}
}
</script>
</BODY>
</HTML>
