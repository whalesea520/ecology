
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import=" com.alibaba.fastjson.JSONArray" %>
<%@ page import=" com.alibaba.fastjson.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.crm.report.CRMContants" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%

        int sumcount = 0;
        int provinceNum = 0;
        int cityNum = 0;
        boolean flag = false;
        JSONObject obj = new JSONObject();
        JSONArray arr = new JSONArray();
        try{
            String sumcountSql = "SELECT  count(*) as sumcount FROM  crm_customerinfo where deleted = 0  ";
            RecordSet rs1 = new RecordSet();
            rs1.executeSql(sumcountSql);
            while(rs1.next()) {
                sumcount = Integer.parseInt(rs1.getString("sumcount"));
            }
            //String cityNumSql = "SELECT  count(*) as citynum FROM (select count(*) as num from crm_customerinfo where deleted = 0 group by city) t1 ";
            String cityNumSql = "select city ,count(*) as citynum from crm_customerinfo where deleted = 0 group by city ";
            RecordSet rs2 = new RecordSet();
            rs2.executeSql(cityNumSql);
            int tmpNum=0;
            while(rs2.next()) {
               //cityNum = Integer.parseInt(rs2.getString("citynum"));
               String city = Util.null2String(rs2.getString("citynum"));
               String citynum = Util.null2String(rs2.getString("citynum"));
               if(city.equals("")||city.equals("0")){
                   tmpNum=1;
                   continue;
               }
               cityNum++;
            }
            cityNum+=tmpNum;
            
            //String provinceNumSql = "SELECT  count(*) as provincenum FROM (select count(*) as num from crm_customerinfo where deleted = 0 group by province) t1 ";
            String provinceNumSql = "select province, count(*) as num from crm_customerinfo where deleted = 0 group by province ";
            RecordSet rs3 = new RecordSet();
            rs3.executeSql(provinceNumSql);
            int tmpNum2=0;
            while(rs3.next()) {
                //provinceNum = Integer.parseInt(rs3.getString("provincenum"));
                String province = Util.null2String(rs3.getString("province"));
                String provincenum = Util.null2String(rs3.getString("num"));
                if(province.equals("")||province.equals("0")){
                    tmpNum2=1;
                    continue;
                }
                provinceNum++;
                System.err.println(provinceNum);
            }
            provinceNum+=tmpNum2;
            
            obj.put("sumcount",sumcount);//鎬绘暟
            obj.put("provinceNum",provinceNum);//鐪佷唤鏁?
            obj.put("cityNum",cityNum);//鍩庡競鏁?
            //String sqlstr="select t2.provincename, count(*) as provincenum from crm_customerinfo t1 left join HrmProvince t2 on t1.province=t2.id  where t1.deleted = 0 group by t1.province,t2.provincename ";
            String sqlstr="select provincename,provincenum from (select t2.provincename as provincename, count(*) as provincenum from crm_customerinfo t1 left join HrmProvince t2 on t1.province=t2.id where t1.deleted = 0 group by t1.province,t2.provincename ) tt order by tt.provincenum desc ";
            rs.executeSql(sqlstr);
            JSONObject objNull = new JSONObject();
            Integer otherNum = 0;
            String otherName = "其他";
            while(rs.next()){
                
                if(rs.getString(1)=="") {
                    otherNum+=Integer.parseInt(rs.getString(2));
                    continue;
                }
                JSONObject obj1 = new JSONObject();
               
                obj1.put("province",rs.getString(1));//鐪佷唤
                obj1.put("num",rs.getString(2));//鏁伴噺
                obj1.put("proportion",cmutil.myRound(Double.parseDouble(rs.getString(2))/sumcount*100+"",2)+"%");//鍗犳瘮
                arr.add(obj1);
                flag = true;
            }
            if(otherNum!=0) {
                objNull.put("province",otherName);
                objNull.put("num",otherNum);
                objNull.put("proportion",cmutil.myRound(Double.parseDouble(otherNum+"")/sumcount*100+"",2)+"%");
                arr.add(objNull);
            }
            obj.put("datas",arr);
            obj.put("msg",flag);
            out.println(obj);
        }catch(Exception e) {
            obj.put("msg",flag);
            out.println(obj);
        }
    %>