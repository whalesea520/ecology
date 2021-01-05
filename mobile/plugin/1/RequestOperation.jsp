
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.mobile.plugin.ecology.RequestOperation"%>
<%@ page import="weaver.mobile.webservices.workflow.*" %>
<%@ page import="weaver.general.* "%>
<%@ page import="org.apache.commons.lang.StringUtils "%>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.workflow.request.WorkflowSpeechAppend" %>
<%@	page import="weaver.file.FileUpload"%>
<%@	page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@ page import="weaver.workflow.request.WorkflowRequestMessage" %>
<%@ page import="weaver.workflow.request.RequestSaveCheckManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
FileUpload fu = new FileUpload(request);
String clienttype = Util.null2String(fu.getParameter("clienttype"));
String clientlevel = Util.null2String(fu.getParameter("clientlevel"));
String detailid = Util.null2String(fu.getParameter("detailid"));
String from = Util.null2String(fu.getParameter("from"));
String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));
String mobileSession = Util.null2String(fu.getParameter("mobileSession"));
String currentnodeid = Util.null2String(fu.getParameter("nodeid"));
String client = Util.null2String(fu.getParameter("client"));
String type = Util.null2String(fu.getParameter("type"));
String requestid = Util.null2String(fu.getParameter("requestid"));
String src = Util.null2String(fu.getParameter("src"));
String clientip = Util.null2String(fu.getParameter("clientip"));
String forwardresourceids = Util.null2String(fu.getParameter("forwardresourceids"));
String forwardresourceids2 = Util.null2String(fu.getParameter("forwardresourceids2"));
String forwardresourceids3 = Util.null2String(fu.getParameter("forwardresourceids3"));
String Intervenorremark = Util.null2String(fu.getParameter("Intervenorremark"));
String remark = Util.null2String(fu.getParameter("userSignRemark"));
String userid = Util.null2String(fu.getParameter("userid"));
String workflowid = Util.null2String(fu.getParameter("workflowid"));
String fromPage = Util.null2String(fu.getParameter("fromPage"));
String requestURI= Util.null2String(fu.getParameter("requestURI"));
int forwardflag = Util.getIntValue(fu.getParameter("forwardflag"),0);
String _rejectToNodeId = Util.null2String(fu.getParameter("rejectToNodeid"));
int rejectToType = 0 ;//退回类型
int rejectToNodeId = 0;
if(_rejectToNodeId.indexOf("_")!=-1){
	rejectToNodeId = Util.getIntValue(_rejectToNodeId.split("_")[0],0);
	rejectToType = Util.getIntValue(_rejectToNodeId.split("_")[1],1);
}else{
	rejectToNodeId = Util.getIntValue(_rejectToNodeId,0);
}
int SubmitToNodeid = Util.getIntValue(fu.getParameter("SubmitToNodeid"), 0);
int markId = Util.getIntValue(fu.getParameter("markId"), -1);
String remarkLocation = Util.null2String(fu.getParameter("remarkLocation"));
String method2 = fu.getParameter("method2");
String ismonitor = Util.null2String(fu.getParameter("ismonitor"));
int isurge = Util.getIntValue(fu.getParameter("isurge"),0);

//干预
String intervenorright=Util.null2String(fu.getParameter("intervenorright"));
String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));
String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));
String IntervenoridType=Util.null2String(fu.getParameter("IntervenoridType"));
int SignType = Util.getIntValue(fu.getParameter("SignType"),0);
int enableIntervenor = Util.getIntValue(fu.getParameter("enableIntervenor"),1);//是否启用节点及出口附加操作

int lastOperator = Util.getIntValue(fu.getParameter("lastOperator"), 0);
String lastOperateDate = Util.null2String(fu.getParameter("lastOperateDate"));
String lastOperateTime = Util.null2String(fu.getParameter("lastOperateTime"));		

//监控、督办群组

