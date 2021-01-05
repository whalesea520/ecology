
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause"
	scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WorkFlowUtil"
	class="weaver.workflow.workflow.WorkFlowUtil" scope="page" />

<!--
  此页面为批量打印的中间处理页面。
  此页面用于将从WorkflowMultiPrintPageFrame.jsp页面中提交的表单字段查询条件拼接成sql的where条件，
  WorkflowMultiPrintPageFrame.jsp页面中的系统字段条件在本页面中不进行处理，统一由下一个页面处理。
  然后再次请求转发到数据查询和结果展示页面。

  本页面实现的功能：
    拼接自定义查询条件；
    查询符合条件的requestid；
    将requestid存入request；
    转发到下一个页面WorkflowMultiPrintListTab.jsp；
-->
<%
	//要跳转到的页面,此页面为查询结果最终展示页面
	final String forwardPage = "WorkflowMultiPrintListTab.jsp";

	boolean isoracle = (RecordSet.getDBType()).equals("oracle");
	boolean isdb2 = (RecordSet.getDBType()).equals("db2");

	String isbill = "0";
	String formID = "0";
	String workflowid = Util.null2String(request
			.getParameter("workflowid"));

	if (workflowid != null && !workflowid.equals("")) {

		RecordSet
				.executeSql("select formid,isbill from workflow_base where id="
						+ workflowid);
		if (RecordSet.next()) {
			formID = RecordSet.getString("formid");
			isbill = RecordSet.getString("isbill");
		}

		//下面开始表单字段的查询条件
		String[] checkcons = request.getParameterValues("check_con");
      //  System.err.println("checkcons"+Arrays.toString(checkcons));
		String sqlwhere = " ";
		if (checkcons != null) {
			for (int i = 0; i < checkcons.length; i++) {

				String tmpid = "" + checkcons[i];
				String tmpcolname = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_colname"));
				String htmltype = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_htmltype"));
				String type = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_type"));
				String tmpopt = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_opt"));
				String tmpvalue = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_value"));
				//System.err.println("tmpvalue:"+tmpvalue);
				if(tmpvalue == null || tmpvalue.equals("")){
					continue;
				}
				String tmpname = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_name"));
				String tmpopt1 = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_opt1"));
				String tmpvalue1 = ""
						+ Util.null2String(request.getParameter("con"
								+ tmpid + "_value1"));
                //System.err.println("tmpname："+tmpname);
				//是自定义表单
				String isnull = "nvl";
				if (!rs2.getDBType().equals("oracle")) {
					isnull = "isNull";
				}

				if (isbill.equals("1")) {
					rs2
							.executeSql("select t.id, t.fieldname, t.detailtable, bdt.id,bil.tablename,"
									+ isnull
									+ "(bil.detailkeyfield,'mainid') detailkeyfield from workflow_billfield t, Workflow_billdetailtable bdt,workflow_bill bil where bil.id = bdt.billid and t.detailtable = bdt.tablename and t.id = "
									+ tmpid + " and viewtype = 1 "); // 查询工作流单据表的信息
				} else {//是系统表单,查询是否是明细表字段属性
					rs2
							.executeSql("select * from workflow_formdictdetail where id= "
									+ tmpid);
				}
				//如果是明细表字段,进行下面的处理.
				if (rs2.next()) {
					String tempsql = WorkFlowUtil.getQuerySqlCondition(
							"dt", htmltype, type, tmpid, tmpopt,
							tmpopt1, tmpvalue, tmpvalue1, tmpcolname,
							isoracle, isdb2);
					//如果是单据,添加明细表的条件!!
					if (isbill.equals("1")) {
						//得到明细字段的列名.
						String fdname = rs2.getString("fieldname");
						//明细表名
						String dtname = rs2.getString("detailtable");
						//主表名
						String tbname = rs2.getString("tablename");
						//主表明细表关联属性
						String dkeyfield = rs2
								.getString("detailkeyfield");
						sqlwhere += " and exists( select 1 from "
								+ dtname + " dt where dt." + dkeyfield
								+ "=d.id " + tempsql + ") ";
					} else {
						//得到系统表单的明细表属性列名
						String dtfieldname = rs2.getString("fieldname");
						//系统表单的明细表就是一张表,叫做Workflow_formdetail,主表和明细表是通过requestid关联.
						sqlwhere += " and exists( select 1 from Workflow_formdetail dt where dt.requestid=t1.requestid "
								+ tempsql + ") ";
					}
				} else { //不是明细表字段进行下面的处理.
					sqlwhere += WorkFlowUtil.getQuerySqlCondition("d",
							htmltype, type, tmpid, tmpopt, tmpopt1,
							tmpvalue, tmpvalue1, tmpcolname, isoracle,
							isdb2);
				}
			}
		}

		//查询符合自定查询条件的requesetid
		String querySql = "";
		if (isbill.equals("0")) {
			querySql = "select requestid from workflow_form d where d.billformid="
					+ formID + sqlwhere;
		} else {
			RecordSet
					.execute("select tablename from workflow_bill where id = "
							+ formID);
			String tableName = "";
			if (RecordSet.next()) {
				tableName = RecordSet.getString("tablename");
			}

			querySql = "select requestid from " + tableName
					+ " d where 1=1 " + sqlwhere;
		}
		/*
		RecordSet.execute(querySql);
		*/
		String requestIdList = "(";
		boolean hasData = true;
		/*
		while (RecordSet.next()) {
			hasData = true;
			requestIdList += (RecordSet.getString("requestid") + ",");
		}
		if (hasData)
			requestIdList = requestIdList.substring(0, requestIdList
					.length() - 1);
			requestIdList += ")";

		if (requestIdList.length() == 2) {
			requestIdList = "(0)";
		}
		*/
		request.setAttribute("CustomSearch_IsNeed", "true");
		request.setAttribute("CustomSearch_RequestIdList", querySql);
		request.getRequestDispatcher(forwardPage).forward(request,
				response);
	} else {
		request.getRequestDispatcher(forwardPage).forward(request,
				response);
	}
%>