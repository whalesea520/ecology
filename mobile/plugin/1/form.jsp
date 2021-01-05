
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="weaver.docs.docs.DocManager" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%
  weaver.conn.RecordSet   RecordSet =new     weaver.conn.RecordSet();
  weaver.meeting.Maint.MeetingSetInfo  meetingSetInfo2=new weaver.meeting.Maint.MeetingSetInfo();
  weaver.common.StringUtil  strUtil =new weaver.common.StringUtil();
  weaver.common.DateUtil       dateUtil =new  weaver.common.DateUtil();
  weaver.hrm.attendance.manager.HrmAttProcSetManager     attProcSetManager=new weaver.hrm.attendance.manager.HrmAttProcSetManager();
  weaver.hrm.attendance.manager.HrmAttVacationManager attVacationManager=new weaver.hrm.attendance.manager.HrmAttVacationManager();
  weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager paidLeaveTimeManager =new weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager();
  weaver.hrm.attendance.manager.HrmLeaveTypeColorManager colorManager =new weaver.hrm.attendance.manager.HrmLeaveTypeColorManager();
%>
<div class="blockHead" style="display:none"><span class="m-l-14"><%=SystemEnv.getHtmlLabelName(32210,user.getLanguage())%></span></div>
<div class="tblBlock" style="width: 100%; background: #fff;" id="mainforminfoDiv">
	<table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable">
<%
Log log = LogFactory.getLog(page.getClass());
String lynrObj = "";
String lynrValue = "";
String lynrName = "";
int lynrIndex = 0;
WorkflowRequestTableField[] workflowRequestTableFields = workflowRequestInfo.getWorkflowMainTableInfo().getRequestRecords()[0].getWorkflowRequestTableFields();

//获取所有被字段联动设置值的字段列表
List assignmentFieldNames = DynamicDataInput.getAssignmentFieldsByWorkflowID(workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId(), 0);
boolean canEdit = workflowRequestInfo.isCanEdit();

StringBuffer attachmentssb = new StringBuffer("[");

String[] docids;
String item="";
String[] uploadids;
String imageFileid="";
DocManager  docManager=new DocManager();
ResourceComInfo  resource=new ResourceComInfo();

String userannualinfo = "",thisyearannual = "",lastyearannual = "",allannual = "";
String userpslinfo = "",thisyearpsldays = "",lastyearpsldays = "",allpsldays = "";
String paidLeaveDays = "",creater = String.valueOf(userid);
String workflowCreate = workflowRequestInfo.getCreatorId();
if(!creater.equals(workflowCreate)){
	creater = workflowCreate;
}

String _tableDBName = strUtil.vString(workflowRequestInfo.getWorkflowMainTableInfo().getTableDBName());
String currentdate = "";
String strleaveTypes = "";  
if(_tableDBName.equalsIgnoreCase("bill_bohaileave")) {
	String createrResource = "";
	String createNewLeaveType ="";
	RecordSet.executeSql("select * from bill_bohaileave where requestid="+workflowRequestInfo.getRequestId());
	if(RecordSet.next())
	{
	   createrResource=RecordSet.getString("resourceid");
	   createNewLeaveType = RecordSet.getString("newLeaveType");
		if(!"".equals(createrResource) && !creater.equals(createrResource)){
			creater = createrResource;
		}
	}
	strleaveTypes=colorManager.getPaidleaveStr();
	currentdate = strUtil.vString(request.getParameter("currentdate"), dateUtil.getCurrentDate());
	userannualinfo = HrmAnnualManagement.getUserAannualInfo(creater,currentdate);
	thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
	lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
	allannual = Util.TokenizerString2(userannualinfo,"#")[2];
	userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(creater, currentdate,createNewLeaveType);
	thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
	lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
	allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
	paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(creater));
	float[] freezeDays = attVacationManager.getFreezeDays(creater);
	if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];
	if(freezeDays[1] > 0) allpsldays += " - "+freezeDays[1];
	if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];
}
%>
	<script type="text/javascript" src="/mobile/plugin/browser/js/browserUtil_wev8.js"></script>
	<SCRIPT type="text/javascript" >
		var MemberConflict="";
		var MemberConflictChk="";
		var beginDate="";
		var beginTime="";
		var endDate="";
		var endTime="";
		var Address="";
		var resources="";
		var crms="";
		var repeatType="";
	</SCRIPT>
