
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.common.Tools" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int companyid=Util.getIntValue(SubCompanyComInfo.getCompanyid(""+id),0);
String canceled = "";
String subcompanycode = "";
rs.executeSql("select canceled,subcompanycode from HrmSubCompany where id="+id);
if(rs.next()){
 canceled = rs.getString("canceled");
 subcompanycode = Util.null2String(rs.getString("subcompanycode"));
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int sublevel=0;

if(detachable==1){
    sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyAdd:Add",id);
    sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyEdit:Edit",id);
}else{
    if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
        sublevel=2;
    }
    if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
        sublevel=2;
    }
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,17897",user.getLanguage())+",javascript:addSiblingSubCompany();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelNames("82,17898",user.getLanguage())+",javascript:addChildSubCompany();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(sublevel>1 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelNames("33619",user.getLanguage())+",javascript:doBatchCancel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelNames("33620",user.getLanguage())+",javascript:doSubComBatchIsCancel();,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
}
}
String isDel = Util.null2String(request.getParameter("isDel"));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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

jQuery(document).ready(function(){
<%if(isDel.equals("1")){%>
try{
   parent.parent.jsReloadTree();
}catch(err){}
 <%}%>
});


var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	var url = "";
	dialog.Width = 800;
	dialog.Height = 500;
  if(cmd=="editSubCompany"){
  	url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyEdit&title=93,141&id="+id;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,141", user.getLanguage())%>";
	}else if(cmd=="addSiblingSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAdd&method=addSiblingSubCompany&title=82,17897&subcompanyid=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17897", user.getLanguage())%>";
	}else if(cmd=="addChildSubCompany"){
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmSubCompanyAdd&method=addChildSubCompany&title=82,17898&subcompanyid=<%=id%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,17898", user.getLanguage())%>";
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editSubCompany(id)
{
	openDialog("editSubCompany",id);
}

function addSiblingSubCompany()
{
	openDialog("addSiblingSubCompany");
}

function addChildSubCompany()
{
	openDialog("addChildSubCompany");
}

function checkHasDepartment(id){
	Validator.checkHasDepartment(id,checkHasDepartmentCallback) ;
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
		var idArr = id.split(",");
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
	for(var i=0;i<idArr.length;i++){
		Validator.checkHasDepartmentAndCompany(idArr[i],function checkHasDepartmentCallback(flag){
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
			}
		}) ;
	}
	
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"SubCompanyOperation.jsp?isdialog=1&operation=deletesubcompany&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
						try{
						   parent.parent.jsReloadTree();
						}catch(err){}
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
window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>",function(){
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
              _table.reLoad();
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
});
}

function doISCanceled(id){
window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>",function(){
var ajax=ajaxinit();
    ajax.open("POST", "HrmCanceledCheck.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("deptorsupid="+id+"&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
    ajax.onreadystatechange = function() {
      if (ajax.readyState == 4 && ajax.status == 200) {
          try{
            if(ajax.responseText == 1){
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
              //parent.leftframe.location.reload();
              _table.reLoad();
            }
          }catch(e){
              return false;
          }
      }
   }
});
}

//封存
function doBatchCancel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33930,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22153,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"HrmCanceledCheck.jsp?deptorsupid="+idArr[i]+"&userid=<%=user.getUID()%>&operation=subcompany",
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

//解封
function doSubComBatchIsCancel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33931,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22154,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"HrmCanceledCheck.jsp?deptorsupid="+idArr[i]+"&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany",
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

function openHrmComDetail(id){
	window.parent.location.href="/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp&id="+id;
}
</script>
</head>
<body>
<form action="HrmSubCompanyList.jsp" name="searchfrm" id="searchfrm">
<input name="id" type="hidden" value="<%=id %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){ %>
			<input type=button class="e8_btn_top" onclick="addSiblingSubCompany();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17897,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="addChildSubCompany();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17898,user.getLanguage())%>"></input>
			<%if(sublevel>1 && ("0".equals(canceled) || "".equals(canceled))){ %>
			<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<%}} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 <%
//分部简称	分部全称	分部编号	显示顺序	
String backfields = " id, subcompanyname, subcompanydesc, subcompanycode, showorder, canceled, (SELECT COUNT(*) FROM hrmresource WHERE subcompanyid1 = HrmSubCompany.id  and ( status =0 or status = 1 or status = 2 or status = 3)) resourcenum "; 
String fromSql  = " from HrmSubCompany ";
String sqlWhere = " where supsubcomid= "+id;
String subcomstr=SubCompanyComInfo.getRightSubCompany(user.getUID(),"HrmResourceAdd:Add",0);
if(subcomstr.length()>0) sqlWhere+=" and ("+Tools.getOracleSQLIn(subcomstr,"id")+")";
String orderby = " showorder " ;
String tableString = "";

//编辑    封存    日志
//操作字符串
String  operateString= "";

if(sublevel>0){
	operateString = "<operates width=\"20%\">";
	operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getSubcompanyListOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)+"\"></popedom> ";
				operateString+="     <operate href=\"javascript:editSubCompany();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
				 operateString+="     <operate href=\"javascript:doCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+"\" index=\"1\"/>";
					 operateString+="     <operate href=\"javascript:doISCanceled();\" text=\""+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+"\" index=\"2\"/>";
					 operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
					 operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"4\"/>";
			   operateString+="</operates>";	
}
 String tabletype="none";
 if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
 	tabletype = "checkbox";
 }
 
tableString =" <table pageId=\""+PageIdConst.HRM_SubCompanyList+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_SubCompanyList,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getSubCompanyCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+ 
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage()) + SystemEnv.getHtmlLabelName(399,user.getLanguage())+"\" column=\"id\" otherpara=\"column:subcompanyname+column:canceled\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmEditSubCompanyName1\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage()) + SystemEnv.getHtmlLabelName(15767,user.getLanguage())+"\" column=\"id\" orderkey=\"subcompanydesc\" otherpara=\"column:subcompanydesc+column:canceled\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmEditSubCompanyShortName1\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+ SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"subcompanycode\" orderkey=\"subcompanycode\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelNames("1831,1859",user.getLanguage())+"\" column=\"resourcenum\" orderkey=\"resourcenum\"/>"+
    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"showorder\" orderkey=\"showorder\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_SubCompanyList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  /> 
 </form> 
</body>
</html>
