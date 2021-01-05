<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="chk" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery1 = Util.null2String(request.getParameter("flowTitle"));
%>
<%
int[] ids = chk.getSubComByUserEditRightId(user.getUID(), "Album:Maint");

//如果系统未启用分权管理，而当前用户没有相册维护权限，则可查看分部调整为空
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
	detachable=rs.getInt("detachable");
}

if(detachable!=1){
	if(!HrmUserVarify.checkUserRight("Album:Maint", user)){
		ids=new int[0];
	}
}

String _ids = ",";
for(int i=0;i<ids.length;i++){
	_ids += ids[i] + ",";
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
//String titlename = "" + SystemEnv.getHtmlLabelName(20207,user.getLanguage());
String titlename = "" + SystemEnv.getHtmlLabelName(20290,user.getLanguage());
String needfav ="1";
String needhelp ="";

//批量设置空间权限
boolean batchEdit=user.getUID()==1;

%>

<html>
<head>
<title></title>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(batchEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelNames("33511",user.getLanguage())+",javascript:onBatchEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=weaver id=weaver method=post action="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
<%
if(batchEdit){
	%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("33511",user.getLanguage())%>" class="e8_btn_top" onclick="onBatchEdit();">
	<%
}
%>		
			<input type="text" class="searchInput" name="flowTitle" value="<%=nameQuery1 %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" ></div>


<% 
String sqlwhere=" WHERE a.supsubcomid=0  ";
if(!"".equals(nameQuery1)){
	sqlwhere+=" and a.subcompanyname like '%"+nameQuery1+"%' ";
}

String tabletype="none";
String backfields=" a.*,b.*,(convert(decimal(18,2),b.albumsize/(1000+0.0))) as totalsize,(convert(decimal(18,2),(b.albumSizeUsed/(1000+0.0)))) as usesize, (convert(decimal(18,2),(b.albumSize-b.albumSizeUsed)/(1000+0.0))) as remainsize, (case b.albumSize when 0 then 0 else (convert(decimal(18,2),(b.albumSizeUsed/(b.albumSize+0.0)*100))) end ) AS rate ";
if("oracle".equalsIgnoreCase(rs.getDBType())){
	backfields=" a.*,b.*,round(b.albumsize/(1000+0.0),2) as totalsize,round(b.albumSizeUsed/(1000+0.0),2) as usesize, round((b.albumSize-b.albumSizeUsed)/(1000+0.0),2) as remainsize, (case b.albumSize when 0 then 0 else round((b.albumSizeUsed/(b.albumSize+0.0)*100),2) end ) AS rate ";
}
String sqlform = " HrmSubcompany a LEFT JOIN AlbumSubcompany b ON a.id=b.subcompanyId  ";
String primarykey="a.id";
String orderby="a.supsubcomid,a.id";
String sumColumns="totalsize,usesize,remainsize";

//out.println("select "+backfields+" from "+sqlform+" "+sqlwhere+" order by "+orderby);

String tableString=""+
   "<table pageId=\""+PageIdConst.DOC_CREATERLIST+"\"  instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_CREATERLIST,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
   "<sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sumColumns=\""+sumColumns+"\" decimalFormat=\"%.2f|%.2f|%.2f\"  sqlform=\""+Util.toHtmlForSplitPage(sqlform)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"   sqlprimarykey=\""+primarykey+"\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
   "<head>"+							 
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyname\"  orderkey=\"subcompanyname\"  />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("84054",user.getLanguage())+"\" column=\"totalsize\" orderkey=\"totalsize\" />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("84055",user.getLanguage())+"\" column=\"usesize\" orderkey=\"usesize\" />"+
		 "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelNames("84056",user.getLanguage())+"\" column=\"remainsize\" orderkey=\"remainsize\" />"+
		 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelNames("20007",user.getLanguage())+"\" column=\"rate\" orderkey=\"rate\" showaspercent=\"true\" />"+
   "</head>";
   if(batchEdit){
	   tableString+=""+
			   "	<operates width=\"5%\">"+
			   "     <popedom  column='id'   ></popedom> "+	
			   "	<operate isalwaysshow=\"true\"  href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"	</operates>";
				
   }
   tableString+=""+
   "</table>";
%>
<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.DOC_CREATERLIST %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
</form>




<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout> 
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>

<script type="text/javascript">
function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

function onEdit(id){
	if(id){
		var url="/album/AlbumSizeBatchEdit.jsp?isdialog=1&subcompanyid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("84057",user.getLanguage())%>";
		openDialog(url,title,400,200);
	}
}
 
function onBatchEdit(){
	var url="/album/AlbumSizeBatchEdit.jsp?isdialog=1";
	var title="<%=SystemEnv.getHtmlLabelNames("84058",user.getLanguage())%>";
	openDialog(url,title,500,400,false,false);
}
</script>
</body>
</html>
