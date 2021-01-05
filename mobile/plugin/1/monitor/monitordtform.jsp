
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="weaver.docs.docs.DocManager" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%@ page import="weaver.mobile.webservices.workflow.*" %>
<%@ page import="weaver.crm.Maint.CustomerInfoComInfo" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingSetInfo2" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page" />
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />


 <style type="text/css">
.requestinfo_making{
 display:none;
 }
.pageMasking{
	width:100%; height:100%; top:0px; left:0px;
	position:absolute; z-index:99; background-color:rgb(51, 51, 51); opacity:0.2;
}
.showInfoWin{
	width:80%; top:50px; left:8px; position:absolute; z-index:999;
	-webkit-user-select:none; onselectstart:none;<!--禁止页面选中 -->
}
.showWin_masking{
	width:95%; position:absolute; z-index:9999; background-color:rgb(51, 51, 51); opacity:0.2;
	display:none; text-align:center; font-size:16px; color:#eeefff;
}
.winHead{
	height:40px; line-height:40px; color:#ffffff;
	background:#017bfd; border-top-left-radius:8px; border-top-right-radius:8px;
}
.winHead_title{
	width:70%; float:left; padding-left:12px; font-size:16px;
}
.winHead_close{
	width:32px; float:right; font-size:18px; font-weight:bold; cursor:pointer;
}
.winContentInfo{
	background:#edefef;
	border-bottom:#bdc2c7 solid 1px;
}
.operatorArea{
	width:100%; font-size:16px; color:#848484; padding-top:2px;
}
.operatorArea .oper_title{
	float:left; width:300px; height:32px; line-height:32px; padding-left:12px; 
}
.operatorArea .oper_info{
	float:right; height:32px; line-height:32px;
}
.operatorArea .oper_choose{
	float:right; padding:4px 12px 0px 12px; cursor:pointer;
}
.operatorArea .oper_add{
	clear:both; height:62px ; padding-left:14px;
}
.operatorArea .oper_show{
	clear:both; height:62px ; padding-left:14px;
}


.operatorArea .Interval_add{
	clear:both; height:62px; padding-left:14px;
}

.operatorArea .Intervalcar_add{
	clear:both; height:62px; padding-left:14px;
}


.operatorArea .oper_add_img{
	cursor:pointer; margin-top:4px;
}

.operatorArea .singleUser{
	float:left; width:56px; text-align:center; font-size:12px;
}
.operatorArea .userHead{
	width:36px; height:36px; border-radius:18px; margin-top:4px; margin-bottom:2px; 
}
.operatorArea .userName{
	white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
}

.operatorArea .userHead{
	width:36px; height:36px; border-radius:18px; margin-top:4px; margin-bottom:2px; 
}
.submitNodeId{
   height:42px; padding-left:14px;
}


.relationTitle{
	height:32px; line-height:32px; padding-left:12px; font-size:16px; color:#848484;
}
.singleRelation{
	height:52px; padding-left:14px;
}
.showInfo{
	float:left; padding-top:4px; padding-bottom:2px;
}
.showInfo .showInfo_top{
	height:24px; line-height:24px; font-size:14px; color:#3f3f3f;
}
.showInfo .showInfo_bottom{
	height:22px; line-height:22px; font-size:12px; color:#afafaf;
}
.checkMark{
	float:right; margin:12px 6px 4px 4px;
}
.btnArea{
	height:40px; width:100%; margin-top:16px;
}
.btnDiv{
	width:200px; margin-left:auto; margin-right:auto;
}
.operBtn{
	width:70px; height:30px; line-height:30px; text-align:center; float:left;
	border-radius:5px; margin-left:15px; margin-right:15px; cursor:pointer; font-size:14px; color:#ffffff;
}
.pageIntervaling{

}

.nodeArea{
	width:100%; font-size:16px; color:#848484; padding-top:2px; height:50px;
}

.nodeArea .node_title{
	float:left; width:300px; height:32px; line-height:32px; padding-left:12px; 
}
.nodeArea .node_info{
	float:right; height:32px; line-height:32px;
}
.nodeArea .node_choose{
	float:right; padding:4px 12px 0px 12px; cursor:pointer;
}