<%
for(int i=0; i<workflowRequestTableFields.length; i++) {
	WorkflowRequestTableField wfreqfield = workflowRequestTableFields[i];
	boolean view = wfreqfield.isView();
	boolean edit = wfreqfield.isEdit();
	String fieldShowName = wfreqfield.getFieldShowName();
	String filedHtmlShow = wfreqfield.getFiledHtmlShow();
	String fieldShowValue = wfreqfield.getFieldShowValue();
	String fieldHtmlType = wfreqfield.getFieldHtmlType();
	String fieldName = wfreqfield.getFieldName();
	String fieldValue = wfreqfield.getFieldValue();
	if (filedHtmlShow != null && !"".equals(filedHtmlShow)) {
		if (filedHtmlShow.indexOf("/browser/dialog.do") != -1) {
			filedHtmlShow = filedHtmlShow.replaceAll("/browser/dialog.do", "/mobile/plugin/browser.jsp");
		}
	}
	
	String fieldFormName = wfreqfield.getFieldFormName();
	String[] selectNames = wfreqfield.getSelectnames();
	String[] selectvalues = wfreqfield.getSelectvalues();
	String fieldType = wfreqfield.getFieldType();
    String fileExtend="";
    
	if(formId.equals("85")){
		if(fieldName.equalsIgnoreCase("beginDate")){
			%>
			<SCRIPT type="text/javascript" >
				 beginDate="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("beginTime")){
			%>
			<SCRIPT type="text/javascript" >
				 beginTime="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("endDate")){
			%>
			<SCRIPT type="text/javascript" >
				 endDate="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("endTime")){
			%>
			<SCRIPT type="text/javascript" >
				 endTime="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("Address")){
			%>
			<SCRIPT type="text/javascript" >
				 Address="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("resources")){
			%>
			<SCRIPT type="text/javascript" >
				 resources="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("crms")){
			%>
			<SCRIPT type="text/javascript" >
				 crms="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}else if(fieldName.equalsIgnoreCase("repeattype")){
			%>
			<SCRIPT type="text/javascript" >
				 repeatType="<%=fieldFormName%>";
			</SCRIPT>
			<%
		}
		%>
		<SCRIPT type="text/javascript" >
			 MemberConflict="<%=meetingSetInfo2.getMemberConflict()%>";
			 MemberConflictChk= "<%=meetingSetInfo2.getMemberConflictChk()%>";
		</SCRIPT>
		<%
		
	}
	
	if("bill_bohaileave".equalsIgnoreCase(_tableDBName)){
		%>
	    			<input type="hidden" id="allannualdays" name="allannualdays" value="<%=allannual%>" />
	    			<input type="hidden" id="allpsldays" name="allpsldays" value="<%=allpsldays%>"  />
	    			<input type="hidden" id="paidLeaveDays" name="paidLeaveDays" value="<%=paidLeaveDays%>"  />
	    			<input type="hidden" id="strleaveTypes" name="strleaveTypes" value="<%=strleaveTypes%>"  />
		<%
	}
    //附件上传
	if ("6".equals(fieldHtmlType)) {
		if (!"".equals(fieldValue)) {
			docids=fieldValue.split(",");
	       
			for (String docid:docids) {
				docManager.resetParameter();
				docManager.setId(Util.getIntValue(docid,0));
                
				RecordSet.executeSql("select  imagefilename,imagefileid  from DocImageFile  where docid="+Util.getIntValue(docid,0));
				if(RecordSet.next())
				{
				   fileExtend=RecordSet.getString("imagefilename");
				   imageFileid=RecordSet.getString("imagefileid");
				   
				   if (fileExtend.lastIndexOf(".") != -1) {
				       fileExtend = fileExtend.substring(fileExtend.lastIndexOf("."));
				   } else {
					   fileExtend = "";
				   }
				}else
				{
				   fileExtend="";
				}
				docManager.getDocInfoById();
				item="{\"filetitle\":\""+docManager.getDocsubject()+fileExtend+"\",\"fileauthor\":\""+resource.getLastname(""+docManager.getOwnerid())+"\",\"" +
						"filecreatetime\":\""+docManager.getDoccreatedate()+"\",\"fileid\":\""+imageFileid+"\",\"filetype\":\"1\"}";
				attachmentssb.append(item).append(",");
			}	
		}
	} else if("3".equals(fieldHtmlType) && ("9".equals(fieldType) || "37".equals(fieldType))) { //文档和多文档
		if(!"".equals(fieldValue)) { 
			uploadids=fieldValue.split(",");
			for(String docid:uploadids) {
				docManager.resetParameter();
				docManager.setId(Util.getIntValue(docid,0));
				docManager.getDocInfoById();
				item="{\"filetitle\":\""+docManager.getDocsubject()+"\",\"fileauthor\":\""+resource.getLastname(""+docManager.getOwnerid())+"\",\"" +
						"filecreatetime\":\""+docManager.getDoccreatedate()+"\",\"fileid\":\""+docid+"\",\"filetype\":\"0\"}";
				attachmentssb.append(item).append(",");
			}
		}
	}

	if (view) {
		String fieldEmptystyle = "";
		if (("".equals(Util.delHtml(fieldShowValue).trim()) && (!edit || !canEdit))
				&& assignmentFieldNames.indexOf(fieldFormName) == -1&& !WorkflowServiceUtil.isRowColumnRule(formId,fieldFormName)) {
		    if (!("2".equals(fieldHtmlType) && "2".equalsIgnoreCase(fieldType))) {
				fieldEmptystyle = " name='emptyFieldTR' style='display:none;!important;' ";
		    }
		}
		if (i != 0) {
%>
		<tr width="100%" <%=fieldEmptystyle %>>
			<td colspan="3" class="mainFromSplitLine"></td>
		</tr>
<%
		} 
		//如果是多行文本,则列名与内容在同一列显示

		
		if (!("2".equals(fieldHtmlType) && "2".equalsIgnoreCase(fieldType)) || !"".equals(fieldEmptystyle)) {
%>
		<tr <%=fieldEmptystyle%>>
			<td class="mainFormRowNameTD">
				<%=fieldShowName %>
			    <%if(!"".equals(fieldEmptystyle)){%>
				   <script>
				       $(document).ready(function () {
	                       if($("#<%=fieldFormName%>_ismandfield").length>0){
							     $("#<%=fieldFormName%>_ismandfield").val("");
								 document.getElementById("<%=fieldFormName.trim()%>_ismandfield").setAttribute("id","< %=fieldFormName.trim()%>ismandfield");
						   }
                       });
				   </script>
				<%}%>
			</td>

			<td style="width:15px;"></td>
			<td width="*" class="mainFormRowValueTD" id="<%=fieldFormName %>_tdwrap">
<%
		} else {
%>
		<tr>
			<td width="*" colspan="3" class="mainFormRowValueTD"  id="<%=fieldFormName %>_tdwrap">
				<div style="font-size:16px;font-weight:bold;text-align:center;">
					<%=fieldShowName %>
				</div>
				<br/>
<%
		}
%>
				<div class="mainFormRowValueTDDIV" id="<%=fieldFormName %>_tdwrap_div">
<%
//===================================================表单当前可以编辑、且字段亦可编辑状态 start===================================================
	if (edit && canEdit) {
			//会议审批单特殊处理

			boolean remindType = false;
			if (fieldName.equalsIgnoreCase("remindType") && workflowRequestInfo.getWorkflowMainTableInfo().getTableDBName().trim().equalsIgnoreCase("bill_meeting")) {
				if ("2".equals(fieldValue) || "3".equals(fieldValue)) {
					remindType = true;
				}
			}
			
			if ((fieldName.equalsIgnoreCase("remindType")
					|| fieldName.equalsIgnoreCase("remindBeforeStart")
					|| fieldName.equalsIgnoreCase("remindBeforeEnd")
					|| fieldName.equalsIgnoreCase("remindTimesBeforeStart")
					|| fieldName.equalsIgnoreCase("remindTimesBeforeEnd"))
				    && workflowRequestInfo.getWorkflowMainTableInfo().getTableDBName().trim().equalsIgnoreCase("bill_meeting")) {
			%>
					<table style="width: 100%;">
						<tr>
							<td id="remindType_<%=fieldName %>" style="width:99%;white-space:normal;display:<%=(remindType?"none":"block")%>" align="left">
					<%
					if (fieldName.equalsIgnoreCase("remindType")) {
					%>
								<SCRIPT type="text/javascript" >
								<!--
									function doChangeRemindType(obj){
										if(obj.value=="1"){
											$('td#remindType_remindBeforeStart').hide();
											$('td#remindType_remindBeforeEnd').hide();
											$('td#remindType_remindTimesBeforeStart').hide();
											$('td#remindType_remindTimesBeforeEnd').hide();
											<%
											if ("".equals(requestid) || "0".equals(requestid)) {
											%>
												$(fieldIdRemindBeforeStart)[0].checked = false;
												$(fieldIdRemindBeforeEnd)[0].checked = false;
												$(fieldIdRemindTimesBeforeStart)[0].value = "";
												$(fieldIdRemindTimesBeforeEnd)[0].value = "";
											<%
											}%>
										} else {
											$('td#remindType_remindBeforeStart').show();
											$('td#remindType_remindBeforeEnd').show();
											$('td#remindType_remindTimesBeforeStart').show();
											$('td#remindType_remindTimesBeforeEnd').show();
											<%
											if ("".equals(requestid) || "0".equals(requestid)) {
											%>
												$(fieldIdRemindBeforeStart)[0].checked = true;
												$(fieldIdRemindBeforeEnd)[0].checked = true;
												$(fieldIdRemindTimesBeforeStart)[0].value = 10;
												$(fieldIdRemindTimesBeforeEnd)[0].value = 10;
											<%
											}%>
										}
									}
								-->
								</SCRIPT>
								<select   class="scroller_select" name="<%=fieldFormName %>" id="<%=fieldFormName %>" onchange="javascript:doChangeRemindType(this);">
						<%
						for (int x=0; x<selectvalues.length; x++) {
							String selectvalue = selectvalues[x];
						%>
									<option value="<%=selectvalue%>" <%=selectvalue.equals(fieldValue)?"selected":""%> > <%=selectNames[x] %> </option>
						<% } %>
								</select>
							
								<script type="text/javascript" >
									fieldIdRemindType = "<%=fieldFormName%>";
								</script>
					<%
					}
								
					if (fieldName.equalsIgnoreCase("remindBeforeStart")) {
					%>	
								<div data-role="fieldcontain">
									<input type="checkbox" name="<%=fieldFormName%>" id="<%=fieldFormName%>" class="custom" <%=fieldValue.equals("1") ? "checked" : "" %> value="1"/>
									<label for="<%=fieldFormName %>" />&nbsp;</label>
								</div>
								<script type="text/javascript" language="javascript">
									fieldIdRemindBeforeStart = "#<%=fieldFormName%>";
								</script>
					<%
					}
					if (fieldName.equalsIgnoreCase("remindBeforeEnd")) {
					%>
								<div data-role="fieldcontain">
									<input type="checkbox" name="<%=fieldFormName%>" id="<%=fieldFormName%>" class="custom" <%=fieldValue.equals("1") ? "checked" : "" %> value="1"/>
									<label for="<%=fieldFormName %>">&nbsp;</label>
								</div>
								<script type="text/javascript" language="javascript">
									fieldIdRemindBeforeEnd = "#<%=fieldFormName%>";
								</script>
					<%
					}
					if (fieldName.equalsIgnoreCase("remindTimesBeforeStart")) { 
					%>
								<input type="text" name="<%=fieldFormName %>" id="<%=fieldFormName %>" value="<%=!"".equals(fieldValue) ? fieldValue : ""%>" />
								<script type="text/javascript" language="javascript">
									fieldIdRemindTimesBeforeStart = "#<%=fieldFormName%>";
								</script>
					<%
					}
					if (fieldName.equalsIgnoreCase("remindTimesBeforeEnd")) {
					%>
							
								<input type="text" name="<%=fieldFormName %>" id="<%=fieldFormName %>" value="<%=!"".equals(fieldValue) ? fieldValue : ""%>" />
								<script type="text/javascript" language="javascript">
									fieldIdRemindTimesBeforeEnd = "#<%=fieldFormName%>";
								</script>
					<%
					}
					%>
						
							</td>
						</tr>
					</table>
			<%
			//请假申请单特殊处理

			} else if ((fieldName.equalsIgnoreCase("leaveDays")||fieldName.equalsIgnoreCase("fromDate")||fieldName.equalsIgnoreCase("fromTime")||fieldName.equalsIgnoreCase("toDate")||fieldName.equalsIgnoreCase("toTime"))
						&& workflowRequestInfo.getWorkflowMainTableInfo().getTableDBName().trim().equalsIgnoreCase("bill_bohaileave")) {
				if (fieldName.equalsIgnoreCase("fromDate")) {
			%>
					<SCRIPT language="JavaScript">
					//<!--
						function doChangeLeaveDateTime(){
							var formDateVal = $("[nameBak='fromDate']").val();
							var fromTimeVal = $("[nameBak='fromTime']").val();
							var toDateVal = $("[nameBak='toDate']").val();
							var toTimeVal = $("[nameBak='toTime']").val();
							var newLeaveType = $("[nameBak='newLeaveType']").val();
							if(formDateVal && fromTimeVal && toDateVal && toTimeVal){
								$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getLeaveDays',{fromDate:formDateVal,fromTime:fromTimeVal,toDate:toDateVal,toTime:toTimeVal,resourceId:"<%=userid%>",newLeaveType:newLeaveType},
									function process(dataObj){
										if(dataObj){
											$("[nameBak='leaveDays']").val(dataObj.days);
										}
									}
								,"json");
							}
						}
						function showVacationInfo() {
							
							var newLeaveType = $("[nameBak='newLeaveType']").val();
							var resourceId = "<%=creater%>";			
							var result = "";
							if(newLeaveType == '<%=HrmAttVacation.L6%>') {
								getAnnualInfo(resourceId);
							} else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
								getPSInfo(resourceId);
							} else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
								getTXInfo(resourceId);
							}else if(newLeaveType != '' && '<%=strleaveTypes%>'.indexOf(","+newLeaveType+",") > -1){
		    					getPSInfo(resourceId);
							}
						}
						function getAnnualInfo(resourceId) {
							if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
								$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getAnnualInfo',{bohai:"true",cmd:"leaveInfo", currentDate:"<%=currentdate%>",resourceId:resourceId},
									function process(dataObj){
										if(dataObj) {
											$("#allannualdays").val(dataObj.allannualValue);
											var vacationInfoObj =  $("[nameBak='vacationInfo']");
											try{if(vacationInfoObj.attr("readonly") != true) vacationInfoObj.attr("readonly","readonly");}catch(e){}
											vacationInfoObj.html(dataObj.info);
										}
									}
								,"json");
							}
						}
						function getPSInfo(resourceId) {
							//alert(resourceId + "===getPSInfo");
							var newLeaveType = $("[nameBak='newLeaveType']").val();							
							
							if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
								$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getPSInfo',{bohai:"true",cmd:"leaveInfo", currentDate:"<%=currentdate%>", resourceId:resourceId,leavetype:newLeaveType},
									function process(dataObj){
										if(dataObj) {
											$("#allpsldays").val(dataObj.allpsldaysValue);
											var vacationInfoObj =  $("[nameBak='vacationInfo']");
											try{if(vacationInfoObj.attr("readonly") != true) vacationInfoObj.attr("readonly","readonly");}catch(e){}
											vacationInfoObj.html(dataObj.info);
										}
									}
								,"json");
							}
						}
						function getTXInfo(resourceId) {
							//alert(resourceId + "===getPSInfo");
							var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
							if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
								$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getTXInfo',{bohai:"true",cmd:"leaveInfo", currentDate:fromDate,resourceId:resourceId},
									function process(dataObj){
										if(dataObj) {
											$("#paidLeaveDays").val(dataObj.paidLeaveDaysValue);
											var vacationInfoObj =  $("[nameBak='vacationInfo']");
											try{if(vacationInfoObj.attr("readonly") != true) vacationInfoObj.attr("readonly","readonly");}catch(e){}
											vacationInfoObj.html(dataObj.info);
										}
									}
								,"json");
							}
						}
				       $(document).ready(function () {
				       		showVacationInfo(); 
                       });
					//-->
					</SCRIPT>
				<%
				} 
				if (fieldName.equalsIgnoreCase("leaveDays")) {
				%>
					<input type="text" name="<%=fieldFormName%>" id="<%=fieldFormName%>" readonly="true" nameBak="<%=fieldName%>" value="<%=fieldValue %>" >
				<%
				} 
				if ((fieldName.equalsIgnoreCase("fromDate") || fieldName.equalsIgnoreCase("toDate"))) {
				%>
					<input type="text" name="<%=fieldFormName%>" id="<%=fieldFormName%>" nameBak="<%=fieldName%>" value="<%=fieldValue%>"
						class="scroller_date" onblur="validateDate(this);" onchange="doChangeLeaveDateTime();"/>
				<%
				}
				if ((fieldName.equalsIgnoreCase("fromTime") || fieldName.equalsIgnoreCase("toTime") )) {
				%>
					<input type="text" name="<%=fieldFormName%>" id="<%=fieldFormName%>" nameBak="<%=fieldName%>" value="<%=fieldValue%>"
						class="scroller_time" onblur="validateTime(this);" onchange="doChangeLeaveDateTime();"/>
				<%} %>
			<%
			//请假申请单特殊处理

			} else if ((fieldName.equalsIgnoreCase("leaveType")||fieldName.equalsIgnoreCase("otherLeaveType"))
					&&workflowRequestInfo.getWorkflowMainTableInfo().getTableDBName().trim().equalsIgnoreCase("bill_bohaileave")) {
				int showOtherLeaveType = 0;
				if (fieldName.equalsIgnoreCase("leaveType")) {
					if (fieldValue!=null&&fieldValue.equals("4")) {
						showOtherLeaveType = 1;
					}
				}
				String tempfieldValue = fieldValue;
				%>
					<div id="<%=fieldName.equalsIgnoreCase("otherLeaveType") ? "selectOtherLeaveType" : fieldFormName %>"
						style="display:<%if (fieldName.equalsIgnoreCase("otherLeaveType") && showOtherLeaveType == 0) {%> none <%}  else if (fieldName.equalsIgnoreCase("otherLeaveType")&& showOtherLeaveType!=0) { %> block <%} %>;width:100%;">
						<select id="<%=fieldFormName%>" name="<%=fieldFormName%>" nameBak="<%=fieldName%>"
								<%=fieldName.equalsIgnoreCase("leaveType") ? "onchange=\"doChangeLeaveType(this);\"" : ""     %>
								<%=fieldName.equalsIgnoreCase("otherLeaveType") ? "onchange=\"dispalyAnnualInfo(this.value);\"" : ""%> >
							<option value="" <%=tempfieldValue.equals("") ? "selected" : ""%>></option>
							<%
							for (int x=0; x<selectvalues.length; x++) {
								String selectvalue = selectvalues[x];
							%>
								<option value="<%=workflowRequestInfo.getWorkflowMainTableInfo().getRequestRecords()[0].getWorkflowRequestTableFields()[i].getSelectvalues()[x] %>" 
							<%=selectvalue.equals(tempfieldValue) ?  "selected" : ""%>>
									<%=workflowRequestInfo.getWorkflowMainTableInfo().getRequestRecords()[0].getWorkflowRequestTableFields()[i].getSelectnames()[x] %>
								</option>
							<%} %>
						</select>
					</div>
			<%
			} else {
				if (workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId().equalsIgnoreCase("6") && fieldName.equalsIgnoreCase("mutiresource")&&!edit&&view) {
				%>
					<span onclick="showwfsigndetail(this, 'nblyp6');" style="font-size:12px;color:#666666;">&nbsp;&nbsp;显示&nbsp;&nbsp;</span><span id="nblyp6" style="display:none;"><%=filedHtmlShow%></span>
				<%} else {
					//<!-- 屏蔽html编辑功能  直接显示html效果-->
					if (!"create".equals(type) && fieldHtmlType.equalsIgnoreCase("2") && fieldType.equalsIgnoreCase("2")) {
						if (fieldShowValue.equalsIgnoreCase("") == false) {
							request_fieldShowValue = fieldShowValue;
							String wfContentKey = sessionkey + "_"+ workflowid + "_"+ userid + "_" + i;
							
							StaticObj staticObj = StaticObj.getInstance();
							synchronized(staticObj){
								Map mapWfContents = (Map)staticObj.getObject("SESSION_VIEW_CONTENT_NEWS_OR_WKFLW");
								if(mapWfContents == null){
									mapWfContents = new HashMap();
								}
								mapWfContents.put(wfContentKey, request_fieldShowValue);
								staticObj.putObject("SESSION_VIEW_CONTENT_NEWS_OR_WKFLW", mapWfContents);
							}
							%>
						<input type="hidden" id='vdcontent<%=i %>' value='<%=i %>'></input>
						<%} 
						 filedHtmlShow = filedHtmlShow.replace("<br>","");
						%>
						<%=HtmlUtil.translateMarkup(filedHtmlShow) %>
					<%
                     } else if(fieldHtmlType.equals("3") && (wfreqfield.isIsshowtree() && (fieldType.equals("161") || fieldType.equals("162")))) {
                        String tempfiledHtmlShow = "";
                        if("".equals(fieldShowValue)){
                            tempfiledHtmlShow = filedHtmlShow + "<span style='color:#ACA899'>["+SystemEnv.getHtmlLabelName(83659,user.getLanguage())+"]</span></td>";
                        }else{
                            tempfiledHtmlShow = filedHtmlShow + "<span style='color:#ACA899'>["+SystemEnv.getHtmlLabelName(83657,user.getLanguage())+"]</span></td>";
                        }
                        %>
		                        <%=tempfiledHtmlShow %>
		                <%
					} else { 
					%>
						<%=filedHtmlShow %>
					<%
					} 
					%>
				<%
				} 
				%>
			<%
			} 
			%>										
		<%
