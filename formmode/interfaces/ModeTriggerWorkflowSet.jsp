<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.formmode.service.ModelInfoService" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean   id="xssUtil" class="weaver.filter.XssUtil"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
	<style>
	.e8_tblForm .e8_tblForm_label_other{
		vertical-align: top;
		border-bottom: 1px solid #e6e6e6;
		border-left: 1px solid #e6e6e6;
		padding: 5px 2px;
		padding-left: 20px;
	}
	.e8_tblForm .e8_tblForm_field_other{
		border-bottom: 1px solid #e6e6e6;
		border-left: 1px solid #e6e6e6;
		padding: 5px 7px;
		background-color: #f8f8f8;
	}
	</style>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>    
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28601,user.getLanguage());//模块触发流程设置
String needfav ="1";
String needhelp ="";

String customname = Util.null2String(request.getParameter("customname"));
ModelInfoService modelInfoService = new ModelInfoService();
int modeId = Util.getIntValue(request.getParameter("id"),0);
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeId"),0);
}
if(modeId<=0){
	modeId = Util.getIntValue(request.getParameter("modeid"),0);
}

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeId;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

String modename = modelInfoService.getModelInfoNameByModelInfoId(modeId);
int formId=Util.getIntValue(request.getParameter("formId"),0);
if(modeId > 0 && formId == 0){
		formId = modelInfoService.getFormInfoIdByModelId(modeId); 
}
int id = 0;
int wfformid = 0;
int wfcreater = 0;
int wfcreaterfieldid = 0;
int workflowid=0;
String successwriteback = "";
String failwriteback = "";
String sql = "select * from mode_triggerworkflowset where modeid = " + modeId;
rs.executeSql(sql);
String showcondition = "";
String showconditioncn = "";
while(rs.next()){
	workflowid = rs.getInt("workflowid");
	id = rs.getInt("id");
	wfcreater = rs.getInt("wfcreater");
	wfcreaterfieldid = rs.getInt("wfcreaterfieldid");
	wfformid = Util.getIntValue(WorkflowComInfo.getFormId(String.valueOf(workflowid)));
	successwriteback = Util.null2String(rs.getString("successwriteback"));
	failwriteback = Util.null2String(rs.getString("failwriteback"));
	showcondition = Util.null2String(rs.getString("showcondition"));
	showconditioncn = Util.null2String(rs.getString("showconditioncn"));
}

