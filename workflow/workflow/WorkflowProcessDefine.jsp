
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.*" %>
<%@page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="node" class="weaver.workflow.node.NodeInfo" scope="page" />

<%

	User user = HrmUserVarify.getUser (request , response) ;
    int wfid=Util.getIntValue(request.getParameter("wfid"),-1);
    int officalType=Util.getIntValue(request.getParameter("officalType"),-1);
    List<Map<String,String>> pds = new ArrayList<Map<String,String>>();
   	rs.executeSql("select * from workflow_processdefine where status=1 and linkType="+officalType+" order by sortorder");
   	while(rs.next()){
   		Map<String,String> map = new HashMap<String,String>();
   		int labelid = Util.getIntValue(rs.getString("shownamelabel"),-1);
   		String label = SystemEnv.getHtmlLabelName(labelid,user.getLanguage(),true);
   		if(label.equals(""))label = rs.getString("label");
   		map.put("id",rs.getString("id"));
   		map.put("sysid",Util.null2String(rs.getString("sysid")));
   		map.put("label",label);
   		pds.add(map);
   	}
%>
<input type="hidden" name="saveThNode" id="saveThNode" value="0"/>
<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'formTableId':'oTableProcess','cols':'2','cws':'40%,60%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("26528,33691",user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33569,33417",user.getLanguage())%></wea:item>
				<%
				for(int i=0;i<pds.size();i++){
					Map<String,String> map = pds.get(i);
					int sysid = Util.getIntValue(map.get("sysid"),-1);
				%>
			    	<wea:item>
			    		<INPUT TYPE="hidden" id="pdid_<%= i %>" NAME="pdid_<%=i %>" VALUE="<%= map.get("id") %>">
			    		<INPUT TYPE="hidden" id="sysid_<%= i %>" NAME="sysid_<%=i %>" VALUE="<%= sysid %>">
			    		<%=map.get("label")%>
			    	</wea:item>
					<wea:item>
						<%
							rs.executeSql("select nodeids from workflow_process_relative where workflowid="+wfid+" and officaltype="+officalType+" and pdid="+map.get("id")); 
							String nodeids = "";
							String nodeidsspan = "";
							String isSingle = "false";
							String mustInput = "1";
							String url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp?workflowId="+wfid+"&printNodes=";
							if(rs.next()){
								nodeids = Util.null2String(rs.getString("nodeids"));
							}
							if(sysid==1||sysid==10||sysid==16){
								mustInput = "0";
								rs.executeSql("select nodeid from workflow_flownode where workflowid="+wfid+" and nodetype=0");
								if(rs.next()){
									nodeids = Util.null2String(rs.getString("nodeid"));
								}
							}else if(sysid==5){
								isSingle = "true";
								url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkFlowNodeBrowser.jsp?wfid="+wfid;
								if(nodeids.equals("")){
									//获取套红设置中设置的套红节点
									rs.executeSql("select useTempletNode from workflow_createdoc where workflowId="+wfid);
									if(rs.next()){
										nodeids = Util.null2String(rs.getString("useTempletNode"));
									}
								}
							}else if(sysid==6){
								if(nodeids.equals("")){
									//获取签章设置中设置的签章节点
									rs.executeSql("select signatureNodes from workflow_createdoc where workflowId="+wfid);
									if(rs.next()){
										nodeids = Util.null2String(rs.getString("signatureNodes"));
									}
								}
							}else if(sysid==7){
								if(nodeids.equals("")){
									//获取签章设置中设置的打印节点
									rs.executeSql("select printNodes from workflow_createdoc where workflowId="+wfid);
									if(rs.next()){
										nodeids = Util.null2String(rs.getString("printNodes"));
									}
								}
							}
							if(!nodeids.equals("")){
								String[] nodes = node.getNodeName(nodeids);
								nodeids = nodes[0];
								nodeidsspan = nodes[1];
							}
							
						%>
						<brow:browser name='<%="nodeids_"+i %>' viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="name"
						browserUrl='<%=url %>' isMustInput='<%= mustInput%>' isSingle='<%=isSingle %>' hasInput="false"
						temptitle='<%= SystemEnv.getHtmlLabelNames("33569,33417",user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
						width="300px" browserValue='<%=nodeids%>' browserSpanValue='<%=nodeidsspan%>' />
			    	</wea:item>
			<%
			}
			%>
	</wea:group>
</wea:layout>
<input type="hidden" name="processRows" id="processRows" value="<%=pds.size() %>"/>
