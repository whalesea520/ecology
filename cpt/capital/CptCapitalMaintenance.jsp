<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
</head>
<body>
<%
    String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
    String nameQuery = Util.null2String(request.getParameter("nameQuery"));
    String typedesc = Util.null2String(request.getParameter("capitalspec"));
%>

<%
String from = Util.null2String(request.getParameter("from"));
String init = Util.null2String(request.getParameter("init"));
if(from.equals("tree") || from.equals("location")||"1".equals(init)){
	CptSearchComInfo.resetSearchInfo();
}
String paraid = Util.null2String(request.getParameter("paraid"));
if(!"0".equals(paraid)&&!"".equals(paraid)){
	CptSearchComInfo.setCapitalgroupid(paraid);
}else{
	CptSearchComInfo.setCapitalgroupid("");
	CptSearchComInfo.setCapitalgroupid1("");
}
if(!"".equals(paraid)){
	nameQuery1 = CptSearchComInfo.getName();
	typedesc = CptSearchComInfo.getCapitalspec();
}else{
	CptSearchComInfo.setName("");
}
if(!"".equals(nameQuery1)){
	nameQuery = nameQuery1;
}else{
	nameQuery1 = nameQuery;
}

boolean hasRight = false;
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
	hasRight = true ;
	rightStr = "Capital:Maintenance";
}
if(!hasRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("cptdetachable")),0);

String CurrentUser = ""+user.getUID();

String mark =Util.toScreenToEdit(CptSearchComInfo.getMark(),user.getLanguage());/*编号*/
String name = Util.toScreenToEdit(CptSearchComInfo.getName(),user.getLanguage());/*名称*/
String startdate =  Util.toScreenToEdit(CptSearchComInfo.getStartdate(),user.getLanguage());/*生效日从*/
String startdate1 = Util.toScreenToEdit(CptSearchComInfo.getStartdate1(),user.getLanguage());/*生效日到*/
String enddate= Util.toScreenToEdit(CptSearchComInfo.getEnddate(),user.getLanguage());/*生效至从*/
String enddate1= Util.toScreenToEdit(CptSearchComInfo.getEnddate1(),user.getLanguage());/*生效至到*/
String blongsubcompany = Util.null2String(request.getParameter("blongsubcompany"));//所属分部

String departmentid = Util.toScreenToEdit(CptSearchComInfo.getDepartmentid(),user.getLanguage());/*部门*/
//System.out.println(" 部门:"+Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage()));
String subcompanyid=Util.toScreenToEdit(CptSearchComInfo.getSubcompanyid(),user.getLanguage());//所属分部
//System.out.println("所属分部:"+SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid)));
String resourceid = Util.toScreenToEdit(CptSearchComInfo.getResourceid(),user.getLanguage());		/*人力资源*/
String isinner = Util.toScreenToEdit(CptSearchComInfo.getIsInner(),user.getLanguage());		/*帐内或帐外*/
String capitaltypeid = Util.toScreenToEdit(CptSearchComInfo.getCapitaltypeid(),user.getLanguage());/*资产类型*/
String capitalgroupid = Util.toScreenToEdit(CptSearchComInfo.getCapitalgroupid(),user.getLanguage());/*资产组*/



String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//分部ID
if(subcompanyid1.equals("") && !from.equals("location") && !from.equals("search") && detachable==1 )
{
   
}

int ishead=0;
String sqlWhere = "";
CptSearchComInfo.setIsData("1");
if(detachable == 1){
	CptSearchComInfo.setCapblsubid(subcompanyid1);
}


String tempsearchsql = CptSearchComInfo.FormatSQLSearch();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

//String sqlwhere = "";

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1509,user.getLanguage());
String needfav ="1";
String needhelp ="";
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptcapitalmaintenance"));
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
    int deplevel=0;
    if(detachable==1){
       deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Capital:Maintenance",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(departmentid)));
    }else{
      if(HrmUserVarify.checkUserRight("Capital:Maintenance", user))
        deplevel=2;
    }
    //if(deplevel>0){
		//if(HrmUserVarify.checkUserRight("Capital:Maintenance", user)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSub("+paraid+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		//}
	//}
    
