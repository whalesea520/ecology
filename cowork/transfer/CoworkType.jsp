
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<%@ page import="java.sql.Timestamp" %>

<HTML><HEAD>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>

<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";

String fromid=Util.null2String(request.getParameter("fromid"));
String toid=Util.null2String(request.getParameter("toid"));
String _type = Util.null2String(request.getParameter("type"));
String _fromURL = Util.null2String(request.getParameter("_fromURL"));
String isHidden = Util.null2String(request.getParameter("isHidden"),"false");
String selectedstrs = Util.null2String(request.getParameter("idStr"));
String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
String oldJson = jsonSql;
jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");

int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);

String typename=Util.null2String(request.getParameter("typename"));
String departmentid=Util.null2String(request.getParameter("departmentid"));
departmentid = departmentid.equals("all")?"":departmentid;


String tableString = "";
int perpage=10;                                 
String backfields = " id,typename,departmentid ";
String fromSql  = " cowork_types ";
String sqlWhere = " 1=1 ";
String orderby = " id ";

if(!typename.equals(""))
	sqlWhere += " and typename like '%"+typename+"%' ";
if(!departmentid.equals(""))
	sqlWhere += " and departmentid="+departmentid;

String toid_str = ","+toid+",";
String tablename = "";
int sharetype = 0;
if(_fromURL.toUpperCase().contains("T182") 
		||_fromURL.toUpperCase().contains("C172")
		||_fromURL.toUpperCase().contains("D151")){//协作创建权限转移、复制、删除【人员】
	tablename = "cotype_sharemembers";
	sharetype = 1;
}
if(_fromURL.toUpperCase().contains("T231")
		||_fromURL.toUpperCase().contains("C251")
		||_fromURL.toUpperCase().contains("D231")){//协作创建权限转移、复制、删除【部门】
	tablename = "cotype_sharemembers";
	sharetype = 2;
}
if(_fromURL.toUpperCase().contains("T331")
		||_fromURL.toUpperCase().contains("C351")
		||_fromURL.toUpperCase().contains("D331")){//协作创建权限转移、复制、删除【分部】
	tablename = "cotype_sharemembers";
	sharetype = 3;
}
if(_fromURL.toUpperCase().contains("T421")
		||_fromURL.toUpperCase().contains("C441")
		||_fromURL.toUpperCase().contains("D421")){//协作创建权限转移、复制、删除【角色】
	tablename = "cotype_sharemembers";
	sharetype = 4;
}
if(_fromURL.toUpperCase().contains("T183")
		||_fromURL.toUpperCase().contains("C173")
		||_fromURL.toUpperCase().contains("D152")){//协作管理权限转移、复制、删除【人员】
	tablename = "cotype_sharemanager";
	sharetype = 1;
}
if(_fromURL.toUpperCase().contains("T232")
		||_fromURL.toUpperCase().contains("C252")
		||_fromURL.toUpperCase().contains("D232")){//协作管理权限转移、复制、删除【部门】
	tablename = "cotype_sharemanager";
	sharetype = 2;
}
if(_fromURL.toUpperCase().contains("T332")
		||_fromURL.toUpperCase().contains("C352")
		||_fromURL.toUpperCase().contains("D332")){//协作管理权限转移、复制、删除【分部】
	tablename = "cotype_sharemanager";
	sharetype = 3;
}
if(_fromURL.toUpperCase().contains("T422")
		||_fromURL.toUpperCase().contains("C442")
		||_fromURL.toUpperCase().contains("D422")){//协作管理权限转移、复制、删除【角色】
	tablename = "cotype_sharemanager";
	sharetype = 4;
}

sqlWhere += " and id in (select cotypeid from "+tablename+" where sharetype = "+sharetype+" and sharevalue = '"+fromid+"')";

