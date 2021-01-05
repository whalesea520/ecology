<!DOCTYPE html>
<%@ page import="weaver.general.Util"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.check.JobComInfo"%>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo"	scope="page" />
<jsp:useBean id="DepartmentComInfo"	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String objtype = Util.null2String(request.getParameter("objtype"));
    String objid = Util.null2String(request.getParameter("objid"));
    String sltgidsql = "";
    String sltwfidsql = "";
    String sltcountsql = "";
    
    String objidspanvalue = "";
    int shareobjtype = 0;
    //获取分权和路径维护权限 START
    
	//是否分权系统，如不是，则不显示框架，直接转向到列表页面
	int detachable=0;
	boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
	if(isUseWfManageDetach){
		detachable = 1;
	}else{
	}
    int subCompanyId= Util.getIntValue(Util.null2String(request.getParameter("subCompanyId")),-1);

    WfRightManager wfrm = new WfRightManager();
    boolean hasPermission = wfrm.hasPermission2(0, user, WfRightManager.OPERATION_CREATEDIR);
    
    String wftypeids = "";
    if(hasPermission && -1 == subCompanyId){
        wftypeids = wfrm.getAllWfTypeIds(user.getUID());    
    }
    String hasRightSub = "";
    
    String whereBuffer = "";
    if (detachable == 1) {
        //查询只读以上权限分部ID字符串
        if(-1 == subCompanyId){
            hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Workflow:permission",0);    
        }
    }
    String workflowidSql = "";
	new BaseBean().writeLog("detachable = "+detachable+"||hasRightSub="+hasRightSub);
    //当开启分权时
    if(detachable == 1){
        if(!"".equals(wftypeids) && !"".equals(hasRightSub)){
                whereBuffer+=" and ( templateid in ("+wftypeids+") or subcompanyid in ("+hasRightSub+")";
                whereBuffer+="       or id in ("+wftypeids+") or subcompanyid in ("+hasRightSub+"))";
        }else if(!"".equals(wftypeids)){
                whereBuffer+=" and (templateid in ("+wftypeids+")";
                whereBuffer+="      or id in ("+wftypeids+"))";
            //当该用户未选择机构时
        }else if(!"".equals(hasRightSub) && -1==subCompanyId){
            whereBuffer+=" and subcompanyid in ("+hasRightSub+")";
        }else{
            whereBuffer+=" and subcompanyid  = "+subCompanyId;
        }
        workflowidSql = "select case when activeversionid is null then id else activeversionid end as workflowid from workflow_base where id in (select id from workflow_base where 1=1 "+ whereBuffer + ")";
    }
    //获取分权和路径维护权限 END
    
    String sqlfrom = "";
    String sqlWhere = "tbl.workflowtype > 0";
    if (!"".equals(objtype) && !"".equals(objid)) {
        //1,4,54,164
        if ("1".equals(objtype)) {
            shareobjtype = 3;
            ResourceComInfo resourceComInfo = new ResourceComInfo();
            objidspanvalue = resourceComInfo.getLastname(objid);
            
        } else if ("4".equals(objtype)) {
            shareobjtype = 1;
            
            DepartmentComInfo dc = new DepartmentComInfo() ;
            objidspanvalue = dc.getDepartmentname(objid);
        } else if ("65".equals(objtype)) {
            shareobjtype = 2;
            
            RolesComInfo rc = new RolesComInfo();
            objidspanvalue = rc.getRolesname(objid);
        } else if ("164".equals(objtype)) {
            shareobjtype = 30;
            
            DepartmentComInfo dc = new DepartmentComInfo() ;
            objidspanvalue = dc.getSubcompanyid1(objid);
        } else if ("58".equals(objtype)) {//岗位
            shareobjtype = 58;
            
            JobComInfo jobComInfo = new JobComInfo();
            objidspanvalue = jobComInfo.getJobName(objid);
        }
        
        sqlfrom = "("
            + " select wfgdl.id, wfng.groupname, wfnb.nodename, wffn.nodetype, wfb.workflowname, wfb.workflowtype,wfb.subcompanyid "
            + " from workflow_groupdetail wfgdl "
            + "    LEFT join  workflow_nodegroup wfng on wfgdl.groupid=wfng.id "
            + "    LEFT JOIN workflow_nodebase wfnb ON wfng.nodeid=wfnb.id "
            + "    LEFT JOIN workflow_flownode wffn ON wffn.nodeid=wfnb.id "
            + "    LEFT join workflow_base wfb ON wfb.id=wffn.workflowid "
            //+ " WHERE wfng.id IN ( "
			+ " WHERE " ;
			//+ "(" 
			//+ " wfgdl.id IN (" + sltgidsql + ")"
            //+ "    and wfb.id IN (" + sltwfidsql + ")" 
            //+ " )"
           
            if(shareobjtype==3){//人力资源类型做了改造，此处需要特殊处理
            	sqlfrom	 +="  wfgdl.type=" + shareobjtype + "   and exists(select 1 from Workflow_HrmOperator where Workflow_HrmOperator.groupdetailid=wfgdl.id and Workflow_HrmOperator.objid='"+objid+"') ";
            }else if(shareobjtype==58){//岗位类型有岗位、多岗位
        		if (rst.getDBType().equals("oracle")||rst.getDBType().equals("db2")){
        			sqlfrom	 += " wfgdl.type=" + shareobjtype + " and ','||to_char(wfgdl.jobobj)||',' like '%," + objid + ",%' ";
        		}else{
        			sqlfrom	 += " wfgdl.type=" + shareobjtype + " and ','+convert(varchar,wfgdl.jobobj)+',' like '%," + objid + ",%' ";
        		}
            
            }else{
            	sqlfrom += "  wfgdl.type=" + shareobjtype + " AND wfgdl.objid=" + objid;
            }
            //获取分权和路径维护权限拼接条件 END
            if(detachable == 1){
                sqlfrom += " and wfb.id in(" + workflowidSql + ")";
			}
            //获取分权和路径维护权限拼接条件 END
			
			sqlfrom += " and (wfnb.IsFreeNode is null or wfnb.IsFreeNode!='1') ";
			//流程状态为有效状态的流程才显示路径
			sqlfrom += " and wfb.isvalid = '1' ";
            //and exists(select 1 from Workflow_HrmOperator where Workflow_HrmOperator.groupdetailid=wfgdl.id and Workflow_HrmOperator.objid='64916')
            //+ " OR ( wfgdl.type=" + shareobjtype + " AND wfgdl.objid=" + objid + ")"
            
//            + " OR ( wfgdl.id IN (SELECT id FROM workflow_groupdetail where type=" + shareobjtype + " AND objid=" + objid + "))"
            sqlfrom += ") tbl";
        
    
        //获取分权和路径维护权限拼接条件 START
        if(detachable == 1){
        	sltcountsql = "select count(1) as count from workflow_groupdetail wfgdl "
            + "    LEFT join  workflow_nodegroup wfng on wfgdl.groupid=wfng.id "
            + "    LEFT JOIN workflow_nodebase wfnb ON wfng.nodeid=wfnb.id "
            + "    LEFT JOIN workflow_flownode wffn ON wffn.nodeid=wfnb.id "
            + "    LEFT join workflow_base wfb ON wfb.id=wffn.workflowid ";
        	sltcountsql += "where type=" + shareobjtype ;
            sltcountsql += " and wfb.id in(" + workflowidSql + ")";
		}else{
        	sltcountsql = "select count(1) as count from workflow_groupdetail wfgdl where type=" + shareobjtype ;
		}
        //获取分权和路径维护权限拼接条件 END
        if(shareobjtype==3){//人力资源类型做了改造，此处需要特殊处理
        	sltcountsql+="  and exists(select 1 from Workflow_HrmOperator inner join workflow_nodegroup ng on ng.id=Workflow_HrmOperator.groupid where Workflow_HrmOperator.groupdetailid=wfgdl.id and ng.nodeid!=0 and Workflow_HrmOperator.objid='"+objid+"') "; 
        }else if(shareobjtype==58){//岗位类型有岗位、多岗位
    		if (rst.getDBType().equals("oracle")||rst.getDBType().equals("db2")){
    			sltcountsql	 += " and ','||to_char(jobobj)||',' like '%," + objid + ",%' ";
    		}else{
    			sltcountsql	 += " and ','+convert(varchar,jobobj)+',' like '%," + objid + ",%' ";
    		}
        }else{
        	sltcountsql+= " AND objid=" + objid;
        }
    } else {
        sqlfrom = "("
            + " select wfgdl.id, wfng.groupname, wfnb.nodename, wffn.nodetype, wfb.workflowname, wfb.workflowtype,wfb.subcompanyid "
            + " from workflow_groupdetail wfgdl "
            + "    LEFT join  workflow_nodegroup wfng on wfgdl.groupid=wfng.id "
            + "    LEFT JOIN workflow_nodebase wfnb ON wfng.nodeid=wfnb.id "
            + "    LEFT JOIN workflow_flownode wffn ON wffn.nodeid=wfnb.id "
            + "    LEFT join workflow_base wfb ON wfb.id=wffn.workflowid "
			+ " WHERE " 
            + "  wfgdl.type=-1 AND wfgdl.objid=-1"
            + ") tbl";
        sqlWhere += " and 1=2";
    }
    
    String sqlfields = "id, workflowtype, workflowname, nodename, nodetype, groupname,subcompanyid";
    String sqlorderby = "id";
	 
    new BaseBean().writeLog("sqlfields+sqlfrom+sqlWhere = "+sqlfields+sqlfrom+sqlWhere);
    String operateString = ""
            + "<operates width=\"20%\">"
            + "    <popedom></popedom> "
            + "    <operate href=\"javascript:viewDetail();\" isalwaysshow='true' text=\""+SystemEnv.getHtmlLabelName(1293,user.getLanguage())+"\"/>"
            + "</operates>";
    String tableString = "<table  pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_TRANSFER_PERMISSIONSEARCHRESULTIFRAME,user.getUID())+"\" tabletype=\"checkbox\">"
            + "<sql backfields=\""
            + sqlfields
            + "\" sqlwhere=\""
            + Util.toHtmlForSplitPage(sqlWhere)
            + "\" sqlform=\""
            + sqlfrom
            + "\" sqlorderby=\""
            + sqlorderby
            + "\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"
