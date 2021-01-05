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
int modeId=Util.getIntValue(request.getParameter("modeId"),-1);
int entryId=Util.getIntValue(request.getParameter("entryId"),0);
String formid = WorkflowComInfo.getFormId(""+modeId);
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
int index = Util.getIntValue(request.getParameter("index"),0);
if(entryId!=0){
	rs1.executeSql("select * from modeDataInputmain where entryID="+entryId+"order by id asc");
	while(rs1.next()){
		String attr = "{'formTableId':'table_"+(index+1)+"','layoutTableId':'ltable_"+(index+1)+"'}";
		String attrGroup = "{'itemAreaDisplay':'"+(index>0?"none":"")+"'}";
		int secIndex = 0;
		int DateInputID = rs1.getInt("id");
		int IsCycle = rs1.getInt("IsCycle");
		String WhereClause = rs1.getString("WhereClause");
		String datasourcename=Util.null2String(rs1.getString("datasourcename"));
		String weacontext = SystemEnv.getHtmlLabelName(31768,user.getLanguage())+"<span class='e8groupIndex'>"+(index+1)+"</span>";
	%>
		<div class="e8triggerSettingDiv">
			<input type="hidden" id="triggerSetting<%=index %>" name="triggerSetting<%=index %>" value="1">
			<wea:layout needImportDefaultJsAndCss="false" attributes='<%=attr %>'><!-- 触发设置 -->
				<wea:group attributes='<%=attrGroup %>' context="<%=weacontext%>">
					<wea:item type="groupHead"><!-- 删除 -->
						<input type=button class=delbtn onclick="deleteGroup(this,<%=index+1 %>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</wea:item><!-- 数据源 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
					<wea:item>
						<select id="datasource<%=index%><%=secIndex%>" name="datasource<%=index%><%=secIndex%>" onchange="changedatasource(this,'<%=index%>','<%=secIndex%>')">
						<option value=""></option>
						<option value="<%=DataSourceXML.SYS_LOCAL_POOLNAME%>" <%if(datasourcename.equals(DataSourceXML.SYS_LOCAL_POOLNAME)){%>selected<%}%>>local</option>
						<% for(int l=0;l<pointArrayList.size();l++){
						%>
						<option value="<%=pointArrayList.get(l)%>" <%if(datasourcename.equals((String)pointArrayList.get(l))){%>selected<%}%>><%=pointArrayList.get(l)%></option>
						<%}%>
						</select>
					</wea:item>	<!-- 引用数据库表名 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></wea:item>
					<wea:item attributes="{'customAttrs':'isTableList=true'}">
						<div style="width:100%;text-align:right;">
							<input type=button class=addbtn onclick="tableTable<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input><!-- 添加 -->
							<input type=button class=delbtn onclick="tableTable<%=index+1%>.deleteRows()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input><!-- 删除 -->
						</div>
						<div id="tableTable<%=index+1%>" class="e8tableTable"></div>
						<script>
							var tableTable<%=index+1%> = null;
							var needFirstRow<%=index+1%> = true;
							jQuery(document).ready(function(){
								var url="/systeminfo/BrowserMain.jsp?url=/formmode/setup/triggerTableBrowser.jsp?modeId=<%=modeId%>%26searchflag=1";
								var items=[//数据库字段 表名
									{width:"35%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span language=<%=user.getLanguage()%> tempTitle='<%=SystemEnv.getHtmlLabelName(21900,user.getLanguage())%>' class='browser' idKey='id' nameKey='name' name='formid<%=index%><%=secIndex%>' browserUrl='"+url+"' _callback='updateTablename'></span>"},
									//模块字段
									{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:"<input type='text' name='tablename<%=index%><%=secIndex%>' style='width:160px;'></input>"},
									//数据库字段  别名
									{width:"5%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span name='desc<%=index%><%=secIndex%>'><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></span>"},
									//模块字段
									{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:"<input type='text' name='tablebyname<%=index%><%=secIndex%>' style='width:80px;'></input>"}
									];
								var option = {
									basictitle:"",
									optionHeadDisplay:"none",
									colItems:items,
									openindex:true,
									useajax:true,
									ajaxurl:"fieldTriggerRecord.jsp",
									ajaxparams:{
										modeId:<%=modeId%>,
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
						<%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%><!-- 表之间关联条件 -->
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())+"a.id=b.id and a.wfid=b.wfid"%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span><!-- 条件前不需要加and,例如 -->
					</wea:item>	
					<wea:item>
						<textarea class=Inputstyle id="tableralations<%=index%><%=secIndex%>" name="tableralations<%=index%><%=secIndex%>" cols=68 rows=4><%=WhereClause%></textarea>
					</wea:item>	
					<wea:item attributes="{'colspan':'full'}">
						<span style="float:left"><%=SystemEnv.getHtmlLabelName(33509,user.getLanguage())%></span><!-- 取值设置 -->
						<span style="float:right;">
							<input type=button class=addbtn onclick="parameterGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input><!-- 添加 -->
							<input type=button class=delbtn onclick="parameterGroup<%=index+1%>.deleteRows()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input><!-- 删除 -->
						</span>
					</wea:item>
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<div id="parameterGroup<%=index+1%>"></div>
						<script type="text/javascript">
							var parameterGroup<%=index+1%> = null;
							jQuery(document).ready(function(){					
								var itemhtml1 = "<span class='browser'  _callback='setfieldTableName' name='parafieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='parafieldtablename<%=index%><%=secIndex%>'></input>";
								var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%>,<%=secIndex%>,#rowIndex#,1' hasInput='false' name='parawfField<%=index%><%=secIndex%>' getBrowserUrlFn='getModeTableField' isSingle='true' isMustinput='2' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span>" ;
								var itemhtml4 = "<div class='treenodeidselectdiv' id='treenodeidselectdiv<%=index%><%=secIndex%>_#rowIndex#'><div>";
								var items=[
									{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:itemhtml1},
									{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:itemhtml3+itemhtml4},
									/* {width:"20%",colname:"",itemhtml:itemhtml4}, */
									{width:"1%",display:"none",colname:"",itemhtml:"<input type='text' name='pfieldindex<%=index%><%=secIndex%>' id='pfieldindex<%=index%><%=secIndex%>' />"}
									];
								var option = {
									basictitle:"",
									optionHeadDisplay:"none",
									colItems:items,
									openindex:true,
									container:"#parameterGroup<%=index+1%>",
									useajax:true,
									ajaxurl:"fieldTriggerRecord.jsp",
									ajaxparams:{
										entryID:<%=entryId%>,
										modeId:<%=modeId%>,
										index:<%=index%>,
										secIndex:<%=secIndex%>,
										dataInputID:<%=DateInputID%>,
										operation:"getParameterFormModeField"
									},
									toolbarshow:false,
									addrowCallBack:addParameterTable,
									configCheckBox:true,
	             					checkBoxItem:{"itemhtml":'<input name="para<%=index%><%=secIndex%>_id" class="groupselectbox" type="checkbox" >',width:"5%"}
								};
								parameterGroup<%=index+1%> = new WeaverEditTable(option);						
							});
						</script>
					</wea:item>
					<wea:item attributes="{'colspan':'full'}">
						<span style="float:left"><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></span><!-- 赋值设置 -->
						<span style="float:right;">
							<input type=button class=addbtn onclick="evaluateGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input><!-- 添加 -->
							<input type=button class=delbtn onclick="evaluateGroup<%=index+1%>.deleteRows()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input><!-- 删除 -->
						</span>
					</wea:item>
					<wea:item attributes="{'isTableList':'true','colspan':'full'}">
						<div id="evaluateGroup<%=index+1%>"></div>
						<script type="text/javascript">
							var evaluateGroup<%=index+1%> = null;
							jQuery(document).ready(function(){
								var itemhtml1 = "<span class='browser' _callback='setfieldTableName' name='evaluatefieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='evaluatefieldtablename<%=index%><%=secIndex%>'></input>";
								var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%>,<%=secIndex%>,#rowIndex#,2' name='evaluatewfField<%=index%><%=secIndex%>' isSingle='true' getBrowserUrlFn='getModeTableField1' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' isMustinput='2' hasInput='false'></span>";
								var items=[//数据库字段
									{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:itemhtml1},
									////模块字段
									{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:itemhtml3},
									{width:"",display:"none",colname:"",itemhtml:"<input type='text' name='fieldindex<%=index%><%=secIndex%>' id='fieldindex<%=index%><%=secIndex%>' value='' />"}
									];
								var option = {
									basictitle:"",
									optionHeadDisplay:"none",
									colItems:items,
									openindex:true,
									container:"#evaluateGroup<%=index+1%>",
									useajax:true,
									ajaxurl:"fieldTriggerRecord.jsp",
									ajaxparams:{
										entryID:<%=entryId%>,
										modeId:<%=modeId%>,
										index:<%=index%>,
										secIndex:<%=secIndex%>,
										dataInputID:<%=DateInputID%>,
										operation:"getEvaluateFormModeField"
									},
									toolbarshow:false,
									addrowCallBack:addParameterTable,
									configCheckBox:true,
	             					checkBoxItem:{"itemhtml":'<input name="evaluate<%=index%><%=secIndex%>_id" class="groupselectbox" type="checkbox" >',width:"5%"}
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
		String weacontext = SystemEnv.getHtmlLabelName(31768,user.getLanguage())+"<span class='e8groupIndex'>"+(index+1)+"</span>";
%>
	<div class="e8triggerSettingDiv">
	<input type="hidden" id="triggerSetting<%=index %>" name="triggerSetting<%=index %>" value="1">
	<wea:layout needImportDefaultJsAndCss="false" attributes='<%=attr %>'><!-- 触发设置 -->
			<wea:group attributes='<%=attrGroup %>' context="<%=weacontext%>">
				<wea:item type="groupHead">
					<input type=button class=delbtn onclick="deleteGroup(this,<%=index+1 %>)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input><!-- 删除 -->
				</wea:item><!-- 数据源 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
				<wea:item>
					<select id="datasource<%=index%><%=secIndex%>" name="datasource<%=index%><%=secIndex%>" onchange="changedatasource(this,'<%=index%>','<%=secIndex%>')">
					<option value=""></option>
					<option value="<%=DataSourceXML.SYS_LOCAL_POOLNAME%>" <%if(datasourcename.equals(DataSourceXML.SYS_LOCAL_POOLNAME)){%>selected<%}%>>local</option>
					<% for(int l=0;l<pointArrayList.size();l++){
					%>
					<option value="<%=pointArrayList.get(l)%>" <%if(datasourcename.equals((String)pointArrayList.get(l))){%>selected<%}%>><%=pointArrayList.get(l)%></option>
					<%}%>
					</select>
				</wea:item>	<!-- 引用数据库表名 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></wea:item>
				<wea:item attributes="{'customAttrs':'isTableList=true'}">
					<div style="width:100%;text-align:right;">
						<input type=button class=addbtn onclick="tableTable<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<input type=button class=delbtn onclick="tableTable<%=index+1%>.deleteRows()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</div>
					<div id="tableTable<%=index+1%>" class="e8tableTable"></div>
					<script type="text/javascript">
						var tableTable<%=index+1%> = null;
						var needFirstRow<%=index+1%> = true;
						jQuery(document).ready(function(){
							var url="/systeminfo/BrowserMain.jsp?url=/formmode/setup/triggerTableBrowser.jsp?modeId=<%=modeId%>%26searchflag=1";
							var items=[
								{width:"35%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span language=<%=user.getLanguage()%> tempTitle='<%=SystemEnv.getHtmlLabelNames("18214,31923",user.getLanguage())%>' class='browser' idKey='id' nameKey='name' name='formid<%=index%><%=secIndex%>' browserUrl='"+url+"' _callback='updateTablename'></span>"},
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:"<input type='text' name='tablename<%=index%><%=secIndex%>' style='width:160px;'></input>"},
								{width:"5%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:"<span><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></span>"},
								{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:"<input type='text' name='tablebyname<%=index%><%=secIndex%>' style='width:80px;'></input>"}
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
						<input type=button class=delbtn onclick="parameterGroup<%=index+1%>.deleteRows()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</span>
				</wea:item>
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<div id="parameterGroup<%=index+1 %>"></div>
					<script type="text/javascript">
						var parameterGroup<%=index+1%> = null;
						jQuery(document).ready(function(){
							var itemhtml1 = "<span class='browser' language=<%=user.getLanguage()%> tempTitle='<%=SystemEnv.getHtmlLabelName(82098,user.getLanguage())%>'  _callback='setfieldTableName' name='parafieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='parafieldtablename<%=index%><%=secIndex%>'></input>";
							var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%>,<%=secIndex%>,#rowIndex#,1' hasInput='false' name='parawfField<%=index%><%=secIndex%>' getBrowserUrlFn='getModeTableField' isSingle='true' isMustinput='2' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl='' ></span>" ;
							var itemhtml4 = "<div class='treenodeidselectdiv' id='treenodeidselectdiv<%=index%><%=secIndex%>_#rowIndex#'><div>";
								
							var items=[
								{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:itemhtml1},
								{width:"50%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:itemhtml3+itemhtml4},
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
             					checkBoxItem:{"itemhtml":'<input name="para<%=index%><%=secIndex%>_id" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							parameterGroup<%=index+1%> = new WeaverEditTable(option);
						});
					</script>
				</wea:item>
				<wea:item attributes="{'colspan':'full'}">
					<span><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></span>
					<span style="float:right;">
						<input type=button class=addbtn onclick="evaluateGroup<%=index+1%>.addRow()" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<input type=button class=delbtn onclick="evaluateGroup<%=index+1%>.deleteRows()" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
					</span>
				</wea:item>
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<div id="evaluateGroup<%=index+1%>"></div>
					<script type="text/javascript">
						var evaluateGroup<%=index+1%> = null;
						jQuery(document).ready(function(){
							var itemhtml1 = "<span class='browser' _callback='setfieldTableName' name='evaluatefieldname<%=index%><%=secIndex%>' getBrowserUrlFn='getTriggerTableField' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' browserUrl=''></span><input type='hidden' name='evaluatefieldtablename<%=index%><%=secIndex%>'></input>";
							var itemhtml3  = "<span class='browser'  _callback='setIndexValue' _callbackParams='<%=index%>,<%=secIndex%>,#rowIndex#,2' name='evaluatewfField<%=index%><%=secIndex%>' isSingle='true' getBrowserUrlFn='getModeTableField1' getBrowserUrlFnParams='<%=index+"_"+secIndex%>' isMustinput='2' hasInput='false'></span>";
							var items=[//数据库字段
								{width:"45%",colname:"<%=SystemEnv.getHtmlLabelNames("33510",user.getLanguage())%>",itemhtml:itemhtml1},
								////模块字段
								{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("28605",user.getLanguage())%>",itemhtml:itemhtml3},
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
             					checkBoxItem:{"itemhtml":'<input name="evaluate<%=index%><%=secIndex%>_id" class="groupselectbox" type="checkbox" >',width:"5%"}
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
