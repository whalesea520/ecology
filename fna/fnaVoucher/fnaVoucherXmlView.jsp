<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.fna.fnaVoucher.FnaCreateXml"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.fna.encrypt.Des"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

BaseBean bb = new BaseBean();
DecimalFormat df = new DecimalFormat("##############################0.00");

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String sql = "";

int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);
int fnaVoucherXmlContentId = Util.getIntValue(request.getParameter("fnaVoucherXmlContentId"), 0);
int isXmlContent = Util.getIntValue(request.getParameter("isXmlContent"), 0);
int isNode = Util.getIntValue(request.getParameter("isNode"), 0);
int isAttr = Util.getIntValue(request.getParameter("isAttr"), 0);

String xmlName = "";
String xmlMemo = "";
String xmlVersion = "";
String xmlEncoding = "";
int workflowid = 0;


int contentParentId = Util.getIntValue(request.getParameter("contentParentId"), 0);
String contentParentName = "";

String contentType = "";
String contentName = "";
String contentValue = "";
String contentValueType = "2";
String parameter = "";
String contentMemo = "";
double orderId = 1.00;
int isNullNotPrint = 0;
int isNullNotPrintNode = 0;
String typename = "";
String interfacesAddress = "";
String datasourceid = "";

if(isNode==1){
	contentType = "e";
}else if(isAttr==1){
	if(contentParentId > 0){
		contentType = "a";
	}else{
		contentType = "?";
	}
}

if(isXmlContent==0){
	sql = "select * from fnaVoucherXml a where a.id = "+fnaVoucherXmlId;
	rs.executeSql(sql);
	if(rs.next()){
		xmlName = Util.null2String(rs.getString("xmlName")).trim();
		xmlMemo = Util.null2String(rs.getString("xmlMemo")).trim();
		xmlVersion = Util.null2String(rs.getString("xmlVersion")).trim();
		xmlEncoding = Util.null2String(rs.getString("xmlEncoding")).trim();
		workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
		typename = Util.null2String(rs.getString("typename")).trim();
		interfacesAddress = Util.null2String(rs.getString("interfacesAddress")).trim();
		datasourceid = Util.null2String(rs.getString("datasourceid")).trim();
	}else{
		xmlVersion = "1.0";
	}
}else{
	sql = "select b.*, a.workflowid from fnaVoucherXml a join fnaVoucherXmlContent b on a.id = b.fnaVoucherXmlid where b.id = "+fnaVoucherXmlContentId;
	rs.executeSql(sql);
	if(rs.next()){
		contentType = Util.null2String(rs.getString("contentType")).trim();
		contentName = Util.null2String(rs.getString("contentName")).trim();
		contentValue = Util.null2String(rs.getString("contentValue")).trim();
		contentValueType = Util.null2String(rs.getString("contentValueType")).trim();
		parameter = Util.null2String(rs.getString("parameter")).trim();
		contentMemo = Util.null2String(rs.getString("contentMemo")).trim();
		orderId = Util.getDoubleValue(rs.getString("orderId"), 0);
		contentParentId = Util.getIntValue(rs.getString("contentParentId"), 0);
		workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
		isNullNotPrint = Util.getIntValue(rs.getString("isNullNotPrint"), 0);
		isNullNotPrintNode = Util.getIntValue(rs.getString("isNullNotPrintNode"), 0);
	}else{
		sql = "select max(orderId) max_orderId from fnaVoucherXmlContent a "+
			" where a.contentType = '"+StringEscapeUtils.escapeSql(contentType)+"' ";
		if(contentParentId > 0){
			sql += " and a.contentParentId = "+contentParentId+" ";
		}
		sql += " and a.fnaVoucherXmlId = "+fnaVoucherXmlId;
		rs.executeSql(sql);
		if(rs.next()){
			orderId = Util.getDoubleValue(df.format(Util.getDoubleValue(rs.getString("max_orderId"), 0.00)+1));
		}
	}
	if(contentParentId > 0){
		sql = "select * from fnaVoucherXmlContent a where ";
		if(contentParentId > 0){
			sql += " a.id = "+contentParentId+" and ";
		}
		sql += " a.fnaVoucherXmlId = "+fnaVoucherXmlId;
		rs.executeSql(sql);
		if(rs.next()){
			contentParentName = Util.null2String(rs.getString("contentName")).trim();
		}
	}
}

String navName = (isXmlContent==0)?xmlName:contentName;
if("".equals(navName)){
	navName = SystemEnv.getHtmlLabelNames("84672",user.getLanguage());//XML模板
}

String workflowname = "";
if(workflowid > 0){
	sql = "select a.workflowname from workflow_base a where a.id = "+workflowid;
	rs.executeSql(sql);
	if(rs.next()){
		workflowname = Util.null2String(rs.getString("workflowname")).trim();
	}
}

StringBuilder selectDetailTableHtml = new StringBuilder("<select id='contentValueForContentValueType6' name='contentValueForContentValueType6'>");
int formid = 0;
int formidABS = 0;
List fieldIdList = new ArrayList();
HashMap fieldInfoHm = new HashMap();

