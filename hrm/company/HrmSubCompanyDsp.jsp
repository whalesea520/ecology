
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.definedfield.HrmDeptFieldManager"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="HrmFieldComInfo" class="weaver.hrm.definedfield.HrmFieldComInfo" scope="page" />
<jsp:useBean id="HrmGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0); 
if(id<0){
	response.sendRedirect("/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDspVirtual&id="+id);
}
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+id);
String subcompanydesc = SubCompanyComInfo.getSubCompanydesc(""+id);
int companyid = Util.getIntValue(SubCompanyComInfo.getCompanyid(""+id),0);
String companyname = CompanyComInfo.getCompanyname(""+companyid);

String supsubcomid=Util.null2s(SubCompanyComInfo.getSupsubcomid(""+id),"0");
String url=SubCompanyComInfo.getUrl(""+id);
String showorder=SubCompanyComInfo.getShoworder(""+id);
boolean isoracle = false;
String strDBType = Util.null2String(rs.getDBType());
if (strDBType.equals("oracle")||strDBType.equals("db2")) {
	isoracle = true;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
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
  if(cmd=="editSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyEdit&title=93,141&id=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,141", user.getLanguage())%>";
	}else if(cmd=="addSiblingSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAdd&method=addSiblingSubCompany&title=82,17897&subcompanyid=<%=supsubcomid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17897", user.getLanguage())%>";
	}else if(cmd=="addChildSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAdd&method=addChildSubCompany&title=82,17898&subcompanyid=<%=id%>&supsubcomid=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17898", user.getLanguage())%>";
	}else if(cmd=="addDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAdd&title=82,27511&subcompanyid=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,27511", user.getLanguage())%>";
	}else if(cmd=="importexcel"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmImport";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17887", user.getLanguage())%>";
		dialog.Height = 600;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addSiblingSubCompany()
{
	openDialog("addSiblingSubCompany");
}

function addChildSubCompany()
{
	openDialog("addChildSubCompany");
}

function addDepartment()
{
	openDialog("addDepartment");
}

function importexcel()
{
	openDialog("importexcel");
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=11 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=11")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>  
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+companyname+"-"+subcompanyname;
String needfav ="1";
String needhelp ="";

String canceled = "";
String subcompanycode = "";
rs.executeSql("select canceled,subcompanycode from HrmSubCompany where id="+id);
if(rs.next()){
 canceled = rs.getString("canceled");
 subcompanycode = Util.null2String(rs.getString("subcompanycode"));
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int sublevel=0;
int suplevel=0;
int deplevel=0;

if(detachable==1){
    deplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmDepartmentAdd:Add",id);
    sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyAdd:Add",id);
    suplevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyAdd:Add",Integer.parseInt(supsubcomid));
}else{
    if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user))
        deplevel=2;
    if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
        sublevel=2;
        suplevel=2;
    }
}

    boolean canlinkbudget = HrmUserVarify.checkUserRight("SubBudget:Maint", user);
    boolean canlinkexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user) ;

String navName = "";
if(id!=0){
	navName = Util.toHtmlMode(SubCompanyComInfo.getSubCompanyname(id+""));
}else if(companyid!=0){
	navName = Util.toHtmlMode(CompanyComInfo.getCompanyname(companyid+""));
}

boolean isdftsubcom = false;//是否默认分部
if(detachable==1){
	sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyEdit:Edit",id);
    rs.executeProc("SystemSet_Select","");
    while(rs.next()){
	    int dftsubcomid = rs.getInt("dftsubcomid");
	    if(dftsubcomid==id)isdftsubcom = true;
    }
}else{
    if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user))
        sublevel=2;
	if(id==1)isdftsubcom = true;	
}
%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});

function jsFnaExpenseDetail(){
	window.open("/fna/report/expense/FnaExpenseDetail.jsp?organizationid=<%=id%>&organizationtype=1");
}

function jsFnaBudgetView(){
	window.open("/fna/budget/FnaBudgetView.jsp?organizationid=<%=id%>&organizationtype=1");
}

function checkHasDepartment(id){
	Validator.checkHasDepartmentAndCompany(id,checkHasDepartmentCallback) ;
}

function checkHasDepartmentCallback(flag){
	if(flag != "0"){
		var alerttitle ="";
		if(flag == 2){
			alerttitle = "<%=SystemEnv.getHtmlNoteName(103,user.getLanguage())%>"
		}else if(flag == 3){
			alerttitle = "<%=SystemEnv.getHtmlNoteName(104,user.getLanguage())%>"
		}else{
			alerttitle="<%=SystemEnv.getHtmlNoteName(3400,user.getLanguage())%>";
		}
		window.top.Dialog.alert(alerttitle);
		return false;
	}else{
     	if(<%=isdftsubcom%>){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(89,user.getLanguage())%>");
		}else{
			invoke(<%=id%>);
		}
     }
}

