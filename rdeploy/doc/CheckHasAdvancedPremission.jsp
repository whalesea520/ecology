<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.*,org.json.*" %>
<%@ page import="weaver.docs.category.security.*"%>
<%@ page import="weaver.hrm.*" %>
<% 
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	int operationcode = MultiAclManager.OPERATION_CREATEDOC;
    int categorytype = MultiAclManager.CATEGORYTYPE_SEC;
	String secgoryid= Util.getIntValues(request.getParameter("secgoryid"));
	String secnmae= Util.getIntValues(request.getParameter("secnmae"));
	boolean hasAdvancedPremission = false;
	String checkSql = "select count(1) from DirAccessControlList where ((permissiontype!=4 and usertype!=0 ) and permissiontype!=5) and  dirid=" 
		+ secgoryid + " and dirtype=" + categorytype + " and operationcode=" + operationcode + " group by dirid";
		rs.executeSql(checkSql);
        if (rs.next()) {
            if (rs.getInt(1) > 0) {
                if (!hasAdvancedPremission) {
                    hasAdvancedPremission = true;
                }
            }
        }
        
        
   
        checkSql = "select count(1) from DocSecCategoryShare where  seccategoryid=" +
        secgoryid + " and ((operategroup!=3 or sharetype not in (1,5)) and (operategroup!=1 or sharetype not in (1,2))) group by seccategoryid";
		rs.executeSql(checkSql);
        if (rs.next()) {
            if (rs.getInt(1) > 0) {
                if (!hasAdvancedPremission) {
                    hasAdvancedPremission = true;
                }
            }
        }
        
        
        
        JSONObject obj = new JSONObject();
        obj.put("id",secgoryid);
        obj.put("secnmae",secnmae);
        
	    obj.put("hasAdvancedPremission",hasAdvancedPremission);
		out.println(obj.toString());
	
%>