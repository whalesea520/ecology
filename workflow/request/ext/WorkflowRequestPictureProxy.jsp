
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.Util" %>
<%@ page import = "weaver.general.TimeUtil"%>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />

    <%
    User user = HrmUserVarify.getUser(request,response);
    String requestid = Util.null2String(request.getParameter("requestid"));

    String workflowid = Util.null2String(request.getParameter("workflowid")) ;
    int desrequestid=Util.getIntValue(request.getParameter("desrequestid"));
    String userid=new Integer(user.getUID()).toString();                   //当前用户id
    String isurger=Util.null2String(request.getParameter("isurger"));
   
    String myStr = "";

    if(isurger.equals("true")||Monitor.hasMonitor(requestid,user.getUID()+"")){
       rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid," +
    "a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype" +
    " from (SELECT distinct requestid ,userid ,workflow_currentoperator.workflowid,workflowtype ,isremark" +
    "      ,usertype" +
    "      ,workflow_currentoperator.nodeid" +
    "      ,agentorbyagentid" +
    "      ,agenttype" +
    "      ,receivedate" +
    "      ,receivetime" +
    "      ,viewtype" +
    "      ,iscomplete" +
    "      ,operatedate" +
    "      ,operatetime" +
    "      ,nodetype" +
    "  FROM workflow_currentoperator,workflow_flownode  where workflow_currentoperator.nodeid=workflow_flownode.nodeid and requestid="+requestid+") a,workflow_nodebase b" +
    " where a.nodeid=b.id" +
    " and a.requestid="+requestid+" and a.agenttype<>1" +
    //" order by a.receivedate,a.receivetime,a.nodeid");
    //nodeid是按添加顺序生成的，不能按这个排序。
    " order by a.receivedate,a.receivetime,a.nodetype,a.nodeid");
    
    }else{
        String viewLogIds = "";
        ArrayList canViewIds = new ArrayList();
        String viewNodeId = "-1";
        String tempNodeId = "-1";
        String singleViewLogIds = "-1";
        rs.executeSql("select distinct nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid);

        while(rs.next()){
        viewNodeId = rs.getString("nodeid");
        rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
        if(rs1.next()){
        singleViewLogIds = rs1.getString("viewnodeids");
        }

        if("-1".equals(singleViewLogIds)){//全部查看
        rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
        while(rs1.next()){
        tempNodeId = rs1.getString("nodeid");
        if(!canViewIds.contains(tempNodeId)){
        canViewIds.add(tempNodeId);
        }
        }
        }
        else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看

        }
        else{//查看部分
        String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
        for(int i=0;i<tempidstrs.length;i++){
        if(!canViewIds.contains(tempidstrs[i])){
        canViewIds.add(tempidstrs[i]);
        }
        }
        }
        }

    //处理相关流程的查看权限

        if(desrequestid>0)
        {
    //System.out.print("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in (\"2\",\"4\") and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
        rs.executeSql("select  distinct a.nodeid from  workflow_currentoperator a  where a.requestid="+requestid+" and  exists (select 1 from workflow_currentoperator b where b.isremark in (\"2\",\"4\") and b.requestid="+desrequestid+"  and  a.userid=b.userid)");
        while(rs.next()){
        viewNodeId = rs.getString("nodeid");
        rs1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
        if(rs1.next()){
        singleViewLogIds = rs1.getString("viewnodeids");
        }

        if("-1".equals(singleViewLogIds)){//全部查看
        rs1.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+desrequestid+"))");
        while(rs1.next()){
        tempNodeId = rs1.getString("nodeid");
        if(!canViewIds.contains(tempNodeId)){
        canViewIds.add(tempNodeId);
        }
        }
        }
        else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看

        }
        else{//查看部分
        String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
        for(int i=0;i<tempidstrs.length;i++){
        if(!canViewIds.contains(tempidstrs[i])){
        canViewIds.add(tempidstrs[i]);
        }
        }
        }
        }
        }
        if(canViewIds.size()>0){
        for(int a=0;a<canViewIds.size();a++)
        {
        viewLogIds += (String)canViewIds.get(a) + ",";
        }
        viewLogIds = viewLogIds.substring(0,viewLogIds.length()-1);
        }
        else{
        viewLogIds = "-1";
        }
        rs.executeSql("select a.nodeid,b.nodename,a.userid,a.isremark,a.usertype,a.agentorbyagentid, a.agenttype,a.receivedate,a.receivetime,a.operatedate,a.operatetime,a.viewtype from (SELECT distinct requestid ,userid ,workflow_currentoperator.workflowid ,workflowtype ,isremark ,usertype ,workflow_currentoperator.nodeid ,agentorbyagentid ,agenttype  ,receivedate ,receivetime ,viewtype ,iscomplete  ,operatedate ,operatetime,nodetype FROM workflow_currentoperator,workflow_flownode  where workflow_currentoperator.nodeid=workflow_flownode.nodeid and requestid = "+requestid+") a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" and a.agenttype<>1 and a.nodeid in("+viewLogIds+") order by a.receivedate,a.receivetime,a.nodetype,a.nodeid");

    }
    int tmpnodeid_old=-1;
    boolean islight=false;
	int count = 0;
    while(rs.next()){
    
		count++;
        String  column1 = "";
        String  column2 = "";
        String  column3 = "";
        String  column4 = "";
        String  column5 = "";
        String  column6 = "";
        int     tmpnodeid=rs.getInt("nodeid");
        String  tmpnodename=rs.getString("nodename");
        String  tmpuserid=rs.getString("userid");
        int     tmpisremark=rs.getInt("isremark");
        int     tmpusertype=rs.getInt("usertype");
        String  tmpagentorbyagentid=rs.getString("agentorbyagentid");
        int     tmpagenttype=rs.getInt("agenttype");
        String  tmpreceivedate=rs.getString("receivedate");
        String  tmpreceivetime=rs.getString("receivetime");
        String  tmpoperatedate=rs.getString("operatedate");
        String  tmpoperatetime=rs.getString("operatetime");
        String  viewtype=rs.getString("viewtype");
        boolean flags=false;
        String  tmpIntervel="";
		//如果tmpisremark=2 判断时候在日志表里有该人（确定是否是由非会签得到的isremark=2）
        rs1.execute("select operator from workflow_requestlog where requestid="+requestid+" and operator="+tmpuserid);
        if (rs1.next()) flags=true;
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 开始
        rs1.executeSql("select * from workflow_currentoperator a ,workflow_groupdetail b where a.groupdetailid=b.id and b.signorder=3 and a.requestid="+requestid+" and a.userid="+tmpuserid);
        if(rs1.next()&&tmpisremark==2&&tmpoperatedate!=null && !tmpoperatedate.equals("")){
        	tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
        //抄送（不需提交）查看后计算操作耗时 MYQ修改 结束
       // if ((tmpisremark==2&&rs1.next())||tmpisremark!=2)
         {
        if(tmpisremark==2 &&flags&& tmpoperatedate!=null && !tmpoperatedate.equals("")){
            tmpIntervel=TimeUtil.timeInterval2(tmpreceivedate+" "+tmpreceivetime,tmpoperatedate+" "+tmpoperatetime,user.getLanguage());
        }
    islight=!islight;
    

    %>
        <%if(tmpnodeid_old==tmpnodeid){%>
			<%column1="";%>
        <%}else{%>           
            <%
            	tmpnodeid_old=tmpnodeid;
            	column1=Util.toScreen(tmpnodename,user.getLanguage());
            %>
        <%}%>

            <%if(tmpusertype == 0){%>
                <%if(tmpagenttype!=2){%> 
					<%column2="<img border=0 align=absmiddle src=/images/replyDoc/userinfo_wev8.gif> "+"<a href=javascript:openhrm("+tmpuserid+") onclick=pointerXY(event)>"+Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())+"</a>";%>
                <%}else{%>
					<%column2="<img border=0 align=absmiddle src=/images/replyDoc/userinfo_wev8.gif> "+"<a href=javascript:openhrm("+tmpagentorbyagentid+") onclick=pointerXY(event)>"+Util.toScreen(ResourceComInfo.getResourcename(tmpagentorbyagentid),user.getLanguage()) + "</a>-><A  href=javaScript:openhrm("+tmpuserid+") onclick=pointerXY(event)>" + Util.toScreen(ResourceComInfo.getResourcename(tmpuserid),user.getLanguage())+"</a>";%>
                <%}%>
            <%}else{%>
			<%column2="<img border=0 align=absmiddle src=/images/replyDoc/userinfo_wev8.gif> "+"<A  href=/CRM/data/ViewCustomer.jsp?CustomerID="+tmpuserid+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(tmpuserid),user.getLanguage())+"</a>";%>
            <%}%>
       
        <%      
        if(tmpisremark==2&&flags){%>
			<%column3=SystemEnv.getHtmlLabelName(15176,user.getLanguage());%>
        <%}else if(tmpisremark==0||tmpisremark==1||tmpisremark==5||tmpisremark==4||tmpisremark==8||tmpisremark==9||(tmpisremark==2&&!flags)){%>
            <%if(viewtype.equals("-2") || (viewtype.equals("-1") && !tmpoperatedate.equals(""))){%>
				<%column3="<font color=#FF33CC>"+SystemEnv.getHtmlLabelName(18006,user.getLanguage())+"</font>";%>
            <%}else{%>
                <%column3="<font color=#FF0000>"+SystemEnv.getHtmlLabelName(18007,user.getLanguage())+"</font>";%>
            <%}%>
        <%}%>

			<%column4=Util.toScreen(tmpreceivedate,user.getLanguage()) + " " +Util.toScreen(tmpreceivetime,user.getLanguage()); %>

			<%column5=Util.toScreen(tmpoperatedate,user.getLanguage()) + " " +Util.toScreen(tmpoperatetime,user.getLanguage()); %>

			<%column6=Util.toScreen(tmpIntervel,user.getLanguage()); %>
		
		<% 
		myStr+="{\"node\":\""+column1+"\",\"operator\":\""+column2+"\",\"operatestatus\":\""+column3+"\",\"receivetime\":\""+column4+"\",\"operatetime\":\""+column5+"\",\"operatecosttime\":\""+column6+"\"},";
		
		%>

    <%}
  }%>
  
  <%
  if(myStr.length()>0){
	  myStr = myStr.substring(0,myStr.length()-1);
  }
  out.print("["+myStr+"]");
  %>