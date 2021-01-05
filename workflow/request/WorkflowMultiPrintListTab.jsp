
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <!--added by xwj  for td2903  20051019-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.IsGovProj" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<%@ include file="/workflow/request/CommonUtils.jsp" %>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>

		<script type="text/javascript">
			jQuery(document).ready(function () {
				$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
				$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
				$("#tabDiv").remove();
			});


			function onBtnSearchClick(){
				var typename=$("input[name='flowTitle']",parent.document).val();
				$("input[name='requestname']").val(typename);
				frmmain.submit();
			}

			function doSearch(){
				if (check_form(frmmain,'')){
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
							if(targetelement.val()==""){
								targetelement.val(temphtml);
							}
						}
					});

					$("input").each(function (i, e) {
						var thisval = $(this).val();
						if (thisval != undefined && thisval != "") {
							var ename = $(this).attr("name");
							var targetelement = $("#" + ename + "_name");

							if(!targetelement) return;
							var temphtml = "";
							$("#" + ename + "span a") && $("#" + ename + "span a").each(function () {
								temphtml += " " + $(this).text();
							});
							var checkspan = /^<.*$/;
							if(checkspan.test(temphtml)){
								temphtml=temphtml.replace(/<[^>]+>/g,"");
							}

							if(targetelement.val()==""){
								targetelement.val(temphtml);
							}
						}
					});

					$('#frmmain').submit();
				}
			}

			jQuery(document).ready(function(){
				//如果指定了流程编号，则加载表单字段作为查询条件

				<%
					String workflowidTemp = request.getParameter("workflowid");
					if(workflowidTemp == null || workflowidTemp.trim().equals("")){
						workflowidTemp = "''";
					}
				%>
				var workflowid = <%=workflowidTemp%>;
				if(workflowid){
					loadFormFieldReady(workflowid, false);
				}

				//给select类型的控件赋值

				<%
					String[] selectes = new String[]{
						"nodetype","requestlevel","creatertype",
						"ismultiprint","nodeid"
					};

					for(int i = 0; i < selectes.length; i++){
						String selectName = selectes[i];
				%>
					$("select[name=<%=selectName%>]").val(<%="'" + request.getParameter(selectName) + "'"%>);  
					$("select[name=<%=selectName%>]").removeAttr('notBeauty');
					beautySelect('select[name=<%=selectName%>]');
				<%
					}
				%>
			});

			/* 加载用户自定义的查询条件 */
			function loadFormFieldReady(workFlowId, needLoadNodes){
				if(needLoadNodes == true){
					return;
				}

				<%
					/*
					* 获取从上一个页面传入的自定义查询条件，将自定义查询条件转换为JSON格式的字符串。

					* 将JSON数据post给WorkflowMultiPrintSearchGenerate.jsp页面，生成自定义查询条件即为赋好值的页面。

					* 以此实现查询的条件的保存，不需要用户再次输入。

					*/
					String[] checkcons = request.getParameterValues("check_con");

					String customJsonString = "{";
					String checkboxes = "'";
					if(checkcons != null){
					  	for(int i = 0; i < checkcons.length; i++){
							String id         = ""+checkcons[i];
							String tmpvalue   = ""+Util.null2String(request.getParameter("con"+id+"_value"));
							String tmpvalue1  = ""+Util.null2String(request.getParameter("con"+id+"_value1"));
							String tmpname    = ""+Util.null2String(request.getParameter("con"+id+"_name"));

							if(!tmpvalue.equals("")){
								customJsonString  += "con"+id+"_value" + ":'" + tmpvalue + "',";	
							} 
							if(!tmpvalue1.equals("")){
								customJsonString  += "con"+id+"_value1" + ":'" + tmpvalue1 + "',";	
							} 
							if(!tmpname.equals("")){
								customJsonString  += "con"+id+"_name" + ":'" + tmpname + "',";	
							} 

							if(!tmpvalue.equals("")){
								checkboxes += (id + ",");
							}
						}
					}

					if(customJsonString.length() > 1){
						customJsonString = customJsonString.substring(0, customJsonString.length() - 1);	
					} 
					customJsonString += "}";

					if(checkboxes.length() > 1){
						checkboxes = checkboxes.substring(0, checkboxes.length() - 1);
					}
					checkboxes += "'"; 

					String nameValueString = "'";
					Enumeration elementNames = (Enumeration) request.getParameterNames();   
				    while(elementNames.hasMoreElements())     {   
				    	String elementName = (String)elementNames.nextElement(); 

				    	if(elementName.startsWith("con") 
				    		&& elementName.endsWith("_value")
				    		&& request.getParameter(elementName) != null 
				    		&& !request.getParameter(elementName).trim().equals("")
				    	){
			    			nameValueString += (elementName + ":" + Util.null2String(request.getParameter(elementName)) + ",");	
				    	}
				    } 
					
					if(nameValueString.length() > 1){
						nameValueString = nameValueString.substring(0, nameValueString.length() - 1);
					}
					nameValueString += "'";

				%>

				var parameter = <%=customJsonString%>;
				parameter['issimple'] = true;
				parameter['workflowid'] = workFlowId;
				parameter['checkboxes'] = <%=checkboxes%>;
				parameter['allValues'] = <%=nameValueString%>;

				jQuery.post(
					'/workflow/request/WorkflowMultiPrintSearchGenerate.jsp',
					parameter,
					function(data){
						jQuery('#formFieldDiv').html(data);

						jQuery('#formFieldDiv').find('select').each(function(i,v){
							beautySelect(jQuery(v));
						});
					}
				);

				if(needLoadNodes == true){
					jQuery.post(
						'/workflow/request/LoadNodesByWorkflow.jsp',
						{
							'workflowid' : workFlowId
						},
						function(data){
							data = (  "<select id='nodeid' name='nodeid'>" 
									+ "<option value='0'></option>"
									+ data
									+ "</select>" );
							$('#nodeidDiv').html(data);
							beautySelect('select[name=nodeid]');
						}
					);
				}
			}
			
			
			/* 加载用户自定义的查询条件 */
			function loadFormField(workFlowId, needLoadNodes){
			    if(workFlowId == <%=workflowidTemp%>){
			    	loadFormFieldReady(workFlowId,true);
			    	return;
			    }
				if(!workFlowId){
					jQuery('#formFieldDiv').html('');

					$('#nodeidDiv').html("<select id='nodeid' name='nodeid'>" 
										 + "<option value='0'></option>" 
										 + "</select>");
					beautySelect('select[name=nodeid]');
					return;
				}

				jQuery.post(
					'/workflow/request/WorkflowMultiPrintSearchGenerate.jsp',
					{
							'workflowid' : workFlowId
					},
					function(data){
						jQuery('#formFieldDiv').html(data);

						jQuery('#formFieldDiv').find('select').each(function(i,v){
							beautySelect(jQuery(v));
						});
					}
				);

				if(needLoadNodes == true){
					jQuery.post(
						'/workflow/request/LoadNodesByWorkflow.jsp',
						{
							'workflowid' : workFlowId
						},
						function(data){
							data = (  "<select id='nodeid' name='nodeid'>" 
									+ "<option value='0'></option>"
									+ data
									+ "</select>" );
							$('#nodeidDiv').html(data);
							beautySelect('select[name=nodeid]');
						}
					);
				}
			}
		</script>
	</head>

