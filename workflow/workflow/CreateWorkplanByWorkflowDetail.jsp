
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="createWorkplanByWorkflow" class="weaver.WorkPlan.CreateWorkplanByWorkflow" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24086, user.getLanguage()) + SystemEnv.getHtmlLabelName(19342, user.getLanguage());
    String needfav = "";
    String needhelp = "";
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
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
	boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowid+"subcompanyid")),-1);
    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");

	if (operateLevel<1 || workflowid==-1) {		
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			if("<%=dialog%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				function btn_cancle(){
					dialog.closeByHand();
				}
			}
			if("<%=isclose%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				parentWin._table.reLoad();
				dialog.close();
			}
		</script>
    </HEAD>
<BODY>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="saveCreateWPDetail();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:saveCreateWPDetail(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	if(!"1".equals(dialog)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javascript:comebackCreateWP("+workflowid+", "+formID+", "+isbill+"),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	if(operateLevel>0 && id!=-1){
		int creatertype = 0;
		int wffieldid = 0;
		int plantypeid = 0;
		int nodeid = 0;
		int remindType = 1;
		int remindBeforeStart = 0;
		int remindDateBeforeStart = 0;
		int remindTimeBeforeStart = 0;
		int remindBeforeEnd = 0;
		int remindDateBeforeEnd = 0;
		int remindTimeBeforeEnd = 0;
		rs.execute("select * from workflow_createplan where id="+id);
		if(rs.next()){
			creatertype = Util.getIntValue(rs.getString("creatertype"), 1);
			wffieldid = Util.getIntValue(rs.getString("wffieldid"), 0);
			plantypeid = Util.getIntValue(rs.getString("plantypeid"), 0);
			nodeid = Util.getIntValue(rs.getString("nodeid"), 0);
			remindType = Util.getIntValue(rs.getString("remindType"), 1);
			remindBeforeStart = Util.getIntValue(rs.getString("remindBeforeStart"), 0);
			remindDateBeforeStart = Util.getIntValue(rs.getString("remindDateBeforeStart"), 0);
			remindTimeBeforeStart = Util.getIntValue(rs.getString("remindTimeBeforeStart"), 0);
			remindBeforeEnd = Util.getIntValue(rs.getString("remindBeforeEnd"), 0);
			remindDateBeforeEnd = Util.getIntValue(rs.getString("remindDateBeforeEnd"), 0);
			remindTimeBeforeEnd = Util.getIntValue(rs.getString("remindTimeBeforeEnd"), 0);
		}
		Hashtable createtaskdetail_hs = new Hashtable();
		sql = "select * from workflow_createplandetail where createplanid="+id;
		rs.execute(sql);
		while(rs.next()){
			int groupid_tmp = Util.getIntValue(rs.getString("groupid"), 0);
			int wffieldid_tmp = Util.getIntValue(rs.getString("wffieldid"), 0);
			String planfieldname_tmp = Util.null2String(rs.getString("planfieldname"));
			int isdetail_tmp = Util.getIntValue(rs.getString("isdetail"), 0);
			createtaskdetail_hs.put("wffield_"+planfieldname_tmp+"_"+groupid_tmp, ""+wffieldid_tmp+"_"+isdetail_tmp);
		}
		Hashtable creategroup_hs = new Hashtable();
		sql = "select * from workflow_createplangroup where createplanid="+id;
		rs.execute(sql);
		while(rs.next()){
			int groupid_tmp = Util.getIntValue(rs.getString("groupid"), 0);
			int isused_tmp = Util.getIntValue(rs.getString("isused"), 0);
			creategroup_hs.put("groupid_"+groupid_tmp, ""+isused_tmp);
		}
%>

