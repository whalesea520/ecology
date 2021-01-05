
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*,weaver.general.*,weaver.hrm.company.*,weaver.hrm.*,java.util.*,weaver.conn.*,weaver.hrm.performance.goal.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<tree>
<%!
private String getOrgTreeXMLBySubComp(String subId) throws Exception{
    String subCompanyIcon = "/images/treeimages/home16_wev8.gif";
    String departmentIcon = "/images/treeimages/dept16_wev8.gif";
    String hrmResourceIcon = "/images/treeimages/user16_wev8.gif";
    RecordSet budgetrs = new RecordSet();

    String str = "";
    SubCompanyComInfo rs = new SubCompanyComInfo();
    
    rs.setTofirstRow();
    while(rs.next()){
        String supsubcomid = rs.getSupsubcomid();
        if(!supsubcomid.equals(subId)) continue;
        String id = rs.getSubCompanyid();
        String name = rs.getSubCompanyname();
        String canceled = rs.getCompanyiscanceled();
        if(!"1".equals(canceled))
        {
            name=Util.replace(Util.replace(Util.replace(Util.replace(Util.replace(name,"<","&lt;",0),">","&gt;",0),"&","&amp;",0),"'","&apos;",0),"\"","&quot;",0);
            str += "<tree text=\""+name+"\" action=\"setSubcompany('com_"+id+"')\" icon=\""+subCompanyIcon+"\" openIcon=\""+subCompanyIcon+"\" src=\"AddressBookLeftTree.jsp?subCompanyId="+id+"\" />";
        }
    }
    str += getDeptTreeXMLBySubComp(subId);
    return str;
}
private String getDeptTreeXMLBySubComp(String subId) throws Exception{
    String subCompanyIcon = "/images/treeimages/home16_wev8.gif";
    String departmentIcon = "/images/treeimages/dept16_wev8.gif";
    String hrmResourceIcon = "/images/treeimages/user16_wev8.gif";
    RecordSet budgetrs = new RecordSet();

    String str = "";
    DepartmentComInfo rsDepartment = new DepartmentComInfo();
    rsDepartment.setTofirstRow();
    while(rsDepartment.next()){
        String subcompid1 = rsDepartment.getSubcompanyid1();
        String supdepid = rsDepartment.getDepartmentsupdepid();
        if(!(subcompid1.equals(subId) && supdepid.equals("0"))) continue;
        String id = rsDepartment.getDepartmentid();
        String name = rsDepartment.getDepartmentname();
        name=Util.replace(Util.replace(Util.replace(Util.replace(Util.replace(name,"<","&lt;",0),">","&gt;",0),"&","&amp;",0),"'","&apos;",0),"\"","&quot;",0);
        str += "<tree text=\""+name+"\" action=\"setDepartment('dept_"+subcompid1+"_"+id+"')\" icon=\""+departmentIcon+"\" openIcon=\""+departmentIcon+"\" src=\"AddressBookLeftTree.jsp?departmentId="+id+"\">";
        str += "</tree>";
    }
    return str;
}
private String getDeptTreeXMLByDept(String deptId) throws Exception{
    String subCompanyIcon = "/images/treeimages/home16_wev8.gif";
    String departmentIcon = "/images/treeimages/dept16_wev8.gif";
    String hrmResourceIcon = "/images/treeimages/user16_wev8.gif";
    RecordSet budgetrs = new RecordSet();

    String str = "";
    DepartmentComInfo rsDepartment = new DepartmentComInfo();
    rsDepartment.setTofirstRow();
    while(rsDepartment.next()){
        String supdepid = rsDepartment.getDepartmentsupdepid();
        if(!supdepid.equals(deptId)) continue;
        String subcompid1 = rsDepartment.getSubcompanyid1();
        String id = rsDepartment.getDepartmentid();
        String name = rsDepartment.getDepartmentname();
        String canceled = rsDepartment.getDeparmentcanceled();
        if(!"1".equals(canceled))
        {
             name=Util.replace(Util.replace(Util.replace(Util.replace(Util.replace(name,"<","&lt;",0),">","&gt;",0),"&","&amp;",0),"'","&apos;",0),"\"","&quot;",0);
             str += "<tree text=\""+name+"\" action=\"setDepartment('dept_"+subcompid1+"_"+id+"')\" icon=\""+departmentIcon+"\" openIcon=\""+departmentIcon+"\" src=\"AddressBookLeftTree.jsp?departmentId="+id+"\">";
             str += "</tree>";
        }
       
    }
    return str;
}
private String getOrgTreeXMLByComp() throws Exception{
    String subCompanyIcon = "/images/treeimages/home16_wev8.gif";
    String departmentIcon = "/images/treeimages/dept16_wev8.gif";
    String hrmResourceIcon = "/images/treeimages/user16_wev8.gif";
    RecordSet budgetrs = new RecordSet();

    String str = "";
    SubCompanyComInfo rs = new SubCompanyComInfo();
    rs.setTofirstRow();
    while(rs.next()){
        String supsubcomid = rs.getSupsubcomid();
        if(!supsubcomid.equals("0")) continue;
        String id = rs.getSubCompanyid();
        String name = rs.getSubCompanyname(); 
        String flowName = GoalUtil.getCheckFlow(Integer.parseInt(id),"1");
        String canceled = rs.getCompanyiscanceled();
        
        if(!"1".equals(canceled))
        {
            name=Util.replace(Util.replace(Util.replace(Util.replace(Util.replace(name,"<","&lt;",0),">","&gt;",0),"&","&amp;",0),"'","&apos;",0),"\"","&quot;",0);
            str += "<tree text=\""+name+"\" action=\""+id+"|1|"+flowName+"\" icon=\""+subCompanyIcon+"\" openIcon=\""+subCompanyIcon+"\" src=\"AddressBookLeftTree.jsp?subCompanyId="+id+"\" />";
        }
    }
    return str;
}
%>
<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String departmentId = Util.null2String(request.getParameter("departmentId"));

    if(!subCompanyId.equals("")){
        //if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            out.println(getOrgTreeXMLBySubComp(subCompanyId));
    }else if(!departmentId.equals("")){
       // if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            out.println(getDeptTreeXMLByDept(departmentId));
    }else{
        //if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            out.println(getOrgTreeXMLByComp());
    }
    
%>
</tree>