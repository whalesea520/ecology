
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<!DOCTYPE html>

<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%
	String titlename = $label(73,user.getLanguage());
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
	int userid = user.getUID();
	
	String Showoperator = "0";
	String commonuse = "0";
	String signlisttype = "1";
	int multisubmitnotinputsign = 0;
	
	RecordSet.executeSql("select Showoperator,commonuse from "
		+"workflow_requestUserdefault where userid=" + userid);
	if(RecordSet.next()){
		Showoperator = RecordSet.getString("Showoperator");
		commonuse = RecordSet.getString("commonuse");
	}
	RecordSet.executeSql("select signlisttype, multisubmitnotinputsign from workflow_RequestUserDefault where userId = "+userid);
	if(RecordSet.next()){
		signlisttype = RecordSet.getString("signlisttype");
		multisubmitnotinputsign = Util.getIntValue(Util.null2String(RecordSet.getString("multisubmitnotinputsign")), 0);
	}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ $label(86,user.getLanguage()) +",javascript:pager.doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>

		<script>
			jQuery(document).ready(function(){
				pager.init();
			});
			
			var pager = {
				init : function(){
					jQuery("input[type=checkbox]").each(function(){
						if(jQuery(this).attr("tzCheckbox") == "true"){
					 		jQuery(this).tzCheckbox({labels:['','']});
						}
					});
					
					pager.bind();
				},
				
				bind : function(){
					jQuery('#btnNewPhrase').click( pager.showAddPhraseDialog );
					jQuery('#btnDelPhrase').click( pager.doDeleteMany );
					jQuery('#btnMessageSetting').click( pager.showMessageSettingDialog );
					
					jQuery(".setting").hover(function(){
						$(this).attr("src","/images/homepage/style/settingOver_wev8.png")
					},function(){
						$(this).attr("src","/images/homepage/style/setting_wev8.png")
					})
				},
				
				doSave : function(){
					jQuery.post(
						'RequestUserDefaultOperation.jsp',
						{
							'Showoperator' : jQuery('#Showoperator').attr('checked') ? '1' : '0',
							'commonuse' : jQuery('#commonuse').attr('checked') ? '1' : '0',
							'signlisttype':jQuery('#signlisttype').val(),
							'multisubmitnotinputsign' : jQuery('#multisubmitnotinputsign').attr('checked') ? '0' : '1'
						},
						function(data){
							window.location = window.location;
						}
					);
				},
				
				showMessageSettingDialog : function(){
					var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					var url = "/system/sysremind/SysRemindWorkflowSetting.jsp?loginid=" 
						+ '<%=user.getLoginid()%>';
					
					dialog.Title = "<%=$label(33552,user.getLanguage())%>";
					dialog.Width = 650;
					dialog.Height = 530;
					dialog.Drag = true;
					dialog.URL = url;
					dialog.show();
				},
				
				showAddPhraseDialog : function(){ 
					pager.showPhraseDialog();
				},
				
				showEditPhraseDialog : function(id, args, btn){
					pager.showPhraseDialog(id);
				},
				
				showPhraseDialog : function(id){
					var dialog = new window.top.Dialog();
					dialog.currentWindow = window;
					var url = "/workflow/request/UserPhraseEdit.jsp?"
					if(id) url += ('id=' + id);	
					
					var title = "<%= $label(22409,user.getLanguage())%>";
					dialog.Title = id? ("<%= $label(26473,user.getLanguage())%>" + title) : ("<%= $label(611,user.getLanguage())%>" + title);
					dialog.Width = 850;
					dialog.Height = 550;
					dialog.Drag = true;
					dialog.URL = url;
					dialog.show();
				},
				
				doDeleteMany : function(){
					var ids = _xtable_CheckedCheckboxId();
					
					if(ids) pager.del( ids + '-1');
					else alert('<%=$label(20149,user.getLanguage())%>');
				},
				
				doDelete : function(id, args, btn){
					pager.del(id);
				},
				
				del : function(ids){
					jQuery.post(
						'/workflow/sysPhrase/PhraseOperate.jsp',
					  	{
					  		'operation' : 'delete',
					  		'ids' : ids
					  	},
				  		function(data){
				  			window.location.reload();
				  		}
					);
				},
				
				refresh : function(){
					window.location.reload();
				}
			};
			
		</script>
	</head>
