
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkShareManager"%>
<%@page import="weaver.email.WeavermailUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />

<%
if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String method = Util.null2String(request.getParameter("method"));
String cotypeid = Util.null2String(request.getParameter("cotypeid"));
String settype = Util.null2String(request.getParameter("settype"));

if (method.equals("add")){
    int shareType = Util.getIntValue(Util.null2String(request.getParameter("sharetype")),0);
    String shareId = Util.null2String(request.getParameter("relatedshareid"));
    int roleLevel = Util.getIntValue(Util.null2String(request.getParameter("rolelevel")),0);
    
    int seclevel = Math.min(Util.getIntValue(request.getParameter("seclevel")) , Util.getIntValue(request.getParameter("seclevelMax")));
    int seclevelMax = Math.max(Util.getIntValue(request.getParameter("seclevel")) , Util.getIntValue(request.getParameter("seclevelMax")));
    
	String jobtitlelevel = Util.null2String(request.getParameter("jobtitlelevel"));
	String jobtitlesubcompany = Util.null2String(request.getParameter("jobtitlesubcompany"));
	String jobtitledepartment = Util.null2String(request.getParameter("jobtitledepartment"));
	String scopeid = "0";
	if(jobtitlelevel.equals("1")){
		scopeid = jobtitledepartment;
	}else if(jobtitlelevel.equals("2")){
		scopeid = jobtitlesubcompany;
	}
	scopeid = ","+WeavermailUtil.trim(scopeid)+",";
	String jobtitleid = "-1" ;    
	if(shareType==6) jobtitleid = shareId ;
	

    String insertsql = "";
    if(settype.equals("manager")){
    	CoworkShareManager shareManager=new CoworkShareManager();
    	String[] shareIds=Util.TokenizerString2(shareId,",");
    	for(int i=0;i<shareIds.length;i++){
    		if(!"".equals(shareIds[i])){
    			insertsql = "insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,seclevelMax,rolelevel,jobtitleid,joblevel,scopeid) values("+cotypeid+","+shareType+",'"+shareIds[i]+"',"+seclevel+",'"+seclevelMax+"',"+roleLevel+",'"+jobtitleid+"',"+jobtitlelevel+",'"+scopeid+"')";
    			rs.executeSql(insertsql);
    		}    	
    	}
    	if(shareType == 5){
    		insertsql = "insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,seclevelMax,rolelevel) values("+cotypeid+","+shareType+",'"+shareIds+"',"+seclevel+",'"+seclevelMax+"',"+roleLevel+")";
			rs.executeSql(insertsql);
    	}
    }
    else if(settype.equals("members")){
    	String[] shareIds=Util.TokenizerString2(shareId,",");
    	for(int i=0;i<shareIds.length;i++){
    		if(!"".equals(shareIds[i])){
    			insertsql = "insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,seclevelMax,rolelevel,jobtitleid,joblevel,scopeid) values("+cotypeid+","+shareType+",'"+shareIds[i]+"',"+seclevel+",'"+seclevelMax+"',"+roleLevel+",'"+jobtitleid+"',"+jobtitlelevel+",'"+scopeid+"')";
    			rs.executeSql(insertsql);
    		}
    	}
    	
    	if(shareType == 5){
    		insertsql = "insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,seclevelMax,rolelevel) values("+cotypeid+","+shareType+",'"+shareIds+"',"+seclevel+",'"+seclevelMax+"',"+roleLevel+")";
			rs.executeSql(insertsql);
    	}
    	
    }
    //更新当前协作区所属协作负责人缓存
    if(settype.equals("manager")){
        String sql="select id  from cowork_items where typeid="+cotypeid;
        rs.executeSql(sql);
        CoworkShareManager shareManager=new CoworkShareManager();
        while(rs.next()){
     	   String coworkid=rs.getString("id");
     	   shareManager.deleteCache("typemanager",coworkid); //删除协作缓存
        }
     }
    CoTypeComInfo.removeCoTypeInfoCache();
		
    response.sendRedirect("CoworkTypeShareEdit.jsp?settype="+settype+"&cotypeid="+cotypeid);    	
}
else if (method.equals("delete")){
    String delId = Util.null2String(request.getParameter("delid"));
    String deletesql = "";
    if(settype.equals("manager")) deletesql = "delete from cotype_sharemanager where id="+delId;
    else if(settype.equals("members")) deletesql = "delete from cotype_sharemembers where id="+delId;
    if(!deletesql.equals("")) rs.executeSql(deletesql);
    //更新当前协作区所属协作负责人缓存
    if(settype.equals("manager")){
       String sql="select id  from cowork_items where typeid="+cotypeid;
       rs.executeSql(sql);
       CoworkShareManager shareManager=new CoworkShareManager();
       while(rs.next()){
    	   String coworkid=rs.getString("id");
    	   shareManager.deleteCache("typemanager",coworkid);//删除协作缓存
       }
    }
    CoTypeComInfo.removeCoTypeInfoCache();
    response.sendRedirect("CoworkTypeShareEdit.jsp?settype="+settype+"&cotypeid="+cotypeid); 
}
%>