//===================================================表单当前可以编辑、且字段亦可编辑状态 end ===================================================
		} else {
//===================================================表单不可以编辑 或者 字段不可编辑状态 start =================================================
			if ("2".equalsIgnoreCase(fieldHtmlType) && "2".equalsIgnoreCase(fieldType)) {
				if ("".equalsIgnoreCase(fieldShowValue) == false) {
					request_fieldShowValue = fieldShowValue;
					String wfContentKey = sessionkey + "_"+ workflowid + "_"+ userid + "_" + i;
					
					StaticObj staticObj = StaticObj.getInstance();
					synchronized(staticObj){
						Map mapWfContents = (Map)staticObj.getObject("SESSION_VIEW_CONTENT_NEWS_OR_WKFLW");
						if(mapWfContents == null){
							mapWfContents = new HashMap();
						}
						mapWfContents.put(wfContentKey, request_fieldShowValue);
						staticObj.putObject("SESSION_VIEW_CONTENT_NEWS_OR_WKFLW", mapWfContents);
					}
					%>
					<input type="hidden" id='vdcontent<%=i %>' value='<%=i %>'>
				<%}
				fieldShowValue = Util.toExcelData(filedHtmlShow);
				%>
				<%=HtmlUtil.translateMarkup(fieldShowValue)%>
				
			<%
			} else {
				//月工作总结与计划 特殊设置
				if ("6".equalsIgnoreCase(workflowRequestInfo.getWorkflowBaseInfo().getWorkflowId()) && "mutiresource".equalsIgnoreCase(fieldName)) {
			%>
					<span onclick="showwfsigndetail(this, 'nblyp6');" style="font-size:12px;color:#666666;">&nbsp;&nbsp;显示&nbsp;&nbsp;</span><span id="nblyp6" style="display:none;"><%=fieldShowValue%></span>
				<%
				}else if(fieldFormName.equals("requestlevel")){
				%>
					<%=filedHtmlShow %>
					<input type="hidden" name="<%=fieldFormName%>" id="<%=fieldFormName%>" value="<%=fieldValue%>"
				<%
				} else {
				%>
					<!-- <span id="<%=fieldFormName %>_span" name="<%=fieldFormName %>_span" > -->
						<%=filedHtmlShow %>
					<!-- </span>  -->
				<%
				}
			}
		}
