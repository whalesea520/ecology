<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig"%>
<%@page import="weaver.workflow.browserdatadefinition.ConditionField"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.Hashtable"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
String impJs="/js/dragBox/rightspluingForBrowserNew_wev8.js";
String srchead="['"+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("602",user.getLanguage())+"']";
String srcfield="['id','name','status']";
boolean isSingle="single".equalsIgnoreCase( Util.null2String(request.getParameter("browtype")));
if(isSingle){
	impJs="/js/dragBox/rightspluingForSingleBrowser_wev8.js";
	srchead="['"+SystemEnv.getHtmlLabelNames("195",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("586",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("432",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("144",user.getLanguage())+"','"+SystemEnv.getHtmlLabelNames("587",user.getLanguage())+"']";
	srcfield="['id','name','prjtype','prjworktype','prjmanager','status']";
}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="<%=impJs %>"></script>
<script type="text/javascript" src="/proj/js/multiPrjBrowser_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("101",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
String name = Util.null2String(request.getParameter("name"));
String from = Util.null2String(request.getParameter("from"));
String description = Util.null2String(request.getParameter("description"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String worktype = Util.null2String(request.getParameter("worktype"));
String manager = Util.null2String(request.getParameter("manager"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
if(request.getParameter("resourceids")==null){
	check_per = Util.null2String(request.getParameter("projectids"));
}


String resourceids = "";
String resourcenames = "";


%>

<script type="text/javascript">
	var btnok_onclick = function(){
		jQuery("#btnok").click();
	}

	var btnclear_onclick = function(){
		jQuery("#btnclear").click();
	}
	
	function onClose(){
		 if(dialog){
	    	dialog.close()
	    }else{
		    window.parent.close();
		}
	}
</script>

</HEAD>

<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("101",user.getLanguage()) %>'/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isSingle){
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
</DIV>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div class="zDialog_div_content">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiProjectBrowser.jsp" onsubmit="btnOnSearch();return false;" method=post>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="from" value='<%=from %>' />



<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<%
//流程浏览定义条件
StringBuffer statusAll=new StringBuffer("");
int bdf_wfid=Util.getIntValue(request.getParameter("bdf_wfid"),-1);
int bdf_fieldid=Util.getIntValue(request.getParameter("bdf_fieldid"),-1);
int bdf_viewtype=Util.getIntValue(request.getParameter("bdf_viewtype"),-1);
List<ConditionField> lst=null;
if(request.getParameter("bdf_wfid")!=null && (lst=ConditionField.readAll(bdf_wfid, bdf_fieldid, bdf_viewtype)).size()>0){
	JSONArray arr=new JSONArray();
	boolean allHide=true;
	for(int i=0;i<lst.size();i++){
		ConditionField f=lst.get(i);
		boolean isHide=f.isHide();
		if(allHide && !isHide){
			allHide=false;
		}
		String fname=f.getFieldName();
		JSONObject obj=new JSONObject();
		obj.put("isHide", isHide);
		obj.put("isReadonly", f.isReadonly());
		obj.put("FieldName", fname);
		obj.put("Value", f.getValue());
		obj.put("ConditionField", f);
		arr.put(obj);
	}
	
if(!allHide){
%>		
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}" >
<%
		for(int i=0;i<arr.length();i++){
			JSONObject obj=(JSONObject)arr.get(i);
			String fieldname=obj.getString("FieldName");
			String fieldvalue=obj.getString("Value");
			boolean isHide=obj.getBoolean("isHide");
			boolean isReadonly=obj.getBoolean("isReadonly");
			if(isHide){
				continue;
			}
			
			if("name".equalsIgnoreCase(fieldname)){
%>				
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input name=name value='<%=fieldvalue %>' class="InputStyle" <%=isReadonly?"readonly":"" %> ></wea:item>
<%
			}else if(!isHide&&"prjtype".equalsIgnoreCase(fieldname)){
%>				
			<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
			<wea:item>
		        <brow:browser viewType="0" name="prjtype" 
					browserValue='<%=fieldvalue %>' browserSpanValue='<%=ProjectTypeComInfo.getProjectTypename(fieldvalue) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp"
					hasInput='<%=(""+!isReadonly) %>' isSingle="true" hasBrowser = "true" isMustInput='<%=(isReadonly?"0":"1") %>'
					completeUrl="/data.jsp?type=244" />
			</wea:item>
<%
			}else if("worktype".equalsIgnoreCase(fieldname)){
%>				
				<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
				<wea:item>
			        <brow:browser viewType="0" name="worktype" 
					browserValue='<%=fieldvalue %>' browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(fieldvalue) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp"
					hasInput='<%=(""+!isReadonly) %>' isSingle="true" hasBrowser = "true" isMustInput='<%=(isReadonly?"0":"1") %>'
					completeUrl="/data.jsp?type=245" />
				</wea:item>
<%				
				
			}else if("status".equalsIgnoreCase(fieldname)){
				ConditionField f=(ConditionField)obj.get("ConditionField");
				List<String> selLst= f.getCanSelectValueList();
%>				
			<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
			<wea:item>
				<%
				if(isReadonly){
%>					
				<input type="hidden" name="status" value="<%=fieldvalue %>" />
<%
				}
				%>
			
				<select  class=inputstyle id=status name=status <%=isReadonly?"disabled":"" %> >
				<option value=""></option>
				<% 
				if(selLst!=null&&selLst.size()>0){
					for(int k=0;k<selLst.size();k++){
						String tmpval=Util.null2String( selLst.get(k));
						statusAll.append(tmpval).append(",");
%>		
				<option value="<%=tmpval %>" <%=tmpval.equals(fieldvalue)?"selected":"" %>><%=Util.toScreen(ProjectStatusComInfo.getProjectStatusdesc(tmpval),user.getLanguage()) %></option>			
<%
					}
					statusAll.deleteCharAt(statusAll.length()-1);
				}else{//全部展现
					ProjectStatusComInfo.setTofirstRow();
					while(ProjectStatusComInfo.next()) {
						String tmpstatus = ProjectStatusComInfo.getProjectStatusid() ;
%>
			          <option value="<%=tmpstatus%>" <% if(tmpstatus.equals(status)) {%>selected<%}%>><%=Util.toScreen(ProjectStatusComInfo.getProjectStatusdesc(tmpstatus),user.getLanguage()) %></option>
<%			          
					}
				}
%>				
		        </select>
			</wea:item>
<%
				
			}else if("manager".equalsIgnoreCase(fieldname)&&(!user.getLogintype().equals("2"))){
				ConditionField f=(ConditionField)obj.get("ConditionField");
				String vtype= f.getValueType();
				if("1".equals(vtype)){//当前操作者的值
					fieldvalue=""+user.getUID();
				}else if("3".equals(vtype)){//取表单字段值
					fieldvalue="";
					if(f.isGetValueFromFormField()){
						fieldvalue=Util.null2String(request.getParameter("bdf_"+fieldname)).split(",")[0];
					}
				}
%>				
			<wea:item><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="manager" 
					browserValue='<%=fieldvalue %>' browserSpanValue='<%=ResourceComInfo.getLastname(fieldvalue ) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput='<%=(""+!isReadonly) %>' isSingle="true" hasBrowser = "true" isMustInput='<%=(isReadonly?"0":"1") %>'
					completeUrl="/data.jsp?type=1" />
			</wea:item>
<%
				
			}
			
		}
		%>
	</wea:group>
</wea:layout>	
<%
	
}
//隐藏的字段
for(int i=0;i<arr.length();i++){
	JSONObject obj=(JSONObject)arr.get(i);
	String fieldname=obj.getString("FieldName");
	String fieldvalue=obj.getString("Value");
	boolean isHide=obj.getBoolean("isHide");
	if(!isHide){
		continue;
	}
	if("manager".equalsIgnoreCase(fieldname)&&(!user.getLogintype().equals("2"))){
		ConditionField f=(ConditionField)obj.get("ConditionField");
		String vtype= f.getValueType();
		if("1".equals(vtype)){//当前操作者的值
			fieldvalue=""+user.getUID();
		}else if("3".equals(vtype)){//取表单字段值
			fieldvalue="";
			if(f.isGetValueFromFormField()){
				fieldvalue=Util.null2String(request.getParameter("bdf_"+fieldname)).split(",")[0];
			}
		}
	}else if("status".equalsIgnoreCase(fieldname)){
		ConditionField f=(ConditionField)obj.get("ConditionField");
		List<String> selLst= f.getCanSelectValueList();
		if(selLst!=null&&selLst.size()>0){
			for(int k=0;k<selLst.size();k++){
				String tmpval=Util.null2String( selLst.get(k));
				statusAll.append(tmpval).append(",");
			}
			statusAll.deleteCharAt(statusAll.length()-1);
		}
	}
	
%>		
<input type="hidden" name="<%=fieldname %>" id="<%=fieldname %>" value="<%=fieldvalue %>" />
<%
}
	
%>	
<input type="hidden" name="statusAll" id="statusAll" value="<%=statusAll.toString() %>" />
<%
	
}else{//默认显示
	%>
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}" >

		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input name=name value='<%=name%>' class="InputStyle"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
			<wea:item>
				<select  class=inputstyle id=status name=status>
				<option value=""></option>
				<% while(ProjectStatusComInfo.next()) {  
					String tmpstatus = ProjectStatusComInfo.getProjectStatusid() ;
				%>
		          <option value=<%=tmpstatus%> <% if(tmpstatus.equals(status)) {%>selected<%}%>>
				  <%=Util.toScreen(ProjectStatusComInfo.getProjectStatusdesc(tmpstatus),user.getLanguage())%></option>
				<% } %>
		        </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
			<wea:item>
		        <brow:browser viewType="0" name="prjtype" 
					browserValue='<%=prjtype %>' browserSpanValue='<%=ProjectTypeComInfo.getProjectTypename(prjtype) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=244" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></wea:item>
			<wea:item>
		         <brow:browser viewType="0" name="worktype" 
					browserValue='<%=worktype %>' browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(worktype) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=245" />
			</wea:item>
	<%
	if(!user.getLogintype().equals("2")){
		%>
			<wea:item><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="manager" 
					browserValue='<%=manager %>' browserSpanValue='<%=ResourceComInfo.getLastname(manager) %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp?type=1" />
			</wea:item>
		<%
	}
	%>	
	</wea:group>
</wea:layout>
	<%
	
}
%>	
	
	
</div>
<div id="dialog">
	<div id='colShow'></div>
</div>


<div style="width:0px;height:0px;overflow:hidden;">
<button type=submit></BUTTON>
</div>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
		<%
		if(!isSingle){
			%>
			<input type="button" class=zd_btn_submit  accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<%
		}
		%>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=check_per %>",<%=srchead %>,<%=srcfield %>);
});


</SCRIPT>
</BODY>
</HTML>
