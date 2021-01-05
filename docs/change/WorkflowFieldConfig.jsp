
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
	response.sendRedirect("/notice/noright.jsp");
		return;
}
%>
<%
String dbtype = RecordSet.getDBType();
String requestnamedbtype = "varchar(400)";
String createrdbtype = "int";
String isDialog = Util.null2String(request.getParameter("isdialog"));
String isClose = Util.null2String(request.getParameter("isclose"));
if(dbtype.equals("oracle")){
    requestnamedbtype = "varchar2(400)";
    createrdbtype = "integer";
}

boolean isView = Util.null2String(request.getParameter("isView")).equals("true");
String viewid="5";//Util.null2String(request.getParameter("viewid"));
String setname = "";
String workFlowId = "";
String workFlowName = "";
String isbill = "";
String formID = "";
String outermaintable = "";
String outerdetailtables = "";
String chageFlag = Util.null2String(request.getParameter("chageFlag"));
String companyid = Util.null2String(request.getParameter("companyid"));
int version = Util.getIntValue(request.getParameter("version"), 0);
int sn = Util.getIntValue(request.getParameter("sn"), 0);
int newsn = sn;
String newversionid = Util.null2String(request.getParameter("newversionid"));
if(!newversionid.equals("")) version = Util.getIntValue(newversionid,0);
workFlowId = Util.null2String(request.getParameter("wfid"));//工作流ID
String isedit = Util.null2String(request.getParameter("isedit"));
//out.println("workFlowId1:"+workFlowId+"	sn:"+sn);

//如果编辑过就把已经存在的数据带出来
String sql = "";
if(workFlowId.equals("")){
	sql = "select * from DocChangeFieldConfig where sn = '"+sn+"' and version = " + version;
	rs.executeSql(sql);
	//out.println(sql);
	while(rs.next()){
		workFlowId = rs.getString("workflowid");
	}
	//如果当前流程没有设置过对应关系，那么取同一个chageFlag设置过的流程来作为默认值
	if(workFlowId.equals("")){
		sql = "select * from DocChangeFieldConfig where companyid='"+companyid+"' and chageFlag='"+chageFlag+"' and version = " + version + " order by id asc";
		rs.executeSql(sql);
		//out.println(sql);
		while(rs.next()){
			workFlowId = rs.getString("workflowid");
			newsn = Util.getIntValue(rs.getString("sn"), 0);
		}
	}
	//out.println("workFlowId2:"+workFlowId+"	newsn:"+newsn);
}

isbill = Util.null2String(WorkflowComInfo.getIsBill(workFlowId));//取得Formid
formID=Util.null2String(WorkflowComInfo.getFormId(workFlowId));//取得Formid
workFlowName=Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId));//工作流名称
ArrayList maintablecolsList = new ArrayList();
//maintablecolsList.add("t1");
//maintablecolsList.add("t2");
ArrayList outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
String maintableoptions = "";
String temptableoptions = "";
String temprulesoptvalue = "0";
String tempiswriteback = "0";
int fieldscount = 2;

//取得配置字段信息
RecordSet.executeSql("SELECT * FROM DocChangeReceiveField WHERE chageFlag='"+chageFlag+"' AND companyid='"+companyid+"' AND version="+version + " and sn = " + sn);
//out.println("SELECT * FROM DocChangeReceiveField WHERE chageFlag='"+chageFlag+"' AND companyid='"+companyid+"' AND version="+version + " and sn = " + sn);
while(RecordSet.next()){
    maintableoptions += "<option value='"+RecordSet.getString("fieldid")+"'>"+RecordSet.getString("fieldname")+"&lt;"+RecordSet.getString("fieldid")+"&gt;"+"</option>";
}
Hashtable outerfieldid_ht = new Hashtable();
Hashtable outerfieldname_ht = new Hashtable();
Hashtable changetype_ht = new Hashtable();