//===================================================表单不可以编辑 或者 字段不可编辑状态 end   =================================================
		%>
				</div>
			</td>
		</tr>
	<%
	} 
}
%>
	</table>
</div>
<div style="height:10px;overflow:hidden;"></div>
	
	
	
	
<%
boolean ismobile = WorkflowServiceUtil.isMobileMode(workflowid,nodeId);
//行列规则计算
ArrayList colCalAry = new ArrayList(); //合计
ArrayList rowCalAry = new ArrayList(); //行规则
ArrayList mainCalAry = new ArrayList(); //列规则
String rowCalItemStr1="";
String colCalItemStr1="";
String mainCalStr1="";
if("1".equals(isBill)){ //新表单

	  RecordSet.execute("select * from workflow_formdetailinfo where formid="+formId);
	  while(RecordSet.next()){
			rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
			colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
			mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
	  }
	  StringTokenizer stk2 = new StringTokenizer(colCalItemStr1,";"); //列规则

    while(stk2.hasMoreTokens()){
      colCalAry.add(stk2.nextToken());
    }
   stk2 = new StringTokenizer(rowCalItemStr1,";");//行规则

    while(stk2.hasMoreTokens()){
		    rowCalAry.add(stk2.nextToken(";"));
	  }
   stk2 = new StringTokenizer(mainCalStr1,";");
	 while(stk2.hasMoreTokens()){
		mainCalAry.add(stk2.nextToken(";"));
	}
	
}else{//老表单
	 RecordSet.executeProc("Workflow_formdetailinfo_Sel",formId+"");
		while(RecordSet.next()){
			rowCalItemStr1 = Util.null2String(RecordSet.getString("rowCalStr"));
			colCalItemStr1 = Util.null2String(RecordSet.getString("colCalStr"));
			mainCalStr1 = Util.null2String(RecordSet.getString("mainCalStr"));
		}
		StringTokenizer stk2 = new StringTokenizer(colCalItemStr1,";");//列规则

      while(stk2.hasMoreTokens()){
          colCalAry.add(stk2.nextToken());
      }
		stk2 = new StringTokenizer(rowCalItemStr1,";");//行规则

      while(stk2.hasMoreTokens()){
		    rowCalAry.add(stk2.nextToken(";"));
	    }
      stk2 = new StringTokenizer(mainCalStr1,";");
   	 while(stk2.hasMoreTokens()){
   		mainCalAry.add(stk2.nextToken(";"));
   	}
}
java.util.HashMap  summap =new  java.util.HashMap();//默认合计使用  
boolean isAddDetail=("1".equals(isBill) && workflowRequestInfo.getWorkflowBaseInfo().getFormId().indexOf("-")>=0 && !ismobile&&workflowRequestInfo.isCanDetailEdit())||("0".equals(isBill)&&!ismobile&&workflowRequestInfo.isCanDetailEdit());
if("1".equals(isDetailRowShow)){
	isAddDetail = ("1".equals(isBill) && workflowRequestInfo.getWorkflowBaseInfo().getFormId().indexOf("-")>=0 && !ismobile)||("0".equals(isBill)&&!ismobile);
}
if(isAddDetail){%>
<%
int wdtiCount = 0; 
// 明细表是否可编辑处理
boolean isEdits = true;
if (clienttype.equalsIgnoreCase("ipad")) {
	isEdits = true;
} else if (clienttype.equalsIgnoreCase("iphone")){
	isEdits = false;
} else if (clienttype.equalsIgnoreCase("Webclient")){
	isEdits = true;
} else if (clienttype.equalsIgnoreCase("Android")){
	isEdits = false;
} else if (clienttype.equalsIgnoreCase("AndPad")){
	isEdits = true;
}
isEdits = false;
boolean isdisplay = false;
//end 
boolean includeDel = false;
if (!"create".equals(type) && workflowRequestInfo.getWorkflowDetailTableInfos() != null && workflowRequestInfo.getWorkflowDetailTableInfos().length>0) {
%>
<div class="blockHead" id="detailforminfoDivHead" style="display:none">
	<span class="m-l-14">
        <%-- 流程明细 --%>
        <%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())  + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) %>
	</span> 
</div>

