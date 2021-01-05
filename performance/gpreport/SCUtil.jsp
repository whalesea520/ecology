<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%! 
/**
 * 得到分数段集合
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getScoreSetting(){
   weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
   String sql = "SELECT  id , "+
             "        gardename ,"+
             "        beginSymbol ,"+
             "        beginscore ,"+
             "        endSymbol ,"+
             "        endscore "+
             "FROM    GP_ScoreSetting "+
             "ORDER BY RANK ";
   rs.execute(sql);
   LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
   String id = null;
   String gardename = null;
   String beginSymbol = null;
   String beginscore = null;
   String endSymbol = null;
   String endscore = null;
   LinkedHashMap<String, String> curValues = null;
   while(rs.next()){
       id = null2String(rs.getString("id"));
       gardename = null2String(rs.getString("gardename"));
       beginSymbol = null2String(rs.getString("beginSymbol"),"0");
       beginscore = null2String(rs.getString("beginscore"),"0");
       endSymbol = null2String(rs.getString("endSymbol"),"0");
       endscore = null2String(rs.getString("endscore"),"0");
       curValues = new LinkedHashMap<String, String>();
       curValues.put("id",id);
       curValues.put("gardename",gardename);
       curValues.put("beginSymbol",beginSymbol);
       curValues.put("beginscore",beginscore);
       curValues.put("endSymbol",endSymbol);
       curValues.put("endscore",endscore);
       map.put(id,curValues);
   }
   return map;
}
/**
 * 得到所有可以查询的分部
 */
private String getCpyAccessView(int userid){
    String sql = " SELECT resourceid "+
                 " FROM   GP_BaseSetting "+
                 " WHERE  accessview LIKE '%," +userid+ ",%' "+
                 "        AND resourcetype=2 "+
                 "        AND ismonth=1 ";
    weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
    rs.execute(sql);
    StringBuffer cpyIds = new StringBuffer();;
    while(rs.next()){
        cpyIds.append(","+rs.getString("resourceid"));
    }
    if(cpyIds.length()==0){
        return "";
    }else{
        //是否是sql server数据库
        boolean isSqlServer = rs.getDBType().equals("sqlserver");
        if(isSqlServer){
            sql = "SELECT id FROM GetSubcpyIdsTreeWithSelf ('"+cpyIds.substring(1)+"')";
        }else{
            sql = "WITH mycte(id) "+
                    "     AS (SELECT id "+
                    "         FROM   HrmSubCompany "+
                    "         WHERE  1=1 "+
                    "               and id in("+cpyIds.substring(1)+")"+
                    "               AND (canceled IS NULL  "+
                    "                   OR  canceled!=1) "+
                    "         UNION ALL "+
                    "         SELECT hrm.id "+
                    "         FROM   HrmSubCompany hrm, "+
                    "                mycte "+
                    "         WHERE  hrm.supsubcomid = mycte.id "+
                    "                AND (canceled IS NULL  "+
                    "                   OR  canceled!=1)) "+
                    " SELECT DISTINCT * "+
                    " FROM   mycte ";
        }
        rs.execute(sql);
    }
    cpyIds.setLength(0);
    while(rs.next()){
        cpyIds.append(","+rs.getString(1));
    }
    return cpyIds.substring(1);
}

/**
 * 把所有分部的数据放到集合中
 * @return
 */
private LinkedHashMap<String,LinkedHashMap<String, String>> getWorkerResult(weaver.conn.RecordSet rs,int scoreMapSize){
        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        String id = null;
        String showname = null;
        LinkedHashMap<String, String> curValues = null;
        String tempKey = null;
        while(rs.next()){
            id = null2String(rs.getString("id"));
            showname = null2String(rs.getString("showname"));
            
            curValues = new LinkedHashMap<String, String>();
            curValues.put("id",id);
            curValues.put("showname",showname);
            for(int i=0;i<scoreMapSize;i++){
                tempKey = "l" + i;
                curValues.put(tempKey,null2String(rs.getString(tempKey),"0"));
            }
            map.put(id,curValues);
        }
        return map;
    }
/**
 * 构建查询sql
 *
 * @param year 年
 * @param month 月
 * @param scoreMap 分数段集合
 * @param isSqlServer 是否sqlserver数据库
 * @return
 */