//取得已配置字段信息
sql = "SELECT t1.fieldname fn, t1.rulesopt, t2.fieldname,t2.fieldid FROM DocChangeFieldConfig t1, DocChangeReceiveField t2 WHERE "+
			 "t1.chageFlag=t2.chageFlag AND t1.companyid=t2.companyid AND t1.version=t2.version AND t1.outerfieldname=t2.fieldid ";
if(!chageFlag.equals("")) sql += " AND t1.chageFlag='"+chageFlag+"' ";
if(!companyid.equals("")) sql += " AND t1.companyid='"+companyid+"' ";
if(version!=0) sql += " AND t1.version="+version;
sql += " AND t1.workflowid='"+workFlowId+"'";
if(newsn>0) sql += " AND t1.sn="+newsn+" ";
RecordSet.executeSql(sql);
//out.println(sql);
while(RecordSet.next()){
	outerfieldid_ht.put(RecordSet.getString("fn"), RecordSet.getString("fieldid"));
	outerfieldname_ht.put(RecordSet.getString("fn"), RecordSet.getString("fieldname")+"&lt;"+RecordSet.getString("fieldid")+"&gt;");
	changetype_ht.put(RecordSet.getString("fn"), RecordSet.getString("rulesopt"));
}
ArrayList wfList = new ArrayList();
sql = "SELECT workflowid FROM DocChangeFieldConfig WHERE 1=1 ";
if(!chageFlag.equals("")) sql += " AND chageFlag='"+chageFlag+"' ";
if(!companyid.equals("")) sql += " AND companyid='"+companyid+"' ";
if(version>0) sql += " AND version="+version+" ";
if(newsn>0) sql += " AND sn="+newsn+" ";
sql += " group by workflowid ";
RecordSet.executeSql(sql);
//out.println(sql);
while(RecordSet.next()){
	wfList.add(RecordSet.getString("workflowid"));
}
String workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId));

//System.out.println("workflowname:"+workflowname+"::workflowid:"+workFlowId);
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">

	var parentWin = null;
	var parentDialog = null;
	<%if(isClose.equals("1")||isDialog.equals("1")){%>
		parentWin = parent.parent.getParentWindow(parent);
		parentDialog = parent.parent.getDialog(parent);
	<%}%>
	<%if(isClose.equals("1")){%>
		//parentDialog.close();
		parentWin._table.reLoad();
	<%}%>
