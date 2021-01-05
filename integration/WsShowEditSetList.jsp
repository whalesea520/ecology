<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:datashowsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32303 ,user.getLanguage());//"数据展现集成";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

String typename = Util.null2String(request.getParameter("typename"));
if(HrmUserVarify.checkUserRight("intergration:datashowsetting", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del1(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

String showname = Util.null2String(request.getParameter("showname"));
String backto = Util.null2String(request.getParameter("backto"));
String errormsg = Util.null2String(request.getParameter("errormsg"));
String thisServiceId = Util.null2String(request.getParameter("thisServiceId"));
List dsPointArrayList = DataSourceXML.getPointArrayList();
String dsOptions = "";
for(int i=0;i<dsPointArrayList.size();i++){
    String pointid = (String)dsPointArrayList.get(i);
    //out.println("thisServiceId : "+thisServiceId+" pointid : "+pointid);
    String selected = "";
    if(thisServiceId.equals(pointid)){
    	selected = "selected";
    }
    dsOptions += "<option value='"+pointid+"' "+selected+">"+pointid+"</option>";
}

if(!"".equals(backto))
	typename = backto;
String namesimple = Util.null2String(request.getParameter("namesimple"));
String name = Util.null2String(request.getParameter("name"));
String showclass = Util.null2String(request.getParameter("showclass"));
String showtype = Util.null2String(request.getParameter("showtype"));
String sqlwhere = "where 1=1 ";
if(!"".equals(typename))
	sqlwhere += " and a.typename='"+typename+"'";
if(!"".equals(name))
	sqlwhere += " and a.name like '%"+name+"%'";
/*if(!"".equals(namesimple))
	sqlwhere += " and a.name like '%"+namesimple+"%'";*/
if(!"".equals(showname))
	sqlwhere += " and a.showname like '%"+showname+"%'";
String tableString="";
if(!"".equals(showclass))
{	
	sqlwhere +=" and a.showclass like '%"+showclass+"%'";
}
if(!"".equals(thisServiceId))
{	
	sqlwhere +=" and a.datasourceid = 'datasource."+thisServiceId+"'";
}
if(!"".equals(showtype))
{	
	sqlwhere +=" and a.showtype like '%"+showtype+"%'";
}
String backfields=" a.*,' ' as nullcolumn " ;
String perpage="10";
String PageConstId = "WsShowEditSetList_gxh";
String fromSql=" datashowset a "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >";
tableString += " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.SplitPageTransmethod.getWsShowEditCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"a.id\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
         "       <head>"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(84 ,user.getLanguage())+"\" column=\"id\" orderkey=\"a.id\" transmethod=\"weaver.general.SplitPageTransmethod.getWsShowTitle\" otherpara=\"column:showname+column:browserfrom+"+typename+"\" />"+
         "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(195 ,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
		 "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(32305 ,user.getLanguage())+"\" column=\"showclass\" orderkey=\"showclass\" transmethod=\"weaver.general.SplitPageTransmethod.getShowClass\" otherpara=\""+user.getLanguage()+"\" />"+
		 "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(23130 ,user.getLanguage())+"\" column=\"showtype\" orderkey=\"showtype\" transmethod=\"weaver.general.SplitPageTransmethod.getShowType\" otherpara=\""+user.getLanguage()+"\" />"+
		 "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(28006 ,user.getLanguage())+"\" column=\"datafrom\" orderkey=\"datafrom\" transmethod=\"weaver.general.SplitPageTransmethod.getWsShowEditDataFrom\" otherpara=\""+user.getLanguage()+"\" />"+
		 "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16208 ,user.getLanguage())+"\" column=\"detailpageurl\" />"+
		 "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(32325 ,user.getLanguage())+"\" column=\"showname\"  transmethod=\"weaver.general.SplitPageTransmethod.getUsedWorkflow\" otherpara=\"column:showclass+column:showtype\"/>"+
         "       </head>"+
         "<operates width=\"20%\">"+
         " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getWsShowEditPopedom\" ></popedom> "+
		 "     <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>"+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
		 "</operates>"+
         " </table>";

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/integration/WsShowEditSetList.jsp" method="post" name="frmmain" id="datalist">
<input name="id" value="" type="hidden" />
<input type="hidden" id="operator" name="operator" value="">
<input name="typename" value="<%=typename %>" type="hidden" />
<input name="backto" value="<%=typename %>" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="del1()"/>
			<input type="text" class="searchInput" name="namesimple" value="<%=name%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(32301,user.getLanguage())%></span> <!-- 数据展示集成列表 -->
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		    <wea:item>
				<input type="text" name="showname" style='width:120px!important;' value="<%=showname%>">
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		    <wea:item>
				<input type="text" name="name" style='width:120px!important;' value="<%=name%>">
			</wea:item>
		    <wea:item>
		     	<%=SystemEnv.getHtmlLabelName(32305,user.getLanguage())%><!-- 展现类型 -->
		    </wea:item>
		    <wea:item>
		   		<SELECT class=InputStyle  id="showclass"  name="showclass" style='width:120px!important;'>   
		   			<option value=""></option> 
					<option value="1" <%if(Util.getIntValue(showclass,0)==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32306,user.getLanguage())%></option> <!-- 浏览框 -->
					<option value="2" <%if(Util.getIntValue(showclass,0)==2)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32307,user.getLanguage())%></option> <!-- 查询页面 -->
				</SELECT>
		    </wea:item>
		    <wea:item>
		     	<%=SystemEnv.getHtmlLabelName(23130,user.getLanguage())%><!-- 展现方式 -->
		    </wea:item>
		    <wea:item attributes="{'colspan':'3'}">
		   		<SELECT class=InputStyle id="showtype" name="showtype" style='width:120px!important;'>   
		   			<option value=""></option> 
					<option value="1" <%if(Util.getIntValue(showtype,0)==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(19525,user.getLanguage())%></option> <!-- 列表式 -->
					<option value="2" <%if(Util.getIntValue(showtype,0)==2)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32308,user.getLanguage())%></option><!-- 树形 -->
					<option value="3" <%if(Util.getIntValue(showtype,0)==3)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32309,user.getLanguage())%></option><!-- 自定义页面 -->
				</SELECT>
		    </wea:item>
		    <wea:item>
		     	<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><!-- 数据源 -->
		    </wea:item>
		    <wea:item attributes="{'colspan':'3'}">
				<select class=InputStyle id="thisServiceId" name="thisServiceId" style='width:120px!important;'>
				    <option></option>
					<%=dsOptions%>
				</select>
		    </wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<!--QC:270809   [80][90]数据展现集成-调整高级搜索中按钮样式，以保持统一 e8_btn_submit -->
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
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
	<%if("1".equals(errormsg)){%>
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83574,user.getLanguage())%>");
		return ;
	<%}%>
});

