
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSetDataSource"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="AutomaticCols" class="weaver.workflow.automatic.automaticcols" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String dbtype = RecordSet.getDBType();
String requestnamedbtype = "varchar(400)";
String createrdbtype = "int";
if(dbtype.equals("oracle")){
    requestnamedbtype = "varchar2(400)";
    createrdbtype = "integer";
}
boolean recordAndNotView=false;
String isdialog = Util.null2String(request.getParameter("isdialog"));

String typename = Util.null2String(request.getParameter("typename"));
String viewid=Util.null2String(request.getParameter("viewid"));
String setname = "";
String workFlowId = "";
String datasourceid = "";
String workFlowName = "";
String isbill = "";
String formID = "";
String outermaintable = "";
String outerdetailtables = "";
String datarecordtype = "";
String isview = "";
RecordSet.executeSql("select * from outerdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workFlowId = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    workFlowName=Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId));
    isbill=Util.null2String(WorkflowComInfo.getIsBill(workFlowId));
    formID=Util.null2String(WorkflowComInfo.getFormId(workFlowId));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
    datarecordtype= Util.null2String(RecordSet.getString("datarecordtype"));
    isview= Util.null2String(RecordSet.getString("isview"));

}

//需要回写且不是视图
if("2".equals(datarecordtype)&&!"1".equals(isview)){
	recordAndNotView=true;
}

ArrayList maintablecolsList = AutomaticCols.getAllColumns(datasourceid,outermaintable);
//qc:284052 页面显示字段类型
RecordSetDataSource rs2=new RecordSetDataSource(datasourceid);
Map allcolnums = rs2.getAllColumnWithTypes(datasourceid,outermaintable);

ArrayList outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
String maintableoptions = "";
String temptableoptions = "";
String temprulesoptvalue = "0";
String tempiswriteback = "0";
String tempcustomsql = "";
for(int i=0;i<maintablecolsList.size();i++){
    String columnname = outermaintable+"."+(String)maintablecolsList.get(i);
    maintableoptions += "<option value='"+columnname+"'>"+columnname+" ("+allcolnums.get((String)maintablecolsList.get(i).toString().toLowerCase())+")"+"</option>";////qc:284052 页面显示字段类型
}

int fieldscount = 2;

