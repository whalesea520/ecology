<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs03" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="rs04" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="rs05" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="rs06" class="weaver.conn.RecordSet" scope="page" /> 
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response);
StringBuffer result = new StringBuffer("{");

if(user == null){
	result.append("\"info\":{\"success\":false,\"msg\":\"user error!\"}");
}else{
	
	String operatorId=""+user.getUID();
	String operation=Util.null2String(request.getParameter("operation"));
	String poststr=Util.null2String(request.getParameter("poststr"));
	int formid=Util.getIntValue (request.getParameter("formid"),0);
	int requestid=Util.getIntValue (request.getParameter("requestid"),0);
	
	String msg="";
	HashMap tmpMap=new HashMap<String,String>();
	if(!"".equals(poststr)){
		
		
		HashMap selfMap=new HashMap<String,String>();
		String sql="";
		if(formid==221){//减损
			sql="select t1.lossCpt as cptid,t1.losscount as num from bill_cptloss t1 where t1.requestid="+requestid;
		}else if(formid==18){//调拨
			sql="select d.capitalid as cptid,d.number_n as num from bill_CptAdjustMain m,bill_CptAdjustDetail d where d.cptadjustid=m.id and m.requestid="+requestid;
		}else if(formid==201){//报废
			sql="select t.capitalid as cptid,t.numbers as num from bill_Discard_Detail t where t.detailrequestid="+requestid;
		}else if(formid==19){//领用
			sql="SELECT t1.capitalid as cptid,t1.number_n as num FROM bill_CptFetchDetail t1 ,bill_CptFetchMain t2 WHERE t1.cptfetchid =t2.id AND t2.requestid = "+requestid;
		}
		
		rs03.executeSql(sql);
		while(rs03.next()){
			String tmpid=Util.null2String( rs03.getString("cptid"));
			String tmpsl= Util.null2String(rs03.getString("num"));
			
			if(selfMap.containsKey(tmpid)){
				selfMap.put(tmpid,  ""+(Util.getDoubleValue(""+selfMap.get(tmpid),0)+Util.getDoubleValue(tmpsl,0)) );
			}else{
				selfMap.put(tmpid, tmpsl);
			}
		}
		
		
		String[] s= Util.TokenizerString2(poststr, "|");
		for(int i=0;i<s.length;i++){
			String[] ss= Util.TokenizerString2(s[i], ",");
			if(ss.length>=2){
				String sql2="select capitalnum,frozennum,sptcount from cptcapital where id="+ss[0];
				
				rs.executeSql(sql2);
				if(rs.next()){
					double capitalnum=Util.getDoubleValue(rs.getString("capitalnum"),0);
					double frozennum=Util.getDoubleValue(rs.getString("frozennum"),0);
					String sptcount=Util.null2String(rs.getString("sptcount"));
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
					
					if((available_num+Util.getDoubleValue((String)selfMap.get(ss[0]),0) )<Util.getDoubleValue(""+tmpMap.get(ss[0]) ,0) || (capitalnum < Util.getDoubleValue(""+tmpMap.get(ss[0]) ,0)) ){
						
						HashMap<String,String> frozenworkflowmap= CptWfUtil.getCptFrozenWorkflow(ss[0]);
					    String reqid="";
						if(frozenworkflowmap!=null&&frozenworkflowmap.size()>0){
							for (Map.Entry<String, String> entry : frozenworkflowmap.entrySet()) {
								  reqid = entry.getKey();
								}
							}		
						
						if(sptcount.equals("1")){
							if( (Util.getIntValue(reqid,0)!=requestid) || (Util.getDoubleValue(""+tmpMap.get(ss[0]) ,0) > frozennum) || (capitalnum < Util.getDoubleValue(""+tmpMap.get(ss[0]) ,0))){
								msg=CapitalComInfo.getCapitalname(ss[0])+" "+SystemEnv.getHtmlLabelName(33044, user.getLanguage());
								break;
						  }
						
						}else{
							if( (Util.getIntValue(reqid,0)!=requestid) || (Util.getDoubleValue(""+tmpMap.get(ss[0]) ,0) > frozennum)){
								msg=CapitalComInfo.getCapitalname(ss[0])+" "+SystemEnv.getHtmlLabelName(33044, user.getLanguage());
								break;
						  }
							
						}

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
