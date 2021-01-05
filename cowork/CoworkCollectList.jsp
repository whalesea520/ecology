
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET />
<script language="javascript" src="/cowork/js/coworkUtil_wev8.js"></script>
<script language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.mousewheel-3.0.4.pack_wev8.js"></script>
<script type="text/javascript" src="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/cowork/js/jquery.fancybox/fancybox/jquery.fancybox-1.3.4_wev8.css" media="screen" />
<link rel="stylesheet" href="/cowork/js/jquery.fancyboxstyle_wev8.css" />

<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(156,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(426,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	int menuIndex=0;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.weaver.submit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(129753,user.getLanguage())+",javascript:batchCancelCollect(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	menuIndex++;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String remark = Util.null2String(request.getParameter("remark"));
String coworkname = Util.null2String(request.getParameter("coworkname"));
String typeid = Util.null2String(request.getParameter("typeid"));

String datetype = Util.null2String(request.getParameter("datetype"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

String searchType = Util.null2String(request.getParameter("searchType"));

String backfields = "id,cid , coworkid,remark,coworkname,typename,typeid, floorNum,topdiscussid,createdate,discussdate";

String fromSql ="(select t1.id ,cc.id as cid, t1.remark ,t1.coworkid, t1.createdate,t1.topdiscussid,"+
	"(SELECT name FROM cowork_items WHERE id = t1.coworkid ) coworkName, "+
	"(SELECT typename FROM cowork_types WHERE id = (SELECT typeid FROM cowork_items WHERE id = t1.coworkid)) typename ,"+
	"(SELECT typeid FROM cowork_items WHERE id =   t1.coworkid) typeid ,floorNum,";
if ("oracle".equals(rs.getDBType())) {
    fromSql += " t1.createdate||' '||t1.createtime discussdate";
} else if ("sqlserver".equals(rs.getDBType())) {
    fromSql += " t1.createdate+' '+t1.createtime discussdate";
} else if ("mysql".equals(rs.getDBType())) {
    fromSql += " concat(t1.createdate, ' ', t1.createtime) discussdate";
}
fromSql +=" from cowork_discuss t1,cowork_collect cc where  t1.coworkid=cc.itemid and t1.id=cc.discussid and cc.userid="+user.getUID();
if(searchType.equals("approve")){//审批
	fromSql+= " and t1.approvalAtatus = 1";
}
fromSql +=") t";

String sqlWhere = "coworkid != 0 ";
if(!"".equals(remark)){
	sqlWhere += " and remark like '%"+remark+"%'";
}
if(!"".equals(coworkname)){
	sqlWhere += " and coworkname like '%"+coworkname+"%'";
}
if(!"".equals(typeid) && !"0".equals(typeid)){
	sqlWhere += " and typeid = '"+typeid+"'";
}


if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlWhere += " and createdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlWhere += " and createdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}

if("6".equals(datetype) && !"".equals(startdate)){
	sqlWhere += " and createdate >= '"+startdate+"'";
}

if("6".equals(datetype) && !"".equals(enddate)){
	sqlWhere += " and createdate <= '"+enddate+"'";
}

String orderby = "discussdate";
String tableString = " <table tabletype=\"checkbox\" pageId=\""+PageIdConst.Cowork_themeMonitor+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_themeMonitor,user.getUID(),PageIdConst.COWORK)+"\" >"+
                     " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getCoworkMonitorCheckbox\" />"+ 
       "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"cid\" sqlsortway=\"Desc\"/>"+
       "<head>"+
       "<col width=\"35%\"  text=\""+ SystemEnv.getHtmlLabelName(33368,user.getLanguage()) +"\" column=\"remark\" transmethod=\"weaver.general.CoworkTransMethod.formatContent\" pkey=\"remark+weaver.general.CoworkTransMethod.formatContent\"/>"+
       "<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(27519,user.getLanguage()) +"\" column=\"floorNum\" orderkey=\"floorNum\" otherpara='column:topdiscussid' transmethod=\"weaver.general.CoworkTransMethod.getFloorNum\" pkey=\"remark+weaver.general.CoworkTransMethod.getFloorNum\" "+
            " href=\"javascript:ViewCoworkDiscuss('{0}')\" linkkey=\"id\" linkvaluecolumn=\"id\" />"+ 
       "<col width=\"25%\"  text=\""+ SystemEnv.getHtmlLabelName(344,user.getLanguage()) +"\" column=\"coworkname\" orderkey=\"coworkname\" "+
       			" href=\"/cowork/ViewCoWork.jsp\" linkkey=\"id\" linkvaluecolumn=\"coworkid\" />"+ 
	   "<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(33867,user.getLanguage()) +"\" column=\"typename\" orderkey=\"typename\"/>"+ 
	   "<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(23066,user.getLanguage()) +"\" column=\"discussdate\" orderkey=\"discussdate\"/>"+
	   "</head>"+  
	    " <operates width=\"15%\">"+
        "     <popedom transmethod=\"weaver.general.CoworkTransMethod.getTypeOperates\"></popedom> "+
		"     <operate  href=\"javascript:batchCancelCollect()\"   text=\""+SystemEnv.getHtmlLabelName(129753,user.getLanguage())+"\"    target=\"_self\"  index=\"0\"/>"+
		" </operates>"+
	   "</table>";			
%>
</head>

<body>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
            <input type=button class="e8_btn_top" onclick="batchCancelCollect()" value="<%=SystemEnv.getHtmlLabelName(129753,user.getLanguage())%>"></input>
        
			<input type="text" class="searchInput" name="searchRemark" id="searchRemark"  value="<%=remark %>"/>
       		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id="weaver" name="weaver" action="/cowork/CoworkCollectList.jsp" method="post">
<input type="hidden" name="searchType" value="<%=searchType %>">
	<wea:layout type="4col" attributes="{'layoutTableId':'oTable1'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(83238,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<input type="text" id="remark" name="remark" value="<%=remark%>" style="width: 150px;"/>       
		        </wea:item> 
		        
		        <wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<input type="text" id="coworkname" name="coworkname" value="<%=coworkname%>" style="width: 150px;"/>       
		        </wea:item> 
		        
		        <wea:item><%=SystemEnv.getHtmlLabelName(33867,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<%
		        		rs.execute("select id , typename from cowork_types");
		        	%>
		        		<select id="typeid" name="typeid" style="width: 125px;">
		        				<option value = ""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			        	<%while(rs.next()){%>
			        		<option value="<%=rs.getString("id") %>" <%if(typeid.equals(rs.getString("id"))){ %>selected="selected"<%} %>>
			        			<%=rs.getString("typename") %>
			        		</option>
			        	<%} %>
		        		</select>
		        </wea:item> 
		        
		        
		        <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<span>
			        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
						  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
						  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
						  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
						  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
						  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
						  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
						</SELECT>
					</span>     
					
					<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
				        <button class="Calendar" style="height: 16px" type="button" onclick="getDate(startdatespan,startdate)" value="<%=startdate%>"></button>
						<span id="startdatespan"><%=startdate%></span>
						<input type="hidden" id="startdate" name="startdate">
						－
						<button class="Calendar" style="height: 16px" type="button" onclick="getDate(enddatespan,enddate)" value="<%=enddate%>"></button>
						<span id="enddatespan"><%=enddate%></span>
						<input type="hidden" id="enddate" name="enddate">
					</span>
		        </wea:item>
		     </wea:group>
		     <wea:group context="" attributes="{'Display':'none'}">
				<wea:item type="toolbar">
					<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
	</wea:layout>	        
</form>
</div>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_CoworkMine%>">	
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" />

<script type="text/javascript">
$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchRemark});
	jQuery("#hoverBtnSpan").hoverBtn();
	
	$(".discuss_content img").live("click",function(){
				var _init=$(this).attr("_init");
				if(_init!="1"){
					$(this).fancybox({
						'overlayShow'	: false,
						'titleShow':false,
						'transitionIn'	: 'elastic',
						'transitionOut'	: 'elastic',
						'type':'image'
					});
					$(this).attr("_init","1");
					$(this).click();
				}
	});
	
	if("<%=datetype%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
});
function searchRemark(){
	var searchRemark = jQuery("#searchRemark").val();
	jQuery("#remark").val(searchRemark);
	window.weaver.submit();
}

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

//打开楼层
function ViewCoworkDiscuss(id){
    diag=getCoworkDialog("楼层信息",600,480);
    diag.URL = "/cowork/ViewCoWorkDiscuss.jsp?discussids="+id;
    diag.show();
}

function getCoworkDialog(title,width,height){
            diag =new window.top.Dialog();
            diag.currentWindow = window; 
            diag.Modal = true;
            diag.Drag=true;
            diag.Width =width?width:680;
            diag.Height =height?height:420;
            diag.ShowButtonRow=false;
            diag.Title = title;
            diag.Left=($(window.top).width()-235-width)/2+235;
            return diag;
}
</script>


<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</html>
