<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

int crmid = Util.getIntValue(request.getParameter("crmid"),0);
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
AppDetachComInfo AppDetachComInfo = new AppDetachComInfo();
boolean canEidt = AppDetachComInfo.isCustomManager(""+user.getUID());
if(!canEidt&&user.getUID()==1)canEidt=true;
if(canEidt){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function add(id){
	window.location.href="/hrm/outinterface/outresourceAdd.jsp?customid=<%=crmid%>";
}

function edit(id){
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=outresourceEdit&id="+id);
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
				url:"outresourceOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
function editHrmResource(id)
{
	openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=outresourceView&id="+id);
}
</script>
</head>
<body>
<FORM name="frmMain" id=frmMain method=post action="outresourceList.jsp">
<input name="id" id="id" type="hidden" value="<%=crmid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(canEidt){ %>
			<input type=button class="e8_btn_top" onclick="add();"  value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();"  value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
		<%} %>	
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 <%
//姓名 分部 部门 手机号码 邮箱 登录名 安全级别 
String backfields = " a.id, a.lastname, c.subcompanyid, c.departmentid, a.mobile, a.email, a.loginid, a.seclevel,a.dsporder "; 
String fromSql  = " from hrmresource a, hrmresourceout b, hrmresourcevirtual c";
String sqlWhere = " where a.status in (0,1,2,3) and a.id = b.resourceid and a.id=c.resourceid " 
								+ " and b.customid ="+crmid;
String orderby = " a.dsporder " ;
String tableString = "";
//编辑   日志
//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+="     <operate href=\"javascript:edit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       operateString+="</operates>";	
 	      
String tabletype="checkbox";
if(canEidt){
	tabletype = "checkbox";
}
 	  		 
tableString =" <table pageId=\""+PageIdConst.HRM_ResourceListVirtual+"\" tabletype=\""+tabletype+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceListVirtual,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    operateString+
    "			<head>"+ 
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmEditHrmResourceName\" otherpara=\"column:id\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid\" transmethod=\"weaver.hrm.companyvirtual.SubCompanyVirtualComInfo.getSubCompanyname\" orderkey=\"subcompanyid\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" transmethod=\"weaver.hrm.companyvirtual.DepartmentVirtualComInfo.getDepartmentname\" orderkey=\"departmentid\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(22482,user.getLanguage())+"\" column=\"mobile\" orderkey=\"mobile\"/>"+
    "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(477,user.getLanguage())+"\" column=\"email\" orderkey=\"email\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(412,user.getLanguage())+"\" column=\"loginid\" orderkey=\"loginid\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\"/>"+
    "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"\" column=\"dsporder\" orderkey=\"dsporder\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceListVirtual %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  /> 
 </form> 
</body>
</html>