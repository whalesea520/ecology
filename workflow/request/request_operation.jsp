<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<%RequestManager.resetParameter();%>
<jsp:useBean id="RequestFieldManager" class="weaver.workflow.request.RequestFieldManager" scope="page"/>
<%RequestFieldManager.resetParameter();%>
<jsp:useBean id="RequestUserMainManager" class="weaver.workflow.request.RequestUserMainManager" scope="page"/>
<%RequestFieldManager.resetParameter();%>
<jsp:useBean id="NodeInfo" class="weaver.workflow.node.NodeInfo" scope="page" />
<jsp:useBean id="User" class="weaver.user.User" scope="session" />
<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;
	
String src=Util.null2String(request.getParameter("src"));
int wfid=Util.getIntValue(request.getParameter("wfid"),-1);
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int lastnodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String lastnodetype = Util.null2String(request.getParameter("nodetype"));
int requestid=Util.getIntValue(request.getParameter("requestid"),-1);

int curnodeid = -1;
String curnodetype = "";
String requeststate = "";
String useparameter="";

if(src.equals("addrequest")) {
	NodeInfo.resetParameter();
	NodeInfo.setWfid(wfid);
	NodeInfo.getNodeinfo();
	
	while(NodeInfo.next()){
		if(NodeInfo.getIsstart().equals("1")) {
			curnodeid = NodeInfo.getNodeid();
			curnodetype = NodeInfo.getNodetype();
			requeststate = NodeInfo.getLinkname();
			useparameter = NodeInfo.getUseparameter();
			break;
		}
	}
	RequestManager.resetParameter();
	RequestManager.setWfid(wfid);
        RequestManager.setCurrentNodeid(curnodeid);
        RequestManager.setCurrentNodetype(curnodetype);
        RequestManager.setLastNodeid(lastnodeid);
        RequestManager.setLastNodetype(lastnodetype);
        RequestManager.setRequestStatus(requeststate);
                
        RequestManager.insertRequest();
        requestid = RequestManager.getRequestid();
        //加入字段信息
        RequestFieldManager.setRequestid(requestid);
        RequestFieldManager.insertRequestField("workflow_form"+formid);
        //加入用户
        RequestUserMainManager.resetParameter();
        RequestUserMainManager.setRequestid(requestid);
        RequestUserMainManager.setSql_where(useparameter);
        
        RequestUserMainManager.updateRequestUser();
        
      response.sendRedirect("managerequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&wfid="+wfid+"&formid="+formid+"&nodeid="+curnodeid+"&nodetype="+curnodetype);
}    
else if(src.equals("save")) {
	String[] fields=request.getParameterValues("fields");
	String[] values = new String[fields.length];	
	for(int i=0;i<fields.length;i++) {
		values[i] = Util.null2String(request.getParameter(fields[i]));
	}	
        RequestFieldManager.setRequestid(requestid);
        RequestFieldManager.updateRequestField(fields,"workflow_form"+formid,values);
        
        curnodeid= lastnodeid;
        curnodetype = lastnodetype;
//	response.sendRedirect("managerequest.jsp?requestid="+requestid+"&wfid="+wfid+"&formid="+formid+"&nodeid="+curnodeid+"&nodetype="+curnodetype);
}    
else if(src.equals("reject")) {
	NodeInfo.resetParameter();
	NodeInfo.setWfid(wfid);
	NodeInfo.getNodeinfo();		
	while(NodeInfo.next()){
		if(NodeInfo.getNodeid()==lastnodeid && NodeInfo.getIsrejectlink().equals("1")) {
			curnodeid = NodeInfo.getDestnodeid();
			requeststate = NodeInfo.getLinkname();			
			break;
		}
	}
	NodeInfo.resetParameter();
	NodeInfo.setWfid(wfid);
	NodeInfo.getNodeinfo();		
	while(NodeInfo.next()){
		if(NodeInfo.getNodeid()==curnodeid) {
			curnodetype = NodeInfo.getNodetype();
			useparameter = NodeInfo.getUseparameter();
			break;
		}
	}
	RequestManager.resetParameter();
	RequestManager.setWfid(wfid);
	RequestManager.setRequestid(requestid);
        RequestManager.setCurrentNodeid(curnodeid);
        RequestManager.setCurrentNodetype(curnodetype);
        RequestManager.setLastNodeid(lastnodeid);
        RequestManager.setLastNodetype(lastnodetype);
        RequestManager.setRequestStatus(requeststate);
        RequestManager.updateRequest();
        
        RequestUserMainManager.resetParameter();
        RequestUserMainManager.setRequestid(requestid);
        RequestUserMainManager.setSql_where(useparameter);
        RequestUserMainManager.updateRequestUser();
    //    
       response.sendRedirect("managerequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&wfid="+wfid+"&formid="+formid+"&nodeid="+curnodeid+"&nodetype="+curnodetype);
}    
else if(src.equals("approve")) {
	NodeInfo.resetParameter();
	NodeInfo.setWfid(wfid);
	NodeInfo.getNodeinfo();		
	while(NodeInfo.next()){
		if(NodeInfo.getNodeid()==lastnodeid && NodeInfo.getIsrejectlink().equals("0")) {
			curnodeid = NodeInfo.getDestnodeid();
			requeststate = NodeInfo.getLinkname();
			break;
		}
	}
	NodeInfo.resetParameter();
	NodeInfo.setWfid(wfid);
	NodeInfo.getNodeinfo();		
	while(NodeInfo.next()){
		if(NodeInfo.getNodeid()==curnodeid) {
			curnodetype = NodeInfo.getNodetype();
			useparameter = NodeInfo.getUseparameter();
			break;
		}
	}
	RequestManager.resetParameter();
	RequestManager.setWfid(wfid);
	RequestManager.setRequestid(requestid);
        RequestManager.setCurrentNodeid(curnodeid);
        RequestManager.setCurrentNodetype(curnodetype);
        RequestManager.setLastNodeid(lastnodeid);
        RequestManager.setLastNodetype(lastnodetype);
        RequestManager.setRequestStatus(requeststate);
        
        RequestManager.updateRequest();
        
     //   Enumeration enu = request.getParameterNames();
       // while(enu.hasMoreElements()){
       // 	out.print("enu:"+enu.nextElement());
       // }

        
        String[] fields=request.getParameterValues("fields");
	String[] values = new String[fields.length];	
	for(int i=0;i<fields.length;i++) {
		values[i] = Util.null2String(request.getParameter(fields[i]));
	//	out.print("fields:"+fields[i]+"=values:"+values[i]);
	}	
	RequestFieldManager.setRequestid(requestid);
        RequestFieldManager.updateRequestField(fields,"workflow_form"+formid,values);
        
        RequestUserMainManager.resetParameter();
        RequestUserMainManager.setRequestid(requestid);
        RequestUserMainManager.setSql_where(useparameter);
        RequestUserMainManager.updateRequestUser();
        
     //   response.sendRedirect("managerequest.jsp?requestid="+requestid+"&wfid="+wfid+"&formid="+formid+"&nodeid="+curnodeid+"&nodetype="+curnodetype);
}    
response.sendRedirect("requestlist.jsp");


%>