<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.formmode.ThreadLocalUser"%>
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@page import="java.io.IOException"%>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
boolean isUseFmManageDetach=ManageDetachComInfo.isUseFmManageDetach();
String fmdetachable="0";
if(isUseFmManageDetach){
   fmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("fmdetachable",fmdetachable);
   session.setAttribute("fmdftsubcomid",ManageDetachComInfo.getFmdftsubcomid());
}else{
   fmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("fmdetachable",fmdetachable);
   session.setAttribute("fmdftsubcomid","0");
}

%>
<%!
private Map getCheckRightSubCompanyParam(String userRightStr,User user,String fmdetachable,int subCompanyId,String subCompanyIdName,
	HttpServletRequest request,HttpServletResponse response,HttpSession session){
	int operatelevel=0;
	Map map = new HashMap();
	if(subCompanyIdName.equals("")){
		subCompanyIdName = "subCompanyId";
	}
	
	if(fmdetachable.equals("1")){  
		if(subCompanyId==-1){
		    if(request.getParameter(subCompanyIdName)==null){
		        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
		    }else{
		        subCompanyId=Util.getIntValue(request.getParameter(subCompanyIdName),-1);
		    }
		    if(subCompanyId == -1){
		        subCompanyId = user.getUserSubCompany1();
		    }
		}
	    CheckSubCompanyRight CheckSubCompanyRight = new CheckSubCompanyRight();
	    operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),userRightStr,subCompanyId);
	    if(operatelevel>=0){
		    session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
	    }
	}else{
	    if(HrmUserVarify.checkUserRight(userRightStr, user)){
	        operatelevel=2;
	    }
	}
	String currentSubCompanyId = ""+session.getAttribute("defaultSubCompanyId");
	map.put("currentSubCompanyId",currentSubCompanyId);
	map.put("subCompanyId",subCompanyId);
	map.put("operatelevel",operatelevel);
	return map;
}
%>