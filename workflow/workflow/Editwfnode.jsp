<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsName" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);

    //如果是自由流程，则直接跳转到自由流程设置界面
	String  freewfid="0";
	//获取自由流程id(系统中只有一个流程绑定该具体单据)
	String  freeWfSql="select  id  from workflow_base a  where  a.formid=285";
	RecordSet.executeSql(freeWfSql);
	if(RecordSet.next())
	{
	  freewfid=RecordSet.getString("id");
	}

   if(freewfid.equals(wfid+"")  &&  !freewfid.equals("0"))
	{
	   //跳转到自由节点设置界面

//	   request.getRequestDispatcher("/workflow/workflow/Editfreewfnode.jsp?ajax=1&wfid="+wfid).forward(request,response);
	
	}



	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	int isModifyLog = 0;
	RecordSet.executeSql("SELECT isModifyLog FROM workflow_base WHERE id=" + wfid);
	if (RecordSet.next()) {
		isModifyLog = Util.getIntValue(RecordSet.getString("isModifyLog"), 0);
	}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<%WFNodeOperatorManager.resetParameter();%>
<html>
<%

	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	String isFree = "0";
	
	int formid=0;
    boolean hassetting=false;
	
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	if (iscust == null || iscust.isEmpty()) {
		iscust = "0";
	}
	int typeid = 0;
	typeid = WFManager.getTypeid();
	isFree = WFManager.getIsFree();
	int rowsum=0;

    String sql2 = "select objid from workflow_addinoperate where workflowid = "+wfid+" and isnode=1 and ispreadd = '0'";
    String hasRolesIds = "";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("objid");
    }
    
    //zzl默认显示绿色钩子，表示有节点后操作

    sql2 = "select w_nodeid from int_BrowserbaseInfo where w_fid = "+wfid+" and ispreoperator=0 and w_enable=1";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("w_nodeid");
    }
    //zzl-end
    
    /*---xwj for td3130 20051122 begin---*/
    sql2 = "select objid from workflow_addinoperate where workflowid = "+wfid+" and isnode=1 and ispreadd = '1'";
    String hasPreRolesIds = "";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasPreRolesIds += ","+RecordSet.getString("objid");
    }
    
     //zzl默认显示绿色钩子，表示有节点后操作

    sql2 = "select w_nodeid from int_BrowserbaseInfo where w_fid = "+wfid+" and ispreoperator=1 and w_enable=1";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasPreRolesIds += ","+RecordSet.getString("w_nodeid");
    }
    //zzl-end
    
    /*---xwj for td3130 20051122 end---*/
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
    
    

    if(detachable==1){  
        //如果开启分权，管理员
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId2")),-1);
        if(user.getUID() == 1){
            operatelevel = 2;
        }else{
            String subCompanyIds = manageDetachComInfo.getDetachableSubcompanyIds(user);
            if (subCompanyId == 0 || subCompanyId == -1 ) {
                if (subCompanyIds != null && !"".equals(subCompanyIds)) {
                    String [] subCompanyIdArray = subCompanyIds.split(",");
                    for (int i=0; i<subCompanyIdArray.length; i++) {
                        subCompanyId = Util.getIntValue(subCompanyIdArray[i]);
                        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
                        if (operatelevel > 0) {
                            break;
                        }
                    }
                }
            } else {
                operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
            }            
        }

    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            operatelevel=2;
        }else{
            operatelevel=1;
        }
    }
    
    if(operatelevel < 1 && haspermission){
        operatelevel = 1;
    }
    int subCompanyId2 = WFManager.getSubCompanyId2();
	if(subCompanyId2 != -1 && subCompanyId2 != 0 && detachable == 1){
	    if(!haspermission){
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId2);    
	    }
	}
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<style type="text/css">
.onhaverstyle:hover{
color:#e43633!important;
}

