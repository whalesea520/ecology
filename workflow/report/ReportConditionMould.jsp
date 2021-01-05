
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />

<HTML><HEAD>
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(15505,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(64,user.getLanguage());
String needfav ="1";
String needhelp ="";
String bclick = "";
String browserValue = "";
String browserSpanValue = "";

//报表id
int reportid = Util.getIntValue(request.getParameter("id"),0);
//模板id
int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);

String newMouldName = Util.null2String(request.getParameter("newMouldName"));
int sharelevel = 0 ;
RecordSet.executeSql("select sharelevel from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid);

if(RecordSet.next()) {
    sharelevel = Util.getIntValue(RecordSet.getString("sharelevel"),0) ;
}
else {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String sql = " select a.formid , a.isbill from Workflow_Report a " +
 " where  a.id="+reportid ;

RecordSet.execute(sql) ;
RecordSet.next() ;

String isbill = Util.null2String(RecordSet.getString("isbill"));
int formid = Util.getIntValue(RecordSet.getString("formid"),0);


List ids = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();

RecordSet.execute("select fieldId,isShow,isCheckCond,colName,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond from WorkflowRptCondMouldDetail where mouldId="+mouldId) ;

while(RecordSet.next()){
	ids.add(Util.null2String(RecordSet.getString("fieldId")));
	isShows.add(Util.null2String(RecordSet.getString("isShow")));
	isCheckConds.add(Util.null2String(RecordSet.getString("isCheckCond")));
	colnames.add(Util.null2String(RecordSet.getString("colName")));
	opts.add(Util.null2String(RecordSet.getString("optionFirst")));
	values.add(Util.null2String(RecordSet.getString("valueFirst")));
	names.add(Util.null2String(RecordSet.getString("nameFirst")));
	opt1s.add(Util.null2String(RecordSet.getString("optionSecond")));
	value1s.add(Util.null2String(RecordSet.getString("valueSecond")));
}


//获得报表显示项

String strReportDspField=",";
String fieldId="";
RecordSet.execute("select fieldId from Workflow_ReportDspField where reportId="+reportid) ;

while(RecordSet.next()){
	fieldId=RecordSet.getString(1);
	if(fieldId!=null&&!fieldId.equals("")){
		strReportDspField+=fieldId+",";
	}
}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//把SearchForm.reset() 改成document.SearchForm().reset() 解决在火狐清空右键菜单不起作用的原因
//RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:resetform(),_self} ";
//RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEditSaveTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;


RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:addTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDeleteTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ReportResult.jsp?&searchByMould=1" method="post">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=reportid value="<%=reportid%>">
<input type=hidden name=mouldId value="<%=mouldId%>">
<input type=hidden name=newMouldName value="<%=newMouldName%>">

<input type=hidden name=operation>

<!--  -->
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>"  class="e8_btn_top" onclick="submit()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"  class="e8_btn_top" onclick="onEditSaveTemplate()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"  class="e8_btn_top" onclick="addTemplate()" >
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<select class="templatetype" id="templatetype" name="templatetype"   onChange="onchangeselect()">
	       		<option value="1" ><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></option>
			<%
	int tempMouldId=-1;
	String tempMouldName="";

    RecordSet.executeSql("select id,mouldName from WorkflowRptCondMould where userId="+user.getUID()+" and reportId="+reportid+" order by id asc");
	
	while(RecordSet.next()){
		tempMouldId=Util.getIntValue(RecordSet.getString(1),0);
		tempMouldName=Util.null2String(RecordSet.getString(2));

%>
	       		<option value="<%=tempMouldId %>" <%if(mouldId == tempMouldId){%>selected<%} %>><%=tempMouldName %></option>
<%
	}

%>
     		</select>	
		</wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">


<wea:layout type='table' attributes="{'cols':'4','cws':'10%,10%,20%,60%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(33541,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
		<%
//如果模板中未保存相关信息则不显示
if(ids.indexOf("-1")>-1){
%>
		<wea:item><%
		if(strReportDspField.indexOf(",-1,")>-1){
		%>
	  	<input type="checkbox" name="requestNameIsShow"  value="1" checked
	  	<%
	    if((ids.indexOf("-1")!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
%>
	checked 
<%
	    }
%>
	  	>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
			<input type="checkbox" name="requestname_check_con"  value="1" 
			<%
	   		 if((ids.indexOf("-1")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
			%>
			checked 
			<%
	  		  }
			%>
			>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
		<wea:item>
			<select class="inputstyle" name="requestname"   onfocus="changeclick1()">
        		<option value="1"  <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="2"  <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("2")){%> selected <%}%>  ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        		<option value="3"   <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="4"  <%if((ids.indexOf("-1")!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("4")){%> selected <%}%>  ><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		<input type=text class=inputstyle style="width:150px;" name="requestnamevalue" onfocus="changeclick1()"  <%if(ids.indexOf("-1")!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf("-1"))))%><%}%>> 
      </wea:item>
      <%
}//if(ids.indexOf("-1")>-1),如果模板中未保存相关信息则不显示

//如果模板中未保存相关信息则不显示
if(ids.indexOf("-2")>-1){

%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-2,")>-1){
		%>
		<input type="checkbox" name="requestLevelIsShow"  value="1" checked
		<%
	    if((ids.indexOf("-2")!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
%>
	checked 
<%
	    }
%>
		>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="requestlevel_check_con"  value="1" 
		<%
	    if((ids.indexOf("-2")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
%>
	checked 
<%
	    }
%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
		<wea:item>
			<select class="inputstyle" name="requestlevelvalue"   onfocus="changeclick2()">
        <option value="0"   <%if((ids.indexOf("-2")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
        <option value="1"<%if((ids.indexOf("-2")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
        <option value="2"<%if((ids.indexOf("-2")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
      </select>
		</wea:item>
		
<%-- --%>
	<!-- 创建人 -->
<%
}
if(ids.indexOf("-10")>-1){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-10,")>-1){
		%>
		<input type="checkbox" name="createmanIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="createman_check_con"  value="1" 
			<%
	   		 if((ids.indexOf("-10")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("1")){
			%>
			checked 
			<%
	  		  }
			%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		<wea:item>
		<div style="float:left;">
			<select class=inputstyle name="createmanselected" >
        		<option value="1" <%if((ids.indexOf("-10")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        		<option value="2" <%if((ids.indexOf("-10")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
      		</select>
      		</div>
      		<%
      		   bclick = "onShowBrowser('-10','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
	           browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-10"))));
	           browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-10"))));
	        %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name="con-10_value" 
	          	  browserValue='<%=browserValue%>'
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle="true" 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl()"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      	
      		<input type=hidden name="con-10_value" id="con-10_value" <%if(ids.indexOf("-10")!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf("-10"))))%> <%}%>>
      		<input type=hidden name="con-10_name" id="con-10_name" <%if(ids.indexOf("-10")!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf("-10"))))%> <%}%>>

		</wea:item>
		<!-- 创建日期 -->
<%
}
if(ids.indexOf("-11")>-1){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-11,")>-1){
		%>
		<input type="checkbox" name="createdateIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
			<input type="checkbox" name="createdate_check_con"  value="1" 
			<%
	   		 if((ids.indexOf("-11")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-11")))).equals("1")){
			%>
			checked 
			<%
	  		  }
			%>
			>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
		<wea:item>
		<%
		   String createdate =  values.get(Util.getIntValue(""+ids.indexOf("-11"))).toString();
			String createdateend = value1s.get(Util.getIntValue(""+ids.indexOf("-11"))).toString();
		%>
		<span class="wuiDateSpan" selectId="createdatespan" onclick="changecreatedate()" selectValue="">
			<input class=wuiDateSel type="hidden" name="createdate" <% if(!"".equals(createdate)){%>value="<%=createdate%>" <%}else{ %>value="" <%} %>>
			<input class=wuiDateSel type="hidden" name="createdateend" <% if(!"".equals(createdateend)){%>value="<%=createdateend%>" <%}else{ %> value="" <%} %>>
		</span>
		<%--
		<button type=button  type=button class=calendar id=SelectCreateDate onfocus="changeclick4()" onclick="gettheDate(createdate,createdatespan)"></BUTTON>&nbsp;
    	<SPAN id=createdatespan name="createdatespan"><%=values.get(Util.getIntValue(""+ids.indexOf("-11")))%></SPAN>
    	<input type="hidden" name="createdate" class=Inputstyle value="<%=values.get(Util.getIntValue(""+ids.indexOf("-11")))%>">
		 --%>
		</wea:item>
		<!--  -->
		<!-- 工作流 -->
<%
}
if(ids.indexOf("-12")>-1){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-12,")>-1){
		%>
		<input type="checkbox" name="workflowtoIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
			<input type="checkbox" name="workflowto_check_con"  value="1" 
			<%
	   		 if((ids.indexOf("-12")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-12")))).equals("1")){
			%>
			checked 
			<%
	  		  }
			%>
			>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%></wea:item>
		<wea:item>
      		<%
      		bclick = "onShowBrowser('-12','/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WFTypeBrowserContenter.jsp')";
	         browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-12"))));
	         browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-12"))));
	         String compurl = "javascript:getajaxurl('workflowBrowser')";
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name="con-12_value" 
	          browserValue='<%=browserValue%>'
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle="true" 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%=compurl%>' 
		          needHidden="false" ></brow:browser>
      		<input type=hidden name="con-12_value" id="con-12_value" <%if(ids.indexOf("-12")!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf("-12"))))%> <%}%>>
      		<input type=hidden name="con-12_name"  id="con-12_name" <%if(ids.indexOf("-12")!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf("-12"))))%> <%}%>>
		</wea:item>
		<!--  -->
		<!-- 当前节点 -->
<%
}
if(ids.indexOf("-13")>-1){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-12,")>-1 && strReportDspField.indexOf(",-13,")>-1){
		%>
		<input type="checkbox" name="currentnodeIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
			<input type="checkbox" name="currentnode_check_con"  value="1" 
			<%
	   		 if((ids.indexOf("-13")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-13")))).equals("1")){
			%>
			checked 
			<%
	  		  }
			%>
			>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18564,user.getLanguage())%></wea:item>
		<wea:item>
		<%
		bclick = "onShowBrowser2('-13','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')";
        browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-13"))));
	        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-13"))));
	        String compurl2 = "javascript:getajaxurl('currentnodeBrowser')";
	        %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name="con-13_value" 
	          browserValue='<%=browserValue%>'
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle="true" 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%=compurl2%>' 
		          needHidden="false" ></brow:browser>
      		
      		<input type=hidden name="con-13_value" id="con-13_value" <%if(ids.indexOf("-13")!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf("-13"))))%> <%}%>>
      		<input type=hidden name="con-13_name" id="con-13_name" <%if(ids.indexOf("-13")!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf("-13"))))%> <%}%>>
     		 
		</wea:item>
		<!--  -->
		<!-- 接收日期 -->
		<%--
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-14,")>-1){
		%>
		<input type="checkbox" name="receivedateIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item><input type="checkbox" name="receivedate_check_con"  value="1" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></wea:item>
		<wea:item>
		<button type=button  type=button class=calendar id=receivedateBt onfocus="changeclick4()" onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
    	<SPAN id=receivedatespan ></SPAN>
		</wea:item>
		 --%>
		<!--  -->
		<!-- 未操作者 -->