.node_making{
	display:none; 
}

.node_showWin{
	background:#f1f6f7;
}


.node_showWin .chooseNodeId{
	height:24px; line-height:24px; font-size:14px; color:#3f3f3f;
}


.nodeMark{
	float:right; 
}

 .showWin_nodetitle{
	height:32px; line-height:32px; padding-left:12px; font-size:16px; color:#848484;
}
#unoperator_n{
    min-width:100px;
}
#unoperator_v{
    word-wrap: break-word;
    width:auto;
}

.borderbottom1{border-bottom:1px solid #dee1e1;}
.splitLineinfo{background:red; height:1px!important;width:100% }
.bgcolor1{background:#ffffff;}
.bgcolor2{background:#017bfd;}
.bgcolor3{background:#aebdc9;}

.wfinfo_left{
    text-align:left !important;
    color:#8b9196;
    font-size:14px;
    line-height:25px;
    padding-left:21px;
    padding-top:14px;
    vertical-align:top;
}
.wfinfo_right{
    text-align:left !important;
    text-align:left !important;
    color:#545b63;
    font-size:14px;
    line-height:25px;
    padding-top:11px;
}
</style>

<%

int userLanguage = Util.getIntValue(request.getParameter("userLanguage"),7);
%>
<div class="requestinfo_making">
<%-- 
<div class="blockHead">
				<span class="m-l-14"><%=SystemEnv.getHtmlLabelName(32210, userLanguage)%></span>
		</div>
--%>

<div class="winContentInfo">
   <table id="head" >

   <tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="requestID_n" id="requestID_n">  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="requestID_v" id="requestID_v" width="50%"> 	
			</div>
		</td>
	</tr>
	<tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="requestname_n" id="requestname_n" >  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="requestname_v" id="requestname_v" width="50%"> 	
			</div>
		</td>
	</tr>

	<tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="workflowname_n" id="workflowname_n" >  </div>
		</td>
			<td width="50% !important" class="wfinfo_right">
			<div name="workflowname_v"  id="workflowname_v" width="50%"> 	
			</div>
		</td>
	</tr>

	<tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="creater_n" id="creater_n" >  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="creater_v" id="creater_v" width="50%"> 	
			</div>
		</td>
	</tr>

	<tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="createtime_n"  id="createtime_n" >  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="createtime_v" id="createtime_v" width="50%"> 	
			</div>
		</td>
	</tr>
	<tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="nodename_n" id="nodename_n" >  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="nodename_v" id="nodename_v" width="50%"> 	
			</div>
		</td>
	</tr>
	<tr>
	   <td width="40% !important" class="wfinfo_left">
			 <div name="nodesta_n" id="nodesta_n" >  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="nodesta_v" id="nodesta_v" width="50%"> 	
			</div>
		</td>
	</tr>
		<tr>
		<td width="40% !important" class="wfinfo_left">
			 <div name="unoperator_n" id="unoperator_n" >  </div>
		</td>
		<td width="50% !important" class="wfinfo_right">
			<div name="unoperator_v" id="unoperator_v"  width="50%"> 	
			</div>
		</td>
	</tr>
	<tr class="Spacing" style="height:22px!important;"><td colspan="6" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>

	  </table>
	
</div>
</div>

    <%
    int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
    String username = "";
    //WorkflowService workflowWebService = new WorkflowServiceImpl();
    //List workflowRequestInfos = workflowWebService.getMonitoRequesttabList(requestid);



    //未操作者计数
    int i =0;
    //for(Iterator iter = workflowRequestInfos.iterator();iter.hasNext();){ 

    //Map map =(Map)iter.next(); 
    //Set keySet = map.keySet(); 
	//Iterator it = keySet.iterator(); 
    //while(it.hasNext()){ 
    //String fieldname =(String)it.next(); 
    //Object fieldname_value =map.get(fieldname);//通过键获取值 
    //String fieldvalue = fieldname_value.toString(); 
    RecordSet rs = new RecordSet();
    RecordSet rs2 = new RecordSet();
    //Map<String, String> map = new HashMap<String, String>();
    //Map<String, String> map2 = new HashMap<String, String>();
    String select = " select distinct ";
    
    //String fields = " t1.requestid,t1.requestname,t3.workflowname,t1.creater,t1.createtime,t1.currentnodeid,t4.nodename,t2.userid ";
    String fields = " t1.status,t1.requestid,t1.requestname,t3.workflowname,t1.creater,t1.createtime,t1.currentnodeid,t4.nodename,t2.userid ";
    String from = " from workflow_requestbase t1,workflow_currentoperator t2,workflow_base t3,workflow_nodebase t4 ";
    String where = "where t1.requestid = t2.requestid and t1.workflowid = t3.id and t4.id = t1.currentnodeid ";
    where += "and  t1.requestid =  " + requestid;
    //String where2 = "and  t2.isremark not in ('2','4') ";
    
    //修改暂停后未操作者依然可以显示的问题
    //String where2 = "and  (t2.isremark not in ('2','4') or (t2.isremark='4' and t2.viewtype=0)) ";
    String where2 = "and  (t2.isremark in ('0','1','5','7','8','9') or (t2.isremark='4' and t2.viewtype=0)) ";
    String sql2 = select + fields +from +where + where2 ;
    String sql = select + fields +from +where ;
    //List wris = new ArrayList();
    rs.execute(sql);

    ResourceComInfo rc = null;
    CustomerInfoComInfo cci = null;
     try {
         rc = new ResourceComInfo();
         cci = new CustomerInfoComInfo();
     } catch (Exception e) {
         e.printStackTrace();
     }
     
    if(rs.next()){
        
	    String requestID = rs.getString("requestid");
	    String requestname = rs.getString("requestname");
	    String workflowname = rs.getString("workflowname");
	    String creater = rs.getString("creater");
	    String creatername = "";
	
	    String createtime = rs.getString("createtime");
	    String currentnodeid = rs.getString("currentnodeid");
	    String nodename = rs.getString("nodename");
	
	    String status = rs.getString("status");
	    //String userid = rs.getString("userid");
	    //rs2.execute("select lastname from hrmresource where id =" +creater);
	    //if(rs2.next()){
	    //    creatername = rs2.getString("lastname");
	    //}
	    creatername = rc.getResourcename(creater);

	    %>
	    <SCRIPT LANGUAGE="JavaScript">
	    // 流程ID
	    jQuery("#requestID_n").html("<%=SystemEnv.getHtmlLabelName(84729, userLanguage)%>");
	    jQuery("#requestID_v").html("<%=requestID%>");
	    // 流程标题
	    jQuery("#requestname_n").html("<%=SystemEnv.getHtmlLabelName(26876, userLanguage)%>");
	    jQuery("#requestname_v").html('<%=requestname%>');
	    // 所属路径
	    jQuery("#workflowname_n").html('<%=SystemEnv.getHtmlLabelName(125749, userLanguage)%>');
	    jQuery("#workflowname_v").html('<%=workflowname%>');
	    // 创建人
	    jQuery("#creater_n").html('<%=SystemEnv.getHtmlLabelName(125357, userLanguage)%>');
	    jQuery("#creater_v").html('<%=creatername%>');
	    // 创建时间
	    jQuery("#createtime_n").html('<%=SystemEnv.getHtmlLabelName(30436, userLanguage)%>');
	    jQuery("#createtime_v").html('<%=createtime%>');
	    //当前节点
	    jQuery("#nodename_n").html('<%=SystemEnv.getHtmlLabelName(18564, userLanguage)%>');
	    jQuery("#nodename_v").html('<%=nodename%>');
	    //当前状况
	    jQuery("#nodesta_n").html('<%=SystemEnv.getHtmlLabelName(1335, userLanguage)%>');
	    jQuery("#nodesta_v").html('<%=status%>');
	    
	    </SCRIPT>
	    <%
    }
    //wris.add(map);
    rs.execute(sql2);

    if(rs.next()){
        String returnStr = "";
        //String userid = rs.getString("userid"); 
        rs.executeSql("select distinct userid,usertype,agenttype,agentorbyagentid from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0))  and requestid = " + requestid);
        %>
        
        <SCRIPT LANGUAGE="JavaScript">
        <%
        while(rs.next()){
            if(rs.getInt("usertype")==0){
                if(rs.getInt("agenttype")==2)
                    returnStr =  rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
                else
                    returnStr =  rc.getResourcename(rs.getString("userid"));
            }else{
                returnStr =  cci.getCustomerInfoname(rs.getString("userid"));
            }
            if (i > 0) username += ", ";
            username += returnStr;
            i++;
        }
        %>
        //当前未操作者
	    jQuery("#unoperator_n").html('<%=SystemEnv.getHtmlLabelName(18565, userLanguage)%>');
	    jQuery("#unoperator_v").html('<a href="javascript:void(0)" onclick="show()"><%=i + SystemEnv.getHtmlLabelName(84097, userLanguage)%></a>');
        </SCRIPT>
        <%
    }else{
        %>
        
        <SCRIPT LANGUAGE="JavaScript">
        jQuery("#unoperator_n").parent().parent().remove();
        </SCRIPT>
        <%
    }
	%>


		
    <%--
	<%if("流程ID".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	//alert("----fieldvalue----"+<%=fieldvalue%>);
		//	 alert(jQuery("#requestID_v"));
	jQuery("#requestID_n").html("<%=fieldname%>");
	jQuery("#requestID_v").html("<%=fieldvalue%>");
	//alert("----fieldvalue----"+jQuery("#requestID_v").html());
	</script>
	 <%}%>
	 	<%if("流程标题".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	//alert("----fieldvalue----"+<%=fieldvalue%>);
	jQuery("#requestname_n").html("<%=fieldname%>");
	jQuery("#requestname_v").html('<%=fieldvalue%>');
	</script>
	 <%}%>
	 	<%if("所属路径".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	//alert("----fieldvalue----"+<%=fieldvalue%>);
	jQuery("#workflowname_n").html('<%=fieldname%>');
	jQuery("#workflowname_v").html('<%=fieldvalue%>');
	</script>
	 <%}%>
	 	<%if("创建人".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	//alert("----fieldvalue----"+<%=fieldvalue%>);
	jQuery("#creater_n").html('<%=fieldname%>');
	jQuery("#creater_v").html('<%=fieldvalue%>');
	</script>
	 <%}%>
	 	<%if("创建时间".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	//alert("----fieldvalue----"+<%=fieldvalue%>);
	jQuery("#createtime_n").html('<%=fieldname%>');
	jQuery("#createtime_v").html('<%=fieldvalue%>');
	</script>
	 <%}%>
	 	<%if("当前节点".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	jQuery("#nodename_n").html('<%=fieldname%>');
	jQuery("#nodename_v").html('<%=fieldvalue%>');
	</script>
	 <%}%>
	  	<%if("当前状况".equals(fieldname)){%>
	<SCRIPT LANGUAGE="JavaScript">
	jQuery("#nodesta_n").html('<%=fieldname%>');
	jQuery("#nodesta_v").html('<%=fieldvalue%>');
	</script>
	 <%}%>
	  	<%if("当前未操作人".equals(fieldname)){
		
		if(!"".equals(username)){
		   username	+= ", "+fieldvalue;
		   i++;
		}else{
		    username = fieldvalue;
			 i++;
		   }
		%>
	<SCRIPT LANGUAGE="JavaScript">
//	alert("----username----"+<%=username%>);
	jQuery("#unoperator_n").html('<%=fieldname%>');
	jQuery("#unoperator_v").html('<a href="javascript:void(0)" onclick="show()"><%=i%>人</a>');
	</script>
	 <%}%>				
				<%
    } 
}
  %>
  --%>





	

<SCRIPT LANGUAGE="JavaScript">
function requestInfoCancel(){
		jQuery(".requestinfo_making").hide();
	}

	function show(){
		jQuery("#unoperator_v").html("<%=username%>");
	}
</SCRIPT>
