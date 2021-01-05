
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.login.Account,
				 weaver.login.VerifyLogin,
                 weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerVO"%>
<%@ page import="weaver.systeminfo.sysadmin.HrmResourceManagerDAO"%>
<%@page import="weaver.hrm.common.*,weaver.hrm.authority.domain.*,weaver.hrm.authority.manager.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RelatedRequestCount" class="weaver.workflow.request.RelatedRequestCount" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<base target="_blank" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
</head>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);    
String id = Util.null2String(request.getParameter("id"));
if(id.equals("")) id=String.valueOf(user.getUID());
String titlename = SystemEnv.getHtmlLabelName(30804,user.getLanguage());

//update by fanggsh TD4233 begin
HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(id);

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();

String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/

String subcompanyid = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
 subcompanyid="-1";
session.setAttribute("hrm_subCompanyId",subcompanyid);
String status = Util.toScreen(RecordSet.getString("status"),user.getLanguage()) ;
String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/

/*显示权限判断*/
int userid = user.getUID();

boolean isSelf		=	false;

if (id.equals(""+user.getUID()) ){
	isSelf = true;
}


// 判定是否可以查看该人预算
boolean canviewbudget = HrmUserVarify.checkUserRight("FnaBudget:All",user, departmentid) ;
boolean caneditbudget =  HrmUserVarify.checkUserRight("FnaBudgetEdit:Edit", user) &&  (""+user.getUserDepartment()).equals(departmentid) ;
boolean canapprovebudget = HrmUserVarify.checkUserRight("FnaBudget:Approve",user) ;

boolean canlinkbudget = canviewbudget || caneditbudget || canapprovebudget || isSelf ;

// 判定是否可以查看该人收支
boolean canviewexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, departmentid) ;
boolean canlinkexpense = canviewexpense || isSelf ;


%>
<BODY>



<form name=resource action=HrmResourceOperation.jsp method=post enctype="multipart/form-data">
<INPUT class=inputstyle id=BCValidate type=hidden value=0 name=BCValidate>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%



//老的分权管理
/*
int detachable=0;
if(session.getAttribute("detachable")!=null){
    detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
}else{
    rs.executeSql("select detachable from SystemSet");
    if(rs.next()){
        detachable=rs.getInt("detachable");
        session.setAttribute("detachable",String.valueOf(detachable));
    }
}
*/
//人力资源模块是否开启了管理分权，如不是，则不显示框架，直接转向到列表页面(新的分权管理)
int hrmdetachable=0;
if(session.getAttribute("hrmdetachable")!=null){
    hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
}else{
	boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
	if(isUseHrmManageDetach){
	   hrmdetachable=1;
	   session.setAttribute("detachable","1");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}else{
	   hrmdetachable=0;
	   session.setAttribute("detachable","0");
	   session.setAttribute("hrmdetachable",String.valueOf(hrmdetachable));
	}
}
int operatelevel=-1;
if(hrmdetachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}

if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
if(HrmListValidate.isValidate(19)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:sendmail(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}}
if(HrmListValidate.isValidate(32)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16426,user.getLanguage())+",javascript:doAddWorkPlan(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//end
if(HrmListValidate.isValidate(33)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17859,user.getLanguage())+",javascript:doAddCoWork(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
			if(HrmListValidate.isValidate(19)){ %>
			<input type=button class="e8_btn_top" onclick="sendmail();" value="<%=SystemEnv.getHtmlLabelName(1226, user.getLanguage())%>"></input>
		<%}} %>
		<input type=button class="e8_btn_top" onclick="doAddWorkPlan();" value="<%=SystemEnv.getHtmlLabelName(16426, user.getLanguage())%>"></input>
		<input type=button class="e8_btn_top" onclick="doAddCoWork();" value="<%=SystemEnv.getHtmlLabelName(17859, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout>