</style>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",addwfnode.jsp?src=editwf&wfid="+wfid+",_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:nodeedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=86 and relatedid="+wfid+",_self} " ;   
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=86 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;

}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(!ajax.equals("1")){
%>
<form name="form1">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></wea:item>
		<wea:item><%=wfname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></wea:item>
		<wea:item><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></wea:item>
		<%if(isPortalOK){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(isbill.equals("0")){ %>
				<%=FormComInfo.getFormname(""+formid)%>
			<%}else if(isbill.equals("1")){
				int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
			%>
				<%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%>
			<%}else{%>
			<%}%>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></wea:item>
		<wea:item><%=wfdes%></wea:item>
	</wea:group>
</wea:layout>
</form>
<%}%>

<form method=post action="wf_operation.jsp">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
<%

	String tableString = "";
	int perpage = 10;
	
	String backfields = " t2.id,t1.nodeid,t2.nodename,t1.nodetype,t1.IsFormSignature,t1.nodetitle,t1.viewnodeids,IsPendingForward,t1.IsWaitForwardOpinion, "+
						" t1.IsBeForward,t1.IsSubmitedOpinion,t1.IsSubmitForward,t1.IsFreeWorkflow,t1.issignmustinput ";
	String fromSql = " from workflow_flownode t1,workflow_nodebase t2 ";
	String whereSql = " where (t2.IsFreeNode is null or t2.IsFreeNode!='1') and t2.id=t1.nodeid and "+
					" t1.workflowid="+wfid;
	String orderSql = " t1.nodeorder, t1.nodetype,t2.id ";
	String operatorparam = wfid+"+"+operatelevel+"+"+ajax+"+"+formid+"+"+isbill+"+"+iscust;
	String operatorpreparam = operatelevel+"+"+hasPreRolesIds;
	String operatorafterparam = operatelevel+"+"+hasRolesIds;
	String freeSetOp = "";
	String popedom = "";
	//if( !isFree.equals("1") ){
		popedom = " 		<popedom transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getNewsOperate\" otherpara=\"column:nodetype+"+isModifyLog+"\"></popedom> ";
		freeSetOp = "<operate href=\"javascript:onFreeWf();\" text=\""+SystemEnv.getHtmlLabelName(33486,user.getLanguage())+"\" otherpara=\"column:nodeid\" target=\"_self\" index=\"1\"/>";
	//}
	
	tableString = " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_NODEINFOLIST,user.getUID())+"\" >"+
	"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(whereSql)+"\"  sqlorderby=\""+orderSql+"\"  sqlprimarykey=\"t2.id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
    "       <head>"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15070,user.getLanguage())+"\" column=\"nodename\" />"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15536,user.getLanguage())+"\" column=\"nodetype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getNodetype\"/>"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"nodeid\" otherpara=\""+operatorparam+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getOperatorName\"/>"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(33473,user.getLanguage())+"\" column=\"nodeid\" otherpara=\""+operatorparam+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getFormContent\"/>"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16380,user.getLanguage())+"\" column=\"nodeid\" otherpara=\""+operatorparam+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getUserselfMenu\"/>"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18009,user.getLanguage())+"\" column=\"nodeid\" otherpara=\""+operatorpreparam+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getPreNodeOperat\"/>"+
    "		<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+"\" column=\"nodeid\" otherpara=\""+operatorafterparam+"\"  transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getAfterNodeOperat\"/>"+
    "       </head>"+
    "		<operates>"+
   	 	popedom +
    "       <operate href=\"javascript:onSubWorkflow();\" text=\""+SystemEnv.getHtmlLabelName(21584,user.getLanguage())+"\" otherpara=\"column:nodeid\" target=\"_self\" index=\"0\"/>"+
    "		<operate href=\"javascript:onTitle();\" text=\""+SystemEnv.getHtmlLabelName(33482,user.getLanguage())+"\" otherpara=\"column:nodeid\" target=\"_self\" index=\"0\"/>"+
	"		<operate href=\"javascript:onSign();\" text=\""+Util.toHtmlForSplitPage(SystemEnv.getHtmlLabelName(33483,user.getLanguage()))+"\" otherpara=\"column:nodeid\" target=\"_self\" index=\"0\"/>"+
	//"		<operate href=\"javascript:onForward();\" text=\""+SystemEnv.getHtmlLabelName(33484,user.getLanguage())+"\" otherpara=\"column:nodeid\" target=\"_self\" index=\"0\"/>"+
	"		<operate href=\"javascript:onFormLog();\" text=\""+SystemEnv.getHtmlLabelName(33485,user.getLanguage())+"\" otherpara=\"column:nodeid\" target=\"_self\" index=\"2\"/>"+
		//freeSetOp + 
	"		<operate href=\"javascript:onExceptionHandle();\" text=\""+SystemEnv.getHtmlLabelName(124778,user.getLanguage())+"\" otherpara=\"column:nodename\" target=\"_self\" index=\"0\"/>"+		
	"		</operates>"+                  
    " </table>";
