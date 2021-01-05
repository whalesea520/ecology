<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<jsp:useBean id="depart" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    User usr = HrmUserVarify.getUser(request, response);
    String sex = usr.getSex();
    int usrId = usr.getUID();
    String name = usr.getLastname();
    String orgName = depart.getDepartmentName(usr.getUserDepartment()+"");
    String pic = resource.getMessagerUrls();
    JSONObject obj = new JSONObject();
    obj.put("usrId",usrId);
    obj.put("name",name);
    obj.put("orgName",orgName);
    if("".equals(pic) || null == pic){
        if("1".equals(sex)){
            pic = "../images/man.jpg";
        }else{
            pic = "../images/woman.jpg";
        }
    }
    if(usrId == 1){
        obj.put("pic","/contract/images/man.jpg");
        
    }else{
        obj.put("pic",pic);
    }
    
    out.print(obj.toString());   

%>



