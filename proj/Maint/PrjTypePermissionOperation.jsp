
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="TypeMultiAclManager" class="weaver.proj.Maint.TypeMultiAclManager" scope="page" />


<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
String method = Util.null2String(request.getParameter("method"));
int typeid = Integer.parseInt(Util.null2String(request.getParameter("typeid")));
int operationcode = Integer.parseInt(Util.null2String(request.getParameter("operationcode")));

//TempletMultiAclManager am = new TempletMultiAclManager();
if (method.equals("add")) {
    int permissiontype = Integer.parseInt(Util.null2String(request.getParameter("permissiontype")));
    int seclevel = Integer.parseInt(Util.null2String(request.getParameter("seclevel")));
    int seclevelmax = Integer.parseInt(Util.null2String(request.getParameter("seclevelmax")));
	String hisSecCategoryCreater="";
    switch (permissiontype) {
        case 1:
        int ismutil = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
        if(ismutil!=0) {


            String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            for(int k=0;k<tempStrs.length;k++){
                int departmentid = Util.getIntValue(Util.null2o(tempStrs[k]));            
                TypeMultiAclManager.grantTempPermission1(typeid, operationcode, departmentid, seclevel,seclevelmax);
            }
            response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        } else {

            int departmentid = Integer.parseInt(Util.null2String(request.getParameter("departmentid")).split(",")[1]);
            TypeMultiAclManager.grantTempPermission1(typeid, operationcode, departmentid, seclevel,seclevelmax);
            response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        }
        break;

        case 6:
            int ismutilsub = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
            if(ismutilsub!=0) {


                String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("subcompanyid")),",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid = Util.getIntValue(Util.null2o(tempStrs[k]));                  
                    TypeMultiAclManager.grantTempPermission6(typeid, operationcode, subcompanyid, seclevel,seclevelmax);
                }
               response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
            } else {

                int subcompanyid = Integer.parseInt(Util.null2String(request.getParameter("subcompanyid")).split(",")[1]);
                TypeMultiAclManager.grantTempPermission6(typeid, operationcode, subcompanyid, seclevel,seclevelmax);
                response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
            }
            break;
        
        case 2:        
        int roleid = Integer.parseInt(Util.null2String(request.getParameter("roleid")));
        int rolelevel = Integer.parseInt(Util.null2String(request.getParameter("rolelevel")));

        TypeMultiAclManager.grantTempPermission2(typeid, operationcode, roleid, rolelevel, seclevel,seclevelmax);
	    response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        break;

        case 3:

        TypeMultiAclManager.grantTempPermission3(typeid, operationcode, seclevel,seclevelmax);
	    response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        break;

        case 4:

        int usertype = Integer.parseInt(Util.null2String(request.getParameter("usertype")));
        TypeMultiAclManager.grantTempPermission4(typeid, operationcode, usertype, seclevel,seclevelmax);
	    response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        break;

        case 5:
        String[] tmpuserid = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
        int userid = 0;
        for(int i=0;tmpuserid!=null&&tmpuserid.length>0&&i<tmpuserid.length;i++){
        	userid = Util.getIntValue(tmpuserid[i]);
        	if(userid>0) TypeMultiAclManager.grantTempPermission5(typeid, operationcode, userid);
        }
        response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        break;
        case 7:
            String[] tmpjobtitleid = Util.TokenizerString2(Util.null2String(request.getParameter("jobtitleid")),",");
            String joblevel = Util.null2String(request.getParameter("joblevel"));
			String scopeid = Util.null2String(request.getParameter("scopeid"));
			if("".equals(scopeid))scopeid = "0";
            int jobtitleid = 0;
            for(int i=0;tmpjobtitleid!=null&&tmpjobtitleid.length>0&&i<tmpjobtitleid.length;i++){
            	jobtitleid = Util.getIntValue(tmpjobtitleid[i]);
            	if(jobtitleid>0) TypeMultiAclManager.grantTempPermission7(typeid, operationcode, jobtitleid,joblevel,scopeid);
            }
        response.sendRedirect("/proj/Maint/PrjTypeAddCreate.jsp?isclose=1&typeid="+typeid+"&operationcode="+operationcode);
        break;
    }
} else if (method.equals("delete")) {
	String mainids = Util.null2String(request.getParameter("mainids"));
    String isDialog = Util.null2String(request.getParameter("isdialog"));
	List tempidOperationCodeList=null;
    if(mainids!=null&&!"".equals(mainids)){
    	String[] tids = mainids.split(",");
    	for(int i=0;tids!=null&&tids.length>0&&i<tids.length;i++){
    		TypeMultiAclManager.depriveTempPermission(Util.getIntValue(tids[i]));
		}
    }
		//url+="&isdialog=1";
	response.sendRedirect("/proj/Maint/PrjTypeCreateDsp.jsp?isdialog=1&paraid="+typeid+"&operationcode="+operationcode);
	return;
}
%>