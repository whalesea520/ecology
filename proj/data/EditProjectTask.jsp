<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docs.CustomFieldManager"%>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>

<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page"/>
<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
isDialog="1";

if("1".equals( isclose)){
	%>
<script type="text/javascript">
var parentWin;
try{
	parentWin = parent.parent.getParentWindow(parent.window);
	parentWin.closeDialog();
	//parentWin._table.reLoad();
	parentWin.reloadPage();
}catch(e){}
</script>	
	
	
	
	<%
	return;
}


%>
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String from = Util.null2String(request.getParameter("from"));

/*合同*/
String contractids_prj="";
String sql_conids="select id from CRM_Contract where projid ="+ProjID;
RecordSet.executeSql(sql_conids);
while(RecordSet.next()){
    contractids_prj += ","+ RecordSet.getString("id");
}
if(!contractids_prj.equals("")) contractids_prj =contractids_prj.substring(1);

String connames="";
if(!contractids_prj.equals("")){
    ArrayList conids_muti = Util.TokenizerString(contractids_prj,",");
    int connum = conids_muti.size();
    for(int i=0;i<connum;i++){
        connames= connames+"<a href=/CRM/data/ContractView.jsp?id="+conids_muti.get(i)+">"+Util.toScreen(ContractComInfo.getContractname(""+conids_muti.get(i)),user.getLanguage())+"</a>" +" ";               
    }
} 



/*项目状态*/
String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
RecordSet.executeSql(sql_tatus);
RecordSet.next();
String isactived=RecordSet.getString("isactived");
//isactived=0,为计划
//isactived=1,为提交计划
//isactived=2,为批准计划

String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
RecordSet.executeSql(sql_prjstatus);
RecordSet.next();
String status_prj=RecordSet.getString("status");
if(isactived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
	response.sendRedirect("ViewProject.jsp?ProjID="+ProjID);
}
//status_prj=5&&isactived=2,立项批准
//status_prj=1,正常
//status_prj=2,延期
//status_prj=3,终止
//status_prj=4,冻结

/*查看项目成员*/
String sql_mem="select members from Prj_ProjectInfo where id= "+ProjID ;
RecordSet.executeSql(sql_mem);
RecordSet.next();
String Members=RecordSet.getString("members");
String Memname="";
String MembersName="";
ArrayList Members_proj = Util.TokenizerString(Members,",");
int Membernum = Members_proj.size();

for(int i=0;i<Membernum;i++){
    Memname= Memname+"<a href=\"/hrm/resource/HrmResource.jsp?id="+Members_proj.get(i)+"\">"+Util.toScreen(ResourceComInfo.getResourcename(""+Members_proj.get(i)),user.getLanguage())+"</a>";
    Memname+=" ";
    MembersName+=ResourceComInfo.getResourcename(""+Members_proj.get(i))+",";
}
   if(!MembersName.equals(""))   MembersName=MembersName.substring(0,MembersName.length()-1);

   
String needinputitems = "";
boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","p1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

RecordSet.executeProc("PRJ_Find_LastModifier",ProjID);
RecordSet.first();
String Modifier = Util.toScreen(RecordSet.getString(1),user.getLanguage());
String ModifyDate = RecordSet.getString(2);

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData");
RecordSet.first();
String newStrXml = RecordSet.getString("relationXml");
/*权限－begin*/
String Creater = Util.toScreen(RecordSet.getString("creater"),user.getLanguage());
String CreateDate = RecordSet.getString("createdate");
String manager = RecordSet.getString("manager");
String department = RecordSet.getString("department");
String useridcheck=""+user.getUID();

String passnoworktime = RecordSet.getString("passnoworktime");
boolean canview=false;
boolean canedit=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
//4E8 项目权限等级(默认共享的值设置:项目成员0.5,项目经理2.5,项目经理上级3,项目管理员4;手动共享值设置:查看1,编辑2)
double ptype=Util.getDoubleValue( CommonShareManager.getPrjPermissionType(""+ProjID, user),0 );
if(ptype==2.5||ptype==2){
	canview=true;
	canedit=true;
	ismanager=true;
}else if (ptype==3){
	canview=true;
	canedit=true;
	ismanagers=true;
}else if (ptype==4){
	canview=true;
	canedit=true;
	isrole=true;
}else if (ptype==0.5){
	canview=true;
	ismember=true;
}else if (ptype==1){
	canview=true;
}
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/


String isManagerFromView = Util.null2String(request.getParameter("isManager"));
String bbStyle="" ; // Browser button style.
String inputDisabled=""; //input disabled
if ("false".equals(isManagerFromView)){
    bbStyle="style='display:none'";
    inputDisabled = "readonly";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript"  type='text/javascript' src="/js/weaver_wev8.js"></SCRIPT>
<style type="text/css">
	td{
		background: none;
	}
	#divTaskList .ListStyle table td{
		padding:0 !important;
		background:none !important;
	}
	 body {-moz-user-select: -moz-none;}  
