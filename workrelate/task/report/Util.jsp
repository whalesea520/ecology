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
    String total = null;
    String overtime = null;
    String finish = null;
    String doing = null;
    LinkedHashMap<String, String> curValues = null;
    while(rs.next()){
        id = null2String(rs.getString("id"));
        showname = null2String(rs.getString("showname"));
        total = null2String(rs.getString("total"));
        overtime = null2String(rs.getString("overtime"));
        finish = null2String(rs.getString("finish"),"0");
        doing = null2String(rs.getString("doing"),"0");
        curValues = new LinkedHashMap<String, String>();
        curValues.put("id",id);
        curValues.put("showname",showname);
        curValues.put("total",total);
        curValues.put("overtime",overtime);
        curValues.put("finish",finish);
        curValues.put("doing",doing);
        map.put(id,curValues);
    }
    return map;
}
/**
 * 构建查询sql
 * @param beginDate 开始时间
 * @param endDate 结束时间
 * @param personType 人员类型
 * @param isSqlServer 是否是SqlServer数据库
 * @return
 */
public String getSubcpySearchSql(String beginDate,String endDate,String personType,boolean isSqlServer){
    String personTypeSql = "";
    //人员类型包含责任人
    if(personType.contains("1")){
        personTypeSql += "tm.principalid=hrm.id ";
    //人员类型包含参与人
    }else if(personType.contains("2")){
        personTypeSql += "or hrm.id in( select partnerid from TM_TaskPartner where taskid=tm.id )";
    //人员类型包含创建人
    }else if(personType.contains("3")){
        personTypeSql += "or tm.creater=hrm.id ";
    }
    if(personTypeSql.startsWith("or")){
        personTypeSql = personTypeSql.substring(2);
    }
    if(personTypeSql.length()>0){
        personTypeSql = " AND ("+personTypeSql+")";
    }else{
        personTypeSql = " AND (tm.principalid=hrm.id or tm.creater=hrm.id or hrm.id in( select partnerid from TM_TaskPartner where taskid=tm.id ))";
    }
    personTypeSql += " and (tm.deleted=0 or tm.deleted is null)";
    String sql = null;
    if(isSqlServer){
        sql = "SELECT cpy.id, "+
            "       cpy.subcompanyname showname, "+
            "       Isnull(total, 0) total, "+
            "       Isnull(overtime, 0) overtime, "+
            "       Isnull(finish, 0) finish, "+
            "       Isnull(doing, 0) doing "+
            " FROM  HrmSubCompany cpy "+
            "       LEFT JOIN (SELECT hrm.subcompanyid1, "+
            "                         Sum(A.total)  total, "+
            "                         Sum(B.overtime)  overtime, "+
            "                         Sum(C.finish) finish, "+
            "                         Sum(D.doing)  doing "+
            "                  FROM   HrmResource hrm "+
            "                         LEFT JOIN (SELECT hrm.id, "+
            "                                           Count(1) total "+
            "                                    FROM   TM_TaskInfo tm,"+
            "                                           HrmResource hrm "+
            "                                    WHERE  tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                           " + personTypeSql +
            "                                           AND hrm.status<=3 " +
            "                                    GROUP  BY hrm.id) A "+
            "                                ON hrm.id = A.id "+
            "                          LEFT JOIN (SELECT hrm.id, "+
            "                                            Count(1) overtime "+
            "                                     FROM   TM_TaskInfo tm,"+
            "                                            HrmResource hrm "+
            "                                     WHERE  tm.status = 1 "+
            "                                            AND hrm.status<=3 " +
            "                                            AND tm.enddate IS NOT NULL "+
            "                                            AND LEN(tm.enddate) >0 "+
            "                                            AND tm.enddate < CONVERT(VARCHAR(10),GETDATE(),120) "+
            "                                            AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                            " + personTypeSql +
            "                                     GROUP BY hrm.id) B "+
            "                                ON hrm.id = B.id "+
            "                         LEFT JOIN (SELECT hrm.id, "+
            "                                           Count(1) finish "+
            "                                    FROM   TM_TaskInfo tm,"+
            "                                           HrmResource hrm "+
            "                                    WHERE  tm.status = 2 "+
            "                                           AND hrm.status<=3 " +
            "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                           " + personTypeSql +
            "                                    GROUP  BY hrm.id) C "+
            "                                ON hrm.id = C.id "+
            "                         LEFT JOIN (SELECT hrm.id, "+
            "                                           Count(1) doing "+
            "                                    FROM   TM_TaskInfo tm, "+
            "                                           HrmResource hrm "+
            "                                    WHERE  tm.status = 1 "+
            "                                           AND hrm.status<=3 " +
            "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                           " + personTypeSql +
            "                                    GROUP  BY hrm.id) D "+
            "                                ON hrm.id = D.id "+
            "                  GROUP  BY hrm.subcompanyid1) E "+
            "              ON cpy.id = E.subcompanyid1 ";
    }else{
        sql = "SELECT cpy.id, "+
            "       cpy.subcompanyname showname, "+
            "       NVL(total, 0) total, "+
            "       NVL(overtime, 0) overtime, "+
            "       NVL(finish, 0) finish, "+
            "       NVL(doing, 0) doing "+
            " FROM  HrmSubCompany cpy "+
            "       LEFT JOIN (SELECT hrm.subcompanyid1, "+
            "                         Sum(A.total)  total, "+
            "                         Sum(B.overtime)  overtime, "+
            "                         Sum(C.finish) finish, "+
            "                         Sum(D.doing)  doing "+
            "                  FROM   HrmResource hrm "+
            "                         LEFT JOIN (SELECT hrm.id, "+
            "                                           Count(1) total "+
            "                                    FROM   TM_TaskInfo tm,"+
            "                                           HrmResource hrm "+
            "                                    WHERE  tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                           " + personTypeSql +
            "                                           AND hrm.status<=3 " +
            "                                    GROUP  BY hrm.id) A "+
            "                                ON hrm.id = A.id "+
            "                          LEFT JOIN (SELECT hrm.id, "+
            "                                            Count(1) overtime "+
            "                                     FROM   TM_TaskInfo tm,"+
            "                                            HrmResource hrm "+
            "                                     WHERE  tm.status = 1 "+
            "                                            AND hrm.status<=3 " +
            "                                            AND tm.enddate IS NOT NULL "+
            "                                            AND LENGTH(tm.enddate) >0 "+
            "                                            AND tm.enddate < TO_CHAR(SYSDATE,'YYYY-MM-DD') "+
            "                                            AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                            " + personTypeSql +
            "                                     GROUP BY hrm.id) B "+
            "                                ON hrm.id = B.id "+
            "                         LEFT JOIN (SELECT hrm.id, "+
            "                                           Count(1) finish "+
            "                                    FROM   TM_TaskInfo tm,"+
            "                                           HrmResource hrm "+
            "                                    WHERE  tm.status = 2 "+
            "                                           AND hrm.status<=3 " +
            "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                           " + personTypeSql +
            "                                    GROUP  BY hrm.id) C "+
            "                                ON hrm.id = C.id "+
            "                         LEFT JOIN (SELECT hrm.id, "+
            "                                           Count(1) doing "+
            "                                    FROM   TM_TaskInfo tm, "+
            "                                           HrmResource hrm "+
            "                                    WHERE  tm.status = 1 "+
            "                                           AND hrm.status<=3 " +
            "                                           AND tm.createdate BETWEEN '"+beginDate+"' AND  '"+endDate+"' " +
            "                                           " + personTypeSql +
            "                                    GROUP  BY hrm.id) D "+
            "                                ON hrm.id = D.id "+
            "                  GROUP  BY hrm.subcompanyid1) E "+
            "              ON cpy.id = E.subcompanyid1 ";
    }
    return sql;
}

%>