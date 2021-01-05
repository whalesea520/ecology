<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ExcelParse" class="weaver.file.ExcelParse" scope="page"/>
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    String opera = Util.null2String(request.getParameter("operation")); //操作类型
	//added by wcd 2014-08-07 start
	if (opera.equals("delete")){
		String ids = Util.null2String(request.getParameter("ids"));
		String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
		String departmentid = Util.null2String(request.getParameter("departmentid"));
		String orgtype = "";
		if(departmentid.trim().length()>0){
			orgtype = "dept";
		}else{
			orgtype = "com";
		}
		StringBuffer _sql = new StringBuffer();
		if(orgtype.equals("dept")){
			_sql.append("select a.theyear,a.themonth,a.subcompanyid1,a.departmentid from (")
			.append(" select row_number()over(order by a.theyear,a.themonth) as num, a.theyear,a.themonth,b.subcompanyid1,b.departmentid")
			.append(" from hrmschedulemonth a left join hrmresource b on a.hrmid = b.id ")
			.append(" group by a.theyear,a.themonth,b.subcompanyid1,b.departmentid ) a ")
			.append(" where a.num in (").append(ids).append(")");
		}else{
			_sql.append("select a.theyear,a.themonth,a.subcompanyid1 from (")
			.append(" select row_number()over(order by a.theyear,a.themonth) as num, a.theyear,a.themonth,b.subcompanyid1")
			.append(" from hrmschedulemonth a left join hrmresource b on a.hrmid = b.id ")
			.append(" group by a.theyear,a.themonth,b.subcompanyid1 ) a ")
			.append(" where a.num in (").append(ids).append(")");
		}
		RecordSet.executeSql(_sql.toString());
		while(RecordSet.next()){
			StringBuffer dSql = new StringBuffer("delete from hrmschedulemonth")
			.append(" where theyear = ").append(Util.null2String(RecordSet.getString("theyear")))
			.append(" and themonth = ").append(Util.null2String(RecordSet.getString("themonth")))
			.append(" and hrmid in ( select id from HrmResource ")
			.append(" where subcompanyid1 = ").append(Util.null2String(RecordSet.getString("subcompanyid1")));
			if(orgtype.equals("dept")){
				dSql.append(" and departmentid = ").append(Util.null2String(RecordSet.getString("departmentid")));
			}
			dSql.append(" )");
			RecordSet1.executeSql(dSql.toString());
		}
		response.sendRedirect("HrmScheduleMonth.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid);
		return;
	}
	//added by wcd 2014-08-07 end
    FileUploadToPath fu = new FileUploadToPath(request);    // 非压缩上传
	opera = Util.null2String(fu.getParameter("operation")); //操作类型
    String theyear = Util.fromScreen(fu.getParameter("theyear"), user.getLanguage()); //简称
    String themonth = Util.fromScreen(fu.getParameter("themonth"), user.getLanguage()); //说明
    String orgtype = Util.fromScreen(fu.getParameter("type"), user.getLanguage());
    String orgid = Util.fromScreen(fu.getParameter("id"), user.getLanguage());
    String subcompanyid = Util.fromScreen(fu.getParameter("subcompanyid"), user.getLanguage());
    String departmentid = Util.fromScreen(fu.getParameter("departmentid"), user.getLanguage());
	String f_flag = Util.fromScreen(fu.getParameter("f_flag"), user.getLanguage());
    if (opera.equals("add")) {//新建
        if (!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user)) {
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
        String sql1;
        if (orgtype.equals("com"))
            sql1 = "select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.subcompanyid1=" + orgid + "  and a.theyear='" +
                    theyear + "' and a.themonth='" + themonth + "'";
        else {
            String deptids = SubCompanyComInfo.getDepartmentTreeStr(orgid);
            deptids = orgid + "," + deptids;
            deptids = deptids.substring(0, deptids.length() - 1);
            sql1 = "select a.hrmid from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.departmentid in(" + deptids + ")  and a.theyear='" +
                    theyear + "' and a.themonth='" + themonth + "'";
        }
        //System.out.println("sql1"+sql1);
        RecordSet.executeSql(sql1);
        if (RecordSet.next()) {
            response.sendRedirect("HrmScheduleMonthAdd.jsp?msg=19428&isdialog=1&type=" + orgtype + "&id=" + orgid+"&subcompanyid="+subcompanyid+"&departmentid="+departmentid);
            return;
        }
        Enumeration enumt = fu.getParameterNames();
        while (enumt.hasMoreElements()) {

            String para = (String) enumt.nextElement();
            //System.out.println(para);
            if (para.indexOf("_") < 1 || para.endsWith("_"))
                continue;

            String value = fu.getParameter(para);
            //System.out.println(value);
            if (value == null || value.equals(""))
                continue;
            String[] splits = Util.TokenizerString2(para, "_");
            String sql = "insert into hrmschedulemonth(hrmid,difftype,hours,theyear,themonth) values(" + splits[0] + "," + splits[1] +
                    "," + value + ",'" + theyear + "','" + themonth + "')";
            //System.out.println(sql);
            RecordSet.executeSql(sql);


        }
        /*if (orgtype.equals("com"))
            response.sendRedirect("HrmScheduleMonthAdd.jsp?isclose=1&subcompanyid=" + orgid);
        else {
            response.sendRedirect("HrmScheduleMonthAdd.jsp?isclose=1&departmentid=" + orgid);
        }*/
		response.sendRedirect("HrmScheduleMonthAdd.jsp?isclose=1&subcompanyid="+subcompanyid+"&departmentid="+departmentid);
    }else if (opera.equals("update")) { //保存
        if (!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user)) {
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
        Enumeration enumt = request.getParameterNames();
        while (enumt.hasMoreElements()) {

            String para = (String) enumt.nextElement();
             //System.out.println("para:"+para);
            if (para.indexOf("_") < 1 || para.endsWith("_"))
                continue;

            String value = fu.getParameter(para);
            //System.out.println(value);
            String[] splits = Util.TokenizerString2(para, "_");
            String sql = "select * from hrmschedulemonth where hrmid=" + splits[0] + " and difftype=" + splits[1] +
                    " and theyear='" + theyear + "' and themonth='" + themonth + "'";
            //System.out.println(sql);
            RecordSet.executeSql(sql);
            if (RecordSet.next()) {
                if (value == null || value.equals(""))
                    value = "0";
                sql = "update hrmschedulemonth set hours=" + value + " where hrmid=" + splits[0] + " and difftype=" + splits[1] +
                        " and theyear='" + theyear + "' and themonth='" + themonth + "'";
                //System.out.println(sql);
            } else {
                if (value == null || value.equals(""))
                    continue;
                sql = "insert into hrmschedulemonth(hrmid,difftype,hours,theyear,themonth) values(" + splits[0] + "," + splits[1] +
                        "," + value + ",'" + theyear + "','" + themonth + "')";
                // System.out.println("sql");
            }

            //System.out.println(sql);
            RecordSet.executeSql(sql);


        }
        response.sendRedirect("HrmScheduleMonthEdit.jsp?isclose=1&year=" + theyear + "&month=" + themonth + "&type=" + orgtype + "&id=" + orgid+"&subcompanyid="+(f_flag.equals("1")?"":subcompanyid)+"&departmentid="+(f_flag.equals("1")?"":departmentid));
    }else if (opera.equals("importnew")) {
        if (!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user)) {
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
        String sql = "select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.subcompanyid1=" + orgid + "  and a.theyear='" +
                theyear + "' and a.themonth='" + themonth + "'";
        RecordSet.executeSql(sql);
        if (RecordSet.next()) {
            response.sendRedirect("HrmScheduleMonthAdd.jsp?isclose=1&msg=19428&type=" + orgtype + "&id=" + orgid);
            return;
        }

          String filename =fu.uploadFiles("excelfile");
          if(filename==null||filename.equals(""))  {
           response.sendRedirect("HrmScheduleMonthAdd.jsp?isclose=1&subcompanyid=" + orgid);
            return;
          }
        String subid = orgid;
        String supids = SubCompanyComInfo.getAllSupCompany(subid);
        if (supids.endsWith(",")) {
            supids = supids.substring(0, supids.length() - 1);
            sql = "select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+") or (diffscope=2 and subcompanyid in("+supids+")))";
        } else
            sql = "select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid=" + subid + "))";
       
        RecordSet.executeSql(sql);
        RecordSet1.executeSql("select * from hrmresource where status>-1 and status<4 and subcompanyid1=" + orgid + " order by dsporder,lastname");

        if (!filename.equals("")) {
            ExcelParse.init(filename);
            int recordercount = 0;
            while (true) {
                recordercount ++;
                //标题行
                if (recordercount == 1) continue;

                String id = Util.null2String(ExcelParse.getValue("1", "" + recordercount, "1")).trim();
                String lastname = Util.null2String(ExcelParse.getValue("1", "" + recordercount, "2")).trim();
                if (id.equals(""))
                    break;
                RecordSet1.beforFirst();
                boolean exist = false;
                while (RecordSet1.next()) {
                    if (id.equals(RecordSet1.getString("id"))) {
                        exist = true;
                        break;
                    }
                }
                if (!exist)
                    continue;
                RecordSet.beforFirst();
                int colcount = 2;
                while (RecordSet.next()) {
                    colcount++;
                    String hours = Util.null2String(ExcelParse.getValue("1", "" + recordercount, "" + colcount)).trim();
                    if (hours.equals(""))
                        continue;
                    String insertsql = "insert into hrmschedulemonth(hrmid,difftype,hours,theyear,themonth) values(" + id + "," + RecordSet.getString("id") +
                            "," + hours + ",'" + theyear + "','" + themonth + "')";
                    RecordSet2.executeSql(insertsql);
                }


            }
            FileManage.DeleteFile(filename);
        }
        response.sendRedirect("HrmScheduleMonthAdd.jsp?isclose=1&subcompanyid=" + orgid);
    }

%>