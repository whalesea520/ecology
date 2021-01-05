<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	user = HrmUserVarify.getUser(request, response) ;
	int ruleid = Util.getIntValue(request.getParameter("ruleid"));
	int linkid = Util.getIntValue(request.getParameter("linkid"));
	int formid = Util.getIntValue(request.getParameter("formid"));
	int rownum = Util.getIntValue(request.getParameter("rownum"),0);
    String wfid = Util.null2String(request.getParameter("wfid"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	
	int detailid = Util.getIntValue(request.getParameter("detailid"), -1);
	
	//int mapNodeId = 0;
	//int meetCondition = 0;
	int mpid = Util.getIntValue(request.getParameter("mapid"), -1);
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	Map<String, String> formfieldMap = null;
	Map<String, String> lnodeMap =  new HashMap<String, String>();
	Map<String, String> lmeetMap = new HashMap<String, String>();
	if (mpid > 0) {
		formfieldMap = new HashMap<String, String>();
	    String sql = "select * from rule_maplist where id=" + mpid;
	    rs = new RecordSet();
	    rs.executeSql(sql);
	    if (rs.next()) {
	        ruleid = Util.getIntValue(rs.getString("ruleid"));
	        linkid = Util.getIntValue(rs.getString("linkid"));
	        rulesrc = Util.null2String(rs.getString("rulesrc"));
	    }
	    sql = "select rulevarid,formfieldid,nodeid,meetCondition from rule_mapitem where ruleid="+ruleid+" and linkid="+linkid+" and rulesrc="+rulesrc+" and rowidenty="+rownum;
	    rs.executeSql(sql);
	    while(rs.next())
	    {
	    	if(!Util.null2String(rs.getString("rulevarid")).equals("")) {
	    		formfieldMap.put(rs.getString("rulevarid"),rs.getString("formfieldid"));
	    		int lnode = rs.getInt("nodeid");
	            int lmeet = rs.getInt("meetCondition");
	            if (lnode > 0) {
	                lnodeMap.put(rs.getString("rulevarid"), lnode + "");
	                lmeetMap.put(rs.getString("rulevarid"), lmeet + "");    
	            }	
	    	}
	    	//mapNodeId = rs.getInt("nodeid");
	    	//meetCondition = rs.getInt("meetCondition");
	    	
	    	
	    }

	    if(!wfid.equals(""))
	    {
		    sql="select formid,isbill from workflow_base where id=" + wfid;
		    rs.executeSql(sql);
			if (rs.next()) {
				isbill = Util.null2String(rs.getString("isbill"));
				formid= Util.getIntValue(rs.getString("formid"),0);
			}
	    }

	}
	
	RuleBusiness rulebusiness = new RuleBusiness();
	rulebusiness.setRuleid(ruleid);
	rulebusiness.setUser(user);
	
	List<Map<String, String>> varlist = rulebusiness.getAllVar();

	//根据wfid获取所有的节点和节点名称
	List<String> nodesOptions = new ArrayList<String>();
	Map<Integer, String> nodesMap = new LinkedHashMap<Integer, String>();
	String sql="SELECT id, nodename FROM workflow_nodebase a,workflow_flownode b "+
		"WHERE a.id=b.nodeid and b.workflowid="+wfid+" and (a.IsFreeNode IS NULL OR a.isfreenode <>'1') and b.nodeType <> '3' "+
		"ORDER BY id ASC";	
	rs.executeSql(sql);
	while(rs.next()){
	  nodesOptions.add("<option value="+rs.getInt("id")+">"+Util.null2String(rs.getString("nodename"))+"</option>");
	  nodesMap.put(rs.getInt("id"),rs.getString("nodename"));
	}
	
	%>

    <wea:layout type="2col">
   		<wea:group context='<%=SystemEnv.getHtmlLabelName(84549,user.getLanguage())%>'>
   			<wea:item><%=SystemEnv.getHtmlLabelName(33748,user.getLanguage())%></wea:item>
   			<wea:item><%=SystemEnv.getHtmlLabelName(83842,user.getLanguage())%></wea:item>
   			<%
   				if(varlist!=null){
   				String pretype = "";
   				String prebrowsertype = "";
				for (int i=0; i<varlist.size(); i++) {
				    Map<String, String> varbean = varlist.get(i);
				    String id = varbean.get("id");
		            String name = varbean.get("name");
		            String type = varbean.get("htmltype");
		            String browsertype = varbean.get("fieldtype");
		            List<Map<String, String>> mfieldlsit = null;
		            //System.out.println("ruleid:"+ruleid+" formid:"+formid+" isbill:"+isbill);
	                mfieldlsit = rulebusiness.getFormMappingList(formid, Util.getIntValue(isbill,0), Util.getIntValue(type, 0), Util.getIntValue(browsertype), Util.getIntValue(pretype,0), Util.getIntValue(prebrowsertype), detailid);    
	                
	                pretype = type;
	                prebrowsertype = browsertype;
		            
			%>
			<wea:item><%=name%></wea:item>
			<wea:item>				
				<select name="field_<%=id %>" _id="<%=id %>" onchange="optionChange(this)">
					<option id="-1" value="-1"></option>
					<%
					String htmltype = "";
					for (int k=0; k<mfieldlsit.size(); k++) {
					    Map<String, String> fieldbean = mfieldlsit.get(k);
					    String fieldid = fieldbean.get("id");
		                String fieldlabel = fieldbean.get("label");
		                String iselected = "";
		                htmltype = fieldbean.get("htmltype");
		                if(formfieldMap != null){
		                	if(formfieldMap.get(id) != null && formfieldMap.get(id).equals(fieldid))
		                		iselected = "selected=\"selected\"";
		                }		                
					%>
					<option value="<%=fieldid %>" <%=iselected %>><%=fieldlabel %></option>					
					<%
					}					
					%>
				</select>
				
				<%
				if (type.equals("9")) {
				    int lnode = Util.getIntValue(lnodeMap.get(id));
				    int lmeet = Util.getIntValue(lmeetMap.get(id));
				%>
				
				<span name="locationSpan_<%=id %>" id="locationSpan_<%=id %>" <%if(htmltype.equals("9") && lnode > 0) {%>style="display:'';" <%}else{%>style="display:none;"<%}%>>
					&nbsp;&nbsp; <%=SystemEnv.getHtmlLabelName(15586,user.getLanguage()) %> <!-- 节点 -->
					<select id="nodeSelect_<%=id %>" name="nodeSelect_<%=id %>" >
						<%
						for(int key : nodesMap.keySet()){
						%>
							<option <%if(lnode == key) {%>selected <% }%> value="<%=key%>" ><%=nodesMap.get(key)%></option>	
						<%}%>
					</select> 
					<select id="meetSelect_<%=id %>" name="meetSelect_<%=id %>" >
						<option <%if(lmeet == 2) {%>selected <% }%> value='2'><%=SystemEnv.getHtmlLabelName(125879,user.getLanguage()) %></option> <!-- 全部满足 -->
						<option <%if(lmeet == 1) {%>selected <% }%> value='1'><%=SystemEnv.getHtmlLabelName(125878,user.getLanguage()) %></option> <!-- 任意满足 -->
					</select>
				</span>		
				<%
				}
				%>
				<input type="hidden" id="htmltype_<%=id %>" name=htmltype value="<%=htmltype %>" />				
			</wea:item>
			<%
			}
   				}
			%>
   		</wea:group>
   	</wea:layout>
<script type="text/javascript">

function optionChange(o){
    var oid = $(o).attr("_id");
	if(jQuery("#htmltype_" + oid).val() === "9" && o.value!= "-1" ){
		jQuery("span[name='locationSpan']").show();	
		$("#locationSpan_" + oid).show();	
	}else{
		$("#locationSpan_" + oid).hide();
	}
}
</script>	
