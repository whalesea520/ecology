<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String companyname = CompanyComInfo.getCompanyname(""+id);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage())+":"+companyname;
String needfav ="1";
String needhelp =""; 
boolean canEdit = false;
boolean canlinkbudget = HrmUserVarify.checkUserRight("SubBudget:Maint", user);
boolean canlinkexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user);

String sqlwhere = "";
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}

if(perpage<=1 )	perpage=10;
	String showTitle = "";

 	showTitle = Util.toHtmlMode(CompanyComInfo.getCompanyname(id+""));

%>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(showTitle.length()>0){%>
 parent.setTabObjName('<%=showTitle%>')
 <%}%>
});
</script>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	parent.parent.jsReloadTree();
	jQuery("#searchfrm").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function setID(id){
	jQuery("#id").val(id);
}

function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	if(id==null)id="";
	var url = "";
	dialog.Width = 600;
	dialog.Height = 260;
	if(cmd=="edit"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCompanyEdit&id=<%=id%>";
		dialog.Height = 239;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("26473,140", user.getLanguage())%>";
	}else if(cmd=="addSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAdd&title=82,141&companyid=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,141", user.getLanguage())%>";
		dialog.Height = 420;
	}else if(cmd=="addCompanyVirtual"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCompanyAddVirtual";
		dialog.Width = 500;
		dialog.Height = 239;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,34069", user.getLanguage())%>";
	}else if(cmd=="importexcel"){
		url = "/hrm/HrmTab.jsp?_fromURL=HrmImport";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("17887", user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 600;
	}else if(cmd=="companyexcel"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmResourceImport&importtype=company&title=125432";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("125432", user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height = 600;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function importResource(){
	openDialog('importexcel',null)
}

function importCompany(){
	openDialog('companyexcel',null)
}

function editCompany(id)
{
	openDialog("edit",id);
}

function addCompanyVirtual()
{
	openDialog("addCompanyVirtual");
}

function addSubCompany(id)
{
	openDialog("addSubCompany",id);
}


function onLogCom(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=10 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=10")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function onLogSubCom(id){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
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

function jsFnaExpenseDetail(){
	window.open("/fna/report/expense/FnaExpenseDetail.jsp?organizationid=<%=id%>&organizationtype=0");
}

function jsFnaBudgetView(){
	window.open("/fna/budget/FnaBudgetView.jsp?organizationid=<%=id%>&organizationtype=0");
}
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:editCompany(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
    if(canlinkexpense){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(428,user.getLanguage())+",javascript:jsFnaExpenseDetail(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    }
    
    if( canlinkbudget ){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(386,user.getLanguage())+",javascript:jsFnaBudgetView(),_blank} " ;
    RCMenuHeight += RCMenuHeightStep ;
    }
if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)){

if(rs.getDBType().equals("db2")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLogCom("+id+"),_self} " ;
}
else{

RCMenu += "{"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLogCom("+id+"),_self} " ;
}

RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())+",javascript:addSubCompany(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
	//新建虚拟总部
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,34069",user.getLanguage())+",javascript:addCompanyVirtual(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)){
    if(rs.getDBType().equals("db2")){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLogSubCom("+id+"),_self} " ;

    }else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLogSubCom("+id+"),_self}" ;
    }
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(17887,user.getLanguage())+",javascript:importResource();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(125523,user.getLanguage())+",javascript:importCompany();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name="searchfrm" id="searchfrm" method=post >
	<input class=inputStyle type=hidden name="id" value=<%=id%>> 
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){%>
				<input type=button class="e8_btn_top" onclick="addSubCompany();" value="<%=SystemEnv.getHtmlLabelNames("82,141", user.getLanguage())%>"></input>
			<%}%>
				<%if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){ %>
					<input type=button class="e8_btn_top" onclick="openDialog('edit');" value="<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%>"></input>
					<input type=button class="e8_btn_top" onclick="openDialog('importexcel');" value="<%=SystemEnv.getHtmlLabelName(17887, user.getLanguage())%>"></input>
				<%} %>
				<%if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){%>
				<input type=button class="e8_btn_top" onclick="openDialog('companyexcel');" value="<%=SystemEnv.getHtmlLabelName(125523, user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="addCompanyVirtual();" value="<%=SystemEnv.getHtmlLabelNames("82,34069", user.getLanguage())%>"></input>
				<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"  class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<%
	  String sql = "select * from HrmCompany where id = "+ id;
	  rs.executeSql(sql);
	  if(rs.next()){
		%>    
	    <wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
	    <wea:item><%=rs.getString("companyname")%></wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
	    <wea:item><%=rs.getString("companydesc")%></wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15768,user.getLanguage())%></wea:item>
	    <wea:item><%=rs.getString("companyweb")%></wea:item>      
		<%}%>  
		</wea:group>
	</wea:layout>
 </form>
</BODY>
<script type="text/javascript">
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

function doCanceled(id){
  if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
  var ajax=ajaxinit();
    ajax.open("POST", "HrmCanceledCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("deptorsupid="+id+"&userid=<%=user.getUID()%>&operation=subcompany");
    ajax.onreadystatechange = function() {
      if (ajax.readyState == 4 && ajax.status == 200) {
          try{
            if(ajax.responseText == 1){
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
              //parent.leftframe.location.reload();
              //window.location.href = "HrmSubCompany.jsp";
              onBtnSearchClick();
            }else{
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22253, user.getLanguage())%>");
            }
          }catch(e){
              return false;
          }
      }
   }
}
}

function doISCanceled(id){
 if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
  var ajax=ajaxinit();
    ajax.open("POST", "HrmCanceledCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("deptorsupid="+id+"&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
    ajax.onreadystatechange = function() {
      if (ajax.readyState == 4 && ajax.status == 200) {
          try{
            if(ajax.responseText == 1){
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
              onBtnSearchClick();
              //parent.leftframe.location.reload();
              //window.location.href = "HrmCompanyDsp.jsp";
            } else {
               window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24298, user.getLanguage())%>");
               return;
            }
          }catch(e){
              return false;
          }
      }
   }
 }
}
</script>
</HTML>
