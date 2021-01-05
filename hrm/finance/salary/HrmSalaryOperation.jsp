<%@ page import="weaver.general.Util,java.math.*,weaver.general.GCONST" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="weaver.conn.WeaverThreadPool" %>
<%@ page import="weaver.conn.HrmSalaryTimer" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SalaryManager" class="weaver.hrm.finance.SalaryManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<%
    char flag = Util.getSeparator();
    String ProcPara = "";
    String method = Util.null2String(request.getParameter("method"));
    String multresourceid = Util.null2String(request.getParameter("multresourceid"));
    String itemid = Util.null2String(request.getParameter("itemid"));
    String changetype = Util.null2String(request.getParameter("changetype"));
    String changeresion = Util.fromScreen(request.getParameter("changeresion"), user.getLanguage());
    String salary = "" + Util.getDoubleValue(request.getParameter("salary"), 0);
    String currentdate = Util.null2String(request.getParameter("currentdate"));
    String needref = Util.null2String(request.getParameter("needref"));
    String payid = Util.null2String(request.getParameter("payid"));
    String oldsalary = "";
    String fromdepartment = Util.null2String(request.getParameter("fromdepartment"));
    String createtype = Util.null2String(request.getParameter("createtype"));
    String plandate = Util.null2String(request.getParameter("plandate"));
    String planid = Util.null2String(request.getParameter("planid"));
    int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"));

