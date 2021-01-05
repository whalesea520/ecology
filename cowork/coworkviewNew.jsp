<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.cowork.CoworkDAO"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<body>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/js/ecology8/cowork/coworkview_wev8.js"></script>
		<%
		   
		   if(true){
			   response.sendRedirect("/cowork/CoworkTabFrame.jsp");
			   return;
		   }
		
			CoworkDAO coworkdao=new CoworkDAO();
			Map mainTotal=coworkdao.getCoworkCount(user,"main");
			Map subTotal=coworkdao.getCoworkCount(user,"sub");
			String leftMenus="";
			String sql="select * from cowork_maintypes ORDER BY id asc";
			RecordSet.execute(sql);
			while(RecordSet.next()){
				String mainTypeId=RecordSet.getString("id");
				String mainTypeName=RecordSet.getString("typename");
				String mainflowAll=mainTotal.containsKey(mainTypeId)?(String)mainTotal.get(mainTypeId):"0";
				
				String submenus="";           
				sql="SELECT * from cowork_types where departmentid="+mainTypeId+" ORDER BY id asc";
				rs.execute(sql);
				while(rs.next()){
					String subTypeId=rs.getString("id");
					String subTypeName=rs.getString("typename");
					String subflowAll=subTotal.containsKey(subTypeId)?(String)subTotal.get(subTypeId):"0";
					submenus+=",{name:'"+subTypeName+"',"+
								 "attr:{subTypeId:'"+subTypeId+"'},"+
								 "numbers:{flowAll:"+subflowAll+"}"+
		           				"}";
				}
				submenus=submenus.length()>0?submenus.substring(1):submenus;
				submenus="["+submenus+"]";
				
				leftMenus+=",{"+
							 "name:'"+mainTypeName+"',"+
							 "attr:{mainTypeId:'"+mainTypeId+"'},"+
							 "numbers:{flowAll:"+mainflowAll+"},"+
							 "submenus:"+submenus+
				 		   "}";
			}
			leftMenus=leftMenus.length()>0?leftMenus.substring(1):leftMenus;
			leftMenus="["+leftMenus+"]";
		%>
		<script>
			var demoLeftMenus=eval("(<%=leftMenus%>)");
		</script>
		<table cellspacing="0" cellpadding="0" class="flowsTable"  >
			<tr>
				<td class="leftTypeSearch">
					<span class="leftType">
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
					<span><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></span>
					</span>
					<span class="leftSearchSpan">
						&nbsp;<input type="text" class="leftSearchInput" />
					</span>
				</td>
				<td rowspan="2">
					<iframe src="/cowork/CoworkTabFrame.jsp" class="flowFrame" frameborder="0" ></iframe>
				</td>
			</tr>
			<tr>
				<td style="width:23%;" class="flowMenusTd">
					<div class="flowMenuDiv"  >
						<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
							<div class="ulDiv" ></div>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</body>
	<script type="text/javascript">
		window.hideAnyway = false;
	</script>
</html>