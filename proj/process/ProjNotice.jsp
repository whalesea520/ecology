<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}
if("<%=isclose%>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	parentWin.closeDialog();	
}
</script>
<%
if("1".equals(isclose)){
	return;
}


    String ProjID = request.getParameter("ProjID");
    
    RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
    RecordSet.next();

    String members =Util.null2String( RecordSet.getString("members"));
    while(members.startsWith(",")){
    	members=members.substring(1,members.length());
    }
    while(members.endsWith(",")){
    	members=members.substring(0,members.length()-1);
    }
    String Memname=ProjectTransUtil.getResourceNames(members);
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-2),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver NAME=weaver  action="/proj/plan/PlanOperation.jsp" method=post>

<input type=hidden name="ProjID" value="<%=ProjID%>">
<input type=hidden name="method" value="tellmember">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important;display:none;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" class="e8_btn_top"  onclick="submitData()"/>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15280,user.getLanguage())%></wea:item>
		<wea:item>
		<%--
			<input class="wuiBrowser" type=hidden name="hrmids02" value="<%=members%>" _param="resourceids"
        	_displayText="<%=Memname %>"
        	_url="/systeminfo/BrowserMain.jsp?url=/proj/process/MutiResourceBrowser_proj.jsp?ProjID=<%=ProjID %>">
         --%>
         	<%
         	String browserurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?from=projnotice%26ProjID="+ProjID+"%26selectedids="+members+"%26sqlwhere=hr.id in("+members+") ";
         	String completeUrl="/data.jsp?type=17&from=projnotice&ProjID="+ProjID+"&sqlwhere=t1.id in("+members+") ";
         	%>
        	<brow:browser viewType="0" name="hrmids02" 
				browserValue='<%=members %>' 
				browserSpanValue='<%=Memname %>'
				browserUrl='<%=browserurl %>'
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl='<%=completeUrl %>'  />
        	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15281,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=inputstyle maxLength=100 size=40 name="noticetitle" onchange='checkinput("noticetitle","spannoticetitle")'> <SPAN id=spannoticetitle><IMG src="/images/BacoError_wev8.gif"align=absMiddle></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15282,user.getLanguage())%></wea:item>
		<wea:item>
			<TEXTAREA class=inputstyle name="noticecontent" ROWS=8 STYLE="width:70%" onchange='checkinput("noticecontent","spannoticecontent")' ></TEXTAREA><SPAN id=spannoticecontent><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
	</wea:group>
</wea:layout>

</form>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>
</BODY>
</HTML>


<script language=javascript>
function doSave(){
	if(check_form(document.weaver,'hrmids02,noticetitle,noticecontent')){	    
		document.weaver.submit();
        window.parent.close();
	}
}

</SCRIPT>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'hrmids02,noticetitle,noticecontent'))
		weaver.submit();
}
</script>
