<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %> 
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowSearchCustom" class="weaver.workflow.search.WorkflowSearchCustom" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="dateutil" class="weaver.general.DateUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
 

		<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
		<%
		String ownerdepartmentid="";
		String formid="";
		String bname="";
		String helpdocid="";
		String hrmcreaterid="";
		%>
		


	    
	    
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
String ajax=Util.null2String(request.getParameter("ajax"));
int wfid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
%>
 
<body>
 
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
 
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

  
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmCoder" name="frmCoder" method=post action="WFTitleCode.jsp" >

		<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20756 ,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(27208,user.getLanguage())%></wea:item>
				<wea:item>
					<select style="width: 150px"  id="nPrintOrient" name="nPrintOrient">
						<option value="1" selected><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%></option>
						<option value="2"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%></option>
					</select>
				</wea:item>
			</wea:group>
			</wea:layout>
</div>
</div>
</div>
</div>
</form>
</body>
 <script language="javascript"> 
  function onSave(){
	window.parent.returnValue = document.getElementById("nPrintOrient").value;
	window.parent.close();
}
function onClose(){
	window.parent.close();
}

 
jQuery(document).ready(function($) {
	 

	jQuery('.e8_box demo2').height(650);
});
      
    </script>
</html>
