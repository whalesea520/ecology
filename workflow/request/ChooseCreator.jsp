
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<!DOCTYPE html>

<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:pager.doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:btn_cancle(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	
	String workflowid = request.getParameter("workflowid");
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>

		<script>
			jQuery(document).ready(function(){
				pager.init();
			});
			
			var dialog = parent.getDialog(window);
			var parentWin = parent.getParentWindow(window);
			
			var pager = {
				init : function(){
					pager.bind();
				},
				
				bind : function(){
					var me = this;

					$('[name=creatertype').change(function(){

					});
				},
				
				doSave : function(){
					if( !$('[name=createrid]').val() ){
						return alert("<%=SystemEnv.getHtmlLabelName(84492,user.getLanguage())%>");
					}
					
					jQuery.ajax({
						url:'CheckCreator.jsp',
						dataType:"json",
       					type:"post",
       					data:{
       						workflowid:'<%=workflowid%>',
       						creatertype:$('[name=creatertype]').val(),
       						createrid:$('[name=createrid]').val()
       					},
       					success:function(result){
       						if(result.hasCreatePermission == 0){
       							_writeBackData('createrid', 1, {id:'',name:''});
       							alert("该用户无流程创建权限请重新选择用户!");
       						}else{
								var result = {
									"creatertype" : $('[name=creatertype]').val(),
									"createrid" : $('[name=createrid]').val()
								};
			
								parent.getDialog(window).close(result);
       						}
       					}
					});
				},

				doClose : function(){
					parent.getDialog(window).close();
				}
			};

			function btn_cancle(){
				dialog.close();
			}
			
			function showBrowserByCreaterType(){
				if( $('[name=creatertype]').val() == '1' ){
					return '/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp';
				}else if( $('[name=creatertype]').val() == '2' ){
					return '/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp';
				}					
			}

			function getajaxurl(typeId){
				var url = "";
				if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 
					|| typeId==164 || typeId== 194 || typeId==23 || typeId==26 
					|| typeId==3 || typeId==8 || typeId==135 || typeId== 65 
					|| typeId==9 || typeId== 89 || typeId==87 || typeId==58 
					|| typeId==59){
					url = "/data.jsp?type=" + typeId;			
				} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
					url = "/data.jsp";
				} else {
					url = "/data.jsp?type=" + typeId;
				}
				url = "/data.jsp?type=" + typeId;	
			    return url;
			}
			
		</script>
	</head>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="workflow"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(125357,user.getLanguage())%>"/>
		</jsp:include>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
					<input id="btnSave" type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="e8_btn_top" onclick="pager.doSave()" />
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<div class="zDialog_div_content" id="zDialog_div_content">
		<!-- <form id="weaver" name="frmmain" action="WorkflowSettingsOperation.jsp" method="post" > -->
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(125357,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(84493,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<%
							String sql = "select * from workflow_groupdetail where groupid="
										+"(select id from workflow_nodegroup where nodeid="
										+"	("
										+"		select nodeid from workflow_flownode where workflowid="+workflowid+" and nodetype = 0"
										+"	)"
										+")";

							RecordSet.executeSql(sql);
							String operatorDescription = "";
							while(RecordSet.next()){
								int type = RecordSet.getInt("type");
								String resourceid = RecordSet.getString("objid");
								String signorder = RecordSet.getString("signorder");
								int level = RecordSet.getInt("level_n");
								int level2 = RecordSet.getInt("level2_n");
								String deptField = RecordSet.getString("deptField");
								String subcompanyField = RecordSet.getString("subcompanyField");
								int bhxj = Util.getIntValue(Util.null2String(RecordSet.getString("bhxj")),0);
								String typeName = "";
								String resourcename = "";
								String betweenAnd = "";
								
								String securityLevel = SystemEnv.getHtmlLabelName(683,user.getLanguage());
								String belongtypeStr = "";
								if(!signorder.equals("-1")){
									if(type==30 || type==1){//分部、部门

										if(signorder.equals("1")){
											belongtypeStr = " (" + SystemEnv.getHtmlLabelName(353,user.getLanguage()) + ")";
										}else if(signorder.equals("2")){
											belongtypeStr = " (" + SystemEnv.getHtmlLabelName(21473,user.getLanguage()) + ")";
										}
									}else if(type==2){//角色
										if(signorder.equals("1")){
											belongtypeStr = " (" + SystemEnv.getHtmlLabelName(346,user.getLanguage()) + ")";
										}else if(signorder.equals("2")){
											belongtypeStr = " (" + SystemEnv.getHtmlLabelName(15507,user.getLanguage()) + ")";
										}
									}
								}
								
								if(type==1){
									typeName = SystemEnv.getHtmlLabelName(124,user.getLanguage())+belongtypeStr;
									resourcename = DepartmentComInfo.getDepartmentname(resourceid);
									if(bhxj == 1)
										resourcename += "&nbsp;["+SystemEnv.getHtmlLabelName(125943,user.getLanguage())+"]";
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==2){
									typeName = SystemEnv.getHtmlLabelName(122,user.getLanguage())+belongtypeStr;
									RecordSet1.executeSql("select rolesmark from hrmroles where id = "+resourceid);
									RecordSet1.next();
									resourcename = RecordSet1.getString(1);
									if(level==0){
										betweenAnd += SystemEnv.getHtmlLabelName(124,user.getLanguage());
									}else if(level==1){
										betweenAnd += SystemEnv.getHtmlLabelName(141,user.getLanguage());
									}else if(level==2){
										betweenAnd += SystemEnv.getHtmlLabelName(140,user.getLanguage());
									}else if(level==3){
										betweenAnd += SystemEnv.getHtmlLabelName(22753,user.getLanguage());
									}
									securityLevel = SystemEnv.getHtmlLabelName(139,user.getLanguage());
								}
								if(type==3){
									typeName = SystemEnv.getHtmlLabelName(179,user.getLanguage());
									resourcename = ResourceComInfo.getResourcename(resourceid);
									securityLevel = "";
								}
								if(type==4){
									typeName = SystemEnv.getHtmlLabelName(1340,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==5)
									typeName = SystemEnv.getHtmlLabelName(15555,user.getLanguage());
								if(type==6)
									typeName = SystemEnv.getHtmlLabelName(15559,user.getLanguage());
								if(type==7){
									typeName = SystemEnv.getHtmlLabelName(15562,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==8)
									typeName = SystemEnv.getHtmlLabelName(15564,user.getLanguage());
								if(type==9){
									typeName = SystemEnv.getHtmlLabelName(15566,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==10)
									typeName = SystemEnv.getHtmlLabelName(15567,user.getLanguage());
								if(type==11){
									typeName = SystemEnv.getHtmlLabelName(15569,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==12){
									typeName = SystemEnv.getHtmlLabelName(15570,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==13)
									typeName = SystemEnv.getHtmlLabelName(15571,user.getLanguage());
								if(type==14){
									typeName = SystemEnv.getHtmlLabelName(15573,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==15)
									typeName = SystemEnv.getHtmlLabelName(15574,user.getLanguage());
								if(type==16)
									typeName = SystemEnv.getHtmlLabelName(15575,user.getLanguage());
								if(type==17)
									typeName = SystemEnv.getHtmlLabelName(15079,user.getLanguage());
								if(type==18)
									typeName = SystemEnv.getHtmlLabelName(15080,user.getLanguage());
								if(type==19){
									typeName = SystemEnv.getHtmlLabelName(15081,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==20){
									typeName = SystemEnv.getHtmlLabelName(1282,user.getLanguage());
									resourcename = Util.toScreen(CustomerTypeComInfo.getCustomerTypename(resourceid),user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==21){
									typeName = SystemEnv.getHtmlLabelName(15078,user.getLanguage());
									resourcename = Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(resourceid),user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==22){
									typeName = SystemEnv.getHtmlLabelName(15579,user.getLanguage());
									resourcename = DepartmentComInfo.getDepartmentname(resourceid);
									if(bhxj == 1)
										resourcename += "&nbsp;["+SystemEnv.getHtmlLabelName(125943,user.getLanguage())+"]";
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==23){
									typeName = SystemEnv.getHtmlLabelName(2113,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==24)
									typeName = SystemEnv.getHtmlLabelName(15580,user.getLanguage());
								if(type==25){
									typeName = SystemEnv.getHtmlLabelName(15581,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==30){
									typeName = SystemEnv.getHtmlLabelName(141,user.getLanguage())+belongtypeStr;
									resourcename = SubCompanyComInfo.getSubCompanyname(resourceid);
									if(bhxj == 1)
										resourcename += "&nbsp;["+SystemEnv.getHtmlLabelName(84674,user.getLanguage())+"]";
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==31){
									typeName = SystemEnv.getHtmlLabelName(15560,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==32){
									typeName = SystemEnv.getHtmlLabelName(15561,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==33){
									typeName = SystemEnv.getHtmlLabelName(15565,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==34){
									typeName = SystemEnv.getHtmlLabelName(15568,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==35){
									typeName = SystemEnv.getHtmlLabelName(15572,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==36){
									typeName = SystemEnv.getHtmlLabelName(15576,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==37){
									typeName = SystemEnv.getHtmlLabelName(15577,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==38){
									typeName = SystemEnv.getHtmlLabelName(15563,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==39){
									typeName = SystemEnv.getHtmlLabelName(15578,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==40)
									typeName = SystemEnv.getHtmlLabelName(18676,user.getLanguage());
								if(type==41)
									typeName = SystemEnv.getHtmlLabelName(18677,user.getLanguage());
								if(type==42){
									typeName = SystemEnv.getHtmlLabelName(124,user.getLanguage());
									
									if("0".equals(deptField)||"".equals(deptField)){//说明下拉框中选择的是安全级别
								       if(level2!=-1){
								    	   betweenAnd += level+"-"+level2;
								       }else{
								    	   betweenAnd += ">="+level;
								       }	
									}else{//说明下拉框中选择的是部门自定义字段 deptField该字段存储值个格式id_fieldname_fieldlabel
									  	String outStr="";
									  	if(deptField!=null && !"".equals(deptField)){
									    	String[] tempStr = Util.TokenizerString2(deptField, "[_]");
									    	if(tempStr!=null && tempStr.length>2){
									      		String fieldlabelStr=tempStr[2];
									    		int fieldlabel= Util.getIntValue(fieldlabelStr,0);
									   			outStr=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
									    	}
										}
										betweenAnd += outStr;
									}
									
								}
								if(type==43)
									typeName = SystemEnv.getHtmlLabelName(122,user.getLanguage());
								if(type==44)
									typeName = SystemEnv.getHtmlLabelName(17204,user.getLanguage());
								if(type==45){
									typeName = SystemEnv.getHtmlLabelName(18678,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==46){
									typeName = SystemEnv.getHtmlLabelName(18679,user.getLanguage());
									if(level2!=-1){
										betweenAnd += level + "-" + level2;
									}else{
										betweenAnd += ">=" + level;
									}
								}
								if(type==47)
									typeName = SystemEnv.getHtmlLabelName(18680,user.getLanguage());
								if(type==48)
									typeName = SystemEnv.getHtmlLabelName(18681,user.getLanguage());
								if(type==49)
									typeName = SystemEnv.getHtmlLabelName(19309,user.getLanguage());
								if(type==50){
									typeName = SystemEnv.getHtmlLabelName(20570,user.getLanguage());
									if(level2==1){
										betweenAnd += SystemEnv.getHtmlLabelName(22689,user.getLanguage());
									}else if(level2==2){
										betweenAnd += SystemEnv.getHtmlLabelName(22690,user.getLanguage());
									}else if(level2==3){
										betweenAnd += SystemEnv.getHtmlLabelName(22667,user.getLanguage());
									}else{
										betweenAnd += SystemEnv.getHtmlLabelName(140,user.getLanguage());
									}
								}
								if(type==51){
									typeName = SystemEnv.getHtmlLabelName(141,user.getLanguage());
									
									if("0".equals(subcompanyField)||"".equals(subcompanyField)){//说明下拉框中选择的是安全级别
								       if(level2!=-1){
								    	   betweenAnd += level+"-"+level2;
								       }else{
								    	   betweenAnd += ">="+level;
								       }	
									}else{//说明下拉框中选择的是分部自定义字段subcompanyField该字段存储值个格式id_fieldname_fieldlabel
										String outStr="";
										if(subcompanyField!=null && !"".equals(subcompanyField)){
											String[] tempStr = Util.TokenizerString2(subcompanyField, "[_]");
											if(tempStr!=null && tempStr.length>2){
									   			String fieldlabelStr=tempStr[2];
									  			int fieldlabel= Util.getIntValue(fieldlabelStr,0);
									 			outStr=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
									   		}
										}
										betweenAnd += outStr;
									}
								}
								if(type==52)
									typeName = SystemEnv.getHtmlLabelName(27107,user.getLanguage());
								if(type==53)
									typeName = SystemEnv.getHtmlLabelName(27108,user.getLanguage());
								if(type==54)
									typeName = SystemEnv.getHtmlLabelName(27109,user.getLanguage());
								if(type==55)
									typeName = SystemEnv.getHtmlLabelName(27110,user.getLanguage());
								if(type==56)
									typeName = SystemEnv.getHtmlLabelName(26592,user.getLanguage());
								if(type==57)
									typeName = SystemEnv.getHtmlLabelName(28442,user.getLanguage());
								if(type == 99){
									typeName = SystemEnv.getHtmlLabelName(84494,user.getLanguage());
								}
								
								//if(RecordSet.getInt("level2_n") == -1){
								//	betweenAnd = ">=" + RecordSet.getInt("level_n");
								//}else{
								//	betweenAnd = RecordSet.getInt("level_n") + "-" + RecordSet.getInt("level2_n");
								//}	
								
								if(!"".equals(resourcename)){
									resourcename += "&nbsp;&nbsp;";
								}
								operatorDescription += (typeName + "&nbsp;&nbsp;" + resourcename + securityLevel + "&nbsp;&nbsp;" + betweenAnd + "</br>");
							}


							out.println(operatorDescription);
						%>
					</wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(84492,user.getLanguage()) %>
					</wea:item>
					<wea:item>
						<span style="float: left;">
				          	<select name="creatertype" style='width:80px' class="InputStyle">
				          		<option value="1"><%=SystemEnv.getHtmlLabelName(32457,user.getLanguage()) %></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(32458,user.getLanguage()) %></option>
							</select>
							&nbsp;
					 	</span>
						<span style="float: left;">
						   <brow:browser name="createrid" viewType="0" hasBrowser="true" hasAdd="false" 
						   		getBrowserUrlFn="showBrowserByCreaterType"
							  	isMustInput="1" isSingle="true" hasInput="true"
							  	completeUrl="javascript:getajaxurl($('[name=creatertype]').val() == '1' ? '1' : '7')"  width="250px" browserValue="" browserSpanValue=""/>
					    </span>
					</wea:item>
				</wea:group>
			</wea:layout>
			</div>
			<div id="zDialog_div_bottom" class="zDialog_div_bottom">
				<wea:layout needImportDefaultJsAndCss="false">
					<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
						<wea:item type="toolbar">
					    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
						</wea:item>
					</wea:group>
				</wea:layout>
				<script type="text/javascript">
					resizeDialog();
				</script>
			</div>
	</body>
</html>
