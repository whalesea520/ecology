
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

String cmd = Util.null2String(request.getParameter("cmd"));
String id = Util.null2String(request.getParameter("id"),"0");
String supdepid = DepartmentVirtualComInfo.getDepartmentsupdepid(id);
String subcompanyid = id;
if(!cmd.equals("subcompany")){
	subcompanyid = DepartmentVirtualComInfo.getSubcompanyid1(id);
}
String companyid = SubCompanyVirtualComInfo.getCompanyid(subcompanyid);

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(cmd.equals("subcompany")){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,124",user.getLanguage())+",javascript:addDepartment();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,17899",user.getLanguage())+",javascript:addSiblingDepartment();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,17587",user.getLanguage())+",javascript:addChildDepartment();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
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

function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	if(id==null)id="";
	var url = "";
	dialog.Width = 600;
	dialog.Height = 260;
  if(cmd=="editDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentEditVirtual&id="+id+"&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,27511", user.getLanguage())%>";
		dialog.Height = 369;
	}else if(cmd=="addDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAddVirtual&subcompanyid=<%=subcompanyid%>"+"&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,27511", user.getLanguage())%>";
		dialog.Height = 369;
	}else if(cmd=="addSiblingDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAddVirtual&method=addSiblingDepartment&isdialog=1&id="+id+"&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17899", user.getLanguage())%>";
		dialog.Height = 369;
	}else if(cmd=="addChildDepartment"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmDepartmentAddVirtual&method=addChildDepartment&isdialog=1&id="+id+"&virtualtype=<%=companyid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17587", user.getLanguage())%>";
		dialog.Height = 369;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function addHrmResource(id){
 	window.parent.parent.location.href="/hrm/HrmTab.jsp?_fromURL=HrmResourceAdd&departmentid="+id;
}

function editDepartment(id)
{
	openDialog('editDepartment',id);
}

function addDepartment()
{
	openDialog('addDepartment','<%=id%>');
}

function addSiblingDepartment()
{
	openDialog('addSiblingDepartment','<%=id%>');
}

function addChildDepartment()
{
	openDialog('addChildDepartment','<%=id%>');
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"DepartmentOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=414 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=414")%>";
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
<body>
<FORM name="searchfrm" id="searchfrm" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;vertical-align: middle;">
			<%if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)){ %>
				<%if(cmd.equals("subcompany")){ %>
				<input type=button class="e8_btn_top" onclick="openDialog('addDepartment','<%=id %>')" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"></input>
				<%}else{ %>
				<input type=button class="e8_btn_top" onclick="openDialog('addSiblingDepartment','<%=id %>')" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17899,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="openDialog('addChildDepartment','<%=id %>')" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17587,user.getLanguage())%>"></input>
				<%} %>
				<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
		  <%} %>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 <%
//部门简称	部门全称	部门编号	显示顺序	
String backfields = " id, departmentmark, departmentname, departmentcode, showorder, canceled "; 
String fromSql  = " from HrmDepartmentVirtual ";
String sqlWhere = " where 1= 1 ";
String orderby = " showorder " ;
String tableString = "";

if(cmd.equals("subcompany"))
{
	//分部下的部门
	sqlWhere += " and subcompanyid1="+id;
}
else if(cmd.equals("department"))
{
	//下级部门
	sqlWhere += " and supdepid="+id;
}
else
{
	//错误的参数
	sqlWhere += "1=2";
}

//编辑    封存    日志
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getDepartmentVirtualOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmDepartmentEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user)+":"+HrmUserVarify.checkUserRight("HrmDepartment:log", user)+"\"></popedom> ";
 	       operateString+="     <operate href=\"javascript:editDepartment();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" index=\"1\"/>";
	 	 		 operateString+="     <operate href=\"javascript:doISCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" index=\"2\"/>";
	 	 		 operateString+="    <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
 	       operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"4\"/>";
 	       operateString+="</operates>";	
 String tabletype="checkbox";
 if(HrmUserVarify.checkUserRight("HrmDepartmentEdit:Edit", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_DepartmentListVirtual+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_DepartmentListVirtual,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getDepartmentVirtualCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+ 
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(32107,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmDepartmentShortName1\" otherpara=\"column:departmentmark+column:canceled\"/>"+
    "				<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage()) + SystemEnv.getHtmlLabelName(15767,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmDepartmentName1\"  otherpara=\"column:departmentname+column:canceled\" orderkey=\"departmentmark\"/>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+ SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"departmentcode\" orderkey=\"departmentcode\"/>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_DepartmentListVirtual %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
 </form> 
</body>
<script type="text/javascript">
function openHrmDepDetail(deptid){
	window.parent.location.href="/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDspVirtual&id="+deptid;
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

function doCanceled(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153,user.getLanguage())%>",function(){
		var ajax=ajaxinit();
    ajax.open("POST", "HrmCanceledCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("deptorsupid="+id+"&userid=<%=user.getUID()%>");
    ajax.onreadystatechange = function() {
      if (ajax.readyState == 4 && ajax.status == 200) {
          try{
            if(ajax.responseText == 1){
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
              onBtnSearchClick();
              //parent.leftframe.location.reload();
              //window.location.href = "HrmDepartmentDsp.jsp?id="+id;
            }else{
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22157, user.getLanguage())%>");
            }
          }catch(e){
              return false;
          }
      }
   }
	});
}

function doISCanceled(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22154,user.getLanguage())%>",function(){
		var ajax=ajaxinit();
    ajax.open("POST", "HrmCanceledCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("deptorsupid="+id+"&cancelFlag=1&userid=<%=user.getUID()%>");
    ajax.onreadystatechange = function() {
      if (ajax.readyState == 4 && ajax.status == 200) {
          try{
            if(ajax.responseText == 1){
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
              onBtnSearchClick();
              //parent.leftframe.location.reload();
              //window.location.href = "HrmDepartmentDsp.jsp?id="+id;
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
</html>
