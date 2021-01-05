
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
	String ope = Util.null2String(request.getParameter("ope"));  // 国家、省份、城市
	String cancelFlag = request.getParameter("cancelFlag");      // 判断是封存还是解封
	int cid = Util.getIntValue(request.getParameter("id"));      // 主键id
	String canceled = "1";
	if ("1".equals(cancelFlag)) {
		canceled = null;
	}
	if ("country".equals(ope.toString())) {
		RecordSet.executeSql("update HrmCountry set canceled = "+canceled+"  WHERE id	= " + cid);
		RecordSet.executeSql("update HrmProvince set canceled = "+canceled+"  WHERE countryid	= " + cid);
		RecordSet.executeSql("update HrmCity set canceled = "+canceled+"  WHERE countryid	= " + cid);
		RecordSet.executeSql("update hrmcitytwo set canceled = "+canceled+"  WHERE cityid in(select id from HrmCity where countryid = " + cid +" )");
		SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(cid);
		RecordSet.executeSql("select countryname from HrmCountry where id = " +cid);
		if(RecordSet.next()){
	      SysMaintenanceLog.setRelatedName(RecordSet.getString(1));
		}
      	if("1".equals(cancelFlag)){
    	  SysMaintenanceLog.setOperateType("11");//解封
      	}else{
	      SysMaintenanceLog.setOperateType("10");//封存
      	}
      	SysMaintenanceLog.setOperateDesc("update HrmCountry set canceled = "+canceled+"  WHERE id	= " + cid);
      	SysMaintenanceLog.setOperateItem("22");
      	SysMaintenanceLog.setOperateUserid(user.getUID());
      	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      	SysMaintenanceLog.setSysLogInfo();
		CountryComInfo.removeCountryCache();
		ProvinceComInfo.removeProvinceCache();
		CityComInfo.removeCityCache();
		CitytwoComInfo.removeCityCache();
	}else if("province".equals(ope.toString())){
		RecordSet.executeSql("update HrmProvince set canceled = "+canceled+"  WHERE id	= " + cid);
		RecordSet.executeSql("update HrmCity set canceled = "+canceled+"  WHERE provinceid	= " + cid);
		RecordSet.executeSql("update hrmcitytwo set canceled = "+canceled+"  WHERE cityid in(select id from HrmCity where provinceid = " + cid +" )");
		SysMaintenanceLog.resetParameter();
      	SysMaintenanceLog.setRelatedId(cid);
      	RecordSet.executeSql("select provincename from HrmProvince where id = " +cid);
		if(RecordSet.next()){
	      SysMaintenanceLog.setRelatedName(RecordSet.getString(1));
		}
      	if("1".equals(cancelFlag)){
    	  SysMaintenanceLog.setOperateType("11");//解封
      	}else{
	      SysMaintenanceLog.setOperateType("10");//封存
      	}
      	SysMaintenanceLog.setOperateDesc("update HrmProvince set canceled = "+canceled+"  WHERE id	= " + cid);
      	SysMaintenanceLog.setOperateItem("74");
      	SysMaintenanceLog.setOperateUserid(user.getUID());
      	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      	SysMaintenanceLog.setSysLogInfo();
		ProvinceComInfo.removeProvinceCache();
		CityComInfo.removeCityCache();
		CitytwoComInfo.removeCityCache();
	}else if("city".equals(ope.toString())){
		RecordSet.executeSql("update HrmCity set canceled = "+canceled+"  WHERE id	= " + cid);
		RecordSet.executeSql("update hrmcitytwo set canceled = "+canceled+"  WHERE cityid = " + cid);
		SysMaintenanceLog.resetParameter();
      	SysMaintenanceLog.setRelatedId(cid);
      	RecordSet.executeSql("select cityname from HrmCity where id = " +cid);
		if(RecordSet.next()){
	      SysMaintenanceLog.setRelatedName(RecordSet.getString(1));
		}
      	if("1".equals(cancelFlag)){
    	  SysMaintenanceLog.setOperateType("11");//解封
      	}else{
	      SysMaintenanceLog.setOperateType("10");//封存
      	}
      	SysMaintenanceLog.setOperateDesc("update HrmCity set canceled = "+canceled+"  WHERE id	= " + cid);
      	SysMaintenanceLog.setOperateItem("61");
      	SysMaintenanceLog.setOperateUserid(user.getUID());
      	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      	SysMaintenanceLog.setSysLogInfo();
		CityComInfo.removeCityCache();
		CitytwoComInfo.removeCityCache();
	}else if("citytwo".equals(ope.toString())){
		RecordSet.executeSql("update hrmcitytwo set canceled = "+canceled+"  WHERE id = " + cid);
		SysMaintenanceLog.resetParameter();
      	SysMaintenanceLog.setRelatedId(cid);
      	RecordSet.executeSql("select cityname from hrmcitytwo where id = " +cid);
		if(RecordSet.next()){
		      SysMaintenanceLog.setRelatedName(RecordSet.getString(1));
		}
 		if("1".equals(cancelFlag)){
    	  SysMaintenanceLog.setOperateType("11");//解封
      	}else{
	      SysMaintenanceLog.setOperateType("10");//封存
     	 }
      	SysMaintenanceLog.setOperateDesc("update hrmcitytwo set canceled = "+canceled+"  WHERE id = " + cid);
      	SysMaintenanceLog.setOperateItem("61");
      	SysMaintenanceLog.setOperateUserid(user.getUID());
      	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      	SysMaintenanceLog.setSysLogInfo();
		CitytwoComInfo.removeCityCache();
	}
%>