public String getSubcpySearchSql(String year,String month,LinkedHashMap<String,LinkedHashMap<String, String>> scoreMap,boolean isSqlServer){
    year = "".equals(year)?""+Calendar.getInstance().get(Calendar.YEAR):year;
    String type = "1";
    String type2 = month;
    
    ArrayList<Map.Entry<String,LinkedHashMap<String,String>>> mapList=new ArrayList<Map.Entry<String,LinkedHashMap<String,String>>>(scoreMap.entrySet());
    StringBuffer fieldStrSB = new StringBuffer();
    StringBuffer tableStrSB = new StringBuffer();
    String beginSymbol = null;
    String beginscore = null;
    String endSymbol = null;
    String endscore = null;
    for(int i=0;i<mapList.size();i++){
        Entry<String,LinkedHashMap<String,String>> obj=mapList.get(i);
        LinkedHashMap<String,String> curMap = obj.getValue();
        beginSymbol = getSymbol(curMap.get("beginSymbol"));
        beginscore = curMap.get("beginscore");
        endSymbol = getSymbol(curMap.get("endSymbol"));
        endscore = curMap.get("endscore");
        fieldStrSB.append(", t"+i + ".l"+i);
	    //如果是sql server数据库
	    if(isSqlServer){
	    	tableStrSB.append(" LEFT JOIN ( SELECT  hrm.subcompanyid1 , "+
                              "          COUNT(*) l"+i+
                              "  FROM    HrmResource hrm , "+
                              "          GP_AccessScore gp "+
                              "  WHERE   hrm.id = gp.userid "+
                              "          AND hrm.status<=3 "+
                              "          AND gp.status = 3 "+
                              "          AND gp.year = '"+year+"' "+
                              "          AND gp.type1 = '"+type+"' "+
                              "          AND gp.type2 = '"+type2+"' "+ 
                              "          AND gp.result"+beginSymbol+ "(" +beginscore +"/5*ISNULL((SELECT ISNULL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                              "          AND gp.result"+endSymbol+ "(" +endscore +"/5*ISNULL((SELECT ISNULL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                              "  GROUP BY hrm.subcompanyid1 "+
                             ") t"+i+" ON sub.id = t"+i+".subcompanyid1");
	    }else{
	    	tableStrSB.append(" LEFT JOIN ( SELECT  hrm.subcompanyid1 , "+
                              "          COUNT(*) l"+i+
                              "  FROM    HrmResource hrm , "+
                              "          GP_AccessScore gp "+
                              "  WHERE   hrm.id = gp.userid "+
                              "          AND hrm.status<=3 "+
                              "          AND gp.status = 3 "+
                              "          AND gp.year = '"+year+"' "+
                              "          AND gp.type1 = '"+type+"' "+
                              "          AND gp.type2 = '"+type2+"' "+ 
                              "          AND gp.result"+beginSymbol+ "(" +beginscore +"/5*NVL((SELECT NVL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                              "          AND gp.result"+endSymbol+ "(" +endscore +"/5*NVL((SELECT NVL(bs.scoreSetting,5) FROM GP_BaseSetting bs WHERE bs.resourceid=hrm.subcompanyid1 AND bs.resourcetype=1 AND bs.ismonth=1),5)) "+
                              "  GROUP BY hrm.subcompanyid1 "+
                             ") t"+i+" ON sub.id = t"+i+".subcompanyid1");
	    }
    }
    String sql = " SELECT  sub.id , "+
                 "         sub.subcompanyname showname,"+fieldStrSB.substring(1)+
                 " FROM    HrmSubCompany sub " + tableStrSB.toString();
    return sql;
}
/**
 * 根据传入符号的值得到数据查询的符号
 */
public String getSymbol(String symbolValue){
    String symbol = null;
    if("1".equals(symbolValue)){
        symbol = ">";
    }else if("2".equals(symbolValue)){
        symbol = ">=";
    }else if("3".equals(symbolValue)){
        symbol = "<";
    }else if("4".equals(symbolValue)){
        symbol = "<=";
    }
    return symbol;
}

/**
 * 根据传入符号的值得到数据查询的符号
 */
public String getSymbolStr(String symbolValue){
    String symbol = null;
    if("1".equals(symbolValue)){
        symbol = "(";
    }else if("2".equals(symbolValue)){
        symbol = "[";
    }else if("3".equals(symbolValue)){
        symbol = ")";
    }else if("4".equals(symbolValue)){
        symbol = "]";
    }
    return symbol;
}
/**
 * 得到分数段值范围
 */
public String getValueSize(LinkedHashMap<String, String> map){
    return  getSymbolStr(map.get("beginSymbol"))+
            map.get("beginscore")+
            ","+
            map.get("endscore")+
            getSymbolStr(map.get("endSymbol"));
}
%>