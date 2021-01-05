
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />


<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(22118, user.getLanguage()) + SystemEnv.getHtmlLabelName(19342, user.getLanguage());
    String needfav = "";
    String needhelp = "";

	String sql = "";
	int id = Util.getIntValue(request.getParameter("id"), -1);
	int workflowid = Util.getIntValue(request.getParameter("wfid"), -1);
	String formID = "";
	String isbill = "";
	rs.execute("select * from workflow_base where id="+workflowid);
	if(rs.next()){
		formID = Util.null2o(rs.getString("formid"));
		isbill = Util.null2o(rs.getString("isbill"));
	}
	String dialog = Util.null2String(request.getParameter("dialog"),"1");
    String isclose = Util.null2String(request.getParameter("isclose"));
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			try{
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
			}catch(e){}
			if("<%=isclose%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				parentWin._table.reLoad();
				dialog.close();
			}
		</script>
    </HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:saveCreateWTDetail(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	if(!"1".equals(dialog)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javascript:comebackCreateWT("+workflowid+", "+formID+", "+isbill+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

	int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowid+"subcompanyid")),-1);
    boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");
	
    if(operateLevel < 1 || id == -1){
		response.sendRedirect("/notice/noright.jsp");
		return;
    }
		int creatertype = 0;
		int wffieldid = 0;
		int taskid = 0;
		int nodeid = 0;
		rs.execute("select * from workflow_createtask where id="+id);
		if(rs.next()){
			creatertype = Util.getIntValue(rs.getString("creatertype"), 1);
			wffieldid = Util.getIntValue(rs.getString("wffieldid"), 0);
			taskid = Util.getIntValue(rs.getString("taskid"), 0);
			nodeid = Util.getIntValue(rs.getString("nodeid"), 0);
		}
		Hashtable createtaskdetail_hs = new Hashtable();
		Hashtable wffieldtype_hs = new Hashtable();
		sql = "select * from workflow_createtaskdetail where createtaskid="+id;
		rs.execute(sql);
		while(rs.next()){
			int groupid_tmp = Util.getIntValue(rs.getString("groupid"), 0);
			int wffieldid_tmp = Util.getIntValue(rs.getString("wffieldid"), 0);
			int wtfieldid_tmp = Util.getIntValue(rs.getString("wtfieldid"), 0);
			int isdetail_tmp = Util.getIntValue(rs.getString("isdetail"), 0);
			int wffieldtype_tmp = Util.getIntValue(rs.getString("wffieldtype"), 0);
			createtaskdetail_hs.put("wffield_"+wtfieldid_tmp+"_"+groupid_tmp, ""+wffieldid_tmp+"_"+isdetail_tmp);
			wffieldtype_hs.put("wffieldtype_"+wtfieldid_tmp+"_"+groupid_tmp, ""+wffieldtype_tmp);
		}
		Hashtable creategroup_hs = new Hashtable();
		sql = "select * from workflow_createtaskgroup where createtaskid="+id;
		rs.execute(sql);
		while(rs.next()){
			int groupid_tmp = Util.getIntValue(rs.getString("groupid"), 0);
			int isused_tmp = Util.getIntValue(rs.getString("isused"), 0);
			creategroup_hs.put("groupid_"+groupid_tmp, ""+isused_tmp);
		}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="saveCreateWTDetail();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<FORM name="CreateWorktaskByWorkflowDetail" method="post" action="CreateWorktaskByWorkflowDetailOperation.jsp" >
					<INPUT type=hidden id='workflowid' name='workflowid' value=<%=workflowid%>>
					<INPUT type=hidden id='wfid' name='wfid' value=<%=workflowid%>>
                    <INPUT type=hidden id='formID' name='formID' value=<%=formID%>>
                    <INPUT type=hidden id='isbill' name='isbill' value=<%=isbill%>>
					<INPUT type=hidden id='id' name='id' value=<%=id%>>
					<input type="hidden" id="operationType" name="operationType" value="">
					<input type="hidden" id="taskid" name="taskid" value="<%=taskid%>">
					<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
					<input type="hidden" name="subCompanyID" value="<%=subCompanyID%>">
					
<%
		ArrayList wt_idList = new ArrayList();
		ArrayList wt_nameList = new ArrayList();
		ArrayList wt_fieldnameLiat = new ArrayList();
		sql = "select id, description, crmname, fieldname from worktask_fielddict f left join worktask_taskfield t on f.id=t.fieldid and t.taskid="+taskid+" where f.wttype=1  order by issystem desc,orderid asc, id asc";
		rs.execute(sql);
		while(rs.next()){
			String wt_id_tmp = Util.null2o(rs.getString("id"));
			String wt_description_tmp = Util.null2String(rs.getString("description"));
			String wt_crmname_tmp = Util.null2String(rs.getString("crmname"));
			String wt_fieldname_tmp = Util.null2String(rs.getString("fieldname"));
			if("".equals(wt_crmname_tmp)){
				wt_crmname_tmp = wt_description_tmp;
			}
			wt_idList.add(wt_id_tmp);
			wt_nameList.add(wt_crmname_tmp);
			wt_fieldnameLiat.add(wt_fieldname_tmp);
			out.println("<input type=\"hidden\" name=\"wtfieldid\" id=\"wtfieldid\" value=\""+wt_id_tmp+"\" >");
		}
