<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.hrm.*" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
    weaver.conn.RecordSet rs=new weaver.conn.RecordSet();
    weaver.conn.RecordSet rs1=new weaver.conn.RecordSet();
    weaver.crm.Maint.CustomerInfoComInfo crminfo=new weaver.crm.Maint.CustomerInfoComInfo();
    String inprepid = weaver.general.Util.null2String(request.getParameter("inprepid"));
    String hrmid = weaver.general.Util.null2String(request.getParameter("hrmid"));
    String crmid = weaver.general.Util.null2String(request.getParameter("crmid"));
    String inprepfrequence = weaver.general.Util.null2String(request.getParameter("inprepfrequence"));
    String currentdate = weaver.general.Util.null2String(request.getParameter("currentdate"));
    String year = weaver.general.Util.null2String(request.getParameter("year"));
    String month = weaver.general.Util.null2String(request.getParameter("month"));
    String day = weaver.general.Util.null2String(request.getParameter("day"));
    String date = weaver.general.Util.null2String(request.getParameter("date"));
    String dspdate = currentdate;
    String returnvalue = "";
    if (!inprepfrequence.equals("0")) {
        switch (weaver.general.Util.getIntValue(inprepfrequence)) {
            case 1:
                dspdate = year;
                break;
            case 2:
                dspdate = year + "-" + month;
                break;
            case 3:
                dspdate = year + "-" + month;
                if (day.equals("05")) dspdate += " 上旬";
                if (day.equals("15")) dspdate += " 中旬";
                if (day.equals("25")) dspdate += " 下旬";
                break;
            case 4:
                java.util.Calendar today = java.util.Calendar.getInstance();
                today.set(java.util.Calendar.YEAR,weaver.general.Util.getIntValue(date.substring(0,4)));
                today.set(java.util.Calendar.MONTH,weaver.general.Util.getIntValue(date.substring(5,7))-1);
                today.set(java.util.Calendar.DAY_OF_MONTH,weaver.general.Util.getIntValue(date.substring(8)));
                dspdate = weaver.general.Util.add0(today.get(java.util.Calendar.YEAR), 4) + " 第" + weaver.general.Util.add0(today.get(java.util.Calendar.WEEK_OF_YEAR), 2) + "周";
                break;
            case 5:
                dspdate = date;
                break;
            case 6:
                dspdate = year;
                if(month.equals("01")) dspdate += " 上半年" ;
                if(month.equals("07")) dspdate += " 下半年" ;
                break;
            case 7:
                dspdate = year;
                if(month.equals("01")) dspdate += " 一季度" ;
                if(month.equals("04")) dspdate += " 二季度" ;
                if(month.equals("07")) dspdate += " 三季度" ;
                if(month.equals("10")) dspdate += " 四季度" ;
                break;
        }

    }
    rs.executeSql("select inpreptablename from T_InputReport where inprepid=" + inprepid);
    if (rs.next()) {
        java.util.ArrayList tablenames=new java.util.ArrayList();
        String tablename = weaver.general.Util.null2String(rs.getString("inpreptablename"));
        rs.executeSql("select id from T_inputreporthrm where inprepid=" + inprepid + " and hrmid=" + hrmid);
        if (rs.next()) {
            int reporthrmid = rs.getInt("id");
            //判断是否有汇总记录
            rs.executeSql("select inputstatus from " + tablename + " where modtype='0' and reportuserid=" + hrmid + " and crmid=" + crmid + " and inprepdspdate='" + dspdate + "'");
            if (rs.next()) {
                if("9".equals(rs.getString("inputstatus")))
                    returnvalue = "1|";
                else
                    returnvalue = "2|";
            } else {
                returnvalue = "0|";
            }
            //判断是否所有统计客户都有填报
            rs.executeSql("select crmids,cycle from T_CollectSettingInfo where reporthrmid=" + reporthrmid);
            while (rs.next()) {
                String crmids = weaver.general.Util.null2String(rs.getString("crmids"));
                String cycle = weaver.general.Util.null2String(rs.getString("cycle"));
                String sqlwhere = "";
                java.util.ArrayList crmidlist = weaver.general.Util.TokenizerString(crmids, ",");
                java.util.ArrayList templist = new java.util.ArrayList();
                switch (weaver.general.Util.getIntValue(cycle)) {
                    case 1://半月
                        sqlwhere = " and reportdate>='" + year + "-" + month + "-01' and reportdate<='" + year + "-" + month + "-15'";
                        break;
                    case 2: //月
                        sqlwhere = " and reportdate>='" + year + "-" + month + "-01' and reportdate<='" + year + "-" + month + "-31'";
                        break;
                    case 3: //季
                        if (weaver.general.Util.getIntValue(month) < 4) {
                            sqlwhere = " and reportdate>='" + year + "-01-01' and reportdate<='" + year + "-03-31'";
                        } else if (weaver.general.Util.getIntValue(month) < 7) {
                            sqlwhere = " and reportdate>='" + year + "-04-01' and reportdate<='" + year + "-06-31'";
                        } else if (weaver.general.Util.getIntValue(month) < 10) {
                            sqlwhere = " and reportdate>='" + year + "-07-01' and reportdate<='" + year + "-09-31'";
                        } else {
                            sqlwhere = " and reportdate>='" + year + "-10-01' and reportdate<='" + year + "-12-31'";
                        }
                        break;
                    case 4://半年
                        if (weaver.general.Util.getIntValue(month) < 7) {
                            sqlwhere = " and reportdate>='" + year + "-01-01' and reportdate<='" + year + "-06-31'";
                        } else {
                            sqlwhere = " and reportdate>='" + year + "-07-01' and reportdate<='" + year + "-12-31'";
                        }
                        break;
                    case 5://年
                        sqlwhere = " and reportdate>='" + year + "-01-01' and reportdate<='" + year + "-12-31'";
                        break;
                }
                rs1.executeSql("select d.inpreptablename from t_inputreporthrm a,t_collectsettinginfo b,t_collecttableinfo c,T_InputReport d where a.id=b.reporthrmid and b.id=c.collectid and c.inprepid=d.inprepid and a.inprepid="+inprepid);
                while(rs1.next()){
                    if(tablenames.indexOf(rs1.getString(1))<0) tablenames.add(rs1.getString(1));
                }
                if(tablenames.size()<1) tablenames.add(tablename);
                //判断是否所有统计客户都有填报
                for(int j=0;j<tablenames.size();j++){
                    rs1.executeSql("select distinct crmid from " + tablenames.get(j) + " where inputstatus='4' and modtype='0' and crmid in(" + crmids + ")" + sqlwhere);
                    while (rs1.next()) {
                        templist.add(rs1.getString("crmid"));
                    }
                    for (int i = 0; i < crmidlist.size(); i++) {
                        String temp = (String) crmidlist.get(i);
                        if (templist.indexOf(temp) == -1) {
                            if (returnvalue.length()==2) {
                                returnvalue += crminfo.getCustomerInfoname(temp);
                            } else {
                                returnvalue += "," + crminfo.getCustomerInfoname(temp);
                            }
                        }
                    }
                }
            }
        }
    }
    out.print(returnvalue);
%>