<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
	<!--QC 282498  [80][90]流程流转集成-新建流程接口部署窗口建议加【关闭】按钮 Start-->
	<script type="text/javascript">
        var parentWinTest = null;
        var dialogTest = null;
        try{
            parentWinTest = parent.parent.getParentWindow(parent);
            dialogTest = parent.parent.getDialog(parent);
        }catch(e){}
	</script>
	<!--QC 282498  [80][90]流程流转集成-新建流程接口部署窗口建议加【关闭】按钮 End-->
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32338 ,user.getLanguage());//"流程流转集成"
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//ArrayList pointArrayList = ActionXML.getPointArrayList();
//rs.execute("delete actionsetting where actionname is null or  actionname not in "+pointArrayList.toString().replace(" ","").replace("[","('").replace("]","')").replace(",","','"));

String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.null2String(request.getParameter("backto"));
if(!"".equals(backto))
	typename = backto;
String fromtype = Util.null2String(request.getParameter("fromtype"));
String namesimple = Util.null2String(request.getParameter("namesimple"));
String actionname = Util.null2String(request.getParameter("actionname"));
String formname = Util.null2String(request.getParameter("formname"));
String errormsg = Util.null2String(request.getParameter("errormsg"));

String sqlwhere = "where 1=1 ";
if(!"".equals(typename))
	sqlwhere += " and a.typename='"+typename+"'";
if(!"".equals(fromtype))
	sqlwhere += " and fromtype="+fromtype;
if(!"".equals(namesimple))
	sqlwhere += " and a.actionname like '%"+namesimple+"%'";
if(!"".equals(actionname))
	sqlwhere += " and a.actionname like '%"+actionname+"%'";
String tableString="";
if(!"".equals(formname))
{
	sqlwhere +=" and b.formname like '%"+formname+"%'";
}
ActionXML.initAction();
String backfields=" a.*,b.formname " ;
String perpage="10";
String sqlorderby = "fromtype,formid";

String fromSql=" ((select d.id,"+
				 "      d.dmlactionname as actionname,d.typename,"+
				 "      d.formid,"+
				 "      d.isbill,"+
				 "      d.datasourceid,"+
				 "      '1' as fromtype,"+
				 "      '"+SystemEnv.getHtmlLabelName(82986,user.getLanguage())+"' as fromtypename"+
				 " from formactionset d "+
		         " union all select s.id,"+
				 "       s.actionname,s.typename,"+
				 "       s.formid,"+
				 "       s.isbill,"+
				 "       '' as datasourceid,"+
				 "       '2' as fromtype,"+
				 "      '"+SystemEnv.getHtmlLabelName(82987,user.getLanguage())+"' as fromtypename"+
				 "  from wsformactionset s ";
if(rs.getDBType().equals("oracle"))
	fromSql += " union all select s.id,nvl(s.actionshowname,actionname) as actionname,typename,0 as formid,0 as isbill,'' as datasourceid,'3' as fromtype, '"+SystemEnv.getHtmlLabelName(82988,user.getLanguage())+"' as fromtypename ";
else
	fromSql += " union all select s.id,isnull(s.actionshowname,actionname) as actionname,typename,0 as formid,0 as isbill,'' as datasourceid,'3' as fromtype, '"+SystemEnv.getHtmlLabelName(82988,user.getLanguage())+"' as fromtypename ";

	fromSql += " from actionsetting s) a left outer  join (select id,formname,0 as isbill from workflow_formbase c union all select c.id,h.labelname as formname,1 as isbill from workflow_bill c ,htmllabelinfo h where c.namelabel=h.indexid and h.languageid="+user.getLanguage()+") b on a.formid=b.id and a.isbill=b.isbill) "; 