</style>

<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
</script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(610,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+" - "+Util.toScreen(RecordSet.getString("name"),user.getLanguage());
titlename += " <B>" + SystemEnv.getHtmlLabelName(401,user.getLanguage()) + ":</B>"+CreateDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1")) 
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Creater + ">" + Util.toScreen(ResourceComInfo.getResourcename(Creater),user.getLanguage()) + "</a>";
titlename += " <B>" + SystemEnv.getHtmlLabelName(103,user.getLanguage()) + ":</B>"+ModifyDate ;
titlename += " <B>" + SystemEnv.getHtmlLabelName(623,user.getLanguage()) + ":</B>";
if(user.getLogintype().equals("1")) 
	titlename += " <A href=/hrm/resource/HrmResource.jsp?id=" + Modifier + ">" + Util.toScreen(ResourceComInfo.getResourcename(Modifier),user.getLanguage()) + "</a>";

String needfav ="1";
String needhelp ="";
%>
<BODY id="myBody" onbeforeunload="protectProj(event)" style="overflow-y:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

if(canedit){
	/**
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
    **/
}

    

    //RCMenu += "{"+SystemEnv.getHtmlLabelName(20521,user.getLanguage())+", /weaver/weaver.file.ExcelOut, ExcelOut} " ;
    //RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver action="/proj/data/ProjectOperation.jsp" method=post enctype="multipart/form-data">
<input <%=inputDisabled%> type="hidden" name="method" value="editTask">
<input <%=inputDisabled%> type="hidden" name="ProjID" value="<%=ProjID%>">
<input type ="hidden" name="isManagerFromView" value="<%=isManagerFromView%>">


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canedit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%> " class="e8_btn_top" onclick="frames['taskDataIframe'].addRow();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%> " class="e8_btn_top" onclick="frames['taskDataIframe'].delRows();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%> " class="e8_btn_top" onclick="submitData(this)"/>
			<%
		}
		%>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" style="display:none;" id="advancedSearchDiv"></div>
<div id="agendaDiv" style="display:;margin-left:0px!important;margin-top:0px!important;">
<iframe id="taskDataIframe" name="taskDataIframe" src="/proj/data/EditProjectTaskData.jsp?manager=<%=manager %>&passnoworktime=<%=passnoworktime %>&ProjID=<%=""+ProjID  %>" class="flowFrame" frameborder="0" scrolling="auto" height="500px" width="100%"></iframe>
  
  <TEXTAREA NAME="areaLinkXml" id="areaLinkXml" ROWS="6" COLS="100" style="display:none"></TEXTAREA> 
   <div id="divTaskList" style="display:none;"></div>
</div>

<input  type=hidden name="hrmids02" id ="hrmids02" value="<%=Members%>">
<span   name="hrmids03span" id ="hrmids03span" style="display:none"><%=MembersName%></span>
</FORM>

<script type="text/javascript">
//选择负责人
function onSelectManager(spanname,inputename){
	tmpids = $("input[name=hrmids02]").val();
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectManagerBrowser.jsp?Members="+tmpids);
	if (datas){
		if(datas.id!=""){
			$(spanname).html("<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>");
			$(inputename).val(datas.id);
		}else {
			$(spanname).html( "");
			$(inputename).val("");
		}
	}
}
</script>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">

				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
</BODY>
</HTML>
<script language="javaScript">  
var ptu = null;
var iRowIndex = null;
var RowindexNum = null;


  
function submitData(obj){
     //把所有控件的display属性设为false
     obj.disabled = true;
	/**var xmlDoc=document.createElement("rootTask");
		var docDom=generaDomJson();
		$.toXml(docDom,xmlDoc);
	   document.getElementById("areaLinkXml").value= "<rootTask>"+ $(xmlDoc).html().replace(/\"\s/g,"\"").replace(/\s\"/g,"\"")+"</rootTask>";
	**/
	var levelflag = $("#taskDataIframe")[0].contentWindow.reloadTaskTree();
	if("overlevel"==levelflag){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125271, user.getLanguage()) %>");
		obj.disabled = false;
	}else{
		var taskinfo= $("#taskDataIframe").contents().find("#divTaskList").html();
	  	$("#divTaskList").html(taskinfo);
	  	//console.log(taskinfo);
	  	
	    myBody.onbeforeunload=null;
	  	weaver.submit();
	}
}
       

</script>
<script type="text/javascript">
$(function(){
	try{
		parent.setTabObjName('<%=ProjectInfoComInfo.getProjectInfoname(ProjID) %>');
	}catch(e){
		if(window.console){
			console.log(e);
		}
	}
});
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>



