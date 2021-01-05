<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String id = ""+Util.getIntValue(request.getParameter("id"),0);
String to = Util.null2String(request.getParameter("to"));
String typeID = "0";

//只有系统管理员和分权管理员可以操作此界面功能。即当前登陆用户id必须存在于表hrmresource表中。
int userid=user.getUID();
String sqlUid = "select count(*) cnt from HrmResourceManager where id="+userid;
RecordSet.executeSql(sqlUid);
RecordSet.next();
if(RecordSet.getInt("cnt") <= 0 && !HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){
   response.sendRedirect("/notice/noright.jsp");	
   return;
}
%>
<script language=javascript>
var common = new MFCommon();
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
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
				url:"sysadminOperation.jsp?isdialog=1&method=del&id="+idArr[i],
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

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=sysadminAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=sysadminEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(1507,user.getLanguage())%>";
	}
	dialog.Width = 600;
	dialog.Height = 403;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function doSet(id){
	common.showDialog("/hrm/HrmDialogTab.jsp?_fromURL=sysadminSet&id="+id, "<%=SystemEnv.getHtmlLabelNames("1507,32496",user.getLanguage())%>");
}
</script>
</head>
<%


String qname = Util.null2String(request.getParameter("qname"));

boolean isoracle = (rs.getDBType()).equals("oracle") ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31978, user.getLanguage());
String needfav ="1";
String needhelp ="";


int rowsum = 0;
String loginidsForCompare = ",";
String sql = "select * from HrmResourceManager where 1=1 order by id asc ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
    //rowsum++;
    String loginid = RecordSet.getString("loginid");
    //loginidsForCompare += loginid.toUpperCase()+",";
    loginidsForCompare += loginid+",";
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id="frmMain" name="frmMain" action="sysadminEditBatch.jsp" method="post" >

	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="openDialog()"/><!-- 添加 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="doDel()"/><!-- 批量删除 -->
				<input type="text" class="searchInput" id="qname" name="qname" value="<%=qname %>"/>
				<!-- 
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
				 --><!-- 高级搜索 -->
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

	<input type="hidden" name="method" value="MagazineUpdate"/>
	<input type="hidden" name="id" value="<%=id%>"/>
	<input type="hidden" name="typeID" value="<%=typeID%>"/>
	<input type="hidden" name="tableMax" value="0"/>
	<input type="hidden" name="to" id="to" value="<%=to%>">

<%
String pageId = PageIdConst.Hrm_sysadminEditBatchTable;
int pagesize = Util.getIntValue(PageIdConst.getPageSize(pageId, user.getUID(), PageIdConst.HRM), 10);

String backfields = "a.*, 'C3***0D_C0***4B' password2";
String sqlform = " from HrmResourceManager a ";
String sqlwhere = " (a.creator='"+user.getUID()+ "' or a.id='"+user.getUID()+"') ";
if(!qname.equals("")){
	sqlwhere += " and (a.loginid like '%"+StringEscapeUtils.escapeSql(qname)+"%' or a.lastname like '%"+StringEscapeUtils.escapeSql(qname)+"%' )";
}
String sqlorderby = "a.id";
String sqlprimarykey = "a.id";
String  operateString= "";

operateString = "<operates width=\"20%\">";
operateString+=" <popedom transmethod=\"weaver.hrm.HrmTransMethod.getDeleteFenQuanOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmSpecialityEdit:Edit", user)+"\" otherpara2=\""+HrmUserVarify.checkUserRight("HrmSpecialityEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("HrmSpeciality:log", user)+":"+HrmUserVarify.checkUserRight("HrmSpecialityAdd:add", user)+"\"></popedom> ";
operateString+="     <operate href=\"javascript:doSet();\" text=\""+SystemEnv.getHtmlLabelName(32496,user.getLanguage())+"\" index=\"0\"/>";
operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"1\"/>";
operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>";
operateString+="</operates>";	
 
String tableString=""+
	"<table pageId=\""+pageId+"\"  pagesize=\""+pagesize+"\" tabletype=\"checkbox\">"+
	" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getFenQuanCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" "+
			" sqlorderby=\""+Util.toHtmlForSplitPage(sqlorderby)+"\" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqldistinct=\"true\" />"+
	    operateString+
			"<head>"+							 
			"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("1507,195", user.getLanguage())+"\" transmethod=\"weaver.hrm.HrmTransMethod.getSysAdminName\" column=\"lastname\" otherpara=\"column:id\" />"+//管理员名称
			"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("1507,20970", user.getLanguage())+"\"  column=\"loginid\" />"+//管理员账号
			//"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(409,user.getLanguage())+"\" column=\"password2\"/>"+//密码
			"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("20970,85", user.getLanguage())+"\" column=\"description\"/>"+//账号说明
			//"<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelNames("633,141", user.getLanguage())+"\" column=\"subcompanyids\""+
			//	" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubcompanynames\"/>"+//管理分部
		"</head>"+
	"</table>";
%> 
	<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"/>
	<input type="hidden" name="pageId" _showCol=false id="pageId" value="<%= pageId %>"/>
 </form>
</BODY>
</HTML>