//            + operateString
            + "<head>"
            + "    <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"workflowtype\" transmethod=\"weaver.workflow.transfer.PermissionTransferMgr.getWfTypeNameByTypeID\" orderkey=\"workflowtype\"/>";
			if(detachable == 1){
				tableString += "    <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(81651,user.getLanguage())+"\" column=\"workflowname\" otherpara=\"column:subcompanyid\" transmethod=\"weaver.workflow.transfer.PermissionTransferMgr.getWorkflowName\" orderkey=\"workflowname\"/>" ;
			}else{
				tableString += "    <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(81651,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>" ;
			}
            tableString += "    <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15070,user.getLanguage())+"\" column=\"nodename\" orderkey=\"nodename\"/>"
            + "    <col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15536,user.getLanguage())+"\" column=\"nodetype\" transmethod=\"weaver.workflow.transfer.PermissionTransferMgr.getNodeTypeDescByTypeID\" orderkey=\"nodetype\"/>"
            + "    <col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15072,user.getLanguage())+"\" column=\"groupname\" orderkey=\"groupname\"/>"
            + "    <col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(28481,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.workflow.transfer.PermissionTransferMgr.getPermissionDetail\" orderkey=\"nodetype\"/>"
            + "</head>" + "</table>";
            
	int count = 0;
	if (!"".equals(sltcountsql)) {
	    RecordSet rs = new RecordSet();
	    rs.execute(sltcountsql);
	    if (rs.next()) {
	        count = Util.getIntValue(rs.getString("count"), 0);
	    }
	}
