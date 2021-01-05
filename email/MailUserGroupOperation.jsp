<%@ page import="weaver.general.Util,weaver.conn.RecordSet,java.io.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String operationtype=Util.null2String(request.getParameter("operationType"));
String mailgroupid=Util.null2String(request.getParameter("mailgroupid"));
String resourceid=Util.null2String(request.getParameter("resourceid"));

char flag=Util.getSeparator();
String userid=user.getUID()+"" ;

ArrayList mailgroupname=new ArrayList();
String idname=Util.null2String(request.getParameter("idname"));
String description=Util.null2String(request.getParameter("description"));

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	if(operationtype.equals("Add")){		
		rs.execute("MailUserGroup_SelectMailgroupname",userid);
		while(rs.next()){
		    mailgroupname.add(rs.getString("mailgroupname"));
		}
	    if(mailgroupname.indexOf(idname)==-1){
		String cmd=idname+flag+description+flag+user.getUID()+flag+currentdate;
		rs.execute("MailUserGroup_Insert",cmd);
		response.sendRedirect("/email/MailUserGroup.jsp");
		}
		else{
				response.sendRedirect("/email/MailUserGroupAdd.jsp?message=1&idname="+idname+
				"&description="+description);			
		}  
	}

	if(operationtype.equals("Update")){
		String cmd=idname+flag+description+flag+mailgroupid;
		rs.execute("MailUserGroup_UpdateById",cmd);
		response.sendRedirect("/email/MailUserGroup.jsp");
		
	}

	if(operationtype.equals("Delete")){
			rs.execute("MailUserGroup_DeleteById",mailgroupid);
			response.sendRedirect("/email/MailUserGroup.jsp");
	     }
	

	if(operationtype.equals("AddUser")){
        rs.execute("MailUser_SelectAllById",""+mailgroupid);
		while(rs.next()){
		    mailgroupname.add(""+rs.getInt("resourceid"));
		}
		ArrayList resourceids =Util.TokenizerString(resourceid,",") ; 
		for(int i=0 ; i < resourceids.size() ; i++ ){
    	    String tmpresourceid=(String) resourceids.get(i) ;
    	    if(mailgroupname.indexOf(tmpresourceid)==-1){
    			rs.execute("MailUser_Insert",mailgroupid+flag+tmpresourceid);
    		}
        }  
        response.sendRedirect("/email/MailUserGroupEdit.jsp?mailgroupid="+mailgroupid);
	}

	if(operationtype.equals("DelUser")){
			rs.execute("MailUser_DeleteById",mailgroupid+flag+resourceid);
			response.sendRedirect("/email/MailUserGroupEdit.jsp?mailgroupid="+mailgroupid);
	}

	if(operationtype.equals("AddMail")){
	    String mailaddress=Util.fromScreen(request.getParameter("mailaddress"),user.getLanguage()) ;
	    String maildesc=Util.fromScreen(request.getParameter("maildesc"),user.getLanguage()) ;
        String para=""+mailgroupid+flag+mailaddress+flag+maildesc ;
        rs.execute("MailUserAddress_Insert",para);
		response.sendRedirect("/email/MailUserGroupEdit.jsp?mailgroupid="+mailgroupid);
	}

	if(operationtype.equals("DelMail")){
		String mailaddress=Util.fromScreen(request.getParameter("mailaddress"),user.getLanguage()) ;
        String para=""+mailgroupid+flag+mailaddress ;
		rs.execute("MailUserAddress_Delete",para);
		response.sendRedirect("/email/MailUserGroupEdit.jsp?mailgroupid="+mailgroupid);
	}
	
			
	
	//response.sendRedirect("MailUserGroup.jsp");
	//response.sendRedirect("/email/MailUserGroup.jsp");

%>