if(workflowid > 0){
	fieldIdList.add("requestid");
	fieldInfoHm.put("requestid"+"_fieldname", "requestid");
	fieldInfoHm.put("requestid"+"_fieldlabel", "requestid");
	fieldInfoHm.put("requestid"+"_viewtype", "");
	fieldInfoHm.put("requestid"+"_fieldhtmltype", "");
	fieldInfoHm.put("requestid"+"_type", "");
	fieldInfoHm.put("requestid"+"_dsporder", "");
	fieldInfoHm.put("requestid"+"_detailtable", "");
	
	formid = FnaWfSet.getFieldListForFieldTypeMain(fieldIdList, fieldInfoHm, 
			workflowid);
	formidABS = Math.abs(formid);
	
	String dbTableName = "formtable_main_"+formidABS;
	sql = "select DISTINCT detailtable \n" +
		" from workflow_billfield \n" +
		" where detailtable like '"+StringEscapeUtils.escapeSql(dbTableName)+"_dt%' \n"+
		" order by detailtable asc";
	rs.executeSql(sql);
	while(rs.next()){
		String detailtable = Util.null2String(rs.getString("detailtable")).trim();
		int dtlNumber = Util.getIntValue(detailtable.replaceAll("formtable_main_"+formidABS+"_dt", ""), 0);
		
		FnaWfSet.getFieldListForFieldTypeDtl(new ArrayList(), new HashMap(), 
				new ArrayList(), new HashMap(), 
				new ArrayList(), new HashMap(), 
				new ArrayList(), new HashMap(), 
				new ArrayList(), new HashMap(), 
				fieldIdList, fieldInfoHm, 
				workflowid, dtlNumber);
		
		String selected = "";
		if("6".equals(contentValueType)){//流程明细表
			if(Util.getIntValue(contentValue)==dtlNumber){
				selected = "selected='selected'";
			}
		}
		selectDetailTableHtml.append("<option value='"+dtlNumber+"' "+selected+">"+
				SystemEnv.getHtmlLabelName(19325,user.getLanguage())+dtlNumber+"（formtable_main_"+formidABS+"_dt"+dtlNumber+"）"+
				"</option>");
	}
	
	if("4".equals(contentValueType) && !"".equals(contentValue)){//表单字段
		String fieldname = "";
		String detailtable = "";
		if(contentValue.indexOf(FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME1+".")==0){
			fieldname = Util.null2String(contentValue.split(FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME1+".")[1]).trim();
		}else if(contentValue.indexOf(FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME2+".")==0){
			fieldname = Util.null2String(contentValue.split(FnaCreateXml.WORKFLOW_MAIN_DATA_SET_ALIAS_NAME2+".")[1]).trim();
		}else{
			try{
				contentValue = contentValue.replace(FnaCreateXml.WORKFLOW_DETAIL_DATA_SET_ALIAS_NAME1, "");
				contentValue = contentValue.replace(FnaCreateXml.WORKFLOW_DETAIL_DATA_SET_ALIAS_NAME2, "");
				int detailtableNumber = Util.getIntValue(contentValue.split("\\.")[0], 0);
				fieldname = Util.null2String(contentValue.split("\\.")[1]).trim();
				detailtable = "formtable_main_"+formidABS+"_dt"+detailtableNumber;
			}catch(Exception ex1){
			}
		}
		contentValue = "";
		if("requestid".equals(fieldname)){
			contentValue = "requestid";
		}else{
	    	sql = "select id from workflow_billfield a "+
				" where billid = "+formid+" "+
	    		" and a.fieldname = '"+StringEscapeUtils.escapeSql(fieldname)+"'";
	    	if(!"".equals(detailtable)){
	    		sql += " and detailtable = '"+StringEscapeUtils.escapeSql(detailtable)+"' ";
	    	}
			rs.executeSql(sql);
			if(rs.next()){
				String fieldId = Util.null2String(rs.getString("id")).trim();
				contentValue = fieldId;
			}
		}
	}
}
selectDetailTableHtml.append("</select>");

String alertSpan_info_1_U8 = SystemEnv.getHtmlLabelName(126459,user.getLanguage())+"：V10、V11、V12";//支持版本：V10、V11、V12
String alertSpan_info_1_K3 = SystemEnv.getHtmlLabelName(126459,user.getLanguage())+"：V10.2；"+SystemEnv.getHtmlLabelName(126460,user.getLanguage());//支持版本：V10.2；不支持辅助核算
String alertSpan_info_1_NC = SystemEnv.getHtmlLabelName(126461,user.getLanguage());//支持Servlet XML接口