%>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
		$(function () {
			parent.initCount(<%=count %>);
		});
		
		function weaverTableCallbackFunction() {
			$(":checkbox[name=chkInTableTag]").attr("checked", "checked");
			$(":checkbox[name=_allselectcheckbox]").attr("checked", "checked");
			$("[name=chkInTableTag]").bind("click", function () {
				parent.initCount($("[name=chkInTableTag]:checkbox:checked").length);
			});
			
			$(":checkbox[name=_allselectcheckbox]").click(function () {
				if ($(this).attr("checked") == "checked" || $(this).attr("checked") == true) {
					parent.initCount($("[name=chkInTableTag]:checkbox").length);
				} else {
					parent.initCount(0);
				}
			});
		}
 		</script>
	</head>
	<%
	    String imagefilename = "/images/hdMaintenance_wev8.gif";
	    String titlename = SystemEnv.getHtmlLabelName(70, user.getLanguage())+ ":" + SystemEnv.getHtmlLabelName(68, user.getLanguage());
	    String needfav = "1";
	    String needhelp = "";
	    String rulename = Util.null2String(request.getParameter("rulename"));
	    //String depid = Util.null2String(request.getParameter("depid"));
	%>
	<BODY>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_TRANSFER_PERMISSIONSEARCHRESULTIFRAME%>"/>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<wea:SplitPageTag tableString='<%=tableString%>' isShowTopInfo="false" mode="run" />
	</BODY>
</HTML>