<%
}
if(ids.indexOf("-15")>-1){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-15,")>-1){
		%>
		<input type="checkbox" name="nooperatorIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item>
			<input type="checkbox" name="nooperator_check_con"  value="1" 
						<%
	   		 if((ids.indexOf("-15")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-15")))).equals("1")){
			%>
			checked 
			<%
	  		  }
			%>
			>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%></wea:item>
		<wea:item>
		<div style="float:left;">
			<select class=inputstyle name="nooperator_opt">
            	<option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            	<option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
			</select>
      		</div>
      		<%
	           bclick = "onShowBrowser2('-15','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')";
	      		browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-15"))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-15"))));
	          %>
      		 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name="con-15_value" 
	          	  browserValue='<%=browserValue%>'
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle="false" 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl()"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
      		
      		<input type=hidden name="con-15_value" id="con-15_value" <%if(ids.indexOf("-15")!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf("-15"))))%> <%}%>>
      		<input type=hidden name="con-15_name" id="con-15_name" <%if(ids.indexOf("-15")!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf("-15"))))%> <%}%>>
     		
		</wea:item>
		<!--  -->
		<!-- 流程状态 -->
<%
}
if(ids.indexOf("-16")>-1){
%>
		<wea:item>

		</wea:item>
		<wea:item><input type="checkbox" name="workfolwtype_check_con"  value="1" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31485,user.getLanguage())%></wea:item>
		<wea:item>
		<select class=inputstyle name="workfolwtype_opt" >
            <option value="1"><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
            <option value="2"><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></option>
		</select>
		</wea:item>
		<!--  -->
		<!-- 签字意见 -->
		<%-- 
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-17,")>-1){
		%>
		<input type="checkbox" name="signopinionsIsShow"  value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item><input type="checkbox" name="signopinions_check_con"  value="1" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(30435,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="signopinions_check_select"  value="1" >
			不显示空意见
		</wea:item>
		--%>
		<!-- -->	
		
<%-- --%>
		
		<%
}//if(ids.indexOf("-2")>-1),如果模板中未保存相关信息则不显示