//out.println("select "+backfields+" from "+fromSql+" "+sqlwhere);
String PageConstId = "FormactionNewList_gxh";
tableString =  " <table instanceid=\"ListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >"; //QC277383  [80][90]流程流转集成-建议去掉流程接口注册页面中的check框，页面中并没有批量删除按钮，check框没有实际意义
tableString += " <checkboxpopedom    popedompara=\"column:id+column:fromtype+column:actionname\" showmethod=\"weaver.general.SplitPageTransmethod.getActionCheckBox\" otherpara=\"\"/>"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
         "       <head>"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195 ,user.getLanguage())+"\" column=\"actionname\" orderkey=\"actionname\" transmethod=\"weaver.general.SplitPageTransmethod.getDMLLink\" otherpara=\"column:fromtype+column:formid+column:isbill+column:actionname+column:id+"+typename+"\" target=\"_self\" />"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15451,user.getLanguage())+"\" column=\"formid\" orderkey=\"formid\" transmethod=\"weaver.general.SplitPageTransmethod.getFormMethod\" otherpara=\"column:isbill\" />"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(63 ,user.getLanguage())+"\" column=\"fromtypename\" orderkey=\"fromtypename\" />"+
		// "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(104 ,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.general.SplitPageTransmethod.getDMLDelete\"  otherpara=\"column:fromtype\" />"+
		 "           <col width=\"*\"  text=\""+SystemEnv.getHtmlLabelName(125608 ,user.getLanguage())+"\" column=\"id\"  transmethod=\"weaver.general.SplitPageTransmethod.getActionWorkflowInfo\" otherpara=\"column:fromtype+column:actionname\"/>"+
		 "       </head>"+
		 "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getActionPopedom\" otherpara=\"column:fromtype+column:actionname\"></popedom> "+
		 "     <operate href=\"javascript:editById1()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>"+
		 "     <operate href=\"javascript:editById2()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+
		 "     <operate href=\"javascript:editById3()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>"+
		 "     <operate href=\"javascript:doDeleteById1()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>"+
		 "     <operate href=\"javascript:doDeleteById2()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"4\"/>"+
		 "     <operate href=\"javascript:doDeleteById3()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"5\"/>"+     
		 "</operates>"+
         " </table>";
// RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(),_self} " ; QC277382 去除搜索菜单
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("intergration:formactionsetting", user))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(31691,user.getLanguage())+SystemEnv.getHtmlLabelName(82986,user.getLanguage())+",javascript:add(1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(31691,user.getLanguage())+SystemEnv.getHtmlLabelName(82987,user.getLanguage())+",javascript:add(2),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(31691,user.getLanguage())+SystemEnv.getHtmlLabelName(82988,user.getLanguage())+",javascript:add(3),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/integration/formactionlist.jsp" method="post" name="frmmain" id="datalist">
<input name="id" value="" type="hidden" />
<input type="hidden" id="operator" name="operator" value="">
<input type="hidden" id="typename" name="typename" value="<%=typename %>">
<input type="hidden" id="backto" name="backto" value="<%=typename %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:630px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82986,user.getLanguage())%>" class="e8_btn_top" onclick="add(1)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82987,user.getLanguage())%>" class="e8_btn_top" onclick="add(2)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82988,user.getLanguage())%>" class="e8_btn_top" onclick="add(3)"/>
			<input type="text" class="searchInput" name="namesimple" value="<%=actionname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;">&nbsp;</span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		    <wea:item>
				<input  type="text" name="actionname" value="<%=actionname%>">
			</wea:item>
		     <wea:item>
		     	<%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%>
		     </wea:item>
		    <wea:item>
		   		<input   type="text" name="formname" value="<%=formname%>">
		    </wea:item>
		    <wea:item>
		     	<%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%>
		     </wea:item>
		    <wea:item>
		   		<select name="fromtype" value="<%=fromtype%>">
		   			<option value=""></option>
		   			<option value=1 <%if(fromtype.equals("1")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(82986,user.getLanguage())%></option>
		   			<option value=2 <%if(fromtype.equals("2")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(82987,user.getLanguage())%></option>
		   			<option value=3 <%if(fromtype.equals("3")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(82988,user.getLanguage())%></option>
		   		</select>
		    </wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<!--QC:270808   [80][90]流程流转集成-调整高级搜索中按钮样式，以保持统一 e8_btn_submit-->
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="zd_btn_cancle" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>
<!--QC 282498  [80][90]流程流转集成-新建流程接口部署窗口建议加【关闭】按钮 Start-->
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
	<wea:item type="toolbar">
	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeDialog1();">
	</wea:item>
	</wea:group>
	</wea:layout>
	<script type="text/javascript">
        jQuery(document).ready(function(){
            resizeDialog(document);
        });
	</script>
</div>
<!--QC 282498  [80][90]流程流转集成-新建流程接口部署窗口建议加【关闭】按钮 End-->
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
//QC  288921  [补丁包测试][80][90]解决注册和编辑DML接口，点击保存后空白页面不消失的问题 start
var dialog = null;
 function closeDialog(){
	 if(dialog){
		 dialog.close();
	 }
 }
//QC  288921  [补丁包测试][80][90]解决注册和编辑DML接口，点击保存后空白页面不消失的问题 end
//QC 282498  [80][90]流程流转集成-新建流程接口部署窗口建议加【关闭】按钮 end
function closeDialog1(){
	if(dialogTest){
        dialogTest.close();
	}
}
function openDialog(url,title,width,height){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = width||750;
	dialog.Height = height||596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable=true;//允许最大化
	dialog.show();
}
function add(type)
{
	if(type=="1"){
		var url = "/integration/integrationTab.jsp?urlType=19&isdialog=1&fromintegration=1&typename=<%=typename%>&backto=<%=typename%>";
		var title = "<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82986,user.getLanguage())%>";
		openDialog(url,title);
		//document.location = "/workflow/dmlaction/FormActionSettingAdd.jsp?fromintegration=1&typename=<%=typename%>&backto=<%=typename%>";
	}else if(type=="2"){
		var url = "/integration/integrationTab.jsp?urlType=21&isdialog=1&fromintegration=1&operate=addws&webservicefrom=1&typename=<%=typename%>&backto=<%=typename%>";
		var title = "<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82987,user.getLanguage())%>";
		openDialog(url,title);
		//document.location = "/workflow/action/WsFormActionEditSet.jsp?fromintegration=1&operate=addws&webservicefrom=1&typename=<%=typename%>&backto=<%=typename%>";
	}else if(type=="3"){
		var url = "/integration/integrationTab.jsp?urlType=23&isdialog=1&fromintegration=1&operate=addws&webservicefrom=0&typename=<%=typename%>&backto=<%=typename%>";
		var title = "<%=SystemEnv.getHtmlLabelName(31691,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82988,user.getLanguage())%>";
		openDialog(url,title);
		//document.location = "/servicesetting/actionsettingnew.jsp?fromintegration=1&operate=addws&webservicefrom=0&typename=<%=typename%>&backto=<%=typename%>";
	}
}
function doDeleteById1(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		var url = "/workflow/dmlaction/FormActionSettingOperation.jsp?typename=<%=typename%>&backto=<%=typename%>&fromintegration=1&actionid="+id+"&operate=delete";
		document.location = url;
	}, function () {}, 320, 90);	
}
function editById1(id)
{
	if(id=="") return ;
	var url = "/integration/integrationTab.jsp?isdialog=1&urlType=20&typename=<%=typename%>&backto=<%=typename%>&fromintegration=1&actionid="+id;
	var title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82986,user.getLanguage())%>";
	openDialog(url,title);
}
function doDeleteById2(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		var url = "/workflow/action/WsFormActionEditOperation.jsp?typename=<%=typename%>&backto=<%=typename%>&fromintegration=1&actionid="+id+"&operate=delete";
		document.location = url;
	}, function () {}, 320, 90);	
}
function editById2(id)
{
	if(id=="") return ;
	var url = "/integration/integrationTab.jsp?isdialog=1&urlType=22&typename=<%=typename%>&backto=<%=typename%>&fromintegration=1&actionid="+id+"&operate=editws";
	var title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82987,user.getLanguage())%>";
	openDialog(url,title);
}
function doDeleteById3(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		var url = "/servicesetting/XMLFileOperation.jsp?typename=<%=typename%>&backto=<%=typename%>&fromintegration=1&actionid="+id+"&operation=action&method=deletesingle";
		document.location = url;
	}, function () {}, 320, 90);	
}
function editById3(id)
{
	if(id=="") return ;
	var url = "/integration/integrationTab.jsp?isdialog=1&urlType=24&typename=<%=typename%>&backto=<%=typename%>&fromintegration=1&actionid="+id;
	var title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(82988,user.getLanguage())%>";
	openDialog(url,title);
}
function resetCondtion()
{
	frmmain.actionname.value = "";
	frmmain.formname.value = "";
	frmmain.namesimple.value = "";
	frmmain.fromtype.value = "";
	jQuery(frmmain.fromtype).selectbox("detach");
	jQuery(frmmain.fromtype).selectbox();
}
jQuery(document).ready(function () {
	  if(!dialogTest)$("#zDialog_div_bottom").css("display","none");   //QC 282498  [80][90]流程流转集成-新建流程接口部署窗口建议加【关闭】按钮 end
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
	<%if("1".equals(errormsg)){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82989,user.getLanguage())%>!");
		return ;
	<%}%>
});
function doRefresh()
{
	//document.frmmain.action = "/integration/formactionlist.jsp?typename=<%=typename%>&backto=<%=typename%>";
	//$("#datalist").submit(); 
	var actionname=$("input[name='namesimple']",parent.document).val();
	$("input[name='actionname']").val(actionname);
	window.location="/integration/formactionlist.jsp?typename=<%=typename%>&backto=<%=typename%>&actionname="+actionname;
}
</script>
