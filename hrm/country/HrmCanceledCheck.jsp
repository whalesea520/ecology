
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	String ope = Util.null2String(request.getParameter("ope"));  // 国家、省份、城市
	String cancelFlag = request.getParameter("cancelFlag");      // 判断是封存还是解封
	int cid = Util.getIntValue(request.getParameter("id"));      // 主键id
	if ("country".equals(ope.toString())) {
		CountryComInfo.removeCountryCache();
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("update HrmCountry set canceled = '0'  WHERE id	= " + cid);
		} else {
			RecordSet.executeSql("update HrmCountry set canceled = '1'  WHERE id	= " + cid);
		}
	}else if("province".equals(ope.toString())){
		ProvinceComInfo.removeProvinceCache();
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("update HrmProvince set canceled = '0'  WHERE id	= " + cid);
		} else {
			RecordSet.executeSql("update HrmProvince set canceled = '1'  WHERE id	= " + cid);
		}
	}else if("city".equals(ope.toString())){
		CityComInfo.removeCityCache();
		if ("1".equals(cancelFlag)) {
			RecordSet.executeSql("update HrmCity set canceled = '0'  WHERE id	= " + cid);
		} else {
			RecordSet.executeSql("update HrmCity set canceled = '1'  WHERE id	= " + cid);
		}
	}
%>