<FORM name="CreateWorkplanByWorkflowDetail" method="post" action="CreateWorkplanByWorkflowDetailOperation.jsp" >
    <input type="hidden" name="dialog" value="<%=dialog%>">
    <%
		Hashtable ret_hs = createWorkplanByWorkflow.getWorkplanField(user.getLanguage());
		ArrayList plan_nameList = (ArrayList)ret_hs.get("plan_nameList");
		ArrayList plan_fieldnameLiat = (ArrayList)ret_hs.get("plan_fieldnameLiat");
		for(int i=0; i<plan_fieldnameLiat.size(); i++){
			String planfieldname_tmp = Util.null2String((String)plan_fieldnameLiat.get(i));
			out.println("<input type=\"hidden\" name=\"planfieldname\" id=\"planfieldname"+i+"\" value=\""+planfieldname_tmp+"\" >");
		}
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
		wf_idList.add("-1");
		wf_nameList.add(SystemEnv.getHtmlLabelName(18015, user.getLanguage())+SystemEnv.getHtmlLabelName(229, user.getLanguage()));
		wf_idList.add("-2");
		wf_nameList.add(SystemEnv.getHtmlLabelName(15534, user.getLanguage()));
		wf_idList.add("-3");
		wf_nameList.add(SystemEnv.getHtmlLabelName(17582, user.getLanguage()));
		rs.execute("select n.id, n.nodename from workflow_flownode f left join workflow_nodebase n on n.id=f.nodeid where workflowid="+workflowid);
		while(rs.next()){
			int nodeid_tmp = Util.getIntValue(rs.getString(1), 0);
			String nodename_tmp = Util.null2String(rs.getString(2));
			wf_idList.add(""+(nodeid_tmp*(-1)-10));
			wf_nameList.add(nodename_tmp + SystemEnv.getHtmlLabelName(15586, user.getLanguage())+SystemEnv.getHtmlLabelName(17482, user.getLanguage()));
		}
		//wf_idList.add("-4");
		//wf_nameList.add(SystemEnv.getHtmlLabelName(22244, user.getLanguage())+SystemEnv.getHtmlLabelName(17482, user.getLanguage()));
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
	%>
