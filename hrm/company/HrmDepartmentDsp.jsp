
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
int depid = Util.getIntValue(request.getParameter("id"),1);
if(depid<0){
	response.sendRedirect("/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDspVirtual&id="+depid);
}
String fromHrmTab = Util.null2String(request.getParameter("fromHrmTab"));
String hasTree = Util.null2String(request.getParameter("hasTree"));
//如果不是来自HrmTab页，增加页面跳转
if(!fromHrmTab.equals("1")){
	String url = "/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp&id="+depid+"&hasTree="+hasTree;
	response.sendRedirect(url.toString()) ;
	return;
}

rs.executeProc("HrmDepartment_SelectByID",""+depid);
String departmentmark="";
String departmentname = "";
//int supdepid = 0;
String supdepid = "";
String allsupdepid = "";
int subcompanyid=0;
int showorder = 0;
String canceled = "0";
int coadjutant=0;    
String departmentcode = "";

if(rs.next()){
	departmentmark = Util.toScreen(rs.getString("departmentmark"),user.getLanguage());
	departmentname = Util.toScreen(rs.getString("departmentname"),user.getLanguage());
	//supdepid = rs.getInt("supdepid");
	supdepid = Util.toScreen(rs.getString("supdepid"),user.getLanguage());	
	allsupdepid = Util.toScreen(rs.getString("allsupdepid"),user.getLanguage());	
	subcompanyid = Util.getIntValue(rs.getString("subcompanyid1"),0);	
	showorder = Util.getIntValue(rs.getString("showorder"),0);
	canceled = Util.toScreen(rs.getString("canceled"),user.getLanguage());	
	departmentcode = Util.toScreen(rs.getString("departmentcode"),user.getLanguage());
    coadjutant = Util.getIntValue(rs.getString("coadjutant"),0);
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	var url = "";
	dialog.Width = 800;
	dialog.Height = 500;
  if(cmd=="editDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentEdit&isdialog=1&id=<%=depid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,27511", user.getLanguage())%>";
	}else if(cmd=="addSiblingDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAdd&method=addSiblingDepartment&isdialog=1&subcompanyid=<%=subcompanyid%>&supdepid=<%=supdepid%>&id=<%=depid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("1421,17899", user.getLanguage())%>";
	}else if(cmd=="addChildDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAdd&method=addChildDepartment&isdialog=1&subcompanyid=<%=subcompanyid%>&supdepid=<%=depid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("1421,17587", user.getLanguage())%>";
		dialog.Height = 500;
	}else if(cmd=="addHrmResource"){
		url = "/hrm/company/HrmResourceAdd.jsp?isdialog=1&departmentid=<%=depid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15883, user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 600;
	}else if(cmd=="importexcel"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmImport";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17887", user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 600;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editDepartment()
{
	openDialog("editDepartment");
}

function addSiblingDepartment()
{
	openDialog("addSiblingDepartment");
}

function addChildDepartment()
{
	openDialog("addChildDepartment");
}

function addHrmResource()
{
	openDialog("addHrmResource");
}

function addHrmImportexcel()
{
	openDialog('importexcel');
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=12 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=12")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function checkHasJob(){
	 Validator.checkHasJob(<%=depid%>,checkHasJobCallback) ;
}

function onDelete(){

		Validator.departmentIsUsed(<%=depid%>,function checkHasChildDepartmentCallback(data){
		if(data=='false')data=false;
	 	if(data){
	 		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33594, user.getLanguage())%>");
             return;
	 	}


		 Validator.checkHasJob(<%=depid%>,function checkHasJobCallback(data){
		 	if(data=='false')data=false;
		 	if(data){
		 		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81685, user.getLanguage())%>");
	             return;
		 	}
		 	
		 	Validator.checkHasChildDepartment(<%=depid%>,function checkHasChildDepartmentCallback(data){
		 	if(data=='false')data=false;
		 	if(data){
		 		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82376, user.getLanguage())%>");
	             return;
		 	}
		     invoke(<%=depid%>);
		 }) ;
		
		 }) ;
	 }) ;
}
function check(o){
		 if(o=='false')o=false;
     if(o)
     	window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(33594, user.getLanguage())%>！') ;
     else{
     	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
     		document.searchfrm.operation.value="delete";
				document.searchfrm.action="DepartmentOperation.jsp";
				document.searchfrm.submit();
     	})
     }
     return o;
 }
