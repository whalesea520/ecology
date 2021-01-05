
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.DbFunctionUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.sysadmin.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String method = Util.null2String(request.getParameter("method"));

String loginid = Util.convertInput2DB(Util.null2String(request.getParameter("loginid")));
String password = Util.convertInput2DB(Util.null2String(request.getParameter("password")));
String lastname = Util.convertInput2DB(Util.null2String(request.getParameter("lastname")));
String description = Util.convertInput2DB(Util.null2String(request.getParameter("description")));
String subcompanyids = Util.convertInput2DB(Util.null2String(request.getParameter("subcompanyids")));
if(method.equals("add")){
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	if(!dao.ifHaveSameLoginId(loginid)){
		RecordSet.executeProc("HrmResourceMaxId_Get","");
		RecordSet.next();
		String id = ""+RecordSet.getInt(1);
		String tempSecPassword = Util.getEncrypt(password);
		HrmResourceManagerVO vo = new HrmResourceManagerVO();
		vo.setId(id);
		vo.setLoginid(loginid);
		vo.setPassword(tempSecPassword);
    vo.setLastname(lastname);
		vo.setSystemlanguage(Integer.toString(user.getLanguage()));
		vo.setDescription(description);
		vo.setSubcompanyids(subcompanyids);
    vo.setCreator(String.valueOf(user.getUID()));
		
		dao.insertHrmResourceManagerVO(vo);
		
		RecordSet.execute("update HrmResourceManager set "+DbFunctionUtil.getInsertUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
		
		ResourceComInfo.removeResourceCache();
		
		
		response.sendRedirect("addSysadmin.jsp?isclose=1&id="+id);
	}else{
		response.sendRedirect("addSysadmin.jsp?isclose=1&result=false");
	}
}else if(method.equals("edit")){
    HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
    String id = Util.null2String(request.getParameter("id"));
    if(!dao.ifHaveSameLoginId(loginid,id)){
  			String tempSecPassword = Util.getEncrypt(password);
        HrmResourceManagerVO vo = new HrmResourceManagerVO();
        vo.setId(id);
        vo.setLoginid(loginid);
        vo.setLastname(lastname);
				if(!"C3***0D_C0***4B".equals(password)){
	    		vo.setPassword(tempSecPassword);
				}else{
        			HrmResourceManagerVO voOld = dao.getHrmResourceManagerByID(id);
					vo.setPassword(voOld.getPassword());
				}
				
        vo.setSystemlanguage(Integer.toString(user.getLanguage()));
        vo.setDescription(description);
    		vo.setSubcompanyids(subcompanyids);
        dao.updateHrmResourceManagerVO(vo);
        
        RecordSet.execute("update HrmResourceManager set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
        
    		ResourceComInfo.removeResourceCache();
        response.sendRedirect("sysadminEdit.jsp?isclose=1&id="+id);
	}else{
		response.sendRedirect("sysadminEdit.jsp??isclose=1&result=false&id="+id);
	}
}else if(method.equals("changepwd")){
	String id = Util.null2String(request.getParameter("id"));
    String oldpassword = Util.null2String(request.getParameter("oldpassword"));
	String newpassword = Util.null2String(request.getParameter("newpassword"));
    //编辑下级密码时不需要旧密码
    if(!oldpassword.equals("")){
        if(password.equals(Util.getEncrypt(oldpassword))){
            String tempSecPassword = Util.getEncrypt(newpassword);
            HrmResourceManagerVO vo = new HrmResourceManagerVO();
            vo.setId(id);
            vo.setPassword(tempSecPassword);
            HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
            dao.updateHrmPwd(vo);
            
            RecordSet.execute("update HrmResourceManager set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
            
            ResourceComInfo.removeResourceCache();
            response.sendRedirect("sysadminList.jsp");
        }else{
            response.sendRedirect("changePwd.jsp?result=false&id="+id);
        }
    }else{
            String tempSecPassword = Util.getEncrypt(newpassword);
            HrmResourceManagerVO vo = new HrmResourceManagerVO();
            vo.setId(id);
            vo.setPassword(tempSecPassword);
            HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
            dao.updateHrmPwd(vo);
            
            RecordSet.execute("update HrmResourceManager set "+DbFunctionUtil.getUpdateSetSql(RecordSet.getDBType(),user.getUID())+" where id="+id) ;
            
            ResourceComInfo.removeResourceCache();
            response.sendRedirect("sysadminList.jsp");
    }
}else if(method.equals("del")){
	String id = Util.null2String(request.getParameter("id"));
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	dao.delHrmResourceManagerByID(id);
	ResourceComInfo.removeResourceCache();
	response.sendRedirect("sysadminEditBatch.jsp");
}
%>