String alertSpan_typename_1 = "display: none;";
String alertSpan_info_1 = "";
if("U8".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_U8;
}else if("K3".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_K3;
}else if("NC".equals(typename)){
	alertSpan_typename_1 = "";
	alertSpan_info_1 = alertSpan_info_1_NC;
}
%>
<%@page import="weaver.filter.XssUtil"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=30"></script>
<script type="text/javascript" src="/fna/encrypt/des/des_wev8.js"></script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(fnaVoucherXmlId > 0 && isNode==0 && isAttr==0 && (!("?".equals(contentType) || "a".endsWith(contentType)) || isXmlContent==0)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(84704,user.getLanguage())+",javascript:doNewNode(),_TOP} ";//新建子节点
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(84703,user.getLanguage())+",javascript:doNewAttr(),_TOP} ";//新建属性
	RCMenuHeight += RCMenuHeightStep ;
}
if(isXmlContent==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_TOP} ";//保存
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSaveContent(),_TOP} ";//保存
	RCMenuHeight += RCMenuHeightStep ;
}
if(fnaVoucherXmlId > 0 && fnaVoucherXmlContentId==0 && isNode==0 && isAttr==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_TOP} ";//删除
	RCMenuHeight += RCMenuHeightStep ;
}else if(fnaVoucherXmlId > 0 && fnaVoucherXmlContentId > 0 && isNode==0 && isAttr==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelContent(),_TOP} ";//删除
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=navName %>"/>
   <jsp:param name="tab_box_overflow" value="overflow-x:hidden;overflow-y:auto;"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    	<%if(fnaVoucherXmlId > 0 && isNode==0 && isAttr==0 && (!("?".equals(contentType) || "a".endsWith(contentType)) || isXmlContent==0)){ %>
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doNewNode();" 
		    			value="<%=SystemEnv.getHtmlLabelName(84704,user.getLanguage())%>"/><!-- 新建子节点 -->
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doNewAttr();" 
		    			value="<%=SystemEnv.getHtmlLabelName(84703,user.getLanguage())%>"/><!-- 新建属性 -->
		    	<%} %>
		    	<%if(isXmlContent==0){ %>
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSave();" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
		    	<%}else{ %>
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doSaveContent();" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
		    	<%} %>
		    	<%if(fnaVoucherXmlId > 0 && fnaVoucherXmlContentId==0 && isNode==0 && isAttr==0){ %>
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doDel();" 
		    			value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"/><!-- 删除 -->
		    	<%}else if(fnaVoucherXmlId > 0 && fnaVoucherXmlContentId > 0 && isNode==0 && isAttr==0){ %>
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doDelContent();" 
		    			value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"/><!-- 删除 -->
		    	<%} %>
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<input type="hidden" id="fnaVoucherXmlId" name="fnaVoucherXmlId" value="<%=fnaVoucherXmlId %>" />
<input type="hidden" id="fnaVoucherXmlContentId" name="fnaVoucherXmlContentId" value="<%=fnaVoucherXmlContentId %>" />
<input type="hidden" id="isXmlContent" name="isXmlContent" value="<%=isXmlContent %>" />
		
<wea:layout type="2col">
<%if(isXmlContent==0){ %>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>"><!-- 基本信息 -->
    <%if(fnaVoucherXmlId > 0){ %>
		<wea:item>ID</wea:item><!-- ID -->
		<wea:item>
			<%=fnaVoucherXmlId %>
		</wea:item>
    <%} %>
		<wea:item>XML&nbsp;<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- XML 名称 -->
		<wea:item>
			<wea:required id="xmlNameSpan" required="true" value="<%=FnaCommon.escapeHtml(xmlName)%>">
       			<input class="inputstyle" id="xmlName" name="xmlName" maxlength="30" style="width: 150px;" 
       				onchange='checkinput("xmlName","xmlNameSpan");' value="<%=FnaCommon.escapeHtml(xmlName)%>" />
			</wea:required>
		</wea:item>
		<wea:item>XML&nbsp;<%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></wea:item><!-- XML 编码 -->
		<wea:item>
            <select class="inputstyle" id="xmlEncoding" name="xmlEncoding" style="width: 80px;">
              <option value="UTF-8" <% if("UTF-8".equals(xmlEncoding)) {%>selected<%}%>>UTF-8</option>
              <option value="GBK" <% if("GBK".equals(xmlEncoding)) {%>selected<%}%>>GBK</option>
              <option value="GB2312" <% if("GB2312".equals(xmlEncoding)) {%>selected<%}%>>GB2312</option>
              <option value="ISO-8859-1" <% if("ISO-8859-1".equals(xmlEncoding)) {%>selected<%}%>>ISO-8859-1</option>
            </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></wea:item><!-- XML 版本 -->
		<wea:item>
			<wea:required id="xmlVersionSpan" required="true" value="<%=FnaCommon.escapeHtml(xmlVersion)%>">
      			<input class="inputstyle" id="xmlVersion" name="xmlVersion" maxlength="30" style="width: 150px;" 
      				onchange='checkinput("xmlVersion","xmlVersionSpan");' value="<%=FnaCommon.escapeHtml(xmlVersion)%>" />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></wea:item><!-- 关联流程 -->
		<wea:item>
			<%
			String workflowid_str = workflowid+"";
			%>
		<%
		String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp%3Fsqlwhere="+new XssUtil().put("where isbill=1 and formid<0");
		%>
	        <brow:browser viewType="0" name="workflowid" browserValue="<%=workflowid_str %>" 
	                browserUrl="<%=_browserUrl %>"
	                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
	                completeUrl="/data.jsp?type=workflowBrowser"  temptitle="<%= SystemEnv.getHtmlLabelName(23753,user.getLanguage())%>"
	                browserSpanValue="<%=FnaCommon.escapeHtml(workflowname) %>" width="80%" 
	        >
	        </brow:browser>
       	</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(32201,user.getLanguage())%></wea:item><!-- 财务系统 -->
		<wea:item>
			<select id="typename" name="typename" style='width:160px!important;' onchange="typename_onchange();">
				<option value="NC" <%if("NC".equals(typename)) out.print("selected"); %>>NC</option>
				<option value="U8" <%if("U8".equals(typename)) out.print("selected"); %>>U8</option>
				<option value="K3" <%if("K3".equals(typename)) out.print("selected"); %>>K3</option>
				<!-- 
				<option value="EAS" <%if("EAS".equals(typename)) out.print("selected"); %>>EAS</option>
				 -->
			</select>
			<span id="alertSpan_typename_1" style="color: red;font-weight: bolder;margin-left: 5px;<%=alertSpan_typename_1 %>"><%=FnaCommon.escapeHtml(alertSpan_info_1) %></span>
		</wea:item>
		<wea:item attributes="{'samePair':'interfacesAddress1'}"><%=SystemEnv.getHtmlLabelNames("32363,83578",user.getLanguage())%></wea:item><!-- 接口地址 -->
		<wea:item attributes="{'samePair':'interfacesAddress1'}">
			<wea:required id="interfacesAddressimage" required="true" value='<%=FnaCommon.escapeHtml(interfacesAddress) %>'>
				<input class="inputstyle" type="text" id="interfacesAddress" name="interfacesAddress" style='width:95%!important;' 
					value="<%=FnaCommon.escapeHtml(interfacesAddress) %>" maxLength="2000" onchange='checkinput("interfacesAddress","interfacesAddressimage")' />
			</wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'datasource1'}"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item><!-- 数据源 -->
		<wea:item attributes="{'samePair':'datasource1'}">
			<wea:required id="datasourceidspan" required="true" value='<%=datasourceid %>'>
				<select id="datasourceid" name="datasourceid" style='width:160px!important;' onchange="datasourceid_onchange();">
					<option></option>
					<%
					List pointArrayList = DataSourceXML.getPointArrayList();
					for(int i=0;i<pointArrayList.size();i++){
						String pointid = (String)pointArrayList.get(i);
						String isselected = "";
						if(datasourceid.equals(pointid)){
							isselected = "selected";
						}
					%>
					<option value="<%=FnaCommon.escapeHtml(pointid) %>" <%=isselected%>><%=FnaCommon.escapeHtml(pointid) %></option>
					<%    
					}
					%>
				</select>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
		<wea:item>
			<textarea class=inputstyle id="xmlMemo" name="xmlMemo" style="width: 95%;" rows=4><%=FnaCommon.escapeHtml(xmlMemo)%></textarea>
       	</wea:item>
	</wea:group>
