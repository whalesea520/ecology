<%@page import="com.sap.mw.jco.JCO"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
		
		String flag="0";//0保存失败,1保存成功
		//save--保存,update--修改,delete-删除
		String opera=Util.null2String(request.getParameter("opera"));
		String id=Util.null2String(request.getParameter("ids"));
		if(!"".equals(id)&&(id.length()==(id.lastIndexOf(",")+1)))
		{
			id=id.substring(0,(id.length()-1));
		}
		String hpid=Util.null2String(request.getParameter("hpid"));
		String poolname=Util.null2String(request.getParameter("poolname")); 
		String hostname1=Util.null2String(request.getParameter("hostname"));
		String systemNum=Util.null2String(request.getParameter("systemnum"));
		String saprouter=Util.null2String(request.getParameter("saprouter"));
		String client=Util.null2String(request.getParameter("client"));
		String language=Util.null2String(request.getParameter("language"));
		String username=Util.null2String(request.getParameter("username"));
		String password=Util.null2String(request.getParameter("password"));
		int maxConnNum=Util.getIntValue(request.getParameter("maxconnnum"),50);
		String datasourceDes=Util.null2String(request.getParameter("datasourcedes"));
		String sql="";
		if("save".equals(opera))
		{
			sql=" insert into sap_datasource (hpid,poolname,hostname,systemNum,saprouter,client,language,username,password,maxConnNum,datasourceDes)";
			sql+=" values ('"+hpid+"','"+poolname+"','"+hostname1+"','"+systemNum+"','"+saprouter+"','"+client+"','"+language+"','"+username+"','"+password+"','"+maxConnNum+"','"+datasourceDes+"')";
			//System.out.println("插入"+sql);
			if(rs.execute(sql))
			{
				flag="1";
			}
			JCO.removeClientPool(id+"");	
			response.sendRedirect("/integration/dateSource/dataSAPNew.jsp?closeDialog=close&isNew=1&id="+hpid);
			return;
		}else if("update".equals(opera))
		{
			sql=" update sap_datasource set hpid='"+hpid+"',poolname='"+poolname+"',hostname='"+hostname1+"',systemNum='"+systemNum+"',saprouter='"+saprouter+"',client='"+client+"',language='"+language+"',username='"+username+"',password='"+password+"',maxConnNum='"+maxConnNum+"',datasourceDes='"+datasourceDes+"'";
			sql+=" where id='"+id+"'";
			if(rs.execute(sql))
			{
				flag="1";
			}
			JCO.removeClientPool(id+"");	
			response.sendRedirect("/integration/dateSource/dataSAPNew.jsp?closeDialog=close&isNew=1&id="+hpid);
			return;
		}else if("delete".equals(opera))
		{
				sql=" delete sap_datasource where id in("+id+")";
				if(rs.execute(sql))
				{
					flag="1";
				}
			String isDialog=Util.null2String(request.getParameter("isDialog"));
			if("1".equals(isDialog)){
				JCO.removeClientPool(id+"");	
				response.sendRedirect("/integration/dateSource/dataSAPNew.jsp?closeDialog=close&isNew=1&id="+id);
				return;
			}
		}
		//清除连接池中的该项连接配置，以便启用新的连接池的配置，这样可以防止重启服务的麻烦
		JCO.removeClientPool(id+"");		   
%>

<script type="text/javascript">
	<!--
		if(<%=flag%>==1)
		{
			alert("<%=SystemEnv.getHtmlLabelName(30648,user.getLanguage())%>!");
		}else
		{
			alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage())%>!");
		}
		window.location.href="/integration/dateSource/dataSAPlist.jsp?hpid=<%=hpid%>";
//-->
</script>