Hashtable outerfieldname_ht = new Hashtable();
Hashtable changetype_ht = new Hashtable();
Hashtable customsql_ht = new Hashtable();
Hashtable iswriteback_ht = new Hashtable();
RecordSet.executeSql("select * from outerdatawfsetdetail where mainid="+viewid+" order by id");
while(RecordSet.next()){
    String wffieldid = Util.null2String(RecordSet.getString("wffieldid"));
    String outerfieldname = Util.null2String(RecordSet.getString("outerfieldname"));
    String customsql = Util.null2String(RecordSet.getString("customsql"));
    String changetype = Util.null2String(RecordSet.getString("changetype"));
    String iswriteback = Util.null2String(RecordSet.getString("iswriteback"));
    outerfieldname_ht.put(wffieldid,outerfieldname);
    customsql_ht.put(wffieldid,customsql);
    changetype_ht.put(wffieldid,changetype);
    iswriteback_ht.put(wffieldid,iswriteback);
}
String tiptitle0 = SystemEnv.getHtmlLabelName(131179,user.getLanguage());//外部字段数据类型要和流程主字段类型保持关系对应，否则会出现转换错误，最终导致触发流程失败！
String tiptitle1 = SystemEnv.getHtmlLabelName(125539,user.getLanguage());//如果转换规则为自定义sql，此设置查询的是当前系统，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}为固定格式。
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body id="setbody">
<%if("1".equals(isdialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" id="doSubmit" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="adddetail">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="typename" name="typename" value="<%=typename%>">

<input type="hidden" id="fieldscount" name="fieldscount" value="<%=fieldscount%>">
<%if("1".equals(isdialog)){ %>
<input type="hidden" name="isdialog" value="<%=isdialog%>">
<%} %>
<wea:layout>
		<%
		String tempfieldname = "";
		if(!workFlowId.equals("")){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(24087,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
			<wea:item attributes="{'colspan':'2','isTableList':'true'}">
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="20%">
					<col width="20%">
					<tr class=header>
						<td><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%>&nbsp;<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=tiptitle0 %>"><IMG align=absMiddle src="/images/remind_wev8.png"></SPAN></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%>&nbsp;<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=tiptitle1 %>"><IMG align=absMiddle src="/images/remind_wev8.png"></SPAN></td>
						<td><%=SystemEnv.getHtmlLabelName(23135,user.getLanguage())%></td>
					</tr>
					<tr class=DataLight>
						<td>
							<%=SystemEnv.getHtmlLabelName(22244,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%> (<%=requestnamedbtype %>)
							<input type="hidden" id="fieldid_index_1" name="fieldid_index_1" value="-1">
							<input type="hidden" id="fieldname_index_1" name="fieldname_index_1" value="requestname">
							<input type="hidden" id="fieldhtmltype_index_1" name="fieldhtmltype_index_1" value="1">
							<input type="hidden" id="fieldtype_index_1" name="fieldtype_index_1" value="1">
							<input type="hidden" id="fielddbtype_index_1" name="fielddbtype_index_1" value="<%=requestnamedbtype%>">
						</td>
						<%
						temptableoptions = maintableoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get("-1"));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>";
						    temptableoptions = temptableoptions.replace(replaceedStr,replaceStr);
						}
						%>
						<td>
							<select id="outerfieldname_index_1" name="outerfieldname_index_1">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr class=DataDark>
						<td>
							<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%> (<%=createrdbtype %>)
							<input type="hidden" id="fieldid_index_2" name="fieldid_index_2" value="-2">
							<input type="hidden" id="fieldname_index_2" name="fieldname_index_2" value="creater">
							<input type="hidden" id="fieldhtmltype_index_2" name="fieldhtmltype_index_2" value="3">
							<input type="hidden" id="fieldtype_index_2" name="fieldtype_index_2" value="1">
							<input type="hidden" id="fielddbtype_index_2" name="fielddbtype_index_2" value="<%=createrdbtype%>">
						</td>
						<%
						temptableoptions = maintableoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get("-2"));
						temprulesoptvalue = Util.null2String((String)changetype_ht.get("-2"));
						tempcustomsql = Util.null2String((String)customsql_ht.get("-2"));
						
						String hrmname = "";
						String hrmid = "";
						if(temprulesoptvalue.equals("5")&&!temprulesoptvalue.equals("")){//选择了固定的创建人
						   hrmid = tempfieldname;
					     hrmname = ResourceComInfo.getLastname(hrmid);
						}else{
						    if(!tempfieldname.equals("")){
						        String replaceedStr = "<option value='"+tempfieldname+"'>";
						        String replaceStr = "<option value='"+tempfieldname+"' selected>";
						        temptableoptions = temptableoptions.replace(replaceedStr,replaceStr);
						    }
						}
						%>
						<td>
							<div id="outerfieldnamediv" name="outerfieldnamediv" <%if(temprulesoptvalue.equals("5")){%>style="display:none;"<%}else{%>style=""<%}%> >
							<select id="outerfieldname_index_2" name="outerfieldname_index_2">
								<option></option>
								<%=temptableoptions%>
							</select>
							</div>
							<div id="fixhrmresource" name="fixhrmresource" <%if(temprulesoptvalue.equals("5")){%>style="display:block;"<%}else{%>style="display:none;"<%}%> >
								<brow:browser viewType="0"  name="hrmid" browserValue='<%=hrmid%>' 
								  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								  completeUrl="/data.jsp" linkUrl="" width="120px"
								  browserSpanValue='<%=hrmname%>'> needHidden=''
								</brow:browser>
							</div>
						</td>
						<td>
						<!-- /*QC327963 [80][90][建议]流程触发集成-详细设置中流程创建人一开始选择固定创建创建保存后，然后在切换转换规则，外部字段的下拉框长度不能恢复 start*/ -->
							<select id="rulesopt_2" name="rulesopt_2" onchange="changeRules(this.value,2,'<%=temprulesoptvalue%>')">
						<!-- /*QC327963 [80][90][建议]流程触发集成-详细设置中流程创建人一开始选择固定创建创建保存后，然后在切换转换规则，外部字段的下拉框长度不能恢复 end*/ -->
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="5" <%if(temprulesoptvalue.equals("5")){%>selected<%}%> >--<%=SystemEnv.getHtmlLabelName(23155,user.getLanguage())%>--</option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<textarea <%if(!temprulesoptvalue.equals("6")){%>style="display:none;"<%}%> id="customsql_2" name="customsql_2" cols=25 rows=4 onchange="checkLengthfortext('customsql_2','1000','<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"><%=tempcustomsql%></textarea>
						</td>
						<td></td>
					</tr>
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
					        while(RecordSet.next()){
					            fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
					            fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
					        }
					    }else if(isbill.equals("1")){//单据
					        RecordSet.executeSql("select * from workflow_billfield where viewtype=0 and billid="+formID);
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
					<%if(i%2==1){%><tr class=DataDark><%}%>
					<%if(i%2==0){%><tr class=DataLight><%}%>
						<td>
							<%=fieldlable%> (<%=fielddbtype %>)
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=fieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=fieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=fieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=fieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=fielddbtype%>">
						</td>
						<%
						temptableoptions = maintableoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get(fieldid));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>";
						    temptableoptions = temptableoptions.replace(replaceedStr,replaceStr);
						}
						%>
						<td>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td>
							<%
							if(fieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(fieldid));
							    tempcustomsql = Util.null2String((String)customsql_ht.get(fieldid));
							    if(fieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>    
							<%  }else if(fieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<%  }else if(fieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<%  }
							%>
							<textarea <%if(!temprulesoptvalue.equals("6")){%>style="display:none;"<%}%> id="customsql_<%=fieldscount%>" name="customsql_<%=fieldscount%>" cols=25 rows=4 onchange="checkLengthfortext('customsql_<%=fieldscount%>','1000','<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"><%=tempcustomsql%></textarea>
							<%}%>
							
						</td>
						<%
						tempiswriteback = Util.null2String((String)iswriteback_ht.get(fieldid));
						if(recordAndNotView){
						%>
						<td>
							<input type="checkbox" id="iswriteback_<%=fieldscount%>" name="iswriteback_<%=fieldscount%>" value="<%=tempiswriteback%>" onclick="if(this.checked){this.value=1;}else{this.value=0;}" <%if(tempiswriteback.equals("1")){%>checked<%}%> >
						</td>
						<%} %>
					</tr>  
					<%}%>
				</table>
			</wea:item>
		</wea:group>
		<%
		int detailindex = 0;
		String detailsSQL = "";
		if(isbill.equals("0")){//表单明细
		    detailindex = 0;
		    detailsSQL = "select distinct groupId from Workflow_formfield where formid="+formID+" and isdetail='1' order by groupid";
				RecordSet.executeSql(detailsSQL);
				
	  		while(RecordSet.next()){
	  		    String outdetailtable = (String)outerdetailtablesArr.get(detailindex);//流程明细对应外部数据表
	      		detailindex++;
	         	String tempGroupId = RecordSet.getString(1);
	          String fieldsSearchSql = "select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid,t3.fieldname,t3.fielddbtype,t3.fieldhtmltype,t3.type from workflow_fieldlable t1,workflow_formfield t2,workflow_formdictdetail t3 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and t2.isdetail='1' and t2.groupId="+tempGroupId+" and t2.formid="+formID+"  and t1.langurageid="+user.getLanguage()+" and t3.id=t2.fieldid order by t2.fieldorder";
	          String outerdetailoptions = "";
			  Map dtallcolnums = rs2.getAllColumnWithTypes(datasourceid,outdetailtable);
	          ArrayList outdetailtablecolsList = AutomaticCols.getAllColumns(datasourceid,outdetailtable);
	          for(int j=0;j<outdetailtablecolsList.size();j++){
	              String detailcolname = outdetailtable+"."+(String)outdetailtablecolsList.get(j);
	              outerdetailoptions += "<option value='"+detailcolname+"'>"+detailcolname+" ("+dtallcolnums.get((String)outdetailtablecolsList.get(j).toString().toLowerCase())+")</option>";
	          }
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())+SystemEnv.getHtmlLabelName(24087,user.getLanguage())%>' attributes="{'samePair':'DetailInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="40%">
					<tr class=header>
						<td><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=detailindex%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></td>
					</tr>
					<%
					int colorindex = 0;
					rs1.executeSql(fieldsSearchSql);
				  while(rs1.next()){//表单明细字段
				      fieldscount++;
				      String detailfieldid = Util.null2String(rs1.getString("fieldid"));//字段id
				      String detailfieldname = Util.null2String(rs1.getString("fieldname"));//字段名称
				      String detailfieldhtmltype = Util.null2String(rs1.getString("fieldhtmltype"));//字段html类型
				      String detailfieldtype = Util.null2String(rs1.getString("type"));//字段类型
				      String detailfielddbtype = Util.null2String(rs1.getString("fielddbtype"));//字段数据库类型
				      String detailfieldlable = Util.null2String(rs1.getString("fieldlable"));//字段显示名
					%>
					<%if(colorindex==1){
					    colorindex = 0;
					%>
					<tr class=DataDark>
					<%}else{
					    colorindex = 1;
					 %>
					<tr class=DataLight>
					<%}%>
						<td>
							<%=detailfieldlable%> (<%=detailfielddbtype %>)
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=detailfieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=detailfieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=detailfieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=detailfieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=detailfielddbtype%>">
						</td>
						<%
						temptableoptions = outerdetailoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get(detailfieldid));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>";
						    temptableoptions = temptableoptions.replace(replaceedStr,replaceStr);
						}
						%>
						<td>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td>
							<%
							if(detailfieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(detailfieldid));
							    tempcustomsql = Util.null2String((String)customsql_ht.get(detailfieldid));
							    if(detailfieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>    
							<%  }else if(detailfieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<%  }else if(detailfieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<%  }
							%>
							<textarea <%if(!temprulesoptvalue.equals("6")){%>style="display:none;"<%}%> id="customsql_<%=fieldscount%>" name="customsql_<%=fieldscount%>" cols=25 rows=4 onchange="checkLengthfortext('customsql_<%=fieldscount%>','1000','<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"><%=tempcustomsql%></textarea>
							<%}%>
						</td>
					</tr>
					<%}%>
				</table>
			</wea:item>
			</wea:group>
		<%}
		}else if(isbill.equals("1")){//单据明细
		    detailindex = 0;
		    detailsSQL = "select tablename from Workflow_billdetailtable where billid="+formID+" order by orderid";
		    boolean isonlyone = false;
		    RecordSet.executeSql(detailsSQL);
		    if(RecordSet.getCounts()==0){
		        //没有记录不代表没有明细,单据对应的明细表可能没有写进Workflow_billdetailtable中
		        //但此时可以确定该单据即使有明细，也只有一个明细。
		        isonlyone = true;
		        detailsSQL = "select distinct viewtype from workflow_billfield where viewtype=1 and billid="+formID;
		    }
		    RecordSet.executeSql(detailsSQL);
		    while(RecordSet.next()){//单据明细字段
		        String outdetailtable = "";//流程明细对应外部数据表
		        if(outerdetailtablesArr.size()>detailindex) outdetailtable = (String)outerdetailtablesArr.get(detailindex);
		        detailindex++;
		        String outerdetailoptions = "";
				Map dtallcolnums = rs2.getAllColumnWithTypes(datasourceid,outdetailtable);
	          ArrayList outdetailtablecolsList = AutomaticCols.getAllColumns(datasourceid,outdetailtable);
	          for(int j=0;j<outdetailtablecolsList.size();j++){
	              String detailcolname = outdetailtable+"."+(String)outdetailtablecolsList.get(j);
	              outerdetailoptions += "<option value='"+detailcolname+"'>"+detailcolname+" ("+dtallcolnums.get((String)outdetailtablecolsList.get(j).toString().toLowerCase())+")</option>";
	          }
		        String fieldsSearchSql = "select * from workflow_billfield where viewtype=1 and billid="+formID+" order by dsporder";
		        if(isonlyone)
		            fieldsSearchSql = "select * from workflow_billfield where viewtype=1 and billid="+formID+" order by dsporder";
		        else
		            fieldsSearchSql = "select * from workflow_billfield where detailtable='"+RecordSet.getString("tablename")+"' and viewtype=1 and billid="+formID+" order by dsporder";
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())+SystemEnv.getHtmlLabelName(24087,user.getLanguage())%>' attributes="{'samePair':'DetailInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="40%">
					<tr class=header>
						<td><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=detailindex%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></td>
					</tr>
					<%
					int colorindex = 0;
					rs1.executeSql(fieldsSearchSql);
				  while(rs1.next()){
				      fieldscount++;
				      String detailfieldid = Util.null2String(rs1.getString("id"));
				      String detailfieldname = Util.null2String(rs1.getString("fieldname"));
				      String detailfieldhtmltype = Util.null2String(rs1.getString("fieldhtmltype"));
				      String detailfieldtype = Util.null2String(rs1.getString("type"));
				      String detailfielddbtype = Util.null2String(rs1.getString("fielddbtype"));
				      String detailfieldlable = Util.null2String(rs1.getString("fieldlabel"));
				      detailfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(detailfieldlable),user.getLanguage());
					%>
					<%if(colorindex==0){
					    colorindex = 1;
					%>
					<tr class=DataDark>
					<%}else{
					    colorindex = 0;
					 %>
					<tr class=DataLight>
					<%}%>
						<td>
							<%=detailfieldlable%> (<%=detailfielddbtype %>)
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=detailfieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=detailfieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=detailfieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=detailfieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=detailfielddbtype%>">
						</td>
						<%
						temptableoptions = outerdetailoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get(detailfieldid));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>";
						    temptableoptions = temptableoptions.replace(replaceedStr,replaceStr);
						}
						%>
						<td>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td>
							<%
							if(detailfieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(detailfieldid));
							    tempcustomsql = Util.null2String((String)customsql_ht.get(detailfieldid));
							    if(detailfieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>    
							<%  }else if(detailfieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<%  }else if(detailfieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>" onchange="changeRules(this.value,<%=fieldscount%>)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
								<option value="6" <%if(temprulesoptvalue.equals("6")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql</option>
							</select>
							<%  }
							%>
							<textarea <%if(!temprulesoptvalue.equals("6")){%>style="display:none;"<%}%> id="customsql_<%=fieldscount%>" name="customsql_<%=fieldscount%>" cols=25 rows=4 onchange="checkLengthfortext('customsql_<%=fieldscount %>','1000','<%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%>sql','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"><%=tempcustomsql%></textarea>
							<%}%>
						</td>
					</tr>
					<%}%>
				</table>
			</wea:item>
			</wea:group>
		<%}
		}%>
		<%}%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'2'}">
			<font>
				1:<%=SystemEnv.getHtmlLabelName(23127,user.getLanguage())%><br>
				2:<%=SystemEnv.getHtmlLabelName(23126,user.getLanguage())%><br>
				&nbsp;&nbsp;&nbsp;[<%=SystemEnv.getHtmlLabelName(23157,user.getLanguage())%>]<br>
				3:<%=SystemEnv.getHtmlLabelName(23123,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23125,user.getLanguage())%>				
			</font>
		</wea:item>
	</wea:group>
  </wea:layout>
