<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.country.CountryComInfo"%>
<%@page import="weaver.hrm.province.ProvinceComInfo"%>
<%@page import="weaver.hrm.city.CityComInfo"%>
<%@page import="weaver.hrm.city.CitytwoComInfo"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.systeminfo.SystemEnv"%>

<%!
public ArrayList getCountryTreeList() throws Exception {
	ArrayList list = new ArrayList();
	CountryComInfo rs = new CountryComInfo();
	rs.setTofirstRow();
	while (rs.next()) {
		String id = rs.getCountryid();
		String name = rs.getCountryname();
		if(Util.null2String(rs.getCountryiscanceled()).equals("1")){
			continue;
		}
		Map map = new HashMap();
		map.put("id",id);
		map.put("name",name);
		map.put("type","country");
		list.add(map);
	}
	return list;
}

public ArrayList getProvinceTreeList(String subId) throws Exception {
	ArrayList list = new ArrayList();
	ProvinceComInfo rs = new ProvinceComInfo();
	rs.setTofirstRow();
    while (rs.next()) {
        if (rs.getProvincecountryid().equals(subId) && !"1".equals(rs.getProvinceiscanceled())){
	        String id = rs.getProvinceid();
	        String name = rs.getProvincename();
	        Map map = new HashMap();
			map.put("id",id);
			map.put("name",name);
			map.put("type","province");
			list.add(map);
        }
    }
      return list;
  }

public ArrayList getCityTreeList(String subId) throws Exception {
	ArrayList list = new ArrayList();
	CityComInfo rs = new CityComInfo();
	rs.setTofirstRow();
    while (rs.next()) {
        if (rs.getCityprovinceid().equals(subId) && !"1".equals(rs.getCitycanceled())){
	        String id = rs.getCityid();
	        String name = rs.getCityname();
	        Map map = new HashMap();
			map.put("id",id);
			map.put("name",name);
			map.put("type","city");
			list.add(map);
        }
    }
      return list;
  }

public ArrayList getCityTwoTreeList(String subId) throws Exception {
	ArrayList list = new ArrayList();
	CitytwoComInfo rs = new CitytwoComInfo();
	rs.setTofirstRow();
    while (rs.next()) {
        if (rs.getCitypid().equals(subId) && !"1".equals(rs.getCitycanceled())){
	        String id = rs.getCityid();
	        String name = rs.getCityname();
	        Map map = new HashMap();
			map.put("id",id);
			map.put("name",name);
			map.put("type","citytwo");
			list.add(map);
        }
    }
      return list;
  }


/**
 * 指定节点下是否有子节点
 * @param type  com:分部;dept:部门
 * @param id   节点id
 * @return  boolean
 * @throws Exception
 */
private int hasChild(String type, String id) throws Exception {
	int hasChild = 0;
  if (type.equals("country")) {
	  ProvinceComInfo rs = new ProvinceComInfo();
		rs.setTofirstRow();
		while (rs.next()) {
			if (rs.getProvincecountryid().equals(id) && !"1".equals(rs.getProvinceiscanceled()))
				hasChild++;
		}
	} else if (type.equals("province")) {
		CityComInfo rs = new CityComInfo();
		rs.setTofirstRow();
		while (rs.next()) {
			if ( rs.getCityprovinceid().equals(id) && !"1".equals(rs.getCitycanceled()))
				hasChild++;
		}
	}else if (type.equals("city")) {
		CitytwoComInfo rs = new CitytwoComInfo();
		rs.setTofirstRow();
		while (rs.next()) {
			if ( rs.getCitypid().equals(id) && !"1".equals(rs.getCitycanceled()))
				hasChild++;
		}
	}
	return hasChild;
}

%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id=Util.null2String(request.getParameter("id"));
String type=Util.null2String(request.getParameter("type"));
String opt=Util.null2String(request.getParameter("opt"));

ArrayList selectList = new ArrayList();
JSONArray jObject = null;
if(opt.equals("findSubid")){
	CountryComInfo counrs = new CountryComInfo();
	ProvinceComInfo provincers = new ProvinceComInfo();
	if(type.equals("province")){
		String countryId = provincers.getProvincecountryid(id);
		Map map = new HashMap();
		map.put("id",countryId);
		map.put("name",counrs.getCountryname(countryId));
		map.put("type","country");
		selectList.add(map);
	}else if(type.equals("city")){
		CityComInfo rs = new CityComInfo();
		String countryId = rs.getCitycountryid(id);
		Map map = new HashMap();
		map.put("id",countryId);
		map.put("name",counrs.getCountryname(countryId));
		map.put("type","country");
		selectList.add(map);
		Map map2 = new HashMap();
		String provinceid = rs.getCityprovinceid(id);
		map2.put("id",provinceid);
		map2.put("name",provincers.getProvincename(provinceid));
		map2.put("type","province");
		selectList.add(map2);
	}else if(type.equals("citytwo")){
		CitytwoComInfo rs = new CitytwoComInfo();
		String citypid=rs.getCitypid(id);
		CityComInfo rs1 = new CityComInfo();
		String countryId = rs1.getCitycountryid(citypid);
		Map map = new HashMap();
		map.put("id",countryId);
		map.put("name",counrs.getCountryname(countryId));
		map.put("type","country");
		selectList.add(map);
		Map map2 = new HashMap();
		String provinceid = rs1.getCityprovinceid(citypid);
		map2.put("id",provinceid);
		map2.put("name",provincers.getProvincename(provinceid));
		map2.put("type","province");
		selectList.add(map2);
		Map map3 = new HashMap();
		map3.put("id",citypid);
		map3.put("name",rs1.getCityname(citypid));
		map3.put("type","city");
		selectList.add(map3);
	}
	jObject = JSONArray.fromObject(selectList);		
	out.println(jObject.toString());
}else if("getTitle".equals(opt)){

		Map map = new HashMap();
		
		map.put("countryName",SystemEnv.getHtmlLabelName(377,user.getLanguage()));
		map.put("provinceName",SystemEnv.getHtmlLabelName(800,user.getLanguage()));
		map.put("cityName",SystemEnv.getHtmlLabelName(493,user.getLanguage()));
		map.put("district",SystemEnv.getHtmlLabelName(81764,user.getLanguage()));
		selectList.add(map);
		jObject = JSONArray.fromObject(selectList);	
		out.println(jObject.toString());	
		
}else{
	if(id.equals("")){
		//初始化
		selectList=getCountryTreeList();
	}else if(type.equals("country")){
		selectList=getProvinceTreeList(id);
	}else if(type.equals("province")){
		selectList=getCityTreeList(id);
	}else if(type.equals("city")){
		selectList=getCityTwoTreeList(id);
	}
	jObject = JSONArray.fromObject(selectList);		
	out.println(jObject.toString());
}
%>