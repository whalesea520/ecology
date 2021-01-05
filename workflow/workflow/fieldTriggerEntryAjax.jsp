<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
int wfid=Util.getIntValue(request.getParameter("wfid"),-1);
int entryId=Util.getIntValue(request.getParameter("entryId"),0);
String formid = WorkflowComInfo.getFormId(""+wfid);
String isbill = WorkflowComInfo.getIsBill(""+wfid);
if(formid.equals("")||isbill.equals("")){
	rs1.executeSql("select formid,isbill from workflow_base where id = " + wfid);
	rs1.next();
	formid = Util.null2String(rs1.getString("formid"));	
    isbill = Util.null2String(rs1.getString("isbill"));
}
if(!"1".equals(isbill)){
	isbill="0";
}
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
int index = Util.getIntValue(request.getParameter("index"),0);
if(entryId!=0){
	rs1.executeSql("select * from Workflow_DataInput_main where entryID="+entryId+"order by id asc");
	while(rs1.next()){
		String attr = "{'formTableId':'table_"+(index+1)+"','layoutTableId':'ltable_"+(index+1)+"'}";
		String attrGroup = "{'itemAreaDisplay':''}";
		int secIndex = 0;
		int DateInputID = rs1.getInt("id");
		int IsCycle = rs1.getInt("IsCycle");
		String WhereClause = rs1.getString("WhereClause");
		String datasourcename=Util.null2String(rs1.getString("datasourcename"));
		String ctx = SystemEnv.getHtmlLabelName(31768,user.getLanguage())+"<span class='e8groupIndex'>"+(index+1)+"</span>";
	%>
		<div class="e8triggerSettingDiv">
			<input type="hidden" id="triggerSetting<%=index %>" name="triggerSetting<%=index %>" value="1">
			<wea:layout needImportDefaultJsAndCss="false" attributes='<%=attr %>'>
				<wea:group attributes='<%=attrGroup %>' context="<%=ctx%>">
					<wea:item type="groupHead">
						<input type=button class=delbtn onclick="deleteGroup(this,<%=index+1 %>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
					<wea:item>
						<select id="datasource<%=index%><%=secIndex%>" name="datasource<%=index%><%=secIndex%>" onchange="changedatasource(this,'<%=index%>','<%=secIndex%>')">
						<option value=""></option>
						<% for(int l=0;l<pointArrayList.size();l++){
						%>
						<option value="<%=pointArrayList.get(l)%>" <%if(datasourcename.equals((String)pointArrayList.get(l))){%>selected<%}%>><%=pointArrayList.get(l)%></option>
						<%}%>
						</select>
					</wea:item>	
					<wea:item><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33523,user.getLanguage())%></wea:item>
					<wea:item attributes="{'customAttrs':'isTableList=true'}">
						<div style="width:100%;text-align:right;">
							<input type=button class=addbtn onclick="tableTable<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
							<input type=button class=delbtn onclick="deleteRows(tableTable<%=index+1%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
						</div>
						<div id="tableTable<%=index+1%>" class="e8tableTable"></div>
						<script>
							var tableTable<%=index+1%> = null;
							var needFirstRow<%=index+1%> = true;
							jQuery(document).ready(function(){
								var url="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/triggerTableBrowser.jsp?wfid=<%=wfid%>%26searchflag=1";
								var items=[
									{width:"35%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span language=<%=user.getLanguage()%> tempTitle='<%=SystemEnv.getHtmlLabelName(21900,user.getLanguage())%>' class='browser' idKey='id' nameKey='name' name='formid<%=index%><%=secIndex%>' browserUrl='"+url+"' _callback='updateTablename'></span>"},
									{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:"<input type='text' name='tablename<%=index%><%=secIndex%>' style='width:160px;'></input>"},
									{width:"5%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span name='desc<%=index%><%=secIndex%>'><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></span>"},
									{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:"<input type='text' name='tablebyname<%=index%><%=secIndex%>' style='width:80px;'></input>"}
									];
								var option = {
									basictitle:"",
									optionHeadDisplay:"none",
									colItems:items,
									openindex:true,
									useajax:true,
									ajaxurl:"officalwf_operation.jsp",
									ajaxparams:{
										wfid:<%=wfid%>,
										index:<%=index%>,
										secIndex:<%=secIndex%>,
										dataInputID:<%=DateInputID%>,
										entryID:<%=entryId%>,
										operation:"getRelateTableInfo",
										datasourcename:"<%=datasourcename%>"
									},
									addrowCallBack:addtable,
									container:"#tableTable<%=index+1%>",
									toolbarshow:false,
									configCheckBox:true,
	             					checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"5%"}
								};
								tableTable<%=index+1%> = new WeaverEditTable(option);
							});
						</script>
					</wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%>
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())+"a.id=b.id and a.wfid=b.wfid"%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>	
					<wea:item>
						<textarea class=Inputstyle id="tableralations<%=index%><%=secIndex%>" name="tableralations<%=index%><%=secIndex%>" cols=68 rows=4><%=WhereClause%></textarea>
					</wea:item>	
					<wea:item attributes="{'colspan':'full'}">
						<span style="float:left"><%=SystemEnv.getHtmlLabelName(33509,user.getLanguage())%></span>
						<span style="float:right;">
							<input type=button class=addbtn onclick="parameterGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
							<input type=button class=delbtn onclick="deleteRows(parameterGroup<%=index+1%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
						</span>
					</wea:item>
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<div id="parameterGroup<%=index+1%>"></div>
						<script type="text/javascript">
							var parameterGroup<%=index+1%> = null;
							jQuery(document).ready(function(){
								var itemhtml2 = "<select name='parawfField<%=index%><%=secIndex%>' style='width:180px;'>";
								itemhtml2 += "<option value=''></options>";
								itemhtml2 += "</select>";
								var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%><%=secIndex%>_#rowIndex#' hasInput='false' name='parawfField<%=index%><%=secIndex%>' getBrowserUrlFn='getWorkflowTableField' isSingle='true' isMustinput='2' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl='' completeUrl='/data.jsp?type=fieldBrowser&wfid=<%=wfid%>' isAutoComplete='true'></span>" ;
								var items=[
									{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span class='browser'  _callback='setfieldTableName' name='parafieldname<%=index%><%=secIndex%>'  getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='parafieldtablename<%=index%><%=secIndex%>'></input>"},
									{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:itemhtml3},
									{width:"1%",display:"none",colname:"",itemhtml:"<input type='text' name='pfieldindex<%=index%><%=secIndex%>' id='pfieldindex<%=index%><%=secIndex%>' />"}
									];
								var option = {
									basictitle:"",
									optionHeadDisplay:"none",
									colItems:items,
									openindex:true,
									container:"#parameterGroup<%=index+1%>",
									useajax:true,
									ajaxurl:"officalwf_operation.jsp",
									ajaxparams:{
										entryID:<%=entryId%>,
										wfid:<%=wfid%>,
										index:<%=index%>,
										secIndex:<%=secIndex%>,
										dataInputID:<%=DateInputID%>,
										operation:"getParameterwfField"
									},
									toolbarshow:false,
									addrowCallBack:addParameterTable,
									configCheckBox:true,
	             					checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"5%"}
								};
								parameterGroup<%=index+1%> = new WeaverEditTable(option);
							});
						</script>
					</wea:item>
					<wea:item attributes="{'colspan':'full'}">
						<span style="float:left"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></span>
						<span style="float:right;">
							<input type=button class=addbtn onclick="evaluateGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
							<input type=button class=delbtn onclick="deleteRows(evaluateGroup<%=index+1%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
						</span>
					</wea:item>
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<div id="evaluateGroup<%=index+1%>"></div>
						<script type="text/javascript">
							var evaluateGroup<%=index+1%> = null;
							jQuery(document).ready(function(){
								var itemhtml2 = "<select name='evaluatewfField<%=index%><%=secIndex%>' style='width:180px;'>";
								itemhtml2 += "<option value=''></options>";
								itemhtml2 += "</select>";
								var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%><%=secIndex%>_#rowIndex#' name='evaluatewfField<%=index%><%=secIndex%>' isSingle='true' getBrowserUrlFn='getWorkflowTableField1' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' isMustinput='2' hasInput='false'></span>" ;
								var items=[
									{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span class='browser'  _callback='setfieldTableName' name='evaluatefieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='evaluatefieldtablename<%=index%><%=secIndex%>'></input>"},
									{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:itemhtml3},
									{width:"",display:"none",colname:"",itemhtml:"<input type='text' name='fieldindex<%=index%><%=secIndex%>' id='fieldindex<%=index%><%=secIndex%>' value='' />"}
									];
								var option = {
									basictitle:"",
									optionHeadDisplay:"none",
									colItems:items,
									openindex:true,
									container:"#evaluateGroup<%=index+1%>",
									useajax:true,
									ajaxurl:"officalwf_operation.jsp",
									ajaxparams:{
										entryID:<%=entryId%>,
										wfid:<%=wfid%>,
										index:<%=index%>,
										secIndex:<%=secIndex%>,
										dataInputID:<%=DateInputID%>,
										operation:"getEvaluatewfField"
									},
									toolbarshow:false,
									addrowCallBack:addParameterTable,
									configCheckBox:true,
	             					checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"5%"}
								};
								evaluateGroup<%=index+1%> = new WeaverEditTable(option);
							});
						</script>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	<%
	index++;
	}
}else{
	String attr = "{'formTableId':'table_"+(index+1)+"','layoutTableId':'ltable_"+(index+1)+"'}";
		String attrGroup = "{'itemAreaDisplay':''}";
		int secIndex = 0;
		int DateInputID = -1;
		String WhereClause = "";
		String datasourcename="";
		String ctx2 = SystemEnv.getHtmlLabelName(31768,user.getLanguage())+"<span class='e8groupIndex'>"+(index+1)+"</span>";
%>
	<div class="e8triggerSettingDiv">
	<input type="hidden" id="triggerSetting<%=index %>" name="triggerSetting<%=index %>" value="1">
	<wea:layout needImportDefaultJsAndCss="false" attributes='<%=attr %>'>
			<wea:group attributes='<%=attrGroup %>' context="<%=ctx2%>">
				<wea:item type="groupHead">
					<input type=button class=delbtn onclick="deleteGroup(this,<%=index+1 %>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
				<wea:item>
					<select id="datasource<%=index%><%=secIndex%>" name="datasource<%=index%><%=secIndex%>" onchange="changedatasource(this,'<%=index%>','<%=secIndex%>')">
					<option value=""></option>
					<% for(int l=0;l<pointArrayList.size();l++){
					%>
					<option value="<%=pointArrayList.get(l)%>" <%if(datasourcename.equals((String)pointArrayList.get(l))){%>selected<%}%>><%=pointArrayList.get(l)%></option>
					<%}%>
					</select>
				</wea:item>	
				<wea:item><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33523,user.getLanguage())%></wea:item>
				<wea:item attributes="{'customAttrs':'isTableList=true'}">
					<div style="width:100%;text-align:right;">
						<input type=button class=addbtn onclick="tableTable<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<input type=button class=delbtn onclick="deleteRows(tableTable<%=index+1%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</div>
					<div id="tableTable<%=index+1%>" class="e8tableTable"></div>
					<script type="text/javascript">
						var tableTable<%=index+1%> = null;
						var needFirstRow<%=index+1%> = true;
						jQuery(document).ready(function(){
							var url="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/triggerTableBrowser.jsp?wfid=<%=wfid%>%26searchflag=1";
							var items=[
								{width:"35%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span language=<%=user.getLanguage()%> tempTitle='<%=SystemEnv.getHtmlLabelName(21900,user.getLanguage())%>' class='browser' idKey='id' nameKey='name' name='formid<%=index%><%=secIndex%>' browserUrl='"+url+"' _callback='updateTablename'></span>"},
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:"<input type='text' name='tablename<%=index%><%=secIndex%>' style='width:160px;'></input>"},
								{width:"5%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></span>"},
								{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:"<input type='text' name='tablebyname<%=index%><%=secIndex%>' style='width:80px;'></input>"}
								];
							var option = {
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								openindex:true,
								addrowCallBack:addtable,
								container:"#tableTable<%=index+1%>",
								toolbarshow:false,
								configCheckBox:true,
             					checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							tableTable<%=index+1%> = new WeaverEditTable(option);
						});
					</script>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%>
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())+"a.id=b.id and a.wfid=b.wfid"%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				</wea:item>	
				<wea:item>
					<textarea class=Inputstyle id="tableralations<%=index%><%=secIndex%>" name="tableralations<%=index%><%=secIndex%>" cols=68 rows=4><%=WhereClause%></textarea>
				</wea:item>	
				<wea:item attributes="{'colspan':'full'}">
					<span><%=SystemEnv.getHtmlLabelName(33509,user.getLanguage())%></span>
					<span style="float:right;">
						<input type=button class=addbtn onclick="parameterGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<input type=button class=delbtn onclick="deleteRows(parameterGroup<%=index+1%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</span>
				</wea:item>
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<div id="parameterGroup<%=index+1 %>"></div>
					<script type="text/javascript">
						var parameterGroup<%=index+1%> = null;
						jQuery(document).ready(function(){
							var itemhtml2 = "<select name='parawfField<%=index%><%=secIndex%>' style='width:180px;'>";
							itemhtml2 += "<option value=''></options>";
							itemhtml2 += "</select>";
							var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%><%=secIndex%>_#rowIndex#' name='parawfField<%=index%><%=secIndex%>' getBrowserUrlFn='getWorkflowTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl='' isSingle='true' completeUrl='/data.jsp?type=fieldBrowser&wfid=<%=wfid%>' isAutoComplete='false' isMustinput='2' hasInput='false'></span>" ;
							var items=[
								{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span class='browser'  _callback='setfieldTableName' name='parafieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='parafieldtablename<%=index%><%=secIndex%>'></input>"},
								{width:"50%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:itemhtml3},
								{width:"",display:"none",colname:"",itemhtml:"<input type='text' name='pfieldindex<%=index%><%=secIndex%>' id='pfieldindex<%=index%><%=secIndex%>' />"}
								];
							var option = {
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								openindex:true,
								container:"#parameterGroup<%=index+1%>",
								toolbarshow:false,
								addrowCallBack:addParameterTable,
								configCheckBox:true,
             					checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							parameterGroup<%=index+1%> = new WeaverEditTable(option);
						});
					</script>
				</wea:item>
				<wea:item attributes="{'colspan':'full'}">
					<span><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></span>
					<span style="float:right;">
						<input type=button class=addbtn onclick="evaluateGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<input type=button class=delbtn onclick="deleteRows(evaluateGroup<%=index+1%>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</span>
				</wea:item>
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<div id="evaluateGroup<%=index+1%>"></div>
					<script type="text/javascript">
						var evaluateGroup<%=index+1%> = null;
						jQuery(document).ready(function(){
							var itemhtml2 = "<select name='evaluatewfField<%=index%><%=secIndex%>' style='width:180px;'>";
							itemhtml2 += "<option value=''></options>";
							itemhtml2 += "</select>";
							var itemhtml1 = "<span class='browser'    _callback='setfieldTableName' name='evaluatefieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' ></span><input type='hidden' name='evaluatefieldtablename<%=index%><%=secIndex%>' />" ;
							var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%><%=secIndex%>_#rowIndex#' isSingle='true'  name='evaluatewfField<%=index%><%=secIndex%>' getBrowserUrlFn='getWorkflowTableField1' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl='' completeUrl='/data.jsp?type=fieldBrowser&wfid=<%=wfid%>' isAutoComplete='false' isMustinput='2' hasInput='false'></span>" ;
							var items=[
								{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:itemhtml1},
								{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("19372",user.getLanguage())%>",itemhtml:itemhtml3},
								{width:"",display:"none",colname:"",itemhtml:"<input type='text' name='fieldindex<%=index%><%=secIndex%>' id='fieldindex<%=index%><%=secIndex%>' value='' />"}
								];
							var option = {
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								openindex:true,
								container:"#evaluateGroup<%=index+1%>",
								toolbarshow:false,
								addrowCallBack:addParameterTable,
								configCheckBox:true,
             					checkBoxItem:{"itemhtml":'<input name="id" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							evaluateGroup<%=index+1%> = new WeaverEditTable(option);
							
							
						});
					</script>
				</wea:item>
			</wea:group>
		</wea:layout>
		</div>
<%}
%>
<script type="text/javascript">
function deleteRows(tableObj) {
	//top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("33475",user.getLanguage())%>', function() {
		tableObj.deleteRows();
	//});
}
</script>
