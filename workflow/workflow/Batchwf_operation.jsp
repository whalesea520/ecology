
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<%WFNodeOperatorManager.resetParameter();%>
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<%RequestCheckUser.resetParameter();%>
<jsp:useBean id="RequestUserDefaultManager" class="weaver.workflow.request.RequestUserDefaultManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}  
	int design = Util.getIntValue(request.getParameter("design"),0);
	String ajax=Util.null2String(request.getParameter("ajax"));
	String isTemplate=Util.null2String(request.getParameter("isTemplate"));
	int templateid=Util.getIntValue(request.getParameter("templateid"),0);
	int selectedCateLog = Util.getIntValue(request.getParameter("selectcatalog"),0);
	int catelogType = Util.getIntValue(request.getParameter("catalogtype"),0);
	String src = Util.null2String(request.getParameter("src"));
    int subCompanyId = Util.getIntValue(request.getParameter("subcompanyid"),-1); //add by wjy
    
	if(src.equalsIgnoreCase("addoperatorgroup")){
		String wfids = Util.null2String(request.getParameter("wfids"));
		String selectwfids[] = wfids.split(",");
		for(int index=0;index<selectwfids.length;index++){
			int wfid = Util.getIntValue(selectwfids[index],0);
		  	int nodeid=0;
		  	int formid=0;
		  	String isbill="";
		  	String iscust="0";
		  	
			String sql = "";
			sql = "select a.formid,a.isbill,a.iscust,b.nodeid from workflow_base a,workflow_flownode b where a.id = b.workflowid and b.nodetype = 0 and a.id = " + wfid;
			RecordSet.executeSql(sql);
			if(RecordSet.next()){
			  	nodeid=Util.getIntValue(RecordSet.getString("nodeid"),0);
			  	formid=Util.getIntValue(RecordSet.getString("formid"),0);
			  	isbill=Util.null2String(RecordSet.getString("isbill"));
			  	iscust=Util.null2String(RecordSet.getString("iscust"));
			}
			
			//先做删除现有操作者
			if(true){
			    String nodetype="0";
			  	String tmp = "";//groupid
		  		RecordSet.executeSql("delete from workflow_groupdetail where groupid in (select id from workflow_nodegroup where nodeid = "+nodeid+")");
		  		RecordSet.executeSql("delete from workflow_nodegroup where nodeid = "+nodeid);
		  		RecordSet.executeSql("update workflow_nodebase set totalgroups=0 where id = "+nodeid);
				String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
				RequestCheckUser.setWorkflowid(wfid);
				RequestCheckUser.setNodeid(nodeid);
			    RequestCheckUser.updateCreateList(Util.getIntValue(tmp));
				RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);

			    //删除节点操作组日志
			    SysMaintenanceLog.resetParameter();
			    SysMaintenanceLog.setRelatedId(nodeid);
			    SysMaintenanceLog.setRelatedName(SystemEnv.getHtmlLabelName(15545,user.getLanguage()));
			    SysMaintenanceLog.setOperateType("3");
			    SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_delete");
			    SysMaintenanceLog.setOperateItem("87");
			    SysMaintenanceLog.setOperateUserid(user.getUID());
			    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			    SysMaintenanceLog.setSysLogInfo();
			}
			
			int id = 0;
		  	sql = "select max(id) as id from workflow_nodegroup";
		  	RecordSet.executeSql(sql);
		
		  	if(RecordSet.next()){
		  		id = Util.getIntValue(Util.null2String(RecordSet.getString("id")),0);
		  	}
		  	id += 1;
		
			int rowsum = Util.getIntValue(Util.null2String(request.getParameter("groupnum")));
			WFNodeOperatorManager.resetParameter();
			WFNodeOperatorManager.setId(id);
			WFNodeOperatorManager.setNodeid(nodeid);
			String groupname = Util.null2String(request.getParameter("groupname"));
			int canview = 1;
			WFNodeOperatorManager.setName(groupname);
			WFNodeOperatorManager.setCanview(canview);
			WFNodeOperatorManager.setAction("add");
			WFNodeOperatorManager.AddGroupInfo();
		    String para="";  
			for(int i=0;i<rowsum;i++) {
				String type = Util.null2String(request.getParameter("group_"+i+"_type"));
				String groupid = Util.null2String(request.getParameter("group_"+i+"_id"));
				int level = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level")),0);
				int level2 = Util.getIntValue(Util.null2String(request.getParameter("group_"+i+"_level2")),0);
		        String conditions=Util.null2String(request.getParameter("group_"+i+"_condition"));
		        String orders=Util.null2String(request.getParameter("group_"+i+"_order"));
				String signorder=Util.null2String(request.getParameter("group_"+i+"_signorder"));
		        String IsCoadjutant=Util.null2String(request.getParameter("group_"+i+"_IsCoadjutant"));
		        String signtype=Util.null2String(request.getParameter("group_"+i+"_signtype"));
				String issyscoadjutant=Util.null2String(request.getParameter("group_"+i+"_issyscoadjutant"));
		        String coadjutants=Util.null2String(request.getParameter("group_"+i+"_coadjutants"));
		        String issubmitdesc=Util.null2String(request.getParameter("group_"+i+"_issubmitdesc"));
				String ispending=Util.null2String(request.getParameter("group_"+i+"_ispending"));
		        String isforward=Util.null2String(request.getParameter("group_"+i+"_isforward"));
		        String ismodify=Util.null2String(request.getParameter("group_"+i+"_ismodify"));
				String Coadjutantconditions=Util.null2String(request.getParameter("group_"+i+"_Coadjutantconditions"));
				signorder = "-1".equals(signorder) ? "" : signorder;
				//对应为空，没选情况判断出来下
				if(signorder.equals("[object]")){
					signorder="";
				}
		        String conditioncn=Util.fromScreen(Util.null2String(request.getParameter("group_"+i+"_conditioncn")),user.getLanguage());
				if (orders.equals("")) orders="0";
				if(!type.equals("")){
					char flag=2;
					para=""+id+flag+type+flag+groupid+flag+level+flag+level2+flag+conditions+flag+conditioncn+flag+orders+flag+signorder+flag+IsCoadjutant+
		                    flag+signtype+flag+issyscoadjutant+flag+issubmitdesc+flag+ispending+flag+isforward+flag+ismodify+flag+coadjutants+flag+Coadjutantconditions;
					RecordSet.executeProc("workflow_groupdetail_Insert",para);
				}
			}
		
			int iscreate = 1;
			if(iscreate==1){
		        String hisWorkflowCreater=RequestUserDefaultManager.getWorkflowCreater(String.valueOf(wfid));
				RequestCheckUser.setWorkflowid(wfid);
				RequestCheckUser.setNodeid(nodeid);
			    RequestCheckUser.updateCreateList(id);
				RequestUserDefaultManager.addDefaultOfNoSysAdmin(String.valueOf(wfid),hisWorkflowCreater);
			}
		
			//新增操作人组日志
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(nodeid);
			SysMaintenanceLog.setRelatedName(groupname);
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("WrokFlowNodeOperator_insert");
			SysMaintenanceLog.setOperateItem("87");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
		}
	   	//response.sendRedirect("/workflow/workflow/Batchaddoperatorgroup.jsp?iscust=0&wfid="+5+"&nodeid="+14+"&formid="+3+"&isbill="+0);
	   	//response.sendRedirect("/workflow/workflow/Batchaddoperatorgroup.jsp");
		//return;
  }
%>
<script type="text/javascript">
<!--
	alert("<%=SystemEnv.getHtmlLabelName(32024,user.getLanguage())+SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>");
	location.href = "/workflow/workflow/Batchaddoperatorgroup.jsp";
//-->
</script>