function onDelete(){
	checkHasDepartment(<%=id%>);
}

function check(o){
		  if(o=='false')o=false;
     if(o)
     	window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(88,user.getLanguage())%>");
     else{
     	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
     	document.searchfrm.action="SubCompanyOperation.jsp";
     	document.searchfrm.operation.value="deletesubcompany";
			document.searchfrm.submit();
     })
     }
     return o;
 }
function invoke(id){

     Validator.subCompanyIsUsed(id,check) ;
 }
</script>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(sublevel>1 && ("0".equals(canceled) || "".equals(canceled))){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_parent} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17897,user.getLanguage())+",javascript:addSiblingSubCompany(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17898,user.getLanguage())+",javascript:addChildSubCompany(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{-}" ;	
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())+",javascript:addDepartment(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(17887,user.getLanguage())+",javascript:importexcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	  	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}else{
     if(sublevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
	 }
}

if(canlinkexpense && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(428,user.getLanguage())+",javascript:jsFnaExpenseDetail();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if( canlinkbudget && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(386,user.getLanguage())+",javascript:jsFnaBudgetView();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}


if(sublevel>0){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+");,_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog("+id+");,_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=searchfrm name=searchfrm action="HrmSubCompanyDsp.jsp" method=post >
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=companyid value="<%=companyid%>">
 <input class=inputstyle type=hidden name=id value="<%=id%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){ %>
		<input type=button class="e8_btn_top" onclick="addSiblingSubCompany()" value="<%=SystemEnv.getHtmlLabelNames("82,17897",user.getLanguage())%>"></input>
		<input type=button class="e8_btn_top" onclick="openDialog('editSubCompany')" value="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>"></input>
		<%}if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){ %>
		<input type=button class="e8_btn_top" onclick="doCanceled()" value="<%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%>"></input>
		<%}else if(sublevel>0){ %>
		<input type=button class="e8_btn_top" onclick="doISCanceled()" value="<%=SystemEnv.getHtmlLabelName(22152,user.getLanguage())%>"></input>
		<%} %>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td>
	</tr>
</table>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<% 
	 HrmDeptFieldManager hfm = new HrmDeptFieldManager(4);
	 hfm.getCustomData(id);
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
  		//System.out.println("fieldid=="+fieldid+"fieldhtmltype=="+fieldhtmltype+"type=="+type+"fieldValue=="+fieldValue);
		if(fieldhtmltype == 3 ){
			fieldValue=hfm.getHtmlBrowserFieldvalue(user, dmlurl, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue , "0");
		}else{
 			fieldValue=hfm.getFieldvalue(user, dmlurl, Integer.parseInt(fieldid), fieldhtmltype, type, fieldValue, 0);
		}
			if("84".equals(fieldid)){
				if(user.getUID() != 1) continue;
				fieldValue = fieldValue.equals("0") ? "" : fieldValue;
			}
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(Integer.parseInt(fieldlabel),user.getLanguage())%></wea:item>  
	  <wea:item><%=fieldValue%></wea:item>
		<%} %>
		<%
		if(tmp==0){
			int resourceNum = 0;
			
			String sql = "";
			sql = "SELECT COUNT(*) FROM hrmresource WHERE subcompanyid1 = "+ id +" and ( status =0 or status = 1 or status = 2 or status = 3)";
			rs.executeSql(sql);
			if(rs.next()){
				resourceNum = rs.getInt(1);
			}
			//4:解聘 5:离职 6:退休 7:无效
			int resourceNum1 = 0;
			 sql = "SELECT COUNT(*) FROM hrmresource WHERE subcompanyid1 = "+ id +" and status in(4,5,6,7)";
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
 <script>
function submitData() {
 openDialog('editSubCompany');
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
      ajax.send("deptorsupid=<%=id%>&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	              //onBtnSearchClick();
	            }else{
	              if(ajax.responseText == 0){
	            		//分部下存在部门
	            		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82296, user.getLanguage())%>");
	            	}else if(ajax.responseText == 2){
	            		//分部下存在下级分部
	              	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82295, user.getLanguage())%>");
	              }
	            }
            }catch(e){
                return false;
            }
        }
     }
	 })
}

 function doISCanceled(){
 	 window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>", function(){
 	 		var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              //parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	              //onBtnSearchClick();
	            }
            }catch(e){
                return false;
            }
        }
     }
 	 });
 }
 </script>
</BODY>
</HTML>