RCMenu += "{EXCEL"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:batchimport(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
    
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;
/**
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    **/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" id="frmSearch" method="post" action="/cpt/search/SearchOperation.jsp?from=search&type=managedata1">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<input type="hidden" name="subcompanyid1" id="subcompanyid1" value="<%=subcompanyid1 %>">
<input type="hidden" name="paraid" id="paraid" value="<%=paraid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top"  onclick="addSub(<%=paraid %>)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<input type="button" value="EXCEL<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %>" class="e8_btn_top" onclick="batchimport()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
		<!-- bpf start 2013-10-29 -->
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<wea:layout type="4col">
			    <wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
				    <wea:item><input type=text name=nameQuery class=InputStyle value='<%=nameQuery %>'></wea:item>
			    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
			    	<wea:item><input type=text name=capitalspec class=InputStyle value='<%=typedesc %>'></wea:item>
			    </wea:group>
			    <wea:group context="">
			    	<wea:item type="toolbar">
			    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="button" name="reset" onclick="resetForm();" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
			    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>"  />
			    	</wea:item>
			    </wea:group>
			</wea:layout>
		</div>
</form>	
<script>
var adName = $("input[name='nameQuery']").eq(0);
$("input[name='submit1']").eq(0).click(function(){
	var value = adName.val();
	$("input[name='flowTitle']").eq(0).val(value);
});

function resetForm(){
	var form= $("#frmSearch");
	//form.find("input[type='text']").val("");
	form.find(".e8_os").find("span.e8_showNameClass").remove();
	form.find(".e8_os").find("input[type='hidden']").val("");
	form.find("select[name!=mouldid]").selectbox("detach");
	form.find("select[name!=mouldid]").val("");
	//form.find("select[name!=mouldid]").trigger("change");
	form.find("span.jNiceCheckbox").removeClass("jNiceChecked");
	beautySelect(form.find("select[name!=mouldid]"));
	form.find(".calendar").siblings("span").html("");
	form.find(".calendar").siblings("input[type='hidden']").val("");
	form.find(".wuiDateSel").val("");
	form.find("input[name=nameQuery]").val("");
	form.find("input[name=capitalspec]").val("");
}
</script>
<%


String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "cpt_cptdata1");//操作项类型
operatorInfo.put("operator_num", 3);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

String backfields = "t1.id,t1.mark,t1.fnamark,t1.location,t1.name,t1.capitalspec,t1.capitalgroupid,t1.resourceid,t1.departmentid,t1.stateid,t1.stockindate,t1.sptcount,t1.depreyear,t1.deprerate,t1.selectdate";
String fromSql  = "";
//String sqlWhere = "";
int resourceLabel =0;
    fromSql  = " from CptCapital  t1 ";
    sqlWhere =  tempsearchsql;
    resourceLabel= 1507;

String orderby = "mark" ;
//baseBean.writeLog("select "+backfields+"  "+fromSql+"  "+sqlWhere+" order by "+orderby);
String tableString = "";
    tableString =" <table  pageId=\""+pageId+"\"  instanceid=\"cptcapitalDetailTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
                         "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                         " <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptCapitalData1' />"+
                         "			<head>"+
                         "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"mark\" orderkey=\"mark\" />"+
                         "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" linkvaluecolumn=\"id\"  linkkey=\"id\" href=\"/cpt/capital/CptCapital.jsp\" target=\"_fullwindow\" />"+
                       	 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(831,user.getLanguage())+"\" column=\"capitalgroupid\" orderkey=\"capitalgroupid\"  transmethod=\"weaver.cpt.maintenance.CapitalAssortmentComInfo.getAssortmentName\" />"+
                       	 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(resourceLabel,user.getLanguage())+"\" column=\"resourceid\"  orderkey=\"resourceid\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\" />"+
                         "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(904,user.getLanguage())+"\" column=\"capitalspec\"  />"+
						 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1363,user.getLanguage())+"\" column=\"sptcount\" orderkey=\"sptcount\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cpt.capital.CapitalComInfo.getIsSptCount\"/>"+
						 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19598,user.getLanguage())+"\" column=\"depreyear\" orderkey=\"depreyear\" />"+
						 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1390,user.getLanguage())+"\" column=\"deprerate\" orderkey=\"deprerate\" />"+
                         "			</head>";
                         
                         tableString+=
                               "		<operates>"+
                            	"     <popedom  column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.cpt.util.CapitalTransUtil.getOperates'  ></popedom> "+	
	               				"		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
	               				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
	               				"		<operate href=\"javascript:onLog();\" text=\""+SystemEnv.getHtmlLabelNames("83",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
	               				"		</operates>"; 
                         
                         
                         tableString+= "</table>";
%>
<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
 



</BODY>
<script language=javascript>
function onSearch(){
	document.frmain.action="/cpt/search/SearchOperation.jsp?from=search";
	$GetEle("frmSearch").submit();
}
function onReSearch(){
	//document.frmain.from.value = "location";
	//alert(document.frmain.from.value);
	location.href="/cpt/capital/CptCapitalMaintenance.jsp?from=location&subcompanyid1=<%=subcompanyid1%>";
}
</script>

<script type="text/javascript">
function onShowCapitalgroupid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("capitalgroupidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitalgroupid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitalgroupidspan").innerHTML = "";
			$GetEle("capitalgroupid").value = "";
		}
	}
}