<body>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
				<input id="btnSave" type="button" value="<%=$label(86,user.getLanguage()) %>" class="e8_btn_top" onclick="pager.doSave()" />
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form id="weaver" name=frmmain action="RequestUserDefaultOperation.jsp" method=post >
	
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="text" class="searchInput" name="flowTitle"  value="test"/>
				</td>
			</tr>
		</table>
		
		<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=$label(33549,user.getLanguage()) %>' attributes="{'class':'e8_title e8_title_1'}">
				<wea:item>
					<%= $label(22219, user.getLanguage())%>
				</wea:item>
				<wea:item>
					<input type="checkbox" id='Showoperator' name="Showoperator" tzCheckbox="true" <%if(Showoperator.equals("1")){%>checked <%}%>>
				</wea:item>
				<wea:item>
					<%= $label(33551, user.getLanguage())%>
				</wea:item>
				<wea:item>
					<input type="checkbox" id='commonuse' name="commonuse" tzCheckbox="true" <%if(commonuse.equals("1")){%>checked <%}%>>
				</wea:item>
			<%if(1 == 1){%>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(84394,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<select name="signlisttype" id="signlisttype">
					   <option value="1" <%if(signlisttype.equals("1")){%>selected<%}%>><%=$label(81641,user.getLanguage())%></option>
					   <option value="0" <%if(signlisttype.equals("0")){%>selected<%}%>><%=$label(81640,user.getLanguage())%></option>
					</select>
				</wea:item>
		   <%}%>
		   
		   		<wea:item>
					<%=SystemEnv.getHtmlLabelName(84395,user.getLanguage())%>
				</wea:item>
				<wea:item>
					<input type="checkbox" id='multisubmitnotinputsign' name="multisubmitnotinputsign" tzCheckbox="true" <%if(multisubmitnotinputsign == 0){%>checked <%}%>>
				</wea:item>
			</wea:group>
			
			<wea:group context='<%= $label(33550, user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
				<wea:item>
					<%= $label(26679, user.getLanguage())%>
				</wea:item>
				<wea:item>
					<img id='btnMessageSetting' class="setting" src="/images/homepage/style/setting_wev8.png" url=""/>
				</wea:item>
			</wea:group>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_REQUESTUSERDEFAULT%>"/>
			<wea:group context='<%= $label(22409, user.getLanguage()) + $label(33508, user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
				<%
					String backFields = "id,hrmId,phraseShort,phraseDesc";
					String whereSql = "hrmId=" + user.getUID();
					
					String operateString = "<operates width='20%'>";
					operateString += "     <operate href='javascript:pager.showEditPhraseDialog()' text='"+$label(26473,user.getLanguage())+"' index='1'/>";
		 	        operateString += "     <operate href='javascript:pager.doDelete()' text='"+$label(91,user.getLanguage())+"' index='2'/>";
		 	        operateString += "</operates>";	
					
					String tableDefination = "";
					tableDefination += "<table id='phraseTable' name='phraseTable' instanceid='phraseTable' pageId='phraseTable' tabletype='checkbox' pagesize='"+PageIdConst.getPageSize("phraseTable",user.getUID())+"'>";
					tableDefination += "	<sql backfields=\""+backFields+"\" sqlform=\"sysPhrase\" sqlwhere=\""+whereSql+"\" sqlprimarykey=\"id\" sqlorderby=\"id\" sqlsortway=\"DESC\" />";
					tableDefination += operateString;
					tableDefination += "	<head>";
					tableDefination += "		<col width='40%' name='phraseShort' text='"+$label(18774,user.getLanguage())+"' column='phraseShort' transmethod='weaver.workflow.sysPhrase.WorkflowPhrase.generateLink' otherpara='column:id'></col>";
					tableDefination += "		<col width='50%' name='phraseDesc' text='"+$label(18775,user.getLanguage())+"' column='phraseDesc' ></col>";
					tableDefination += "	</head>";
					tableDefination += "</table>";
				 %>
				 
				 <wea:item type="groupHead">
				 	<input type="button" id="btnNewPhrase" name="btnNewPhrase" class="addbtn" accessKey=A  title="<%=$label(82,user.getLanguage())%>"/>
				 	<input type="button" id='btnDelPhrase' name="btnDelPhrase" class="delbtn" accessKey=E  title="<%=$label(23777,user.getLanguage())%>"/>
				 </wea:item>
				 <wea:item attributes="{'isTableList':'true'}">
				 	<input type="hidden" showCol="false" name="pageId" id="pageId" value="phraseTable"/>
				 	<wea:SplitPageTag  tableInstanceId="phraseTable"  tableString='<%=tableDefination%>' />
				 </wea:item>
			</wea:group>
			
		</wea:layout>
	
	</form>
</body>
</html>
