<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<jsp:useBean id="CustomTreeUtil" class="weaver.formmode.tree.CustomTreeUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(user==null){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(563,user.getLanguage());//数据
	String needfav ="1";
	String needhelp ="";
	String sql = "";
	int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")),0);
	String fieldname = Util.null2String(request.getParameter("fieldname"),"");
	String pid = Util.null2String(request.getParameter("pid"));
	String searchkeyname = Util.null2String(request.getParameter("searchkeyname"));
	String pids[] = pid.split(CustomTreeData.Separator);
	String customdetailid = pids[0];
	String supid = pids[1];
	String defaultaddress = Util.null2String(request.getParameter("defaultaddress"));
	String treeremark = "";
	sql = "select * from mode_customtree where id = " + mainid;
	rs.executeSql(sql);
	boolean temp = false;
	while(rs.next()){
		temp = true;
		titlename = Util.null2String(rs.getString("rootname"));
		defaultaddress = Util.null2String(rs.getString("defaultaddress"));
		treeremark = Util.null2String(rs.getString("treeremark"));
	}
	
	if(!defaultaddress.equals("")){
		if (defaultaddress.indexOf("?") > -1) {
			defaultaddress += "&searchkeyname="+URLEncoder.encode(searchkeyname,"utf-8");
		} else {
			defaultaddress += "?searchkeyname="+URLEncoder.encode(searchkeyname,"utf-8");
		}
		String tempvalue = "";
		if(fieldname !=null && !fieldname.equals("")){
			rs.executeSql("select * from workflow_billfield where id="+fieldname);
			if(rs.next()){			
				String param1 = "&check_con="+fieldname;
			    String param2 = "&con"+fieldname+"_htmltype="+rs.getString("fieldhtmltype");
			    String param3 = "&con"+fieldname+"_type="+rs.getInt("type");
			    String param4 = "&con"+fieldname+"_colname="+rs.getString("fieldname");
			    String param5 = "&con"+fieldname+"_viewtype="+rs.getInt("viewtype");
			    String param6 = "&con"+fieldname+"_opt=3";
				String param7 = "&con"+fieldname+"_value="+URLEncoder.encode(searchkeyname,"utf-8");
				tempvalue = param1+param2+param3+param4+param5+param6+param7;
			}
			defaultaddress += tempvalue;
		}
		defaultaddress += "&id="+mainid;
		response.sendRedirect(defaultaddress);
		return;
	}

%>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(temp){ %>
<div style="padding-left: 15px;">
		<p><strong><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%><!-- 操作说明 --></strong></p>
		<ul>
		<%if("".equals(treeremark)){ %>
		
		  <li><%=SystemEnv.getHtmlLabelName(82269,user.getLanguage())%><!-- 点击左边树中的节点，本页会显示该节点对应的数据 --></li>
		  <li><%=SystemEnv.getHtmlLabelName(82270,user.getLanguage())%><!-- 如果选中的节点没有配置对应的地址，那么本页面的内容不会刷新 --></li>
		<%}else{ 
		String[] treeremarks = treeremark.split("\n"); 
		for(String tr : treeremarks){
		%>
		 <li><%=tr%></li>
		<% 
		}
		}
		%>
		</ul>
	</div>
	 <%}else{%>
	          <div  style="padding-left: 15px;padding-top: 25px;font-size:15px;color:red;">
		<%=SystemEnv.getHtmlLabelName(33713,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18967,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(126138,user.getLanguage())%>
			  </div>
	   <%}%>

</BODY>
</HTML>