<div class="tblBlock" style="width:100%;background:#fff;min-height:25px;padding-bottom:5px;padding-top:5px;" id="detailforminfoDiv">
<%
    StringBuffer sumString =new StringBuffer();//合计的字段

	WorkflowDetailTableInfo[] workflowDetailTableInfos = workflowRequestInfo.getWorkflowDetailTableInfos();
	wdtiCount = workflowDetailTableInfos.length;
	for (int i=0; i<workflowDetailTableInfos.length; i++) {
		boolean isHeJi = false;
		sumString =new StringBuffer();//合计的字段 
		WorkflowDetailTableInfo wfdetailTabInfo = workflowDetailTableInfos[i];
		String[] tableFieldName = wfdetailTabInfo.getTableFieldName();
		WorkflowRequestTableRecord[] workflowRequestTableRecords = wfdetailTabInfo.getWorkflowRequestTableRecords();
		int index = i + 1;
		int tblHeadCnt = tableFieldName.length - 1;
		if(!"1".equals(wfdetailTabInfo.getIsEdit())){
			isdisplay = true;
		}else{
			 isdisplay = false;
		}
		if("1".equals(wfdetailTabInfo.getIsDelete())){
			 includeDel = true;
		}else{
			  includeDel = false;
		}
		 int tableOrderId = 0;
		 String tableDBName = wfdetailTabInfo.getTableDBName();
		 if(tableDBName.lastIndexOf("_")>=0){
		     	tableOrderId =  Integer.parseInt(tableDBName.substring(tableDBName.lastIndexOf("_")+"_dt".length()));
		 }else if("0".equals(isBill) && !"".equals(tableDBName) ){
			     tableOrderId =  Integer.parseInt(tableDBName);
		 }
	%>
    <%@ include file="/mobile/plugin/1/form/detail/jsaddanddelete.jsp" %>
	<div style="text-align:right;margin-top:25px">
	  <% if("1".equals(wfdetailTabInfo.getIsAdd())&&canEdit){%>
	        <button name="addbutton<%=i%>"  type=button Class="operationBt"  onclick="addRow<%=i%>(<%=i%>)"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
	  <%} %>
	  <%if(("1".equals(wfdetailTabInfo.getIsAdd()) || "1".equals(wfdetailTabInfo.getIsDelete()))&&canEdit){ 
	  %>
	       <button name="delbutton<%=i%>" type=button Class="operationBt"   onclick="deleteRow(<%=i%>);"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></BUTTON>
	  <%} %>
	</div>
	<div name="detailTableDiv" style="overflow-x:auto;width:100%;"  <%="1".equals(isDetailRowShow)?"":(canEdit?"":"onclick=\"exTblCol(this, "+(tableFieldName.length+1)+");\"")%> >
	    <input type="hidden" id="nodenum<%=i%>"  name="nodenum<%=i %>"  value="<%=workflowRequestTableRecords.length %>" />
		<input type="hidden" id="newRowNum<%=i%>"  name="newRowNum<%=i %>"  value="<%="create".equals(method)?0:workflowRequestTableRecords.length %>" />
	    <input type="hidden" name="deleteId<%=i %>"  id="deleteId<%=i %>"   />
		<input type="hidden" id="needAddRow<%=i%>" value="<%=wfdetailTabInfo.getNeedAddRow() %>" />
		<input type="hidden" id="approveCount<%=i%>" name="approveCount<%=i%>" value="<%="create".equals(method)?0:workflowRequestTableRecords.length %>" />
	    <input type="hidden" id="deleteRowIndex<%=i%>" name="deleteRowIndex<%=i%>"  />
		<table id="table<%=i %>" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable"  >
		 <tbody id="detailInfo<%=i %>" >
			<tr>
				<th class="detailFormIndexTD detailLeftTableBorder" <%=canEdit?"":"style=\"display:none\""%>></th>
			    <th class="detailFormIndexTD detailMiddleTableBorder"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>	
		<%
		for (int x=0; x<tableFieldName.length; x++) {
		%>
			   <th class="detailFormIndexTDValue detailMiddleTableBorder" >
					<%=tableFieldName[x] %>
			   </th>
			   <%if(x==(tableFieldName.length-1)){ %>
			      <th class="detailFormIndexTDValue detailRightTableBorder" width="0%" style="display:none;" >
			      </th> 
			   <%} %>
		<%
		}
		%>
			</tr>
	<%
      String defaultRow = wfdetailTabInfo.getDefaultRow(); //新增默认空明细

	  String defaultRowCount = wfdetailTabInfo.getDefaultRowCount(); //新增默认空明细行数

	  String needAddRow = wfdetailTabInfo.getNeedAddRow(); //必须新增明细
	  if("create".equals(method)){//add by liaodong 
		  int defaultRowCountInt =!"".equals(defaultRowCount)&&null!=defaultRowCount?Integer.parseInt(defaultRowCount):0;
           if("1".equals(defaultRow)&&defaultRowCountInt>0){   
		%>
          <script language="javascript">
		      document.getElementById("nodenum<%=i%>").value = 0;
		       var lengthVar=<%=defaultRowCountInt%>;
		       for(var s=0;s<lengthVar;s++){
			       addRow<%=i %>(<%=i %>);
		       }
		  </script>
       <%
		}else{
			%>
            <script language="javascript">
		       document.getElementById("nodenum<%=i%>").value = 0;
		     </script>
			<%
		 }
		 //编辑页面获取合计行

		 String sumStr = WorkflowServiceUtil.getSumString(workflowid,nodeId,user,tableOrderId,colCalItemStr1);
		 if(!"".equals(sumStr)){
               sumString.append(sumStr);
			   isHeJi = true;
		 }
	  }else{
		for (int x=0; x<workflowRequestTableRecords.length; x++) {
			WorkflowRequestTableRecord wfreqtabrec = workflowRequestTableRecords[x];
			WorkflowRequestTableField[] workflowRequestTableFields2 = wfreqtabrec.getWorkflowRequestTableFields();
			int tdcount = 0;
			int tblCentCnt = 0;
			int recordOrder = wfreqtabrec.getRecordOrder();
			int recodeId = wfreqtabrec.getRecordId();
			int fieldCount = 0;
		%>
			<tr class="isneed_<%=i%>" style="background-color:#F7F7F7;" <%="1".equals(isDetailRowShow)?"onclick=\"trMouseOver("+i+","+x+");\"":(canEdit?"onclick=\"trMouseOver("+i+","+x+");\"":"")%> >
			  <td class="detailCountTDValue" <%=canEdit?"":"style=\"display:none\""%>>
			    <input onclick="event.stopPropagation();"  type="checkbox" name="check_node<%=i %>"  value="<%=recodeId %>"  <%=includeDel?"":"disabled"%>/>
			 </td>
			<%
			 //if (recordOrder < 0) {
			%>
				<!-- <td class="detailCountTD">合计</td>-->
			<% //} else { %>
				<td   id="detailRowNum<%=i %>_<%=x %>" class="detailValueTD"><%=x + 1 %></td>
			<%//}
			tblCentCnt = workflowRequestTableFields2.length - 1;
			 //System.out.println("this is enter===========================>"+workflowRequestTableFields2.length+"==="+tblHeadCnt+"====="+tblCentCnt);
			if (tblHeadCnt == tblCentCnt) {
				for (int y=0; y<workflowRequestTableFields2.length; y++) {
					WorkflowRequestTableField wfreqtabfield = workflowRequestTableFields2[y];
            
					String fieldHtmlType = wfreqtabfield.getFieldHtmlType();
					String fieldType = wfreqtabfield.getFieldType();
					String fieldId=wfreqtabfield.getFieldId();
						

					String fieldValue = wfreqtabfield.getFieldValue();
					String fileExtend="";
              
			        


					if(colCalItemStr1.indexOf(fieldId)>=0){
						 isHeJi = true;
					}
					if(colCalItemStr1.indexOf(fieldId)>=0){ 
                             if(!"".equals(wfreqtabfield.getFieldValue())&&null != wfreqtabfield.getFieldValue()){
									 if( null != summap.get(fieldId)){
										 String  sumField=(String)summap.get(fieldId);
										 String sumDefaultValue = wfreqtabfield.getFieldValue();
										 if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
											  sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
										 }
										 summap.put(fieldId,(Double.parseDouble(sumField)+Double.parseDouble(sumDefaultValue))+"");
									 }else{
										   String sumDefaultValue = wfreqtabfield.getFieldValue();
										    if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
											    sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
										    }
										   summap.put(fieldId,sumDefaultValue);  
									 }
						   }
					}
					if (wfreqtabfield.isView()) {
							tdcount++;
                            //附件上传
							if ("6".equals(fieldHtmlType)) {
								if (!"".equals(fieldValue)) {
									docids=fieldValue.split(",");
								   
									for (String docid:docids) {
										docManager.resetParameter();
										docManager.setId(Util.getIntValue(docid,0));
										
										RecordSet.executeSql("select  imagefilename,imagefileid  from DocImageFile  where docid="+Util.getIntValue(docid,0));
										if(RecordSet.next())
										{
										   fileExtend=RecordSet.getString("imagefilename");
										   imageFileid=RecordSet.getString("imagefileid");
										   if (fileExtend.lastIndexOf(".") != -1) {
										       fileExtend = fileExtend.substring(fileExtend.lastIndexOf("."));
										   } else {
											   fileExtend = "";
										   }
										}else
										{
										   fileExtend="";
										}
										docManager.getDocInfoById();
										item="{\"filetitle\":\""+docManager.getDocsubject()+fileExtend+"\",\"fileauthor\":\""+resource.getLastname(""+docManager.getOwnerid())+"\",\"" +
												"filecreatetime\":\""+docManager.getDoccreatedate()+"\",\"fileid\":\""+imageFileid+"\",\"filetype\":\"1\"}";
										attachmentssb.append(item).append(",");
									}	
								}
							} else if("3".equals(fieldHtmlType) && ("9".equals(fieldType) || "37".equals(fieldType))) { //文档和多文档
								if(!"".equals(fieldValue)) { 
									uploadids=fieldValue.split(",");
									for(String docid:uploadids) {
										docManager.resetParameter();
										docManager.setId(Util.getIntValue(docid,0));
										docManager.getDocInfoById();
										item="{\"filetitle\":\""+docManager.getDocsubject()+"\",\"fileauthor\":\""+resource.getLastname(""+docManager.getOwnerid())+"\",\"" +
												"filecreatetime\":\""+docManager.getDoccreatedate()+"\",\"fileid\":\""+docid+"\",\"filetype\":\"0\"}";
										attachmentssb.append(item).append(",");
									}
								}
							}
						%>
				<td class="detailValueTD" style="<%=fieldHtmlType.equals("1") && (fieldType.equals("2") || fieldType.equals("3")) ? "text-align:left;" : "" %>
				<%=wfreqtabfield.getFieldOrder() < 0 ? "color:red;font-weight:bold;" : ""%>" >
				   <% if("1".equals(wfdetailTabInfo.getIsEdit())){%>
				      <%if(isEdits){%>
				        <%=wfreqtabfield.getFiledHtmlShow() %>
				      <%}else{ %>
					    <input type="hidden" id="<%=fieldId%><%=x %>"  value="isshow<%=i %>_<%=x %>_<%=fieldCount %>"/>
				        <div id="isshow<%=i %>_<%=x %>_<%=fieldCount %>">
				          <%=wfreqtabfield.getFieldShowValue() %>
				       </div>
				       <div id="isedit" style="display:none">
					     <%if("1".equals(isDetailRowShow)){%>
				             <%if(canEdit){%>
				                <%=wfreqtabfield.getFiledHtmlShow() %>
						    <%}else{%>
						       <%
								  String detailFieldShowValue = wfreqtabfield.getFieldShowValue(); 
				                if(fieldHtmlType.equals("1")&&fieldType.equals("4")&&detailFieldShowValue.indexOf("<script")!=-1){
						           String codeVaue = Util.null2String(detailFieldShowValue.substring(0,detailFieldShowValue.indexOf("<script"))).trim();
						         %>
								   <%if(!"".equals(wfreqtabfield.getFieldValue())&&codeVaue.equals(wfreqtabfield.getFieldValue())){%>
						                <span id="<%=wfreqtabfield.getFieldFormName() %>_span"></span><span style="display:none;"><%=detailFieldShowValue %></span>
						            <%}else{ %>
						                <%=detailFieldShowValue %>
						             <%} %> 
                                 <%}else{%>
								      <%=detailFieldShowValue %>
								 <%}%>
						    <%}%>
						 <%}else{%>
						    <%=wfreqtabfield.getFiledHtmlShow() %>
						 <%}%>
				       </div>
				      <%}%>
				   <%}else{
				     String detailFieldShowValue = wfreqtabfield.getFieldShowValue();
				   %>
				      <%if(colCalItemStr1.indexOf(fieldId)>=0){%>
					     <%if(detailFieldShowValue.indexOf("<span")==-1){%>
						   <span id="<%=wfreqtabfield.getFieldFormName() %>_span" name="<%=wfreqtabfield.getFieldFormName() %>_span" >
					          <%=detailFieldShowValue %>
						   </span>
						 <%}else{%>
						    <%if(fieldHtmlType.equals("1")&&fieldType.equals("4")&&detailFieldShowValue.indexOf("<script")!=-1){
						           String codeVaue = Util.null2String(detailFieldShowValue.substring(0,detailFieldShowValue.indexOf("<script"))).trim();
						     %>
						     <%if(!"".equals(wfreqtabfield.getFieldValue())&&codeVaue.equals(wfreqtabfield.getFieldValue())){%>
						           <span id="<%=wfreqtabfield.getFieldFormName() %>_span"></span>
						           <span style="display:none;">
						           <%=detailFieldShowValue %>
						           </span>
						       <%}else{ %>
						           <%=detailFieldShowValue %>
						       <%} %>
						    <% }else{%>
						        <%=detailFieldShowValue %>
						    <%} %>
						 <%}%>
						  <span id="<%=wfreqtabfield.getFieldFormName() %>_span_d" name="<%=wfreqtabfield.getFieldFormName() %>_span_d" >
						   </span>
						 <input type="hidden" _detailRecordId="<%=recodeId %>" fieldType="1"    id="field<%=fieldId%>_<%=x %>" name="field<%=fieldId%>_<%=x %>" value="<%=wfreqtabfield.getFieldValue() %>" />
					  <%}else{%>
					     <%if(detailFieldShowValue.indexOf("<span")==-1){%>
						   <span id="<%=wfreqtabfield.getFieldFormName() %>_span" name="<%=wfreqtabfield.getFieldFormName() %>_span" >
					          <%=detailFieldShowValue %>
						   </span>
						 <%}else{%>
						        <%if(fieldHtmlType.equals("1")&&fieldType.equals("4")&&detailFieldShowValue.indexOf("<script")!=-1){
						           String codeVaue = Util.null2String(detailFieldShowValue.substring(0,detailFieldShowValue.indexOf("<script"))).trim();
						     %>
						     <%if(!"".equals(wfreqtabfield.getFieldValue())&&codeVaue.equals(wfreqtabfield.getFieldValue())){%>
						           <span id="<%=wfreqtabfield.getFieldFormName() %>_span"></span>
						           <span style="display:none;">
						           <%=detailFieldShowValue %>
						           </span>
						       <%}else{ %>
						           <%=detailFieldShowValue %>
						       <%} %>
						    <% }else{%>
						        <%=detailFieldShowValue %>
						    <%} %>
						 <%}%>
						 <span id="<%=wfreqtabfield.getFieldFormName() %>_span_d" name="<%=wfreqtabfield.getFieldFormName() %>_span_d" >
						   </span>
						 <input type="hidden" _detailRecordId="<%=recodeId %>" name="<%=wfreqtabfield.getFieldFormName() %>" id="<%=wfreqtabfield.getFieldFormName() %>" _fieldhtmlType="<%=wfreqtabfield.getFieldHtmlType() %>" value="<%=wfreqtabfield.getFieldValue()%>" nameBak="<%=wfreqtabfield.getFieldName()%>" >
					  <%}%>
				   <%} %>
				</td>
					<%
					  if(x==(workflowRequestTableRecords.length-1)){
					     sumString.append("<td style=\"text-align:left;\" class=\"detailValueTD\" id=\"sum"+wfreqtabfield.getFieldId()+"\">");
					     sumString.append("<input type=\"hidden\" name=\"sumvalue"+wfreqtabfield.getFieldId()+"\" >");
					     sumString.append("</td>");
					  }
					   fieldCount ++ ;
					}
				} 
			} else { 
				for (int y=0; y<workflowRequestTableFields2.length; y++) {
					WorkflowRequestTableField wfreqtabfield = workflowRequestTableFields2[y];
					String fieldHtmlType = wfreqtabfield.getFieldHtmlType();
					String fieldType = wfreqtabfield.getFieldType();
					int fieldOrder = wfreqtabfield.getFieldOrder();
					String fieldId=wfreqtabfield.getFieldId();

					String fieldValue = wfreqtabfield.getFieldValue();
					String fileExtend="";
               
					
					if(colCalItemStr1.indexOf(fieldId)>=0){
						 isHeJi = true;
					}
					String fieldShowValue = wfreqtabfield.getFieldShowValue();
						if(colCalItemStr1.indexOf(fieldId)>=0){ 
                                if(!"".equals(wfreqtabfield.getFieldValue()) && null != wfreqtabfield.getFieldValue()){
									   if( null != summap.get(fieldId)){
										   String  sumField=(String)summap.get(fieldId);
										   String sumDefaultValue = wfreqtabfield.getFieldValue();
										 if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
											  sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
										 }
										 summap.put(fieldId,(Double.parseDouble(sumField)+Double.parseDouble(sumDefaultValue))+"");
									   }else{
										    String sumDefaultValue = wfreqtabfield.getFieldValue();
										    if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
											    sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
										    }
										   summap.put(fieldId,sumDefaultValue);
									   }
								 }
					 }
					if (wfreqtabfield.isView()) {
						//附件上传
						if ("6".equals(fieldHtmlType)) {
							if (!"".equals(fieldValue)) {
								docids=fieldValue.split(",");
							   
								for (String docid:docids) {
									docManager.resetParameter();
									docManager.setId(Util.getIntValue(docid,0));
									
									RecordSet.executeSql("select  imagefilename,imagefileid  from DocImageFile  where docid="+Util.getIntValue(docid,0));
									if(RecordSet.next())
									{
									   fileExtend=RecordSet.getString("imagefilename");
									   imageFileid=RecordSet.getString("imagefileid");
									   if (fileExtend.lastIndexOf(".") != -1) {
									       fileExtend = fileExtend.substring(fileExtend.lastIndexOf("."));
									   } else {
										   fileExtend = "";
									   }
									}else
									{
									   fileExtend="";
									}
									docManager.getDocInfoById();
									item="{\"filetitle\":\""+docManager.getDocsubject()+fileExtend+"\",\"fileauthor\":\""+resource.getLastname(""+docManager.getOwnerid())+"\",\"" +
											"filecreatetime\":\""+docManager.getDoccreatedate()+"\",\"fileid\":\""+imageFileid+"\",\"filetype\":\"1\"}";
									attachmentssb.append(item).append(",");
								}	
							}
						} else if("3".equals(fieldHtmlType) && ("9".equals(fieldType) || "37".equals(fieldType))) { //文档和多文档
							if(!"".equals(fieldValue)) { 
								uploadids=fieldValue.split(",");
								for(String docid:uploadids) {
									docManager.resetParameter();
									docManager.setId(Util.getIntValue(docid,0));
									docManager.getDocInfoById();
									item="{\"filetitle\":\""+docManager.getDocsubject()+"\",\"fileauthor\":\""+resource.getLastname(""+docManager.getOwnerid())+"\",\"" +
											"filecreatetime\":\""+docManager.getDoccreatedate()+"\",\"fileid\":\""+docid+"\",\"filetype\":\"0\"}";
									attachmentssb.append(item).append(",");
								}
							}
						}
						if (false) {
						} else {
							tdcount++;
						%>
				<td class="detailValueTD2" style="<%=fieldHtmlType.equals("1") && (fieldType.equals("2") || fieldType.equals("3"))? "text-align:left;" : "" %>
				<%=(fieldOrder < 0 ? "color:red;font-weight:bold;" : "")%>">
				   <% if("1".equals(wfdetailTabInfo.getIsEdit())){%>
				      <%if(isEdits){ %>
				        <%=wfreqtabfield.getFiledHtmlShow() %>
				      <%}else{ %>
					    <input type="hidden" id="<%=fieldId%><%=x %>"  value="isshow<%=i %>_<%=x %>_<%=fieldCount %>"/>
				        <div id="isshow<%=i %>_<%=x %>_<%=fieldCount %>">
				             <%=wfreqtabfield.getFieldShowValue() %>
				       </div>
				       <div id="isedit" style="display:none">
				         <%if("1".equals(isDetailRowShow)){%>
				             <%if(canEdit){%>
				                <%=wfreqtabfield.getFiledHtmlShow() %>
						    <%}else{%>
							     <%
								  String detailFieldShowValue = wfreqtabfield.getFieldShowValue(); 
				                if(fieldHtmlType.equals("1")&&fieldType.equals("4")&&detailFieldShowValue.indexOf("<script")!=-1){
						           String codeVaue = Util.null2String(detailFieldShowValue.substring(0,detailFieldShowValue.indexOf("<script"))).trim();
						         %>
								   <%if(!"".equals(wfreqtabfield.getFieldValue())&&codeVaue.equals(wfreqtabfield.getFieldValue())){%>
						                 <span id="<%=wfreqtabfield.getFieldFormName() %>_span"></span><span style="display:none;"><%=detailFieldShowValue %></span>
						            <%}else{ %>
						                <%=detailFieldShowValue %>
						             <%} %> 
                                 <%}else{%>
								      <%=detailFieldShowValue %>
								 <%}%>
						    <%}%>
						 <%}else{%>
						    <%=wfreqtabfield.getFiledHtmlShow() %>
						 <%}%>
				       </div>
				      <%} %>
				   <%}else{ 
				      String detailFieldShowValue = wfreqtabfield.getFieldShowValue();
				   %>
				      <%if(colCalItemStr1.indexOf(fieldId)>=0){%>
					      <%if(detailFieldShowValue.indexOf("<span")==-1){%>
						   <span id="<%=wfreqtabfield.getFieldFormName() %>_span" name="<%=wfreqtabfield.getFieldFormName() %>_span" >
					          <%=detailFieldShowValue %>
						   </span>
						 <%}else{%>
						      <%if(fieldHtmlType.equals("1")&&fieldType.equals("4")&&detailFieldShowValue.indexOf("<script")!=-1){
						           String codeVaue = Util.null2String(detailFieldShowValue.substring(0,detailFieldShowValue.indexOf("<script"))).trim();
						     %>
						     <%if(!"".equals(wfreqtabfield.getFieldValue())&&codeVaue.equals(wfreqtabfield.getFieldValue())){%>
						           <span id="<%=wfreqtabfield.getFieldFormName() %>_span"></span>
						           <span style="display:none;">
						           <%=detailFieldShowValue %>
						           </span>
						       <%}else{ %>
						           <%=detailFieldShowValue %>
						       <%} %>
						    <% }else{%>
						        <%=detailFieldShowValue %>
						    <%} %>
						 <%}%>
						 <input type="hidden" _detailRecordId="<%=recodeId %>" fieldType="1" id="field<%=fieldId%>_<%=x %>" name="field<%=fieldId%>_<%=x %>" value="<%=wfreqtabfield.getFieldValue() %>" />
					  <%}else{%>
					     <%if(detailFieldShowValue.indexOf("<span")==-1){%>
						   <span id="<%=wfreqtabfield.getFieldFormName() %>_span" name="<%=wfreqtabfield.getFieldFormName() %>_span" >
					          <%=detailFieldShowValue %>
						   </span>
						 <%}else{%>
						         <%if(fieldHtmlType.equals("1")&&fieldType.equals("4")&&detailFieldShowValue.indexOf("<script")!=-1){
						           String codeVaue = Util.null2String(detailFieldShowValue.substring(0,detailFieldShowValue.indexOf("<script"))).trim();
						     %>
						     <%if(!"".equals(wfreqtabfield.getFieldValue())&&codeVaue.equals(wfreqtabfield.getFieldValue())){%>
						           <span id="<%=wfreqtabfield.getFieldFormName() %>_span"></span>
						           <span style="display:none;">
						           <%=detailFieldShowValue %>
						           </span>
						       <%}else{ %>
						           <%=detailFieldShowValue %>
						       <%} %>
						    <% }else{%>
						        <%=detailFieldShowValue %>
						    <%} %>
						 <%}%>
						 <input type="hidden" _detailRecordId="<%=recodeId %>" name="<%=wfreqtabfield.getFieldFormName() %>" id="<%=wfreqtabfield.getFieldFormName() %>" _fieldhtmlType="<%=wfreqtabfield.getFieldHtmlType() %>" value="<%=wfreqtabfield.getFieldValue()%>" nameBak="<%=wfreqtabfield.getFieldName()%>" >
					  <%}%>
				   <%} %>
				</td>
						<%
						 if(x==(workflowRequestTableRecords.length-1)){
						     sumString.append("<td class=\"detailValueTD2\" style=\"text-align:left\" id=\"sum"+wfreqtabfield.getFieldId()+"\">");
						     sumString.append("<input type=\"hidden\" name=\"sumvalue"+wfreqtabfield.getFieldId()+"\" >");
						     sumString.append("</td>");
						  }
						 fieldCount ++ ;
						} 
					} 
				} 
			} 
			%>
			  <td width="0%" class="detailValueTD2" style="text-align:center;width:0px;display:none" >
			      <a id="a<%=i %>_<%=x %>" onclick="dyeditPage(<%=i %>,<%=x %>,<%=fieldCount %>,<%=isEdits %>,<%=isdisplay%>);return false;" href="#"></a>
			  </td>
			</tr>
		      <tr width="100%"  id="trspace<%=i %>_<%=x %>" style="display:none">
				 <td width="100%"  colspan="<%=tdcount+3%>" id="tdspace<%=i %>_<%=x %>" align="right"></td>
			  </tr>
		<%
		if (x != 0) {
		%>
			<tr width="100%">
				<td colspan="<%=tdcount%>" class="detailTableSplitLine"></td>
			</tr>
		<%
		}
	}
    if(workflowRequestTableRecords.length == 0 && canEdit){
    	   //当为空的时候需要将默认行数功能添加进来
    	   int defaultRowCountInt =!"".equals(defaultRowCount)&&null!=defaultRowCount?Integer.parseInt(defaultRowCount):0;
    	   if("1".equals(defaultRow)&&defaultRowCountInt>0){   %>
    	          <script language="javascript">
					      document.getElementById("nodenum<%=i%>").value = 0;
					       var lengthVar=<%=defaultRowCountInt%>;
					       for(var s=0;s<lengthVar;s++){
						       addRow<%=i %>(<%=i %>);
					       }
		         </script>
    	   <% }else{%>
    		     <script language="javascript">
		            document.getElementById("nodenum<%=i%>").value = 0;
		         </script>
    	   <%}
		   String sumStr = WorkflowServiceUtil.getApproveSumString(workflowid,nodeId,user,tableOrderId,colCalItemStr1,tableFieldName);
	       if(!"".equals(sumStr)){
			     sumString.append(sumStr);
			     isHeJi = true;
		   }
	}
	%>
	<%} %>
		</tbody>
		  <%if(colCalAry.size()>0&&isHeJi){%>
	          <tfoot>
			   <tr>
			    <%if(canEdit){%> <td class="detailCountTDValue"></td><%}%>
			    <td class="detailValueTD2"><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
			    <%=sumString.toString() %>
			   <td class="detailValueTD2" width="0%" style="display:none;">
			   </td>
			 </tr>
		     </tfoot>
	      <%} %>
		</table>
	</div>
	<%
	}
	%>
     <!-- 拆分明细表--用于添加数据 -->
	   <%@ include file="/mobile/plugin/1/form/detail/rowhtmldetail.jsp" %>