%>
	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.WF_NODEINFOLIST %>"/>
		</wea:item>
	</wea:group>
</wea:layout>
<input type="hidden" value="wfnode" name="src">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=wfid%>" name="newversionWFID" id="newversionWFID">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="0" name="nodesnum" value="<%=rowsum%>">
</form>

<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});

function setSpanInner(row,hascon,pre)
{
    if(pre == "buttonName"){
    	if(hascon=="1"){
	    	$GetEle("buttonName"+row+"span").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
	   	}else{
	    	$GetEle("buttonName"+row+"span").innerHTML="";
	    }
    }else{
		if(hascon=="1"){
	    	$GetEle("ischeck"+row+"span").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
	   	}else{
	    	$GetEle("ischeck"+row+"span").innerHTML="";
	    }
	}
}
function setPreSpanInner(row,hascon,pre)
{
	if(hascon=="1"){
    	$GetEle("ischeckpre"+row+"span").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
   	}else{
    	$GetEle("ischeckpre"+row+"span").innerHTML="";
    }
}
</script>
<%
 if(!ajax.equals("1")){
%>
<script>
function selectall(){
	window.document.forms[1].submit();

}

<%--xwj taiping wf_log  control  2005-07-25  B E G I N --%>
function onShowBrowser1(wfid,nodeid){
  url = "BrowserMain.jsp?url=wfNodeBrownser.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:400px');
    if(con != undefined){
        if(con=="1"){// "1" 代表 "全选" 或 "选择部分"
            document.all("por"+nodeid+"_conspan").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("por"+nodeid+"_conspan").innerHTML="";
        }
    }

}
<%--xwj taiping wf_log  control  2005-07-25  E N D --%>


function onShowBrowser(row){
//	alert(row);
	url = "BrowserMain.jsp?url=showaddinoperate.jsp?wfid=<%=wfid%>&nodeid="+row;
//	alert(url);
	//con = window.showModalDialog(url);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, con) {
		if(con != undefined){
	        if(con=="1"){
	            document.all("ischeck"+row+"span").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
	        }else{
	            document.all("ischeck"+row+"span").innerHTML="";
	        }
	    }
	} ;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%>";
	dialog.Width = 1000 ;
	dialog.Height = 500 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
//  alert(con==undefined);
}
<%--xwj for td3130 20051122 begin--%>
function onShowPreBrowser(row){
	url = "BrowserMain.jsp?url=showpreaddinoperate.jsp?wfid=<%=wfid%>&nodeid="+row;
	con = window.showModalDialog(url);
    if(con != undefined){
        if(con=="1"){
            document.all("ischeckpre"+row+"span").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("ischeckpre"+row+"span").innerHTML="";
        }
    }

}
<%--xwj for td3130 20051122 end--%>
function onShowNodeAttrBrowser(nodeid){
	url = "BrowserMain.jsp?url=showNodeAttrOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:500px;dialogwidth:600px');
    if(con != undefined){
        if(con=="1"){
            document.all("nodeattr"+nodeid+"Span").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("nodeattr"+nodeid+"Span").innerHTML="";
        }
    }
}

