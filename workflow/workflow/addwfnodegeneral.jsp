<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="stateProcSetManager" class="weaver.hrm.pm.manager.HrmStateProcSetManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page" />
<%WFNodeDtlFieldManager.resetParameter();%>
<html>
<%
	int init_nodeid=Util.getIntValue(request.getParameter("nodeid"),-1);
	int choosemodeid=Util.getIntValue(request.getParameter("choosemodeid"),-1);
	int nodeid;
	if(choosemodeid!=-1){
		RecordSet.executeSql(" select nodeid from wfnodegeneralmode where id="+choosemodeid);
        RecordSet.first();
        nodeid=RecordSet.getInt("nodeid");
	}else{
		nodeid=init_nodeid;
	}
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	int formid = Util.getIntValue(request.getParameter("formid"),-1);
	String modetype = Util.null2String(request.getParameter("modetype"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String isnew = Util.null2String(request.getParameter("isnew"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String modeid="";
	String modename = Util.null2String(request.getParameter("modename"));
	boolean isStateForm = stateProcSetManager.isHrmStateForm(formid);
	if(isclose.equals("1")){
		RecordSet.executeSql(" select id,modename from wfnodegeneralmode where formid="+formid+" and nodeid="+nodeid+" and isbill="+isbill+" and wfid="+wfid);
		RecordSet.first();
		modeid= Util.null2String(RecordSet.getString("id"));
		modename = Util.null2String(RecordSet.getString("modename"));
	}
%>
<script type="text/javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

$(document).ready(function(){
  	 resizeDialog(document);
});

var isclose = "<%=isclose%>";
if(isclose === "1"){
	$(parentWin.modenamelink).html("<%=modename%>");
	$("#genmode_isnew",parentWin.document).val("n");
	$("[name='ischoose']",parentWin.document).val("s");
	$("[name='choosemodeid']",parentWin.document).val("<%=modeid %>");
	closeWin();
}

function closeWin(){
	dialog.close();
}

jQuery(document).ready(function(){
	jQuery("div.e8normaltd").closest(".tableField").closest("tr").addClass("intervalTR")
});

</script>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<style type="text/css">
	.tableField table.LayoutTable tbody td{
		padding:0;
	}
</style>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveAsVersion(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closeWin(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=modename %>"/>
</jsp:include>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	        <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="saveAsVersion()" class="e8_btn_top" id="btnok">				
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<form id="nodefieldform" name="nodefieldform" method=post action="wf_operation.jsp" >
<input type="hidden" name="wfid" value="<%=wfid %>" >
<input type="hidden" name="nodeid" value="<%=nodeid %>" >
<input type="hidden" name="formid" value="<%=formid %>" >
<input type="hidden" name="modetype" value="<%=modetype %>" >
<input type="hidden" name="isbill" value="<%=isbill %>" >
<input type="hidden" name="isnew" value="<%=isnew %>" >
<input type="hidden" name="src" value="saveGeneralField" >
<wea:layout type="2col">
<%--
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%= SystemEnv.getHtmlLabelName(28050,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="modename" value=<%=modename %> disabled>
		</wea:item>
	</wea:group>
--%>
	<wea:group context="" attributes="{groupOperDisplay:none,groupDisplay:none}">
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout type="table" attributes="{'cols':'4','cws':'25%'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage()) %>'>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item><%-- 字段名称 --%>
					<wea:item type="thead">
						<input type="checkbox" name="title_viewall"  onClick="titleviewAll(this)" >
						<%-- 是否显示 --%>
						<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>
					</wea:item>
					<wea:item type="thead">
						<input type="checkbox" name="title_editall"  onClick="titleeditAll(this)" <%if("3".equals(nodetype)){ %>disabled<%} %> />
						<%-- 是否可编辑  --%>
						<%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%>
					</wea:item>
					<wea:item type="thead">
						<input type="checkbox" name="title_manall"  onClick="titlemanAll(this)" <%if("3".equals(nodetype)){ %>disabled<%} %>  />
						<%-- 是否必须输入 --%>
						<%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%>
					</wea:item>
					<%
						if(nodeid != -1){
						//****************************************************
						//***************  "标题"字段显示    start  *************
						//****************************************************
							boolean isCreateNode = false;
							if(nodetype.equals("0")){
								isCreateNode = true;
							}
							String view="";
							String edit="";
							String man="";
							WFNodeFieldMainManager.resetParameter();
							WFNodeFieldMainManager.setNodeid(nodeid);
							//"说明"字段在workflow_nodeform中的fieldid 定为 "-1"
							WFNodeFieldMainManager.setFieldid(-1);
							WFNodeFieldMainManager.selectWfNodeField();
							if(!isnew.equals("y")){
								if(WFNodeFieldMainManager.getIsview().equals("1"))   	view=" checked";
								if(WFNodeFieldMainManager.getIsedit().equals("1"))   	edit=" checked";
								if(WFNodeFieldMainManager.getIsmandatory().equals("1"))  man=" checked";
							}
					%>
					<wea:item><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></wea:item>
					<wea:item><input type="checkbox" name="title_view" <%=view%> onClick="titlebox(this)" checked disabled ></wea:item>
					<wea:item><input type="checkbox" name="title_edit" <%=edit%> onClick="titlebox_edit_special(this)" <%if(isCreateNode){%>disabled checked<%}else if(nodetype.equals("3")){%>disabled<%}%> ></wea:item>
					<wea:item><input type="checkbox" name="title_man" <%=man%> onClick="titlebox(this)" disabled  <%if(isCreateNode){%> checked <%}else if(nodetype.equals("3")){%><%}else{%> <%= "".equals(edit)?"":"checked" %><%}%> ></wea:item>
					<%
							WFNodeFieldMainManager.closeStatement();
							//****************************************************
							//***************  "标题"字段显示    end  ***************
							//****************************************************


							//****************************************************
							//*************  "紧急程度"字段显示    start  ***********
							//****************************************************
							isCreateNode = false;
							if(nodetype.equals("0")){
								isCreateNode = true;
							}
							view="";
							edit="";
							man="";
							WFNodeFieldMainManager.resetParameter();
							WFNodeFieldMainManager.setNodeid(nodeid);
							//"紧急程度"字段在workflow_nodeform中的fieldid 定为 "-2"
							WFNodeFieldMainManager.setFieldid(-2);
							WFNodeFieldMainManager.selectWfNodeField();
							if(!isnew.equals("y"))
							{
								if(WFNodeFieldMainManager.getIsview().equals("1"))		  view=" checked";
								if(WFNodeFieldMainManager.getIsedit().equals("1"))		  edit=" checked";
								if(WFNodeFieldMainManager.getIsmandatory().equals("1"))		man=" checked";
							}
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
						<wea:item><input type="checkbox" name="level_view" <%=view%> onClick="titlebox(this)" disabled checked></wea:item>
						<wea:item><input type="checkbox" name="level_edit" <%=edit%> onClick="titlebox_edit_special(this)" <%if(isCreateNode){%>disabled checked<%}else if(nodetype.equals("3")){%>disabled<%}%>  ></wea:item>
						<wea:item><input type="checkbox"  name="level_man" <%=man%> onClick="titlebox(this)" <%if(isCreateNode){%>disabled checked<%}else if(nodetype.equals("3")){%>disabled<%}else{%>disabled  <%= "".equals(edit)?"":"checked" %><%}%>></wea:item>
						
					<%
							WFNodeFieldMainManager.closeStatement();
						//****************************************************
						//*************  "紧急程度"字段显示    end  *************
						//****************************************************
						}

						//****************************************************
						//*************  "短信提醒"字段显示    start  ***********
						//****************************************************
						String messageType = WFManager.getMessageType();
						if(nodeid!=-1&&messageType.equals("1")){
							boolean isCreateNode = false;
							if(nodetype.equals("0")){
								isCreateNode = true;
							}
							String view="";
							String edit="";
							String man="";
							WFNodeFieldMainManager.resetParameter();
							WFNodeFieldMainManager.setNodeid(nodeid);
							//"是否短信提醒"字段在workflow_nodeform中的fieldid 定为 "-3"
							WFNodeFieldMainManager.setFieldid(-3);
							WFNodeFieldMainManager.selectWfNodeField();
							if(!isnew.equals("y"))
							{
								if(WFNodeFieldMainManager.getIsview().equals("1"))		  view=" checked";
								if(WFNodeFieldMainManager.getIsedit().equals("1"))		  edit=" checked";
								if(WFNodeFieldMainManager.getIsmandatory().equals("1"))		  man=" checked";
							}
					%>
						<wea:item><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></wea:item>
						<wea:item><input type="checkbox" name="ismessage_view" <%=view%> onClick="titlebox(this)" disabled ></wea:item>
						<wea:item><input type="checkbox" name="ismessage_edit" <%=edit%> onClick="titlebox(this)" <%if(isCreateNode||nodetype.equals("3")){%>disabled<%}%> ></wea:item>
						<wea:item><input type="checkbox" name="ismessage_man" <%=man%> onClick="titlebox(this)" disabled></wea:item>				 
					<%
								
							WFNodeFieldMainManager.closeStatement();
						}
							//****************************************************
							//*************  "短信提醒"字段显示    end  *************
							//****************************************************

						//****************************************************
						//*************  "微信提醒"字段显示    start  ***********
						//****************************************************
						String chatsType = WFManager.getChatsType();
						if(nodeid!=-1&&chatsType.equals("1")){
							boolean isCreateNode = false;
							if(nodetype.equals("0")){
								isCreateNode = true;
							} 
							String edit="";
							String man="";
							WFNodeFieldMainManager.resetParameter();
							WFNodeFieldMainManager.setNodeid(nodeid);
							//"是否微信提醒"字段在workflow_nodeform中的fieldid 定为 "-5"
							WFNodeFieldMainManager.setFieldid(-5);
							WFNodeFieldMainManager.selectWfNodeField(); 
							if(WFNodeFieldMainManager.getIsedit().equals("1"))		  edit=" checked";
							if(WFNodeFieldMainManager.getIsmandatory().equals("1"))		  man=" checked";
						%>
								<wea:item><%=SystemEnv.getHtmlLabelName(32812,user.getLanguage())%></wea:item>
								<wea:item><input type="checkbox" name="ischats_view" checked onClick="if(this.checked==false){document.nodefieldform.ischats_edit.checked=false;document.nodefieldform.ischats_man.checked=false;}"  disabled ></wea:item>
								<wea:item><input type="checkbox" name="ischats_edit" <%=edit%> onClick="if(this.checked==true){document.nodefieldform.ischats_view.checked=(this.checked==true?true:false);}else{document.nodefieldform.ischats_man.checked=false;}" <%if(nodetype.equals("3")){%>disabled<%}%> ></wea:item>
								<wea:item><input type="checkbox" name="ischats_man" <%=man%> onClick="if(this.checked==true){document.nodefieldform.ischats_view.checked=(this.checked==true?true:false);document.nodefieldform.ischats_edit.checked=(this.checked==true?true:false);}" disabled></wea:item>

						<%
							WFNodeFieldMainManager.closeStatement();
						}
						//****************************************************
						//*************  "微信提醒"字段显示    end  *************
						//****************************************************
					%>
							
					<%
						if(nodeid!=-1 && isbill.equals("0")){
							FormFieldMainManager.setFormid(formid);
							FormFieldMainManager.setNodeid(nodeid);
							FormFieldMainManager.selectFormFieldLable();
							int groupid=-1;
							String dtldisabled="";
							while(FormFieldMainManager.next()){
								int curid=FormFieldMainManager.getFieldid();
								String fieldname=FieldComInfo.getFieldname(""+curid);
								//if (fieldname.equals("manager")) continue;//字段为“manager”这个字段是程序后台所用，不必做必填之类的设置!
								String fieldhtmltype = FieldComInfo.getFieldhtmltype(""+curid);
								String curlable = FormFieldMainManager.getFieldLable();
								int curgroupid=FormFieldMainManager.getGroupid();
								//表单头group值为－1，会引起拼装checkbox语句的脚本错误，这里简单的处理为999
								if(curgroupid==-1) curgroupid=999;
								String isdetail = FormFieldMainManager.getIsdetail();
								WFNodeFieldMainManager.resetParameter();
								WFNodeFieldMainManager.setNodeid(nodeid);
								WFNodeFieldMainManager.setFieldid(curid);
								WFNodeFieldMainManager.selectWfNodeField();
								String view="";
								String edit="";
								String man="";
								if(isdetail.equals("1") && curgroupid>groupid) {
									groupid=curgroupid;
							
									WFNodeDtlFieldManager.setNodeid(nodeid);
									WFNodeDtlFieldManager.setGroupid(curgroupid);
									WFNodeDtlFieldManager.selectWfNodeDtlField();
									String dtladd = WFNodeDtlFieldManager.getIsadd();
										if(!isnew.equals("y")) if(dtladd.equals("1")) dtladd=" checked";
									String dtledit = WFNodeDtlFieldManager.getIsedit();
										if(!isnew.equals("y")) if(dtledit.equals("1")) dtledit=" checked";
									String dtldelete = WFNodeDtlFieldManager.getIsdelete();
										if(!isnew.equals("y")) if(dtldelete.equals("1")) dtldelete=" checked";
									String dtlhide = WFNodeDtlFieldManager.getIshide();
										if(!isnew.equals("y")) if(dtlhide.equals("1")) dtlhide=" checked";
									String dtldefault = WFNodeDtlFieldManager.getIsdefault();
										if(!isnew.equals("y")) if(dtldefault.equals("1")) dtldefault=" checked";
							        String dtlneed = WFNodeDtlFieldManager.getIsneed();
							        	if(!isnew.equals("y")) if(dtlneed.equals("1")) dtlneed=" checked";
									if(!dtladd.equals(" checked") && !dtledit.equals(" checked")) 
										dtldisabled="disabled";
									int defaultrow = WFNodeDtlFieldManager.getDefaultrows();
										if(!isnew.equals("y")){ if(defaultrow<1)defaultrow=1; }else defaultrow=1;
									String isopensapmul=WFNodeDtlFieldManager.getIsopensapmul();//zzl
										if(isnew.equals("y") && isopensapmul.equals("1")){
												isopensapmul=" checked";
										}
										if(!isopensapmul.equals("1")) 
											dtldisabled="";
										if(isnew.equals("y"))dtldisabled = "disabled";	
									
						%>
							<wea:item attributes="{'isTableList':'true','colspan':'4'}">
								<wea:layout type="2col">
									<wea:group context='<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(groupid+1)%>'>
										<wea:item type="groupHead"><div class="e8normaltd"></div></wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(19394,user.getLanguage())%></wea:item>
										<wea:item><input type="checkbox" name="dtl_add_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtladd%><%}%>></wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(19395,user.getLanguage())%></wea:item>
										<wea:item><input type="checkbox" name="dtl_edit_<%=groupid%>" onClick="checkChange('<%=String.valueOf(groupid)%>')" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtledit%><%}%>></wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(19396,user.getLanguage())%></wea:item>
										<wea:item><input type="checkbox" name="dtl_del_<%=groupid%>" onClick="" <%if(nodetype.equals("3")){%>disabled<%}else{%> <%=dtldelete%><%}%>></wea:item>
										<%
							            if(!nodetype.equals("3"))
							            {
							            %>
										<wea:item><%=SystemEnv.getHtmlLabelName(24801,user.getLanguage())%></wea:item>
						                <wea:item>
							                 <input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_ned" name="dtl_ned_<%=groupid%>" onClick="" <%=dtlneed%>>
						                </wea:item>
										<wea:item><%=SystemEnv.getHtmlLabelName(24796,user.getLanguage())%></wea:item>
						                <wea:item>
							                 <input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_def"  name="dtl_def_<%=groupid%>" onClick="" <%=dtldefault%>>
							                 <input type="text" <%=dtladd.equals(" checked")?"":"disabled" %> name="dtl_defrow<%=groupid%>" onkeypress="ItemCount_KeyPress()" onchange="checkcount2(this);" value="<%=defaultrow%>" style="width:30px;" >
						                </wea:item>
						                <wea:item><%=SystemEnv.getHtmlLabelName(31592,user.getLanguage())%></wea:item>
						                <wea:item>
							                 <input type="checkbox" <%=dtladd.equals(" checked")?"":"disabled" %> id="dt_mul"  name="dtl_mul_<%=groupid%>" onClick="" <%=isopensapmul%>>
						                </wea:item>
										<%
							            }
							            %>
							            <wea:item><%=SystemEnv.getHtmlLabelName(22363,user.getLanguage())%></wea:item>
										<wea:item><input type="checkbox" name="hide_del_<%=groupid%>" onClick="" <%=dtlhide%>></wea:item>
									</wea:group>
								</wea:layout>
							</wea:item>
							<wea:item attributes="{isTableList:'true',colspan:4}">
								<wea:layout type="table" attributes="{cols:4,cws:25%}">
									<wea:group context="" attributes="{groupOperDisplay:none,groupDisplay:none}">
										<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
										<wea:item type="thead">
											<input type="checkbox" name="title_viewall<%=groupid%>"  onClick="nodeCkAll(this,'<%=groupid%>')" >
											<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>
										</wea:item>
										<wea:item type="thead">
											<input type="checkbox" name="title_editall<%=groupid%>"  onClick="nodeCkAll(this,'<%=groupid%>')" <%=dtldisabled%>>
											<%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%>
										</wea:item>
										<wea:item type="thead">
											<input type="checkbox" name="title_manall<%=groupid%>"  onClick="nodeCkAll(this,'<%=groupid%>')" <%=dtldisabled%>>
											<%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%>
										</wea:item>
									</wea:group>
								</wea:layout>
							</wea:item>
							<%
							}	
								if(!isnew.equals("y"))
								{
									if(WFNodeFieldMainManager.getIsview().equals("1"))
										view=" checked";
									if(WFNodeFieldMainManager.getIsedit().equals("1"))
										edit=" checked";
									if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
										man=" checked";
								}
							%>
							<wea:item><%=Util.toScreen(curlable,user.getLanguage())%><input type="hidden" name="isdetail<%=curgroupid%>" value='<%=isdetail.equals("")?"0":isdetail %>'/></wea:item>
							<wea:item><input type="checkbox" name="node<%=curid%>_view_g<%=curgroupid%>" <%=view%> onClick="titlebox(this)"></wea:item>
							<wea:item><input type="checkbox" name="node<%=curid%>_edit_g<%=curgroupid%>" <%=edit%> <%=dtldisabled%> onClick="titlebox(this)" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7") ){%>disabled<%}%>></wea:item>
							<wea:item><input type="checkbox" name="node<%=curid%>_man_g<%=curgroupid%>"  <%=man%>  <%=dtldisabled%> onClick="titlebox(this)" <%if(nodetype.equals("3") || fieldname.equals("manager") || fieldhtmltype.equals("7") || fieldhtmltype.equals("9")){%>disabled<%}%>></wea:item>
						<% 
							}
							FormFieldMainManager.closeStatement();
						}else if(nodeid!=-1 && isbill.equals("1")){
							boolean isNewForm = false;//是否是新表单 modify by myq for TD8730 on 2008.9.12
							//数据中心表（新表单对应表）
							String tmpDataCenterTableName = "";
							RecordSet.executeSql("select  inpreptablename  from T_InputReport where billid = "+formid);
							if(RecordSet.next()) tmpDataCenterTableName = Util.null2String(RecordSet.getString("inpreptablename"));

							RecordSet.executeSql("select tablename from workflow_bill where id = "+formid);
							if(RecordSet.next()){
								String temptablename = Util.null2String(RecordSet.getString("tablename"));
								if(temptablename.equals("formtable_main_"+formid*(-1)) || temptablename.startsWith("uf_")) isNewForm = true;
								if(temptablename.equals(tmpDataCenterTableName+ "_main")) isNewForm = true;
							}

							boolean iscptbill = false;
							if(isbill.equals("1")&&(formid==7||formid==14||formid==15||formid==18||formid==19||formid==201||formid==85))
								iscptbill = true;

							String sql = "";
							if(isNewForm == true){
								if("ORACLE".equalsIgnoreCase(RecordSet.getDBType())){
									sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,TO_NUMBER((select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
								}else{
									sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,convert(int, (select orderid from Workflow_billdetailtable bd where bd.billid = billid and bd.tablename = detailtable)),dsporder ";
								}
							}else{
								sql = "select * from workflow_billfield where billid = "+formid +" order by viewtype,detailtable,dsporder ";
							}
							RecordSet.executeSql(sql);
							String predetailtable=null;
							int groupid=0;
							String dtldisabled="";
							while(RecordSet.next()){
								String fieldhtmltype = RecordSet.getString("fieldhtmltype");
								String fieldname = RecordSet.getString("fieldname");
								int curid=RecordSet.getInt("id");
								int curlabel = RecordSet.getInt("fieldlabel");
								int viewtype = RecordSet.getInt("viewtype");
								String detailtable = Util.null2String(RecordSet.getString("detailtable"));

								WFNodeFieldMainManager.resetParameter();
								WFNodeFieldMainManager.setNodeid(nodeid);
								WFNodeFieldMainManager.setFieldid(curid);
								WFNodeFieldMainManager.selectWfNodeField();
								String view="";
								String edit="";
								String man="";
								if(viewtype==1 && !detailtable.equals(predetailtable)){
									groupid++;
									WFNodeDtlFieldManager.setNodeid(nodeid);
									WFNodeDtlFieldManager.setGroupid(groupid-1);
									WFNodeDtlFieldManager.selectWfNodeDtlField();
									String dtladd = WFNodeDtlFieldManager.getIsadd();
										if(!isnew.equals("y")) if(dtladd.equals("1")) dtladd=" checked";
									String dtledit = WFNodeDtlFieldManager.getIsedit();
										if(!isnew.equals("y")) if(dtledit.equals("1")) dtledit=" checked";
									String dtldelete = WFNodeDtlFieldManager.getIsdelete();
										if(!isnew.equals("y")) if(dtldelete.equals("1")) dtldelete=" checked";
									String dtldefault = WFNodeDtlFieldManager.getIsdefault();
										if(!isnew.equals("y")) if(dtldefault.equals("1")) dtldefault=" checked";
									String dtlhide = WFNodeDtlFieldManager.getIshide();
										if(!isnew.equals("y")) if(dtlhide.equals("1")) dtlhide=" checked";
									String dtlneed = WFNodeDtlFieldManager.getIsneed();
										if(!isnew.equals("y")) if(dtlneed.equals("1")) dtlneed=" checked";
							        int defaultrow = WFNodeDtlFieldManager.getDefaultrows();
							        	if(!isnew.equals("y")) {if(defaultrow<1)defaultrow=1; }else defaultrow=1;
						          	String isopensapmul=WFNodeDtlFieldManager.getIsopensapmul();//zzl
						          		if(!isnew.equals("y")) if(isopensapmul.equals("1")) isopensapmul=" checked";
									predetailtable=detailtable;
									if((formid==7||formid==156 || formid==157 || formid==158 || formid==159 || isNewForm || iscptbill) && !dtladd.equals(" checked") && !dtledit.equals(" checked"))
										dtldisabled="disabled";
									else
										dtldisabled="";
									if(isnew.equals("y"))dtldisabled="disabled";
									%>
										<wea:item attributes="{'isTableList':'true','colspan':'4'}">
									
									 <jsp:include page="wfnodegeneral_inner.jsp">
											<jsp:param value="<%=isNewForm %>" name="isNewForm"/>
											<jsp:param value="<%=iscptbill %>" name="iscptbill"/>
											<jsp:param value="<%=isopensapmul %>" name="isopensapmul"/>
											<jsp:param value="<%=dtldefault %>" name="dtldefault"/>
											<jsp:param value="<%=dtlneed %>" name="dtlneed"/>
											<jsp:param value="<%=dtladd %>" name="dtladd"/>
											<jsp:param value="<%=dtlhide %>" name="dtlhide"/>
											<jsp:param value="<%=defaultrow %>" name="defaultrow"/>
											<jsp:param value="<%=dtledit %>" name="dtledit"/>
											<jsp:param value="<%=dtldelete %>" name="dtldelete"/>
											<jsp:param value="<%=nodetype %>" name="nodetype"/>
											<jsp:param value="<%=groupid %>" name="groupid"/>
											<jsp:param value="<%=formid %>" name="formid"/>
											<jsp:param value="<%=dtldisabled %>" name="dtldisabled"/>

										</jsp:include>
										</wea:item>
								<wea:item attributes="{'isTableList':'true','colspan':'4'}">
										<wea:layout type="table" attributes="{'cols':'4','cws':'25%'}">
											<wea:group context="" attributes="{groupOperDisplay:none,groupDisplay:none}">
												<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
												<wea:item type="thead">
													<input type="checkbox" name="title_viewall<%=groupid%>"  onClick="nodeCkAll(this,'<%=groupid%>')" >
													<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage())%>
												</wea:item>
												<wea:item type="thead">
													<input type="checkbox" name="title_editall<%=groupid%>"  onClick="nodeCkAll(this,'<%=groupid%>')" <%=dtldisabled%>>
													<%=SystemEnv.getHtmlLabelName(31836,user.getLanguage())%>
												</wea:item>
												<wea:item type="thead">
													<input type="checkbox" name="title_manall<%=groupid%>"  onClick="nodeCkAll(this,'<%=groupid%>')" <%=dtldisabled%>>
													<%=SystemEnv.getHtmlLabelName(31837,user.getLanguage())%>
												</wea:item>
											</wea:group>
										</wea:layout>
									</wea:item>
									<%

								}
								if(!isnew.equals("y"))
								{
									if(WFNodeFieldMainManager.getIsview().equals("1"))
										view=" checked";
									if(WFNodeFieldMainManager.getIsedit().equals("1"))
										edit=" checked";
									if(WFNodeFieldMainManager.getIsmandatory().equals("1"))
										man=" checked";
								}
							%>
									<wea:item><%=SystemEnv.getHtmlLabelName(curlabel,user.getLanguage())%><input type="hidden" name="isdetail<%=groupid%>" value='<%=viewtype %>'/></wea:item>
									<wea:item><input type="checkbox" name="node<%=curid%>_view_g<%=groupid%>" <%=view%> onClick="titlebox(this)"></wea:item>
									<%if(!fieldhtmltype.equals("7") && !fieldhtmltype.equals("9")){%>
									<wea:item><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" <%=edit%> <%=dtldisabled%> onClick="titlebox(this)" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%>></wea:item>
									<wea:item><input type="checkbox" name="node<%=curid%>_man_g<%=groupid%>"  <%=man%>  <%=dtldisabled%> onClick="titlebox(this)" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%>></wea:item>
									<%}else{%>
									 <%if(fieldhtmltype.equals("9")){ %>
									      <wea:item><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" <%=edit%> <%=dtldisabled%> onClick="titlebox(this)" <%if(nodetype.equals("3") || fieldname.equals("manager")){%>disabled<%}%>></wea:item>
									    <%}else{ %>
											<wea:item><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></wea:item>
									   <%} %>
									<wea:item><input type="checkbox" name="node<%=curid%>_edit_g<%=groupid%>" disabled></wea:item>
									<%}%>
						<%
							}
						}
						%>
	</wea:group>
</wea:layout>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWin()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
<script type="text/javascript">

function titlebox_edit_special(obj){		//针对标题、紧急程度字段，编辑按钮勾选，联动把必填勾上
	var ckbox = $(obj);
	var flag = ckbox.attr("checked");
	if(flag){
		ckbox.closest("tr").find(":checkbox").eq(2).attr("checked",true).next().addClass("jNiceChecked");
	}else{
		ckbox.closest("tr").find(":checkbox").eq(2).attr("checked",false).next().removeClass("jNiceChecked");
	}
}


function titlebox(obj){
	var ckbox = $(obj);
	var flag = ckbox.attr("checked");
	var ckboxval = ckbox.attr("name");
	if(ckboxval.indexOf("_view")>=0 && !flag){
		ckbox.closest("tr").find(":checkbox").attr("checked",false).next().removeClass("jNiceChecked");
	}else if(ckboxval.indexOf("_edit")>=0){
		if(flag){
			ckbox.closest("tr").find(":checkbox").eq(0).attr("checked",true).next().addClass("jNiceChecked");
		}else{
			ckbox.closest("tr").find(":checkbox").eq(2).attr("checked",false).next().removeClass("jNiceChecked");
		}
	}else if(ckboxval.indexOf("_man")>=0 && flag){
		ckbox.closest("tr").find(":checkbox").attr("checked",true).next().addClass("jNiceChecked");
	}
}
//主表 显示 表头checkbox  点击事件
function titleviewAll(obj,groupid){
	if($(obj).attr("checked"))
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox[name*=_view]").attr("checked",true).next().addClass("jNiceChecked");
	else{
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox").attr("checked",false).next().removeClass("jNiceChecked");
		$("[name=title_editall]").attr("checked",false).next().removeClass("jNiceChecked");
		$("[name=title_manall]").attr("checked",false).next().removeClass("jNiceChecked");
	}
}
//主表 可编辑 表头checkbox  点击事件
function titleeditAll(obj){
	if($(obj).attr("checked")){
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox[name*=_view]").attr("checked",true).next().addClass("jNiceChecked");
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox[name*=_edit]").attr("checked",true).next().addClass("jNiceChecked");
		$("[name=title_viewall]").attr("checked",true).next().addClass("jNiceChecked");
	}else{
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox[name*=_edit]").attr("checked",false).next().removeClass("jNiceChecked");
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox[name*=_man]").attr("checked",false).next().removeClass("jNiceChecked");
		$("[name=title_manall]").attr("checked",false).next().removeClass("jNiceChecked");
	}
	var sysobj;
	<%if(nodetype.equals("0")){ %>
		sysobj = $("[name='ischats_edit'],[name='ischats_man']");
	<%}else if(!nodetype.equals("3")){ %>
		sysobj = $("[name='title_edit'],[name='title_man'],[name='level_edit'],[name='level_man'],[name='ismessage_edit'],[name='ismessage_man'],[name='ischats_edit'],[name='ischats_man']");
	<%} %>
	if(sysobj != null){
		if($(obj).attr("checked"))
			sysobj.attr("checked",true).next().addClass("jNiceChecked");
		else
			sysobj.attr("checked",false).next().removeClass("jNiceChecked");
	}
}

//主表 是否必填 表头checkbox  点击事件
function titlemanAll(obj){
	if(obj.checked){
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox").attr("checked",true).next().addClass("jNiceChecked");
		$("[name=title_viewall]").attr("checked",true).next().addClass("jNiceChecked");
		$("[name=title_editall]").attr("checked",true).next().addClass("jNiceChecked");
	}else{
		$(obj).closest("table").find("tr").find("input[name^=isdetail][value=0]").closest("tr").find(":checkbox[name*=_man]").attr("checked",false).next().removeClass("jNiceChecked");
	}
}
//允许新增/编辑 明细 点击事件
function checkChange(groupid) {
    var isenable=0;
    var isen=0;
    if(jQuery("[name=dtl_add_"+groupid+"]").attr("checked"))
    	isen=1;
	if(jQuery("[name=dtl_edit_"+groupid+"]").attr("checked"))
    	isenable=1;
    if(isen==1){
   		jQuery("[name=dtl_ned_"+groupid+"]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   		jQuery("[name=dtl_def_"+groupid+"]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   		jQuery("[name=dtl_defrow"+groupid+"]").attr("disabled",false);
   		jQuery("[name=dtl_mul_"+groupid+"]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
	}else{
    	jQuery("[name=dtl_ned_"+groupid+"]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
   		jQuery("[name=dtl_def_"+groupid+"]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
   		jQuery("[name=dtl_defrow"+groupid+"]").attr("disabled",true);
   		jQuery("[name=dtl_mul_"+groupid+"]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
    }
    if(isenable==1||isen==1){
    	jQuery("[name*=edit_g"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name*=edit_g"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    	jQuery("[name*=man_g"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name*=man_g"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    	jQuery("[name=title_editall"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name=title_editall"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    	jQuery("[name=title_manall"+groupid+"]:checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox").addClass("jNiceChecked");
    	jQuery("[name=title_manall"+groupid+"]").not(":checked").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
    }else
    {
    	jQuery("[name*=edit_g"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name*=edit_g"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    	jQuery("[name*=man_g"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name*=man_g"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    	jQuery("[name=title_editall"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name=title_editall"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    	jQuery("[name=title_manall"+groupid+"]:checked").attr("disabled",true).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled").addClass("jNiceChecked_disabled");
    	jQuery("[name=title_manall"+groupid+"]").not(":checked").attr("disabled",true).next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
    }
}
//明细表 表头checkbox 点击事件
function nodeCkAll(obj,groupid){
	var ckbox = $(obj);
	var flag = ckbox.attr("checked");
	var ckboxval = ckbox.attr("name");
	if(ckboxval.indexOf("_view")>=0){
		if(flag){
			jQuery("[name*=view_g"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
		}else
		{
			jQuery("[name*=view_g"+groupid+"]").attr("checked",false).next().removeClass("jNiceChecked");
			jQuery("[name*=edit_g"+groupid+"]").not(":disabled").attr("checked",false).next().removeClass("jNiceChecked");
			jQuery("[name*=man_g"+groupid+"]").not(":disabled").attr("checked",false).next().removeClass("jNiceChecked");
			jQuery("[name=title_editall"+groupid+"]").not(":disabled").attr("checked",false).next().removeClass("jNiceChecked");
			jQuery("[name=title_manall"+groupid+"]").not(":disabled").attr("checked",false).next().removeClass("jNiceChecked");
		}
	}else if(ckboxval.indexOf("_edit")>=0){
		if(flag){
			jQuery("[name*=view_g"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
			jQuery("[name*=edit_g"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
			jQuery("[name=title_viewall"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
		}else
		{
			jQuery("[name*=edit_g"+groupid+"]").attr("checked",false).next().removeClass("jNiceChecked");
			jQuery("[name*=man_g"+groupid+"]").attr("checked",false).next().removeClass("jNiceChecked");
			jQuery("[name=title_manall"+groupid+"]").attr("checked",false).next().removeClass("jNiceChecked");
		}
	}else if(ckboxval.indexOf("_man")>=0){
		if(flag){
			jQuery("[name*=view_g"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
			jQuery("[name*=edit_g"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
			jQuery("[name*=man_g"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
			jQuery("[name=title_viewall"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
			jQuery("[name=title_editall"+groupid+"]").attr("checked",true).next().addClass("jNiceChecked");
		}else
		{
			jQuery("[name*=man_g"+groupid+"]").attr("checked",false).next().removeClass("jNiceChecked");
		}
	}
}
//保存
function saveAsVersion(){
	if (check_form(nodefieldform,'')){
		$("[name='nodeid']").val("<%=init_nodeid %>");
		nodefieldform.submit();
	}
}
</script>
</html>
