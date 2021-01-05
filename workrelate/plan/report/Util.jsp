<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%! 
	/**
	 * 把所有分部的数据放到集合中
	 * @return
	 */
	private LinkedHashMap<String, LinkedHashMap<String, String>> getWorkerResult(
	        weaver.conn.RecordSet rs) {
		LinkedHashMap<String, LinkedHashMap<String, String>> map = new LinkedHashMap<String, LinkedHashMap<String, String>>();
		String id = null;
		String showname = null;
		String exist = null;
		String without = null;
		String scoring = null;
		String assessing = null;
		String back = null;
		String finish = null;
		String oscoring = null;
		String oassessing = null;
		String oback = null;
		LinkedHashMap<String, String> curValues = null;
		while (rs.next()) {
			id = Util.null2String(rs.getString("id"));
			showname = Util.null2String(rs.getString("showname"));
			exist = Util.null2String(rs.getString("exist"));
			without = Util.null2String(rs.getString("without"), "0");
			scoring = Util.null2String(rs.getString("scoring"), "0");
			assessing = Util.null2String(rs.getString("assessing"), "0");
			back = Util.null2String(rs.getString("back"), "0");
			finish = Util.null2String(rs.getString("finish"), "0");
			oscoring = Util.null2String(rs.getString("oscoring"), "0");
			oassessing = Util.null2String(rs.getString("oassessing"), "0");
			oback = Util.null2String(rs.getString("oback"), "0");
			curValues = new LinkedHashMap<String, String>();
			curValues.put("id", id);
			curValues.put("showname", showname);
			curValues.put("exist", exist);
			curValues.put("without", without);
			curValues.put("scoring", scoring);
			curValues.put("assessing", assessing);
			curValues.put("back", back);
			curValues.put("finish", finish);
			curValues.put("oscoring", oscoring);
			curValues.put("oassessing", oassessing);
			curValues.put("oback", oback);
			map.put(id, curValues);
		}
		return map;
	}
    /**
     * 构建查询sql
     *
     * @param year 年
     * @param month 月
     * @param week  周
     * @param type  查询类型（1：月；2：周）
     * @param isSqlServer  是否sqlserver数据库
     * @return
     */
    public String getSubcpySearchSql(String year,String month,String week,String type,boolean isSqlServer){
        year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
        int wcount = 0;
        String type2 = "1".equals(type)?month:week;
        String isType = "1".equals(type)?" AND ismonth=1 ":" AND isweek=1 ";
        String sql = null;
        if("2".equals(type) && week.indexOf(",")>-1){
        	String[] weeks = week.split(",");
        	if(weeks.length==2){
        		int w1 = Util.getIntValue(weeks[0],1);
        		int w2 = Util.getIntValue(weeks[1],1);
        		type2 = "";
        		for(int i=w1;i<=w2;i++){
        			type2 += "," + i;
        			wcount++;
        		}
        		if(!type2.equals("")) type2 = type2.substring(1);
        	}
        }
        if(wcount==0) wcount = 1;
        //如果是sql server数据库
        if(isSqlServer){
            sql = "SELECT  sc.id , "+
            "        sc.subcompanyname showname, "+
            "        ISNULL(A.exist, 0) exist , "+
            "        (ISNULL(A.exist, 0)-ISNULL(B.without, 0)) without , "+
            "        ISNULL(C.scoring, 0) scoring , "+
            "        ISNULL(D.assessing, 0) assessing , "+
            "        ISNULL(BK.back, 0) back , "+
            "        ISNULL(E.finish, 0) finish, "+
            "        ISNULL(F.oscoring, 0) oscoring , "+
            "        ISNULL(G.oassessing, 0) oassessing,  "+
            "        ISNULL(OBK.oback, 0) oback  "+
            "FROM    HrmSubCompany sc "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1)*"+wcount+" exist "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) A ON A.subcompanyid1 = sc.id "+
            /* "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) without "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND hrm.id NOT in ( "+
            "                                  SELECT userid "+
            "                                  FROM   PR_PlanReport "+
            "                                 WHERE   year = '"+year+"' "+
            "                                         AND type1 = '"+type+"' "+
            "                                         AND type2 in ("+type2+") "+ 
            "                             ) "+
            "                            AND hrm.subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) B ON B.subcompanyid1 = sc.id "+ */
    		"        LEFT JOIN ( SELECT  hrm.subcompanyid1 , "+
            "                            COUNT(1) without "+
            "                    FROM    PR_PlanReport p,HrmResource hrm "+
            "                    WHERE   hrm.status<=3 and p.userid=hrm.id"+
            "                            AND p.year = '"+year+"' "+
            "                            AND p.type1 = '"+type+"' "+
            "                            AND p.type2 in ("+type2+") "+ 
            "                            AND hrm.subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY hrm.subcompanyid1 "+
            "                  ) B ON B.subcompanyid1 = sc.id "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) scoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()<=Cast(score.enddate AS DATETIME) "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) C ON C.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) assessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()<=SCORE.enddate "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) D ON D.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) back "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()<=SCORE.enddate "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) BK ON D.subcompanyid1 = sc.id "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) finish "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 3 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                    GROUP BY subcompanyid1 "+
            "                  ) E ON E.subcompanyid1 = sc.id "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) oscoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) F ON F.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) oassessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) G ON G.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) oback "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) OBK ON OBK.subcompanyid1 = sc.id ";
        }else{
            sql = "SELECT  sc.id , "+
            "        sc.subcompanyname showname, "+
            "        NVL(A.exist, 0) exist , "+
            "        (NVL(A.exist, 0)-NVL(B.without, 0)) without , "+
            "        NVL(C.scoring, 0) scoring , "+
            "        NVL(D.assessing, 0) assessing , "+
            "        NVL(BK.back, 0) back , "+
            "        NVL(E.finish, 0) finish, "+
            "        NVL(F.oscoring, 0) oscoring , "+
            "        NVL(G.oassessing, 0) oassessing,  "+
            "        NVL(OBK.oback, 0) oback  "+
            "FROM    HrmSubCompany sc "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1)*"+wcount+" exist "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) A ON A.subcompanyid1 = sc.id "+
            /* "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) without "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND hrm.id NOT in ( "+
            "                                  SELECT userid "+
            "                                  FROM   PR_PlanReport "+
            "                                  WHERE  year = '"+year+"' "+
            "                                         AND type1 = '"+type+"' "+
            "                                         AND type2 in ("+type2+") "+ 
            "                             ) "+
            "                            AND hrm.subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) B ON B.subcompanyid1 = sc.id "+ */
    		"        LEFT JOIN ( SELECT  hrm.subcompanyid1 , "+
            "                            COUNT(1) without "+
            "                    FROM    PR_PlanReport p,HrmResource hrm "+
            "                    WHERE   hrm.status<=3 and p.userid=hrm.id"+
            "                            AND p.year = '"+year+"' "+
            "                            AND p.type1 = '"+type+"' "+
            "                            AND p.type2 in ("+type2+") "+ 
            "                            AND hrm.subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY hrm.subcompanyid1 "+
            "                  ) B ON B.subcompanyid1 = sc.id "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) scoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) C ON C.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) assessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd')  "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) D ON D.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) back "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd')  "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) BK ON D.subcompanyid1 = sc.id "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) finish "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 3 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                    GROUP BY subcompanyid1 "+
            "                  ) E ON E.subcompanyid1 = sc.id "+
            "        LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) oscoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) F ON F.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) oassessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) G ON G.subcompanyid1 = sc.id "+
            "         LEFT JOIN ( SELECT  subcompanyid1 , "+
            "                            COUNT(1) oback "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY subcompanyid1 "+
            "                  ) OBK ON OBK.subcompanyid1 = sc.id ";
        }
        return sql;
    }

    
    /**
     * 构建部门查询sql
     *
     * @param year 年
     * @param month 月
     * @param week  周
     * @param type  查询类型（1：月；2：周）
     * @return
     */
    public String getDeptSearchSql(String year,String month,String week,String type,boolean isSqlServer){
        year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
        int wcount = 0;
        String type2 = "1".equals(type)?month:week;
        String isType = "1".equals(type)?" AND ismonth=1 ":" AND isweek=1 "; 
        String sql = null;
        if("2".equals(type) && week.indexOf(",")>-1){
        	String[] weeks = week.split(",");
        	if(weeks.length==2){
        		int w1 = Util.getIntValue(weeks[0],1);
        		int w2 = Util.getIntValue(weeks[1],1);
        		type2 = "";
        		for(int i=w1;i<=w2;i++){
        			type2 += "," + i;
        			wcount++;
        		}
        		if(!type2.equals("")) type2 = type2.substring(1);
        	}
        }
        if(wcount==0) wcount = 1;
        if(isSqlServer){
            sql = "SELECT  dept.id , "+
            "        dept.departmentname showname, "+
            "        ISNULL(A.exist, 0) exist , "+
            "        (ISNULL(A.exist, 0)-ISNULL(B.without, 0)) without , "+
            "        ISNULL(C.scoring, 0) scoring , "+
            "        ISNULL(D.assessing, 0) assessing , "+
            "        ISNULL(BK.back, 0) back , "+
            "        ISNULL(E.finish, 0) finish, "+
            "        ISNULL(F.oscoring, 0) oscoring , "+
            "        ISNULL(G.oassessing, 0) oassessing,  "+
            "        ISNULL(OBK.oback, 0) oback  "+
            "FROM    HrmDepartment dept "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1)*"+wcount+" exist "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY departmentid "+
            "                  ) A ON A.departmentid = dept.id "+
            /* "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) without "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND hrm.id NOT in ( "+
            "		                           SELECT userid "+
            "                                  FROM   PR_PlanReport"+
            "                                 WHERE   year = '"+year+"' "+
            "                                         AND type1 = '"+type+"' "+
            "                                         AND type2 in ("+type2+") "+ 
            "                             ) "+
            "                            AND subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY departmentid "+
            "                  ) B ON B.departmentid = dept.id "+ */
    		"        LEFT JOIN ( SELECT  hrm.departmentid , "+
            "                            COUNT(1) without "+
            "                    FROM    PR_PlanReport p,HrmResource hrm "+
            "                    WHERE   hrm.status<=3 and p.userid=hrm.id"+
            "                            AND p.year = '"+year+"' "+
            "                            AND p.type1 = '"+type+"' "+
            "                            AND p.type2 in ("+type2+") "+ 
            "                            AND hrm.subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY hrm.departmentid "+
            "                  ) B ON B.departmentid = dept.id "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) scoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()<=Cast(score.enddate AS DATETIME) "+
            "                    GROUP BY departmentid "+
            "                  ) C ON C.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) assessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()<=CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY departmentid "+
            "                  ) D ON D.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) back "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()<=CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY departmentid "+
            "                  ) BK ON BK.departmentid = dept.id "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) finish "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 3 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                    GROUP BY departmentid "+
            "                  ) E ON E.departmentid = dept.id "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) oscoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY departmentid "+
            "                  ) F ON F.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) oassessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY departmentid "+
            "                  ) G ON G.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) oback "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
            "                    GROUP BY departmentid "+
            "                  ) OBK ON OBK.departmentid = dept.id ";
        }else{
            sql = "SELECT  dept.id , "+
            "        dept.departmentname showname, "+
            "        NVL(A.exist, 0) exist , "+
            "        (NVL(A.exist, 0)-NVL(B.without, 0)) without , "+
            "        NVL(C.scoring, 0) scoring , "+
            "        NVL(D.assessing, 0) assessing , "+
            "        NVL(BK.back, 0) back , "+
            "        NVL(E.finish, 0) finish, "+
            "        NVL(F.oscoring, 0) oscoring , "+
            "        NVL(G.oassessing, 0) oassessing,  "+
            "        NVL(OBK.oback, 0) oback  "+
            "FROM    HrmDepartment dept "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1)*"+wcount+" exist "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY departmentid "+
            "                  ) A ON A.departmentid = dept.id "+
            /* "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) without "+
            "                    FROM    HrmResource hrm "+
            "                    WHERE   hrm.status<=3 "+
            "                            AND hrm.id NOT in ( "+
            "		                           SELECT userid "+
            "                                  FROM   PR_PlanReport"+
            "                                 WHERE   year = '"+year+"' "+
            "                                         AND type1 = '"+type+"' "+
            "                                         AND type2 in ("+type2+") "+ 
            "                             ) "+
            "                            AND subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY departmentid "+
            "                  ) B ON B.departmentid = dept.id "+ */
    		"        LEFT JOIN ( SELECT  hrm.departmentid , "+
            "                            COUNT(1) without "+
            "                    FROM    PR_PlanReport p,HrmResource hrm "+
            "                    WHERE   hrm.status<=3 and p.userid=hrm.id"+
            "                            AND p.year = '"+year+"' "+
            "                            AND p.type1 = '"+type+"' "+
            "                            AND p.type2 in ("+type2+") "+ 
            "                            AND hrm.subcompanyid1 IN ( "+
            "                                    SELECT resourceid  "+
            "                                    FROM   PR_BaseSetting  "+
            "                                    WHERE  resourcetype=2 "+isType+") "+
            "                    GROUP BY hrm.departmentid "+
            "                  ) B ON B.departmentid = dept.id "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) scoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY departmentid "+
            "                  ) C ON C.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) assessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY departmentid "+
            "                  ) D ON D.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) back "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY departmentid "+
            "                  ) BK ON BK.departmentid = dept.id "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) finish "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 3 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                    GROUP BY departmentid "+
            "                  ) E ON E.departmentid = dept.id "+
            "        LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) oscoring "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 0 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY departmentid "+
            "                  ) F ON F.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) oassessing "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 1 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY departmentid "+
            "                  ) G ON G.departmentid = dept.id "+
            "         LEFT JOIN ( SELECT  departmentid , "+
            "                            COUNT(1) oback "+
            "                    FROM    HrmResource hrm , "+
            "                            PR_PlanReport score "+
            "                    WHERE   hrm.id = score.userid "+
            "                            AND hrm.status<=3 "+
            "                            AND score.status = 2 "+
            "                            AND year = '"+year+"' "+
            "                            AND type1 = '"+type+"' "+
            "                            AND type2 in ("+type2+") "+ 
            "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
            "                    GROUP BY departmentid "+
            "                  ) OBK ON OBK.departmentid = dept.id ";
        }
        return sql;
    }
    
%>