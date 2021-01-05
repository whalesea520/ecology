<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
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
	String cptwftype=Util.null2String(request.getParameter("cptwftype"));
	boolean ismodecpt="true".equalsIgnoreCase( Util.null2String(request.getParameter("ismodecpt")));
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int currentnodetype=Util.getIntValue(request.getParameter("currentnodetype"),0);
	int formid=Util.getIntValue(request.getParameter("formid"),0);
	int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);

	if(requestid>0){
		rs2.executeSql("select t1.currentnodetype,t1.workflowid,t2.formid from workflow_requestbase t1,workflow_base t2 where t1.workflowid=t2.id and t1.requestid="+requestid);
		if(rs2.next()){
			currentnodetype=rs2.getInt("currentnodetype");
			formid=rs2.getInt("formid");
			workflowid=rs2.getInt("workflowid");
		}
	}
	
	String msg="";
	HashMap tmpMap=new HashMap<String,String>();
	if(!"".equals(poststr)&&!ismodecpt){
		HashMap selfMap=new HashMap<String,String>();
		if(requestid>0&&currentnodetype>0&&currentnodetype<3){//来自流程,剔除掉自身的数量
			
			JSONObject jsonObject= CptWfUtil.getCptwfInfo(""+workflowid);
			String cptmaintablename="formtable_main_"+(-formid);
			RecordSet.execute("select tablename from workflow_bill where id="+formid);
			while(RecordSet.next()){
				cptmaintablename=RecordSet.getString("tablename");
			}
			String cptdetailtablename=cptmaintablename;
			String zcname=jsonObject.getString("zcname");
			String zcsl=jsonObject.getString("slname");
			int zcViewtype=Util.getIntValue(""+jsonObject.getInt ("zctype"),0);
			if(zcViewtype==1){
				cptdetailtablename+="_dt1";
			}else if(zcViewtype==2){
				cptdetailtablename+="_dt2";
			}else if(zcViewtype==3){
				cptdetailtablename+="_dt3";
			}else if(zcViewtype==4){
				cptdetailtablename+="_dt4";
			}
			String cptsearchsql="";
			if(!cptdetailtablename.equals(cptmaintablename)){
				cptsearchsql="select d."+zcname+" as cptzcid,d."+zcsl+" as cptnum from "+cptmaintablename+" m ,"+cptdetailtablename+" d where d.mainid=m.id and m.requestid="+requestid;
			}else{
				cptsearchsql="select m."+zcname+" as cptzcid,m."+zcsl+" as cptnum from "+cptmaintablename+" m  where  m.requestid="+requestid;
			}
			RecordSet.executeSql(cptsearchsql);			
			while(RecordSet.next()){
				String tmpid= RecordSet.getString("cptzcid");
				String tmpsl= RecordSet.getString("cptnum");
				
				if(selfMap.containsKey(tmpid)){
					selfMap.put(tmpid,  ""+(Util.getDoubleValue(""+selfMap.get(tmpid),0)+Util.getDoubleValue(tmpsl,0)) );
				}else{
					selfMap.put(tmpid, tmpsl);
				}
				
			}
			
		}
		
		
		
		
		
		
		String[] s= Util.TokenizerString2(poststr, "|");
		for(int i=0;i<s.length;i++){
			String[] ss= Util.TokenizerString2(s[i], ",");
			if(ss.length>=2){
				String sql="select capitalnum,frozennum,sptcount from cptcapital where id="+ss[0];
				
				rs.executeSql(sql);
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
		
		
		
	}else if(ismodecpt&&!"".equals(poststr)){//建模资产流程判断


		String[] s= Util.TokenizerString2(poststr, "|");
		for(int i=0;i<s.length;i++){
			String[] ss= Util.TokenizerString2(s[i], ",");
			if(ss.length>=2){
				Map<String, Object> capitalInfoMap=Cpt4modeUtil.getCapitalInfo(ss[0]);
				double capitalnum=Util.getDoubleValue((String) capitalInfoMap.get("capitalnum"), 0.0);
				double usenum=Util.getDoubleValue(ss[1],0.0);
				String sql="select SUM(frozennum) as frozennum from uf4mode_cptwffrozennum where requestid<>"+requestid+" and cptid="+ss[0];
				rs.executeSql(sql);
				if(rs.next()){
					double frozennum=Util.getDoubleValue(rs.getString("frozennum"),0.0);
					if(frozennum<0) frozennum=0;
					double available_num=0;
					if(capitalnum-frozennum<0){
						available_num=0;
					}else{
						available_num=capitalnum-frozennum;
					}

					if(available_num <usenum){
						msg=capitalInfoMap.get("name")+" "+SystemEnv.getHtmlLabelName(33044, user.getLanguage());
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