%>
					
    <wea:layout>
    	<wea:group context='<%=SystemEnv.getHtmlLabelNames("16539,616", user.getLanguage())%>'>
    		<wea:item><%=SystemEnv.getHtmlLabelNames("18015,882", user.getLanguage())%></wea:item>
    		<wea:item><input class="inputStyle" type="radio" name="creatertype" value="1" <%if(creatertype==1){out.println("checked");}%>  onclick="showWFfield(0)"></wea:item>
    		<wea:item><%=SystemEnv.getHtmlLabelNames("18015,15555", user.getLanguage())%></wea:item>
    		<wea:item>
    			<input class="inputStyle" type="radio" name="creatertype" value="2" <%if(creatertype==2){out.println("checked");}%>  onclick="showWFfield(1)">
				&nbsp;&nbsp;
				<select id="wffield" name="wffield" style="display:<%if(creatertype!=2){out.println("none");}%>" >
				<%
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=165) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formID;		//不包括多人力资源字段
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formID+ " and fieldhtmltype = '3' and (type=1 or type=165) and viewtype = 0 " ;
					}
					//System.out.println("sql = "+sql);
					rs.execute(sql);
					while(rs.next()){
						int fieldid_tmp = Util.getIntValue(rs.getString("id"), 0);
						int fieldlabel_tmp = Util.getIntValue(rs.getString("name"), 0);
						String fieldname_tmp = "";
						if(isbill.equals("0")){
							fieldname_tmp = Util.null2String(rs.getString("name"));
						}else{
							fieldname_tmp = SystemEnv.getHtmlLabelName(fieldlabel_tmp, user.getLanguage());
						}
						String selectedStr = "";
						if(wffieldid == fieldid_tmp){
							selectedStr = " selected ";
						}
						out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldname_tmp+"</option>");
					}
				%>
				</select>
    		</wea:item>
    	</wea:group>
										
						<%
							int detailCount = 0;
							ArrayList groupidList = new ArrayList();
							ArrayList detailTableList = new ArrayList();
							if(isbill.equals("0")){
								sql = "select groupid from workflow_formfield where formid="+formID+" and isdetail=1 group by groupid order by groupid";
								rs.execute(sql);
								while(rs.next()){
									detailCount++;
									String groupid_tmp = Util.null2o(rs.getString("groupid"));
									groupidList.add(groupid_tmp);
								}
							}else{
								sql = "select orderid,tablename from Workflow_billdetailtable where billid="+formID+" order by orderid";
								rs.execute(sql);
								while(rs.next()){
									detailCount++;
									String groupid_tmp = ""+Util.getIntValue(rs.getString("orderid"), 0);
									String detailTable_tmp = Util.null2String(rs.getString("tablename"));
									groupidList.add(groupid_tmp);
									detailTableList.add(detailTable_tmp);
								}
							}
							//获得所有流程主字段
							ArrayList wf_idList = new ArrayList();
							ArrayList wf_nameList = new ArrayList();
							if(isbill.equals("0")){
								sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formID;
							}else{
								sql = "select id as id , fieldlabel as name from workflow_billfield where viewtype=0 and billid="+ formID;
							}
							rs.execute(sql);
							while(rs.next()){
								String wf_id_tmp = Util.null2o(rs.getString("id"));
								String wf_name_tmp = Util.null2String(rs.getString("name"));
								if(!isbill.equals("0")){
									wf_name_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(wf_name_tmp, 0), user.getLanguage());
								}
								wf_idList.add(wf_id_tmp);
								wf_nameList.add(wf_name_tmp);
							}
							for(int i=0; (i<detailCount || i==0); i++){
								String wf_groupid = "-1";
								if(isbill.equals("0")){
									try{
										wf_groupid = ""+Util.getIntValue((String)groupidList.get(i), -1);
									}catch(Exception e){}
								}else{
									try{
										wf_groupid = Util.null2String((String)groupidList.get(i));
									}catch(Exception e){}
								}
								boolean hasNoDeatil = false;
								if(wf_groupid.equals("-1")){
									hasNoDeatil = true;
									wf_groupid = "0";
								}
								String checkStr = "";
						%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22129, user.getLanguage())+"("+ (i+1)+SystemEnv.getHtmlLabelName(2026, user.getLanguage())+"--"+SystemEnv.getHtmlLabelName(22131, user.getLanguage())+")"%>'>
			
			<wea:item type="groupHead">
				<span class="noHide">
					<input type="hidden" name="groupid" id="groupid" value="<%=wf_groupid%>" >
					<%
						String isused_tmp = Util.null2String((String)creategroup_hs.get("groupid_"+wf_groupid));
						if("1".equals(isused_tmp)){
							checkStr = " checked ";
						}
						out.println("<span class=\"noHide\">"+SystemEnv.getHtmlLabelName(22132, user.getLanguage())+"</span>&nbsp;&nbsp;<input type=\"checkbox\" name=\"isused_"+wf_groupid+"\" id=\"isused_"+wf_groupid+"\" value=\"1\" "+checkStr+">");
					%>
				</span>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'33%,33%,33%'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16539, user.getLanguage()) + SystemEnv.getHtmlLabelName(261, user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(261, user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(19359, user.getLanguage())%></wea:item>
					    <%
									boolean isLight = true;
									String classStr = " class=\"datalight\"";
									for(int cx=0; cx<wt_idList.size(); cx++){
										String wt_id_tmp = (String)wt_idList.get(cx);
										String wt_crmname_tmp = (String)wt_nameList.get(cx);
										String wt_fieldname_tmp = (String)wt_fieldnameLiat.get(cx);
										String wffieldselectStr2 = "<select name=\"wffield_"+wt_id_tmp+"_"+(wf_groupid)+"\" id=\"wffield_"+wt_id_tmp+"_"+(wf_groupid)+"\" style=\"width:80%\">\n<option value=\"-1\"></option>";
										String valueStr = Util.null2String((String)createtaskdetail_hs.get("wffield_"+wt_id_tmp+"_"+(wf_groupid)));
										String wffieldselectStr = "";
										for(int ax=0; ax<wf_idList.size(); ax++){
											String wf_id_tmp = (String)wf_idList.get(ax);
											String wf_name_tmp = (String)wf_nameList.get(ax);
											String selectStr = "";
											//System.err.println("---------->valueStr:"+valueStr);
											if(!"".equals(valueStr) && valueStr.equals(""+wf_id_tmp+"_0")){
												selectStr = " selected ";
											}
											wffieldselectStr += ("<option value=\""+wf_id_tmp+"_0\""+selectStr+">"+wf_name_tmp+"</option>\n");
										}
										wffieldselectStr2 += wffieldselectStr;
										if(hasNoDeatil == false){
											if(isbill.equals("0")){
												sql = "select workflow_formdictdetail.id as id,workflow_fieldlable.fieldlable as name from workflow_formdictdetail,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdictdetail.id and workflow_formfield.isdetail='1' and workflow_formfield.formid="+formID+" and workflow_formfield.groupid="+wf_groupid;
											}else{
												String detailTable = (String)detailTableList.get(i);
												sql = "select id as id , fieldlabel as name from workflow_billfield where viewtype=1 and billid="+ formID+" and detailtable='"+detailTable+"'";
											}
											rs.execute(sql);
											while(rs.next()){
												String wf_id_tmp = Util.null2o(rs.getString("id"));
												String wf_name_tmp = Util.null2String(rs.getString("name"));
												if(!isbill.equals("0")){
													wf_name_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(wf_name_tmp, 0), user.getLanguage());
												}
												String selectStr = "";
												//System.err.println("---------->valueStr:"+valueStr);
												if(!"".equals(valueStr) && valueStr.equals(wf_id_tmp+"_1")){
													selectStr = " selected ";
												}
												wffieldselectStr2 += ("<option value=\""+wf_id_tmp+"_1\" "+selectStr+">"+wf_name_tmp+"("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")"+(i+1)+"</option>\n");
											}
										}
										wffieldselectStr2 += "</select>";
										checkStr = "";
										int wffieldtype = Util.getIntValue((String)wffieldtype_hs.get("wffieldtype_"+wt_id_tmp+"_"+(wf_groupid)), 0);
										String wffieldtypeStr = "";
										if(wffieldtype == 1){
											wffieldtypeStr = " checked ";
										}
										if("liableperson".equalsIgnoreCase(wt_fieldname_tmp)){
											wffieldtypeStr = "<input type=\"checkbox\" name=\"wffieldtype_"+wt_id_tmp+"_"+(wf_groupid)+"\" id=\"wffieldtype_"+wt_id_tmp+"_"+(wf_groupid)+"\" value=\"1\" "+wffieldtypeStr+">&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(22130, user.getLanguage());
										}
						%>
						<wea:item><%=wt_crmname_tmp%></wea:item>
						<wea:item><%=wffieldselectStr2%></wea:item>
						<wea:item ><%=wffieldtypeStr%></wea:item>
						<%
						}
						%>
					</wea:group>
			    </wea:layout>
			</wea:item>
	</wea:group>
	<%}%>
	</wea:layout>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclose_onclick()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
function showWFfield(type){
	if(type==1){
		CreateWorktaskByWorkflowDetail.wffield.style.display = "";
	}else{
		CreateWorktaskByWorkflowDetail.wffield.style.display = "none";
	}
}

function saveCreateWTDetail(){
	CreateWorktaskByWorkflowDetail.operationType.value = "save";
	CreateWorktaskByWorkflowDetail.submit();
}

function comebackCreateWT(workflowid, formID, isbill){
	window.location = "/workflow/workflow/CreateWorktaskByWorkflow.jsp?ajax=1&errorMessage=0&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill;

}
// 关闭
function btnclose_onclick(){
    if(dialog){
        try{
			dialog.close();
		}catch(e){
		}
	}else{
	    window.parent.close();
	}
}
</script>
</BODY>
</HTML>