<%
	//Added by wcd 2014-11-07 start
	if(HrmListValidate.isValidate(24) && (isSelf || user.getUID() == 1)){
		HrmRightTransferManager transferManager = new HrmRightTransferManager("transfer", id, "", request).loadData();
		HrmRightTransfer bean = (HrmRightTransfer)transferManager.getBean();
		Map addressLinkMap = bean.getAddressMap();
		if(addressLinkMap == null) addressLinkMap = new HashMap();
		String[] codeNames = new String[] {
			"T101","T111","T112","T113","T121","T122","T123","T124","T125","T131",
			"T132","T133","T134","T141","T142","T143","T144","T145","T146","T147",
			"T148","T149","T151","T152","T161","T171","T181","T182","T183","T191",
			"Temail001","Temail002"};
		String[] lNames = new String[] {
				"21313","33929,101","430,101","101,1332","442","122","22671","33646","33645","18015,15586,99",
				"15060,665,18015","1207","17991","58,21945","58,77,385","58,78,385","58,15059","20482,633,385","15060,60,16398","15060,60,25237",
				"58,79","20306,58","33929,2103","430,2103","2211","535","18831","17855,21945","17855,633,385","15060,60,33677"
				,"131756","131757"};
		int[] allNums = new int[] {
			bean.getT101AllNum(),bean.getT111AllNum(),bean.getT112AllNum(),bean.getT113AllNum(),bean.getT121AllNum(),
			bean.getT122AllNum(),bean.getT123AllNum(),bean.getT124AllNum(),bean.getT125AllNum(),bean.getT131AllNum(),
			bean.getT132AllNum(),bean.getT133AllNum(),bean.getT134AllNum(),bean.getT141AllNum(),bean.getT142AllNum(),
			bean.getT143AllNum(),bean.getT144AllNum(),bean.getT145AllNum(),bean.getT146AllNum(),bean.getT147AllNum(),
			bean.getT148AllNum(),bean.getT149AllNum(),bean.getT151AllNum(),bean.getT152AllNum(),bean.getT161AllNum(),
			bean.getT171AllNum(),bean.getT181AllNum(),bean.getT182AllNum(),bean.getT183AllNum(),bean.getT191AllNum(),
			bean.getTemail001AllNum(),bean.getTemail002AllNum()};
		String[] wTitles = new String[] {
			"367,21313","367,101","367,101","367,101,1332","367,442","367,122","367,124","367,33646","367,33645","367,18015,15586,15072",
			"367,665,18015","367,1207","367,17991","367,58,92","367,58,92","367,58,92","367,58,92","367,20482","367,16398","367,66",
			"367,58","367,58","367,2103","367,2103","367,2211","367,535","367,18831","367,17855,34242","367,17855,34242","367,33677",
			"367","367"};
%>
<wea:group context='<%=SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage())%>'>
<wea:item attributes="{'isTableList':'true','colspan':'full'}">
	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'30%,30%,40%'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("385,63",user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></wea:item>
			<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></wea:item>
<%
	String addressLink = "";
	String onClick = "";
	int codeLength = allNums == null ? 0 : allNums.length;
	for(int i=0; i<codeLength; i++){
		if(allNums[i] <= 0) continue;
		addressLink = Tools.vString(addressLinkMap.get(codeNames[i]));
		if(addressLink.length() > 0){
			addressLink += (addressLink.indexOf("?") == -1 ? "?" : "&") + "fromid=" + id + "&type="+codeNames[i]+"IdStr&isHidden=true&_HRM_FLAG=true";
		}
		onClick = "doOpen('"+addressLink+"','"+SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage())+"');";
%>
		<wea:item><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
		<wea:item><%=allNums[i]%></wea:item>
		<wea:item><a href="javascript:void(0);" onclick="<%=onClick%>return false;"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></a></wea:item>
<%
	}
%>
<%
boolean FnaExpenseResource = true;
boolean isManager = false;
String managerStr = "";
RecordSet.executeSql(" select managerstr from hrmresource where id = " + id ) ;
if ( RecordSet.next() ) managerStr = Util.null2String(RecordSet.getString(1)) ;
if (managerStr.indexOf(String.valueOf(user.getUID())) != -1)
    isManager = true;

boolean isSameDept = false;
RecordSet.executeSql(" select departmentid from hrmresource where id = " + id ) ;
if ( RecordSet.next() && (user.getUserDepartment() == RecordSet.getInt(1)) )
    isSameDept = true;

if (String.valueOf(user.getUID()).equals(id)) {
    //it's ok.
} else if (isManager) {
    //it's ok.
} else if (HrmUserVarify.checkUserRight("FnaBudget:All" , user) && isSameDept) {
    //it's ok.
} else {
	FnaExpenseResource = false;
}
//增加期间设置判断，如果期间设置数据异常，不能进入页面
ArrayList startdates = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
String fnayear = Util.add0(today.get(Calendar.YEAR) , 4) ; 
RecordSet.executeSql("select startdate, enddate from FnaYearsPeriodsList where fnayear= '"+fnayear+"' order by Periodsid ");
while( RecordSet.next() ) {
    startdates.add( Util.null2String(RecordSet.getString( "startdate" ) ) ) ;
    enddates.add( Util.null2String(RecordSet.getString( "enddate" ) ) ) ;
}
    //added by lupeng 2004.2.11
    if (startdates.isEmpty() || enddates.isEmpty() || enddates.size()<12)
    	FnaExpenseResource = false;
%>
		<%if(FnaExpenseResource){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></wea:item>
		<wea:item></wea:item>
		<wea:item><a href="/fna/report/expense/FnaExpenseResourceDetail.jsp?resourceid=<%=id%>" target="_blank"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></a></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></wea:item>
		<wea:item></wea:item>
		<wea:item><a href="/fna/report/budget/FnaBudgetResourceDetail.jsp?resourceid=<%=id%>" target="_blank"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></a></wea:item>
		<%} %>
		</wea:group>
	</wea:layout>
</wea:item>
</wea:group>
<%	
	}
	//Added by wcd 2014-11-07 end