HashMap existsMap = new HashMap();
sql = "select * from mode_triggerworkflowsetdetail where mainid = " + id;
rs.executeSql(sql);
while(rs.next()){
	String modefieldid = rs.getString("modefieldid");
	String wffieldid = rs.getString("wffieldid");
	String key = wffieldid+"_"+modefieldid;
	existsMap.put(key,key);
	existsMap.put(wffieldid,modefieldid);
}
String workflowname = WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));
if(workflowname.equals("")){
	workflowname = "<img src=\"/images/BacoError_wev8.gif\" align=\"absmiddle\">";
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>1){
	if(id>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<form name="frmSearch" method="post" action="/formmode/interfaces/ModeTriggerWorkflowSetOperation.jsp">
	<input name="operation" value="save" type="hidden">
	<input name="modeid" value="<%=modeId%>" type="hidden">
	<input name="id" value="<%=id%>" type="hidden">

		<table class="e8_tblForm">
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%><!-- 模块名称 -->
			</td>
			<td class="e8_tblForm_field">
		  		 <!-- button type="button" class=Browser id=formidSelect onClick="onShowModeSelect(modeid,modeidspan)" name=formidSelect></BUTTON -->
		  		 <span id=modeidspan><%=modename%></span>
		  		 <input type="hidden" name="modeid" id="modeid" value="<%=modeId%>">
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(28600,user.getLanguage())%><!-- 被触发流程类型 -->
			</td>
			<td class="e8_tblForm_field">
				<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid==0?"":(String.valueOf(workflowid))%>' 
  		 			browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid<0") %>'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
					completeUrl="/data.jsp" linkUrl=""  width="228px" onPropertyChange="updateBrowserSpan()"
					browserDialogWidth="510px"
					browserSpanValue='<%=workflowname%>'>
				</brow:browser>
			</td>
		</tr>
		<%if(id!=0){ %>
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33384,user.getLanguage())%><!-- 流程触发条件 -->
			</td>
			<td class="e8_tblForm_field">
			<%
				showconditioncn = showconditioncn.replace(",","&#44;");
			%>
				<brow:browser viewType="0" id="showconditionBrow" name="showconditionBrow" browserValue="1" 
  		 				browserUrl="'+getTriggerConditionUrl()+'"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="610px" tempTitle="<%=SystemEnv.getHtmlLabelName(81602,user.getLanguage())%>"
						browserSpanValue='<%=showconditioncn %>'
						_callback="reloadWin"
						></brow:browser>
						<input type="hidden" name="showcondition" id="showcondition" value="<%=showcondition %>">
						<input type="hidden" name="showconditioncn" id="showconditioncn" value="<%=showconditioncn %>">
			</td>
		</tr>
		<%} %>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81945,user.getLanguage())%></td><!-- 流程触发成功回写 -->
			<td class="e8_tblForm_field">
				<textarea id="successwriteback" name="successwriteback" style="width:80%" rows=2 ><%=successwriteback%></textarea>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(81946,user.getLanguage())%></td><!-- 流程触发失败回写 -->
			<td class="e8_tblForm_field">
				<textarea id="failwriteback" name="failwriteback" style="width:80%" rows=2 ><%=failwriteback%></textarea>
				<br>
				<font color="red">
				<%=SystemEnv.getHtmlLabelName(81947,user.getLanguage())%><!-- 触发审批流成功或者失败的时候，可以设置回写值，用来修改当前模块某些主字段的值，比如:a='2'， -->
				<br>
				<%=SystemEnv.getHtmlLabelName(81948,user.getLanguage())%><!-- 如果要修改多个字段的值，请用","将多个字段的值隔开，比如a='2',b='3',c='abc'， -->
				<br>
				<%=SystemEnv.getHtmlLabelName(81949,user.getLanguage())%><!-- 其中a,b,c是指表单中数据库字段名。 -->
				<br>
				<%=SystemEnv.getHtmlLabelName(127213,user.getLanguage())%><!--  触发成功可以将流程主表字段值回写到当前模块中，比如：a=$A$,b=$B$-->
				<br>
				<%=SystemEnv.getHtmlLabelName(126433,user.getLanguage())%><!--其中a,b为当前表单中的数据库字段名，A,B为流程主表字段名称。格式必须为：$字段名称$-->
				</font>
			</td>
		</tr>		
		<TR>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28602,user.getLanguage())%></TD><!-- 被触发流程创建人 -->
			<td class="e8_tblForm_field">
				<input type=radio name=wfcreater id=wfcreater value="1" 
				<%
				    if(wfcreater<=0||wfcreater==1){
				%>
						checked
				<%
					}
				%>
				>
				<%=SystemEnv.getHtmlLabelName(28596,user.getLanguage())%><!-- 模块当前操作人 -->
				<br/>
			   
				<input type=radio name=wfcreater id=wfcreater value="2" 
				<%
				    if(wfcreater==2){
				%>
						checked
				<%
				    }
				%>
				>
				<%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%><!-- 模块创建人 -->
				<br/>
				
				<input type=radio name=wfcreater id=wfcreater value="3"
				<%
				    if(wfcreater==3){
				%>
						checked
				<%
				    }
				%>										 
				>
				<%=SystemEnv.getHtmlLabelName(28598,user.getLanguage())%><!-- 模块人力资源相关字段 -->
				<select class=inputstyle  name=wfcreaterfieldid style="width:120px;">
				<%
					int fieldId= 0;
					//sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ modeformid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=141 or type=142 or type=166) " ;
					sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ formId+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=166) " ;
					rs.executeSql(sql);
					while(rs.next()){
						fieldId=rs.getInt("id");
				%>
						<option value=<%=fieldId%> 
				<%
						if(fieldId==wfcreaterfieldid){
				%>
							selected
				<%
				    	}
				%>
				>
						<%=SystemEnv.getHtmlLabelName(rs.getInt("name"),user.getLanguage())%>
						</option>
				<%
					}
				%>
				</select>
			</TD>		
		</TR>
	</table>
	<%
		int modedetailno = 0;
		HashMap optionMap = new HashMap();
		
		HashMap modeFieldIdMap = new HashMap();
		HashMap modeLabelNameMap = new HashMap();
		
		ArrayList modeFieldIdList = new ArrayList();
		ArrayList modeLabelNameList = new ArrayList();
		
		ArrayList modeDetailFieldIdList = new ArrayList();
		ArrayList modeDetailLabelNameList = new ArrayList();		

		if(workflowid>0){
			
			modeFieldIdList.add("-1");
			modeLabelNameList.add(SystemEnv.getHtmlLabelName(81287,user.getLanguage()));//数据Id
			
			//模块表单字段信息
			String tempdetailtable = "";
			sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + formId + " order by viewtype asc,detailtable asc,id asc";
			rs.executeSql(sql);
			while(rs.next()){
				String fieldid = Util.null2String(rs.getString("id"));
				String fieldname = Util.null2String(rs.getString("fieldname"));
				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
				String type = Util.null2String(rs.getString("type"));
				String viewtype = Util.null2String(rs.getString("viewtype"));
				String detailtable = Util.null2String(rs.getString("detailtable"));
				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
				String optionstr = "<option value=\""+fieldid+"\">"+labelname+"</option>";
				if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
					modedetailno++;
					tempdetailtable = detailtable;
					//modeFieldIdList = new ArrayList();
					//modeLabelNameList = new ArrayList();
					modeDetailFieldIdList.add("");
					modeDetailLabelNameList.add("------"+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+modedetailno+"------");//明细
				}
				if(modedetailno==0){
					modeFieldIdList.add(fieldid);
					modeLabelNameList.add(labelname);
				}else{
					modeDetailFieldIdList.add(fieldid);
					modeDetailLabelNameList.add(labelname);					
				}
				String key = String.valueOf(modedetailno);
				if(optionMap.containsKey(key)){
					optionstr = Util.null2String((String)optionMap.get(key)) + optionstr;
				}
				optionMap.put(key,optionstr);
				//modeFieldIdMap.put(key,modeFieldIdList);
				//modeLabelNameMap.put(key,modeLabelNameList);
			}
			
			//modeFieldIdList = (ArrayList)modeFieldIdMap.get("0");
			//modeLabelNameList = (ArrayList)modeLabelNameMap.get("0");
	%><br/>
			<TABLE class=e8_tblForm>
				<COLGROUP>
					<COL width="50%">
					<COL width="50%">
				</COLGROUP>
		  		<TBODY>
		       		<TR>
						<TD colSpan=2 class="e8_tblForm_field_other"><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(28603,user.getLanguage())%></font></TD><!-- 被触发流程数据导入 -->
					</TR>					
					<TR class=Spacing style="height:1px;">
						<TD class=Line1 colSpan=2></TD>
					</TR>
					<tr>
						<td colspan=2>
							<table class="listStyle" id="oTableOfSubwfSetDetail" name="oTableOfSubwfSetDetail" width="100%">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<tr class="header">
								    <td class="e8_tblForm_label_other"><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(28604,user.getLanguage())%></font></td><!-- 被触发流程字段 -->
		                  			<td class="e8_tblForm_label_other"><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></font></td><!-- 模块字段 -->
		              			</tr>
	              				<tr class="datalight">
	              					<td class="e8_tblForm_label_other">
	              						<%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%><!-- 请求标题 -->
	              						<input type="hidden" name="wffieldid0" id="wffieldid0" value="-1">
              						</td>
	              					<td class="e8_tblForm_label_other">
	              						<select name="modefieldid0" id="modefieldid0">
	              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<%
	              								for(int i=0;i<modeFieldIdList.size();i++){
	              									String fieldid = (String)modeFieldIdList.get(i);
	              									String fieldlabelname = (String)modeLabelNameList.get(i);
	              									String key = "-1_"+fieldid;
	              									boolean selected = existsMap.containsKey(key);
	              									String selectedstr = "";
	              									if(selected){
	              										selectedstr = "selected";
	              									}
           									%>
           											<option value="<%=fieldid%>" <%=selectedstr%>><%=fieldlabelname%></option>
           									<%
	              								}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
	              				<tr class="datadark">
	              					<td class="e8_tblForm_label_other">
	              						<%=SystemEnv.getHtmlLabelName(21587,user.getLanguage())%><!-- 请求紧急程度 -->
	              						<input type="hidden" name="wffieldid0" id="wffieldid0" value="-2">
              						</td>
	              					<td class="e8_tblForm_label_other">
	              						<select name="modefieldid0" id="modefieldid0">
	              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<%
	              								for(int i=0;i<modeFieldIdList.size();i++){
	              									String fieldid = (String)modeFieldIdList.get(i);
	              									String fieldlabelname = (String)modeLabelNameList.get(i);
	              									String key = "-2_"+fieldid;
	              									boolean selected = existsMap.containsKey(key);
	              									String selectedstr = "";
	              									if(selected){
	              										selectedstr = "selected";
	              									}
           									%>
           											<option value="<%=fieldid%>" <%=selectedstr%>><%=fieldlabelname%></option>
           									<%
	              								}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
	              				<%
	              				int messageType = 0;
	              				rs.executeSql("select messageType from workflow_base where id="+workflowid);
	              				if(rs.next())
	              					messageType = Util.getIntValue(rs.getString(1),0);
	              				%>
	              				<tr class="datalight" <%if(messageType == 0){ %>style="display:none"<%} %>>
	              					<td class="e8_tblForm_label_other">
	              						<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%><!-- 短信提醒 -->
	              						<input type="hidden" name="wffieldid0" id="wffieldid0" value="-3">
              						</td>
	              					<td class="e8_tblForm_label_other">
	              						<select name="modefieldid0" id="modefieldid0">
	              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
	              							<%
	              								for(int i=0;i<modeFieldIdList.size();i++){
	              									String fieldid = (String)modeFieldIdList.get(i);
	              									String fieldlabelname = (String)modeLabelNameList.get(i);
	              									String key = "-3_"+fieldid;
	              									boolean selected = existsMap.containsKey(key);
	              									String selectedstr = "";
	              									if(selected){
	              										selectedstr = "selected";
	              									}
           									%>
           											<option value="<%=fieldid%>" <%=selectedstr%>><%=fieldlabelname%></option>
           									<%
	              								}
	              							%>
	              						</select>
	              					</td>
	              				</tr>
		              			<%
		              				//被触发流程字段信息
		              				int detailno = 0;
		              				tempdetailtable = "";
		              				String dataclass = "datadark";
		              				sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + wfformid + " order by viewtype asc,detailtable asc";
			              			rs.executeSql(sql);
			              			while(rs.next()){
			              				String fieldid = Util.null2String(rs.getString("id"));
			              				String fieldname = Util.null2String(rs.getString("fieldname"));
			              				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
			              				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			              				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			              				String type = Util.null2String(rs.getString("type"));
			              				String viewtype = Util.null2String(rs.getString("viewtype"));
			              				String detailtable = Util.null2String(rs.getString("detailtable"));
			              				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
			              				if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
			              					detailno++;
			              					tempdetailtable = detailtable;
			              					dataclass = "datalight";
								%>
				              				<tr>
				              					<td colspan="2" class="e8_tblForm_field"><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=detailno%></font></td><!-- 明细 -->
				              					<td  style="display:none">
				              						<%=SystemEnv.getHtmlLabelName(28606,user.getLanguage())%><!-- 模块明细表 -->
				              						<select style="display:none" id="selectdetail<%=detailno%>"  name="selectdetail<%=detailno%>" onchange="ChangeSelect(this)">
				              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
				              							<%
				              								for(int i=1;i<modedetailno;i++){
			              								%>
				              									<option value="<%=i%>"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=i%></option><!-- 明细 -->
				              							<%
				              								}
				              							%>
				              						</select>
				              					</td>
				              				</tr>
											<TR class=Spacing style="height:1px;">
												<TD class=Line1 colSpan=2></TD>
											</TR>
								<%
			              				}
			              		%>
			              				<tr class="<%=dataclass%>">
			              					<td class="e8_tblForm_label_other">
			              						<%=labelname%>
			              						<input type="hidden" name="wffieldid<%=detailno%>" value="<%=fieldid%>">
		              						</td>
			              					<td class="e8_tblForm_label_other">
			              						<select name="modefieldid<%=detailno%>" id="modefieldid<%=detailno%>">
			              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
			              							<%
			              								if(detailno==0){
			              									for(int i=0;i<modeFieldIdList.size();i++){
			              										String tempfieldid = (String)modeFieldIdList.get(i);
			              										String tempfieldlabelname = (String)modeLabelNameList.get(i);
				              									String key = fieldid+"_"+tempfieldid;
				              									boolean selected = existsMap.containsKey(key);
				              									String selectedstr = "";
				              									if(selected){
				              										selectedstr = "selected";
				              									}
		           									%>
		           												<option value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%
			              									}
			              								}else{
			              									for(int i=0;i<modeDetailFieldIdList.size();i++){
			              										String tempfieldid = (String)modeDetailFieldIdList.get(i);
			              										String tempfieldlabelname = (String)modeDetailLabelNameList.get(i);
				              									String key = fieldid+"_"+tempfieldid;
				              									boolean selected = existsMap.containsKey(key);
				              									String selectedstr = "";
				              									if(selected){
				              										selectedstr = "selected";
				              									}
		           									%>
		           												<option value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%
			              									}			              									
			              								}
			              							%>
			              						</select>
			              					</td>
			              				</tr>
			              		<%
			              				if(dataclass.equals("datalight")){
			              					dataclass = "datadark";
			              				}else{
			              					dataclass = "datalight";
			              				}
			              			}
		              			%>
		                	</table>
		                	<input type="hidden" name="detailno" value="<%=detailno%>">
		            	</td>
					</tr>
				</TBODY>
			</TABLE><br/>
	<%
		}
	%>
