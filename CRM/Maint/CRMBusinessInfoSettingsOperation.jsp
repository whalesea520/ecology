<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.conn.ConnStatement"%> 

<%
    User user=HrmUserVarify.getUser(request, response);
    if(user==null){
        return;
    }
    
    String method = Util.null2String(request.getParameter("method"));
    //应用设置
    if(method.equals("settings")) {
		//检查权限项
        if (!HrmUserVarify.checkUserRight("Customer:Settings", user)) {
            response.sendRedirect("/notice/noright.jsp");
            return;
        }
		
        String isopen = Util.null2String(request.getParameter("isopen"),"0");
        String serviceurl = Util.null2String(request.getParameter("serviceurl"));
        String appkey = Util.null2String(request.getParameter("appkey"));
        String iscache = Util.null2String(request.getParameter("iscache"),"0");
        String cacheday = Util.null2String(request.getParameter("cacheday"),"0");
        String [] crmtypes=request.getParameterValues("crmtype");
        String crmtype="";
        if(crmtypes!=null&&crmtypes.length>0) {
            for(int i=0;i<crmtypes.length;i++) {
                crmtype+=crmtypes[i]+",";
            }
        }
       
        StringBuilder sb=new StringBuilder();
        sb.append(" update crm_busniessinfosettings")
        .append(" set isopen='"+isopen+"'");
        if("1".equals(isopen)){
        	sb.append(" ,modifydate='"+TimeUtil.getCurrentDateString()+"'")
	        .append(" ,modifytime='"+TimeUtil.getOnlyCurrentTimeString()+"'")
	        .append(" ,modifyuser='"+user.getUID()+"'")
	        .append(" ,serviceurl='"+serviceurl+"'")
	        .append(" ,appkey='"+appkey+"'")
	        .append(" ,crmtype='"+crmtype+"'")
	        .append(" ,iscache='"+iscache+"'");
        	if("1".equals(iscache)){
            	sb.append(" ,cacheday='"+cacheday+"'");
            }
        }
        sb.append(" where id=1");
        
        RecordSet.executeSql(sb.toString());
        response.sendRedirect("CRMBusinessInfoSettings.jsp");
    }
    //数据缓存
    if(method.equals("eacheData")) {
        RecordSet brs = new RecordSet();
        String crmname = Util.null2String(request.getParameter("crmname"));
        String uid = user.getUID()+"";
        String data = Util.null2String(request.getParameter("data"));
      	//清除该客户名称的缓存数据
        brs.executeSql("delete from crm_busniessinfoeache where crmname='"+crmname+"'");
        //新增该客户名称的缓存数据
		if(brs.getDBType().equals("oracle")){//oracle特殊处理clob
			ConnStatement conn = null;
			try{
				conn = new ConnStatement();
				conn.setStatementSql("insert into crm_busniessinfoeache (userid,data,modifydate,modifytime,crmname) values('"+uid+"',empty_clob(),'"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','"+crmname+"')");
				conn.executeUpdate();
				conn.setStatementSql("select data from crm_busniessinfoeache where crmname='"+crmname+"' for update");
				conn.executeQuery();
				oracle.sql.CLOB clob = null; 
				if(conn.next()){
					clob = (oracle.sql.CLOB)conn.getClob(1);
					Writer outStream = clob.getCharacterOutputStream();
					char[] c = data.toCharArray();
		            outStream.write(c, 0, c.length);
		            outStream.flush();
		            outStream.close();
				 }
			}catch(Exception e){
				
			}finally {
				conn.close();
			}
		}else      
        	brs.executeSql("insert into crm_busniessinfoeache (userid,data,modifydate,modifytime,crmname) values('"+uid+"','"+data+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"','"+crmname+"')");
    }
    //记录访问日志
    if(method.equals("requestLog")) {
        RecordSet brs = new RecordSet();
        String crmid = Util.null2String(request.getParameter("crmid"));
        String requesttype = Util.null2String(request.getParameter("requesttype"));
        String cdate = TimeUtil.getCurrentDateString();
        String ctime = TimeUtil.getOnlyCurrentTimeString();
        String uid = user.getUID()+"";
        String fieldValue = "'"+crmid+"','"+requesttype+"','"+cdate+"','"+ctime+"','"+uid+"'";
        brs.executeSql("insert into crm_busniessinfolog(crmid,requesttype,requestdate,requesttime,requestuid) values("+fieldValue+")");
    }
    
    
    
%>