<%--自定义菜单 打开dialog--%>
function onShowButtonNameBrowser(nodeid){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showButtonNameOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) + SystemEnv.getHtmlLabelName(15072,user.getLanguage()) %>";
	dialog.Width = 850;
	dialog.Height = 430;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function openFullWindow(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBar(url){
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

//为了删除时用
function openFullWindow1(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top="+height/2+"," ;
  szFeatures +="left="+width/2+"," ;
  szFeatures +="width=181," ;
  szFeatures +="height=129," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=no" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ;
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
</script>
<%}else{%>
<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function nodeedit() {
		window.location.href="/workflow/workflow/addwfnode.jsp?ajax=1&src=editwf&wfid=<%=wfid%>";
}

function onShowNodeAttrBrowser(nodeid){
	url = "BrowserMain.jsp?url=showNodeAttrOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:500px;dialogwidth:600px');
    if(con != undefined){
        if(con=="1"){
            $GetEle("nodeattr"+nodeid+"Span").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("nodeattr"+nodeid+"Span").innerHTML="";
        }
    }
}

<%-- 标题设置 @author Dracula 2014-7-24 --%>
function onTitle(id,nodeid,obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=title&wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33482,user.getLanguage())%>";
	dialog.Width = 500;
	dialog.Height = 240;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}
<%-- 子流程设置 @author wanglu 2014-09-23 --%>
function onSubWorkflow(id, nodeid, obj){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=subWorkflow&wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(21584,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

<%-- 签字意见设置 @author Dracula 2014-7-24 --%>
function onSign(id,nodeid,obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=sign&wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33483,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 450;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

<%-- 转发设置 @author Dracula 2014-7-24 --%>
function onForward(id,nodeid,obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=forward&wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33484,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 580;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

<%-- 表单内容查看范围设置 @author Dracula 2014-7-24 --%>
function onFormLog(id,nodeid,obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/wfNodeBrownser.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33485,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 350;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

<%-- 自由流转设置 @author Dracula 2014-7-24 --%>
function onFreeWf(id,nodeid,obj)
{
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=freewf&wfid=<%=wfid%>&nodeid="+nodeid+"&isFree=<%=isFree%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33486,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 300;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

<%--流转异常处理设置 --%>
function onExceptionHandle(nodeid, nodename){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=exceptionhandle&wfid=<%=wfid%>&nodeid="+nodeid+"&nodename="+nodename;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(124778,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 350;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}

<%--自定义菜单 打开dialog--%>
function onShowButtonNameBrowser(nodeid){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/showButtonNameContent.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(16380,user.getLanguage()) %>";
	dialog.Width = 1020;
	dialog.Height = 580;
	dialog.Drag = true;
	dialog.maxiumnable = false;
	dialog.URL = url;
	dialog.show();
}
<%--节点前附加操作 打开dialog--%>
function onShowPreBrowser(row){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var titlename = "<%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%>";
	var url = "/workflow/workflow/showpreaddinContent.jsp?wfid=<%=wfid%>&nodeid="+row+"&titlename="+titlename;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
			dialog.callbackfunc4CloseBtn = function(){
			//alert(1);
			//console.log(dialog.innerFrame.contentWindow.document.getElementById("tabcontentframe").contentWindow.closeWindow);
			dialog.innerFrame.contentWindow.document.getElementById("tabcontentframe").contentWindow.closeWindow();
		};
	dialog.show();
}
<%--节点后附加操作 打开dialog--%>
function onShowBrowser(row){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var titlename = "<%=SystemEnv.getHtmlLabelName(18010,user.getLanguage())%>";
	var url = "/workflow/workflow/showaddinContent.jsp?wfid=<%=wfid%>&nodeid="+row+"&titlename="+titlename;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18010,user.getLanguage())%>";
	dialog.Width = 1000;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
		dialog.callbackfunc4CloseBtn = function(){
			//alert(1);
			//console.log(dialog.innerFrame.contentWindow.document.getElementById("tabcontentframe").contentWindow.closeWindow);
			dialog.innerFrame.contentWindow.document.getElementById("tabcontentframe").contentWindow.closeWindow();
		};
	dialog.show();
}

function onShowBrowser1(wfid,nodeid){
  url = "BrowserMain.jsp?url=wfNodeBrownser.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:400px');
    if(con != undefined){
        if(con=="1"){// "1" 代表 "全选" 或 "选择部分"
            $GetEle("por"+nodeid+"_conspan").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            $GetEle("por"+nodeid+"_conspan").innerHTML="";
        }
    }

}
var dialog = null;

function nodefieldedit(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/wfnodefieldContent.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(33508,user.getLanguage())+SystemEnv.getHtmlLabelName(33473,user.getLanguage())%>";
	dialog.Width = 1020;
	dialog.Height = 580;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	
}
<%--
	打开新增节点操作人对话框
	@author: Dracula 2014-7-16
--%>
function nodeopadd(formid,nodeid,isbill,iscust){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/operatorgroupContent.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) + SystemEnv.getHtmlLabelName(15072,user.getLanguage()) %>";
	dialog.Width = 1020;
	dialog.Height = 580;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	
}

function nodeopedit(formid,nodeid,id,isbill,iscust){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workflow/workflow/operatorgroupContent.jsp?ajax=1&wfid=<%=wfid%>&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust+"&id="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) + SystemEnv.getHtmlLabelName(15072,user.getLanguage()) %>";
	dialog.Width = 1020;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
<% } %>
</body>

</html>
