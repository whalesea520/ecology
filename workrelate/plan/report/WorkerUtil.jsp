<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%! 
/**
 * 构建查询sql
 *
 * @param year 年
 * @param type  查询类型（1：月；2：周）
 * @return
 */
public String getSearchSql(String year,String type,String hrmids){
year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
String sql="SELECT hrm.id, "+
        "          pr.type1,"+
        "          pr.type2,"+
        "          pr.status"+
        "   FROM   PR_PlanReport pr,"+
        "          HrmResource hrm"+
        "   WHERE  pr.userid = hrm.id"+
     ((hrmids!=null&&!"".equals(hrmids))
    ?"          AND pr.userid IN("+hrmids+")"
    :"")+
        "          AND hrm.status<=3 "+
        "          AND pr.type1 = 1"+
        "          AND pr.year = '"+year+"'"+
        "   ORDER  BY hrm.id";
    return sql;
}
/**
 * 构建查询sql
 *
 * @param year 年
 * @param type  查询类型（1：月；2：周）
 * @return
 */
public String getWeekSearchSql(String year,int weeknum,String hrmids){
    year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
    String hrmidsSql1=isEmpty(hrmids)?"":" AND hrm.id IN("+hrmids+") ";
    String hrmidsSql2=isEmpty(hrmids)?"":" AND pr.userid IN("+hrmids+") ";
    StringBuffer sb = new StringBuffer();
    for(int i=1; i<=weeknum; i++){
    	sb.append(",Max(CASE WHEN pr.type2 = "+i+" THEN pr.status ELSE -1 END) week"+i+" ");
    }
    String sql1="SELECT hrm.id, "+
	        "          hrm.lastname,"+
	        "          cpy.subcompanyname,"+
	        "          dept.departmentname,"+
	        "          hrm.dsporder"+
	        "   FROM   HrmResource hrm,"+
	        "          HrmSubCompany cpy,"+
	        "          HrmDepartment dept"+
	        "   WHERE  hrm.departmentid = dept.id"+
	        "          AND status<=3 "+
	        "          AND dept.subcompanyid1 = cpy.id"+ hrmidsSql1;
    
    String sql2="SELECT pr.userid "+sb.toString() +
               " FROM   PR_PlanReport pr "+
               " WHERE  pr.year = '"+year+"' "+
               "        AND pr.type1 = 2 "+ hrmidsSql2 +
               " GROUP  BY pr.userid ";
    
    String sql = "SELECT A.id id, "+
    		 "           A.lastname, "+
             "           A.subcompanyname, "+
             "           A.departmentname, "+
             "           B.* "+
             "    FROM   ("+sql1+") A "+
             "    LEFT   JOIN ("+sql2+") B "+
             "           ON A.id = B.userid "+
             "    ORDER BY A.dsporder";
    return sql;
}

/**
 * 通过查询结果，组合成展示数据
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerWeekResult(weaver.conn.RecordSet rs,int weeknum) {
    LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    String id = null;
    String lastname = null;
    String subcompanyname = null;
    String departmentname = null;
    String week = null;
    LinkedHashMap<String, String> curValues = null;
    while(rs.next()){
        id = null2String(rs.getString("id"));
        lastname = null2String(rs.getString("lastname"));
        subcompanyname = null2String(rs.getString("subcompanyname"));
        departmentname = null2String(rs.getString("departmentname"));

        curValues = new LinkedHashMap<String, String>();
        curValues.put("id",id);
        curValues.put("lastname",lastname);
        curValues.put("subcompanyname",subcompanyname);
        curValues.put("departmentname",departmentname);
        for(int i=1;i<=weeknum;i++){
        	week = null2String(rs.getString("week"+i),"n");
            curValues.put("week"+i,week);
        }
        map.put(id,curValues);
    }
    return map;
}

/**
 * 得到数据集合
 * @param map
 * @param maxMonth
 * @return
 */
public LinkedHashMap<String,LinkedHashMap<String,String>> setData(LinkedHashMap<String,LinkedHashMap<String,String>> map,
        LinkedHashMap<String,LinkedHashMap<String,String>> hrmInfoMap,int maxMonth){
    LinkedHashMap<String, String> curValues = null;
    LinkedHashMap<String, String> infoValues = null;
    for (Entry<String,LinkedHashMap<String,String>> obj : hrmInfoMap.entrySet()) {
        infoValues = obj.getValue();
        curValues = map.get(obj.getKey());
        if(curValues == null){
            for (int i = 1; i <= maxMonth; i++) {
                infoValues.put("month" + i,"n");
            }
            infoValues.put("rate","0.0%");
            for (int i = maxMonth+1; i <= 12; i++) {
                infoValues.put("month" + i,"-");
            }
        }else{
            int rateNum = 0;
            for (int i = 1; i <= maxMonth; i++) {
                if(curValues.get("month" + i)==null || "".equals(curValues.get("month" + i))){
                    curValues.put("month" + i,"n");
                }else if("3".equals(curValues.get("month" + i))){
                    rateNum++;
                }
            }
            DecimalFormat df = new DecimalFormat("0.00");
            curValues.put("rate",df.format(rateNum*100.0/maxMonth)+"%");
            for (int i = maxMonth+1; i <= 12; i++) {
                if(curValues.get("month" + i)==null || "".equals(curValues.get("month" + i))){
                    curValues.put("month" + i,"-");
                }
            }
            infoValues.putAll(curValues);
        }
        
    }
    return hrmInfoMap;
}




/**
 * 获得用户信息
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getHrmInfo(weaver.conn.RecordSet rs) {
    LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
    String id = null;
    String lastname = null;
    String subcompanyname = null;
    String departmentname = null;
    LinkedHashMap<String, String> curValues = null;
    while(rs.next()){
        id = null2String(rs.getString("id"));
        lastname = null2String(rs.getString("lastname"));
        subcompanyname = null2String(rs.getString("subcompanyname"));
        departmentname = null2String(rs.getString("departmentname"));
        curValues = new LinkedHashMap<String, String>();
        curValues.put("id",id);
        curValues.put("lastname",lastname);
        curValues.put("subcompanyname",subcompanyname);
        curValues.put("departmentname",departmentname);
        map.put(id,curValues);
    }
    return map;
}

/**
* 通过查询结果，组合成展示数据
* @return
*/
private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerResult(weaver.conn.RecordSet rs) {
 LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
 String id = null;
 String lastname = null;
 String subcompanyname = null;
 String departmentname = null;
 String type1 = null;
 String type2 = null;
 String status = null;
 LinkedHashMap<String, String> curValues = null;
 while(rs.next()){
     id = null2String(rs.getString("id"));
     type1 = null2String(rs.getString("type1"));
     type2 = null2String(rs.getString("type2"));//月份
     status = null2String(rs.getString("status"),"0");
     if(map.get(id) != null){
         curValues = map.get(id);
         curValues.put("month" + type2,status);
     }else{
         curValues = new LinkedHashMap<String, String>();
         curValues.put("id",id);
         curValues.put("type1",type1);
         curValues.put("month" + type2,status);
     }
     map.put(id,curValues);
 }
 return map;
}
    
%>