<%}else{ %>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>"><!-- 基本信息 -->
	<%if(contentParentId > 0){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(84705,user.getLanguage())%></wea:item><!-- 父节点 -->
		<wea:item>
			<%=FnaCommon.escapeHtml(contentParentName) %>
		</wea:item>
	<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item><!-- 类型 -->
		<wea:item>
		<%if(fnaVoucherXmlContentId <= 0){ %>
			<input id="contentValueType" name="contentValueType" value="0" type="hidden" />
		<%} %>
			<input id="contentParentId" name="contentParentId" value="<%=contentParentId%>" type="hidden" />
			<input id="contentType" name="contentType" value="<%=FnaCommon.escapeHtml(contentType)%>" type="hidden" />
			<%=(("?".equals(contentType) || "a".endsWith(contentType))?
					SystemEnv.getHtmlLabelName(713,user.getLanguage()):SystemEnv.getHtmlLabelName(15586,user.getLanguage())) %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- 名称 -->
		<wea:item>
			<wea:required id="contentNameSpan" required="true" value="<%=FnaCommon.escapeHtml(contentName)%>">
       			<input class="inputstyle" id="contentName" name="contentName" maxlength="30" style="width: 150px;" 
       				onchange='checkinput("contentName","contentNameSpan");' value="<%=FnaCommon.escapeHtml(contentName)%>" />
			</wea:required>
		</wea:item>
	<%if(fnaVoucherXmlContentId > 0){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(126499,user.getLanguage())%></wea:item><!-- 隐藏当前节点  -->
		<wea:item>
            <input id="isNullNotPrint" name="isNullNotPrint" value="1" type="checkbox" <%=(isNullNotPrint==1)?"checked=\"checked\"":"" %>/>
			<%=SystemEnv.getHtmlLabelName(126500,user.getLanguage())%>：<!-- 右侧节点内容为空时隐藏当前节点 -->
            <select class="inputstyle" id="isNullNotPrintNode" name="isNullNotPrintNode">
			<%
			String _sql = "WITH allsub(id,contentParentId,contentName)\n" +
					" as (\n" +
					" SELECT id,contentParentId,contentName FROM fnaVoucherXmlContent where id="+fnaVoucherXmlContentId+" \n" +
					"  UNION ALL SELECT a.id,a.contentParentId,a.contentName FROM fnaVoucherXmlContent a,allsub b where a.contentParentId = b.id\n" +
					" ) select * from allsub";
			if("oracle".equals(rs.getDBType())){
				_sql = "select id,contentParentId,contentName from fnaVoucherXmlContent\n" +
					" start with id="+fnaVoucherXmlContentId+" \n" +
					" connect by prior id = contentParentId";
			}else if("mysql".equals(rs.getDBType())){
				_sql = "select DISTINCT t.id,t.contentName,t.contentParentId,t.feelevel from (\n" +
					"	select @id idlist, @lv:=@lv+1 lv,\n" +
					"	(select @id:=group_concat(id separator ',') from fnaVoucherXmlContent where find_in_set(contentParentId,@id)) sub\n" +
					"	from fnaVoucherXmlContent,(select @id:="+fnaVoucherXmlContentId+",@lv:=0) vars\n" +
					"	where @id is not null) tl,fnaVoucherXmlContent t\n" +
					" where find_in_set(t.id,tl.idlist) " +
					" order by lv asc";
			}
			rs.executeSql(_sql);
			while(rs.next()){
				int _delId1 = rs.getInt("id");
				String _contentName = Util.null2String(rs.getString("contentName")).trim();
			%>
              <option value="<%=_delId1 %>" <% if(isNullNotPrintNode==_delId1) {%>selected<%}%>><%=FnaCommon.escapeHtml(_contentName+"("+_delId1+")") %></option><!-- 下级节点字段 -->
			<%
			} 
			%>
            </select>
		</wea:item>
		<wea:item><%=("?".equals(contentType) || "a".endsWith(contentType))
			?SystemEnv.getHtmlLabelName(124789,user.getLanguage()):SystemEnv.getHtmlLabelName(84706,user.getLanguage())%></wea:item><!-- 节点内容类型 -->
		<wea:item>
            <select class="inputstyle" id="contentValueType" name="contentValueType" onchange="contentValueType_onchange(true);" style="width: 128px;">
			<%if(workflowid > 0){ %>
              <option value="4" <% if("4".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></option><!-- 4：表单字段 -->
              <option value="5" <% if("5".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option><!-- 5：流程 -->
              <option value="6" <% if("6".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84595,user.getLanguage())%></option><!-- 6：流程明细表 -->
			<%} %>
              <option value="2" <% if("2".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84710,user.getLanguage())%></option><!-- 2：返回单个值 -->
              <option value="3" <% if("3".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84709,user.getLanguage())%></option><!-- 3：返回多行记录 -->
              <option value="0" <% if("0".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84708,user.getLanguage())%></option><!-- 0：无内容 -->
              <option value="1" <% if("1".equals(contentValueType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(84711,user.getLanguage())%></option><!-- 1：固定文字 -->
            </select>
		</wea:item>
		<wea:item attributes="{'samePair':'tr1_contentValue'}"><%=("?".equals(contentType) || "a".endsWith(contentType))
			?SystemEnv.getHtmlLabelName(124790,user.getLanguage()):SystemEnv.getHtmlLabelName(84707,user.getLanguage())%></wea:item><!-- 节点内容 -->
		<wea:item attributes="{'samePair':'tr1_contentValue'}">
			<wea:required id="contentValueSpan" required="true" value="<%=FnaCommon.escapeHtml(contentValue)%>">
	      		<input class="inputstyle" id="contentValue" name="contentValue" style="width: 95%;" 
	      			onchange='checkinput("contentValue","contentValueSpan");' value="<%=FnaCommon.escapeHtml(contentValue)%>" />
			</wea:required><br />
			<font color="red" style="font: bold;">
				<span id="contentValue2" style="display: none;">
					<%=SystemEnv.getHtmlLabelName(124791,user.getLanguage())%><br />
					<%=SystemEnv.getHtmlLabelName(84740,user.getLanguage())%>
				</span><!-- 
					//节点内容格式：
					//“数据集别名”加上“.”加上“数据集中值的名称（SQL中为查询结果列名、类中为方法名、配置文件为配置项名称、默认变量为变量名）”
				 -->
				<span id="contentValue3" style="display: none;">
					<%=SystemEnv.getHtmlLabelName(124791,user.getLanguage())%><br />
					<%=SystemEnv.getHtmlLabelName(84741,user.getLanguage())%>
				</span><!-- 
					//节点内容格式：
					//数据集别名
				 -->
				<span id="contentValue1" style="display: none;">
					<%=SystemEnv.getHtmlLabelName(124791,user.getLanguage())%><br />
					<%=SystemEnv.getHtmlLabelName(84742,user.getLanguage())%>
				</span><!-- 
					//节点内容格式：
					//固定文字
				 -->
			</font>
		</wea:item>
		<wea:item attributes="{'samePair':'td_parameter'}"><%=SystemEnv.getHtmlLabelName(32312,user.getLanguage())%></wea:item><!-- 传入参数 -->
		<wea:item attributes="{'samePair':'td_parameter'}">
      		<input class="inputstyle" id="parameter" name="parameter" style="width: 95%;" 
      			value="<%=parameter%>" /><br />
	            <font color="red" style="font: bold;">
					<%=SystemEnv.getHtmlLabelName(84735,user.getLanguage())%><br />
					<%=SystemEnv.getHtmlLabelName(84737,user.getLanguage())%><br />
					<%=SystemEnv.getHtmlLabelName(84738,user.getLanguage())%><br />
	            </font>
		</wea:item>
		<wea:item attributes="{'samePair':'tr2_contentValue'}"><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></wea:item><!-- 表单字段 -->
		<wea:item attributes="{'samePair':'tr2_contentValue'}">
			<%=FnaWfSet.getSelect(fieldIdList, fieldInfoHm, contentValue, user, formid, "contentValueForContentValueType4", true, 0, false, "width:380px;") %>
		</wea:item>
		<wea:item attributes="{'samePair':'tr3_contentValue'}"><%=SystemEnv.getHtmlLabelName(84595,user.getLanguage())%></wea:item><!-- 流程明细表 -->
		<wea:item attributes="{'samePair':'tr3_contentValue'}">
			<%=selectDetailTableHtml.toString() %>
		</wea:item>
	<%} %>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item><!-- 显示顺序 -->
		<wea:item>
			<wea:required id="orderIdSpan" required="true" value="<%=df.format(orderId)%>">
       			<input class="inputstyle" id="orderId" name="orderId" maxlength="10" style="width: 50px;" 
       				onchange='checkinput("orderId","orderIdSpan");' value="<%=df.format(orderId)%>" />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
		<wea:item>
			<textarea class=inputstyle id="contentMemo" name="contentMemo" style="width: 95%;" rows=4><%=FnaCommon.escapeHtml(contentMemo)%></textarea>
       	</wea:item>
	</wea:group>
<%} 
if((isXmlContent==0 && fnaVoucherXmlId > 0) || ("e".equals(contentType) && fnaVoucherXmlContentId > 0)){
	String orderNameSql = " case when (a.initTiming = 0) then ('"+SystemEnv.getHtmlLabelName(31706,user.getLanguage())+" '+Convert(varchar, a.orderId)) "+//节点前
			" else ('"+SystemEnv.getHtmlLabelName(31705,user.getLanguage())+" '+Convert(varchar, a.orderId)) end orderName ";
	if("oracle".equals(rs.getDBType())){
		orderNameSql = " case when (a.initTiming = 0) then ('"+SystemEnv.getHtmlLabelName(31706,user.getLanguage())+" '||to_char(a.orderId)) "+//节点前
			" else ('"+SystemEnv.getHtmlLabelName(31705,user.getLanguage())+" '||to_char(a.orderId)) end orderName ";
	}else if("mysql".equals(rs.getDBType())){
		orderNameSql = " case when (a.initTiming = 0) then (CONCAT('"+SystemEnv.getHtmlLabelName(31706,user.getLanguage())+" ',a.orderId)) "+//节点前
			" else (CONCAT('"+SystemEnv.getHtmlLabelName(31705,user.getLanguage())+" ', a.orderId)) end orderName ";
	}
	//设置好搜索条件
	String backFields =" a.*, b.dSetName, "+orderNameSql;//节点后
	String fromSql = " from fnaVoucherXmlContentDset a join fnaDataSet b on a.fnaDataSetId = b.id ";
	String sqlWhere = " where a.fnaVoucherXmlId = "+fnaVoucherXmlId+" and a.fnaVoucherXmlContentId = "+fnaVoucherXmlContentId+" ";

	String orderBy=" a.initTiming, a.orderId ";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table needPage=\"false\" pagesize=\"999999\" tabletype=\"checkbox\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
      		" sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" />"+
       "<head>"+
             "<col width=\"45%\"  text=\""+SystemEnv.getHtmlLabelName(84712,user.getLanguage())+"\" column=\"dSetName\" "+
					" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"doEditDtl+column:id\"/>"+
             "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(84743,user.getLanguage())+"\" column=\"dSetAlias\" "+
 	     			" transmethod=\"weaver.general.Util.toScreenForWorkflow\" />"+
             "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(84822,user.getLanguage())+"\" column=\"orderName\" "+
		 			" />"+
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:doEditDtl();\" text=\""+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"\" index=\"0\"/>"+
		"			<operate href=\"javascript:doDel_grid_dtl();\" text=\""+SystemEnv.getHtmlLabelName(91, user.getLanguage())+"\" index=\"1\"/>"+
		"		</operates>"+
       "</table>";
%>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(84720,user.getLanguage())%>"><!-- 加载数据集 -->
		<wea:item type="groupHead">
			&nbsp;
		  	<input type=button  Class="addbtn" type=button accessKey=A onclick="doAddDtl()" 
		  		title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
		  	<input type=button  Class="delbtn" type=button accessKey=E onclick="batchDelDtl();" 
		  		title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
  		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
		</wea:item>
	</wea:group>
<%
}
%>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<%if(true){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="dialog.closeByHand();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>
<%} %>

<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var dialog = parent.parent.getDialog(parent);

jQuery(document).ready(function(){
	try{
		checkinput("xmlName","xmlNameSpan");
	}catch(e1){}
	try{
		checkinput("xmlVersion","xmlVersionSpan");
	}catch(e1){}
	try{
		checkinput("contentName","contentNameSpan");
	}catch(e1){}
	try{
		checkinput("contentValue","contentValueSpan");
	}catch(e1){}
	try{
		checkinput("orderId","orderIdSpan");
	}catch(e1){}
	try{
		controlNumberCheck_jQuery("orderId", true, 2, false, 2);
	}catch(e1){}
	try{
		contentValueType_onchange(false);
	}catch(e1){}
	try{
		typename_onchange();
	}catch(e1){}
	try{
		resizeDialog(document);
	}catch(e1){}
});

function typename_onchange(){
	var typename = jQuery("#typename").val();
	var _obj = jQuery("#alertSpan_typename_1");
	showEle("datasource1");
	hideEle("interfacesAddress1");
	if(typename=="U8"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_U8) %>");
		_obj.show();
	}else if(typename=="K3"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_K3) %>");
		_obj.show();
	}else if(typename=="NC"){
		_obj.text("<%=FnaCommon.escapeHtml(alertSpan_info_1_NC) %>");
		_obj.show();
		showEle("interfacesAddress1");
		hideEle("datasource1");
	}else{
		_obj.hide();
	}
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

function contentValueType_onchange(clearContentValue){
	var _contentValueType = jQuery("#contentValueType").val();
	if(_contentValueType=="0"){
		hideEle("tr1_contentValue");
		hideEle("tr2_contentValue");
		hideEle("tr3_contentValue");
	}else if(_contentValueType=="4"){
		hideEle("tr1_contentValue");
		showEle("tr2_contentValue");
		hideEle("tr3_contentValue");
	}else if(_contentValueType=="5"){
		hideEle("tr1_contentValue");
		hideEle("tr2_contentValue");
		hideEle("tr3_contentValue");
	}else if(_contentValueType=="6"){
		hideEle("tr1_contentValue");
		hideEle("tr2_contentValue");
		showEle("tr3_contentValue");
	}else{
		showEle("tr1_contentValue");
		hideEle("tr2_contentValue");
		hideEle("tr3_contentValue");
	}
	if(_contentValueType=="2" || _contentValueType=="3"){
		showEle("td_parameter");
	}else{
		hideEle("td_parameter");
	}
	if(clearContentValue){
		jQuery("#contentValue").val("");
		jQuery("#parameter").val("");
	}
	checkinput("contentValue","contentValueSpan");

	jQuery("#contentValue0").hide();
	jQuery("#contentValue1").hide();
	jQuery("#contentValue2").hide();
	jQuery("#contentValue3").hide();
	jQuery("#contentValue"+_contentValueType).show();
}

//编辑
function doEditDtl(id){
	_fnaOpenDialog("/fna/fnaVoucher/fnaVoucherXmlContentDsetEdit.jsp?id="+id+"&fnaVoucherXmlId=<%=fnaVoucherXmlId %>", 
			"<%=SystemEnv.getHtmlLabelNames("93,84720",user.getLanguage()) %>", 
			700, 600);
}

//新建
function doAddDtl(){
	_fnaOpenDialog("/fna/fnaVoucher/fnaVoucherXmlContentDsetEdit.jsp?fnaVoucherXmlId=<%=fnaVoucherXmlId %>&fnaVoucherXmlContentId=<%=fnaVoucherXmlContentId %>", 
			"<%=SystemEnv.getHtmlLabelNames("365,84720",user.getLanguage()) %>", 
			700, 600);
}

//删除
function doDel_grid_dtl(_id){
	var _data = "operation=delete&id="+_id;

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/fnaVoucherXmlContentDsetOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							window._table.reLoad();
						}else{
							top.Dialog.alert(_json.msg);
						}
				    	showRightMenuIframe();
				    }catch(e1){
				    	showRightMenuIframe();
				    }
				}
			});	
		}, function(){}
	);
}