var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
	}
}

function openDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = 750;
	dialog.Height = 596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable=true;//允许最大化
	dialog.show();
}


function doEditById(id)
{
	if(id=="") return ;
	var url = "/integration/WsShowEditSetTab.jsp?urlType=2&isdialog=1&backto=<%=typename%>&id="+id;
	var title = "<%=SystemEnv.getHtmlLabelNames("93,32303",user.getLanguage())%>";
	openDialog(url,title);
}

function doDeleteById(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			document.frmmain.action = "/integration/WsShowEditSetOperation.jsp";
			document.frmmain.id.value = id;
			document.frmmain.operator.value = "delete";
			document.frmmain.submit();
	}, function () {}, 320, 90);
}
function resetCondtion()
{
	frmmain.name.value = "";
	frmmain.showname.value = "";
	frmmain.showclass.value = "";
	jQuery(frmmain.showclass).selectbox("detach");
	jQuery(frmmain.showclass).selectbox();
	frmmain.thisServiceId.value = "";
	jQuery(frmmain.thisServiceId).selectbox("detach");
	jQuery(frmmain.thisServiceId).selectbox();
	frmmain.showtype.value = "";
	jQuery(frmmain.showtype).selectbox("detach");
	jQuery(frmmain.showtype).selectbox();
	frmmain.namesimple.value = "";
}
function doRefresh()
{
	//document.frmmain.action = "/integration/WsShowEditSetList.jsp?typename=<%=typename%>";
	//$("#datalist").submit(); 
	var name=$("input[name='namesimple']",parent.document).val();
	$("input[name='name']").val(name);
	window.location="/integration/WsShowEditSetList.jsp?typename=<%=typename%>&name="+name;
}
function add()
{
	var url = "/integration/WsShowEditSetTab.jsp?urlType=1&isdialog=1&typename=<%=typename%>&backto=<%=typename%>";
	var title = "<%=SystemEnv.getHtmlLabelNames("365,32303",user.getLanguage())%>";
	openDialog(url,title);
}

function del1()
{
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")
    {
       	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return ;
    }
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			document.frmmain.action = "/integration/WsShowEditSetOperation.jsp";
			document.frmmain.id.value = ids;
			document.frmmain.operator.value = "delete";
			document.frmmain.submit();
	}, function () {}, 320, 90);
}
</script>
