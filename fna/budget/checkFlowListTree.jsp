
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,weaver.general.*,weaver.hrm.company.*,weaver.hrm.*,java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<tree>
<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String departmentId = Util.null2String(request.getParameter("departmentId"));

    if(!subCompanyId.equals("")){
        if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            out.println(subCompInfo.getFnaOrgTreeXMLBySubComp(subCompanyId,false));
    }else if(!departmentId.equals("")){
        if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            out.println(subCompInfo.getFnaDeptTreeXMLByDept(departmentId,false));
    }else{
        if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            out.println(subCompInfo.getFnaOrgTreeXMLByComp());
    }
    
%>
</tree>