// 在修改工资单后做跳转
    int departmentid = Util.getIntValue(request.getParameter("departmentid"));   // 部门
    String jobactivityid = Util.null2String(request.getParameter("jobactivityid")); // 职务
    String jobtitle = Util.null2String(request.getParameter("jobtitle"));       // 岗位
    String resourceid = Util.null2String(request.getParameter("resourceid"));       // 人力资源
    String status = Util.null2String(request.getParameter("status"));       // 人力资源状态


    String salarybegindate = Util.null2String(request.getParameter("salarybegindate"));       // 工资开始计算日期
    String salaryenddate = Util.null2String(request.getParameter("salaryenddate"));       // 工资截至计算日期

    if (method.equals("changesalary")) {
        Calendar today = Calendar.getInstance();
        currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
        ArrayList hrmids = Util.TokenizerString(multresourceid, ",");
        for (int i = 0; i < hrmids.size(); i++) {
            String tmpsalary = "0";
            String newsalary = salary;
            RecordSet.executeSql(" select resourcepay from HrmSalaryResourcePay where itemid = " + itemid + " and resourceid = " + hrmids.get(i));
            if (RecordSet.next()) {
                tmpsalary = RecordSet.getString("resourcepay");
            } else { //从等级里面找（计算顺序”岗位－>职务->职级“）
                tmpsalary = SalaryManager.getRankSalary(Util.getIntValue((String) hrmids.get(i)), Util.getIntValue(itemid));
                RecordSet.executeSql("insert into HrmSalaryResourcePay(itemid, resourceid, resourcepay) values(" + itemid + "," + hrmids.get(i) + "," + tmpsalary + ")");
            }
            // 调整工资
            if (changetype.equals("1")) {
                RecordSet.executeSql(" update HrmSalaryResourcePay set resourcepay = resourcepay + " + salary + " where resourceid = " + hrmids.get(i) + " and itemid= " + itemid);
            } else if (changetype.equals("2")) {
                RecordSet.executeSql(" update HrmSalaryResourcePay set resourcepay = resourcepay - " + salary + " where resourceid =" + hrmids.get(i) + " and itemid= " + itemid);
            } else if (changetype.equals("3")) {
                RecordSet.executeSql(" update HrmSalaryResourcePay set resourcepay = " + salary + " where resourceid = " + hrmids.get(i) + " and itemid= " + itemid);
            }
            RecordSet.executeSql(" select resourcepay from HrmSalaryResourcePay where itemid = " + itemid + " and resourceid = " + hrmids.get(i));
            if (RecordSet.next()) {
                newsalary = RecordSet.getString("resourcepay");
            }
            RecordSet.executeSql("insert into HrmSalaryChange(multresourceid,itemid,changetype,salary,changeresion,changeuser,changedate,oldvalue,newvalue) values('," + hrmids.get(i) + ",'," + itemid + ",'" + changetype + "'," + salary + ",'" + changeresion + "'," + user.getUID() + ",'" + currentdate + "'," + tmpsalary + "," + newsalary + ")");
        }
        response.sendRedirect("HrmSalaryChangeLog.jsp");
        return;
    } else if (method.equals("createpay")) {
        if (createtype.equals("1")) {
            SalaryManager.initResourcePay(currentdate, salarybegindate, salaryenddate, Util.getIntValue(payid, 0));
        } else {
            ProcPara = currentdate;
            ProcPara += flag + salarybegindate;
            ProcPara += flag + salaryenddate;
            ProcPara += flag + payid;
            ProcPara += flag + plandate;

            RecordSet.executeProc("HrmSalaryCreateInfo_Insert", ProcPara);
        }
        if (fromdepartment.equals("1")) response.sendRedirect("HrmDepSalaryPay.jsp?currentdate=" + currentdate);
        else response.sendRedirect("HrmSalaryPay.jsp?currentdate=" + currentdate);
    } else if (method.equals("deleteplan")) {
        RecordSet.executeProc("HrmSalaryCreateInfo_Delete", planid);
        response.sendRedirect("HrmSalaryCreate.jsp?currentdate=" + currentdate + "&salarybegindate=" + salarybegindate + "&salaryenddate=" + salaryenddate + "&payid=" + payid + "&fromdepartment=" + fromdepartment);
    } else if (method.equals("changepay")) {
        ArrayList itemids = new ArrayList();
        ArrayList itemtypes = new ArrayList();
        ArrayList itemshows = new ArrayList();
        ArrayList resourceitems = new ArrayList();
        ArrayList salarys = new ArrayList();
        ArrayList tempresourceitems = new ArrayList();
        ArrayList tempsalarys = new ArrayList();
        boolean haschanged = false;
        boolean hasinited = false;

        RecordSet.executeSql("select * from HrmSalaryItem");
        while (RecordSet.next()) {
            itemid = Util.null2String(RecordSet.getString("id"));
            String itemtype = Util.null2String(RecordSet.getString("itemtype"));
            String itemshow = Util.null2String(RecordSet.getString("isshow"));

            itemids.add(itemid);
            itemtypes.add(itemtype);
            itemshows.add(itemshow);
        }


        if (status.equals("")) status = "8";
        String sqlwhere = "";
        if (departmentid > 0) {
            sqlwhere += " and departmentid = " + departmentid;
        }
        if (!jobactivityid.equals("")) {
            sqlwhere += " and jobtitle in ( select id from HrmJobTitles where jobactivityid = " + jobactivityid + " ) ";
        }
        if (!jobtitle.equals("")) {
            sqlwhere += " and jobtitle = " + jobtitle;
        }
        if (!resourceid.equals("")) {
            sqlwhere += " and id = " + resourceid;
        }
        if (!status.equals("9")) {
            if (status.equals("8"))
                sqlwhere += " and (status = 0 or status = 1 or status = 2 or status = 3) ";
            else
                sqlwhere += " and status = " + status;
        }

        RecordSet.executeSql(" select a.id , b.locationcity " +
                " from HrmResource a left join HrmLocations b on a.locationid = b.id where a.id >0 " + sqlwhere);

        while (RecordSet.next()) {
            String resourceidrs = Util.null2String(RecordSet.getString("id"));
            int departmentid5 = Util.getIntValue(ResourceComInfo.getDepartmentID(resourceidrs), 0);
            String locationcityrs = Util.null2String(RecordSet.getString("locationcity"));

            resourceitems.clear();
            salarys.clear();
            tempresourceitems.clear();
            tempsalarys.clear();
            haschanged = false;
            hasinited = false;


            for (int i = 0; i < itemids.size(); i++) {
                itemid = (String) itemids.get(i);
                String itemtype = (String) itemtypes.get(i);
                String itemshow = (String) itemshows.get(i);

                if (itemtype.equals("3") || itemtype.equals("4")) continue;

                salary = "";
                oldsalary = "";

                if (itemshow.equals("1")) {

                    if (!itemtype.equals("2")) {
                        salary = "" + Util.getDoubleValue(request.getParameter(resourceidrs + "_" + itemid), 0);
                        oldsalary = "" + Util.getDoubleValue(request.getParameter("old_" + resourceidrs + "_" + itemid), 0);

                        if (!salary.equals(oldsalary)) {
                            ProcPara = payid + flag + itemid + flag + resourceidrs + flag + salary + flag + departmentid5;
                            RecordSet2.executeProc("HrmSalaryPaydetail_Update", ProcPara);
                            haschanged = true;
                        }

                        if (needref.equals("1")) {
                            resourceitems.add(resourceidrs + "_" + itemid);
                            salarys.add(salary);
                        }
                        continue;
                    }

                    if (itemtype.equals("2")) {
                        salary = "" + Util.getDoubleValue(request.getParameter(resourceidrs + "_" + itemid + "_1"), 0);
                        oldsalary = "" + Util.getDoubleValue(request.getParameter("old_" + resourceidrs + "_" + itemid + "_1"), 0);
                        BigDecimal personwelfareratedes = new BigDecimal(salary);

                        if (!salary.equals(oldsalary)) {
                            ProcPara = payid + flag + itemid + "_1" + flag + resourceidrs + flag + salary + flag + departmentid5;
                            RecordSet2.executeProc("HrmSalaryPaydetail_Update", ProcPara);
                            haschanged = true;
                        }

                        if (needref.equals("1")) {
                            resourceitems.add(resourceidrs + "_" + itemid + "_1");
                            salarys.add(salary);
                        }

                        salary = "" + Util.getDoubleValue(request.getParameter(resourceidrs + "_" + itemid + "_2"), 0);
                        oldsalary = "" + Util.getDoubleValue(request.getParameter("old_" + resourceidrs + "_" + itemid + "_2"), 0);
                        BigDecimal companywelfareratedes = new BigDecimal(salary);

                        if (!salary.equals(oldsalary)) {
                            ProcPara = payid + flag + itemid + "_2" + flag + resourceidrs + flag + salary + flag + departmentid5;
                            RecordSet2.executeProc("HrmSalaryPaydetail_Update", ProcPara);
                            haschanged = true;
                        }

                        if (needref.equals("1")) {
                            resourceitems.add(resourceidrs + "_" + itemid + "_2");
                            salarys.add(salary);

                            BigDecimal welfareratedes = (personwelfareratedes.add(companywelfareratedes)).divide(new BigDecimal(1), 2, BigDecimal.ROUND_HALF_DOWN);

                            resourceitems.add(resourceidrs + "_" + itemid);
                            salarys.add("" + welfareratedes.doubleValue());
                        }
                        continue;
                    }
                } else if (needref.equals("1")) {
                    if (!itemtype.equals("2")) {
                        RecordSet2.executeSql("select salary from HrmSalaryPaydetail where payid=" + payid + " and hrmid=" + resourceidrs + " and itemid='" + itemid + "'");
                        if (RecordSet2.next()) salary = "" + Util.getDoubleValue(RecordSet2.getString("salary"), 0);

                        resourceitems.add(resourceidrs + "_" + itemid);
                        salarys.add(salary);
                        continue;
                    }

                    if (itemtype.equals("2")) {
                        RecordSet2.executeSql("select salary from HrmSalaryPaydetail where payid=" + payid + " and hrmid=" + resourceidrs + " and itemid='" + itemid + "_1'");
                        if (RecordSet2.next()) salary = "" + Util.getDoubleValue(RecordSet2.getString("salary"), 0);

                        resourceitems.add(resourceidrs + "_" + itemid + "_1");
                        salarys.add(salary);

                        RecordSet2.executeSql("select salary from HrmSalaryPaydetail where payid=" + payid + " and hrmid=" + resourceidrs + " and itemid='" + itemid + "_2'");
                        if (RecordSet2.next()) salary = "" + Util.getDoubleValue(RecordSet2.getString("salary"), 0);

                        resourceitems.add(resourceidrs + "_" + itemid + "_2");
                        salarys.add(salary);
                    }
                }
            }


            if (needref.equals("1") && haschanged && !hasinited) {
                SalaryManager.setResourceitems(resourceitems);
                SalaryManager.setAmounts(salarys);
                SalaryManager.initResourceSalaryInfo(false);
                hasinited = true;
            }

            for (int i = 0; i < itemids.size(); i++) {
                itemid = (String) itemids.get(i);
                String itemtype = (String) itemtypes.get(i);

                if (itemtype.equals("3") || itemtype.equals("4")) {
                    if (needref.equals("1") && haschanged) {
                        SalaryManager.setResourceid(resourceidrs);
                        SalaryManager.setCityid(locationcityrs);
                        SalaryManager.setItemid(itemid);
                        SalaryManager.setItemtype(itemtype);
                        salary = "" + SalaryManager.getItemSalary();

                        ProcPara = payid + flag + itemid + flag + resourceidrs + flag + salary + flag + departmentid5;
                        RecordSet2.executeProc("HrmSalaryPaydetail_Update", ProcPara);
                    } else if (!needref.equals("1")) {
                        salary = "" + Util.getDoubleValue(request.getParameter(resourceidrs + "_" + itemid), 0);
                        oldsalary = "" + Util.getDoubleValue(request.getParameter("old_" + resourceidrs + "_" + itemid), 0);

                        if (!salary.equals(oldsalary)) {
                            ProcPara = payid + flag + itemid + flag + resourceidrs + flag + salary + flag + departmentid5;
                            RecordSet2.executeProc("HrmSalaryPaydetail_Update", ProcPara);
                        }
                    }
                }
            }
        }

        response.sendRedirect("HrmSalaryPay.jsp?currentdate=" + currentdate + "&departmentid=" + departmentid + "&jobactivityid=" + jobactivityid + "&jobtitle=" + jobtitle + "&resourceid=" + resourceid + "&status=" + status);
    } else if (method.equals("create")) {//生成工资单
        ConnStatement statement = new ConnStatement();
        String sql = "";
        String wherestr = "";
        String wherestr1 = "";
        String wherestr2 = "";
        payid = "";
        String yearmonth = request.getParameter("yearmonth");
        String subcompanystr = "";
        String departmentstr = "";
        try {
            if (departmentid < 1 && subcompanyid > 0) {
                String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Manager", 0);
                ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
                subcompanystr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
            }
            //查找该月工资单是否有生成过
            sql = "select id from HrmSalarypay where paydate='" + yearmonth + "'";

            statement.setStatementSql(sql);
            statement.executeQuery();
            if (statement.next()) {
                payid = statement.getString("id");
            }


            if (payid.equals("")) {//没有生成过
                //插入工资单主表
                sql = "insert into HrmSalarypay(paydate,isvalidate) values(?,?)";
                statement.setStatementSql(sql);
                statement.setString(1, yearmonth);
                statement.setInt(2, 0);
                statement.executeUpdate();
                //获得生成的工资单id
                sql = "select id from HrmSalarypay where paydate='" + yearmonth + "'";
                statement.setStatementSql(sql);
                statement.executeQuery();
                if (statement.next()) {
                    payid = statement.getString("id");
                }
            }
            //更新修改日志，将是否应用到薪酬设置置为1(让原先更改的记录应用到薪酬设置失效)
            if (departmentid > 0) {
                departmentstr = SubCompanyComInfo.getDepartmentTreeStr("" + departmentid) + departmentid;
                wherestr2 = " and departmentid in(" + departmentstr + ")";
                wherestr = " and hrmid in (select r.id from HrmResource r where r.departmentid in(" + departmentstr + "))";
                wherestr1 = " and exists (select 1 from HrmResource where userid=id and departmentid in(" + departmentstr + "))";
            } else if (subcompanyid > 0) {
                wherestr = " and exists (select 1 from Hrmdepartment c where c.id=departmentid and c.subcompanyid1 in(" + subcompanystr + "))";
                wherestr2 = wherestr;
                wherestr1 = " and exists (select 1 from HrmResource where userid=id and subcompanyid1 in(" + subcompanystr + "))";
            } else {//生成失败
                response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid + "&yearmonth=" + yearmonth + "&createerror=1");
                return;
            }
            sql = "update HRMSalaryPayLog set changedset=1 where changedset=0 and payid=" + payid + wherestr1;
            statement.setStatementSql(sql);
            statement.executeUpdate();
            if (!payid.equals("")) {//计算工资单
                //查找关闭了的部门工资单
                String decdeptid = "";
                sql = "select distinct departmentid from HrmSalarypaydetail where status=1 and payid=" + payid + wherestr;
                statement.setStatementSql(sql);
                statement.executeQuery();
                while (statement.next()) {
                    if (decdeptid.equals("")) {
                        decdeptid = statement.getString("departmentid");
                    } else {
                        decdeptid += "," + statement.getString("departmentid");
                    }
                }
                //删除该分部或部门下原有的工资单
                if (decdeptid.length() > 0) { 
                	wherestr += " and departmentid not in(" + decdeptid + ")";
                	wherestr2 += " and departmentid not in(" + decdeptid + ")";
                }
                sql = "delete from HrmSalarypaydetail where (status is null or status=0) and payid=" + payid + wherestr;
                RecordSet.executeSql(sql);
                //生成新的工资单
                //获得该分部及下级分部或部门下的所有人
                sql = "select distinct departmentid,subcompanyid1 from HrmResource where status in(0,1,2,3) " + wherestr2 + " order by subcompanyid1";

                RecordSet.executeSql(sql);

                int tempsubcompanyid = -2;
                ArrayList itemlist = new ArrayList();
                WeaverThreadPool threadpool=GCONST.getWeaverThreadPool();
                ArrayList checklist=new ArrayList();
                while (RecordSet.next()) {
                    int deptid = RecordSet.getInt("departmentid");
                    int subcompanyid1 = RecordSet.getInt("subcompanyid1");
                    if (tempsubcompanyid != subcompanyid1) {
                        //获得该分部及下级分部的工资项
                        itemlist = SalaryComInfo.getSubCompanySalary(subcompanyid1, false);
                        tempsubcompanyid = subcompanyid1;
                    }

                    String tempwhere=" where status in(0,1,2,3) and departmentid="+deptid+" " + wherestr2+" order by departmentid,subcompanyid1";
                    HrmSalaryTimer ht=new HrmSalaryTimer(itemlist,payid,tempwhere);
					checklist.add(ht);
                    threadpool.run(ht);

                    /*
                    for (int i = 0; i < itemlist.size(); i++) {
                        int tempitemid = Util.getIntValue((String) itemlist.get(i));
                        SalaryManager.runFunction(tempitemid, userid, Util.getIntValue(payid));    //计算每个人的工资单
                    } */
                }
               // while(true){
               //     checklist=threadpool.Threadstatus(checklist);
               //     if(checklist.size()<1){
              //          break;
              //      }else{
              //          Thread.sleep(5000);
              //      }
              //  }
			  session.setAttribute("hrm_salary_process",checklist) ;
            } else {//生成失败
                response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid + "&yearmonth=" + yearmonth + "&createerror=1");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            statement.close();
        }
        response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid + "&yearmonth=" + yearmonth);
	} else if(method.equals("processing")){
    	out.clear() ;
    	ArrayList checklist = (ArrayList) session.getAttribute("hrm_salary_process") ;
    	if(checklist!=null){
    		checklist = GCONST.getWeaverThreadPool().Threadstatus(checklist) ;
    		if(checklist.size() > 0){
    			out.print("1") ;
    			return  ;
    		}
    	}
    	out.print("0");
    	return ;
    } else if (method.equals("edit")) {  //编辑
        String changeids = Util.null2String(request.getParameter("changeids"));
        String changeitemids = Util.null2String(request.getParameter("changeitemids"));
        String sql = "";
        if (changeids.length() > 0 && changeitemids.length() > 0) {
            Calendar today = Calendar.getInstance();
            currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                    Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                    Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
            String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                    Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                    Util.add0(today.get(Calendar.SECOND), 2);
            changeids = changeids.substring(1);
            changeitemids = changeitemids.substring(1);
            ArrayList hrmidlist = Util.TokenizerString(changeids, ",");
            ArrayList itemidlist = Util.TokenizerString(changeitemids, ",");
            ArrayList caltypeitems = SalaryComInfo.getSubCompanyItemByType(subcompanyid, "'4','3','9'", false);
            ConnStatement statement = new ConnStatement();
            
            //System.out.println("changeids :"+changeids);
            //System.out.println("chageitemids :"+changeitemids);
            
            try {
                for (int i = 0; i < hrmidlist.size(); i++) {
                    for (int j = 0; j < itemidlist.size(); j++) {
                        double tmpsalary = 0;
                        String tmpsalarystr = "0";
                        String newsalarystr = request.getParameter("item" + hrmidlist.get(i) + "_" + itemidlist.get(j));
                        double newsalary = Util.getDoubleValue(newsalarystr);
                        boolean hasitem = false;
                        sql = "select salary from HrmSalarypaydetail where (status is null or status=0) and payid=" + payid + " and hrmid =" + hrmidlist.get(i) + " and itemid ='" + itemidlist.get(j) + "'";
                        //System.out.println("sql:"+sql);

                        statement.setStatementSql(sql);
                        statement.executeQuery();
                        if (statement.next()) {
                            tmpsalarystr = statement.getString("salary");
                            tmpsalary = Util.getDoubleValue(tmpsalarystr);
                            hasitem = true;
                        }
                        if (tmpsalary != newsalary) {
                            if (hasitem) {//有该项工资 直接更新
                                sql = "update HrmSalarypaydetail set salary=" + newsalary + " where (status is null or status=0) and payid=" + payid + " and hrmid=" + hrmidlist.get(i) + " and itemid='" + itemidlist.get(j) + "'";
                                statement.setStatementSql(sql);
                                statement.executeUpdate();
                            } else {  //没有该项工资，插入工资
                                sql = "insert into HrmSalarypaydetail(payid,itemid,hrmid,salary,departmentid,status,sent) values(?,?,?,?,?,?,?)";
                                statement.setStatementSql(sql);
                                statement.setInt(1, Util.getIntValue(payid));
                                statement.setString(2, (String) itemidlist.get(j));
                                statement.setInt(3, Util.getIntValue((String) hrmidlist.get(i)));
                                statement.setString(4, newsalarystr);
                                statement.setString(5, ResourceComInfo.getDepartmentID((String) hrmidlist.get(i)));
                                statement.setInt(6, 0);
                                statement.setInt(7, 0);
                                statement.executeUpdate();
                            }
                            //更改发送状态为“未发送”
                            sql = "update HrmSalarypaydetail set sent=0 where (status is null or status=0) and payid=" + payid + " and hrmid=" + hrmidlist.get(i);
                            statement.setStatementSql(sql);
                            statement.executeUpdate();
                            //记录更改日志
                            sql = "insert into HRMSalaryPayLog(userid,changedate,changetime,payid,itemid,oldvalue,newvalue,changedset,changid) values(?,?,?,?,?,?,?,?,?)";
                            statement.setStatementSql(sql);
                            statement.setInt(1, Util.getIntValue((String) hrmidlist.get(i)));
                            statement.setString(2, currentdate);
                            statement.setString(3, currenttime);
                            statement.setInt(4, Util.getIntValue(payid));
                            statement.setString(5, (String) itemidlist.get(j));
                            statement.setString(6, tmpsalarystr);
                            statement.setString(7, newsalarystr);
                            statement.setInt(8, 0);
                            statement.setInt(9, user.getUID());
                            statement.executeUpdate();
                        }
                    }
                    //计算类型重新计算
                    
                    //example : tax item rely on sum,sum is also a calculater,when you first delete tax detail to recalculate,
                    //at that time ,your tax is based on an old sum,so it's wrong.
                    
                    //delete all cal item for calculate new 
                    String itemIds="";
                    for (int m = 0; m < caltypeitems.size(); m++) {
                      int deindx = itemidlist.indexOf(caltypeitems.get(m));
                        if (deindx < 0) {
                            deindx = itemidlist.indexOf(caltypeitems.get(m) + "_1");
                        }
                        if (deindx < 0) {
                            deindx = itemidlist.indexOf(caltypeitems.get(m) + "_2");
                        }
                        if (deindx < 0) {
	                           itemIds+="'"+caltypeitems.get(m)+"',"+"'"+caltypeitems.get(m)+"_1',"+"'"+caltypeitems.get(m)+"_2',";
	                     }
                     }
                     
                     
                    sql = "delete from HrmSalarypaydetail where payid=" + payid + " and hrmid=" + hrmidlist.get(i);
                        if(!itemIds.equals("")){
                          int end=itemIds.lastIndexOf(",");  
                          sql+= " and itemid in ("+itemIds.substring(0,end)+")";
                       
                           // System.out.println("delte detail  :"+sql);
                            statement=new ConnStatement();
                            statement.setStatementSql(sql);
                            statement.executeUpdate();
                            statement.close();
                        }
                    for (int j = 0; j < caltypeitems.size(); j++) {
                        int deindx = itemidlist.indexOf(caltypeitems.get(j));
                        if (deindx < 0) {
                            deindx = itemidlist.indexOf(caltypeitems.get(j) + "_1");
                        }
                        if (deindx < 0) {
                            deindx = itemidlist.indexOf(caltypeitems.get(j) + "_2");
                        }
                        if (deindx < 0) {
                            //删除该工资项原来值
                           // sql = "delete from HrmSalarypaydetail where payid=" + payid + " and hrmid=" + hrmidlist.get(i) + " and (itemid='" + caltypeitems.get(j) + "' or itemid='" + caltypeitems.get(j) + "_1' or itemid='" + caltypeitems.get(j) + "_2')";
                            //System.out.println("delte detail  :"+sql);
                           // statement=new ConnStatement();
                           // statement.setStatementSql(sql);
                          //  statement.executeUpdate();
                          //  statement.close();
                             
                            //计算工资项值
                            //System.out.println("caltypeitems:"+Util.getIntValue((String) caltypeitems.get(j)));
                            //System.out.println("hrmidlist:"+Util.getIntValue((String) hrmidlist.get(i)));
                            //System.out.println("payid:"+Util.getIntValue(payid));
                            
                            SalaryManager.runFunction(Util.getIntValue((String) caltypeitems.get(j)), Util.getIntValue((String) hrmidlist.get(i)), Util.getIntValue(payid));
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                SalaryManager.colseconnect();
                if(statement!=null)
                statement.close();
            }
        }
        response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid);
    } else if (method.equals("change")) { //调整薪酬设置
        ConnStatement statement = new ConnStatement();
        ConnStatement statement1 = new ConnStatement();
        Calendar today = Calendar.getInstance();
        currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
        String wherestr = "";
        String wherestr1 = "";
        String sql = "";
        if (departmentid > 0) {
            String departmentstr = SubCompanyComInfo.getDepartmentTreeStr("" + departmentid) + departmentid;
            wherestr = " and a.userid in(select id from HrmResource where departmentid in(" + departmentstr + "))";
            wherestr1 = " and userid in(select id from HrmResource where departmentid in(" + departmentstr + "))";
        } else if (subcompanyid > 0) {
            String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Manager", 0);
            ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
            String subcompanystr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
            wherestr = " and a.userid in(select id from HrmResource where subCompanyId1 in(" + subcompanystr + "))";
            wherestr1 = " and userid in(select id from HrmResource where subCompanyId1 in(" + subcompanystr + "))";
        }
        if (RecordSet.getDBType().equals("oracle")) {
            sql = "select a.userid,a.itemid,a.newvalue,c.paydate from HRMSalaryPayLog a,HrmSalaryItem b,HrmSalarypay c where substr(a.itemid,length(a.itemid)-1,length(a.itemid)) not in('_1','_2') and a.itemid=b.id and a.payid=c.id and a.changedset=0 and b.itemtype='1' and a.payid=" + payid + " and a.changid=" + user.getUID() + wherestr + " order by changedate,changetime";
        } else {
            sql = "select a.userid,a.itemid,a.newvalue,c.paydate from HRMSalaryPayLog a,HrmSalaryItem b,HrmSalarypay c where substring(a.itemid,len(a.itemid)-1,len(a.itemid)) not in('_1','_2') and a.itemid=b.id and a.payid=c.id and a.changedset=0 and b.itemtype='1' and a.payid=" + payid + " and a.changid=" + user.getUID() + wherestr + " order by changedate,changetime";
        }
        //System.out.println(sql);
        try {
            statement.setStatementSql(sql);
            statement.executeQuery();
            while (statement.next()) {
                String userid = statement.getString("userid");
                String tmpitemid = statement.getString("itemid");
                String newvalue = statement.getString("newvalue");
                String paydate = statement.getString("paydate");
                String resourcepay = "0";
                sql = "select resourcepay from HrmSalaryResourcePay where itemid=" + tmpitemid + " and resourceid=" + userid;
                statement1.setStatementSql(sql);
                statement1.executeQuery();
                if (statement1.next()) {//如果有则更新
                    resourcepay = statement1.getString("resourcepay");
                    sql = "update HrmSalaryResourcePay set resourcepay=? where itemid=? and resourceid=?";
                    statement1.setStatementSql(sql);
                    statement1.setString(1, newvalue);
                    statement1.setString(2, tmpitemid);
                    statement1.setString(3, userid);
                    statement1.executeUpdate();
                } else {//没有则插入一条记录
                    sql = "insert into HrmSalaryResourcePay(itemid,resourceid,resourcepay) values(?,?,?)";
                    statement1.setStatementSql(sql);
                    statement1.setString(1, tmpitemid);
                    statement1.setString(2, userid);
                    statement1.setString(3, newvalue);
                    statement1.executeUpdate();
                }
                //记录调整日志
                sql = "insert into HrmSalaryChange(multresourceid,itemid,changetype,salary,changeresion,changeuser,changedate,oldvalue,newvalue) values(?,?,?,?,?,?,?,?,?)";
                statement1.setStatementSql(sql);
                statement1.setString(1, "," + userid + ",");
                statement1.setString(2, tmpitemid);
                statement1.setString(3, "3");
                statement1.setString(4, newvalue);
                statement1.setString(5, paydate + SystemEnv.getHtmlLabelName(19592, user.getLanguage()));
                statement1.setInt(6, user.getUID());
                statement1.setString(7, currentdate);
                statement1.setString(8, resourcepay);
                statement1.setString(9, newvalue);
                statement1.executeUpdate();
            }
            //更新修改日志，将是否应用到薪酬设置置为1
            sql = "update HRMSalaryPayLog set changedset=1 where changedset=0 and payid=" + payid + " and changid=" + user.getUID() + wherestr1;
            statement1.setStatementSql(sql);
            statement1.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            statement.close();
            statement1.close();
        }
        response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid);
    } else if (method.equals("send")) {  //发送工资单
        String deptids[] = request.getParameterValues("chkdeptid");
        if (deptids != null) {
            for (int i = 0; i < deptids.length; i++) {
                String tmpdeptid = deptids[i];
                String hrmids[] = request.getParameterValues("chkresourceid_" + tmpdeptid);
                if (hrmids != null) {
                    String hrmstr = "";
                    for (int j = 0; j < hrmids.length; j++) {
                        if (hrmids[j] != null && !hrmids[j].trim().equals("")) {
                            if (hrmstr.equals("")) {
                                hrmstr = hrmids[j];
                            } else {
                                hrmstr += "," + hrmids[j];
                            }
                        }
                    }
                    RecordSet.executeSql(" update HrmSalarypaydetail set sent=1 where payid=" + payid + " and departmentid=" + tmpdeptid + " and hrmid in(" + hrmstr + ")");
                }
            }
        }
        response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid);
    } else if (method.equals("close")) {  //关闭工资单
        if (departmentid < 1) {
            if (subcompanyid > 0) {
                String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Manager", 0);
                ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
                String subcompanystr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
                RecordSet.executeSql(" update HrmSalarypaydetail set status=1 where payid=" + payid + " and departmentid in(select id from Hrmdepartment where subcompanyid1 in(" + subcompanystr + "))");
            }
        } else {
            String departmentstr = SubCompanyComInfo.getDepartmentTreeStr("" + departmentid) + departmentid;
            RecordSet.executeSql(" update HrmSalarypaydetail set status=1 where payid=" + payid + " and departmentid in(" + departmentstr + ")");
        }
        response.sendRedirect("HrmSalaryManageView.jsp?payid=" + payid + "&subCompanyId=" + subcompanyid + "&departmentid=" + departmentid);
    }
%>