function onShowCapitaltypeid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "";
			$GetEle("capitaltypeid").value = "";
		}
	}
}

function onShowSubcompany() {
	var id = null;
	var detachable = <%=detachable%>;
	if (detachable != 1) {
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
								+ $GetEle("subcompanyid").value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	} else {
		id = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="
								+ $GetEle("subcompanyid").value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	}
	var issame = false;
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			if (wuiUtil.getJsonValueByIndex(id, 0) == $GetEle("subcompanyid").value) {
				issame = true;
			}
			$GetEle("subcompanyidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("subcompanyid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("subcompanyidspan").innerHTML = "";
			$GetEle("subcompanyid").value = "";
		}
	}
}

function onShowResourceID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	if (id != undefined || id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("resourceidspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1);
			+"</A>";
			$GetEle("resourceid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("resourceidspan").innerHTML = "";
			$GetEle("resourceid").value = "";
		}
	}
}

function onShowDepartment(inputname, spanname) {
	var retValue = null;
	if (<%=detachable%> != 1) {
		retValue = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								+ $GetEle(inputname).value, "",
								"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	} else {
		retValue = window
				.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="
								+ $GetEle(inputname).value, "",
						"dialogWidth:550px;dialogHeight:550px;center:1;addressbar=no;status=0;resizable=0;");
	}
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$GetEle(spanname).innerHTML = "<A href=/hrm/company/HrmDepartmentDsp.jsp?id="
					+ wuiUtil.getJsonValueByIndex(retValue, 0)
					+ ">"
					+ wuiUtil.getJsonValueByIndex(retValue, 1) + "</A>";
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue,
					0);
		} else {
			$GetEle(inputname).value = "";
			$GetEle(spanname).innerHTML = "";
		}
	}
}
function onEdit(id){
	if(id){
		var url="/cpt/capital/CptCapitalEdit.jsp?id="+id+"&isdialog=1";
		var title="<%=SystemEnv.getHtmlLabelNames("83597",user.getLanguage())%>";
		openDialog(url,title,1000,720,true,true);
	}
}
function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/cpt/capital/CptCapitalOperation.jsp",
				{"operation":"deletecapital","id":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
						refreshLeftTree();
					});
				}
			);
			
		});
	}
}

function onLog(id){
	//var url= "/systeminfo/SysMaintenanceLog.jsp?_fromURL=3&sqlwhere=where operateitem=51";
	var url = "/systeminfo/SysMaintenanceLog.jsp?_fromURL=3&operateitem=51";
	var title="<%=SystemEnv.getHtmlLabelNames("32061",user.getLanguage())%>";
	if(id){
		url=url+"&relatedid="+id;
	}
	openDialog(url,title,1000,720,false);
}
function addSub(id){
	if(id==undefined){id=0}
	var url="/cpt/capital/CptCapitalAdd.jsp?assortmentid="+id+"&isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("22357",user.getLanguage())%>";
	openDialog(url,title,1000,720,true,true);
}
function batchimport(){
	var url="/cpt/capital/CapitalExcelToDB.jsp?isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelName(19320,user.getLanguage())%>";
	openDialog(url,title,1000,720);
}

function batchDel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		jQuery.post(
			"/cpt/capital/CptCapitalOperation.jsp",
			{"operation":"batchdelete","id":typeids},
			function(data){
				if(data&&data.length>0){
					window.top.Dialog.alert(data.join("\n"),function(){
						window.parent.location.href=window.parent.location.href;
					});
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						window.parent.location.href=window.parent.location.href;
					});
				}
				refreshLeftTree();
			},
			'json'
		);
		
	});
}
function onBtnSearchClick(){
	$("#frmSearch").submit();
}
$(function(){
	var cptgroupname='<%=CapitalAssortmentComInfo.getAssortmentName( paraid) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(22315,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
function refreshLeftTree(){
	try{
		var tree= $("#leftframe2",parent.parent.document);
		var src=tree.attr("src");
		tree.attr("src",src);
	}catch(e){}
}
</script>

<SCRIPT language="VBS" src="/js/browser/LgcAssetUnitBrowser.vbs"></SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