<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(26382,user.getLanguage())+",javascript:onMultiPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(84820,user.getLanguage())+",javascript:onSetPrint(1),_self}";
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(84821,user.getLanguage())+",javascript:onSetPrint(0),_self}";
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(21533,user.getLanguage())+",javascript:doPrintViewLog(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;


%>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<FORM id="frmmain" name="frmmain" method="post" action="WorkflowMultiPrintMiddleHandler.jsp">
<input type="hidden" id="fromself" name="fromself" value="1">
<input type="hidden" id="operation" name="operation" value="">
<input type="hidden" id="ismultiprintinput" name="ismultiprintinput" value="">
<input type="hidden" id="multirequestid" name="multirequestid" value="">
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统


ArrayList canoperaternode = new ArrayList(); //added by xwj  for td2903  20051019

ArrayList monitorWfList = new ArrayList();

String operation = Util.null2String(request.getParameter("operation"));
if("setprint".equals(operation)){
	int ismultiprintinput = Util.getIntValue(request.getParameter("ismultiprintinput"), -1);
	if(ismultiprintinput==0 || ismultiprintinput==1){
		String multirequestid = Util.null2String(request.getParameter("multirequestid"));
		String sql_tmp = "update workflow_requestbase set ismultiprint="+ismultiprintinput+" where requestid in ("+multirequestid+"0)";
		rs.executeSql(sql_tmp);
	}
}
String monitorWfStrs = "";
String typeId="";
String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String requestname ="" ;//added xwj for for td2903  20051019
String wfcode = "";
int ismultiprint = -1;
int nodeid = 0;
int operater = 0;
String startDate = "";   //归档日期的开始日期
String endDate = "";     //归档日期的结束日期
String createDate = "";  //创建日期下拉框选择的值
String archiveDate = ""; //归档日期下拉框选择的值

