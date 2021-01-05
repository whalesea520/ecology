
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page"/>
<%
    char separator = Util.getSeparator() ;
    String operation = Util.null2String(request.getParameter("operation"));
    
    String labelId = Util.null2String(request.getParameter("labelId"));
    String menuName = Util.null2String(request.getParameter("menuName"));
    String linkAddress = Util.null2String(request.getParameter("linkAddress"));
    String parentFrame = Util.null2String(request.getParameter("parentFrame"));
    String defaultParentId = Util.null2String(request.getParameter("defaultParentId"));
    String defaultLevel = Util.null2String(request.getParameter("defaultLevel"));
    String defaultIndex = Util.null2String(request.getParameter("defaultIndex"));

    String needRightToView = Util.null2String(request.getParameter("needRightToView"));
    String rightDetailToView = Util.null2String(request.getParameter("rightDetailToView"));

    String needRightToVisible = Util.null2String(request.getParameter("needRightToVisible"));
    String rightDetailToVisible = Util.null2String(request.getParameter("rightDetailToVisible"));

    String needSwitchToVisible = Util.null2String(request.getParameter("needSwitchToVisible"));
    String switchClassNameToVisible = Util.null2String(request.getParameter("switchClassNameToVisible"));
    String switchMethodNameToVisible = Util.null2String(request.getParameter("switchMethodNameToVisible"));

    String needSwitchToView = Util.null2String(request.getParameter("needSwitchToView"));
    String switchClassNameToView = Util.null2String(request.getParameter("switchClassNameToView"));
    String switchMethodNameToView = Util.null2String(request.getParameter("switchMethodNameToView"));

    String systemModuleId = Util.null2String(request.getParameter("systemModuleId"));

    if(needRightToView.equalsIgnoreCase("")){
        needRightToView = "0";
    }
    if(needRightToVisible.equalsIgnoreCase("")){
        needRightToVisible = "0";
    }
    if(needSwitchToVisible.equalsIgnoreCase("")){
        needSwitchToVisible = "0";
    }
    if(needSwitchToView.equalsIgnoreCase("")){
        needSwitchToView = "0";
    }

	//搜索标签操作
    if(operation.equalsIgnoreCase("searchLabel")){
      String descLike = request.getParameter("descLike");
	  descLike=URLEncoder.encode(descLike);//用response.sendRedirect来传递需要转码接收方需要解码

      response.sendRedirect("MainMenuAdd.jsp?labelId="+labelId+"&linkAddress="+linkAddress+"&defaultParentId="+defaultParentId+"&systemModuleId="+systemModuleId+"&descLike="+descLike+"&defaultLevel="+defaultLevel+"&defaultIndex="+defaultIndex);
      return ;
    }

    //搜索操作
    if(operation.equalsIgnoreCase("search")){
        String searchMenuName = Util.null2String(request.getParameter("searchMenuName"));
        searchMenuName=URLEncoder.encode(searchMenuName);//用response.sendRedirect来传递需要转码接收方需要解码
        String menuId = Util.null2String(request.getParameter("menuId"));

		response.sendRedirect("ManageMainMenu.jsp?searchMenuName="+searchMenuName+"&menuId="+menuId+"&defaultLevel="+defaultLevel+"&defaultParentId="+defaultParentId);
        return ;
    }
    //添加操作
    else if(operation.equalsIgnoreCase("addMainMenuInfo")){ 
        String maxIdSql = "SELECT MAX(id) as MaxId FROM MainMenuInfo";

        RecordSet.executeSql(maxIdSql);
        int maxId = 0;
        while(RecordSet.next()){
            maxId = RecordSet.getInt("MaxId");
        }
        
		if(defaultIndex.equalsIgnoreCase("")){
			defaultIndex = "1";
		}
        String para = "";
        
        para = defaultParentId;
        para +=separator+defaultIndex;

        rs.executeProc("MainMenuConfig_U_ByInfoInsert", para);
    
        int id = maxId+1;
        para = String.valueOf(id);
        para +=separator+labelId;
        para +=separator+menuName;
        para +=separator+linkAddress;
        para +=separator+parentFrame;
        para +=separator+defaultParentId;
        para +=separator+defaultLevel;
        para +=separator+defaultIndex;

        para +=separator+needRightToVisible;
        para +=separator+rightDetailToVisible;
        para +=separator+needRightToView;
        para +=separator+rightDetailToView;

        para +=separator+needSwitchToVisible;
        para +=separator+switchClassNameToVisible;
        para +=separator+switchMethodNameToVisible;

        para +=separator+needSwitchToView;
        para +=separator+switchClassNameToView;
        para +=separator+switchMethodNameToView;

        para +=separator+systemModuleId;

        rs.executeProc("MainMenuInfo_Insert", para);
        
    	response.sendRedirect("ManageMainMenu.jsp");
      	return ;
    }
    //删除操作
    else if(operation.equalsIgnoreCase("deleteMenu")){
		String id = Util.null2String(request.getParameter("deleteMenuId"));
		String para = "";

        para = id;

		rs.executeProc("MainMenuInfo_DeleteById", para);
        
    	response.sendRedirect("ManageMainMenu.jsp");
      	return ;
    }
    //修改--采用先删后加的形式
    else if(operation.equalsIgnoreCase("editMainMenuInfo")){ 
		String id = Util.null2String(request.getParameter("menuId"));
		String oldIndex = Util.null2String(request.getParameter("oldIndex"));
		if(defaultIndex.equalsIgnoreCase("")){
			defaultIndex = "1";
		}
		String para = "";

        para = id;
        para +=separator+oldIndex;
        para +=separator+labelId;
        para +=separator+menuName;
        para +=separator+linkAddress;
        para +=separator+parentFrame;
        para +=separator+defaultParentId;
        para +=separator+defaultLevel;
        para +=separator+defaultIndex;

        para +=separator+needRightToVisible;
        para +=separator+rightDetailToVisible;
        para +=separator+needRightToView;
        para +=separator+rightDetailToView;

        para +=separator+needSwitchToVisible;
        para +=separator+switchClassNameToVisible;
        para +=separator+switchMethodNameToVisible;

        para +=separator+needSwitchToView;
        para +=separator+switchClassNameToView;
        para +=separator+switchMethodNameToView;

        para +=separator+systemModuleId;

		rs.executeProc("MainMenuInfo_Update", para);
        
    	response.sendRedirect("ManageMainMenu.jsp");
      	return ;
    }
%>