</div>
<div style="height:10px;overflow:hidden;"></div>
<%
}
%>
	<!--  行列规则计算 -->
	  <%@ include file="/mobile/plugin/1/form/detail/jscalculate.jsp" %>
<%}else{%>
<%
if (!"create".equals(method) && workflowRequestInfo.getWorkflowDetailTableInfos() != null && workflowRequestInfo.getWorkflowDetailTableInfos().length>0) {
%>
<div class="blockHead" id="detailforminfoDivHead" style="display:none">
	<span class="m-l-14">
        <%-- 流程明细 --%>
        <%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())  + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) %>
	</span>
</div>

<div class="tblBlock" style="width:100%;background:#fff;min-height:25px;" id="detailforminfoDiv">
<%
    StringBuffer sumString =new StringBuffer();//合计的字段
	WorkflowDetailTableInfo[] workflowDetailTableInfos = workflowRequestInfo.getWorkflowDetailTableInfos();
	for (int i=0; i<workflowDetailTableInfos.length; i++) {
		boolean isHeJi = false;
		WorkflowDetailTableInfo wfdetailTabInfo = workflowDetailTableInfos[i];
		String[] tableFieldName = wfdetailTabInfo.getTableFieldName();
		WorkflowRequestTableRecord[] workflowRequestTableRecords = wfdetailTabInfo.getWorkflowRequestTableRecords();
		int index = i + 1;
		int tblHeadCnt = tableFieldName.length - 1;
	%>
	<div name="detailTableDiv" style="overflow-x:auto;width:100%;" onclick="exTblCol(this, <%=tableFieldName.length + 1 %>);">
		<table id="head" cellspacing="0" cellpadding="0" width="100%" class="mainFormTable" style="<%=i != 0 ? "margin-top:25px;" : "" %>" >
			<tr>
				<th class="detailFormIndexTD" style="border-width:<%=i != 0 ? "1px" : "0px"%> 1px 1px 0;"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>
		<%
		for (int x=0; x<tableFieldName.length; x++) {
		%>
				<th class="detailFormIndexTDValue" style="border-width:<%=i != 0 ? "1px" : "0px" %> 1px 1px 0;">
					<%=tableFieldName[x] %>
				</th>
		<%
		}
		%>
			</tr>
	<%
		for (int x=0; x<workflowRequestTableRecords.length; x++) {
			 sumString =new StringBuffer();//合计的字段
			WorkflowRequestTableRecord wfreqtabrec = workflowRequestTableRecords[x];
			WorkflowRequestTableField[] workflowRequestTableFields2 = wfreqtabrec.getWorkflowRequestTableFields();
			int tdcount = 0;
			int tblCentCnt = 0;
			int recordOrder = wfreqtabrec.getRecordOrder();
			int recordId = wfreqtabrec.getRecordId();
		%>
		<tbody>
			<tr>
			<%
			if (recordOrder < 0) {
			%>
				<td class="detailCountTD">合计</td>
			<%} else { %>
				<td class="detailCountTDValue"><%=x + 1 %></td>
			<%}
			tblCentCnt = workflowRequestTableFields2.length - 1;
			
			if (tblHeadCnt == tblCentCnt) {
				for (int y=0; y<workflowRequestTableFields2.length; y++) {
					WorkflowRequestTableField wfreqtabfield = workflowRequestTableFields2[y];
					String fieldHtmlType = wfreqtabfield.getFieldHtmlType();
					String fieldType = wfreqtabfield.getFieldType();
					String fieldId=wfreqtabfield.getFieldId();
					String detailFieldShowValue = wfreqtabfield.getFieldShowValue();
					if(colCalItemStr1.indexOf(fieldId)>=0){ 
                        if(!"".equals(wfreqtabfield.getFieldValue()) && null != wfreqtabfield.getFieldValue()){
							   if( null != summap.get(fieldId)){
								   String  sumField=(String)summap.get(fieldId);
								   String sumDefaultValue = wfreqtabfield.getFieldValue();
								 if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
									  sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
								 }
								 summap.put(fieldId,(Double.parseDouble(sumField)+Double.parseDouble(sumDefaultValue))+"");
							   }else{
								    String sumDefaultValue = wfreqtabfield.getFieldValue();
								    if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
									    sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
								    }
								   summap.put(fieldId,sumDefaultValue);
							   }
						 }
			          }
					if (wfreqtabfield.isView()) {
							tdcount++;
							if(colCalItemStr1.indexOf(fieldId)>=0){
								 isHeJi = true;
							}
						%>
				<td class="detailValueTD" style="<%=fieldHtmlType.equals("1") && (fieldType.equals("2") || fieldType.equals("3")) ? "text-align:right;" : "" %>
				<%=wfreqtabfield.getFieldOrder() < 0 ? "color:red;font-weight:bold;" : ""%>" >
					<span id="<%=wfreqtabfield.getFieldFormName() %>_span" name="<%=wfreqtabfield.getFieldFormName() %>_span" >
					          <%=detailFieldShowValue %>
					</span>
					<span id="<%=wfreqtabfield.getFieldFormName() %>_span_d" name="<%=wfreqtabfield.getFieldFormName() %>_span_d" >
					</span>
					<input type="hidden" _detailRecordId="<%=recordId %>" fieldType="1"   id="field<%=fieldId%>_<%=x %>" name="field<%=fieldId%>_<%=x %>" value="<%=wfreqtabfield.getFieldValue() %>" />
					</td>
					<%
					   if(x==(workflowRequestTableRecords.length-1)){
					     sumString.append("<td class=\"detailValueTD2\" style=\"text-align:left\" id=\"sum"+wfreqtabfield.getFieldId()+"\">");
					     sumString.append("<input type=\"hidden\" name=\"sumvalue"+wfreqtabfield.getFieldId()+"\" >");
					     sumString.append("</td>");
					   }
					}
				} 
			} else { 
				for (int y=0; y<workflowRequestTableFields2.length; y++) {
					WorkflowRequestTableField wfreqtabfield = workflowRequestTableFields2[y];
					String fieldHtmlType = wfreqtabfield.getFieldHtmlType();
					String fieldType = wfreqtabfield.getFieldType();
					int fieldOrder = wfreqtabfield.getFieldOrder();
					String fieldShowValue = wfreqtabfield.getFieldShowValue();
					String fieldId=wfreqtabfield.getFieldId();
					String detailFieldShowValue = wfreqtabfield.getFieldShowValue();
					if(colCalItemStr1.indexOf(fieldId)>=0){ 
                        if(!"".equals(wfreqtabfield.getFieldValue()) && null != wfreqtabfield.getFieldValue()){
							   if( null != summap.get(fieldId)){
								   String  sumField=(String)summap.get(fieldId);
								   String sumDefaultValue = wfreqtabfield.getFieldValue();
								 if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
									  sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
								 }
								 summap.put(fieldId,(Double.parseDouble(sumField)+Double.parseDouble(sumDefaultValue))+"");
							   }else{
								    String sumDefaultValue = wfreqtabfield.getFieldValue();
								    if(wfreqtabfield.getFieldValue().indexOf(",")>=0){
									    sumDefaultValue = wfreqtabfield.getFieldValue().replace(",","");
								    }
								   summap.put(fieldId,sumDefaultValue);
							   }
						 }
			          }
					if (wfreqtabfield.isView()) {
						if (false) {
						} else {
							if(colCalItemStr1.indexOf(fieldId)>=0){
								 isHeJi = true;
							}
							tdcount++;
						%>
				<td class="detailValueTD2" style="<%=fieldHtmlType.equals("1") && (fieldType.equals("2") || fieldType.equals("3"))? "text-align:right;" : "" %>
				<%=(fieldOrder < 0 ? "color:red;font-weight:bold;" : "")%>">
					<span id="<%=wfreqtabfield.getFieldFormName() %>_span" name="<%=wfreqtabfield.getFieldFormName() %>_span" >
					          <%=detailFieldShowValue %>
					</span>
					<span id="<%=wfreqtabfield.getFieldFormName() %>_span_d" name="<%=wfreqtabfield.getFieldFormName() %>_span_d" >
					</span>
					 <input type="hidden" _detailRecordId="<%=recordId %>" fieldType="1"   id="field<%=fieldId%>_<%=x %>" name="field<%=fieldId%>_<%=x %>" value="<%=wfreqtabfield.getFieldValue() %>" />
					 </td>
						<%
						   if(x==(workflowRequestTableRecords.length-1)){
						     sumString.append("<td class=\"detailValueTD2\" style=\"text-align:left\" id=\"sum"+wfreqtabfield.getFieldId()+"\">");
						     sumString.append("<input type=\"hidden\" name=\"sumvalue"+wfreqtabfield.getFieldId()+"\" >");
						     sumString.append("</td>");
						  }
						} 
						
						
					} 
				} 
			} 
			%>
			</tr>
		<%
		if (x != 0) {
		%>
			<tr width="100%">
				<td colspan="<%=tdcount%>" class="detailTableSplitLine"></td>
			</tr>
		<%
		}
	}
	%>
	</tbody>
	 <%if(colCalAry.size()>0&&isHeJi){%>
	          <tfoot>
			   <tr>
			    <td class="detailValueTD2"><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
			    <%=sumString.toString() %>
			   <td class="detailValueTD2" width="0%" style="display:none;">
			   </td>
			 </tr>
		     </tfoot>
		     <script>
		        $(document).ready(function () {
		            var detailrow = 0; 
				     <%
				      for(int u=0;u<colCalAry.size();u++){
				    	  String fieldStr =(String)colCalAry.get(u);
						  String  defaultValue = "0";
				    	  fieldStr =fieldStr.replaceAll("detailfield_","");
						  if(null != summap.get(fieldStr)&&!"".equals((String)summap.get(fieldStr))){
							  defaultValue = (String)summap.get(fieldStr);
						%>
						try{
				            var sumvalue = <%=defaultValue%>;
				            var datalength = 2;
				            document.getElementById("sum<%=fieldStr%>").innerHTML = toPrecision(sumvalue,datalength);
				        }catch(e){}
						<%}}%>
				       
		        });
		     </script>
	    <%} %>
		</table>
	</div>
	<%
	}
	%>
</div>
<div style="height:10px;overflow:hidden;"></div>
<%
}
}
%>

<%
String rsdata = "";
//如果里面包含元素
if (attachmentssb.length()>2) {
	rsdata = attachmentssb.substring(0, attachmentssb.length()-1) + "]";
} else {
	rsdata = "[]";
}
rsdata=rsdata.replace("\\", "&transline;");
rsdata=rsdata.replace("\"", "\\\"");

%>
<script>
	 try{
	  formcontainattachs = JSON.parse("<%=rsdata%>");
  }catch(e){}
  	jQuery(function(){
	     if(clienttype=='iPhone'||clienttype == "iPad"||clienttype=="Webclient"){
	         $(".mainFromSplitLine").html("<div style='height:0px;'>&nbsp;</div>");
	         $(".detailLeftTableBorder").append("&nbsp;");
	         $(".detailValueTD").append("&nbsp;");
	         $(".detailCountTDValue").append("&nbsp;"); 
	     }
	});
	
	jQuery(document).ready(function(){
		iscustome=0;
	});
</script>