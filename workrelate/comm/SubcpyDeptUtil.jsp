<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.Map.Entry"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%! 
    /**
     * 得到分部树查询sql
     */
    private String getSubCpyTree(boolean isSqlServer){
        String sql = null;
        if(isSqlServer){
            sql = "select * from GetSubCpyTree() order by level desc,showorder,id";
        }else{
            sql=" select id, "+
	            "        subcompanyname, "+
	            "        supsubcomid, "+
	            "        substr(code, 2) code, "+
	            "        (length(lv) / 2) \"level\" "+
	            "   from (select id, "+
	            "                subcompanyname, "+
	            "                supsubcomid, "+
	            "                showorder, "+
	            "                SYS_CONNECT_BY_PATH(cpy.id, '_') code, "+
	            "                SYS_CONNECT_BY_PATH('a', '_') as lv "+
	            "           FROM HrmSubCompany cpy "+
	            "          START WITH cpy.supsubcomid = 0 "+
	            "         CONNECT BY PRIOR cpy.id = cpy.supsubcomid) t "+
	            "  order by \"level\" desc,showorder asc, id asc ";
        }
        return sql;
    }

    /**
     * 得到部门树查询sql
     */
    private String getDeptTree(boolean isSqlServer){
        String sql = null;
        if(isSqlServer){
            sql = "select * from getdepttree() order by level desc,showorder,id";
        }else{
            sql =   " select id, "+
		            "        departmentname, "+
		            "        supdepid, "+
		            "        subcompanyid1, "+
		            "        'dept_' || substr(code, 2) code, "+
		            "        (length(lv) / 2) \"level\" "+
		            "   from (select id, "+
		            "                departmentname, "+
		            "                supdepid, "+
		            "                subcompanyid1, "+
		            "                showorder, "+
		            "                SYS_CONNECT_BY_PATH(dept.id, '_') code, "+
		            "                SYS_CONNECT_BY_PATH('a', '_') as lv "+
		            "           FROM HrmDepartment dept "+
		            "          START WITH dept.supdepid = 0 "+
		            "         CONNECT BY PRIOR dept.id = dept.supdepid) t "+
		            "  order by \"level\" desc,showorder asc, id asc ";
        }
        return sql;
    }

    /**
     * 设置否包含下级部门
     */
    private void setIsContainSub(
            LinkedHashMap<String, LinkedHashMap<String, String>> map) {
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        rs.execute("SELECT distinct subcompanyid1 FROM HrmDepartment WHERE canceled IS NULL OR  canceled!=1");
        List<String> subIdsList = new ArrayList<String>();
        while (rs.next()) {
            subIdsList.add(rs.getString("subcompanyid1"));
        }
        LinkedHashMap<String, String> tempMap = null;
        for (int i = 0; i < subIdsList.size(); i++) {
            tempMap = map.get(subIdsList.get(i));
            if (tempMap == null) {
                continue;
            } else {
                if ("no".equals(tempMap.get("hasSub"))
                        || tempMap.get("hasSub") == null) {
                    tempMap.put("hasSub", "yes");
                }
            }
        }
    }
    /**
     * 把所有分部组合成的树放到集合中
     * @return
     */
    private LinkedHashMap<String,LinkedHashMap<String, String>> getTreeMapResult(weaver.conn.RecordSet rs) {
        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        String id = null;
        String supsubcomid = null;
        String code = null;
        String level = null;
        String s3 = null;
        LinkedHashMap<String, String> curValues = null;
        while(rs.next()){
            id = null2String(rs.getString("id"));
            supsubcomid = null2String(rs.getString("supsubcomid"));
            code = null2String(rs.getString("code"));
            level = null2String(rs.getString("level"));

            curValues = new LinkedHashMap<String, String>();
            curValues.put("id",id);
            curValues.put("supsubcomid",supsubcomid);
            curValues.put("code",code);
            curValues.put("level",level);
            map.put(id,curValues);
        }
        return map;
    }
    
    /**
     * 把所有部门组合成的树放到集合中
     * @return
     */
    private LinkedHashMap<String,LinkedHashMap<String, String>> getDeptTreeMapResult(weaver.conn.RecordSet rs) {
        LinkedHashMap<String,LinkedHashMap<String, String>> map = new LinkedHashMap<String,LinkedHashMap<String, String>>();
        String id = null;
        String superid = null;
        String subcompanyid1 = null;
        String code = null;
        String level = null;
        String s3 = null;
        LinkedHashMap<String, String> curValues = null;
        while(rs.next()){
            id = null2String(rs.getString("id"));
            superid = null2String(rs.getString("supdepid"));
            subcompanyid1 = null2String(rs.getString("subcompanyid1"));
            code = null2String(rs.getString("code"));
            level = null2String(rs.getString("level"));

            curValues = new LinkedHashMap<String, String>();
            curValues.put("id",id);
            curValues.put("superid",superid);
            curValues.put("subcompanyid1",subcompanyid1);
            curValues.put("code",code);
            curValues.put("level",level);
            map.put(id,curValues);
        }
        return map;
    }
    /**
     * null转空字符串
     * @param str
     * @return
     */
    public static String null2String(String str) {
        return null2String(str, "");
    }
    /**
     * null转换为指定字符串
     * @param str 检测字符串
     * @param nullValue 替换字符串
     * @return
     */
    public static String null2String(String str, String nullValue) {
        return (str == null || "".equals(str)) ? nullValue : str;
    }
    /**
     * 字符串是否为空
     * @param str
     * @return
     */
    public static boolean isEmpty(String str){
        return str==null || "".equals(str.trim());
    }
%>