//批量删除
function batchDelDtl(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage()) %>");
		return;
	}
	var _data = "operation=batchDel&batchDelIds="+ids;
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/fnaVoucherXmlContentDsetOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							window._table.reLoad();
						}else{
							top.Dialog.alert(_json.msg);
						}
				    	showRightMenuIframe();
				    }catch(e1){
				    	showRightMenuIframe();
				    }
				}
			});	
		}, function(){}
	);
}

//新建属性
function doNewNode(){
	window.location.href = "/fna/fnaVoucher/fnaVoucherXmlView.jsp?fnaVoucherXmlId=<%=fnaVoucherXmlId %>&contentParentId=<%=fnaVoucherXmlContentId %>&isXmlContent=1&isNode=1";
}

//新建子节点
function doNewAttr(){
	window.location.href = "/fna/fnaVoucher/fnaVoucherXmlView.jsp?fnaVoucherXmlId=<%=fnaVoucherXmlId %>&contentParentId=<%=fnaVoucherXmlContentId %>&isXmlContent=1&isAttr=1";
}

//保存
function doSave(){
	try{
		var _key1 = "<%=Des.KEY1 %>";
		var _key2 = "<%=Des.KEY2 %>";
		var _key3 = "<%=Des.KEY3 %>";
		
		var fnaVoucherXmlId = null2String(jQuery("#fnaVoucherXmlId").val());
		var fnaVoucherXmlContentId = null2String(jQuery("#fnaVoucherXmlContentId").val());
		var isXmlContent = null2String(jQuery("#isXmlContent").val());

		var xmlName = null2String(jQuery("#xmlName").val());
		var xmlEncoding = null2String(jQuery("#xmlEncoding").val());
		var xmlVersion = null2String(jQuery("#xmlVersion").val());
		var xmlMemo = null2String(jQuery("#xmlMemo").val());
		var workflowid = null2String(jQuery("#workflowid").val());
		var interfacesAddress = null2String(jQuery("#interfacesAddress").val());
		var datasourceid = null2String(jQuery("#datasourceid").val());
		
		if(xmlName==""){
			top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("195,81909",user.getLanguage())%>");
			return;
		}
		if(xmlVersion==""){
			top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("567,81909",user.getLanguage())%>");
			return;
		}

		interfacesAddress = strEnc(interfacesAddress,_key1,_key2,_key3);
		datasourceid = strEnc(datasourceid,_key1,_key2,_key3);

		var _data = "operation=save_fnaVoucherXml&fnaVoucherXmlId="+fnaVoucherXmlId+"&fnaVoucherXmlContentId="+fnaVoucherXmlContentId+"&isXmlContent="+isXmlContent+
			"&xmlName="+(xmlName)+"&xmlEncoding="+(xmlEncoding)+"&xmlVersion="+(xmlVersion)+"&xmlMemo="+(xmlMemo)+
			"&workflowid="+workflowid+"&interfacesAddress="+interfacesAddress+"&datasourceid="+datasourceid+
			"";

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/fnaVoucher/fnaVoucherOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						//top.Dialog.alert(_json.msg);
						try{window.parent.parent.tabcontentframe.window._table.reLoad();}catch(e2){}
						window.parent.location.href = "/fna/fnaVoucher/fnaVoucherXml.jsp?fnaVoucherXmlId="+_json.fnaVoucherXmlId;
					}else{
						top.Dialog.alert(_json.msg);
					}
			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
		alert(e1);
	}
}

