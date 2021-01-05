
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(442,user.getLanguage());
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
	
	Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
    
    //构建where语句
    String SqlWhere1 = ""  ;  
  	
    String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));
    String typeid = Util.null2String(request.getParameter("typeid"));
    String status = Util.null2String(request.getParameter("status"));
    String creater = Util.null2String(request.getParameter("creater"));
    
    if(!name.equals("")){
    	SqlWhere1 += " and name like '%"+name+"%' "; 
	}
	if(!typeid.equals("")){
		SqlWhere1 += "  and typeid in ("+typeid+")  ";
	}
	if(!status.equals("")){
		SqlWhere1 += " and status ="+status+"";
	}
	if(!creater.equals("")){
		SqlWhere1 += " and creater='"+creater+"'  ";
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
			<input type="text" class="searchInput"  id="searchCoworkName" name="searchCoworkName" value="<%=name%>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form action="Cowork.jsp" name="searchfrm" id="searchfrm">
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
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<input class=inputstyle type=text name="name" id="name" value="" style="180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
		        </wea:item> 
		        <wea:item><%=SystemEnv.getHtmlLabelName(33867,user.getLanguage())%></wea:item>
		        <wea:item>
			        <select name="typeid" size=1 style="width:180px;">
			    	<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
			        <%
			            String typesql="select * from cowork_types" ;
			           
			            RecordSet.executeSql(typesql);
			            while(RecordSet.next()){
			                String tmptypeid=RecordSet.getString("id");
			                String typename=RecordSet.getString("typename");
			        %>
			            <option value="<%=tmptypeid%>" <%=tmptypeid.equals(typeid)?"selected":"" %>><%=typename%></option>
			        <%
			            }
			        %>
			        </select>
		        </wea:item>

			      <wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
			      <wea:item>
				       <brow:browser viewType="0" name="creater" 
				       			browserValue='<%=creater%>' 
				        		browserSpanValue = '<%=ResourceComInfo.getResourcename(creater)%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="175px" >
					   </brow:browser>
			      </wea:item>   

			      <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			      <wea:item>
				      <select name=status style="width: 180px;">
				      <option value="" selected="selected"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				      <option value="1"><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
				      <option value="2"><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
				      </select>
			      </wea:item>
			</wea:group>
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</form>
</div>
<%
	String backfields = " t1.id,t1.name,t1.creater, t1.typeid,t1.status"; 
	String fromSql  = " cowork_items t1 ";
	String sqlWhere = " 1=1 "+SqlWhere1;
	String orderby = " t1.id" ;
	if(_fromURL.toUpperCase().contains("T181")){//转移协作负责人【人员】
		sqlWhere +=" and t1.principal = "+fromid;
	}
	if(_fromURL.toUpperCase().contains("C171")){//复制协作参与人 【人员】 
		if ("oracle".equals(rs.getDBType())) {
		    sqlWhere +=" and t1.id in (select sourceid from coworkshare where type =1 and ','||content||',' like '%,"+fromid+",%')";
		} else if ("sqlserver".equals(rs.getDBType())) {
		    sqlWhere +=" and t1.id in (select sourceid from coworkshare where type =1 and ','+content+',' like '%,"+fromid+",%')";
		} else if ("mysql".equals(rs.getDBType())) {
		    sqlWhere +=" and t1.id in (select sourceid from coworkshare where type =1 and concat(',', content, ',') like '%,"+fromid+",%')";
		}
	}
	if(_fromURL.toUpperCase().contains("D153")){//删除协作参与人 【人员】 
		if ("oracle".equals(rs.getDBType())) {
		    sqlWhere +=" and t1.id in (select sourceid from coworkshare where type =1 and ','||content||',' like '%,"+fromid+",%')";
		} else if ("sqlserver".equals(rs.getDBType())) {
		    sqlWhere +=" and t1.id in (select sourceid from coworkshare where type =1 and ','+content+',' like '%,"+fromid+",%')";
		} else if ("mysql".equals(rs.getDBType())) {
		    sqlWhere +=" and t1.id in (select sourceid from coworkshare where type =1 and concat(',', content, ',') like '%,"+fromid+",%')";
		}
		sqlWhere +=" and t1.id not in (select id from cowork_items where principal = '"+fromid+"')";
	}
	String tableString =" <table pageId=\""+PageIdConst.Cowork_TransferList+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_TransferList,user.getUID(),PageIdConst.COWORK)+"\""+
						"		tabletype=\"checkbox\">"+
						" <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
						" <head>"+
						" <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"name\" orderkey=\"name\"/>"+
					    " <col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" "+
					    "	orderkey=\"creater\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" "+
					    "	href=\"/hrm/resource/HrmResource.jsp\" linkkey=\"id\" linkvaluecolumn=\"creater\"/>"+
					    " <col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(33867,user.getLanguage())+"\" column=\"typeid\"  "+
					 	"	orderkey=\"typeid\" transmethod=\"weaver.cowork.CoTypeComInfo.getCoTypename\"/>"+
					 	" <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\"  column=\"status\" "+
					 	"	orderkey=\"status\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkStatus\"/>"+
						" </head>"+
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
<script>
	
</script>

<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
	
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
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchCoworkName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});

function searchCoworkName(){
	var searchCoworkName = jQuery("#searchCoworkName").val();
	jQuery("#name").val(searchCoworkName);
	window.searchfrm.submit();
}

		
</script>
</body>
</html>