//如果模板中未保存相关信息则不显示
if(ids.indexOf("-3")>-1){

%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-3,")>-1){
		%>
			<input type="checkbox" name="requestStatusIsShow"  value="1" 
<%
	    if((ids.indexOf("-3")!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("1")){
%>
	checked 
<%
	    }
%>
>
		<%
    		}
		%>	  
		</wea:item>
		<wea:item>
		<input type="checkbox" name="requeststatus_check_con"  value="1" 
		<%
	    if((ids.indexOf("-3")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("1")){
%>
	checked 
<%
	    }
%>	
		
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			      <select class="inputstyle" name="requeststatusvalue"   onfocus="changeclick3()">
        <option value="1" <%if((ids.indexOf("-3")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
        <option value="2"<%if((ids.indexOf("-3")!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf("-3")))).equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
      </select>
		</wea:item>
<%
}//if(ids.indexOf("-3")>-1),如果模板中未保存相关信息则不显示

%>
<%
	if(ids.indexOf("-4")>-1){
%>   
		<wea:item></wea:item>
		<wea:item>
		<input type='checkbox' name='archiveTime' value="1" 
		<%
	    if((ids.indexOf("-4")!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-4")))).equals("1")){
%>
	checked 
<%
	    }
%>	  
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19736,user.getLanguage())%></wea:item>
		<wea:item>
		<BUTTON type='button' class=calendar id=SelectDate onfocus="changeclick4()" onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=values.get(Util.getIntValue(""+ids.indexOf("-4")))%></SPAN>
    -&nbsp;&nbsp;<BUTTON type='button' class=calendar id=SelectDate2 onfocus="changeclick4()" onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
    <SPAN id=todatespan ><%=value1s.get(Util.getIntValue(""+ids.indexOf("-4")))%></SPAN>
	  <input type="hidden" name="fromdate" class=Inputstyle value="<%=values.get(Util.getIntValue(""+ids.indexOf("-4")))%>">
	  <input type="hidden" name="todate" class=Inputstyle value="<%=value1s.get(Util.getIntValue(""+ids.indexOf("-4")))%>">
		</wea:item>
<%}%>			

		<%
		  //获取用户语言，默认为7
		    int userLanguage = user.getLanguage();
		    userLanguage = (userLanguage == 0) ? 7 : userLanguage;
		    
			int linecolor=0;
			sql="";
		
		if(isbill.equals("0")){
			StringBuffer sqlSB = new StringBuffer();
			sqlSB.append("   Select bf.* from                                               \n");
			sqlSB.append("     (select t1.fieldid as id,                                    \n");
			sqlSB.append("             (select distinct fieldname                           \n");
			sqlSB.append("                from workflow_fieldlable t3                       \n");
			sqlSB.append("               where t3.formid = t1.formid                        \n");
			sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
			sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
			sqlSB.append("             (select distinct t3.fieldlable as label              \n");
			sqlSB.append("                from workflow_fieldlable t3                       \n");
			sqlSB.append("               where t3.formid = t1.formid                        \n");
			sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
			sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
			sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
			sqlSB.append("             t2.type as type,                                     \n");
			sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
			sqlSB.append("             1 as ismain,                            				\n");
			sqlSB.append("             NULL as groupid                                      \n");
			sqlSB.append("        from workflow_formfield t1, workflow_formdict t2          \n");
			sqlSB.append("       where t2.id = t1.fieldid                                   \n");
			sqlSB.append("         and t1.formid = " + formid + "                           \n");
			sqlSB.append("         and (t1.isdetail <> '1' or t1.isdetail is null)          \n");
			sqlSB.append("      UNION                                                       \n");
			sqlSB.append("      select t1.fieldid as id,                                    \n");
			sqlSB.append("             (select distinct fieldname                           \n");
			sqlSB.append("                from workflow_fieldlable t3                       \n");
			sqlSB.append("               where t3.formid = t1.formid                        \n");
			sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
			sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
			sqlSB.append("             (select distinct t3.fieldlable                       \n");
			sqlSB.append("                from workflow_fieldlable t3                       \n");
			sqlSB.append("               where t3.formid = t1.formid                        \n");
			sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
			sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
			sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
			sqlSB.append("             t2.type as type,                                     \n");
			sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
			sqlSB.append("             0 as ismain,                            				\n");
			sqlSB.append("             t1.groupid                                           \n");
			sqlSB.append("        from workflow_formfield t1, workflow_formdictdetail t2    \n");
			sqlSB.append("       where t2.id = t1.fieldid                                   \n");
			sqlSB.append("         and t1.formid = " + formid + "                           \n");
			sqlSB.append("         and (t1.isdetail = '1' or t1.isdetail is not null)) bf   \n");
			sqlSB.append("   left join (Select * from Workflow_ReportDspField               \n");
			sqlSB.append("                    where reportid = " + reportid + " ) rf        \n");
			sqlSB.append("   on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)               \n");
			sqlSB.append("   order by rf.dsporder                                           \n");
			sql = sqlSB.toString();
		} else if(isbill.equals("1")){
			StringBuffer sqlSB = new StringBuffer();
			sqlSB.append("  select bf.* from (                              \n");
			sqlSB.append("    select wfbf.id            as id,              \n");
			sqlSB.append("           wfbf.fieldname     as name,            \n");
			sqlSB.append("           wfbf.fieldlabel    as label,           \n");
			sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
			sqlSB.append("           wfbf.type          as type,            \n");
			sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
			sqlSB.append("           wfbf.viewtype      as viewtype,        \n");
			sqlSB.append("           wfbf.dsporder      as dsporder,        \n");
			sqlSB.append("           wfbf.detailtable   as detailtable      \n");
			sqlSB.append("      from workflow_billfield wfbf                \n");
			sqlSB.append("     where wfbf.billid = " + formid + " AND wfbf.viewtype = 0               \n");
			sqlSB.append("    Union                                         \n");
			sqlSB.append("    select wfbf.id            as id,              \n");
			sqlSB.append("           wfbf.fieldname     as name,            \n");
			sqlSB.append("           wfbf.fieldlabel    as label,           \n");
			sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
			sqlSB.append("           wfbf.type          as type,            \n");
			sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
			sqlSB.append("		     wfbf.viewtype      as viewtype,        \n");
			sqlSB.append("		     wfbf.dsporder+100  as dsporder,        \n");
			sqlSB.append("           wfbf.detailtable   as detailtable      \n");
			sqlSB.append("		from workflow_billfield wfbf                \n");
			sqlSB.append("	   where wfbf.billid = " + formid + " AND wfbf.viewtype = 1               \n");
			sqlSB.append("  ) bf left join (Select fieldid,dsporder,fieldidbak                        \n");
			sqlSB.append("      from Workflow_ReportDspField  where reportid = " + reportid + ") rf   \n");
			sqlSB.append("      on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)                      \n");
			sqlSB.append("   order by rf.dsporder, bf.dsporder,   bf.detailtable                      \n");
			sql = sqlSB.toString();
		}
		RecordSet.executeSql(sql);
		int tmpcount = 0;
		while(RecordSet.next()){
		String id = RecordSet.getString("id");
		if(ids.indexOf(""+id)==-1){
			continue;
		}
		//tmpcount累加值必须放在检查id值的后边，否则执行累加后可能再继续

		//执行(以上的)continue语句，而致使tmpcount值错位。

		tmpcount++;
		String  _type = RecordSet.getString("type");
		%>
		<wea:item>
<%
	if(strReportDspField.indexOf(","+id+",")>-1){
%>
      <input type='checkbox' name='isShow'  value="<%=id%>" <%if((ids.indexOf(""+id)!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
<%
    }
%>
    </wea:item>
    <wea:item>
      <input type='checkbox' name='check_con' id="check_con<%=tmpcount%>"  value="<%=id%>"   <%=_type.equals("141")?"style='display:none;'":""%> <%if((ids.indexOf(""+id)!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </wea:item>
    <wea:item>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">

      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
int ismain=1;
if(isbill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
    int viewtypeint=Util.getIntValue(RecordSet.getString("viewtype"));
    if(viewtypeint==1){
        label="("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label;
        ismain=0;
    }
} else {
	ismain=Util.getIntValue(RecordSet.getString("ismain"), 1);
}
%>
      <input type=hidden name="con<%=id%>_ismain" value="<%=ismain%>">
      <%=Util.toScreen(label,user.getLanguage())%>
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </wea:item>
    <%
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");
%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
    <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle  style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </wea:item>
    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
    <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      <input type=text class=inputstyle style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      <input type=text class=inputstyle style="width:150px;" name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </wea:item>
    <%
}
else if(htmltype.equals("4")){
%>
    <wea:item>
      <input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </wea:item>
    <%}
else if(htmltype.equals("5")){
%>
    <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
      	<option value=""  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("")){%> selected <%}%>></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
        <option value="<%=tmpselectvalue%>"  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
</wea:item>
    <%} else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("4")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&&!type.equals("162") && !type.equals("141")){
%>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
</div>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }else if("161".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype;
		    }
         %>
                  	<%
	           bclick = "onShowBrowser('"+id+"','"+browserurl+"')";
               if(ids.indexOf(""+id)!=-1){
            	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
            	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
               }
	          %>
         <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
        <!-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
          -->
      <input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" id="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
            </span>
          --%>
</wea:item>
	<%} else if(htmltype.equals("3") && type.equals("141") && false){ //
	%>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
</div>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
         %>
         
         <%
	           bclick = "onShowResourceConditionBrowser('"+id+"','"+browserurl+"')";
	          %>
         <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
				browserValue=""
		          browserSpanValue="" 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
       <!-- <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowResourceConditionBrowser('<%=id%>','<%=browserurl%>')"></button>
          -->
      <input type=hidden name="con<%=id%>_value"  id="con<%=id%>_value">
      <input type=hidden name="con<%=id%>_name" id="con<%=id%>_name">
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> 
          --%>
</wea:item>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
<wea:item>
<!--  <div style="float:left;"> -->
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
   <!--    </div> -->
           <%--  <%
	           bclick = "onShowBrowser1('"+id+"','"+UrlComInfo.getUrlbrowserurl(type)+"','1')";
             if(ids.indexOf(""+id)!=-1){
          	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
          	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
             }
	          %> 
          <div style="float:left;width:150px;"> 
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
		          browserValue='<%=browserValue%>' 
		          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		          </div> --%>
  <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','1')"></button>
       
      <input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
       <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span>
       
    <!--    <div style="float:left;">-->
      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
     <!--   </div>-->
             <%--  <%
	           bclick = "onShowBrowser1('"+id+"','"+UrlComInfo.getUrlbrowserurl(type)+"','2')";
              if(ids.indexOf(""+id)!=-1){
             	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
             	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
                }
	          %>
         <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>'  
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>--%>
  <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','2')"></button>
       
      <input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
       <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       
</wea:item>
     <%} else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
   <wea:item>
      <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      <%
	           bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')";
      if(ids.indexOf(""+id)!=-1){
    	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
    	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
       }
	          %>
         <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
<%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
        --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
<%} else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理（可选择多个部门）

%>
   <wea:item>
   <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
      </select>
      </div>
      <%
	           bclick = "onShowBrowser2('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')";
      if(ids.indexOf(""+id)!=-1){
   	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
   	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
      }
	          %>
         <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
<%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')"></button>
        --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
     <%--  <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
   <wea:item>
   <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      		<%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
            if(ids.indexOf(""+id)!=-1){
            	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
            	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
               }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
 <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
       <wea:item>
       <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
            <%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')";
            if(ids.indexOf(""+id)!=-1){
         	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
         	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
            }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>'  
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
 <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      		<%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
            if(ids.indexOf(""+id)!=-1){
          	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
          	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
             }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
 <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%--<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
        --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      			<%
	           bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
                if(ids.indexOf(""+id)!=-1){
               	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
               	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
                  }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
 <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含） %>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
</div>
    	  <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype;
    	%>
    	
    		<%
	           bclick = "onShowBrowser('"+id+"','"+browserurl+"')";
            if(ids.indexOf(""+id)!=-1){
            	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
            	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
               }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
 <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
    	 --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
    	 --%>
</wea:item>
<%}else{
        %>
        <wea:item>
        </wea:item>
        <%}
}%>
    <%if(isbill.equals("0")){ 
  linecolor=0;
  sql="";
  
      	sql = "select t1.fieldid as id,(select distinct fieldname  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as name,(select distinct t3.fieldlable  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as label,t2.fieldhtmltype as htmltype,t2.type as type,t2.fielddbtype as dbtype from workflow_formfield t1,workflow_formdictdetail t2 where  t2.id = t1.fieldid and t1.formid="+formid + " and (t1.isdetail = '1' or t1.isdetail is not null)";
      //sql = "select t1.fieldid as id,(select distinct fieldname  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as name,(select distinct t3.fieldlable  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as label,t2.fieldhtmltype as htmltype,t2.type as type,t2.fielddbtype as dbtype from workflow_formfield t1,workflow_formdictdetail t2 where  t2.id = t1.fieldid and t1.formid="+formid + " and (t1.isdetail = '1' or t1.isdetail is not null)";
      	StringBuffer sqlSB = new StringBuffer();
      	sqlSB.append(" Select bf.*                                                        \n");
      	sqlSB.append("   from (select t1.fieldid as id,                                   \n");
      	sqlSB.append("                (select distinct fieldname                          \n");
      	sqlSB.append("                   from workflow_fieldlable t3                      \n");
      	sqlSB.append("                  where t3.formid = t1.formid                       \n");
      	sqlSB.append("                    and t3.langurageid = " + userLanguage + "       \n");
      	sqlSB.append("                    and t3.fieldid = t1.fieldid) as name,           \n");
      	sqlSB.append("                (select distinct t3.fieldlable                      \n");
      	sqlSB.append("                   from workflow_fieldlable t3                      \n");
      	sqlSB.append("                  where t3.formid = t1.formid                       \n");
      	sqlSB.append("                    and t3.langurageid = " + userLanguage + "       \n");
      	sqlSB.append("                    and t3.fieldid = t1.fieldid) as label,          \n");
      	sqlSB.append("                t2.fieldhtmltype as htmltype,                       \n");
      	sqlSB.append("                t2.type as type,                                    \n");
      	sqlSB.append("                t2.fielddbtype as dbtype,                           \n");
      	sqlSB.append("                t1.groupid                                          \n");
      	sqlSB.append("           from workflow_formfield t1, workflow_formdictdetail t2   \n");
      	sqlSB.append("          where t2.id = t1.fieldid                                  \n");
      	sqlSB.append("            and t1.formid = " + formid + "                          \n");
      	sqlSB.append("	           and (t1.isdetail = '1' or t1.isdetail is not null)) bf \n");
      	sqlSB.append("	  left join (Select * from Workflow_ReportDspField                \n");
      	sqlSB.append("       where reportid = " + reportid + " ) rf                       \n");
      	sqlSB.append("   on bf.id =  rf.fieldid   order by bf.groupid, rf.dsporder        \n");
      	sql = sqlSB.toString();
RecordSet.executeSql(sql);
while(RecordSet.next()){
String id = RecordSet.getString("id");

if(ids.indexOf(""+id)==-1){
	continue;
}
//tmpcount累加值必须放在检查id值的后边，否则执行累加后可能再继续

//执行(以上的)continue语句，而致使tmpcount值错位。

tmpcount++;
%>
    <wea:item>
<%
	if(strReportDspField.indexOf(","+id+",")>-1){
%>
      <input type='checkbox' name='isShow'"  value="<%=id%>" <%if((ids.indexOf(""+id)!=-1)&&((String)isShows.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
<%
    }
%>
    </wea:item>
    <wea:item>
      <input type='checkbox' name='check_con' id="check_con<%=tmpcount%>"  value="<%=id%>" <%if((ids.indexOf(""+id)!=-1)&&((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </wea:item>
    <wea:item>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">
      <input type=hidden name="con<%=id%>_ismain" value="0">
      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
if(isbill.equals("1"))
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
%>
      <%=Util.toScreen("("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label,user.getLanguage())%>
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </wea:item>
    <%
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");
%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
%>
    <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </wea:item>
    <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
   <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle style="width:150px;" name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>

      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <input type=text class=inputstyle style="width:150px;" name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
    </wea:item>
    <%
}
else if(htmltype.equals("4")){
%>
    <wea:item>
      <input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> checked <%}%>>
    </wea:item>
    <%}
else if(htmltype.equals("5")){
%>
    <wea:item>
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>

      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
      	<option value=""  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("")){%> selected <%}%>></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
        <option value="<%=tmpselectvalue%>"  <%if((ids.indexOf(""+id)!=-1)&&((String)values.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals(""+tmpselectvalue)){%> selected <%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
    </wea:item>
    <%} else if(htmltype.equals("3") && !type.equals("2")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&&!type.equals("162")){
%>
   <wea:item>
      <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
</div>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }else if("161".equals(type)){
				browserurl = browserurl.trim() + "?type="+dbtype;
		    }
         %>
         
         	<%
	           bclick = "onShowBrowser('"+id+"','"+browserurl+"')";
            if(ids.indexOf(""+id)!=-1){
         	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
         	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
            }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		     </div>
       <%--  <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
          --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
     <%--  <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
          --%>
      </span> 
</wea:item>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
   <wea:item>
   <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      </div>
      <%
	           bclick = "onShowBrowser1('"+id+"','"+UrlComInfo.getUrlbrowserurl(type)+"','1')";
      if(ids.indexOf(""+id)!=-1){
    	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
    	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
       }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		         </div>
<%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','1')"></button>
    --%>   
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span>
    --%>   
      <div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt1"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("3")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("4")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("5")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6" <%if((ids.indexOf(""+id)!=-1)&&((String)opt1s.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("6")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
      </div>
     		 <%
	           bclick = "onShowBrowser1('"+id+"','"+UrlComInfo.getUrlbrowserurl(type)+"','2')";
     	      if(ids.indexOf(""+id)!=-1){
     	    	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
     	    	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
     	       }
	          %>
        	 <div style="float:left;width:150px;">
	          <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
	          browserValue='<%=browserValue%>' 
	          browserSpanValue='<%=browserSpanValue%>' 
		          browserOnClick='<%=bclick%>' 
		          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
		          hasBrowser = "true" 
		          isMustInput='1' style="width:150px;"
		          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
		          needHidden="false" ></brow:browser>
		       </div>
<%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser1('<%=id%>','<%=UrlComInfo.getUrlbrowserurl(type)%>','2')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value1" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <%-- <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)value1s.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
        <%
          bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
	      if(ids.indexOf(""+id)!=-1){
	    	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
	    	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
	       }
         %>
      	 <div style="float:left;width:150px;">
         <brow:browser viewType="0" name='<%="con"+id+"_value" %>'  
         browserValue='<%=browserValue%>' 
         browserSpanValue='<%=browserSpanValue%>' 
          browserOnClick='<%=bclick%>' 
          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
          hasBrowser = "true" 
          isMustInput='1' style="width:150px;"
          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
          needHidden="false" ></brow:browser>
       </div>
  <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
      --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
      <%-- <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      <%
          bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')";
      if(ids.indexOf(""+id)!=-1){
   	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
   	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
      }
         %>
      	 <div style="float:left;width:150px;">
         <brow:browser viewType="0" name='<%="con"+id+"_value" %>'  
         browserValue='<%=browserValue%>' 
         browserSpanValue='<%=browserSpanValue%>' 
          browserOnClick='<%=bclick%>' 
          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
          hasBrowser = "true" 
          isMustInput='1' style="width:150px;"
          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
          needHidden="false" ></brow:browser>
       </div>
<%--  <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
     <%--  <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      <%
          bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
      if(ids.indexOf(""+id)!=-1){
      	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
      	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
         }
         %>
      	 <div style="float:left;width:150px;">
         <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
         browserValue='<%=browserValue%>' 
         browserSpanValue='<%=browserSpanValue%>' 
          browserOnClick='<%=bclick%>' 
          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
          hasBrowser = "true" 
          isMustInput='1' style="width:150px;"
          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
          needHidden="false" ></brow:browser>
       </div>
  <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
     <%--  <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span>
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </div>
      <%
          bclick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
      if(ids.indexOf(""+id)!=-1){
     	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
     	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
        }
         %>
      	 <div style="float:left;width:150px;">
         <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
         browserValue='<%=browserValue%>' 
         browserSpanValue='<%=browserSpanValue%>' 
          browserOnClick='<%=bclick%>' 
          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
          hasBrowser = "true" 
          isMustInput='1' style="width:150px;"
          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
          needHidden="false" ></brow:browser>
       </div>
 <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
       --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
     <%--  <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
       --%>
</wea:item>
    <%} else if(htmltype.equals("3") && type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含） %>
<wea:item>
<div style="float:left;">
      <select class=inputstyle name="con<%=id%>_opt"  onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" <%if((ids.indexOf(""+id)!=-1)&&((String)opts.get(Util.getIntValue(""+ids.indexOf(""+id)))).equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </div>
    <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <%
          bclick = "onShowBrowser('"+id+"','"+browserurl+"')";
    if(ids.indexOf(""+id)!=-1){
  	   browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))));
  	   browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))));
     }
         %>
      	 <div style="float:left;width:150px;">
         <brow:browser viewType="0" name='<%="con"+id+"_value" %>' 
         browserValue='<%=browserValue%>' 
         browserSpanValue='<%=browserSpanValue%>' 
          browserOnClick='<%=bclick%>' 
          hasInput="true" isSingle='<%=BrowserManager.browIsSingle(type)%>' 
          hasBrowser = "true" 
          isMustInput='1' style="width:150px;"
          completeUrl='<%="javascript:getajaxurl(" + type + ")"%>' 
          needHidden="false" ></brow:browser>
       </div>
     <%-- <BUTTON type='button' class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
     --%>
      <input type=hidden name="con<%=id%>_value" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)values.get(Util.getIntValue(""+ids.indexOf(""+id))))%> <%}%>>
      <input type=hidden name="con<%=id%>_name" <%if(ids.indexOf(""+id)!=-1){%> value=<%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%><%}%>>
     <%--  <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      <%if(ids.indexOf(""+id)!=-1){%>
      <%=((String)names.get(Util.getIntValue(""+ids.indexOf(""+id))))%>
      <%}%>
      </span> 
     --%>