%>
<%/*if(HrmListValidate.isValidate(26)){%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())+","+SystemEnv.getHtmlLabelName(139,user.getLanguage())%>'>
	<wea:item>
		<table width="100%">
			<% RecordSet.executeProc("HrmRoleMembers_SByResourceID",id);
	   	int idx = 0 ;
			while(RecordSet.next()) {
	    	RecordSet1.executeSql("select rolesmark from hrmroles where id = "+RecordSet.getString("roleid"));
	    	RecordSet1.next();
	    	if(idx==0||idx%4==0)out.println("<tr>");
	    	String roleInfo = Util.toScreen(RecordSet1.getString(1),user.getLanguage());
	    	String rolelevel = RecordSet.getString("rolelevel") ;
	      String levelname = "" ;
	      if(rolelevel.equals("2")) levelname = SystemEnv.getHtmlLabelName(140,user.getLanguage());
	      if(rolelevel.equals("1")) levelname = SystemEnv.getHtmlLabelName(141,user.getLanguage());
	      if(rolelevel.equals("0")) levelname = SystemEnv.getHtmlLabelName(124,user.getLanguage());
	      if(roleInfo.length()>0)roleInfo+=",";
	      roleInfo+=levelname;
	      idx++;
	      out.println("<td>"+roleInfo+"</td>");
	      if(idx!=0&&idx%4==0)out.println("</tr>");
	    }%>
			</tr>
		</table>
	</wea:item>
</wea:group>
<%}*/%>	
<%if(isgoveproj==0){%>
<%if(software.equals("ALL") || software.equals("HRM")){%>
<%if(HrmListValidate.isValidate(27)){%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(16068,user.getLanguage())%>'>
<%
ArrayList al = new ArrayList();
al = TrainComInfo.getTrainByResource(id);
for(int i = 0; i<al.size(); i++){
String trainid = (String)al.get(i);
%>
<wea:item><a href="/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainEditDo&isdialog=0&id=<%=trainid%>" ><%=TrainComInfo.getTrainname(trainid)%></a></wea:item>
<%}%>
</wea:group>
<%}%>         
<%if(HrmListValidate.isValidate(28)){%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(16069,user.getLanguage())%>'>
<%
String applyworkflowid = "" ;
rs.executeSql("select id from workflow_base  where formid = 48 and isbill='1' and isvalid = '1' ");
if( rs.next() ) applyworkflowid = Util.null2String(rs.getString("id"));

ArrayList al = new ArrayList();
al = TrainPlanComInfo.getTrainPlanByResource(id);
for(int i = 0; i<al.size(); i++){
String trainplanid = (String)al.get(i);
%>
<wea:item><a href="/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id=<%=trainplanid%>" target="_blank"><%=TrainPlanComInfo.getTrainPlanname(trainplanid)%></a></wea:item>
<wea:item><%if(user.getUID()==Util.getIntValue(id) && !applyworkflowid.equals("")){%><a href="/workflow/request/AddRequest.jsp?workflowid=<%=applyworkflowid%>&TrainPlanId=<%=trainplanid%>" target="_Blank"><%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%></a><%}%></wea:item>
<%}%>
</wea:group>
<%}%>
<%if(HrmListValidate.isValidate(35)){%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(15652,user.getLanguage())%>'>
<%
String sql = "" ;
sql = "select a.id ,b.checkname,a.resourceid" +
" from HrmByCheckPeople a , HrmCheckList b "+
" where a.checkid = b.id and a.checkercount="+id +" and b.enddate>='"+currentdate+"' " ;
rs.executeSql(sql);
while(rs.next()) {
String checkpeopleid = Util.null2String(rs.getString(1)) ;
String checkname = Util.null2String(rs.getString(2)) ;
String resourceid = Util.null2String(rs.getString(3)) ;
%>
<wea:item><a href="/hrm/actualize/HrmCheckMark.jsp?id=<%=checkpeopleid%>" target="_Blank"><%=checkname%></a></wea:item>
<wea:item><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></wea:item>
<%}%>
</wea:group>
<%} %>
<%}%>
<%}%>
</wea:layout>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
</form>

<script language=javascript>
  function doedit(){

    if(<%=operatelevel%>>0){
      location = "HrmResourceBasicEdit.jsp?id=<%=id%>&isView=1";
    }else{
        if(<%=isSelf%>){
          location = "HrmResourceContactEdit.jsp?id=<%=id%>&isView=1";
        }
    }
  }
  function dodelete(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
    document.resource.operation.value="delete";
    document.resource.submit();
    }
  }


  function sendmail(){
    var tmpvalue = "<%=email%>";
    while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if (tmpvalue=="" || tmpvalue.indexOf("@") <1 || tmpvalue.indexOf(".") <1 || tmpvalue.length <5) {
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
        return;
    }
    openFullWindowForXtable("/sendmail/HrmMailMerge.jsp?id=<%=id%>&fromPage="+encodeURIComponent(window.location));
  }


function doAddWorkPlan() {
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/workplan/data/WorkPlan.jsp?resourceid=<%=id%>&add=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
	
}
function doAddCoWork(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/cowork/AddCoWork.jsp?hrmid=<%=id%>";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18034,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function doOpen(url, title){
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width = 700;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

jQuery(document).ready(function(){
	jQuery(".HeaderForXtalbe").hide();
})
</script>
</BODY>
</HTML>

