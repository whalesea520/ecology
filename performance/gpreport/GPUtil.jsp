<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%! 
	/**
	 * 把所有分部的数据放到集合中
	 * @return
	 */
	private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerResult(weaver.conn.RecordSet rs){
        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
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
        while(rs.next()){
            id = null2String(rs.getString("id"));
            showname = null2String(rs.getString("showname"));
            exist = null2String(rs.getString("exist"));
            without = null2String(rs.getString("without"),"0");
            scoring = null2String(rs.getString("scoring"),"0");
            assessing = null2String(rs.getString("assessing"),"0");
            back = null2String(rs.getString("back"),"0");
            finish = null2String(rs.getString("finish"),"0");
            oscoring = null2String(rs.getString("oscoring"),"0");
            oassessing = null2String(rs.getString("oassessing"),"0");
            oback = null2String(rs.getString("oback"),"0");
            curValues = new LinkedHashMap<String, String>();
            curValues.put("id",id);
            curValues.put("showname",showname);
            curValues.put("exist",exist);
            curValues.put("without",without);
            curValues.put("scoring",scoring);
            curValues.put("assessing",assessing);
            curValues.put("back",back);
            curValues.put("finish",finish);
            curValues.put("oscoring",oscoring);
            curValues.put("oassessing",oassessing);
            curValues.put("oback",oback);
            map.put(id,curValues);
        }
        return map;
    }
	/**
	 * 构建查询sql
	 *
	 * @param year 年
	 * @param month 月
	 * @param isSqlServer 是否sqlserver数据库
	 * @return
	 */
	public String getSubcpySearchSql(String year,String month,boolean isSqlServer){
		year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
		String type = "1";
		String type2 = month;
		String sql = null;
	    //如果是sql server数据库
	    if(isSqlServer){
		    sql = "SELECT  sc.id , "+
	        "        sc.subcompanyname showname, "+
	        "        ISNULL(A.exist, 0) exist , "+
	        "        ISNULL(B.without, 0) without , "+
	        "        ISNULL(C.scoring, 0) scoring , "+
	        "        ISNULL(D.assessing, 0) assessing , "+
	        "        ISNULL(BK.back, 0) back , "+
	        "        ISNULL(E.finish, 0) finish, "+
	        "        ISNULL(F.oscoring, 0) oscoring , "+
	        "        ISNULL(G.oassessing, 0) oassessing,  "+
	        "        ISNULL(OBK.oback, 0) oback  "+
	        "FROM    HrmSubCompany sc "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) exist "+
	        "                    FROM    HrmResource hrm "+
	        "                    WHERE   hrm.status<=3 AND EXISTS ( SELECT 1 "+
	        "                                     FROM   GP_AccessProgram ap "+
	        "                                     WHERE  hrm.id = ap.userid "+
	        "                                            AND ap.status = 3 ) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) A ON A.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) without "+
	        "                    FROM    HrmResource hrm "+
	        "                    WHERE   hrm.status<=3 AND hrm.id NOT in ( SELECT ap.userid "+
	        "                                     FROM   GP_AccessProgram ap "+
	        "                                     WHERE  ap.status = 3 ) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) B ON B.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) scoring "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 0 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND GETDATE()<Cast(score.enddate AS DATETIME) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) C ON C.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) assessing "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 1 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND GETDATE()<SCORE.enddate "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) D ON D.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) back "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 2 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND GETDATE()<SCORE.enddate "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) BK ON D.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) finish "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 3 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) E ON E.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) oscoring "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 0 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) F ON F.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) oassessing "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 1 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) G ON G.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) oback "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 2 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND GETDATE()>CAST(score.enddate AS DATETIME) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) OBK ON OBK.subcompanyid1 = sc.id ";
	    }else{
		    sql = "SELECT  sc.id , "+
	        "        sc.subcompanyname showname, "+
	        "        NVL(A.exist, 0) exist , "+
	        "        NVL(B.without, 0) without , "+
	        "        NVL(C.scoring, 0) scoring , "+
	        "        NVL(D.assessing, 0) assessing , "+
	        "        NVL(BK.back, 0) back , "+
	        "        NVL(E.finish, 0) finish, "+
	        "        NVL(F.oscoring, 0) oscoring , "+
	        "        NVL(G.oassessing, 0) oassessing,  "+
	        "        NVL(OBK.oback, 0) oback  "+
	        "FROM    HrmSubCompany sc "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) exist "+
	        "                    FROM    HrmResource hrm "+
	        "                    WHERE   hrm.status<=3 AND EXISTS ( SELECT 1 "+
	        "                                     FROM   GP_AccessProgram ap "+
	        "                                     WHERE  hrm.id = ap.userid "+
	        "                                            AND ap.status = 3 ) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) A ON A.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) without "+
	        "                    FROM    HrmResource hrm "+
	        "                    WHERE   hrm.status<=3 AND hrm.id NOT in ( SELECT ap.userid "+
	        "                                     FROM   GP_AccessProgram ap "+
	        "                                     WHERE  ap.status = 3 ) "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) B ON B.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) scoring "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 0 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) C ON C.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) assessing "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 1 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) D ON D.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) back "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 2 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND SYSDATE<=TO_DATE(score.enddate,'yyyy-mm-dd') "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) BK ON D.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) finish "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 3 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) E ON E.subcompanyid1 = sc.id "+
	        "        LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) oscoring "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 0 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) F ON F.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) oassessing "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 1 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) G ON G.subcompanyid1 = sc.id "+
	        "         LEFT JOIN ( SELECT  subcompanyid1 , "+
	        "                            COUNT(1) oback "+
	        "                    FROM    HrmResource hrm , "+
	        "                            GP_AccessScore score "+
	        "                    WHERE   hrm.id = score.userid "+
	        "                            AND hrm.status<=3 "+
	        "                            AND score.status = 2 "+
	        "                            AND year = '"+year+"' "+
	        "                            AND type1 = '"+type+"' "+
	        "                            AND type2 = '"+type2+"' "+ 
	        "                            AND SYSDATE>TO_DATE(score.enddate,'yyyy-mm-dd') "+
	        "                    GROUP BY subcompanyid1 "+
	        "                  ) OBK ON OBK.subcompanyid1 = sc.id ";
	    }
	    return sql;
	}
%>