</wea:item>
 <%}else{
        %>
  	<wea:item>
</wea:item>
  <%   	}
	}
    }
%>      

	</wea:group>
</wea:layout>



</FORM>

<!--xwj for td2974 20051026   B E G I N-->
<script language="javascript">
function changeclick1(){
document.SearchForm.requestname_check_con.checked = true;
}
function changeclick2(){
document.SearchForm.requestlevel_check_con.checked = true;
}
function changeclick3(){<!--xwj for td2451 20051104 -->
document.SearchForm.requeststatus_check_con.checked = true;
}
function changeclick4(){
document.SearchForm.archiveTime.checked = true;
}
function onEditSaveTemplate(){
	var thisval = "";
	$("input[name$=_value]").each(function (i, e) {
		thisval = $(this).val();
		if (thisval != undefined && thisval != "") {
			var ename = $(this).attr("name");
			var eid = ename.replace("con", "").replace("_value", "");
			var targetelement = $("#con" + eid + "_name");
			var temphtml = "";
			//alert($("#" + ename + "span").children().length);
			$("#" + ename + "span a").each(function () {
				temphtml += " " + $(this).text();	
			});
			var checkspan = /^<.*$/;
			if(checkspan.test(temphtml)){
				temphtml=temphtml.replace(/<[^>]+>/g,"");
			}
			targetelement.val(temphtml);
		}
		//alert(targetelement.val());
	});
	
	//if(check_form(document.SearchForm,'newMouldName')){
		//if(document.all("todate") != null && document.all("todate") != undefined && document.all("fromdate") != null && document.all("fromdate") != undefined){
		//	if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
		//		alert("<%--=SystemEnv.getHtmlLabelName(16722,user.getLanguage())--%>");
		//		return;
		//	}
		//}
	    document.SearchForm.operation.value="editSaveTemplate";
	    document.SearchForm.action="ReportConditionOperation.jsp";
	    document.SearchForm.submit();
	//}
}

