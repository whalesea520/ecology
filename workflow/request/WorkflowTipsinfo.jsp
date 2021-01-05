
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="RequestManagerForTipsinfo" class="weaver.workflow.request.RequestManagerForTipsinfo" scope="page"/>

<%
    FileUpload fu = new FileUpload(request);
    String ismode = Util.null2String(fu.getParameter("ismode"));
    String divcontent = Util.null2String(fu.getParameter("divcontent"));
    String content = Util.null2String(fu.getParameter("content"));
	//回退到的节点id
	String RejectToNodeid = Util.null2String(fu.getParameter("RejectToNodeid")); 
    int requestid = weaver.general.Util.getIntValue(fu.getParameter("requestid"));
    int workflowid = weaver.general.Util.getIntValue(fu.getParameter("workflowid"));
    String src = weaver.general.Util.null2String(fu.getParameter("src"));
    int isreject = weaver.general.Util.getIntValue(fu.getParameter("isreject"),0);
    int nodeid = weaver.general.Util.getIntValue(fu.getParameter("nodeid"));
    int billid = weaver.general.Util.getIntValue(fu.getParameter("billid"));
    int formid = weaver.general.Util.getIntValue(fu.getParameter("formid"), -1);
    int isbill = weaver.general.Util.getIntValue(fu.getParameter("isbill"), -1);
    String calfields=weaver.general.Util.null2String(fu.getParameter("calfields"));
    java.util.ArrayList calfieldlist=weaver.general.Util.TokenizerString(calfields,",");
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
    //weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser(request, response);
    int userid=user.getUID();
    int usertype=weaver.general.Util.getIntValue(user.getLogintype(),1)-1;
    String returnvalue = "";
	boolean savestatus=true;
	String message="";
	String messageLabelName="";
    if(src.equals("reject")) isreject=1;
	
    if (weaver.general.GCONST.getWorkflowWayOut()) {
        weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
        int copnodeid = nodeid;
        int submitgroups = 0;
        int totalunsubmitgroups = 0;
        String billtablename = "";
        if (src.equals("submit")) {
            if (requestid > 0) {

				String iscreate = Util.null2String(fu.getParameter("iscreate"));
				String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
				int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
				String nodetype = Util.null2String(fu.getParameter("nodetype"));
				String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
				String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
				String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
				String isFromEditDocument = Util.null2String(fu.getParameter("isFromEditDocument"));
				String remark = Util.null2String(fu.getParameter("remark"));
				String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));
				String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));
				int SignType = Util.getIntValue(fu.getParameter("SignType"),0);
				int isovertime = Util.getIntValue(fu.getParameter("isovertime"),0);
				int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
				int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);

				String isintervenor=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"isintervenor"));

				boolean IsCanSubmit="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanSubmit"))?true:false;
				boolean coadCanSubmit="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"coadCanSubmit"))?true:false;
				boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
				String IsBeForwardPending=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"IsBeForwardPending"));
				String coadispending=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"coadispending"));
				String coadsigntype=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"coadsigntype"));
				int ispending=-1;
				if(isremark==7&&coadispending.equals("1")){
				    if(IsBeForwardPending.equals("1")){
				        ispending=2;
				    }else{
				        ispending=1;
				    }
				}else if(IsBeForwardPending.equals("1")){
				    ispending=0;
				}
				int wfcurrrid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"wfcurrrid"),0);

				String isMultiDoc = Util.null2String(fu.getParameter("isMultiDoc")); //多文档新建


				RequestManagerForTipsinfo.setIsMultiDoc(isMultiDoc) ;
				RequestManagerForTipsinfo.setSrc(src) ;
				RequestManagerForTipsinfo.setIscreate(iscreate) ;
				RequestManagerForTipsinfo.setRequestid(requestid) ;
				RequestManagerForTipsinfo.setWorkflowid(workflowid) ;
				RequestManagerForTipsinfo.setWorkflowtype(workflowtype) ;
				RequestManagerForTipsinfo.setIsremark(isremark) ;
				RequestManagerForTipsinfo.setFormid(formid) ;
				RequestManagerForTipsinfo.setIsbill(isbill) ;
				RequestManagerForTipsinfo.setBillid(billid) ;
				RequestManagerForTipsinfo.setNodeid(nodeid) ;
				RequestManagerForTipsinfo.setNodetype(nodetype) ;
				RequestManagerForTipsinfo.setRequestname(requestname) ;
				RequestManagerForTipsinfo.setRequestlevel(requestlevel) ;
				RequestManagerForTipsinfo.setRemark(remark) ;
				RequestManagerForTipsinfo.setRequest(fu) ;
				RequestManagerForTipsinfo.setSubmitNodeId(submitNodeId);
				RequestManagerForTipsinfo.setIntervenorid(Intervenorid);
				RequestManagerForTipsinfo.setSignType(SignType);
				RequestManagerForTipsinfo.setMessageType(messageType) ;
				RequestManagerForTipsinfo.setIsFromEditDocument(isFromEditDocument) ;
				RequestManagerForTipsinfo.setUser(user) ;
				RequestManagerForTipsinfo.setIsagentCreater(isagentCreater);
				RequestManagerForTipsinfo.setBeAgenter(beagenter);
				RequestManagerForTipsinfo.setIsPending(ispending);
				RequestManagerForTipsinfo.setRequestKey(wfcurrrid);
				RequestManagerForTipsinfo.setCanModify(IsCanModify);
				RequestManagerForTipsinfo.setCoadsigntype(coadsigntype);

				savestatus = RequestManagerForTipsinfo.saveRequestInfoForMaintableAndNoAnnex() ;
				message=Util.null2String(RequestManagerForTipsinfo.getMessage());

                if(!message.equals("")){
                	
                	
                	out.print("<script>	try{jQuery(window.parent.flowbody).attr(\"onbeforeunload\", \"\");}catch(e){}</script>");
					//out.print("<script>	try{window.parent.flowbody.onbeforeunload=null;}catch(e){}</script>");
					out.print("<script>window.parent.wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&message="+message+"&isintervenor="+isintervenor+"');</script>");
					return ;
				}

				if(message.equals("4")){
					messageLabelName=SystemEnv.getHtmlLabelName(21266,user.getLanguage());
				}else if(message.equals("5")){
					messageLabelName=SystemEnv.getHtmlLabelName(21270,user.getLanguage());
				}else if(message.equals("6")){
					messageLabelName=SystemEnv.getHtmlLabelName(21766,user.getLanguage());
				}else if(message.equals("7")){
					messageLabelName=SystemEnv.getHtmlLabelName(22751,user.getLanguage());
				}else if(message.equals("8")){
					messageLabelName=SystemEnv.getHtmlLabelName(24676,user.getLanguage());
				}


            }
            weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();
            weaver.conn.RecordSet rs3 = new weaver.conn.RecordSet();
            rs.executeSql("select count(distinct groupid) from workflow_currentoperator where isremark = '0' and requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype);
            if (rs.next()) {
                submitgroups = weaver.general.Util.getIntValue(rs.getString(1), 0);
            }
            // 如果是提交节点, 查询当前用户提交组数和总共的未提交组数
            rs.executeSql("select nodeid from workflow_currentoperator where isremark = '0' and requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype + "order by id desc");
            if (rs.next()) copnodeid = weaver.general.Util.getIntValue(rs.getString(1), 0);
            rs.executeSql("select count(distinct groupid) from workflow_currentoperator where isremark = '0' and requestid=" + requestid);
            if (rs.next()) totalunsubmitgroups = weaver.general.Util.getIntValue(rs.getString(1), 0);
            //判断该人所在组是否含有依次逐个递交的组，如果有一个，则passedgroups-1，并且进入得到下个操作者的方法
            rs.execute("select distinct groupdetailid,groupid from workflow_currentoperator where isremark = '0' and requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype);
            //System.out.println("select distinct groupdetailid,groupid from workflow_currentoperator where isremark = '0' and requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype);
            while (rs.next()) {
                rs2.execute("select * from workflow_groupdetail where id=" + rs.getInt("groupdetailid"));
                if (rs2.next()) {
                    int type = rs2.getInt("type");
                    int signorder = rs2.getInt("signorder");
                    if (type == 5 && signorder == 2) {    //判断是否还有剩余节点
                        rs3.execute("select * from workflow_agentpersons where requestid=" + requestid + " and (groupdetailid=" + rs.getInt("groupdetailid") + " or groupdetailid is null)");
                        if (rs3.next() && !rs3.getString("receivedPersons").equals("")) {
                            submitgroups--;
                        }
                    }

                }
            }
        }
        //System.out.println(src + "|" + submitgroups + "|" + totalunsubmitgroups + "|" + copnodeid + "|" + nodeid);
        if ((src.equals("submit") && submitgroups >= totalunsubmitgroups && copnodeid == nodeid) || src.equals("reject")) {
            weaver.workflow.request.WorkflowFlowInfo wfi = new weaver.workflow.request.WorkflowFlowInfo();
            java.util.ArrayList linkids = wfi.getNextNode(requestid, nodeid, userid, usertype, isreject, billid);
            for (int i = 0; i < linkids.size(); i++) {
                String viewNodeIdSQL = "select tipsinfo from workflow_nodelink where id=" + linkids.get(i);
				if(!"".equals(RejectToNodeid)){
					viewNodeIdSQL+=" and  destnodeid="+RejectToNodeid ;
				} 
                rs.executeSql(viewNodeIdSQL);
                if (rs.next()) {
                    if (returnvalue.equals("")) returnvalue = weaver.general.Util.null2String(rs.getString("tipsinfo"));
                    else returnvalue += "\\n" + weaver.general.Util.null2String(rs.getString("tipsinfo"));
                }
            }
        }
    }
    //response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    //out.print(returnvalue);
%>
<script language="javascript">
window.parent.showtipsinfoReturn("<%=returnvalue%>","<%=src%>","<%=ismode%>","<%=divcontent%>","<%=content%>","<%=messageLabelName%>");
</script>