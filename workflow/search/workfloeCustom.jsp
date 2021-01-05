
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ page import="java.util.*" %>
<html><head>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />

		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<META HTTP-EQUIV="pragma" CONTENT="no-cache"> 
	</head>
  <body>
	<%
		String custom_id=Util.null2String(request.getParameter("custom_id"));
	//测试	custom_id="13";
		String name="";
		String value="";
		String opt="";
	%>
	<table class="viewform">
		<colgroup>
			<col width="10%">
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="5%">
			<col width="10%">
			<col width="10%">
			<col width="20%">
			<col width="10%">
		<%		
			rs.executeSql("select workflow_formfield.fieldid,workflow_formdict.fieldname,WorkFlow_FieldLable.fieldlable,workflow_formdict.fielddbtype,workflow_formdict.fieldhtmltype,workflow_formdict.type from workflow_formdict,workflow_formfield,WorkFlow_FieldLable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid =workflow_formfield.fieldid and  workflow_formdict.id = workflow_formfield.fieldid and workflow_formfield.formid in ( select formID from Workflow_Custom where id="+custom_id+")");
			
			int custom_i=0;
			int custom_num=0;//浏览按钮计数
			while(rs.next()){
				//有查询条件
				String fieldname=rs.getString("fieldname");//表单自定义数据库字段名
				String fieldhtmltype=rs.getString("fieldhtmltype");
				String type=rs.getString("type");
				String fieldid=rs.getString("fieldid");
				String fielddbtype=rs.getString("fielddbtype");
				if(custom_i==2){
					custom_i=0;
		%>
					</tr>
					<TR style="height:1px;">
						<TD class=Line colSpan=9></TD>
					</TR>
		<%
				}
				if(custom_i==0){
		%>
					<tr>
		<%	
				}
		%>
			<td><%=rs.getString("fieldlable")%></td>
			<td class=field colSpan=3>
		<%
			if((fieldhtmltype.equals("1")&&type.equals("1"))||fieldhtmltype.equals("2")){
				//单行文本框 || 多行文本框
				//都是文本
				opt=Util.null2String(request.getParameter(fieldname+"_opt"));
				if(fieldhtmltype.equals("2")){
					if(opt.equals("")){
						opt="3";
					}
				}else{
					if(opt.equals("")){
						opt="1";
					}
				}
				value=Util.null2String(request.getParameter(fieldname+"_value"));
		%>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<%if(!fieldhtmltype.equals("2")){%>
					<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
					<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
				<%}%>
					<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
					<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->
			</select>
			<input type='text' style="width:50%" name="<%=fieldname%>_value" value="<%=value%>"/>
		<%
			}else if(fieldhtmltype.equals("1")){
				//单行文本框  整数、浮点
				opt=Util.null2String(request.getParameter(fieldname+"_01opt"));
				if(opt.equals("")){
					opt="1";
				}
				value=Util.null2String(request.getParameter(fieldname+"_01value"));
		%>
			<select class=inputstyle  name="<%=fieldname%>_01opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!--大于-->
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!--大于等于-->
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!--小于-->
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<input type=text size=10 name="<%=fieldname%>_01value" value="<%=value%>"/>
		<%
				opt=Util.null2String(request.getParameter(fieldname+"_02opt"));
				if(opt.equals("")){
					opt="3";
				}
				value=Util.null2String(request.getParameter(fieldname+"_02value"));	
		%>
			<select class=inputstyle  name="<%=fieldname%>_02opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<input type=text size=10 name="<%=fieldname%>_02value" value="<%=value%>"/>
	<%		
		}else if(fieldhtmltype.equals("3")){
			//浏览按钮
			if(type.equals("1")){//人力资源	
				opt=Util.null2String(request.getParameter(fieldname+"_opt"));
				if(opt.equals("")){
					opt="1";
				}
				value=Util.null2String(request.getParameter(fieldname+"_value"));
				name=Util.null2String(request.getParameter(fieldname+"_name"));	
	%>	
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90">
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!--被包含于-->
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!--不被包含于-->
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser2('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp',<%=type%>,<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name" class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("9")){
			//浏览框单文挡  条件为多文挡 (like not lik)
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
				if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));	
%>			
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser2('/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp',<%=type%>,<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("4")){
			//浏览框单部门  条件为多部门 (like not lik)
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));	
%>			
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser2('/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp',<%=type%>,<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("7")){
			//浏览框单客户  条件为多客户 (like not lik)
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser2('/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp',<%=type%>,<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("8")){
			//浏览框单项目  条件为多项目 (like not lik)
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser2('/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp',<%=type%>,<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>	
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("16")){
			//浏览框单请求  条件为多请求 (like not lik)
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowser2('/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp',<%=type%>,<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>	
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%			
		//	custom_num++;
		}else if(type.equals("24")){
			//职位的安全级别
			opt=Util.null2String(request.getParameter(fieldname+"_01opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_01value"));
%>
			<select class=inputstyle  name="<%=fieldname%>_01opt" style="width:90"  >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<input type=text class=InputStyle size=10 name="<%=fieldname%>_01value" value="<%=value%>"/>
<%
			opt=Util.null2String(request.getParameter(fieldname+"_02opt"));
			if(opt.equals("")){
					opt="3";
				}
			value=Util.null2String(request.getParameter(fieldname+"_02value"));			
%>
			<select class=inputstyle  name="<%=fieldname%>_02opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<input type=text class=InputStyle size=10 name="<%=fieldname%>_02value" value="<%=value%>" />
<%
		}else if(type.equals("2")){
				//日期
			opt=Util.null2String(request.getParameter(fieldname+"_01opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_01value"));
%>
			<select class=inputstyle  name="<%=fieldname%>_01opt" style="width:90">
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<button type=button  class=calendar
			 onclick="onSearchWFQTDate('<%=fieldname%>_01valuespan','<%=fieldname%>_01value','<%=fieldname%>_02value')" ></button>
			 <input type=hidden name="<%=fieldname%>_01value" value="<%=value%>"/>
			 <span name="<%=fieldname%>_01valuespan" id="<%=fieldname%>_valuespan"><%=value%></span>
			<%
				opt=Util.null2String(request.getParameter(fieldname+"_02opt"));
				if(opt.equals("")){
					opt="3";
				}
				value=Util.null2String(request.getParameter(fieldname+"_02value")); 
			%>
			 <select class=inputstyle  name="<%=fieldname%>_02opt" style="width:90">
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<button type=button  class=calendar
			 onclick="onSearchWFQTDate('<%=fieldname%>_02value1span','<%=fieldname%>_02value1','<%=fieldname%>_01value')"
			  ></button>
			<input type=hidden name="<%=fieldname%>_02value" value="<%=value%>">
			<span name="<%=fieldname%>_02value1span" id="<%=fieldname%>_02value1span"><%=value%></span>
<%
		}else if(type.equals("19")){
			//时间
			opt=Util.null2String(request.getParameter(fieldname+"_01opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_01value"));
%>
			<select class=inputstyle  name="<%=fieldname%>_01opt" style="width:90">
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<button type=button  class=calendar
			 onclick="onSearchWFQTTime('<%=fieldname%>_01valuespan','<%=fieldname%>_01value','<%=fieldname%>_02value')" ></button>
			 <input type=hidden name="<%=fieldname%>_01value" value="<%=value%>"/>
			 <span name="<%=fieldname%>_01valuespan" id="<%=fieldname%>_valuespan"><%=value%></span>
			 <%
				opt=Util.null2String(request.getParameter(fieldname+"_02opt"));
				if(opt.equals("")){
					opt="3";
				}
				value=Util.null2String(request.getParameter(fieldname+"_02value"));
			 %>
			 <select class=inputstyle  name="<%=fieldname%>_02opt" style="width:90">
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
				<option value="3" <%if(opt.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
				<option value="4" <%if(opt.equals("4")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
				<option value="5" <%if(opt.equals("5")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="6" <%if(opt.equals("6")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			<button type=button  class=calendar
			 onclick="onSearchWFQTTime('<%=fieldname%>_02value1span','<%=fieldname%>_02value1','<%=fieldname%>_01value')"
			  ></button>
			<input type=hidden name="<%=fieldname%>_02value" value="<%=value%>">
			<span name="<%=fieldname%>_02value1span" id="<%=fieldname%>_02value1span"><%=value%></span>
<%											  
		}else if(type.equals("17")){
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>			
			<span>
				<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
					<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!--包含-->
					<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp',<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>	
			-->
			<span>
			 <brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="130px" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=name%>'> 
			 </brow:browser>
			 <input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%	  
			//custom_num++;
		}else if(type.equals("37")){
			//浏览框  多选筐条件为单选筐(多文挡)
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>			
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
		<!--	
			<button type=button  class=Browser  onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1',<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
		-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
			//custom_num++;
		}else if(type.equals("57")){
			//浏览框  多选筐条件为单选筐（多部门）
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp',<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" _callback="databack" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%				
		//	custom_num++;
		}else if(type.equals("135")){
			//浏览框  多选筐条件为单选筐（多项目）
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp',<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%			
		//	custom_num++;
		}else if(type.equals("152")){
			//浏览框  多选筐条件为单选筐（多请求）
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp',<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp" hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("18")){
			//浏览框  多选筐条件为单选筐
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp',<%=custom_num%>)"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%			
		//	custom_num++;
		}else if(type.equals("160")){
			//浏览框  多选筐条件为单选筐
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser  onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=custom_num%>')"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%	
		//	custom_num++;
		}else if(type.equals("142")){
			//浏览框多收发文单位
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp','<%=custom_num%>')"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp" hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137")){
			//浏览框
			String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowser('<%=urls%>','<%=custom_num%>')"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl='<%=urls%>' hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else if(type.equals("161") || type.equals("162")){
			String urls=BrowserComInfo.getBrowserurl(type)+"?type="+fielddbtype;     // 浏览按钮弹出页面的url
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowserCustom('<%=urls%>',<%=custom_num%>,'<%=type%>')"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl='<%=urls%>' hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}else{
			String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
			opt=Util.null2String(request.getParameter(fieldname+"_opt"));
			if(opt.equals("")){
					opt="1";
				}
			value=Util.null2String(request.getParameter(fieldname+"_value"));
			name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
			<span>
			<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
				<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
				<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
			</select>
			</span>
			<!--
			<button type=button  class=Browser onclick="onShowBrowser('<%=urls%>','<%=custom_num%>')"></button>
			<input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			<span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
			-->
			<span>
			<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl='<%=urls%>' hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
			<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
			</span>
<%
		//	custom_num++;
		}
	}else if(fieldhtmltype.equals("4")){
		//Check框
		value=Util.null2String(request.getParameter(fieldname+"_value"));
%>
		<input type=checkbox value=1 name="<%=fieldname%>_value" <%if(value.equals("1")){%>checked<%}%>/>
<%
	}else if(fieldhtmltype.equals("5")){
		//选择框
		opt=Util.null2String(request.getParameter(fieldname+"_opt"));
		if(opt.equals("")){
					opt="1";
				}
%>
		<select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
			<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
			<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
		</select>
<%
	}else if(fieldhtmltype.equals("6")){
		 //附件上传同多文挡
		 String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
		 opt=Util.null2String(request.getParameter(fieldname+"_opt"));
		 if(opt.equals("")){
					opt="1";
				}
		 value=Util.null2String(request.getParameter(fieldname+"_value"));
		 name=Util.null2String(request.getParameter(fieldname+"_name"));
%>
		<span>
		 <select class=inputstyle  name="<%=fieldname%>_opt" style="width:90" >
			<option value="1" <%if(opt.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
			<option value="2" <%if(opt.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
		 </select>
		 </span>
		 <!--
		 <button type=button  class=Browser  onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1',<%=custom_num%>)"></button>
		 <input type=hidden name="<%=fieldname%>_value" class="custom_value" value="<%=value%>"/>
		 <input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
		 <span name="<%=fieldname%>_valuespan" class="custom_valuespan"><%=name%></span>
		 -->
		<span>
		<brow:browser viewType="0" name='<%=fieldname+"_value"%>' browserValue='<%=value+""%>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="false" _callback="databack" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="130px" browserSpanValue='<%=name%>'> </brow:browser>
		<input type=hidden name="<%=fieldname%>_name"  class="custom_name" value="<%=name%>"/>
		</span>
<%
	//	custom_num++;
	}
%>
		</td>
<%
		if(custom_i<1){
%>
			<td>&nbsp;</td>
<%
		}
		custom_i++;
	}
%>
	</table>
	<script language="javascript">
		function databack(e,data,name){
		//	console.dir(data);
			name=name.replace("value", "name");
			jQuery("input[name="+name+"]").val(data.name);
		//	console.log("name:"+name);
		}

		function _userDelCallback(text,name){
			//console.log(text);
			//console.log(name);
			name=name.replace("value", "name");
			var value=jQuery("input[name="+name+"]").val();
			//console.log(value);
			var varray=value.split(",");
			value="";
			for(var i=0;i<varray.length;i++){
				if(varray[i]!=text){
					value=value+varray[i]+",";
				}
			}
			if(value!=""){
				value=value.substring(0,value.length-1);
			}
			jQuery("input[name="+name+"]").val(value);
		}
		function onShowBrowser2(url, type, tmpindex){
			var tmpids = "";
			var id1 = null;
			if (type == 8) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids);
			} else if (type == 9) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids);
			} else if (type == 1) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			} else if (type == 4) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids
						+ "&resourceids=" + tmpids);
			} else if (type == 16) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			} else if (type == 7) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			} else if (type == 142) {
				tmpids = jQuery(".custom_value")[tmpindex].value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
			}
			if (id1 != null) {
				resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					jQuery(".custom_valuespan")[tmpindex].innerHTML = resourcename;
					jQuery(".custom_value")[tmpindex].value=resourceids;
					jQuery(".custom_name")[tmpindex].value=resourcename;
				} else {
					jQuery(".custom_valuespan")[tmpindex].innerHTML = "";
					jQuery(".custom_value")[tmpindex].value = "";
					jQuery(".custom_name")[tmpindex].value = "";
				}
			}
		}
		function onSearchWFQTDate(spanname,inputname,inputname1){
			var oncleaingFun = function(){
				$(spanname).innerHTML = '';
				$(inputname).value = '';
				if($(inputname).value==""&&$(inputname1).value==""){
					document.frmmain.check_con[tmpindex*1].checked = false;
				}
			}
			var language=readCookie("languageidweaver");
			if(language==8)
				languageStr ="en";
			else if(language==9)
				languageStr ="zh-tw";
			else
				languageStr ="zh-cn";
			if(window.console){
			   //console.log("language "+language+" languageStr="+languageStr);
			}
			WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
		}
		function onSearchWFQTTime(spanname,inputname,inputname1){
			var dads  = document.all.meizzDateLayer2.style;
			setLastSelectTime(inputname);
			var th = spanname;
			var ttop  = spanname.offsetTop;
			var thei  = spanname.clientHeight;
			var tleft = spanname.offsetLeft;
			var ttyp  = spanname.type;
			while (spanname = spanname.offsetParent){
				ttop += spanname.offsetTop;
				tleft += spanname.offsetLeft;
			}
			dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
			dads.left = tleft;
			outObject = th;
			outValue = inputname;
			outButton = (arguments.length == 1) ? null : th;
			dads.display = '';
			bShow = true;
			CustomQuery=1;
			outValue1 = inputname1;
		}
		function onShowBrowser(url,index) {
			var url = url + "?selectedids=" + jQuery(".custom_value")[index].value;
			disModalDialog(url, jQuery(".custom_valuespan")[index], jQuery(".custom_value")[index], false);
			jQuery(".custom_name")[index].value = jQuery(".custom_valuespan")[index].innerHTML;
		}
		function disModalDialog(url, spanobj, inputobj, need, curl) {
			var id = window.showModalDialog(url, "",
					"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
			if (id != null) {
				if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
					if (curl != undefined && curl != null && curl != "") {
						spanobj.innerHTML = "<A href='" + curl
								+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
								+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
					} else {
						spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
					}
					inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
				} else {
					spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
					inputobj.value = "";
				}
			}
		}
		function onShowBrowserCustom( url, tmpindex, type1) {
			var id1 = window.showModalDialog(url, "", 
					"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
			if (id1 != null) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
					var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
					var names = wuiUtil.getJsonValueByIndex(id1, 1);
					var descs = wuiUtil.getJsonValueByIndex(id1, 2);
					if (type1 == 161) {
						jQuery(".custom_valuespan")[tmpindex].innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
						jQuery(".custom_value")[tmpindex].value = ids;
						jQuery(".custom_name")[tmpindex].value = names;
					}
					if (type1 == 162) {
						var sHtml = "";

						var idArray = ids.split(",");
						var curnameArray = names.split(",");
						var curdescArray = descs.split(",");

						for ( var i = 0; i < idArray.length; i++) {
							var curid = idArray[i];
							var curname = curnameArray[i];
							var curdesc = curdescArray[i];

							sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}

						jQuery(".custom_valuespan")[tmpindex].innerHTML = sHtml;
						jQuery(".custom_value")[tmpindex].value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
						jQuery(".custom_name")[tmpindex].value = wuiUtil.getJsonValueByIndex(id1, 1);
					}
				} else {
					jQuery(".custom_valuespan")[tmpindex].innerHTML = "";
					jQuery(".custom_value")[tmpindex].value = "";
					jQuery(".custom_name")[tmpindex].value = "";
				}
			}
		}
	</script>
  </body>
</html>