function onchangeselect(){
	var changetype = jQuery("#templatetype").val();
	var str = $("#templatetype").find("option:selected").text();
	if(changetype == 1){
		location.href = "ReportCondition.jsp?id=<%=reportid%>";
	}else{
		location.href = "ReportConditionMould.jsp?id=<%=reportid%>&mouldId="+changetype;
	}
}

function onSaveAsTemplate(){
	var thisval = "";
	$("input[name$=_value]").each(function (i, e) {
		thisval = $(this).val();
		if (thisval != undefined && thisval != "") {
			var ename = $(this).attr("name");
			var eid = ename.replace("con", "").replace("_value", "");
			var targetelement = $("#con" + eid + "_name");
			var temphtml = "";
			//alert($("#" + ename + "span").children().length);
			$("#" + ename + "span a").each(function () {
				temphtml += " " + $(this).text();	
			});
			var checkspan = /^<.*$/;
			if(checkspan.test(temphtml)){
				temphtml=temphtml.replace(/<[^>]+>/g,"");
			}
			targetelement.val(temphtml);
		}
		//alert(targetelement.val());
	});
	
	if(check_form(document.SearchForm,'newMouldName')){
		if(document.all("todate") != null && document.all("todate") != undefined && document.all("fromdate") != null && document.all("fromdate") != undefined){
			if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
				alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
				return;
			}
		}
	    document.SearchForm.operation.value="saveAsTemplate";
	    document.SearchForm.action="ReportConditionOperation.jsp";
	    document.SearchForm.submit();
	}
}

