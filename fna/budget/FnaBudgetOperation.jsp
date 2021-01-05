
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="weaver.fna.maintenance.FnaBudgetInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="BudgetApproveWFHandler" class="weaver.fna.budget.BudgetApproveWFHandler" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="FnaBudgetUtil" class="weaver.fna.budget.FnaBudgetUtil" scope="page" />
<%
	boolean ifbottomtotop =  false;//是否启用从下至上编辑财务费用设置
	int checkFlag = 3;
	RecordSet.executeSql("select ifbottomtotop from fnasystemset");
	if(RecordSet.next()){
		if(RecordSet.getInt("ifbottomtotop")==1){
			ifbottomtotop =  true;
			checkFlag = 4;
		}
	}

		String fnabudgetinfoid_hrm = Util.null2String(request.getParameter("fnabudgetinfoid_hrm"));//ID
    String operation = Util.null2String(request.getParameter("operation"));
    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    String oldfnabudgetinfoid = fnabudgetinfoid;
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID

    String budgetyears = "";//期间年
    String revision = "";//版本
    String status = "";//状态
    String budgetstatus = "";//审批状态

    String sqlstr = "";
    String para = "";
    char separator = Util.getSeparator();
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) + " " +
            Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
            Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
            Util.add0(today.get(Calendar.SECOND), 2);
    //取数据
    sqlstr = " select budgetperiods,budgetorganizationid,organizationtype,revision,status,budgetstatus from FnaBudgetInfo where id = " + fnabudgetinfoid;
    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        budgetperiods = RecordSet.getString("budgetperiods");
        organizationid = RecordSet.getString("budgetorganizationid");
        organizationtype = RecordSet.getString("organizationtype");
        revision = RecordSet.getString("revision");
        status = RecordSet.getString("status");
        budgetstatus = RecordSet.getString("budgetstatus");
    } else {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    //取当前期间的年份
    if ("".equals(budgetyears)) {
        sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetyears = RecordSet.getString("fnayear");
        }
    }

    boolean canEdit = true;