workflowid =  Util.null2String(request.getParameter("workflowid"));
nodetype = Util.null2String(request.getParameter("nodetype"));
fromdate = Util.null2String(request.getParameter("fromdate"));
todate = Util.null2String(request.getParameter("todate"));
typeId = Util.null2String(request.getParameter("typeId"));

creatertype = Util.null2String(request.getParameter("creatertype"));
createrid = Util.null2String(request.getParameter("createrid"));
String createrid1 = Util.null2String(request.getParameter("createrid1"));

requestlevel = Util.null2String(request.getParameter("requestlevel"));
requestname = Util.null2String(request.getParameter("requestname"));//added xwj for for td2903  20051019
wfcode = Util.null2String(request.getParameter("wfcode"));


ismultiprint = Util.getIntValue(request.getParameter("ismultiprint"));
nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
operater = Util.getIntValue(request.getParameter("operater"));

startDate = Util.null2String(request.getParameter("startDate"));
endDate = Util.null2String(request.getParameter("endDate"));
createDate = Util.null2String(request.getParameter("createDate"));
archiveDate = Util.null2String(request.getParameter("archiveDate"));


String newsql=" ";

if(!"".equals(startDate) || !"".equals(endDate)){
	newsql += " and a.currentnodetype = '3' and b.iscomplete = '1'";  //仅查询归档的流程
}
if(!"".equals(startDate)){
	newsql += " and a.lastoperatedate >= '" + startDate + "'";
}
if(!"".equals(endDate)){
	newsql += " and a.lastoperatedate <= '" + endDate + "'";
}

if(!typeId.equals("")){
	newsql+=" and b.workflowtype in ("+typeId+") " ;
}
if(!workflowid.equals("")&&!workflowid.equals("0")){
	String versionwfids = WorkflowVersion.getAllVersionStringByWFIDs(workflowid);
	newsql+=" and a.workflowid in("+versionwfids+")" ;
}

if(!wfcode.equals("")){
	newsql += " and requestmark ='"+wfcode+"'";
}

if(!nodetype.equals("")){
	newsql += " and currentnodetype='"+nodetype+"'";
}
if(!fromdate.equals("")){
	newsql += " and createdate>='"+fromdate+"'";
}

if(!todate.equals("")){
	newsql += " and createdate<='"+todate+"'";
}

 

 if(creatertype.equals("1")){
    if(!createrid.equals("")){
	  newsql += " and creater='"+createrid+"'";
	 
	}
 }else{
	if(!createrid1.equals("")){
	
	  newsql += " and creater='"+createrid+"'";
	 
	  
	}
 }
	

if(!requestlevel.equals("")){
	newsql += " and requestlevel="+requestlevel;
}

if(!requestname.equals("")){
	newsql += " and requestnamenew like '%"+requestname+"%' ";
}

// if(!requestmark.equals("")){
// 	newsql += " and requestmark like '%"+requestmark+"%' ";
// }

if(ismultiprint > -1){
	newsql += " and a.ismultiprint="+ismultiprint;
}

if(nodeid > 0){
	newsql += " and exists (select c.id from workflow_currentoperator c where c.requestid=a.requestid and c.nodeid="+nodeid+" and c.userid="+user.getUID()+") ";
}

if(operater > 0){
	newsql += " and exists (select c.id from workflow_currentoperator c where c.requestid=a.requestid and c.userid="+operater+") ";
}


String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();
String userlang = ""+user.getLanguage();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")){
		usertype = 1;
	}
}