//保存
function doSaveContent(){
	try{
		var fnaVoucherXmlId = null2String(jQuery("#fnaVoucherXmlId").val());
		var fnaVoucherXmlContentId = null2String(jQuery("#fnaVoucherXmlContentId").val());
		var isXmlContent = null2String(jQuery("#isXmlContent").val());

		var contentParentId = null2String(jQuery("#contentParentId").val());
		var contentType = null2String(jQuery("#contentType").val());
		var contentName = null2String(jQuery("#contentName").val());
		var contentValueType = null2String(jQuery("#contentValueType").val());
		var contentValue = null2String(jQuery("#contentValue").val());
		var parameter = null2String(jQuery("#parameter").val());
		var orderId = null2String(jQuery("#orderId").val());
		var contentMemo = null2String(jQuery("#contentMemo").val());
		var isNullNotPrint = jQuery("#isNullNotPrint").attr("checked")?"1":"0";
		var isNullNotPrintNode = null2String(jQuery("#isNullNotPrintNode").val());
		var contentValueForContentValueType4 = null2String(jQuery("select[name=contentValueForContentValueType4_0]").val());
		var contentValueForContentValueType6 = null2String(jQuery("select[name=contentValueForContentValueType6]").val());
		
		if(contentName==""){
			top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("15070,81909",user.getLanguage())%>");
			return;
		}
		if(contentValueType=="4"){
			if(contentValueForContentValueType4==""){
				top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("84707,81909",user.getLanguage())%>");
				return;
			}
		}else if(contentValueType=="5"){
		}else if(contentValueType=="6"){
			if(contentValueForContentValueType6==""){
				top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("84707,81909",user.getLanguage())%>");
				return;
			}
		}else if(contentValueType!="0"){
			if(contentValue==""){
				top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("84707,81909",user.getLanguage())%>");
				return;
			}
		}
		if(orderId==""){
			top.Dialog.alert("XML <%=SystemEnv.getHtmlLabelNames("15513,81909",user.getLanguage())%>");
			return;
		}

		var _key1 = "<%=Des.KEY1 %>";
		var _key2 = "<%=Des.KEY2 %>";
		var _key3 = "<%=Des.KEY3 %>";
		contentValue = strEnc(contentValue,_key1,_key2,_key3);
		parameter = strEnc(parameter,_key1,_key2,_key3);

		var _data = "operation=save_fnaVoucherXmlContent&fnaVoucherXmlId="+fnaVoucherXmlId+"&fnaVoucherXmlContentId="+fnaVoucherXmlContentId+"&isXmlContent="+isXmlContent+
			"&contentParentId="+contentParentId+"&contentType="+(contentType)+"&contentName="+(contentName)+"&contentValueType="+(contentValueType)+
			"&contentValue="+(contentValue)+"&parameter="+(parameter)+"&orderId="+(orderId)+"&contentMemo="+(contentMemo)+
			"&contentValueForContentValueType4="+contentValueForContentValueType4+"&contentValueForContentValueType6="+contentValueForContentValueType6+
			"&isNullNotPrint="+isNullNotPrint+"&isNullNotPrintNode="+isNullNotPrintNode+
			"";

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/fnaVoucher/fnaVoucherOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						//top.Dialog.alert(_json.msg);
						try{window.parent.parent.tabcontentframe.window._table.reLoad();}catch(e2){}
						window.parent.leftframe.do_reAsyncChildNodes(_json.fnaVoucherXmlId+"_"+_json.parentFnaVoucherXmlContentId, 
								_json.fnaVoucherXmlId+"_"+_json.parentFnaVoucherXmlContentId,
								_json.fnaVoucherXmlId+"_"+_json.fnaVoucherXmlContentId);
						window.location.href = "/fna/fnaVoucher/fnaVoucherXmlView.jsp"+
							"?fnaVoucherXmlId="+_json.fnaVoucherXmlId+"&fnaVoucherXmlContentId="+_json.fnaVoucherXmlContentId+
							"&isXmlContent=1";
					}else{
						top.Dialog.alert(_json.msg);
					}
			    }catch(e1){
			    }
			}
		});	
	}catch(e1){
		alert(e1);
	}
}

