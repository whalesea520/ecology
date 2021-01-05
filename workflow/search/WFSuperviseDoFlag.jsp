
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ page import="java.io.Writer"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="cci" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<%
   //add By lsj 2014/1/23

  String[]  requestids=request.getParameterValues("requestid");

  User user = HrmUserVarify.getUser (request , response) ;
 
//用户id
  int userid=user.getUID();
  
  Calendar today = Calendar.getInstance();
  
  String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

  String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

  // 记录ip地址
  String clientip = request.getRemoteAddr();

    
  String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
  int usertype = 0;
  if(logintype.equals("1")) usertype = 0;
  if(logintype.equals("2")) usertype = 1;

 //流程督办人查看
  String orderType="4";

  int showorder = 10000;
 
  //分隔符
  char flag = Util.getSeparator() ;

  int requestid;

  int nodeid;

	
  for(String  reqid:requestids)
  {
    //请求id
    requestid=Util.getIntValue(reqid,0);
    //节点id
    nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));  
    rs.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + orderType + flag + showorder);
  
  }
   

  String returnStr="success";
  
  out.print(returnStr);
  
  return;
%>