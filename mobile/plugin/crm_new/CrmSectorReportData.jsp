
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import=" com.alibaba.fastjson.JSONArray" %>
<%@ page import=" com.alibaba.fastjson.JSONObject" %>
<%@ page import=" com.ibm.icu.text.DecimalFormat" %>
<%@ page import=" weaver.common.util.string.StringUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.crm.report.CRMContants" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	JSONObject resultObj = new JSONObject(); 	
	JSONArray resultArr = new JSONArray();
	DecimalFormat fnum = new DecimalFormat("##0.00"); 
	int sectorCount = 0;
	String sql = "select s.fullname,s.id,count(1) as totalCount,(select count(1) from CRM_CustomerInfo where deleted = 0) as sectorCount from CRM_CustomerInfo c left join CRM_SectorInfo s on c.sector = s.id where c.deleted = 0 group by s.id,s.fullname order by  case when s.fullname is null then 0 else 1 end desc, totalCount desc";
	try{
		rs.execute(sql);
		int totalNum = rs.getCounts();
	    while(rs.next()){
	    	JSONObject obj = new JSONObject();
	    	int totalCount = rs.getInt("totalCount");
	    	sectorCount = rs.getInt("sectorCount");
	    	String sectorName = rs.getString("fullname");
	    	if(StringUtil.isNullOrEmpty(sectorName)){
	    		sectorName = "其他行业";
	    	}
	    	Float percent = 0f;
	    	obj.put("sectorName",sectorName);
	    	obj.put("totalCount",totalCount);
	    	if(totalCount > 0 && totalNum > 0 && sectorCount > 0){
	    		percent = (float)totalCount / (float)sectorCount;
	    	}
	    	obj.put("percent",fnum.format(percent*100)+"%");
	    	resultArr.add(obj);
	    }
	    resultObj.put("msg",true);
	    resultObj.put("totalNum",sectorCount);
	    resultObj.put("datas",resultArr);
	}catch(Exception e) {
		resultObj.put("msg",false);
	}
    out.print(resultObj.toString());
    %>