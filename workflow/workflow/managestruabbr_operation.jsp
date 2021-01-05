
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>


<%
    if(!HrmUserVarify.checkUserRight("StruAbbr:Maintenance", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}  

    String operation = Util.null2String(request.getParameter("operation"));

    ////得到标记信息
    if(operation.equalsIgnoreCase("managestruabbr_subcompany")){      

        int rowNum = Util.getIntValue(Util.null2String(request.getParameter("tableMax")));

        int tempSubCompanyId=0;
	    int tempSubComAbbrDefId=0;
        String tempAbbr=null;
			
	    for(int i=0;i<rowNum;i++) {
		    tempSubCompanyId = Util.getIntValue(request.getParameter("abbr"+i+"_subCompanyId"),0);
		    tempSubComAbbrDefId = Util.getIntValue(request.getParameter("abbr"+i+"_subComAbbrDefId"),0);

		    tempAbbr = Util.null2String(request.getParameter("abbr"+i+"_abbr"));
		    tempAbbr=Util.toHtml100(tempAbbr);
			
		    if(tempSubComAbbrDefId <=0&&!(tempAbbr.trim().equals(""))){
				RecordSet.executeSql("insert into workflow_subComAbbrDef(subCompanyId,abbr) values("+tempSubCompanyId+",'"+tempAbbr+"')");
		    }
		    if(tempSubComAbbrDefId>0){
			    RecordSet.executeSql("update workflow_subComAbbrDef set abbr='"+tempAbbr+"' where id="+tempSubComAbbrDefId);
		    }
	    }

        response.sendRedirect("managestruabbr_subcompany.jsp");
        return;

    }else if(operation.equalsIgnoreCase("managestruabbr_department")){

        int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

        int rowNum = Util.getIntValue(Util.null2String(request.getParameter("tableMax")));

        int tempDepartmentId=0;
	    int tempDeptAbbrDefId=0;
        String tempAbbr=null;

	    for(int i=0;i<rowNum;i++) {
		    tempDepartmentId = Util.getIntValue(request.getParameter("abbr"+i+"_departmentId"),0);
		    tempDeptAbbrDefId = Util.getIntValue(request.getParameter("abbr"+i+"_deptAbbrDefId"),0);

		    tempAbbr = Util.null2String(request.getParameter("abbr"+i+"_abbr"));
		    tempAbbr=Util.toHtml100(tempAbbr);

		    if(tempDeptAbbrDefId <=0&&!(tempAbbr.trim().equals(""))){
				RecordSet.executeSql("insert into workflow_deptAbbrDef(departmentId,abbr) values("+tempDepartmentId+",'"+tempAbbr+"')");
		    }
		    if(tempDeptAbbrDefId>0){
			    RecordSet.executeSql("update workflow_deptAbbrDef set abbr='"+tempAbbr+"' where id="+tempDeptAbbrDefId);
		    }
	    }

        response.sendRedirect("managestruabbr_department.jsp?subCompanyId="+subCompanyId);
        return;

    }


%>