Map<String, Object> otherinfo = new HashMap<String, Object>();
otherinfo.put("ismonitor", ismonitor);
otherinfo.put("isurger", isurge);
otherinfo.put("module",module);
//干预
Map<String, String> otherinfo2 = new HashMap<String, String>();
otherinfo2.put("submitNodeId", submitNodeId);
otherinfo2.put("Intervenorid", Intervenorid);
otherinfo2.put("IntervenoridType", IntervenoridType);
otherinfo2.put("SignType", Util.null2String(SignType));
otherinfo2.put("enableIntervenor", Util.null2String(enableIntervenor));
otherinfo2.put("intervenorright", Util.null2String(intervenorright));

//获取当前版本
String clientVer = Util.null2String(fu.getParameter("clientver"));
String serverVer = Util.null2String(fu.getParameter("serverver"));
String formid="";
RecordSet.executeSql("select formid from workflow_base where id="+workflowid);
if(RecordSet.next()){
	formid=RecordSet.getString("formid");
}
String f_weaver_belongto_userid=Util.null2String(fu.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(fu.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
if(user == null)  return;
userid = user.getUID()+"";

//将签字意见中的换行内容替换成换行标签。



remark = remark.replaceAll("\r\n", "<br/>");

//根据客户端类型转换成数字常量。



String clientType = "";
if (clienttype.equalsIgnoreCase("ipad")) {
    clientType = "3";
} else if (clienttype.equalsIgnoreCase("iphone")){
   clientType = "2";
} else if (clienttype.equalsIgnoreCase("Webclient")){
   clientType = "1";
} else if (clienttype.equalsIgnoreCase("Android")){
   clientType = "4";
} else if (clienttype.equalsIgnoreCase("AndPad")){
   clientType = "5";
}

//判断当前客户端程序版本是否高于4.5
boolean flagClientVersion4_5 = RequestOperation.compareVersion(clientVer, RequestOperation.VERSION_45);
//判断当前Mobile程序版本是否高于4.5
boolean flagServerVersion4_5 = RequestOperation.compareVersion(serverVer, RequestOperation.VERSION_45);

int speechAttachment = 0;
int handWrittenSign = 0;
String isannexUpload = "";
if(flagServerVersion4_5){
	//获取语音附件
	String speechAppendix = Util.null2String(fu.getParameter("fieldSpeechAppend"));
	//如果不为空，则将其以附件形式上传。



	if(!"".equals(speechAppendix)){
	  speechAttachment = WorkflowSpeechAppend.uploadAppend(speechAppendix, WorkflowSpeechAppend.FMT_SPEECHATTACHMENT);
	}
	
	//获取手写签批数据
	String fieldHandWritten = Util.null2String(fu.getParameter("fieldHandWritten"));
	//如果不为空，则将其以附件形式上传。



	if(!"".equals(fieldHandWritten)){
	  handWrittenSign = WorkflowSpeechAppend.uploadAppend(fieldHandWritten, WorkflowSpeechAppend.FMT_HANDWRITTEN_SIGN);
	}
	
	//处理电子签章
	if(markId > 0){
	  remark+="<br/><br/><img alt='electricSignature' name='electricSignature' src=/weaver/weaver.file.SignatureDownLoad?markId=" + markId + ">";
	}
	
	int[] annexDocCategory = weaver.workflow.workflow.WorkflowComInfo.getAnnexDocCategory(workflowid);
	isannexUpload = weaver.mobile.plugin.ecology.RequestOperation.uploadSignatureAppends(fu, user, annexDocCategory);
}

if(remark.indexOf("'")!=-1){
   remark = remark.replace("\'","&#39;");
}
//读取配置项的值，对签字意见内容是否加上手机版上特有来源信息。


//int isShowTerminal = Util.getIntValue(fu.getParameter("_isShowTerminal_"), 1);
//qc 145589 处理设置签字意见配置项不能读取问题。


String isshowterminalstr = (String)application.getAttribute("emobile_config_isShowTerminal");
if (isshowterminalstr == null) {
    WorkflowServiceImpl wfsimpl = new WorkflowServiceImpl();
    isshowterminalstr = wfsimpl.getIsShowTerminal();
    application.setAttribute("emobile_config_isShowTerminal", isshowterminalstr);
}

BaseBean mobilewfprops=new BaseBean();
String mobileWFOffice= Util.null2String(mobilewfprops.getPropValue("MobileWFOfficeSign","mobileWFOffice"));


if ("1".equals(isshowterminalstr)) {
	if(clienttype.equalsIgnoreCase("Webclient")){
		//增加微信钉钉提交标记--QC150390
		String clienttype2 = Util.null2String(fu.getParameter("clienttype2"));
		if(!"".equals(clienttype2)) remark += ("<br/><br/><span style='font-size:11px;color:#666;'>"+SystemEnv.getHtmlLabelName(31505, user.getLanguage())+clienttype2+"</span>");
		else remark += ("<br/><br/><span style='font-size:11px;color:#666;'>"+SystemEnv.getHtmlLabelName(31505, user.getLanguage())+"Web"+SystemEnv.getHtmlLabelName(31506, user.getLanguage())+"</span>");
	}else{
		remark += ("<br/><br/><span style='font-size:11px;color:#666;'>"+SystemEnv.getHtmlLabelName(31505, user.getLanguage()) + clienttype +SystemEnv.getHtmlLabelName(108, user.getLanguage()) +"</span>");
	}
}else {
	remark += "<br/>";
}

WorkflowRequestInfo workflowRequestInfo = null;
WorkflowService wfs = new WorkflowServiceImpl();
String wfReqInfoKey = "";
String sessionkey = Util.null2String((String)request.getParameter("sessionkey"));
if("create".equals(method2)){
  	wfReqInfoKey = sessionkey + "_"+ workflowid + "_"+ user.getUID();
} else {
	//workflowRequestInfo = wfs.getWorkflowRequest4split(Util.getIntValue(requestid, 0), user.getUID(), 0, 10000); 
	wfReqInfoKey = sessionkey + "_" + workflowid + "_" + requestid + "_"+ userid;
}



//从缓存中获取流程表单基础数据
StaticObj staticObj = StaticObj.getInstance();
synchronized(staticObj){
	Map mapWfReqInfos = (Map)staticObj.getObject("MOBILE_WORKFLOWREQUESTINFO_CACHE");
	if (mapWfReqInfos != null) {
		workflowRequestInfo = (WorkflowRequestInfo)mapWfReqInfos.get(wfReqInfoKey);
		mapWfReqInfos.remove(wfReqInfoKey);
	
		//当缓存中的项大于10000时，自动清除缓存
		if (mapWfReqInfos.entrySet().size() >= 1000) {
			mapWfReqInfos.clear();
			//System.err.println("wipe mobile catche!");
		} 
	}
	
	if (workflowRequestInfo == null) {
	    //创建时，如果sessionkey发生变化，缓存对象无法获取，则从数据库中重新查询对象
	    if (Util.getIntValue(requestid, 0) <= 0) {
	        workflowRequestInfo = wfs.getCreateWorkflowRequestInfo(Util.getIntValue(workflowid), user.getUID());
	    } else {
	        workflowRequestInfo = wfs.getWorkflowRequest4split(Util.getIntValue(requestid, 0), user.getUID(), 0, 10000, false, otherinfo);
	    }
		
		//System.err.println("failed to get the object from the cache!");
	} else {
		//System.err.println("success derives from the cache object!");
	}
}



int[] docCategory = WorkflowSpeechAppend.getDocCategory(workflowid, fu);
workflowRequestInfo = weaver.mobile.plugin.ecology.RequestOperation.getWorkflowRequestInfoFromRequest(fu, workflowRequestInfo, user, docCategory);
workflowRequestInfo.setRejectToNodeid(rejectToNodeId);
workflowRequestInfo.setRejcetToType(rejectToType);
workflowRequestInfo.setSubmitToNodeid(SubmitToNodeid);

boolean fnaMobileErrorFlag = false;
String fnaMobileErrorMsg = "";
String result = "";
workflowRequestInfo.setSpeechAttachment(speechAttachment);
workflowRequestInfo.setHandWrittenSign(handWrittenSign);
workflowRequestInfo.setSignatureAppendfix(isannexUpload);
workflowRequestInfo.setRemarkLocation(remarkLocation);
workflowRequestInfo.setLanguageid(user.getLanguage());

String responseUrl = "/mobile/plugin/1/view.jsp";
if("client.jsp".equals(fromPage)){ 
    responseUrl =  "/mobile/plugin/1/client.jsp"; 
}

//流程已流转到下一节点，不可再提交
//if(StringUtils.isBlank(result)){
if("submit".equals(src)||"subnoback".equals(src)||"subback".equals(src)||"supervise".equals(src) ||"intervenor".equals(src) ){

    if(!"create".equals(method2)){
	    if(!src.equals("supervise")&&!src.equals("intervenor")){
		    int isremark = workflowRequestInfo.getIsremark();
		    if(isremark!=1&&isremark!=9){
		   	   RecordSet.executeSql("select 1 from workflow_currentoperator where isremark not in('2','4') and (takisremark<>-2 or takisremark is null) and requestid="+requestid+" and userid="+userid+" and nodeid="+workflowRequestInfo.getNodeId());
		       if(RecordSet.getCounts()<1){
		           workflowRequestInfo.setMessageid(WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_02); //已经流转到下一节点，不可以再提交
		           responseUrl += "?detailid="+requestid+"&messageid="+workflowRequestInfo.getMessageid()+"&clienttype="+clienttype+"&module=8&scope=373";
		           request.getRequestDispatcher(responseUrl).forward(request,response);
		           return;
		       }
	    	}
	    }
	}
	
    String message = RequestSaveCheckManager.getReturnMessage(lastOperator,lastOperateDate,lastOperateTime,Util.getIntValue(workflowid),Util.getIntValue(workflowRequestInfo.getCurrentNodeId(),-1),Util.getIntValue(userid),Util.getIntValue(requestid));
    if(StringUtils.isNotEmpty(message)){
		workflowRequestInfo.setMessageid(message);
		result = "failed";
    }else{
		//由用户选择操作者，异常处理信息封装workflowRequestInfo
		String eh_setoperator = Util.null2String(fu.getParameter("eh_setoperator"));
		if("n".equals(eh_setoperator)){			//异常处理窗口未选择操作者，以提交失败处理
	
			if("y".equals(Util.null2String(fu.getParameter("eh_fromcreate")))){
				//创建节点异常选人，不选择时需删除流程信息
				//new WorkFlowInit().DeleteByid(Util.getIntValue(requestid));
			}
			workflowRequestInfo.setMessageid(WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_07);
			JSONObject msgjson = new JSONObject();
			msgjson.put("resetoperator","y");
			workflowRequestInfo.setMessagecontent(msgjson.toString());	
			result = "failed";
		}else{
			if("y".equals(eh_setoperator)){		//异常处理选择了操作者，拼装操作者信息
	
				Map<String,Object> eh_operatorMap = new HashMap<String,Object>();
				eh_operatorMap.put("eh_setoperator", eh_setoperator);
				eh_operatorMap.put("eh_relationship", Util.null2String(fu.getParameter("eh_relationship")));
				eh_operatorMap.put("eh_operators", Util.null2String(fu.getParameter("eh_operators")));
				workflowRequestInfo.setEh_operatorMap(eh_operatorMap);
			}
			if("create".equals(method2)){
				//是否是自由流程
	
				String nodeId = workflowRequestInfo.getCurrentNodeId();
				weaver.workflow.workflow.WFManager wfm = new weaver.workflow.workflow.WFManager();
		        wfm.setWfid(Util.getIntValue(workflowid));
		        wfm.getWfInfo();
		    	String isFree = wfm.getIsFree();
				boolean IsFreeWorkflow = false;
				if(isFree.equals("1")){
					IsFreeWorkflow = true;
				}
				
				boolean iscreatenode = false;
				String nodetypesql="select nodetype from workflow_flownode where nodeid="+nodeId;
				RecordSet.executeSql(nodetypesql);
		        while(RecordSet.next()){
		        	String nodetype=RecordSet.getString("nodetype");
		        	if("0".equals(nodetype)){
		        		iscreatenode = true;
		        	}
		        }
				if(IsFreeWorkflow && iscreatenode){
					Map<String, String> params = new HashMap<String, String>();  
			    	try{
			    		Enumeration<String> paramNames = fu.getParameterNames();  
				        while( paramNames.hasMoreElements() ) {  
				        	String paramName = paramNames.nextElement();  
				        	String[] paramValues = fu.getParameterValues(paramName);  
				        	if (paramValues.length >= 1) {  
				        		String paramValue = paramValues[0];  
				        		if (paramValue.length() != 0) {  
				        			params.put(paramName, paramValue);  
				        		}  
				        	} 
				        }
			    	}catch(Exception e){
			    	}
					result = wfs.doCreateWorkflowRequest(workflowRequestInfo, user.getUID(), remark, clientType,src,params);
				}else{
				////////////////
				
					result = wfs.doCreateWorkflowRequest(workflowRequestInfo, user.getUID(), remark, clientType,src);
				}
				
				if(formid.equals("85")){
					String meetingid=MeetingWFUtil.updateWF2Meeting(""+result,""+formid,"",user.getUID());
					RecordSet.execute("update meeting set requestid="+result+" where id="+meetingid);
					//只有草稿状态才更新成待审批
					 
					RecordSet.execute("SELECT currentnodetype from workflow_requestbase where requestid="+result);
					if(RecordSet.next()){
						if("3".equals(RecordSet.getString("currentnodetype"))){ //归档
							//设置会议正常,创建日程或者形成周期会议
	
							RecordSet.execute("select id,meetingstatus from meeting where id="+meetingid);
							if(RecordSet.next()){
								if("1".equals(RecordSet.getString("meetingstatus"))||"0".equals(RecordSet.getString("meetingstatus"))){//当前会议是待审批或者草稿(流程穿透)
									MeetingWFUtil.setMeetingNormal(meetingid);
								}
							}
						}else{
							RecordSet.execute("update meeting set meetingstatus=1 where id="+meetingid);
						}
					}
				}
			} else {
				//是否是自由流程
	
				String nodeId = workflowRequestInfo.getCurrentNodeId();
				weaver.workflow.workflow.WFManager wfm = new weaver.workflow.workflow.WFManager();
		        wfm.setWfid(Util.getIntValue(workflowid));
		        wfm.getWfInfo();
		    	String isFree = wfm.getIsFree();
				boolean IsFreeWorkflow = false;
				if(isFree.equals("1")){
					IsFreeWorkflow = true;
				}
				
				boolean iscreatenode = false;
				String nodetypesql="select nodetype from workflow_flownode where nodeid="+nodeId;
				RecordSet.executeSql(nodetypesql);
		        while(RecordSet.next()){
		        	String nodetype=RecordSet.getString("nodetype");
		        	if("0".equals(nodetype)){
		        		iscreatenode = true;
		        	}
		        }
		        if(IsFreeWorkflow && iscreatenode){
					Map<String, String> params = new HashMap<String, String>();  
			    	try{
			    		Enumeration<String> paramNames = fu.getParameterNames();  
				        while( paramNames.hasMoreElements() ) {  
				        	String paramName = paramNames.nextElement();  
				        	String[] paramValues = fu.getParameterValues(paramName);  
				        	if (paramValues.length >= 1) {  
				        		String paramValue = paramValues[0];  
				        		if (paramValue.length() != 0) {  
				        			params.put(paramName, paramValue);  
				        		}  
				        	} 
				        }
			    	}catch(Exception e){
			    	}
					//result = wfs.doCreateWorkflowRequest(workflowRequestInfo, user.getUID(), remark, clientType,src,params);
					result = wfs.submitWorkflowRequest(workflowRequestInfo, Util.getIntValue(requestid), user.getUID(), src, remark, clientType,params);
				}else{
					if("intervenor".equals(src)){
					result = wfs.submitWorkflowRequest(workflowRequestInfo, Util.getIntValue(requestid), user.getUID(), src, remark, clientType, otherinfo2);
					}else{
					result = wfs.submitWorkflowRequest(workflowRequestInfo, Util.getIntValue(requestid), user.getUID(), src, remark, clientType);
					}
				}
			}
			
			if(result.indexOf("FnaMobileErrorMsg") > -1){		//
				fnaMobileErrorFlag = true;
				
				int req_requestid = -1;
				if("create".equals(method2))
					req_requestid = Util.getIntValue(result.substring(result.indexOf("_")+1));
				else
					req_requestid = Util.getIntValue(requestid);
				
				int fcsemId = 0;
				String sql = "select id,msg from FnaMobileErrorMsg where userid = " + user.getUID() + " and requestid = " + req_requestid;
				RecordSet.executeSql(sql);
				if(RecordSet.next()){
					fcsemId = RecordSet.getInt("id");
					fnaMobileErrorMsg = Util.null2String(RecordSet.getString("msg"));
				}
				
				//RecordSet.executeSql("delete FnaMobileErrorMsg where id = " + fcsemId);
			}
			
			if(result.indexOf("needChooseOperator") > -1){		//异常处理，由用户选择操作者
	
				int req_requestid = -1;
				if("create".equals(method2))
					req_requestid = Util.getIntValue(result.substring(result.indexOf(",")+1));
				else
					req_requestid = Util.getIntValue(requestid);
				
				String forwardUrl = "/mobile/plugin/1/view.jsp";
				if("client.jsp".equals(fromPage))
					forwardUrl = "/mobile/plugin/1/client.jsp";
				forwardUrl += "?method=&detailid="+req_requestid+"&needChooseOperator=y";
				forwardUrl += "&eh_fromcreate="+("create".equals(method2)?"y":"n");
				forwardUrl += "&clienttype="+clienttype;
				//System.err.println("forwardUrl=="+forwardUrl);
				//out.println("<script>");
		    	//out.println("window.location.href='"+forwardUrl+"';");
		    	//out.println("</script>");
		    	request.getRequestDispatcher(forwardUrl).forward(request, response);
		    	return;
			}
		}
	}
}else if("save".equals(src)){
    result = wfs.saveWorkflowRequest(workflowRequestInfo, Util.getIntValue(requestid), user.getUID(), src, remark, clientType);
} else if("reject".equals(src)){
	result = wfs.submitWorkflowRequest(workflowRequestInfo, Util.getIntValue(requestid), user.getUID(), src, remark, clientType);
} else if("forward".equals(src) && forwardflag == 1 ){
	String[] forwardids = StringUtils.split(forwardresourceids,","); 
	String forwardidvalue = "";
	for(int p=0;forwardids!=null&&forwardids.length>0&&p<forwardids.length;p++){
		String value = forwardids[p];
		if(StringUtils.isNotEmpty(value)){
			forwardidvalue+=","+value;
		}
	}
	forwardidvalue = forwardidvalue.startsWith(",")?forwardidvalue.substring(1):forwardidvalue;
	if(clientip==null||"".equals(clientip)){
		String regex = "(((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))";
        Pattern p = Pattern.compile(regex);
		clientip = StringUtils.defaultIfEmpty(request.getHeader("X-Forwarded-For"),"");
        Matcher m = p.matcher(clientip);
        if (clientip == null || "".equals(clientip) || !m.matches()) {
        	clientip = request.getRemoteAddr();
        }
	}
	result = wfs.forwardWorkflowRequest(Util.getIntValue(requestid), forwardidvalue, remark, user.getUID(), clientip, clientType, handWrittenSign, speechAttachment, isannexUpload,remarkLocation,module);

} else if("forward".equals(src) && forwardflag == 2 ){
	String[] forwardids = StringUtils.split(forwardresourceids2,","); 
	String forwardidvalue = "";
	for(int p=0;forwardids!=null&&forwardids.length>0&&p<forwardids.length;p++){
		String value = forwardids[p];
		if(StringUtils.isNotEmpty(value)){
			forwardidvalue+=","+value;
		}
	}
	forwardidvalue = forwardidvalue.startsWith(",")?forwardidvalue.substring(1):forwardidvalue;
	if(clientip==null||"".equals(clientip)){
		String regex = "(((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))";
        Pattern p = Pattern.compile(regex);
		clientip = StringUtils.defaultIfEmpty(request.getHeader("X-Forwarded-For"),"");
        Matcher m = p.matcher(clientip);
        if (clientip == null || "".equals(clientip) || !m.matches()) {
        	clientip = request.getRemoteAddr();
        }
	}
	
	result = wfs.forwardWorkflowRequest(Util.getIntValue(requestid), forwardidvalue, remark, user.getUID(), clientip, clientType, forwardflag, handWrittenSign, speechAttachment, isannexUpload,remarkLocation);
	
} else if("forward".equals(src) && forwardflag == 3 ){
	String[] forwardids = StringUtils.split(forwardresourceids3,","); 
	String forwardidvalue = "";
	for(int p=0;forwardids!=null&&forwardids.length>0&&p<forwardids.length;p++){
		String value = forwardids[p];
		if(StringUtils.isNotEmpty(value)){
			forwardidvalue+=","+value;
		}
	}
	forwardidvalue = forwardidvalue.startsWith(",")?forwardidvalue.substring(1):forwardidvalue;
	if(clientip==null||"".equals(clientip)){
		String regex = "(((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))";
        Pattern p = Pattern.compile(regex);
		clientip = StringUtils.defaultIfEmpty(request.getHeader("X-Forwarded-For"),"");
        Matcher m = p.matcher(clientip);
        if (clientip == null || "".equals(clientip) || !m.matches()) {
        	clientip = request.getRemoteAddr();
        }
	}
	
	result = wfs.forwardWorkflowRequest(Util.getIntValue(requestid), forwardidvalue, remark, user.getUID(), clientip, clientType, forwardflag, handWrittenSign, speechAttachment, isannexUpload, remarkLocation);
	
}
boolean flagResult = (Util.getIntValue(result, 0)>0 || "success".equals(result));
if(!flagResult){
    session.setAttribute("msgcontent_"+userid+"_"+workflowRequestInfo.getRequestId(),workflowRequestInfo.getMessagecontent());
    responseUrl += "?detailid="+workflowRequestInfo.getRequestId()+"&messageid="+workflowRequestInfo.getMessageid()+"&clienttype="+clienttype; 
    request.getRequestDispatcher(responseUrl).forward(request,response);
}else{
	RecordSet.executeSql("select wftype from cpt_cptwfconf where wfid="+workflowid);
	if(RecordSet.next()){
		String cptwftype=Util.null2String(RecordSet.getString("wftype"));
		if (!"".equals(cptwftype) && !"apply".equalsIgnoreCase(cptwftype)) {
			RecordSet.executeSql("update CptCapital set frozennum = 0 where isdata='2' ");
		}else if ("19".equals(formid)||"201".equals(formid)||"220".equals(formid)||"221".equals(formid)) {
			RecordSet.executeSql("update CptCapital set frozennum = 0 where isdata='2' ");
		}
	}
if((!"1".equals(mobileWFOffice)&&"client.jsp".equals(fromPage))
	||("1".equals(mobileWFOffice)&&"client.jsp".equals(fromPage)&&!"save".equals(src)||("create".equals(method2)&&"client.jsp".equals(fromPage)))){%>
<script type="text/javascript">
		function submitResult(){		
			var url = "<%=flagResult%>" + ":" + "<%=result%>:<%=user.getUID() %>";	
			<%
				if(fnaMobileErrorFlag){
			%>
				alert("<%=fnaMobileErrorMsg.replace("<br>","")%>");
			<%
				}
			%>
			return url;
		}	    
</script>
<% }else{%>
<html><head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
</head>
<body style="margin:0;padding:0;">

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width:100%;height:40px;font-size:13px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title"><%=workflowRequestInfo.getWorkflowBaseInfo().getWorkflowName() %></div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
					<a href="javascript:logout();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						退出



						</div>
					</a>
				</td>
			</tr>
		</table>
	</div>


	<div class="bodyContext" style="background:url(/images/news/viewBg_wev8.png) repeat;margin:0;width:100%;padding-top:20px;padding-bottom:20px;">
		<div style="margin:0 10px 10px 10px;">
			<div class="blockBody">
				<div style="margin:10px;">
				   <%if("1".equals(mobileWFOffice)&&!"create".equals(method2)){%>
				       <%if("save".equals(src)){%>
					     <script>
					        location = '<%=requestURI%>';
					     </script>
					  <%}else{%>
					      流程处理成功！
					   <%}%>
				   <%}else{%>
					  流程处理成功！
					<%}%>
				</div>
			</div>
		</div>
	</div>
	
	
</div>


<script type="text/javascript">	
	function goBack() {
		location = "/list.do?module=<%=module%>&scope=<%=scope%>";
	}
	
	function logout() {
		location = "/logout.do";
	}
</script>

</body>
</html> <% } }%>