</form>


<script type="text/javascript">
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
		if($("#modeid").val()=='0'){
			if(confirm("<%=SystemEnv.getHtmlLabelName(30776,user.getLanguage())%>")){//请先保存基本信息！
				window.parent.document.getElementById('modeBasicTab').click();
			}else{
				$('.href').hide();
			}
		}
	});

	<%
		for(int i=0;i<modedetailno;i++){
			String key = String.valueOf(i);
			String optionstr = Util.null2String((String)optionMap.get(key));
			out.println(" var option" + key + "  = '" + optionstr + "';");
		}
	%>

	function ChangeSelect(obj){
		
	}

	$(document).ready(function(){//onload事件
		
	});

    function doSave(){
        if($("#workflowid").val()=='0'){
        	$("#workflowid").val("");
		}
        if($("#modeid").val()=='0'){
        	$("#modeid").val("");
		}
        if(check_form(document.frmSearch,"workflowid,modeid")){
        	enableAllmenu();
        	document.frmSearch.submit();
        }
    }
	function doDel(){
    	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			enableAllmenu();
    		document.frmSearch.operation.value="del";
    		document.frmSearch.submit();
		});
	}
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("");
    		}
    	} 
    }
    
    function openURL(){
      var url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid<0";
      var result = showModalDialog(url);
      if(result){
	      if(result.name!="" && result.id!=""){
	         $("#workflowspan").html(result.name);
	         $("#workflowid").val(result.id);
	      }else{
	     	 $("#workflowspan").html("<img src=\"/images/BacoError_wev8.gif\" align=\"absmiddle\">");
	         $("#workflowid").val("");
	      }
      }
    }
    $(document).ready(function(){
    	if($("#workflowid").val()!=''){
    		var title = $("#workflowidspan").find("a").text();
			$("#workflowidspan").html("<span class=\"e8_showNameClass\">"+title+"</span>");
    	}
    });
	function updateBrowserSpan(){
		if(event.propertyName=='value'){
			var title = $("#workflowidspan").find("a").text();
			$("#workflowidspan").html("<span class=\"e8_showNameClass\">"+title+"</span>");
		}
	}
	
function getTriggerConditionUrl(){
	var url = escape("/formmode/interfaces/ModeTriggerCondition.jsp?isbill=1&formid=<%=formId%>&id=<%=id%>");
	url = "/systeminfo/BrowserMain.jsp?url="+url
    return url;
}

function reloadWin(){
	window.location.href = window.location.href;
}
</script>

</BODY></HTML>