function doDelContent(){
	var _data = "operation=delete_fnaVoucherXmlContent&fnaVoucherXmlId=<%=fnaVoucherXmlId %>&fnaVoucherXmlContentId=<%=fnaVoucherXmlContentId %>";

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/fnaVoucherOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							try{window.parent.parent.tabcontentframe.window._table.reLoad();}catch(e2){}
							window.parent.leftframe.do_reAsyncChildNodes(_json.fnaVoucherXmlId+"_"+_json.parentFnaVoucherXmlContentId, 
									_json.fnaVoucherXmlId+"_"+_json.parentFnaVoucherXmlContentId, 
									_json.fnaVoucherXmlId+"_"+_json.fnaVoucherXmlContentId);
							if(_json.parentFnaVoucherXmlContentId==0){
								window.location.href = "/fna/fnaVoucher/fnaVoucherXmlView.jsp"+
									"?fnaVoucherXmlId="+_json.fnaVoucherXmlId;
							}else{
								window.location.href = "/fna/fnaVoucher/fnaVoucherXmlView.jsp"+
									"?fnaVoucherXmlId="+_json.fnaVoucherXmlId+"&fnaVoucherXmlContentId="+_json.parentFnaVoucherXmlContentId+
									"&isXmlContent=1";
							}
						}else{
							top.Dialog.alert(_json.msg);
						}
				    	showRightMenuIframe();
				    }catch(e1){
				    	showRightMenuIframe();
				    }
				}
			});	
		}, function(){}
	);
}

//删除
function doDel(){
	var _data = "operation=delete_fnaVoucherXml&id=<%=fnaVoucherXmlId %>";

	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/fnaVoucher/fnaVoucherOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							try{window.parent.parent.tabcontentframe.window._table.reLoad();}catch(e2){}
							dialog.closeByHand();
						}else{
							top.Dialog.alert(_json.msg);
						}
				    	showRightMenuIframe();
				    }catch(e1){
				    	showRightMenuIframe();
				    }
				}
			});	
		}, function(){}
	);
}

</script>
</BODY>
</HTML>