function invoke(id){
     Validator.departmentIsUsed(id,check) ;
 }
</script>
</head>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int deplevel=0;
if(detachable==1){
    deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmDepartmentAdd:Add",subcompanyid);
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user))
        deplevel=2;
}
boolean canlinkbudget = HrmUserVarify.checkUserRight("SubBudget:Maint", user);
boolean canlinkexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user, depid) ;

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = departmentname+","+departmentmark;
String needfav ="1";
String needhelp ="";

String navName = "";
if(depid!=0){
	navName = Util.toHtmlMode(DepartmentComInfo.getDepartmentmark(depid+""));
}
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});

function jsHrmDepartmentRoles(){
 window.open("/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentRoles&id=<%=depid%>");
}
function jsHrmJobTitles(){
	window.open("/hrm/HrmTab.jsp?_fromURL=jobtitles&from=HrmDepartmentDsp&departmentid=<%=depid%>");
}
function jsFnaExpenseDetail(){
	window.open("/fna/report/expense/FnaExpenseDetail.jsp?organizationid=<%=depid%>&organizationtype=2");
}
function jsFnaBudgetView(){
	window.open("/fna/budget/FnaBudgetView.jsp?organizationid=<%=depid%>&organizationtype=2");
}
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	if(deplevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}

	if(deplevel>1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		}
	

	//RCMenu += "{"+SystemEnv.getHtmlLabelName(179,user.getLanguage())+",/hrm/search/HrmResourceSearchTmp.jsp?department="+depid+",_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	
	if(deplevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17899,user.getLanguage())+",javascript:addSiblingDepartment(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17900,user.getLanguage())+",javascript:addChildDepartment(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	if(deplevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17887,user.getLanguage())+",javascript:addHrmImportexcel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
	}}
	
if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	  	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}else{
     if(deplevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
	 }
}


