<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowBarCodeSetManager" class="weaver.workflow.workflow.WorkflowBarCodeSetManager" scope="page" />
<HTML>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21449,user.getLanguage());
		String needfav = "";
		String needhelp = "";
	%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js" />
    </HEAD>
	<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveBarCodeSet(this),_self}";
		RCMenuHeight += RCMenuHeightStep;      
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelBarCodeSet(this),_self}";
		RCMenuHeight += RCMenuHeightStep;  
	%>

	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<%
		int workflowId = Util.getIntValue(request.getParameter("workflowId"),-1);
		WfRightManager wfrm = new WfRightManager();
		boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
		int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
		int subCompanyID = -1;
		int operateLevel = 0;

		if(1 == detachable) {  
			if(null == request.getParameter("subCompanyID")) {
				subCompanyID=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
			} else {
				subCompanyID=Util.getIntValue(request.getParameter("subCompanyID"),-1);
			}
			if(-1 == subCompanyID) {
				subCompanyID = user.getUserSubCompany1();
			}
			session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));
			operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
		} else {
			if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
				operateLevel=2;
			}
		}
		if(operateLevel<=0 && haspermission) {
			operateLevel = 2;
		}
		if(operateLevel > 0) {
			String formId = request.getParameter("formId");
			String isBill = Util.null2String(request.getParameter("isBill"));
			
			int id=-1;
			String isUse="0";
			String measureUnit="1";
			int printRatio=96;
			int minWidth=30;
			int maxWidth=70;
			int minHeight=10;
			int maxHeight=25;
			int bestWidth=50;
			int bestHeight=20;

			RecordSet.executeSql("select * from Workflow_BarCodeSet where workflowId="+workflowId);

			if(RecordSet.next()){
				id = Util.getIntValue(RecordSet.getString("id"),-1);
				isUse = Util.null2String(RecordSet.getString("isUse"));
				measureUnit = Util.null2String(RecordSet.getString("measureUnit"));
				printRatio = Util.getIntValue(RecordSet.getString("printRatio"),96);
				minWidth = Util.getIntValue(RecordSet.getString("minWidth"),30);
				maxWidth = Util.getIntValue(RecordSet.getString("maxWidth"),70);
				minHeight = Util.getIntValue(RecordSet.getString("minHeight"),10);
				maxHeight = Util.getIntValue(RecordSet.getString("maxHeight"),25);
				bestWidth = Util.getIntValue(RecordSet.getString("bestWidth"),50);
				bestHeight = Util.getIntValue(RecordSet.getString("bestHeight"),20);
			}

			if(measureUnit.trim().equals("")){
				measureUnit="1";
			}   
			
			int dataElementNum=14;//数据元素个数，根据规范为14个。		     
	%>


	

	<FORM name="formBarCodeSet" method="post" action="WorkflowBarCodeSetOperation.jsp" >

		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="workflow"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(127779,user.getLanguage()) %>"/>
		</jsp:include>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="qr_btn_submit" class="e8_btn_top" onclick="saveCode()">
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table> 

		<INPUT TYPE="hidden" NAME="workflowId" VALUE="<%= workflowId %>">  
		<INPUT TYPE="hidden" NAME="formId" VALUE="<%= formId %>">
		<INPUT TYPE="hidden" NAME="isBill" VALUE="<%= isBill %>">
		<INPUT TYPE="hidden" NAME="id" VALUE="<%= id %>">

		<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
			<%
				String contentDivBarCodeSet = "{'groupOperDisplay':'none','samePair':'contentDivBarCodeSet','groupDisplay':'','itemAreaDisplay':''}"; 
				if(!"1".equals(isUse)){
					contentDivBarCodeSet = "{'groupOperDisplay':'none','samePair':'contentDivBarCodeSet','groupDisplay':'none','itemAreaDisplay':'none'}"; 
				}
			%>	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%>' attributes="<%=contentDivBarCodeSet %>">
				<wea:item attributes="{'isTableList':'true'}">
					<wea:layout type="4col">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></wea:item>
							<wea:item>
								<select class=inputstyle name="measureUnit" onChange="changeMeasureUnit(this.value)">
									<option value="1" <% if(measureUnit.equals("1")) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%></option>
									<option value="2" <% if(measureUnit.equals("2")) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></option>
								</select>					
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21451,user.getLanguage())%></wea:item>
							<wea:item>
								<%=SystemEnv.getHtmlLabelName(21452,user.getLanguage())%>	  
								<input type="text" name="printRatioBarCodeSet" value="<%=printRatio%>" maxlength="4" size="4"  onKeyPress="ItemCount_KeyPress()" onChange='checknumber("printRatioBarCodeSet");checkinput("printRatioBarCodeSet","printRatioBarCodeSetImage")' style="width:40px;">
								<span id=printRatioBarCodeSetImage></span>
								<%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>					
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21453,user.getLanguage())%></wea:item>
							<wea:item>
								<input type="text" name="minWidthBarCodeSet" value="<%=minWidth%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("minWidthBarCodeSet");checkinput("minWidthBarCodeSet","minWidthBarCodeSetImage")' style="width:40px;">
								<span id=minWidthBarCodeSetImage></span>
								-
								<input type="text" name="maxWidthBarCodeSet" value="<%=maxWidth%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("maxWidthBarCodeSet");checkinput("maxWidthBarCodeSet","maxWidthBarCodeSetImage")' style="width:40px;">
								<span id=maxWidthBarCodeSetImage></span>&nbsp;
								<span id=widthRangeSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span>					
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21454,user.getLanguage())%></wea:item>
							<wea:item>
								<input type="text" name="bestWidthBarCodeSet"   value="<%=bestWidth%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("bestWidthBarCodeSet");checkinput("bestWidthBarCodeSet","bestWidthBarCodeSetImage")' style="width:40px;">
								<span id=bestWidthBarCodeSetImage></span>&nbsp;
								<span id=bestWidthSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span>					
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21455,user.getLanguage())%></wea:item>
							<wea:item>
								<input type="text" name="minHeightBarCodeSet" value="<%=minHeight%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("minHeightBarCodeSet");checkinput("minHeightBarCodeSet","minHeightBarCodeSetImage")' style="width:40px;">
								<span id=minHeightBarCodeSetImage></span>
								-
								<input type="text" name="maxHeightBarCodeSet"   value="<%=maxHeight%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("maxHeightBarCodeSet");checkinput("maxHeightBarCodeSet","maxHeightBarCodeSetImage")' style="width:40px;">
								<span id=maxHeightBarCodeSetImage></span>&nbsp;
								<span id=heightRangeSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span>					
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21466,user.getLanguage())%></wea:item>
							<wea:item>
								<input type="text" name="bestHeightBarCodeSet" value="<%=bestHeight%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("bestHeightBarCodeSet");checkinput("bestHeightBarCodeSet","bestHeightBarCodeSetImage")' style="width:40px;">
								<span id=bestHeightBarCodeSetImage></span>&nbsp;
								<span id=bestHeightSpan><%if("1".equals(measureUnit)){%><%=SystemEnv.getHtmlLabelName(21450,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%><%}%></span>					
							</wea:item>
						</wea:group>
					</wea:layout>
				</wea:item>	
			</wea:group>
			<%	
				Map barCodeSetDetailMap = new HashMap();
				int tempDataElementId=0;
				int tempFieldId=0;
				RecordSet.executeSql("select * from Workflow_BarCodeSetDetail where barCodeSetId="+id);
				while(RecordSet.next()){
					tempDataElementId=Util.getIntValue(RecordSet.getString("dataElementId"),0);
					tempFieldId=Util.getIntValue(RecordSet.getString("fieldId"),0);
					barCodeSetDetailMap.put(""+tempDataElementId, ""+tempFieldId);
				}
							
				/*================ 下拉框信息 ================*/
				List formDictIdList = new ArrayList();
				List formDictLabelList = new ArrayList();
					  
				String SQL = null;
				if("1".equals(isBill)) {
					SQL = "select formField.id,fieldLable.labelName as fieldLable "
								  + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
								  + "where fieldLable.indexId=formField.fieldLabel "
								  + "  and formField.billId= " + formId
								  + "  and formField.viewType=0 "
								  + "  and fieldLable.languageid =" + user.getLanguage()
								  + "  order by formField.dspOrder  asc ";
				} else {			
					SQL = "select formDict.ID, fieldLable.fieldLable "
								  + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
								  + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
								  + "and formField.formid = " + formId
								  + "and fieldLable.langurageid = " + user.getLanguage()
								  + " order by formField.fieldorder";
				}
								  
				RecordSet.executeSql(SQL);
				while(RecordSet.next()){
					formDictIdList.add(Util.null2String(RecordSet.getString("ID")));
					formDictLabelList.add(Util.null2String(RecordSet.getString("fieldLable")));
				}
			%>  
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21456,user.getLanguage())%>' attributes="<%=contentDivBarCodeSet %>">
				<wea:item attributes="{'isTableList':'true'}">
					<table class="ListStyle" cellspacing=0 id="oTable">
						<colgroup>
							<col width="40%">
							<col width="*">
						</colgroup>    
						<tr class="header">
							<td><%=SystemEnv.getHtmlLabelName(21457,user.getLanguage())%></td>
							<td><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
						</tr>
						<%
						for(int i=1;i<=dataElementNum;i++){
						%>
						<tr>
							<td><%=WorkflowBarCodeSetManager.getLabelNameByDataElementId(i,user.getLanguage())%></td>
							<td>
								<select class=inputstyle name="fieldId<%=i%>">
								<option value=-1></option>
								<option value=-3  <%if ("-3".equals((String)(barCodeSetDetailMap.get(""+i)))) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
								<%
								for(int j = 0; j < formDictIdList.size(); j++){
								%>                   
								  <option value=<%= (String)formDictIdList.get(j) %>  <% if(((String)formDictIdList.get(j)).equals((String)(barCodeSetDetailMap.get(""+i)))) { %> selected <% } %>   ><%= (String)formDictLabelList.get(j) %></option>
								<%}%>                         
								</select>
							</td>
						</tr>
						<tr class='Spacing' style="height:1px!important;"><td colspan=2 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
						<%}%>
					</table>		
				</wea:item>
			</wea:group>	
		</wea:layout>

		<INPUT TYPE="hidden" NAME="dataElementNum" VALUE="<%=dataElementNum%>">              
	</FORM>
	<br/>
	<script type="text/javascript">
			jQuery(document).ready(function(){
				jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
				showGroup("contentDivBarCodeSet");
			});

			function saveCode() {
				console.log("do not click again.");
					//return false;
				jQuery("form[name='formBarCodeSet']").submit();
				
			}

			function saveBarCodeSet(obj){
				if(checkValueBarCodeSet()){
					formBarCodeSet.submit();	
					obj.disabled=true;
				}
			}

			function cancelBarCodeSet(obj){
				window.location = "/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=<%=workflowId%>&formid=<%=formId%>&isbill=<%=isBill%>";
			}

			function checkValueBarCodeSet(){
				if(!check_form(formBarCodeSet,"printRatioBarCodeSet,minWidthBarCodeSet,maxWidthBarCodeSet,bestWidthBarCodeSet,minHeightBarCodeSet,maxHeightBarCodeSet,bestHeightBarCodeSet")){//判断必填项
					return false;
				}

				var minWidthBarCodeSet=parseInt(formBarCodeSet.minWidthBarCodeSet.value);
				var maxWidthBarCodeSet=parseInt(formBarCodeSet.maxWidthBarCodeSet.value);
				if(minWidthBarCodeSet>maxWidthBarCodeSet){
					alert("<%=SystemEnv.getHtmlLabelName(21467, user.getLanguage())%>");
					return false;
				}

				var bestWidthBarCodeSet=parseInt(formBarCodeSet.bestWidthBarCodeSet.value);  
				if(bestWidthBarCodeSet<minWidthBarCodeSet||bestWidthBarCodeSet>maxWidthBarCodeSet){
					alert("<%=SystemEnv.getHtmlLabelName(21468, user.getLanguage())%>");
					return false;
				}

				var minHeightBarCodeSet=parseInt(formBarCodeSet.minHeightBarCodeSet.value);
				var maxHeightBarCodeSet=parseInt(formBarCodeSet.maxHeightBarCodeSet.value);
				if(minHeightBarCodeSet>maxHeightBarCodeSet){
					alert("<%=SystemEnv.getHtmlLabelName(21469, user.getLanguage())%>");
					return false;
				}

				var bestHeightBarCodeSet=parseInt(formBarCodeSet.bestHeightBarCodeSet.value);  
				if(bestHeightBarCodeSet<minHeightBarCodeSet||bestHeightBarCodeSet>maxHeightBarCodeSet){
					alert("<%=SystemEnv.getHtmlLabelName(21470, user.getLanguage())%>");
					return false;
				}

				return true ;
			}

			function changeMeasureUnit(objValue){
				if(objValue==1){
					widthRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";
					bestWidthSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";
					heightRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";
					bestHeightSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(21450, user.getLanguage())%>";

					formBarCodeSet.minWidthBarCodeSet.value="30";
					formBarCodeSet.maxWidthBarCodeSet.value="70";
					formBarCodeSet.bestWidthBarCodeSet.value="50";

					formBarCodeSet.minHeightBarCodeSet.value="10";
					formBarCodeSet.maxHeightBarCodeSet.value="25";
					formBarCodeSet.bestHeightBarCodeSet.value="20";
				}
				else if(objValue==2){
					widthRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";
					bestWidthSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";
					heightRangeSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";
					bestHeightSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(218, user.getLanguage())%>";

					formBarCodeSet.minWidthBarCodeSet.value="113";
					formBarCodeSet.maxWidthBarCodeSet.value="265";
					formBarCodeSet.bestWidthBarCodeSet.value="189";

					formBarCodeSet.minHeightBarCodeSet.value="38";
					formBarCodeSet.maxHeightBarCodeSet.value="144";
					formBarCodeSet.bestHeightBarCodeSet.value="76";
				}
			}
		</script>
	<%
		}
		else
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
	%>
	
	
	</BODY>

</HTML>
