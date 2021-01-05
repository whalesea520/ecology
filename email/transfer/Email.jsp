
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String titlename =SystemEnv.getHtmlLabelName(442,user.getLanguage());

	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String _fromURL = Util.null2String(request.getParameter("_fromURL"));
	String isHidden = Util.null2String(request.getParameter("isHidden"),"false");
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
    String folderid = Util.null2String(request.getParameter("folderid"),"-1");//0:收件箱；-1:已发送
    
    //构建where语句
    String SqlWhere1 = ""  ;  
    
    String subject = Util.null2String(request.getParameter("subject"));//邮件主题
    String sendfrom = Util.null2String(request.getParameter("sendfrom"));//发件人
    String datetype = Util.null2String(request.getParameter("datetype"));//日期类型（全部、今天、本周、本月、上个月、本季、本年、上一年、指定日期范围）
    String startdate = Util.null2String(request.getParameter("startdate"));//起始日期
    String enddate = Util.null2String(request.getParameter("enddate"));//结束日期
    
    if (!subject.equals("")) {
        if ("oracle".equals(RecordSet.getDBType())) {
            SqlWhere1 += " and lower(subject) like '%" + subject.toLowerCase() + "%'";
        } else {
            SqlWhere1 += " and subject like '%" + subject + "%'";
        }
    }
    
    if(!"".equals(datetype) && !"6".equals(datetype)){
        SqlWhere1 += " and senddate >= '"+TimeUtil.getDateByOption(datetype+"","0")+" 00:00:00'";
        SqlWhere1 += " and senddate <= '"+TimeUtil.getDateByOption(datetype+"","")+" 23:59:59'";
    }
    
    if("6".equals(datetype) && !startdate.equals("")){
        SqlWhere1 += " and senddate >= '"+startdate+" 00:00:00'";
    }
    
    if("6".equals(datetype) && !enddate.equals("")){
        SqlWhere1 += " and senddate <= '"+enddate+" 23:59:59'";
    }

    if(!sendfrom.equals("")){
        SqlWhere1 += " and sendfrom like '%"+sendfrom+"%' "; 
    }
    
    SqlWhere1 += " and resourceid = '"+fromid+"'";
    SqlWhere1 += " and isinternal = 1";
    
    SqlWhere1 += " and folderid = '"+folderid+"'";
    
    int perpage =10;
    mss.selectMailSetting(user.getUID());
    if(!Util.null2String(mss.getPerpage()).equals("")){
        perpage = Util.getIntValue(mss.getPerpage());
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
			<input type="text" class="searchInput"  id="searchCoworkName" name="searchCoworkName" value="<%=subject%>" />
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
	<form action="Email.jsp" name="searchfrm" id="searchfrm">
		<input type=hidden name="cmd" value="closeDialog">
		<input type=hidden name="fromid" value="<%=fromid%>">
        <input type=hidden name="folderid" value="<%=folderid%>">
		<input type=hidden name="toid" value="<%=toid%>">
		<input type=hidden name="type" value="<%=_type%>">
		<input type=hidden name="isAll" value="<%=isAll%>">
		<input type=hidden name="idStr" value="<%=selectedstrs%>">
		<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
		<input type=hidden name="isDelType" value="0">
		<input type=hidden name="selectAllSql" value="">
		<input type=hidden name="needExecuteSql" value="0">
		<input type=hidden name="isHidden" value="<%=isHidden %>">
		<input type=hidden name="_fromURL" value="<%=_fromURL %>">	
		
		<wea:layout type="4col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("34077,25025",user.getLanguage())%></wea:item>
		        <wea:item>
		        	<input class=inputstyle type=text name="subject" id="subject" value="" style="180px" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
		        </wea:item> 
		        <wea:item><%=SystemEnv.getHtmlLabelName(129935,user.getLanguage())%></wea:item>
		        <wea:item>
			            <brow:browser viewType="0" name="sendfrom" 
                                browserValue='<%=sendfrom%>' 
                                browserSpanValue = '<%=ResourceComInfo.getResourcename(sendfrom)%>'
                                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
                                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                                completeUrl="/data.jsp" width="175px" >
                       </brow:browser>
		        </wea:item>

			    <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
                <wea:item>
                    <span>
                        <SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
                          <option value=""  <%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
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
	String backfields = " t1.id,t1.resourceid,t1.subject,t1.sendfrom,t1.senddate,t1.toids,t1.toall,t1.todpids"; 
	String fromSql  = " mailresource t1 ";
	String sqlWhere = " 1=1 "+SqlWhere1;
	String orderby = " t1.senddate" ;
	String column="";
    if("0".equals(folderid)){
        column = " <col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(129935,user.getLanguage())+"\" column=\"sendfrom\" orderkey=\"sendfrom\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getMulResourcename2\"  />";
    }else{
        column = " <col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(2046,user.getLanguage())+"\" column=\"toids\"  otherpara='column:toall+column:todpids' orderkey=\"toids\" transmethod=\"weaver.splitepage.transform.SptmForMail.getHrmSendToName\"  />"; 
    }
    
	String tableString =" <table pageId=\""+PageIdConst.Cowork_TransferList+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_TransferList,user.getUID(),PageIdConst.COWORK)+"\" tabletype=\""+("true".equals(isHidden)?"none":"checkbox")+"\">"+
						" <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" />"+
						" <head>"+
						" <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelNames("34077,25025",user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\"  href=\"/email/new/MailView.jsp\" linkkey=\"mailid\" linkvaluecolumn=\"id\" />"+
						column +
					 	" <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(277,user.getLanguage())+"\"  column=\"senddate\" "+
					 	"	orderkey=\"senddate\" />"+
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
		selectedstrs = authorityManager.getData("id", strUtil.decode(mjson.getValue(_type)));
		mjson.updateArrayValue(_type, weaver.common.StringUtil.encode(_sql.toString()));
	} else {
		 if(Boolean.valueOf(isAll).booleanValue()){
            selectedstrs = authorityManager.getData("id", _sql.toString());
        }
		mjson.putArrayValue(_type, weaver.common.StringUtil.encode(_sql.toString()));
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
		$GetEle("selectAllSql").value = encodeURI("<%=new String(Base64.encode((_sql.toString()).getBytes())) %>");
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
	//	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
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
	//	});
	}
		

$(document).ready(function(){
			
	jQuery("#topTitle").topMenuTitle({searchFn:searchCoworkName});
	jQuery("#hoverBtnSpan").hoverBtn();
    
    if("<%=datetype%>" == 6){
        jQuery("#dateTd").show();
    }else{
        jQuery("#dateTd").hide();
    }
				
});

function onChangetype(obj){
    if(obj.value == 6){
        jQuery("#dateTd").show();
    }else{
        jQuery("#dateTd").hide();
    }
}

function searchCoworkName(){
	var searchCoworkName = jQuery("#searchCoworkName").val();
	jQuery("#subject").val(searchCoworkName);
	window.searchfrm.submit();
}

</script>
<script language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>  
</body>
</html>
