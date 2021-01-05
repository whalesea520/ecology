<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="java.util.*"%>

<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>

<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%
    /*用户验证*/
   
    String cloudstore = Util.null2String( new BaseBean().getPropValue("cloudstore","cloudstore"));
    
    MenuMaint mm = new MenuMaint("top", 3, user.getUID(), user.getLanguage());
    List menuArray = mm.getAllMenus(user, 1);
    for(int i=0;i<menuArray.size();i++){
    	Map menu = (Map)menuArray.get(i);
    	String target = Util.null2String(menu.get("target"));
    	String url = Util.null2String(menu.get("url"));
    	String infoId = Util.null2String(menu.get("infoId"));
    	if(infoId.equals("10010")){
    		if(cloudstore.equals("")){
    			continue;
    		}else{
    			target="_blank";
    			url = cloudstore;
    		}
    	}
    	
    	
    	%>
		 <div menuid='<%=menu.get("levelid")%>' target="<%=target %>" parentid ="<%=menu.get("parentId") %>" url="<%=url %>"  title="<%=menu.get("name") %>" style=""></div>
	<%
}
   
    
    	
%>