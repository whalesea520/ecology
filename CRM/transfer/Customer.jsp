
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(442,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String _fromURL = Util.null2String(request.getParameter("_fromURL"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String isHidden = Util.null2String(request.getParameter("isHidden"),"false");
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String isAll = Util.null2String(request.getParameter("isAll"),"false");
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	
	Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
    
    //构建where语句
    String SqlWhere1 = ""  ;  
  	
    String customerName = Util.null2String(request.getParameter("customerName"));
    String customerType = Util.null2String(request.getParameter("customerType"));
	String customerStatus = Util.null2String(request.getParameter("customerStatus"));
  	//正常会议 
    if(!customerName.equals("")){
    	SqlWhere1 += " and t1.name like '%" + customerName +"%' ";
	}
    if(!customerType.equals("")){
    	SqlWhere1 += " and t1.type = "+ customerType;
    }
    if(!customerStatus.equals("")){
    	SqlWhere1 += " and t1.status = "+ customerStatus;
    }
%>
<HTML>
	<HEAD>
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
			<input type="text" class="searchInput"  id="searchCustomerName" name="searchCustomerName" value="<%=customerName%>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form action="Customer.jsp" name="searchfrm" id="searchfrm">
		<input type=hidden name="cmd" value="closeDialog">
		<input type=hidden name="fromid" value="<%=fromid%>">
		<input type=hidden name="toid" value="<%=toid%>">
		<input type=hidden name="type" value="<%=_type%>">
		<input type=hidden name="idStr" value="<%=selectedstrs%>">
		<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
		<input type=hidden name="isDelType" value="0">
		<input type=hidden name="isAll" value="<%=isAll%>">
		<input type=hidden name="selectAllSql" value="">
		<input type=hidden name="needExecuteSql" value="0">
		<input type=hidden name="isHidden" value="<%=isHidden %>">
		<input type=hidden name="_fromURL" value="<%=_fromURL %>">	
		
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></wea:item>
				<wea:item>
					<input type="text" class="InputStyle"  name="customerName" id="customerName" value="<%=customerName%>" style="width:150px">
				</wea:item>

				<wea:item><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerType" 
				        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp"
				        browserValue='<%=customerType%>'
				        browserSpanValue='<%=CustomerTypeComInfo.getCustomerTypename(customerType) %>'
				        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				        completeUrl="/data.jsp?type=customerType" width="180px" ></brow:browser>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="customerStatus" 
				        browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp"
				        browserValue='<%=customerStatus%>'
				        browserSpanValue='<%=CustomerStatusComInfo.getCustomerStatusname(customerStatus) %>'
				        isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				        completeUrl="/data.jsp?type=customerStatus" width="180px" ></brow:browser>
				</wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel"  onclick="resetCondition()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>
<%
	String backfields = " t1.id,t1.name,t1.type,t1.status"; 
	String fromSql  = " CRM_CustomerInfo t1 ";
	String sqlWhere = " t1.deleted = 0"+SqlWhere1;
	String orderby = " t1.id" ;
	if(_fromURL.toUpperCase().contains("T101")){//转移客户经理
		sqlWhere +=" and t1.manager = "+fromid;
	}
	if(_fromURL.toUpperCase().contains("C101")){//复制人员内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =1 and contents = "+fromid+")";
	}
	if(_fromURL.toUpperCase().contains("C211")){//复制部门内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =2 and contents = "+fromid+")";
	}
	if(_fromURL.toUpperCase().contains("C311")){//复制分部内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =5 and contents = "+fromid+")";
	}
	if(_fromURL.toUpperCase().contains("C401")){//复制角色内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =3 and contents = "+fromid+")";
	}
	
	if(_fromURL.toUpperCase().contains("D171")){//删除人员内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where "+
					"(isdefault is null or (isdefault=1 and sharelevel=3 and sharetype=1))"+
					" and contents = "+fromid+" and sharetype = 1)";
	}
	if(_fromURL.toUpperCase().contains("D251")){//删除部门内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =2 and contents = "+fromid+")";
	}
	if(_fromURL.toUpperCase().contains("D351")){//删除分部内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =5 and contents = "+fromid+")";
	}
	if(_fromURL.toUpperCase().contains("D441")){//删除角色内容
		sqlWhere +=" and t1.id in (select relateditemid from CRM_ShareInfo where sharetype =3 and isdefault is null and contents = "+fromid+")";
	}
	
	String tableString =" <table pageId=\""+PageIdConst.CRM_TransferList+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_TransferList,user.getUID(),PageIdConst.CRM)+"\""+
						"		tabletype=\"checkbox\">"+
						" <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
						" <head>"+
						" <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(1268,user.getLanguage())+"\" column=\"name\""+
						"		orderkey=\"name\" href=\"/CRM/data/ViewCustomer.jsp\" linkkey =\"CustomerID\" linkvaluecolumn = \"id\"/>"+
					    " <col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(1282,user.getLanguage())+"\" column=\"type\" "+
					    "		orderkey=\"type\" transmethod=\"weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename\" />"+
					 	" <col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(15078,user.getLanguage())+"\" column=\"status\"  "+
					 	"		orderkey=\"status\" transmethod=\"weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname\"/>"+
						" </head>"+
						" </table>";

	StringBuilder _sql = new StringBuilder();
	_sql.append("select ").append(backfields).append(" from ").append(fromSql).append(" where ").append(sqlWhere);
	rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
	long count = 0;
	String tempSql = strUtil.encode(_sql.toString());
	_sql.setLength(0);
	_sql.append(tempSql);
	if (rs.next()){
		count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
	}
	MJson mjson = new MJson(oldJson, true);
	if(mjson.exsit(_type)) {
		selectedstrs = authorityManager.getData("id", strUtil.decode(mjson.getValue(_type)));
		mjson.updateArrayValue(_type, _sql.toString());
	} else {
		if(Boolean.valueOf(isAll).booleanValue()) selectedstrs = authorityManager.getData("id", strUtil.decode(_sql.toString()));
		mjson.putArrayValue(_type, _sql.toString());
	}
	String oJson = Tools.getURLEncode(mjson.toString());
	mjson.removeArrayValue(_type);
	String nJson = Tools.getURLEncode(mjson.toString());
%>
<script>
	
</script>

<div class="zDialog_div_content" style="height:400px;">

<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
	
</div>
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    	<wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
	    	</wea:item>
	   	</wea:group>
  	</wea:layout>
</div>

<script type="text/javascript">
	
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
	}

	function selectAll(){
		if (dialog) {
			var data = {
				type: '<%=_type%>',
				isAll: true,
				count: <%=count%>,
				json: '<%=nJson%>'
			};
			dialog.callback(data);
			doCloseDialog();
		}
	}
		

$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchCustomerName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});

function searchCustomerName(){
	var customerName = jQuery("#searchCustomerName").val();
	jQuery("#customerName").val(customerName);
	window.searchfrm.submit();
}

		
</script>
</body>
</html>