//检查权限
    int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
    if ("0".equals(organizationtype)) {
        if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user)) right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user),0);
    } else {
        if (Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0) == 1) {//如果分权
            int subCompanyId = 0;
            if("1".equals(organizationtype))
                subCompanyId = (new Integer(organizationid)).intValue();
            else if("2".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(organizationid))).intValue();
            else if("3".equals(organizationtype))
                 subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid)))).intValue();
            right = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "SubBudget:Maint",subCompanyId);
        } else {
            if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
                right = Util.getIntValue(HrmUserVarify.getRightLevel("SubBudget:Maint", user),0);
        }
    }
    if (right < 1) canEdit = false;//不可编辑

    if(!canEdit) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }

    String[] BUDGET_CALCULETE_TYPE = new String[]{"canusedbudget", "allottedbudget", "originalbudget", "newbudget", "addedbudget"};
    String[] BUDGET_CALCULETE_TIME_TYPE = new String[]{"month", "quarter", "halfyear", "year"};

    int topage = Util.getIntValue(Util.null2String(request.getParameter("topage")),1);
    int opage = Util.getIntValue(Util.null2String(request.getParameter("page")),1);
    int showtab = Util.getIntValue(Util.null2String(request.getParameter("showtab")),1);
    String wrapshow = Util.null2String(request.getParameter("wrapshow"));
    
    //保存某版本为草稿
    if (operation.equals("savetodraft")) {
        status = "0";
        budgetstatus = "0";
        revision = "0";
        //如果已有草稿，则查找删除
        RecordSet.executeSql(
                " select id from FnaBudgetInfo where "
                        + " budgetorganizationid = " + organizationid
                        + " and organizationtype = " + organizationtype
                        + " and budgetperiods = " + budgetperiods
                        + " and status = 0 ");
        while(RecordSet.next()) {
            String existfnabudgetinfoid = RecordSet.getString(1);
            RecordSet2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = " + existfnabudgetinfoid);
            RecordSet2.executeSql("delete from FnaBudgetInfo where id = " + existfnabudgetinfoid);
        }
    	
        para = budgetperiods + separator//budgetperiods
        	 + organizationid + separator//budgetorganizationid
        	 + organizationtype + separator//organizationtype
        	 + budgetstatus + separator//budgetstatus
        	 + user.getUID() + separator//createrid
        	 + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
        	 + revision + separator//revision
        	 + status;//status
		RecordSet2.executeProc("FnaBudgetInfo_Insert", para);
		if (RecordSet2.next()) fnabudgetinfoid = RecordSet2.getString(1);

		String usedfnabudgetinfoid = oldfnabudgetinfoid;
		RecordSet2.executeSql(
            		"insert into FnaBudgetInfoDetail(budgetinfoid,budgetperiods,budgettypeid,budgetaccount,budgetperiodslist)"
                    + " select " + fnabudgetinfoid + ",budgetperiods,budgettypeid,budgetaccount,budgetperiodslist"
                    + " from FnaBudgetInfoDetail "
                    + " where budgetinfoid = " + usedfnabudgetinfoid
    	);
        response.sendRedirect("FnaBudgetEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&showtab="+showtab+"&page="+opage+"&wrapshow="+wrapshow+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }
    
    
    if (operation.equals("savepage")) {
        int check = FnaBudgetInfoComInfo.checkBudget(request,1);

        if (check != 0) {
            response.sendRedirect("FnaBudgetEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&showtab="+showtab+"&page="+opage+"&wrapshow="+wrapshow+"&msgid=" + check+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
            return;
        }

        //如果修改的是生效版本，则根据生效版本新建草稿
        if (!"0".equals(status)) {
            status = "0";
            budgetstatus = "0";
            revision = "0";
            //如果已有草稿，则查找删除
            RecordSet.executeSql(
                    " select id from FnaBudgetInfo where "
                            + " budgetorganizationid = " + organizationid
                            + " and organizationtype = " + organizationtype
                            + " and budgetperiods = " + budgetperiods
                            + " and status = 0 ");
            while(RecordSet.next()) {
                String existfnabudgetinfoid = RecordSet.getString(1);
                RecordSet2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = " + existfnabudgetinfoid);
                RecordSet2.executeSql("delete from FnaBudgetInfo where id = " + existfnabudgetinfoid);

                //System.out.println("delete existed draft");
            }
            para = budgetperiods + separator//budgetperiods
                    + organizationid + separator//budgetorganizationid
                    + organizationtype + separator//organizationtype
                    + budgetstatus + separator//budgetstatus
                    + user.getUID() + separator//createrid
                    + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                    + revision + separator//revision
                    + status;//status
            RecordSet.executeProc("FnaBudgetInfo_Insert", para);
            if (RecordSet.next()){
            	fnabudgetinfoid = RecordSet.getString(1);
                RecordSet2.executeSql("insert into FnaBudgetInfoDetail(budgetinfoid,budgetperiods,budgettypeid,budgetresourceid,budgetcrmid,budgetprojectid,budgetaccount,budgetremark,budgetperiodslist) (select "+fnabudgetinfoid+",budgetperiods,budgettypeid,budgetresourceid,budgetcrmid,budgetprojectid,budgetaccount,budgetremark,budgetperiodslist from FnaBudgetInfoDetail where budgetinfoid = " + oldfnabudgetinfoid + ")");
            }
        }

        String[] budgetids = request.getParameterValues("FnaBudgetfeeTypeIDs");
        String[] budgetvaluenum = request.getParameterValues("FnaBudgetfeeTypeSaveValueNum");

        for (int i = 0; budgetids != null && budgetvaluenum != null && i < budgetids.length; i++) {
            String getstr = "";
            String flag = "_";
            if (budgetvaluenum[i].equals("12")) getstr += BUDGET_CALCULETE_TIME_TYPE[0];
            else if (budgetvaluenum[i].equals("4")) getstr += BUDGET_CALCULETE_TIME_TYPE[1];
            else if (budgetvaluenum[i].equals("2")) getstr += BUDGET_CALCULETE_TIME_TYPE[2];
            else if (budgetvaluenum[i].equals("1")) getstr += BUDGET_CALCULETE_TIME_TYPE[3];
            getstr += flag;
            getstr += budgetids[i];
            getstr += flag;
            getstr += BUDGET_CALCULETE_TYPE[3];
            getstr += flag;

            for (int j = 1; j <= (new Integer(budgetvaluenum[i])).intValue(); j++) {
                String getstr1 = getstr;
                if ("1".equals(budgetvaluenum[i])) getstr1 += "sum";
                else getstr1 += j;

                String account = Util.null2String(request.getParameter(getstr1));
				if (account==null||"".equals(account)) account="0";
                para = fnabudgetinfoid + separator
                        + budgetperiods + separator
                        + j + separator
                        + budgetids[i] + separator
                        + "" + separator
                        + "" + separator
                        + "" + separator
                        + account + separator
                        + "";

                if (account!=null&&!"".equals(account)&&Util.getDoubleValue(account) > 0d)
                    RecordSet.executeProc("FnaBudgetInfoDetail_Insert", para);
            }
        }
        //状态设置为草稿
        para = fnabudgetinfoid + separator
                + status + separator
                + revision + separator
                + budgetstatus;

        RecordSet.executeProc("FnaBudgetInfo_UpdateStatus", para);

        response.sendRedirect("FnaBudgetEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&showtab="+showtab+"&page="+topage+"&wrapshow="+wrapshow+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }

    //保存
    if (operation.equals("editbudget")) {
        int check = FnaBudgetInfoComInfo.checkBudget(request,1);

        if (check != 0) {
            response.sendRedirect("FnaBudgetEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&msgid=" + check+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
            return;
        }

        //如果修改的是生效版本，则根据生效版本新建草稿
        if (!"0".equals(status)) {
            status = "0";
            budgetstatus = "0";
            revision = "0";
            //如果已有草稿，则查找删除
            RecordSet.executeSql(
                    " select id from FnaBudgetInfo where "
                            + " budgetorganizationid = " + organizationid
                            + " and organizationtype = " + organizationtype
                            + " and budgetperiods = " + budgetperiods
                            + " and status = 0 ");
            while(RecordSet.next()) {
                String existfnabudgetinfoid = RecordSet.getString(1);
                RecordSet2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = " + existfnabudgetinfoid);
                RecordSet2.executeSql("delete from FnaBudgetInfo where id = " + existfnabudgetinfoid);

                //System.out.println("delete existed draft");
            }
            para = budgetperiods + separator//budgetperiods
                    + organizationid + separator//budgetorganizationid
                    + organizationtype + separator//organizationtype
                    + budgetstatus + separator//budgetstatus
                    + user.getUID() + separator//createrid
                    + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                    + revision + separator//revision
                    + status;//status
            RecordSet.executeProc("FnaBudgetInfo_Insert", para);
            if (RecordSet.next()){
            	fnabudgetinfoid = RecordSet.getString(1);
                RecordSet2.executeSql("insert into FnaBudgetInfoDetail(budgetinfoid,budgetperiods,budgettypeid,budgetresourceid,budgetcrmid,budgetprojectid,budgetaccount,budgetremark,budgetperiodslist) (select "+fnabudgetinfoid+",budgetperiods,budgettypeid,budgetresourceid,budgetcrmid,budgetprojectid,budgetaccount,budgetremark,budgetperiodslist from FnaBudgetInfoDetail where budgetinfoid = " + oldfnabudgetinfoid + ")");
            }
        }

        String[] budgetids = request.getParameterValues("FnaBudgetfeeTypeIDs");
        String[] budgetvaluenum = request.getParameterValues("FnaBudgetfeeTypeSaveValueNum");

        for (int i = 0; budgetids != null && budgetvaluenum != null && i < budgetids.length; i++) {
            String getstr = "";
            String flag = "_";
            if (budgetvaluenum[i].equals("12")) getstr += BUDGET_CALCULETE_TIME_TYPE[0];
            else if (budgetvaluenum[i].equals("4")) getstr += BUDGET_CALCULETE_TIME_TYPE[1];
            else if (budgetvaluenum[i].equals("2")) getstr += BUDGET_CALCULETE_TIME_TYPE[2];
            else if (budgetvaluenum[i].equals("1")) getstr += BUDGET_CALCULETE_TIME_TYPE[3];
            getstr += flag;
            getstr += budgetids[i];
            getstr += flag;
            getstr += BUDGET_CALCULETE_TYPE[3];
            getstr += flag;

            for (int j = 1; j <= (new Integer(budgetvaluenum[i])).intValue(); j++) {
                String getstr1 = getstr;
                if ("1".equals(budgetvaluenum[i])) getstr1 += "sum";
                else getstr1 += j;

                String account = Util.null2String(request.getParameter(getstr1));
				if (account==null||"".equals(account)) account="0";
                para = fnabudgetinfoid + separator
                        + budgetperiods + separator
                        + j + separator
                        + budgetids[i] + separator
                        + "" + separator
                        + "" + separator
                        + "" + separator
                        + account + separator
                        + "";

                //if (account!=null&&!"".equals(account)&&Util.getDoubleValue(account) > 0d)
                    RecordSet.executeProc("FnaBudgetInfoDetail_Insert", para);
            }
        }
        //状态设置为草稿
        para = fnabudgetinfoid + separator
                + status + separator
                + revision + separator
                + budgetstatus;

        RecordSet.executeProc("FnaBudgetInfo_UpdateStatus", para);

        response.sendRedirect("FnaBudgetView.jsp?fnabudgetinfoid=" + fnabudgetinfoid+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }

    //提交审批
    if (operation.equals("processfnabudget")) {
        int check = FnaBudgetInfoComInfo.checkBudget(request,2);

        if (check != 0) {
            response.sendRedirect("FnaBudgetEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&msgid=" + check+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
            return;
        }

        //查找原来生效版本,将原来的生效版本变更为历史
        String inusefnabudgetinfoid = "";
        String inusestatus = "";
        String inuserevision = "";
        String inusebudgetstatus = "";
        RecordSet.executeSql(
                " select id,revision,budgetstatus,status from FnaBudgetInfo where "
                        + " budgetorganizationid = " + organizationid
                        + " and organizationtype = " + organizationtype
                        + " and budgetperiods = " + budgetperiods
                        + " and status = 1 ");
        if (RecordSet.next()) {
            inusefnabudgetinfoid = Util.null2String(RecordSet.getString(1));
            inuserevision = Util.null2String(RecordSet.getString(2));
            inusebudgetstatus = Util.null2String(RecordSet.getString(3));
            inusestatus = Util.null2String(RecordSet.getString(4));
            //变为历史状态
            inusestatus = "2";
            para = inusefnabudgetinfoid + separator
                    + inusestatus + separator
                    + inuserevision + separator
                    + inusebudgetstatus;
            RecordSet2.executeProc("FnaBudgetInfo_UpdateStatus", para);
        }

        //如果是草稿,将草稿变更为新版本
        if ("0".equals(status)) {
            status = "3";
            budgetstatus = "0";
            RecordSet.executeSql(
                    " select max(revision)+1 from FnaBudgetInfo where "
                            + " budgetorganizationid = " + organizationid
                            + " and organizationtype = " + organizationtype
                            + " and budgetperiods = " + budgetperiods);
            if (RecordSet.next()) {
                revision = ""+Util.getIntValue(Util.null2String(RecordSet.getString(1)),1);
            }
            para = fnabudgetinfoid + separator
                    + status + separator
                    + revision + separator
                    + budgetstatus;
            RecordSet2.executeProc("FnaBudgetInfo_UpdateStatus", para);
        } else {
            //保存新版本
            status = "3";
            budgetstatus = "0";
            RecordSet.executeSql(
                    " select max(revision)+1 from FnaBudgetInfo where "
                            + " budgetorganizationid = " + organizationid
                            + " and organizationtype = " + organizationtype
                            + " and budgetperiods = " + budgetperiods);
            if (RecordSet.next()) {
                revision = ""+Util.getIntValue(Util.null2String(RecordSet.getString(1)),1);
            }
            para = budgetperiods + separator//budgetperiods
                    + organizationid + separator//budgetorganizationid
                    + organizationtype + separator//organizationtype
                    + budgetstatus + separator//budgetstatus
                    + user.getUID() + separator//createrid
                    + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                    + revision + separator//revision
                    + status;//status
            RecordSet.executeProc("FnaBudgetInfo_Insert", para);
            RecordSet.next();
            fnabudgetinfoid = RecordSet.getString(1);
        }

        String[] budgetids = request.getParameterValues("FnaBudgetfeeTypeIDs");
        String[] budgetvaluenum = request.getParameterValues("FnaBudgetfeeTypeSaveValueNum");

        for (int i = 0; budgetids != null && budgetvaluenum != null && i < budgetids.length; i++) {
            String getstr = "";
            String flag = "_";
            if (budgetvaluenum[i].equals("12")) getstr += BUDGET_CALCULETE_TIME_TYPE[0];
            else if (budgetvaluenum[i].equals("4")) getstr += BUDGET_CALCULETE_TIME_TYPE[1];
            else if (budgetvaluenum[i].equals("2")) getstr += BUDGET_CALCULETE_TIME_TYPE[2];
            else if (budgetvaluenum[i].equals("1")) getstr += BUDGET_CALCULETE_TIME_TYPE[3];
            getstr += flag;
            getstr += budgetids[i];
            getstr += flag;
            getstr += BUDGET_CALCULETE_TYPE[3];
            getstr += flag;

            for (int j = 1; j <= (new Integer(budgetvaluenum[i])).intValue(); j++) {
                String getstr1 = getstr;
                if ("1".equals(budgetvaluenum[i])) getstr1 += "sum";
                else getstr1 += j;

                String account = Util.null2String(request.getParameter(getstr1));
				if (account==null||"".equals(account)) account="0";
                para = fnabudgetinfoid + separator
                        + budgetperiods + separator
                        + j + separator
                        + budgetids[i] + separator
                        + "" + separator
                        + "" + separator
                        + "" + separator
                        + account + separator
                        + "";

                //if (account!=null&&!"".equals(account)&&Util.getDoubleValue(account) > 0d)
                    RecordSet.executeProc("FnaBudgetInfoDetail_Insert", para);
            }
        }

        // Todo 提交流程
        String subcomid = "0";//分部ID
        if ("1".equals(organizationtype))
            subcomid = organizationid;
        else if ("2".equals(organizationtype))
            subcomid = DepartmentComInfo.getSubcompanyid1(organizationid);
        else if ("3".equals(organizationtype))
            subcomid = DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid));
        //取得与分部项目关联的工作流ID
        int workflowid = BudgetApproveWFHandler.getApproveWFId((new Integer(subcomid)).intValue());
        
        RecordSet.executeSql(" update FnaBudgetInfo set remark = '" + SystemEnv.getHtmlLabelName(367, user.getLanguage()) + "' where id = " + fnabudgetinfoid);
        
        //提交流程
        BudgetApproveWFHandler.SetWorkFlowID(workflowid);
        BudgetApproveWFHandler.SetCreater(user);
        BudgetApproveWFHandler.SetRequestName(SystemEnv.getHtmlLabelName(386, user.getLanguage()) + SystemEnv.getHtmlLabelName(359, user.getLanguage()));
        BudgetApproveWFHandler.SetBudgetId((new Integer(fnabudgetinfoid).intValue()));
        int message = BudgetApproveWFHandler.NewFlow();
		if(message==-1){//流程触发失败，那么将流程设置为草稿状态
			RecordSet.executeSql("update fnabudgetinfo set status = 0,revision=0 where id = " + fnabudgetinfoid);
		}
        response.sendRedirect("FnaBudgetView.jsp?fnabudgetinfoid=" + fnabudgetinfoid+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }

    //批准生效
    if (operation.equals("approvefnabudget")) {
        int check = FnaBudgetInfoComInfo.checkBudget(request,checkFlag);

        if (check != 0) {
            response.sendRedirect("FnaBudgetEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&msgid=" + check+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
            return;
        }

        //查找原来生效版本,将原来的生效版本变更为历史
        List fnaNeedChange = new ArrayList();
        String inusefnabudgetinfoid = "";
        String inusestatus = "";
        String inuserevision = "";
        String inusebudgetstatus = "";
        RecordSet.executeSql(
                " select id,revision,budgetstatus,status from FnaBudgetInfo where "
                        + " budgetorganizationid = " + organizationid
                        + " and organizationtype = " + organizationtype
                        + " and budgetperiods = " + budgetperiods
                        + " and status = 1 ");
        if (RecordSet.next()) {
            inusefnabudgetinfoid = Util.null2String(RecordSet.getString(1));
            inuserevision = Util.null2String(RecordSet.getString(2));
            inusebudgetstatus = Util.null2String(RecordSet.getString(3));
            inusestatus = Util.null2String(RecordSet.getString(4));
            //变为历史状态
            inusestatus = "2";
            para = inusefnabudgetinfoid + separator
                    + inusestatus + separator
                    + inuserevision + separator
                    + inusebudgetstatus;
            RecordSet2.executeProc("FnaBudgetInfo_UpdateStatus", para);
        }

        //如果是草稿,将草稿变更为新版本
        if ("0".equals(status)) {
            status = "1";
            budgetstatus = "0";
            RecordSet.executeSql(
                    " select max(revision)+1 from FnaBudgetInfo where "
                            + " budgetorganizationid = " + organizationid
                            + " and organizationtype = " + organizationtype
                            + " and budgetperiods = " + budgetperiods);
            if (RecordSet.next()) {
                revision = ""+Util.getIntValue(Util.null2String(RecordSet.getString(1)),1);
            }
            para = fnabudgetinfoid + separator
                    + status + separator
                    + revision + separator
                    + budgetstatus;
            RecordSet2.executeProc("FnaBudgetInfo_UpdateStatus", para);
        } else {
            //保存新版本
            status = "1";
            budgetstatus = "0";
            RecordSet.executeSql(
                    " select max(revision)+1 from FnaBudgetInfo where "
                            + " budgetorganizationid = " + organizationid
                            + " and organizationtype = " + organizationtype
                            + " and budgetperiods = " + budgetperiods);
            if (RecordSet.next()) {
                revision = ""+Util.getIntValue(Util.null2String(RecordSet.getString(1)),1);
            }
            para = budgetperiods + separator//budgetperiods
                    + organizationid + separator//budgetorganizationid
                    + organizationtype + separator//organizationtype
                    + budgetstatus + separator//budgetstatus
                    + user.getUID() + separator//createrid
                    + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                    + revision + separator//revision
                    + status;//status
            RecordSet.executeProc("FnaBudgetInfo_Insert", para);
            RecordSet.next();
            fnabudgetinfoid = RecordSet.getString(1);
        }

        String[] budgetids = request.getParameterValues("FnaBudgetfeeTypeIDs");
        String[] budgetvaluenum = request.getParameterValues("FnaBudgetfeeTypeSaveValueNum");

        for (int i = 0; budgetids != null && budgetvaluenum != null && i < budgetids.length; i++) {
            String getstr = "";
            String flag = "_";
            if (budgetvaluenum[i].equals("12")) getstr += BUDGET_CALCULETE_TIME_TYPE[0];
            else if (budgetvaluenum[i].equals("4")) getstr += BUDGET_CALCULETE_TIME_TYPE[1];
            else if (budgetvaluenum[i].equals("2")) getstr += BUDGET_CALCULETE_TIME_TYPE[2];
            else if (budgetvaluenum[i].equals("1")) getstr += BUDGET_CALCULETE_TIME_TYPE[3];
            getstr += flag;
            getstr += budgetids[i];
            getstr += flag;
            getstr += BUDGET_CALCULETE_TYPE[3];
            getstr += flag;

            for (int j = 1; j <= (new Integer(budgetvaluenum[i])).intValue(); j++) {
                String getstr1 = getstr;
                if ("1".equals(budgetvaluenum[i])) getstr1 += "sum";
                else getstr1 += j;

                String account = Util.null2String(request.getParameter(getstr1));
				if (account==null||"".equals(account)) account="0";
                para = fnabudgetinfoid + separator
                        + budgetperiods + separator
                        + j + separator
                        + budgetids[i] + separator
                        + "" + separator
                        + "" + separator
                        + "" + separator
                        + account + separator
                        + "";



                //if (account!=null&&!"".equals(account)&&Util.getDoubleValue(account) > 0d)
                    RecordSet.executeProc("FnaBudgetInfoDetail_Insert", para);
            }
        }

		//变更的科目预算

		//新预算 开放从下往上调整
		if(ifbottomtotop){
	        RecordSet.executeSql("select * from FnaBudgetInfoDetail where budgetinfoid="+fnabudgetinfoid);
			while(RecordSet.next()){
				String tempbudgetperiods = RecordSet.getString("budgetperiods");
				int tempbudgetperiodslist = Util.getIntValue(RecordSet.getString("budgetperiodslist"),0); 
				String tempbudgettypeid = RecordSet.getString("budgettypeid"); 
				double tempbudgetaccount = Util.getDoubleValue(RecordSet.getString("budgetaccount"),0);
				double diff = 0;
	            //历史预算
	            if("".equals(inusefnabudgetinfoid)){
	            	diff = tempbudgetaccount;
	            }else{
		            RecordSet3.executeSql("select budgetaccount from FnaBudgetInfoDetail where budgetinfoid="+inusefnabudgetinfoid
		            		+" and budgetperiods="+tempbudgetperiods+" and budgetperiodslist="+tempbudgetperiodslist+" and budgettypeid="+tempbudgettypeid);
		            if(RecordSet3.next()){
		            	diff = tempbudgetaccount-Util.getDoubleValue(RecordSet3.getString("budgetaccount"),0);
		            }else{
		            	diff = tempbudgetaccount;
		            }
	            }
	           	if(diff !=0){
	           		double tempCanusedBudget = FnaBudgetInfoComInfo.getAvailableBudgetAmountNew(organizationid,organizationtype,tempbudgetperiods,String.valueOf(tempbudgetperiodslist),tempbudgettypeid);
	           		if(0>tempCanusedBudget){
	           		FnaBudgetInfo fnaBudgetInfo = new FnaBudgetInfo();
	           		fnaBudgetInfo.setBudgetinfoid(fnabudgetinfoid);
	           		fnaBudgetInfo.setBudgetperiods(tempbudgetperiods);
	           		fnaBudgetInfo.setBudgetperiodslist(tempbudgetperiodslist);
	           		fnaBudgetInfo.setBudgettypeid(tempbudgettypeid);
	           		fnaBudgetInfo.setDiffbudgetaccount(diff);
	           		fnaNeedChange.add(fnaBudgetInfo);
	           		}
	           	}
			}
	        
	        String tempFnabudgetinfoid = fnabudgetinfoid;
	        
	        //对部门的上级部门预算进行调整 如果修改的个人预算
	        if("3".equals(organizationtype) && fnaNeedChange.size()>0){
	            RecordSet.executeSql("select departmentid,subcompanyid1 from hrmresource where id="+organizationid);
	            String subcompanyid1 = "0";
	            if(RecordSet.next()){
	            	subcompanyid1 = RecordSet.getString("subcompanyid1");
	                String supdepid = RecordSet.getString("departmentid");
	                FnaBudgetUtil.changDepartmentFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid,subcompanyid1,supdepid);
	            }
	            
	            //对部门的上级分部预算进行调整
	            if(!"0".equals(subcompanyid1)){
	            	FnaBudgetUtil.changSubcompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid,subcompanyid1);
	            }
	            //对总部预算进行调整
	            FnaBudgetUtil.changeCompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid);
	        }
	        
	        //对部门的上级部门预算进行调整 如果修改的部门预算
	        if("2".equals(organizationtype) && fnaNeedChange.size()>0){
	            RecordSet.executeSql("select subcompanyid1,supdepid from HrmDepartment where id="+organizationid);
	            String subcompanyid1 = "0";
	            if(RecordSet.next()){
	            	subcompanyid1 = RecordSet.getString("subcompanyid1");
	                String supdepid = RecordSet.getString("supdepid");
	                FnaBudgetUtil.changDepartmentFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid,subcompanyid1,supdepid);
	            }
	            
	            //对部门的上级分部预算进行调整
	            if(!"0".equals(subcompanyid1)){
	            	FnaBudgetUtil.changSubcompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid,subcompanyid1);
	            }
	            //对总部预算进行调整
	            FnaBudgetUtil.changeCompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid);
	        }
	        
	        //对分部和分部上级部门预算进行调整 如果修改的分部预算
	        if("1".equals(organizationtype) && fnaNeedChange.size()>0){
	            //对部门的上级分部预算进行调整
	            RecordSet.executeSql("select supsubcomid from Hrmsubcompany where id="+organizationid);
	            String subcompanyid1 = "0";
	            if(RecordSet.next()){
	            	subcompanyid1 = RecordSet.getString("supsubcomid");
	                if(!"0".equals(subcompanyid1)){
	                	FnaBudgetUtil.changSubcompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid,subcompanyid1);
	                }
	            }
	
	            //对总部预算进行调整
	            FnaBudgetUtil.changeCompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,tempFnabudgetinfoid);
	        }
		}

        response.sendRedirect("FnaBudgetView.jsp?fnabudgetinfoid=" + fnabudgetinfoid+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }

    //保存草稿
    if (operation.equals("edittypebudget")) {
        String[] FnaOrgIDs = request.getParameterValues("FnaOrgIDs");
        String[] FnaOrgTypes = request.getParameterValues("FnaOrgTypes");
        String tmpfnabudgettypeid = Util.null2String(request.getParameter("fnabudgettypeid"));//科目ID

        for (int i = 0; FnaOrgIDs!=null && i < FnaOrgIDs.length; i++) {

            String tmporganizationid = FnaOrgIDs[i];
            String tmporganizationtype = FnaOrgTypes[i];
            String tmpbudgetperiods = budgetperiods;
            String tmpfnabudgetinfoid = "";
            String tmpbudgetstatus = "0";
            String tmprevision = "0";
            String tmpstatus = "0";
            String tmpaccount = "";

            if (status.equals("1")) {//如果当前部门是生效版本，将从所有分配对象的生效版本复制新建草稿，并更新当前科目
                RecordSet.executeSql(
                        " select id from FnaBudgetInfo where "
                                + " budgetorganizationid = " + tmporganizationid
                                + " and organizationtype = " + tmporganizationtype
                                + " and budgetperiods = " + tmpbudgetperiods
                                + " and status = 0 ");
                if (RecordSet.next()) {
                    String existfnabudgetinfoid = RecordSet.getString(1);
                    RecordSet2.executeSql("delete from FnaBudgetInfoDetail where budgetinfoid = " + existfnabudgetinfoid);
                    RecordSet2.executeSql("delete from FnaBudgetInfo where id = " + existfnabudgetinfoid);

                    //System.out.println("delete existed draft");
                }

                para = tmpbudgetperiods + separator//budgetperiods
                        + tmporganizationid + separator//budgetorganizationid
                        + tmporganizationtype + separator//organizationtype
                        + tmpbudgetstatus + separator//budgetstatus
                        + user.getUID() + separator//createrid
                        + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                        + tmprevision + separator//revision
                        + tmpstatus;//status
                RecordSet2.executeProc("FnaBudgetInfo_Insert", para);
                if (RecordSet2.next()) tmpfnabudgetinfoid = RecordSet2.getString(1);

                RecordSet.executeSql(
                        " select id from FnaBudgetInfo where "
                                + " budgetorganizationid = " + tmporganizationid
                                + " and organizationtype = " + tmporganizationtype
                                + " and budgetperiods = " + tmpbudgetperiods
                                + " and status = 1 ");
                if (RecordSet.next()) {
                    String usedfnabudgetinfoid = RecordSet.getString(1);
                    RecordSet2.executeSql(
                            "insert into FnaBudgetInfoDetail(budgetinfoid,budgetperiods,budgettypeid,budgetaccount,budgetperiodslist)"
                                    + " select " + tmpfnabudgetinfoid + ",budgetperiods,budgettypeid,budgetaccount,budgetperiodslist"
                                    + " from FnaBudgetInfoDetail "
                                    + " where budgetinfoid = " + usedfnabudgetinfoid
                    );

                    //System.out.println("copy existed used");
                }
            } else {//如果当前部门是草稿版本，将更新所有分配对象草稿的当前科目
                RecordSet.executeSql(
                        " select id from FnaBudgetInfo where "
                                + " budgetorganizationid = " + tmporganizationid
                                + " and organizationtype = " + tmporganizationtype
                                + " and budgetperiods = " + tmpbudgetperiods
                                + " and status = 0");
                if (RecordSet.next()) {
                    tmpfnabudgetinfoid = RecordSet.getString(1);
                } else {
                    para = tmpbudgetperiods + separator//budgetperiods
                            + tmporganizationid + separator//budgetorganizationid
                            + tmporganizationtype + separator//organizationtype
                            + tmpbudgetstatus + separator//budgetstatus
                            + user.getUID() + separator//createrid
                            + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                            + tmprevision + separator//revision
                            + tmpstatus;//status
                    RecordSet2.executeProc("FnaBudgetInfo_Insert", para);
                    if (RecordSet2.next()) tmpfnabudgetinfoid = RecordSet2.getString(1);
                }
            }

            String[] Fna_Budgets = request.getParameterValues("Fna_" + tmporganizationid + "_" + FnaOrgTypes[i] + "_Budgets");//预算值

            for (int j = 0; Fna_Budgets!=null && j < Fna_Budgets.length; j++) {

                tmpaccount = Util.null2String(Fna_Budgets[j]);

                //System.out.println(tmpaccount);
				if (tmpaccount==null||"".equals(tmpaccount)) tmpaccount="0";
                para = tmpfnabudgetinfoid + separator
                        + tmpbudgetperiods + separator
                        + (j + 1) + separator
                        + tmpfnabudgettypeid + separator
                        + "" + separator
                        + "" + separator
                        + "" + separator
                        + tmpaccount + separator
                        + "";
                //if (tmpaccount!=null&&!"".equals(tmpaccount)&&Util.getDoubleValue(tmpaccount) > 0d)
                    RecordSet.executeProc("FnaBudgetInfoDetail_Insert", para);
            }
        }
        response.sendRedirect("FnaBudgetTypeView.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&fnabudgettypeid=" + tmpfnabudgettypeid+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }

    //批准生效
    if (operation.equals("approvetypefnabudget")) {
    	if(!ifbottomtotop){
        int check = FnaBudgetInfoComInfo.checkTypeBudget(request);

        if (check != 0) {
            response.sendRedirect("FnaBudgetTypeEdit.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&msgid=" + check+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
            return;
        }
    	}

        String[] FnaOrgIDs = request.getParameterValues("FnaOrgIDs");
        String[] FnaOrgTypes = request.getParameterValues("FnaOrgTypes");
        String tmpfnabudgettypeid = Util.null2String(request.getParameter("fnabudgettypeid"));//科目ID
        List fnaNeedChange = new ArrayList();
        double[] diffAccount = new double[12];
        int accountLength = 0;
        String lastFnabudgetinfoid = "";

        
        for (int i = 0; FnaOrgIDs!=null && i < FnaOrgIDs.length; i++) {

            String tmporganizationid = FnaOrgIDs[i];
            String tmporganizationtype = FnaOrgTypes[i];
            String tmpbudgetperiods = budgetperiods;
            String tmpfnabudgetinfoid = "";
            String tmpbudgetstatus = "0";
            String tmprevision = "0";
            String tmpstatus = "0";
            String tmpaccount = "";

            //查找原来生效版本,将原来的生效版本变更为历史
            String inusefnabudgetinfoid = "";
            String inusestatus = "";
            String inuserevision = "";
            String inusebudgetstatus = "";
            RecordSet.executeSql(
                    " select id,revision,budgetstatus,status from FnaBudgetInfo where "
                            + " budgetorganizationid = " + tmporganizationid
                            + " and organizationtype = " + tmporganizationtype
                            + " and budgetperiods = " + tmpbudgetperiods
                            + " and status = 1 ");
            if (RecordSet.next()) {
                inusefnabudgetinfoid = Util.null2String(RecordSet.getString(1));
                lastFnabudgetinfoid = inusefnabudgetinfoid;
                inuserevision = Util.null2String(RecordSet.getString(2));
                inusebudgetstatus = Util.null2String(RecordSet.getString(3));
                inusestatus = Util.null2String(RecordSet.getString(4));
                //变为历史状态
                inusestatus = "2";
                para = inusefnabudgetinfoid + separator
                        + inusestatus + separator
                        + inuserevision + separator
                        + inusebudgetstatus;
                RecordSet2.executeProc("FnaBudgetInfo_UpdateStatus", para);
            }

            //如果当前部门是生效版本，从原生效版本复制新版本生效
            if (status.equals("1")) {

                RecordSet.executeSql(
                        " select max(revision)+1 from FnaBudgetInfo where "
                                + " budgetorganizationid = " + tmporganizationid
                                + " and organizationtype = " + tmporganizationtype
                                + " and budgetperiods = " + tmpbudgetperiods);
                if (RecordSet.next()) {
                    tmprevision = ""+Util.getIntValue(Util.null2String(RecordSet.getString(1)),1);
                    tmpstatus = "1";
                    tmpbudgetstatus = "0";
                }
                //从原生效版本新建新版本
                para = tmpbudgetperiods + separator//budgetperiods
                        + tmporganizationid + separator//budgetorganizationid
                        + tmporganizationtype + separator//organizationtype
                        + tmpbudgetstatus + separator//budgetstatus
                        + user.getUID() + separator//createrid
                        + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                        + tmprevision + separator//revision
                        + tmpstatus;//status
                RecordSet2.executeProc("FnaBudgetInfo_Insert", para);
                if (RecordSet2.next()) tmpfnabudgetinfoid = RecordSet2.getString(1);
                RecordSet.executeSql(
                        "insert into FnaBudgetInfoDetail(budgetinfoid,budgetperiods,budgettypeid,budgetaccount,budgetperiodslist)"
                                + " select " + tmpfnabudgetinfoid + ",budgetperiods,budgettypeid,budgetaccount,budgetperiodslist"
                                + " from FnaBudgetInfoDetail "
                                + " where budgetinfoid = " + inusefnabudgetinfoid
                );
            } else {
                //如果当前部门是草稿版本，将草稿版本变为新版本生效，更新科目
                //找到草稿，没找到新建
                RecordSet.executeSql(
                        " select id from FnaBudgetInfo where "
                                + " budgetorganizationid = " + tmporganizationid
                                + " and organizationtype = " + tmporganizationtype
                                + " and budgetperiods = " + tmpbudgetperiods
                                + " and status = 0 ");
                if (RecordSet.next()) {
                    tmpfnabudgetinfoid = RecordSet.getString(1);
                } else {
                    para = budgetperiods + separator//budgetperiods
                            + tmporganizationid + separator//budgetorganizationid
                            + tmporganizationtype + separator//organizationtype
                            + tmpbudgetstatus + separator//budgetstatus
                            + user.getUID() + separator//createrid
                            + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
                            + tmprevision + separator//revision
                            + tmpstatus;//status
                    RecordSet2.executeProc("FnaBudgetInfo_Insert", para);
                    if (RecordSet2.next()) tmpfnabudgetinfoid = RecordSet2.getString(1);
                }
                //更新为新版本并生效
                tmpstatus = "1";
                tmpbudgetstatus = "0";
                RecordSet.executeSql(
                        " select max(revision)+1 from FnaBudgetInfo where "
                                + " budgetorganizationid = " + tmporganizationid
                                + " and organizationtype = " + tmporganizationtype
                                + " and budgetperiods = " + tmpbudgetperiods);
                if (RecordSet.next()) {
                    tmprevision = ""+Util.getIntValue(Util.null2String(RecordSet.getString(1)),1);
                }
                para = tmpfnabudgetinfoid + separator
                        + tmpstatus + separator
                        + tmprevision + separator
                        + tmpbudgetstatus;
                RecordSet2.executeProc("FnaBudgetInfo_UpdateStatus", para);
            }

            String[] Fna_Budgets = request.getParameterValues("Fna_" + tmporganizationid + "_" + FnaOrgTypes[i] + "_Budgets");//预算值
            accountLength = Fna_Budgets.length;

            for (int j = 0; Fna_Budgets!=null && j < Fna_Budgets.length; j++) {

                tmpaccount = Fna_Budgets[j];
				if (tmpaccount==null||"".equals(tmpaccount)) tmpaccount="0";
                para = tmpfnabudgetinfoid + separator
                        + tmpbudgetperiods + separator
                        + (j + 1) + separator
                        + tmpfnabudgettypeid + separator
                        + "" + separator
                        + "" + separator
                        + "" + separator
                        + tmpaccount + separator
                        + "";
                if(ifbottomtotop){
	                //修改的预算值计算
	                int jj = j+1;
	                RecordSet3.executeSql("select budgetaccount from FnaBudgetInfoDetail where budgetinfoid="+inusefnabudgetinfoid
	                		+" and budgetperiods="+budgetperiods+" and budgetperiodslist="+jj+" and budgettypeid="+tmpfnabudgettypeid);
	                double diff = 0;
	                if(RecordSet3.next()){
	                	diff = Util.getDoubleValue(tmpaccount,0)-Util.getDoubleValue(RecordSet3.getString("budgetaccount"),0);
	                }else{
	                	diff = Util.getDoubleValue(tmpaccount,0);
	                }
	                diffAccount[j] += diff;
	                //System.out.println("diff:"+diffAccount[j]);
				}

                //if (tmpaccount!=null&&!"".equals(tmpaccount)&&Util.getDoubleValue(tmpaccount) > 0d)
                    RecordSet.executeProc("FnaBudgetInfoDetail_Insert", para);
            }
        }
        //修改的预算
        if(ifbottomtotop){
	        if(FnaOrgIDs!=null && FnaOrgTypes !=null){
	            String editOrganizationid = FnaOrgIDs[0];
	            String editOrganizationtype = FnaOrgTypes[0];
	        for(int ii=0;ii<accountLength;ii++){
	        	double tempDiff = diffAccount[ii];
	        	if(tempDiff !=0){
	           		double tempCanusedBudget = FnaBudgetInfoComInfo.getAvailableBudgetAmountNew(editOrganizationid,editOrganizationtype,budgetperiods,String.valueOf(ii+1),tmpfnabudgettypeid);
	           		if(0>tempCanusedBudget){
	        		FnaBudgetInfo fnaBudgetInfo = new FnaBudgetInfo();
	        		fnaBudgetInfo.setBudgetinfoid(lastFnabudgetinfoid);      //预算信息
	        		fnaBudgetInfo.setBudgetperiods(budgetperiods);       //预算会计期间
	        		fnaBudgetInfo.setBudgetperiodslist(ii+1);            //	期
	        		fnaBudgetInfo.setBudgettypeid(tmpfnabudgettypeid);   //收支种类
	        		fnaBudgetInfo.setDiffbudgetaccount(tempDiff);        //	差额
	        		fnaNeedChange.add(fnaBudgetInfo);
	           		}
	        	}
	        }
	        //修改上级预算
	            //如果是人力资源  如果修改的个人预算
	        	if("3".endsWith(editOrganizationtype)&& fnaNeedChange.size()>0){
	        		RecordSet.executeSql("select departmentid,subcompanyid1 from hrmresource where id="+editOrganizationid);
	                String subcompanyid1 = "0";
	                if(RecordSet.next()){
	                	subcompanyid1 = RecordSet.getString("subcompanyid1");
	                    String supdepid = RecordSet.getString("departmentid");
	                    FnaBudgetUtil.changDepartmentFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid,subcompanyid1,supdepid);
	                }
	                //对部门的上级分部预算进行调整 
	                if(!"0".equals(subcompanyid1)){
	                	FnaBudgetUtil.changSubcompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid,subcompanyid1);
	                }
	                //对总部预算进行调整
	                FnaBudgetUtil.changeCompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid);
	        	}
	            //如果是部门 如果修改的部门预算
	        	if("2".endsWith(editOrganizationtype) && fnaNeedChange.size()>0){
	                RecordSet.executeSql("select subcompanyid1,supdepid from HrmDepartment where id="+editOrganizationid);
	                String subcompanyid1 = "0";
	                if(RecordSet.next()){
	                	subcompanyid1 = RecordSet.getString("subcompanyid1");
	                    String supdepid = RecordSet.getString("supdepid");
	                    FnaBudgetUtil.changDepartmentFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid,subcompanyid1,supdepid);
	                }
	                
	                //对部门的上级分部预算进行调整 
	                if(!"0".equals(subcompanyid1)){
	                	FnaBudgetUtil.changSubcompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid,subcompanyid1);
	                }
	                //对总部预算进行调整
	                FnaBudgetUtil.changeCompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid);
	        	}
	            //如果是分部  如果修改的分部预算
	        	if("1".endsWith(editOrganizationtype) && fnaNeedChange.size()>0){
	                //对部门的上级分部预算进行调整
	                RecordSet.executeSql("select supsubcomid from Hrmsubcompany where id="+editOrganizationid);
	                String subcompanyid1 = "0";
	                if(RecordSet.next()){
	                	subcompanyid1 = RecordSet.getString("supsubcomid");
	                    if(!"0".equals(subcompanyid1)){
	                    	FnaBudgetUtil.changSubcompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid,subcompanyid1);
	                    }
	                }
	                //对总部预算进行调整
	                FnaBudgetUtil.changeCompanyFnaBudget(budgetperiods,fnaNeedChange,user,currentdate,lastFnabudgetinfoid);
	        	}
	        }
        }

        response.sendRedirect("FnaBudgetTypeView.jsp?fnabudgetinfoid=" + fnabudgetinfoid + "&fnabudgettypeid=" + tmpfnabudgettypeid+"&fnabudgetinfoid_hrm="+fnabudgetinfoid_hrm);
    }
%>

