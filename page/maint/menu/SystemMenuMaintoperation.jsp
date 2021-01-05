
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*,weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />

<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String type = Util.null2String(request.getParameter("type"));
String operate = Util.null2String(request.getParameter("operate"));
int resourceId = Util.getIntValue(Util.null2String(request.getParameter("resourceId")),0);
int resourceType = Util.getIntValue(Util.null2String(request.getParameter("resourceType")),0);
String tblInfo = "";
String tblConfig = "";
StringBuffer sbf = null;
if ("left".equalsIgnoreCase(type)) {
	tblInfo = "leftmenuinfo";
	tblConfig = "leftmenuconfig";
} else if ("top".equalsIgnoreCase(type)) {
	tblInfo = "mainmenuinfo";
	tblConfig = "mainmenuconfig";
}

if("menuDrag".equals(operate)){
	String moveType = Util.null2String(request.getParameter("moveType"));
	int curMenuId = Util.getIntValue(Util.null2String(request.getParameter("curMenuId")),0);
	int tarMenuId = Util.getIntValue(request.getParameter("tarMenuId"),0);
	int tarviewIndex = Util.getIntValue(request.getParameter("tarviewIndex"),0);
	int tarparentId = Util.getIntValue(request.getParameter("tarparentId"),0);
	
	int index = Util.getIntValue(request.getParameter("index"),0);
	sbf = new StringBuffer();
	
	
	
	String strSql="";
	
	if(tarviewIndex>= index){
		sbf.append("update ").append(tblConfig).append(" set viewIndex = viewIndex-1")
		.append(" where viewIndex <=" ).append(tarviewIndex).append("and infoId != ").append(curMenuId).append(" and resourceid=").append(resourceId)
		.append(" and resourceType=").append(resourceType);
		
	}else if(tarviewIndex<index){
		sbf.append("update ").append(tblConfig).append(" set viewIndex = viewIndex+1")
		.append(" where viewIndex >=" ).append(tarviewIndex).append("and infoId != ").append(curMenuId).append(" and resourceid=").append(resourceId)
		.append(" and resourceType=").append(resourceType);
		
		
	}
	strSql+=sbf.toString();
	
	rs.executeSql(sbf.toString());
	//System.out.println(tblInfo+"==:"+sbf.toString());
	sbf.setLength(0);
	
	sbf.append("update ").append(tblConfig).append(" set viewIndex = ").append(tarviewIndex)
		.append(" where infoId = ").append(curMenuId).append(" and resourceid=").append(resourceId)
		.append(" and resourceType=").append(resourceType);
	strSql+=sbf.toString();
	rs.executeSql(sbf.toString());
	
	
	//System.out.println(tblConfig+"==:"+sbf.toString());
	log.setItem("PortalMenu");
	log.setType("update");
	log.setSql(strSql);
	log.setDesc("拖动菜单顺序");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	response.sendRedirect("SystemMenuMaintList.jsp?type="+type+"&resourceType="+resourceType+"&resourceId="+resourceId+"&" + new Date().getTime() + "=" + new Date().getTime());
}else if("isvisible".equals(operate)){
	String[] menushowids = Util.TokenizerStringNew(Util.null2String(request.getParameter("menushowids")),",");
	String[] menuhideids = Util.TokenizerStringNew(Util.null2String(request.getParameter("menuhideids")),",");
	sbf = new StringBuffer();
	for(int i=0;i<menushowids.length;i++){
		sbf.append("update ").append(tblConfig).append(" set visible=1 where resourceid=")
			.append(resourceId).append(" and  resourcetype=").append(resourceType).append("  and infoid=").append(menushowids[i]);	
		rs.executeSql(sbf.toString());
		sbf.setLength(0);
	}
	for(int i=0;i<menuhideids.length;i++){
		sbf.append("update ").append(tblConfig).append(" set visible=0 where resourceid=")
		.append(resourceId).append(" and  resourcetype=").append(resourceType).append("  and infoid=").append(menuhideids[i]);	
		rs.executeSql(sbf.toString());
		sbf.setLength(0);
	}
	
	log.setItem("PortalMenu");
	log.setType("update");
	log.setSql("");
	log.setDesc("修改菜单显示状态");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
	//response.sendRedirect("SystemMenuMaintList.jsp?type="+type+"&resourceType="+resourceType+"&resourceId="+resourceId+"&" + new Date().getTime() + "=" + new Date().getTime());
	out.print("OK");
}else if("addLimit".equals(operate)){
	sbf = new StringBuffer();
	int menuId = Util.getIntValue(Util.null2String(request.getParameter("menuId")),0);
	String removeshareids = Util.null2String(request.getParameter("removeshareids"));
	String[] shareValues = request.getParameterValues("txtShareDetail"); 
    if (shareValues!=null) {       
		sbf.append("select visible,viewIndex,useCustomName,customName from ").append(tblConfig)
		.append(" where infoid = ").append(menuId).append(" and resourceid=").append(resourceId).append(" and  resourcetype=").append(resourceType);
		rs.executeSql(sbf.toString());
		//System.out.println(sbf.toString());
		sbf.setLength(0);
		if(rs.next()){
			
		String sharetype="";
        for (int i=0;i<shareValues.length;i++){               
        	//System.out.println(shareValues[i]+"<br>");
            String[] paras = Util.TokenizerStringNew(shareValues[i],"_");
            sharetype = paras[0];			
           
            if ("1".equals(sharetype)||"3".equals(sharetype)){  //1:多人力资源   3:多部门  
                String tempStrs[]=Util.TokenizerStringNew(paras[1],",");
                for(int k=0;k<tempStrs.length;k++){
                	sbf.append("INSERT INTO ").append(tblConfig).append("(userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName)")
        				.append("VALUES (0,").append(menuId).append(",").append(rs.getString("visible"))
        				.append(",").append(tempStrs[k]).append(",").append(sharetype).append(",0,0,")
        				.append(rs.getString("useCustomName")).append(",").append(rs.getString("CustomName")).append(")");
                	//System.out.println(sbf.toString());
                	rs1.executeSql(sbf.toString());
					sbf.setLength(0);
                }                       
            } 
        }
		}
    }
    if(!"".equals(removeshareids)){
    	String tempStrs[]=Util.TokenizerStringNew(removeshareids,",");
    	//System.out.println(tempStrs.length);
        for(int k=0;k<tempStrs.length;k++){
	    	sbf.append("DELETE from ").append(tblConfig).append(" where id=").append(tempStrs[k]);
	    	//System.out.println(sbf.toString());
	    	rs1.executeSql(sbf.toString());
	    	sbf.setLength(0);
        }
    }
    
    log.setItem("PortalMenu");
	log.setType("update");
	log.setSql("");
	log.setDesc("修改菜单查看泛微");
	log.setUserid(user.getUID()+"");
	log.setIp(request.getRemoteAddr());
	log.setOpdate(TimeUtil.getCurrentDateString());
	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
	log.savePortalOperationLog();
    out.println("OK");
}
%>