</script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23083,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!workFlowId.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(!"1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!workFlowId.equals("")){ %>
				<input type=button class="e8_btn_top" onclick="doSubmit();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="WorkflowFieldConfigOperation.jsp">
<input type="hidden" id="operate" name="operate" value="adddetail">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="sn" name="sn" value="<%=sn%>">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<input type="hidden" id="companyid" name="companyid" value="<%=companyid%>">
<input type="hidden" id="chageFlag" name="chageFlag" value="<%=chageFlag%>">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="wfid" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="name"
				browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isWorkflowDoc=1" isMustInput="2" isSingle="true" hasInput="true"
				temptitle='<%= SystemEnv.getHtmlLabelName(2118,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
				completeUrl="/data.jsp?type=workflowBrowser&isWorkflowDoc=1&onlyWfDoc=1" _callback="doFieldConfig" width="300px" browserValue='<%=workFlowId %>' browserSpanValue='<%=workflowname %>' />
			<input type="hidden" value="<%=version%>" name="version">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></wea:item>
		<wea:item>V<%=version%></wea:item>
	</wea:group>
	<%if(!workFlowId.equals("")&&!workFlowId.equals("0")){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33512,user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'3','cws':'40%,40%,20%'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("18015,18549",user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("1995,261",user.getLanguage())%></wea:item>
						<wea:item type="thead">
							<%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%>
							<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(24540,user.getLanguage())%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
						</wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(22244,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
							<input type="hidden" id="fieldid_index_1" name="fieldid_index_1" value="-1">
							<input type="hidden" id="fieldname_index_1" name="fieldname_index_1" value="requestname">
							<input type="hidden" id="fieldhtmltype_index_1" name="fieldhtmltype_index_1" value="1">
							<input type="hidden" id="fieldtype_index_1" name="fieldtype_index_1" value="1">
							<input type="hidden" id="fielddbtype_index_1" name="fielddbtype_index_1" value="<%=requestnamedbtype%>">
						</wea:item>
						<%
							temptableoptions = maintableoptions;
							String tempfieldname = Util.null2String((String)outerfieldname_ht.get("-1"));
							if(!tempfieldname.equals("")){
							    String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
							    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
							    temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
							}
							%>
						<wea:item>
							<select id="outerfieldname_index_1" name="outerfieldname_index_1">
								<option></option>
								<%=temptableoptions%>
							</select>
						</wea:item>
						<wea:item></wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
							<input type="hidden" id="fieldid_index_2" name="fieldid_index_2" value="-2">
							<input type="hidden" id="fieldname_index_2" name="fieldname_index_2" value="creater">
							<input type="hidden" id="fieldhtmltype_index_2" name="fieldhtmltype_index_2" value="3">
							<input type="hidden" id="fieldtype_index_2" name="fieldtype_index_2" value="1">
							<input type="hidden" id="fielddbtype_index_2" name="fielddbtype_index_2" value="<%=createrdbtype%>">
						</wea:item>
						<wea:item>
							<%
							temptableoptions = maintableoptions;
							tempfieldname = Util.null2String((String)outerfieldname_ht.get("-2"));
							temprulesoptvalue = Util.null2String((String)changetype_ht.get("-2"));
							String hrmname = "";
							String hrmid = "";
							if(temprulesoptvalue.equals("5")&&!temprulesoptvalue.equals("")){//选择了固定的创建人
							   hrmid = tempfieldname;
						     hrmname = ResourceComInfo.getLastname(hrmid);
							}else{
							    if(!tempfieldname.equals("")){
							        String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
							        String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
							        temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
							    }
							}
							%>
							<div id="outerfieldnamediv" name="outerfieldnamediv" <%if(temprulesoptvalue.equals("5")){%>style="display='none'"<%}else{%>style="display=''"<%}%> >
							<select id="outerfieldname_index_2" name="outerfieldname_index_2">
								<option></option>
								<%=temptableoptions%>
							</select>
							</div>
							<%--
							<div id="fixhrmresource" name="fixhrmresource" <%if(temprulesoptvalue.equals("5")){%>style="display=''"<%}else{%>style="display='none'"<%}%> >
							<button type="button" class=Browser  onclick="onShowHrmResource()" title="<%=SystemEnv.getHtmlLabelName(22734,user.getLanguage())%>"></button>
							<span id="hrmidspan"><%=hrmname%></span>
							<input type="hidden" id="hrmid" name="hrmid" value="<%=hrmid%>">
							</div> --%>
						</wea:item>
						<wea:item>
							<select id="rulesopt_2" name="rulesopt_2" onchange="changeRules(this.value)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<!--
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								-->
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<!--
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="5" <%if(temprulesoptvalue.equals("5")){%>selected<%}%> >--<%=SystemEnv.getHtmlLabelName(23155,user.getLanguage())%>--</option>
								 -->
							</select>
						</wea:item>
						<%
					ArrayList fieldids = new ArrayList();             //字段队列
					ArrayList fieldlabels = new ArrayList();          //字段的label队列
					ArrayList fieldhtmltypes = new ArrayList();       //字段的html type队列
					ArrayList fieldtypes = new ArrayList();           //字段的type队列
					ArrayList fieldnames = new ArrayList();           //字段名队列
					ArrayList fielddbtypes = new ArrayList();         //字段数据类型
					if(!formID.equals("")){
					    if(isbill.equals("0")){//表单
					        RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formID+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");
					    	//out.println("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formID+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");
					        while(RecordSet.next()){
					            fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
					            fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
					        }
					    }else if(isbill.equals("1")){//单据
					        RecordSet.executeSql("select * from workflow_billfield where viewtype=0 and billid="+formID);
					        //out.println("select * from workflow_billfield where viewtype=0 and billid="+formID);
					        while(RecordSet.next()){
					            fieldids.add(Util.null2String(RecordSet.getString("id")));
					            fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
					            fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
					            fieldtypes.add(Util.null2String(RecordSet.getString("type")));
					            fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
					            fielddbtypes.add(Util.null2String(RecordSet.getString("fielddbtype")));
					        }
					    }
					}
					for(int i=0;i<fieldids.size();i++){// 主字段循环开始
					    fieldscount++;
					    String fieldid = (String)fieldids.get(i);
					    String fieldlable = (String)fieldlabels.get(i);
					    String fieldhtmltype = "";
					    String fieldtype = "";
					    String fieldname = "";
					    String fielddbtype = "";
					    if(isbill.equals("0")){
					        fieldhtmltype = FieldComInfo.getFieldhtmltype(fieldid);
					        fieldtype = FieldComInfo.getFieldType(fieldid);
					        fieldname = FieldComInfo.getFieldname(fieldid);
					        fielddbtype = FieldComInfo.getFielddbtype(fieldid);
					    }else if(isbill.equals("1")){
					        fieldhtmltype = (String)fieldhtmltypes.get(i);
					        fieldtype = (String)fieldtypes.get(i);
					        fieldname = (String)fieldnames.get(i);
					        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue(fieldlable,0),user.getLanguage() );
					        fielddbtype = (String)fielddbtypes.get(i);
					    }
					%>  
						<wea:item>
							<%=fieldlable%>
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=fieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=fieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=fieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=fieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=fielddbtype%>">
						</wea:item>
						<%
						temptableoptions = maintableoptions;
						tempfieldname = Util.null2String((String)outerfieldid_ht.get(fieldid));
						if(!tempfieldname.equals("")){
							String tmpname = Util.null2String((String)outerfieldname_ht.get(fieldid));
						    String replaceedStr = "<option value='"+tempfieldname+"'>"+tmpname+"</option>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tmpname+"</option>";
						    temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
						}
						%>
						<wea:item>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</wea:item>
						<wea:item>
							<%
							if(fieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(fieldid));
							    if(fieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<!--
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								-->
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<!--
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								-->
							</select>    
							<%  }else if(false && fieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
							</select>
							<%  }else if(false && fieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
							</select>
							<%  }
							%>
							<%}%>
						</wea:item>
					<%} %>
					</wea:group>
				</wea:layout>
			</wea:item>
		</wea:group>
	<%} %>
</wea:layout>
<input type="hidden" id="fieldscount" name="fieldscount" value="<%=fieldscount%>">
</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</body>
</html>
<script language="javascript">

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});