<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(2211, user.getLanguage()) + SystemEnv.getHtmlLabelName(616, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
		<wea:item><input type="radio" name="creatertype" value="1" <%if(creatertype==1){out.println("checked");}%>  onclick="showWFfield2(0)"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(15555, user.getLanguage())%></wea:item>
		<wea:item>
			<input type="radio" name="creatertype" value="2" <%if(creatertype==2){out.println("checked");}%>  onclick="showWFfield2(1)">
			&nbsp;&nbsp;
			<select id="wffield"  name="wffield" style="display:<%if(creatertype!=2){out.println("none");}%>" >
			<%
				if(isbill.equals("0")){
					sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=165) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formID;		//不包括多人力资源字段
				}else{
					sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formID+ " and fieldhtmltype = '3' and (type=1 or type=165) and viewtype = 0 " ;
				}
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
					String selectStr = "";
					if(wffieldid>0 && wffieldid==fieldid_tmp){
						selectStr = " selected ";
					}
					out.println("<option value=\""+fieldid_tmp+"\" "+selectStr+">"+fieldname_tmp+"</option>");
				}
			%>
			</select>
		</wea:item>
		
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21976, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT type="radio" value="1" name="remindType" onclick="showRemindTime_wp(this)" <%if (remindType==1) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
			<INPUT type="radio" value="2" name="remindType" onclick="showRemindTime_wp(this)" <%if (remindType==2) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
			<INPUT type="radio" value="3" name="remindType" onclick="showRemindTime_wp(this)" <%if (remindType==3) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
		</wea:item>
		<%String attrs = "{'samePair':'remindTime','display':'"+(remindType==1?"none":"")+"'}"; %>
		<wea:item attributes='<%=attrs %>'><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attrs %>'>
			<INPUT type="checkbox" name="remindBeforeStart" value="1" <%if(remindBeforeStart==1){%>checked<%}%>>
			<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
			<INPUT class="InputStyle" style="width:50px;" type="text" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size="5" value="<%=remindDateBeforeStart%>">
			<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
			<INPUT class="InputStyle" style="width:50px;" type="text" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size="5" value="<%=remindTimeBeforeStart%>">
			<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			<br/>
			<INPUT type="checkbox" name="remindBeforeEnd" value="1" <% if(remindBeforeEnd==1) { %>checked<% } %>>
			<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
			<INPUT class="InputStyle" style="width:50px;" type="text" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size="5" value="<%=remindDateBeforeEnd%>">
			<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
			<INPUT class="InputStyle" style="width:50px;" type="text" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size="5" value="<%=remindTimeBeforeEnd%>">
			<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
		</wea:item>
	</wea:group>
	
	<%
		
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
				<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'50%,50%'}">
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(2211, user.getLanguage()) + SystemEnv.getHtmlLabelName(261, user.getLanguage())%></wea:item>
						<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage()) + SystemEnv.getHtmlLabelName(261, user.getLanguage())%></wea:item>
					<%
						boolean isLight = true;
						String classStr = " class=\"datalight\"";
						for(int cx=0; cx<plan_nameList.size(); cx++){
							String plan_crmname_tmp = (String)plan_nameList.get(cx);
							String plan_fieldname_tmp = (String)plan_fieldnameLiat.get(cx);
							String wffieldselectStr2 = "<select name=\"wffield_"+plan_fieldname_tmp+"_"+(wf_groupid)+"\" id=\"wffield_"+plan_fieldname_tmp+"_"+(wf_groupid)+"\" style=\"width:80%\">\n<option value=\"-1\"></option>";
							String valueStr = Util.null2String((String)createtaskdetail_hs.get("wffield_"+plan_fieldname_tmp+"_"+(wf_groupid)));
							String wffieldselectStr = "";
							for(int ax=0; ax<wf_idList.size(); ax++){
								String wf_id_tmp = (String)wf_idList.get(ax);
								String wf_name_tmp = (String)wf_nameList.get(ax);
								String selectStr = "";
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
									if(!"".equals(valueStr) && valueStr.equals(wf_id_tmp+"_1")){
										selectStr = " selected ";
									}
									wffieldselectStr2 += ("<option value=\""+wf_id_tmp+"_1\" "+selectStr+">"+wf_name_tmp+"("+SystemEnv.getHtmlLabelName(17463, user.getLanguage())+")"+(i+1)+"</option>\n");
								}
							}
							wffieldselectStr2 += "</select>";
							checkStr = "";
					%>
						<wea:item><%=plan_crmname_tmp%></wea:item>
						<wea:item><%=wffieldselectStr2%></wea:item>
					<%
						}
					%>
				</wea:group>
				</wea:layout>
			</wea:item>
		</wea:group>
		<%}%>
		</wea:layout>
               <INPUT type=hidden id="workflowid" name="workflowid" value=<%=workflowid%>>
<INPUT type=hidden id="wfid" name="wfid" value=<%=workflowid%>>
               <INPUT type=hidden id="formID" name="formID" value=<%=formID%>>
               <INPUT type=hidden id="isbill" name="isbill" value=<%=isbill%>>
<INPUT type=hidden id="id" name="id" value="<%=id%>">
<input type="hidden" id="operationType" name="operationType" value="">
<input type="hidden" id="plantypeid" name="plantypeid" value="<%=plantypeid%>">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid%>">
    
</FORM>
<%if("1".equals(dialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');checkSubmit();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');checkSubmit();">
		    	<span class="e8_sep_line">|</span> --%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
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
<script language="javascript">
function showWFfield2(type){
	if(type==1){
		//CreateWorkplanByWorkflowDetail.wffield.style.display = "";
		jQuery("#wffield").selectbox("show");
	}else{
		//CreateWorkplanByWorkflowDetail.wffield.style.display = "none";
		jQuery("#wffield").selectbox("hide");
	}
}

function showRemindTime_wp(obj){
	if("1" == obj.value){
		hideEle("remindTime");
	}else{
		showEle("remindTime");
	}
}

function saveCreateWPDetail(){
	CreateWorkplanByWorkflowDetail.operationType.value = "save";
	CreateWorkplanByWorkflowDetail.submit();
}

function comebackCreateWP(workflowid, formID, isbill){
	window.location = "/workflow/workflow/CreateWorkplanByWorkflow.jsp?ajax=1&errorMessage=0&wfid="+workflowid+"&formid="+formID+"&isbill="+isbill;

}
</script>
<%
	}else{
		
		return;
	}
%>
</BODY>
</HTML>
