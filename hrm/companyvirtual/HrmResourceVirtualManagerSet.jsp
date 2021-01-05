<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
String sql = " SELECT lastname, sex, a.subcompanyid, jobtitle, a.departmentid, a.managerid,a.virtualtype "
					 + " FROM HrmResourceVirtual a, HrmResource b "
					 + " WHERE a.resourceid = b.id AND a.id = "+id;
rs.executeSql(sql);
String lastname="",sex="",sexname="",subcompanyid="",subcompanyname="";
String jobtitle="",jobtitlename="", departmentid="",departmentname="", managerid="",virtualtype="";
if(rs.next()){
	lastname=rs.getString("lastname");
	sex=Util.null2String(rs.getString("sex"));
	virtualtype = Util.null2String(rs.getString("virtualtype"));
	if(sex.equals("0")) {
		sexname =SystemEnv.getHtmlLabelName(28473,user.getLanguage());
	}else if(sex.equals("1")) {
		sexname =SystemEnv.getHtmlLabelName(28474,user.getLanguage());
	}
	subcompanyid=Util.null2String(rs.getString("subcompanyid"));
	if(subcompanyid.length()>0&&!subcompanyid.equals("0")){
		subcompanyname = SubCompanyVirtualComInfo.getSubCompanyname(subcompanyid);
	}
	departmentid=Util.null2String(rs.getString("departmentid"));
	if(departmentid.length()>0&&!departmentid.equals("0")){
		departmentname = DepartmentVirtualComInfo.getDepartmentname(departmentid);
	}
	jobtitle=Util.null2String(rs.getString("jobtitle"));
	if(jobtitle.length()>0&&!jobtitle.equals("0")){
		jobtitlename = JobTitlesComInfo.getJobTitlesname(jobtitle);
	}
	managerid=Util.null2String(rs.getString("managerid"));
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
      <!-- 
      <wea:item><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></wea:item>
      <wea:item><%=sexname%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
      <wea:item><%=subcompanyname%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
      <wea:item><%=departmentname%></wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
      <wea:item><%=jobtitlename%></wea:item>
       -->
<FORM id=weaver name=frmMain action="ResourceOperation.jsp" method=post >
   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=id%>">
   <input type=hidden name=lastname value="<%=lastname%>">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
      <wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
      <wea:item><%=lastname%></wea:item>

      <wea:item><%=SystemEnv.getHtmlLabelName(34079,user.getLanguage())%></wea:item>
      <wea:item>
      	<%
        String browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?show_virtual_org=-1&virtualtype="+virtualtype+"&selectedids=";
        String completeUrl="/data.jsp?virtualtype="+virtualtype;
      	%>
	  	  <brow:browser viewType="0"  name="managerid" browserValue='<%=managerid %>' 
	      browserUrl='<%=browserUrl %>'
	      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
	      completeUrl='<%=completeUrl %>' width="200px"
	      browserSpanValue='<%=ResourceComInfo.getLastname(managerid)%>'>
	      </brow:browser>
      </wea:item>
		</wea:group>
	</wea:layout>
 </FORM>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
		</wea:item>
		</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %> 

<script language=javascript>
function onSave(){
	
  if(jQuery("input[name=managerid]").val()==""){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16072,user.getLanguage())%>",function(){
		document.frmMain.operation.value="setVirtualManager";
		document.frmMain.submit();
		})
	}else{
		document.frmMain.operation.value="setVirtualManager";
		document.frmMain.submit();
	}
}
</script>
</BODY></HTML>
