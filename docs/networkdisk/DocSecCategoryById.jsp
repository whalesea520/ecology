<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo"%>
<%@ page import="weaver.docs.networkdisk.server.GetSecCategoryById"%>
<%
    User user = HrmUserVarify.getUser(request, response);
    HrmUserSettingComInfo userSetting = new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID() + "");
    String belongtoids = user.getBelongtoids();
    String account_type = user.getAccount_type();
    if (belongtoshow.equals("1") && account_type.equals("0") && !belongtoids.equals("")) {
        belongtoids += "," + user.getUID();
    }
	
	Map<String,String> requestMap = new HashMap<String,String>();
	requestMap.put("subCompanyId",Util.null2String(request.getParameter("subCompanyId")));
	requestMap.put("categoryname",Util.null2String(request.getParameter("categoryname")));
	requestMap.put("categoryid",Util.null2String(request.getParameter("categoryid"),"0"));
	requestMap.put("url",Util.null2String(request.getParameter("url")));
	requestMap.put("urlType",Util.null2String(request.getParameter("urlType")));
	requestMap.put("offical",Util.null2String(request.getParameter("offical")));
	requestMap.put("officalType",Util.null2String(request.getParameter("officalType"),"-1"));
	requestMap.put("doccreatedateselect",Util.null2String(request.getParameter("doccreatedateselect")));
	requestMap.put("fromadvancedmenu",Util.null2String(request.getParameter("fromadvancedmenu"),"0"));
	requestMap.put("infoId",Util.null2String(request.getParameter("infoId"),"0"));
	requestMap.put("operationcode",Util.null2String(request.getParameter("operationcode"),"-1"));
	requestMap.put("owner",Util.null2String(request.getParameter("owner")));
	requestMap.put("departmentid",Util.null2String(request.getParameter("departmentid")));
	requestMap.put("fromdate",Util.fromScreen(request.getParameter("fromdate"), user.getLanguage()));
	requestMap.put("todate",Util.fromScreen(request.getParameter("todate"), user.getLanguage()));
	requestMap.put("dspreply",Util.null2String(request.getParameter("dspreply")));
	requestMap.put("publishtype",Util.fromScreen(request.getParameter("publishtype"), user.getLanguage()));
	StringBuffer result = new StringBuffer("{");
	List<Map<String,String>> secList = GetSecCategoryById.getCategoryById(user,requestMap);
     for(Map<String,String> sec : secList)
     {
         result.append("\"").append(sec.get("sid")).append("\"").append(":").append("{")
          .append("\"").append("sid").append("\"").append(":").append("\"").append(sec.get("sid")).append("\"").append(",")
          .append("\"").append("pid").append("\"").append(":").append("\"").append(sec.get("pid")).append("\"").append(",")
          .append("\"").append("sname").append("\"").append(":").append("\"").append(sec.get("sname")).append("\"").append(",")
          .append("\"").append("secorder").append("\"").append(":").append("\"").append(sec.get("secorder")).append("\"").append(",")
          .append("\"").append("canCreateDoc").append("\"").append(":").append("\"").append(sec.get("canCreateDoc")).append("\"");
         result.append("},");
     }
     result.append("}");
     out.println(result.toString().replace("},}","}}"));
%>