</form>
<%if("1".equals(isdialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onClose();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</body>
</html>
<script language="javascript">
window.onbeforeunload = function protectManageBillFlow(event){
  	if(!checkDataChange())//added by cyril on 2008-06-10 for TD:8828
        return "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
}
function doSubmit(){
    document.getElementById("fieldscount").value = "<%=fieldscount%>";
    jQuery($GetEle("setbody")).attr("onbeforeunload", "");
    document.frmmain.submit();
}
/*QC327963 [80][90][建议]流程触发集成-详细设置中流程创建人一开始选择固定创建创建保存后，然后在切换转换规则，外部字段的下拉框长度不能恢复 start*/
function changeRules(rulevalue,order,temprulesoptvalue){
/*QC327963 [80][90][建议]流程触发集成-详细设置中流程创建人一开始选择固定创建创建保存后，然后在切换转换规则，外部字段的下拉框长度不能恢复 end*/
    if(rulevalue==5){
    	if(order==2)
    	{
	        document.getElementById("outerfieldnamediv").style.display = "none";
	        document.getElementById("fixhrmresource").style.display = "";
        }
        document.getElementById("customsql_"+order).style.display = "none";
    }
    else if(rulevalue==6){
    	if(order==2)
    	{
	        document.getElementById("outerfieldnamediv").style.display = "";
	        document.getElementById("fixhrmresource").style.display = "none";
        }
        document.getElementById("customsql_"+order).style.display = "";
    }
    else{
    	if(order==2)
    	{
	        document.getElementById("outerfieldnamediv").style.display = "";
	        document.getElementById("fixhrmresource").style.display = "none";
        }
        document.getElementById("customsql_"+order).style.display = "none";
    }
     /*QC327963 [80][90][建议]流程触发集成-详细设置中流程创建人一开始选择固定创建创建保存后，然后在切换转换规则，外部字段的下拉框长度不能恢复 start*/
    if(temprulesoptvalue == 5){
       $("#outerfieldnamediv span div").css("width",$(".sbHolder ").css("width"));
       $(".sbOptions").css("width",$(".sbOptions").css("width"));
       $(".sbSelector").css("width",$(".sbSelector").css("width"));
    }
    /*QC327963 [80][90][建议]流程触发集成-详细设置中流程创建人一开始选择固定创建创建保存后，然后在切换转换规则，外部字段的下拉框长度不能恢复 end*/
}
function onShowHrmResource(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var strs="<a href=javaScript:openhrm("+datas.id+"); onclick='pointerXY(event);'>"+datas.name+"</a>&nbsp";
            
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id);
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
		}
	}
}
function onBackUrl(url)
{
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	document.location.href=url;
}
jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
});
function onClose()
{
	parentWin.closeDialog();
}
</script>
<script language="vbs">
Sub onShowWorkFlowSerach(inputname, spanname)
    retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
    temp=document.all(inputname).value
    If (Not IsEmpty(retValue)) Then
        If retValue(0) <> "0" Then
            document.all(spanname).innerHtml = retValue(1)
            document.all(inputname).value = retValue(0)
        end if
    Else 
        document.all(inputname).value = ""
        document.all(spanname).innerHtml = ""			
    End If
    document.frmmain.action="automaticsettingAdd.jsp"
    document.frmmain.submit()
End Sub
</script>
<script language=javascript src="/js/checkData_wev8.js"></script>