function submit(){
	if(document.all("todate")!=null&&document.all("fromdate")!=null&&document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
		alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
		return;
	}else{
  document.SearchForm.submit();
	}
}

function onDeleteTemplate(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
	    document.SearchForm.operation.value="deleteTemplate";
	    document.SearchForm.action="ReportConditionOperation.jsp";
	    document.SearchForm.submit();
	}
}

function changelevel(tmpindex){
	$GetEle("check_con" + tmpindex).checked = true;
}

function onShowBrowser2(id,url) {
	var url = url + "?selectedids=" + $G("con"+id+"_value").value;
	var id1 = window.showModalDialog(url);
	if (id1 != null && id1 != undefined) {
	    if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	    	var rid = wuiUtil.getJsonValueByIndex(id1, 0);
	    	var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname;
			$G("con"+id+"_value").value = rid;
	        $G("con"+id+"_name").value = rname;
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser(id,url) {
	var id1 = window.showModalDialog(url + "&selectedids=" + $G("con"+id+"_value").value);

	if (id1 != null) {
		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname
			$G("con"+id+"_value").value=rid
	        $G("con"+id+"_name").value=rname
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		var id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
		if(id1==null||id1==undefined)return;
		$G("con"+id+"_valuespan").innerHTML = id1;
		$G("con"+id+"_value").value=id1;
	} else if( type1 == 2) {
		var id1 = window.showModalDialog(url, "","dialogHeight:320px;dialogwidth:275px");
		if(id1==null||id1==undefined)return;
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}

function onShowResourceConditionBrowser(id, url, type1) {
	var linkurl = "";
	var ismand=0;
	var tmpids = $GetEle("con" + id+"_value").value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if ((dialogId)) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			








			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];
				if (shareTypeValue == "") {
					continue;
				}
				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;
				
				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage()==0?7:user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage()==0?7:user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage()==0?7:user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage()==0?7:user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage()==0?7:user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			//$GetEle("field" + id).value = fileIdValue;
			//$GetEle("field" + id + "span").innerHTML = sHtml;
			$G("con"+id+"_valuespan").innerHTML = sHtml;
	    	$G("con"+id+"_value").value= fileIdValue;
	    	$G("con"+id+"_name").value=sHtml;
		} else {
			$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	} 
}

function addTemplate(){
	var title = "<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>";	
	var url = "/workflow/report/reportTemplateAdd.jsp";
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 400;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL =url;
	diag_vote.isIframe=false;
	diag_vote.show();
}

function setTemplatename(templatename) {
	$("input[name='newMouldName']").val(templatename);
}

function getajaxurl(typeId){
	var url = "";
	var whereClause = "";
	if(typeId == "currentnodeBrowser"){
		var workflowid = jQuery("#con-12_value").val();
		//alert(workflowid);
		whereClause = "id IN( SELECT nodeid FROM workflow_flownode WHERE workflowid = "+workflowid+")";
		url = "/data.jsp?type=" + typeId+"&whereClause="+whereClause;
	}else{
		url = "/data.jsp?type=" + typeId;
	}
    return url;
}

function resetform() {
	document.SearchForm.reset();
	//try{
	//	if($GetEle("newMouldName").value == '') {
	//		$GetEle("newMouldNameSpan").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	//	} else {
	//		$GetEle("newMouldNameSpan").innerHTML="";
	//	}
	//}catch(e){}
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
