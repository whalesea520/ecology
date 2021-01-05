<%@page import="weaver.wxinterface.InterfaceUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	out.clearBuffer();
	response.setContentType("application/json;charset=GBK");
	if(WxInterfaceInit.isIsutf8()){
		response.setContentType("application/json;charset=UTF-8");
	}
	String operation = Util.null2String(request.getParameter("operation"));
	
	JSONObject resultinfo = new JSONObject();
	try{
		if(operation.equals("getWFUsers")){//读取流程相关人员
			String requestid = Util.null2String(request.getParameter("requestid"));
			int topsize = Util.getIntValue(request.getParameter("topsize"),100);
			if(!"".equals(requestid)){
				
				String creater = RequestComInfo.getRequestCreater(requestid);
				resultinfo.put("requestname", Util.null2String(RequestComInfo.getRequestname(requestid)));
				
				if(!creater.equals("")){
					
					String userkeytype = InterfaceUtil.getUserkeytype();
					
					JSONObject jo = new JSONObject();
		        	if(userkeytype.equals("loginid")){//转化为登录名
		        		jo.put("usertag",Util.null2String(InterfaceUtil.transUserId(creater,1)));
					}else{
						jo.put("usertag",creater);
					}
					jo.put("username",ResourceComInfo.getResourcename(creater));
					jo.put("subcompany",Util.getMoreStr(SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(creater)), 8, "..."));
					jo.put("depart",Util.getMoreStr(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(creater)), 8, "..."));
					jo.put("jobtitle",Util.getMoreStr(JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(creater)), 12, "..."));
					jo.put("imgurl",Util.null2String(ResourceComInfo.getMessagerUrls(creater)));
					
					
					resultinfo.put("creater", jo);
					
					JSONArray userarray1 = new JSONArray();//已操作者
					JSONArray userarray2 = new JSONArray();//未操作者
					
					
					String userid = "";
					String usertag = "";
					String username = "";
					String belongto = "";
					String accounttype = "";
					String sql = "select distinct top "+(topsize+1)+" t1.userid,t1.usertype,t1.agenttype,t1.agentorbyagentid,t1.isremark,t1.viewtype,t2.accounttype,t2.belongto"
						+" from workflow_currentoperator t1,HrmResource t2 where t1.userid=t2.id and t2.status in (0,1,2,3) and t1.usertype=0 and t1.userid<>"+creater+" and t1.requestid = " + requestid;
					if("oracle".equals(rs.getDBType())){
						sql = "select distinct t1.userid,t1.usertype,t1.agenttype,t1.agentorbyagentid,t1.isremark,t1.viewtype,t2.accounttype,t2.belongto"
						+" from workflow_currentoperator t1,HrmResource t2 where t1.userid=t2.id and t2.status in (0,1,2,3) and t1.usertype=0 and t1.userid<>"+creater+" and t1.requestid = " + requestid + " and rownum<="+(topsize+1);
					}
					rs.executeSql(sql);//and (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0))
			        int index = 0;
					while(rs.next()){
						index++;
						if(index<=topsize){
							userid = Util.null2String(rs.getString("userid"));
				        	usertag = Util.null2String(rs.getString("userid"));
				        	accounttype = Util.null2String(rs.getString("accounttype"));
				        	belongto = Util.null2String(rs.getString("belongto"));
				        	if("1".equals(accounttype) && !"".equals(belongto) && !"0".equals(belongto) && !"-1".equals(belongto)) usertag = belongto;//次账号取主账号人员ID
				        	
				        	if(userkeytype.equals("loginid")){//转化为登录名
				        		usertag = Util.null2String(InterfaceUtil.transUserId(usertag,1));
							}
				        	
				        	if(rs.getInt("agenttype")==2){
				        		username =  ResourceComInfo.getResourcename(rs.getString("agentorbyagentid"))+"->"+ResourceComInfo.getResourcename(userid);
				        	}else{
				        		username = ResourceComInfo.getResourcename(userid);
				        	}
				        	
				        	jo = new JSONObject();
				        	jo.put("usertag",usertag);
							jo.put("username",username);
							jo.put("subcompany",Util.getMoreStr(SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(userid)), 8, "..."));
							jo.put("depart",Util.getMoreStr(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(userid)), 8, "..."));
							jo.put("jobtitle",Util.getMoreStr(JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(userid)), 12, "..."));
							jo.put("imgurl",Util.null2String(ResourceComInfo.getMessagerUrls(userid)));
							
							
							int isremark = Util.getIntValue(rs.getString("isremark"),0);
				        	int viewtype = Util.getIntValue(rs.getString("viewtype"),0);
				        	
				        	if((isremark==0||isremark==1||isremark==5||isremark==7||isremark==8||isremark==9) || (isremark==4||viewtype==0)){
				        		//未操作者
				        		userarray2.put(jo);
				        	}else{
				        		//已操作者
				        		userarray1.put(jo);
				        	}
						} 
			        }
			        
			        if(userarray1.length()>0) resultinfo.put("operators1", userarray1);
			        if(userarray2.length()>0) resultinfo.put("operators2", userarray2);
			        
			        if(index>topsize) resultinfo.put("hasmore", 1);
			        else resultinfo.put("hasmore", 0);
				}
			}
		}else if(operation.equals("getRequestName")){
			String requestid = Util.null2String(request.getParameter("requestid"));
			String requestname = "";
			if(!requestid.equals("")){
				requestname = Util.null2String(RequestComInfo.getRequestname(requestid));
			}
			resultinfo.put("requestname", requestname);
		}
	}catch(Exception e){
		
	}
	
	out.print(resultinfo);
%>