function doSubmit(){
    document.getElementById("fieldscount").value = "<%=fieldscount%>";
    document.frmmain.submit();
}

function doFieldConfig(e,datas,name,params){
	window.location.href = "/docs/change/WorkflowFieldConfig.jsp?isdialog=1&chageFlag=<%=chageFlag%>&newversionid=<%=newversionid%>&companyid=<%=companyid%>&sn=<%=sn%>&wfid="+datas.id;
}

function changeRules(rulevalue){
    if(rulevalue==5){
        document.getElementById("outerfieldnamediv").style.display = "none";
        document.getElementById("fixhrmresource").style.display = "";
    }else{
        document.getElementById("outerfieldnamediv").style.display = "";
        document.getElementById("fixhrmresource").style.display = "none";
    }
}
//更改条件
function changeParam() {
	document.frmmain.action = '/docs/change/WorkflowFieldConfig.jsp';
	document.frmmain.submit();
}
//处理提示信息
if(document.frmmain.wfid.value!='') {
	//document.getElementById('wffont').style.display = 'none';
}
if(document.frmmain.version.value!='') {
	//document.getElementById('versionfont').style.display = 'none';
}
function doBack() {
	<%if(isView){%>
		location.href = '/docs/change/DocChangeSetting.jsp';
	<%}else{%>
		location.href = '/docs/change/ReceiveDoc.jsp?status=1';
	<%}%>
}
</script>

