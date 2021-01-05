<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page import="weaver.general.Util,java.text.SimpleDateFormat" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@ page import="weaver.workflow.workflow.WorkflowVersion" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="Browsedatadefinition" class="weaver.workflow.request.Browsedatadefinition" scope="page"/>

<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<style type="text/css">
		.LayoutTable .fieldName {
			padding-left:20px!important;
		}
	</style>
</HEAD>
<%
SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
String currentdate = df.format(new Date());

String sqlwhere = " where 1=1 ";

int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"));

int _bdf_wfid = Util.getIntValue(request.getParameter("bdf_wfid"));
int _bdf_fieldid = Util.getIntValue(request.getParameter("bdf_fieldid"));
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String userID = String.valueOf(user.getUID());
int userid=user.getUID();
if(!f_weaver_belongto_userid.equals(userID) && !"".equals(f_weaver_belongto_userid)){
userID = f_weaver_belongto_userid;
userid = Util.getIntValue(f_weaver_belongto_userid,0);
}
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
					if(RecordSet.next()){
						belongtoshow = RecordSet.getString("belongtoshow");
					}
String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
String usertype = "0";
if ("2".equals(user.getLogintype())) usertype = "1";

BaseBean baseBean = new BaseBean();
String dSetName = Util.null2String(request.getParameter("dSetName"));

%>
<BODY style='overflow-x:hidden'>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84712,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_top"  onclick="dosubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:dosubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onResetwf(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/fna/browser/dataSet/dataSetBrowser.jsp" method=post>

<wea:layout type="4col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(20331, user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
		<wea:item>
        	<input class="inputstyle" id="dSetName" name="dSetName" value="<%=dSetName%>" />
		</wea:item>
	</wea:group>
<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item attributes="{'colspan':'full','isTableList':'true'}">
		<% 
			if(fnaVoucherXmlId > 0){
				sqlwhere += " and (fnaVoucherXmlId is null or fnaVoucherXmlId = "+fnaVoucherXmlId+") ";
			}
			if (!"".equals(dSetName)) {
				sqlwhere += " and dSetName like '%"+StringEscapeUtils.escapeSql(dSetName)+"%'";
			}
			String backfields = " * ";
			String formsql = " from fnaDataSet ";
			String orderby  = "dSetName";
			String colString=
			 "<col width=\"0%\" hide=\"true\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" text=\"\" column=\"id\" />"+
			 "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(195, user.getLanguage())+"\" column=\"dSetName\" "+
	 	     			" transmethod=\"weaver.general.Util.toScreenForWorkflow\" />"+
			 "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(433, user.getLanguage())+"\" column=\"dsMemo\" "+
   						" transmethod=\"weaver.general.Util.toScreenForWorkflow\" />";
			String tableString =
			" <table pageId=\""+PageIdConst.FNA_DATA_SET_BROWSER_LIST+"\" instanceid=\"FNA_DATA_SET_BROWSER_LIST\" tabletype=\"none\" "+
			" pagesize=\""+PageIdConst.getPageSize(PageIdConst.FNA_DATA_SET_BROWSER_LIST,user.getUID())+"\" >"+
			" <checkboxpopedom  id=\"checkbox\" />"+
            " <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(formsql)+"\" "+
			" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\" "+
            " sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
            " <head>"+colString+"</head>"+
            " </table>";
		%>
		<wea:SplitPageTag  tableString="<%=tableString%>" isShowTopInfo="false"  mode="run"/>
	</wea:item>
</wea:group>
</wea:layout>
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.FNA_DATA_SET_BROWSER_LIST %>"/>
<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>"
					 accessKey="2" id="btnclear" class="zd_btn_submit" onclick="submitClear()" />
				<input type="button"  value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					 accessKey="T" id="btncancel" class="zd_btn_cancle" onclick="dialog.close();" />
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

function onResetwf(){
	document.SearchForm.reset();
}

function afterDoWhenLoaded(){
	jQuery(".ListStyle").children("tbody").find("tr[class!='Spacing']").bind("click",function(){
	    var _name = $(this).find("td:eq(2)").html().trim();
	    if(_name.indexOf("<font>")!=-1){
	    	_name = _name.substring(0,_name.indexOf("<font>"));
	    }
	    var _id = $(this).find("td:eq(1)").text().trim();
		var returnjson = {"id":_id,"name":_name};
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
	});
};

function submitClear(){
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

function dosubmit(){
	jQuery('select:disabled').attr('disabled', false);
	document.SearchForm.submit();
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>