if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(122,user.getLanguage())+",javascript:jsHrmDepartmentRoles();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+",javascript:jsHrmJobTitles();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	if(canlinkexpense){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(428,user.getLanguage())+",javascript:jsFnaExpenseDetail();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
		
	if( canlinkbudget ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(386,user.getLanguage())+",javascript:jsFnaBudgetView();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
if(HrmUserVarify.checkUserRight("HrmDepartment:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+depid+"),_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+depid+"),_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=searchfrm name=searchfrm action="HrmDepartmentDsp.jsp" method=post>
<input class=inputstyle type=hidden name=id value="<%=depid %>">
<input class=inputstyle type=hidden name=fromHrmTab value="<%=fromHrmTab %>">
<input class=inputstyle type=hidden name=operation value="add">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
	<%if(deplevel>0 && ("0".equals(canceled) || "".equals(canceled))){
		if(deplevel>0){
	%>
			<input type=button class="e8_btn_top" onclick="openDialog('importexcel');" value="<%=SystemEnv.getHtmlLabelName(17887, user.getLanguage())%>"></input>
	<%}} %>	
		<%if(deplevel>0){%>
			<%
				if(("0".equals(canceled) || "".equals(canceled))){
				%>
				<input type=button class="e8_btn_top" onclick="addSiblingDepartment();" value="<%=SystemEnv.getHtmlLabelNames("82,17899",user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="editDepartment();" value="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="doCanceled();" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%>"></input>
				<%}else{ %>
				<input type=button class="e8_btn_top" onclick="doISCanceled();" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage())%>"></input>
			<%}} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<% 
	 HrmDeptFieldManager hfm = new HrmDeptFieldManager(5);
	 hfm.getCustomData(depid);
	 List lsGroup = hfm.getLsGroup();
	 for(int tmp=0;lsGroup!=null&&tmp<lsGroup.size();tmp++){
   	String groupid = (String)lsGroup.get(tmp);
  	List lsField = hfm.getLsField(groupid);
  	if(lsField.size()==0)continue;
  	if(hfm.getGroupCount(lsField)==0)continue;
  	String grouplabel = HrmGroupComInfo.getLabel(groupid);
   	%>
   	<wea:group context='<%=SystemEnv.getHtmlLabelName(Integer.parseInt(grouplabel),user.getLanguage())%>' >	
   	<%
  	for(int j=0;lsField!=null&&j<lsField.size();j++){
  		String fieldid = (String)lsField.get(j);
  		String isuse = HrmFieldComInfo.getIsused(fieldid);
  		if(!isuse.equals("1"))continue;
  		String fieldname = HrmFieldComInfo.getFieldname(fieldid);
  		String fieldlabel = HrmFieldComInfo.getLabel(fieldid);
  		int fieldhtmltype = Integer.parseInt(HrmFieldComInfo.getFieldhtmltype(fieldid));
  		int type = Integer.parseInt(HrmFieldComInfo.getFieldType(fieldid));
  		String dmlurl = Util.null2String(HrmFieldComInfo.getFieldDmlurl(fieldid));
  		String fieldValue = hfm.getData(fieldname);
  		
		if(fieldhtmltype == 3 ){
			fieldValue=hfm.getHtmlBrowserFieldvalue(user, dmlurl, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue , "0");
		}else{
	  		fieldValue=hfm.getFieldvalue(user, dmlurl, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue, 0);
		}
 			if(fieldname.equals("showid")){
 			%>
 			<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>
			<wea:item><%=depid%></wea:item>
 				<%
 				continue;
 			}
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>  
	  <wea:item><%=fieldValue%></wea:item>
		<%} %>
		<%
		if(tmp==0){
			int resourceNum = 0;
			String sql = "SELECT COUNT(*) FROM hrmresource WHERE departmentid = "+ depid +" and ( status =0 or status = 1 or status = 2 or status = 3)";
			rs.executeSql(sql);
			if(rs.next()){
				resourceNum = rs.getInt(1);
			}
			
			//4:解聘 5:离职 6:退休 7:无效
			int resourceNum1 = 0;
			 sql = "SELECT COUNT(*) FROM hrmresource WHERE departmentid = "+ depid +" and status in(4,5,6,7)";
			rs.executeSql(sql);
			if(rs.next()){
				resourceNum1 = rs.getInt(1);
			}
		%>
		<wea:item><%=SystemEnv.getHtmlLabelNames("1831,1859",user.getLanguage())+"/"+SystemEnv.getHtmlLabelNames("6091,1859",user.getLanguage())%></wea:item>  
	  <wea:item><%=resourceNum+"/"+resourceNum1%></wea:item>
		<%} %>
	</wea:group>
	<%} %>
</wea:layout>
</FORM>
<script language=javascript>
function submitData() {
editDepartment();
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>", function(){
	 		var ajax=ajaxinit();
		      ajax.open("POST", "HrmCanceledCheck.jsp", true);
		      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		      ajax.send("deptorsupid=<%=depid%>&userid=<%=user.getUID()%>");
		      ajax.onreadystatechange = function() {
		        if (ajax.readyState == 4 && ajax.status == 200) {
		            try{
			            if(ajax.responseText == 1){
			              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
			              //parent.leftframe.location.reload();
			              window.location.href = "HrmDepartmentDsp.jsp?id=<%=depid%>";
			              onBtnSearchClick();
			            }else{
			             if(ajax.responseText == 0){
			          			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82293, user.getLanguage())%>!");
			             }else if(ajax.responseText == 2){
			             		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82294, user.getLanguage())%>！");
			             }
			            }
		            }catch(e){
		                return false;
		            }
		        }
		     }
	 	}); 	
}

 function doISCanceled(){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>", function(){
		var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=depid%>&cancelFlag=1&userid=<%=user.getUID()%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmDepartmentDsp.jsp?id=<%=depid%>";
	              onBtnSearchClick();
				  return;
	            } 
                if(ajax.responseText == 0) {
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24296, user.getLanguage())%>");
	              return;
	            }
	            if(ajax.responseText == 2) {
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24297, user.getLanguage())%>");
	              return;
	            }
            }catch(e){
                return false;
            }
        }
     }
	});
 }
</script>

</BODY></HTML>