tableString = " <table  pageId=\""+PageIdConst.Cowork_TransferTypeList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_TransferTypeList,user.getUID(),PageIdConst.COWORK)+"\" "+
			  " 	tabletype=\"checkbox\">"+
			  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
              " <head>"+
              "	<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" orderkey=\"typename\" column=\"typename\" linkvaluecolumn=\"id\" href=\"javascript:editCoworkType('{0}')\"/>"+
              "	<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(178,user.getLanguage())+"\" orderkey=\"departmentid\" column=\"departmentid\" transmethod=\"weaver.cowork.CoMainTypeComInfo.getCoMainTypename\"/>"+
              "	</head>"+ 
              " </table>";
              
          	StringBuilder _sql = new StringBuilder();
          	_sql.append("select ").append(backfields).append(" from ").append(fromSql).append(" where ").append(sqlWhere);
          	rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
          	long count = 0;
          	
          	if (rs.next()){
          		count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
          	}
          	MJson mjson = new MJson(oldJson, true);
          	if(mjson.exsit(_type)) {
          		mjson.updateArrayValue(_type, _sql.toString());
          	} else {
          		mjson.putArrayValue(_type, _sql.toString());
          	}
          	String oJson = Tools.getURLEncode(mjson.toString());
          	mjson.removeArrayValue(_type);
          	String nJson = Tools.getURLEncode(mjson.toString());              
%>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isHidden.equals("false")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</head>

<BODY>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(isHidden.equals("false")){ %>
			<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput"  id="searchtypename" name="searchtypename" value="<%=typename %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
<form id="searchfrm" action="CoworkType.jsp" method="post">
	<input type=hidden name="cmd" value="closeDialog">
	<input type=hidden name="fromid" value="<%=fromid%>">
	<input type=hidden name="toid" value="<%=toid%>">
	<input type=hidden name="type" value="<%=_type%>">
	<input type=hidden name="idStr" value="<%=selectedstrs%>">
	<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
	<input type=hidden name="isDelType" value="0">
	<input type=hidden name="selectAllSql" value="">
	<input type=hidden name="needExecuteSql" value="0">
	<input type=hidden name="isHidden" value="<%=isHidden %>">
	<input type=hidden name="_fromURL" value="<%=_fromURL %>">	
		
		
	<wea:layout type="4col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=inputstyle type=text name="typename" id="typename" value="<%=typename%>" style="width:150px;" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
			</wea:item> 
			
			<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
			<wea:item>
				<select name=departmentid id=departmentid style="width: 120px;">
					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				    <%while(CoMainTypeComInfo.next()){%>
				    	<option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>" <%=CoMainTypeComInfo.getCoMainTypeid().equals(departmentid)?"selected=selected":""%>><%=CoMainTypeComInfo.getCoMainTypename()%></option>
				    <%}%>
				</select>      
			</wea:item>
		</wea:group>
		
		<wea:group context="" attributes="{'Display':'none'}">
			<wea:item type="toolbar">
				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondition()"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>	
</div>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_TransferTypeList%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    	<wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
	    	</wea:item>
	   	</wea:group>
  	</wea:layout>
</div>

<script>

	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
	function doCloseDialog() {
		dialog.close();
	}
	
	jQuery(function(){
		$GetEle("selectAllSql").value = encodeURI("<%=_sql.toString()%>");
		resizeDialog(document);
	});
	function selectDone(id){
		if(!id){
			id = _xtable_CheckedCheckboxId();
		}
		if(!id){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
			return;
		}
		if(id.match(/,$/)){
			id = id.substring(0,id.length-1);
		}
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
			if (dialog) {
				var data = {
					type: '<%=_type%>',
					isAll: false,
					id: id,
					json: '<%=nJson%>'
				};
				dialog.callback(data);
				doCloseDialog();
			}
		});
	}

	function selectAll(){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
			if (dialog) {
				var data = {
					type: '<%=_type%>',
					isAll: true,
					count: <%=count%>,
					json: '<%=oJson%>'
				};
				dialog.callback(data);
				doCloseDialog();
			}
		});
	}
		
$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchTypeName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});

function searchTypeName(){
	var searchtypename = jQuery("#searchtypename").val();
	jQuery("#typename").val(searchtypename);
	window.searchfrm.submit();
}
</script>
</BODY>
</HTML>