newsql += " and a.requestid=b.requestid and b.islasttimes = 1 and userid="+user.getUID()
	   +" and usertype="+usertype+"    and (exists (select 1 from workflow_nodemode n where n.isprint='1' and n.workflowid=b.workflowid and n.nodeid=b.nodeid ) "
       +" or exists (select 1 from workflow_nodehtmllayout f where f.isactive=1 and f.type = '1' and f.workflowid = b.workflowid and f.nodeid = b.nodeid ))";


if(!"".equals(newsql)){
	newsql = newsql.replaceFirst("and", "");
}
String sqlWhere = " where  " +newsql + "  ";
String orderby =" createdate ,createtime ";
int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

String ops="";
if(operater!=-1)
{
  ops=operater+"";
}

SearchClause.resetClause();
SearchClause.setWhereClause(sqlWhere);
 
%>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(26382,user.getLanguage())%>" class="e8_btn_top" onclick="onMultiPrint()"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(84820,user.getLanguage())%>" class="e8_btn_top" onclick="onSetPrint(1)"/>	&nbsp;&nbsp;&nbsp;
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(84821,user.getLanguage())%>" class="e8_btn_top" onclick="onSetPrint(0)"/>	&nbsp;&nbsp;&nbsp;
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(21533,user.getLanguage())%>" class="e8_btn_top" onclick="doPrintViewLog()"/>&nbsp;&nbsp;&nbsp;
						<input type="text" class="searchInput" name="flowTitle" value="<%=requestname%>"/>
						&nbsp;&nbsp;&nbsp;
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			
			<div id="tabDiv" >
				<span id="hoverBtnSpan" class="hoverBtnSpan">
				<span><%=SystemEnv.getHtmlLabelName(26382,user.getLanguage())%></span>
				</span>
			</div>
			<!-- bpf start 2013-10-29 -->
			<div class="advancedSearchDiv" id="advancedSearchDiv">	
		        <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
			    	<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
			    		<!-- 类型 -->
				    	<wea:item><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="typeId"
								browserValue='<%=typeId%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
								onPropertyChange="changeFlowType()"
								hasInput="true" isSingle="true" hasBrowser="true"
								isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
								browserDialogWidth="600px"
								browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(typeId)%>'></brow:browser>
						</wea:item>	
						
					    <!-- 工作流 -->
				    	<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
					    <wea:item>
						    <brow:browser onPropertyChange="loadFormField(jQuery('#workflowid').val(),true)" id='workflowid' name="workflowid" viewType="0"   hasBrowser="true" hasAdd="false" getBrowserUrlFn="getFlowWindowUrl" isMustInput="1" isSingle="true" hasInput="true" completeUrl="/data.jsp?type=workflowBrowser" width='80%' browserValue='<%=workflowid%>' browserSpanValue='<%=WfComInfo.getWorkflowname(workflowid)%>'/> 				  	
					    </wea:item>
				  
				    	<!-- 流程编号 -->
				    	<wea:item ><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
				    	<wea:item >
				    		<input type="text" name="wfcode" style='width:80%;' value='<%=wfcode%>'>
				    	</wea:item>
				    	
				    	<!-- 打印状态 -->
						<wea:item ><%=SystemEnv.getHtmlLabelName(27044,user.getLanguage())%></wea:item >
						<wea:item >
					        <select id="ismultiprint" name="ismultiprint" >
								<option value="-1"></option>
								<option value="0" <%if(ismultiprint==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27045,user.getLanguage())%></option>
								<option value="1" <%if(ismultiprint==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27046,user.getLanguage())%></option>
							</select>
						</wea:item>
						
						<!-- 创建人 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item >
						<wea:item>			
							<span style="float:left;">
							  <select  name=creatertype id="creatertype" onChange="onChangeUserType(this.value)">
								  <%if(isgoveproj==0){%>
								  <option value="1"  <%if(creatertype.equals("1")){%>selected<%} %> ><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
								  <option value="2"  <%if(creatertype.equals("2")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
							  <%}else{%>
							   	  <option value="1"  <%if(creatertype.equals("1")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
							  <%}%>
							  </select>
							  </span>
							  <span id="crmAndHrm" style="">
							   <span id="hrm" >
									<brow:browser viewType="0" name="createrid" browserValue='<%=createrid%>' 
									 browserOnClick="onShowCreater('createridspan','createrid')"
									 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									 completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
									 browserSpanValue='<%=ResourceComInfo.getResourcename(createrid)%>'></brow:browser>
								</span>
							   <span id="crm" style="display:none">
									<brow:browser viewType="0" name="createrid1" browserValue='<%=createrid1%>' 
									 browserOnClick="onShowCreater('createrid1span','createrid1')"
									 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									 completeUrl="/data.jsp?type=7" linkUrl="#" width="49%"
									 browserSpanValue='<%=ResourceComInfo.getResourcename(createrid1)%>'></brow:browser>
								</span>
					  		</span>	
						</wea:item>
						
						<!-- 创建日期 -->
					    <wea:item ><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item >
				    	<wea:item >
				    		<%-- 
				            <button type="button"  class="calendar" id="SelectDate"  onclick="gettheDate(fromdate,fromdatespan)"></button>
							<span id="fromdatespan" ><%=fromdate%></span>
							<span id="fromdatespanimg"></span>
							&nbsp;-&nbsp;
							<button type="button"  class="calendar" id="SelectDate2" onclick="gettheDate(todate,todatespan)"></button>
							<span id="todatespan"><%=todate%></span>
							<input type="hidden" name="fromdate" value="<%=fromdate%>" />
							<input type="hidden" name="todate" value="<%=todate%>" />
				    		--%>
				    		<span class="wuiDateSpan" selectId="createDate" selectValue="<%=createDate%>">
							<input name="fromdate" value="<%=fromdate%>"  type="hidden" class="wuiDateSel">
							<input name="todate" value="<%=todate%>"  type="hidden" class="wuiDateSel">
							</span>
						</wea:item>
			    	</wea:group>
				     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'>
				     	<!-- 流程标题 -->
				    	<wea:item ><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></wea:item>
				    	<wea:item >
				    		<input type="text" name="requestname" style='width:80%;' value="<%=requestname%>">
				    	</wea:item>
				    	
				    	<!-- 紧急程度 -->
				    	<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
				    	<wea:item>
				    		<select name="requestlevel">
								<option value="">&nbsp;</option>
								<option value="0" <%if(requestlevel.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
								<option value="1" <%if(requestlevel.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
								<option value="2" <%if(requestlevel.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
							</select>
				    	</wea:item>		
				    						
						<!-- 节点类型 -->
				    	<wea:item><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
				    	<wea:item>
				          	<select name="nodetype" >
								<option value="">&nbsp;</option>
								<option value="0" <%if(nodetype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
								<option value="1" <%if(nodetype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
								<option value="2" <%if(nodetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
								<option value="3" <%if(nodetype.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
							</select>
						</wea:item>	
						
						<!-- 节点处理人 -->
				    	<wea:item ><%=SystemEnv.getHtmlLabelName(26033,user.getLanguage())%></wea:item >
						<wea:item >   
				        <brow:browser viewType="0" name="operater" browserValue='<%=operater+""%>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
										hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
										completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
										browserSpanValue='<%=ResourceComInfo.getResourcename(operater+"")%>'></brow:browser>
						</wea:item >
											
						<!-- 节点 -->
						<wea:item ><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></wea:item >
						<wea:item >
							<div id="nodeidDiv">
					         	<select id="nodeid" name="nodeid" notBeauty="true">
									<option value="0"></option>
									<%
										if(!workflowid.trim().equals("")){
										    rs.execute("select f.nodeid, n.nodename from workflow_flownode f left join workflow_nodebase n on f.nodeid=n.id where f.workflowid="+workflowid+" order by f.nodetype, f.nodeid");
											while(rs.next()){
												out.println("<option value='"+Util.getIntValue(rs.getString(1), 0)+"'>"
												+Util.null2String(rs.getString(2))
												+"</option>");
											}
										}
									%>
								</select>
							</div>
						</wea:item >
						<%--归档时间 --%>
						<wea:item ><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item >
						<wea:item>
						<span class="wuiDateSpan" selectId="archiveDate" selectValue="<%=archiveDate%>">
						<input name="startDate" value="<%=startDate%>"  type="hidden" class="wuiDateSel">
						<input name="endDate" value="<%=endDate%>"  type="hidden" class="wuiDateSel">
						</span>
						</wea:item>
				    </wea:group>
				    <wea:group context="">
				    	<wea:item type="toolbar">
						    <input class="e8_btn_submit" type="submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" class="e8_btn_submit" onclick="doSearch()"/>
							<span class="e8_sep_line">|</span>
					        <input  class="e8_btn_cancel" type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				    	</wea:item>
				    </wea:group>
				</wea:layout>
				<div id="formFieldDiv"></div>
			</div>	

			<input name="start" type="hidden" value="<%=start%>">
			<input type="hidden" name="multiRequestIds" value="">
			<input type="hidden" name="multiSubIds" id="multiSubIds" value="">
			<input type="hidden" name="flag" id="flag" value="">
			<input type="hidden" name="requestidvalue" id="requestidvalue" value="">
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_REQUEST_WORKFLOWMULTIPRINTLISTTAB%>"/>

<%
String tableString = "";
if(perpage <2) perpage=10;								 
String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel, a.ismultiprint,b.receivedate,b.receivetime ";
String fromSql  = " workflow_requestbase a,workflow_currentoperator b";

String isNeed = (String) request.getAttribute("CustomSearch_IsNeed");

if(isNeed != null){
	String _requestIdList = (String)request.getAttribute("CustomSearch_RequestIdList");
	if(_requestIdList != null && !_requestIdList.trim().equals("")){
		sqlWhere += (" and exists ( " + _requestIdList + " and d.requestid=a.requestid) ");
	}
}

//System.out.println("select " + backfields + " from " + fromSql+ sqlWhere) ;
//out.println("fromSql:" + fromSql);
//out.println("sqlWhere:" + sqlWhere);




// if(hasFieldClause == true) sqlWhere += fieldsql;
String para2="column:requestid+"+CurrentUser+"+"+logintype+"+"+userlang;
String para11="column:requestname+"+"("+"column:requestid+"+")";
String para1="column:requestid+column:workflowid+column:viewtype+0+"+user.getLanguage();
String para4=userlang+"+"+user.getUID();
String para3="column:workflowid+"+CurrentUser+"+"+logintype;
tableString = "<table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUEST_WORKFLOWMULTIPRINTLISTTAB,user.getUID())+"\" >"+
		"	<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
		"		<head>"+
		"			<col width=\"22%\" text=\"" + SystemEnv.getHtmlLabelName(1334, user.getLanguage()) + "\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLink\"  otherpara=\""+para1+"\" />"+
		"			<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"a.workflowid,a.requestname\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
		"			<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
		"			<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
		"			<col width=\"8%\" display=\"false\" text=\""+SystemEnv.getHtmlLabelName(27044,user.getLanguage())+"\" column=\"ismultiprint\" orderkey=\"a.ismultiprint\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getIsmultiprintStr\" />"+
		"			<col width=\"8%\" display=\"false\" text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"a.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>"+
		"			<col width=\"12%\" display=\"false\" text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"b.receivedate,b.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
		"			<col width=\"8%\" display=\"false\" text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" />"+
		"		</head>"+
		"</table>";
%>
		<table width="100%" cellspacing=0 height=94%>
			<tr>
				<td valign="top">  
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
				</td>
			</tr>
		</table>
		</td>
		</tr>
		</TABLE>
</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<script type="text/javascript">
	
	function onShowCreater(tdname,inputename){
	var userType = jQuery("#creatertype").val();
	var datas=null;
	//var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	//var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	
	var url = "";
	if (userType == "1" ) {
	    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	    url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else  {
	    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	    url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.callbackfunParam = null;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, datas) {
		if (datas) {
		    if (datas.id!=""){
		    	var name = "<a href='#"+datas.id+"'>"+datas.name+"</a>";
		    	if(userType=="1"){
		    		name = wrapshowhtml("<a href='javascript:openhrm("+datas.id+")' onclick='javascript:pointerXY(event);'>"+datas.name+"</a>", datas.id);
		    	}
		        jQuery("#"+tdname).html(name);
		        jQuery("#"+inputename).val(datas.id);
			}
		    else{
		        jQuery("#"+tdname).html("");
		        jQuery("#"+inputename).val("");
		    }
		    hoverShowNameSpan(".e8_showNameClass");
		    try {
				eval(jQuery("#inputename").attr('onpropertychange'));
			} catch (e) {
			}
			try {
				eval(jQuery("#inputename__").attr('onpropertychange'));
			} catch (e) {
			}
		}
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}
function uescape(url){
	return escape(url);
}
	function doPrintViewLog(){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 550;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(21533,user.getLanguage())%>";
	   
		 
		diag_vote.URL = "/workflow/request/WorkflowLogNew.jsp?requestid=&printtypes=2&workflowid2=<%=workflowid%>&multitype=1&wheresql=<%=xssUtil.put(sqlWhere) %>";
		diag_vote.show();
	}


	function onChangeResource(tdname,inputename){
		var tmpval = $GetEle("creatertype").value;
		var tempurl1 = "";
		if (tmpval == "0") {
			tempurl1 = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
		}else {
			tempurl1 = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
		}
		disModalDialog(tempurl1,$G(tdname), $G(inputename), false);		
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

	function OnChangePage(start){
			document.frmmain.start.value = start;
			//if(check_form(document.weaver,'fromdate'))
			document.frmmain.submit();
	}

	var showTableDiv  = document.getElementById('divshowreceivied');
	var oIframe = document.createElement('iframe');
	function showreceiviedPopup(content){
		showTableDiv.style.display='';
		var message_Div = document.createElement("div");
		 message_Div.id="message_Div";
		 message_Div.className="xTable_message";
		 showTableDiv.appendChild(message_Div);
		 var message_Div1  = document.getElementById("message_Div");
		 message_Div1.style.display="inline";
		 message_Div1.innerHTML=content;
		 var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
		 var pLeft= document.body.offsetWidth/2-50;
		 message_Div1.style.position="absolute"
		 message_Div1.style.top=pTop;
		 message_Div1.style.left=pLeft;

		 message_Div1.style.zIndex=1002;

		 oIframe.id = 'HelpFrame';
		 showTableDiv.appendChild(oIframe);
		 oIframe.frameborder = 0;
		 oIframe.style.position = 'absolute';
		 oIframe.style.top = pTop;
		 oIframe.style.left = pLeft;
		 oIframe.style.zIndex = message_Div1.style.zIndex - 1;
		 oIframe.style.width = parseInt(message_Div1.offsetWidth);
		 oIframe.style.height = parseInt(message_Div1.offsetHeight);
		 oIframe.style.display = 'block';
	}

	function onMultiPrint(){
		var multirequestid = _xtable_CheckedCheckboxId();
		//alert(multirequestid);
		if(multirequestid!=null && multirequestid!=""){
			var redirectUrl = "/workflow/multiprint/MultiPrintGroups.jsp?multirequestid="+multirequestid;
			var width = screen.availWidth-10 ;
			var height = screen.availHeight-50 ;
			var szFeatures = "top=0," ;
			szFeatures +="left=0," ;
			szFeatures +="width="+width+"," ;
			szFeatures +="height="+height+"," ;
			szFeatures +="directories=no," ;
			szFeatures +="status=yes,toolbar=no,location=no," ;
			szFeatures +="menubar=no," ;
			szFeatures +="scrollbars=yes," ;
			szFeatures +="resizable=yes" ; //channelmode
			//window.open(redirectUrl,"",szFeatures) ;
			jQuery.post("/workflow/multiprint/MultiPrintGroups.jsp",{multirequestid : multirequestid },function(_data){
				_data = eval("(" + _data + ")");
				var modereqids = _data.modereqids;
				if(!!modereqids && modereqids.length > 0){
					var redirectUrl = "/workflow/multiprint/MultiPrintMode.jsp?multirequestid=" + modereqids;
					window.open(redirectUrl,"",szFeatures) ;
				}

				var htmlreqids = _data.htmlreqids;
				if(!!htmlreqids && typeof htmlreqids == "object"){
					for(_key in htmlreqids){
						var redirectUrl = "/workflow/multiprint/MultiPrintRequest.jsp?multirequestid=" + htmlreqids[_key];
						window.open(redirectUrl,"",szFeatures) ;
					}
				}
			});
		}else{
		 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26427,user.getLanguage())%>");
		}
	}

	function onSetPrint(ismultiprint){
		document.getElementById("ismultiprintinput").value = ismultiprint;
		var multirequestid = _xtable_CheckedCheckboxId();
		if(multirequestid != null && multirequestid != ""){
			document.getElementById("multirequestid").value = multirequestid;
			document.getElementById("operation").value = "setprint";
			$('#frmmain').submit();
		}else{
			 top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26427,user.getLanguage())%>");
		}
	}

	function onShowBrowser(id,url,tmpindex) {
		var url = url + "?selectedids=" + $G("con" + id + "_value").value;
		disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
		$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;

		if ($G("con" + id + "_value").value == ""){
		    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
		} else {
		    document.frmmain.check_con[tmpindex*1].checked = true
		    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
		}
	}

	function onShowBrowser2(id, url, type1, tmpindex) {
				var tmpids = "";
				var dlgurl = "";
				if (type1 == 8) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?projectids=" + tmpids;
				} else if (type1 == 9) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?documentids=" + tmpids;
				} else if (type1 == 1) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				} else if (type1 == 4) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?selectedids=" + tmpids + "&resourceids=" + tmpids
				} else if (type1 == 16) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				} else if (type1 == 7) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				} else if (type1 == 142) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?receiveUnitIds=" + tmpids;
				} else {
				    tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				}
				
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.callbackfunParam = null;
				dialog.URL = dlgurl;
				dialog.callbackfun = function (paramobj, id1) {
					if (id1 != null) {
						resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
						resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
						if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
							resourceids = resourceids.replace(',','');
							resourcename = resourcename.replace(',','');
	
							$G("con" + id + "_valuespan").innerHTML = wrapshowhtml(resourcename, resourceids);
							jQuery("input[name=con" + id + "_value]").val(resourceids);
							jQuery("input[name=con" + id + "_name]").val(resourcename);
						} else {
							$G("con" + id + "_valuespan").innerHTML = "";
							$G("con" + id + "_value").value = "";
							$G("con" + id + "_name").value = "";
						}
					}
					if ($G("con" + id + "_value").value == "") {
	
						document.getElementsByName("check_con")[tmpindex * 1].checked = false;
					} else {
						document.getElementsByName("check_con")[tmpindex * 1].checked = true;
					}
					hoverShowNameSpan(".e8_showNameClass");
					try {
						jQuery("#"+ "con" + id + "_value").attr('onpropertychange');
					} catch (e) {
					}
					try {
						jQuery("#"+ "con" + id + "_value" + "__").attr('onpropertychange');
					} catch (e) {
					}
				};
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
				dialog.Width = 550 ;
				dialog.Height = 600;
				dialog.Drag = true;
				dialog.show();
			}

	function onShowWorkFlowSerach(inputname, spanname) {

		retValue = window
				.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put(" where isvalid='1' ")%> ");
		temp = $G(inputname).value;
		if(retValue != null) {
			if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
				$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
				$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
				
				if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
					$G("frmmain").action = "WFCustomSearchBySimple.jsp";
					$G("frmmain").submit();
					enablemenuall();
				}
			} else {
				$G(inputname).value = "";
				$G(spanname).innerHTML = "";
				$G("frmmain").action = "WFSearch.jsp";
				$G("frmmain").submit();

			}
		}
	}
	
	function getFlowWindowUrl(){
			//return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
			return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WFTypeBrowser.jsp";
	}
	
	function enablemenuall()
	{
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
				{
				window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
		}
		//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
	function changelevel(obj,tmpindex){

	    if(obj.value!=""){
	 		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	    }else{
	        document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	    }
	}
	function changelevel1(obj1,obj,tmpindex){

	    if(obj.value!=""||obj1.value!=""){
	 		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	    }else{
	       document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	    }
	}
	function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex){
		var oncleaingFun = function(){
			  $(spanname).innerHTML = '';
			  $(inputname).value = '';
	          if($(inputname).value==""&&$(inputname1).value==""){
	              document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	          }
			}
			var language=readCookie("languageidweaver");
			if(language==8)
				languageStr ="en";
			else if(language==9)
				languageStr ="zh-tw";
			else
				languageStr ="zh-cn";
			WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;
				document.getElementsByName("check_con")[tmpindex * 1].checked = true;
			},oncleared:oncleaingFun});
	}
	function onSearchWFQTTime(spanname,inputname,inputname1,tmpindex){
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
	    outValue2=tmpindex;
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
	function changeFlowType() {
		//_writeBackData('workflowid', 1, {id:'',name:''});
	}
</script>
<script language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
</body>
</html>
