<%@page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response);
StringBuffer result = new StringBuffer("{");

if(user == null){
	result.append("\"info\":{\"success\":false,\"msg\":\"user error!\"}");
}else{
	
	String operatorId=""+user.getUID();
	String operation=Util.null2String(request.getParameter("operation"));
	String poststr=Util.null2String(request.getParameter("poststr"));
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int currentnodetype=Util.getIntValue(request.getParameter("currentnodetype"),0);
	int formid=Util.getIntValue(request.getParameter("formid"),0);
	int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);
	
	
	String msg="";
	HashMap tmpMap=new HashMap<String,String>();
	if(!"".equals(poststr)){
		
		String[] s= Util.TokenizerString2(poststr, "|");
		for(int i=0;i<s.length;i++){
			String[] ss= Util.TokenizerString2(s[i], ",");
			if(ss.length>=2){
				String sql="select capitalnum from uf_cptcapital where id="+ss[0];
				
				rs.executeSql(sql);
				if(rs.next()){
					double capitalnum=Util.getDoubleValue(rs.getString("capitalnum"),0);
					double frozennum=Util.getDoubleValue(rs.getString("frozennum"),0);
					if(frozennum<0) frozennum=0;
					double available_num=0;
					if(capitalnum-frozennum<0){
						available_num=0;
					}else{
						available_num=capitalnum-frozennum;
					}
					if(tmpMap.containsKey(ss[0])){
						tmpMap.put(ss[0],  ""+(Util.getDoubleValue(""+tmpMap.get(ss[0]),0)+Util.getDoubleValue(ss[1],0)) );
					}else{
						tmpMap.put(ss[0], ss[1]);
					}
					
					if(available_num <Util.getDoubleValue(""+tmpMap.get(ss[0]) ,0)){
						msg=Cpt4modeUtil.getCapitalInfo(ss[0]).get("name")+" "+SystemEnv.getHtmlLabelName(33044, user.getLanguage());
						break;
					}
					
				}else{
					
				}
			}
		}
		
		
		
	}
		
	result.append("\"msg\":\""+msg+"\",");
	
	result.append("\"info\":{\"success\":true,\"msg\":\"\"}");
	
}
result.append("}");

%>
<%=result.toString() %>
