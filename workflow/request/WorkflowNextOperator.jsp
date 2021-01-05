
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.workflow.request.ComparatorUtilBean"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
	int requestid = Util.getIntValue(request.getParameter("requestid"),0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	String nodetype= Util.null2String(request.getParameter("nodetype"));
	String isremark=Util.null2String(request.getParameter("isremark"));
	int intervenorright=Util.getIntValue(request.getParameter("intervenorright"),0);
	// 操作的用户信息
	
	int userid=user.getUID();                   //当前用户id
	String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
	int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);           //工作流id

    String billtablename = "";
    int operatorsize = 0;
    int formid=Util.getIntValue(request.getParameter("formid"),0);
    int isbill=Util.getIntValue(request.getParameter("isbill"),0);
    int billid=Util.getIntValue(request.getParameter("billid"),0);
    int creater = Util.getIntValue(request.getParameter("creater"),0);
    int creatertype =Util.getIntValue(request.getParameter("creatertype"),0);
    int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();
    String intervenoruserids="";
	String intervenoruseridsType="";
    String intervenorusernames="";
    if(isremark.equals("5")||intervenorright>0){
	if (isbill == 1) {
				RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息
	
				if (RecordSet.next())
					billtablename = RecordSet.getString("tablename");          // 获得单据的主表
	
	}
	

		String isintervenor="1";	//是否干预
	    intervenoruserids="";
		intervenoruseridsType="";
	    intervenorusernames="";
	    //查询节点操作者
        requestNodeFlow.setRequestid(requestid);
		//requestNodeFlow.setNodeid(nodeid);
		//requestNodeFlow.setNodetype(nodetype);
		requestNodeFlow.setNextnodeid(nodeid);
		requestNodeFlow.setNextnodetype(nodetype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(userid);
		requestNodeFlow.setUsertype(usertype);
		requestNodeFlow.setCreaterid(creater);
		requestNodeFlow.setCreatertype(creatertype);
		requestNodeFlow.setIsbill(isbill);
		requestNodeFlow.setBillid(billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
		requestNodeFlow.setIsreject(0);
		//requestNodeFlow.setRejectToNodeid(nodeid);
		requestNodeFlow.setIsintervenor(isintervenor);
		//requestNodeFlow.getNextNodesIntervenor();
		
		//requestNodeFlow.getNextNodes();
        //ArrayList nextnodeids = requestNodeFlow.getNextnodeids();
        //ArrayList nextuserids = requestNodeFlow.getOperatorshts();
        //System.out.println(" tmpid="+tmpid+"  tmpname="+tmpname+" nextnodeids.size() = "+nextnodeids.size()+"");
        
        boolean NextOperator = requestNodeFlow.getNextOperator();
        //System.out.println(" NextOperator="+NextOperator+" nodeid="+nodeid+" nodetype="+nodetype);
        if(NextOperator){
			operatorsht = requestNodeFlow.getOperators();
            int nextnodeid=requestNodeFlow.getNextNodeid();
            operatorsize = operatorsht.size();
            //System.out.println(" nextnodeid = "+nextnodeid+" operatorsize = "+operatorsize+" NextOperator = "+NextOperator);
            ArrayList userids = new ArrayList();
            if(nodeid==nextnodeid){
	            if(operatorsize > 0){
	                TreeMap map = new TreeMap(new ComparatorUtilBean());
					Enumeration tempKeys = operatorsht.keys();
					try{
					while (tempKeys.hasMoreElements()) {
						String tempKey = (String) tempKeys.nextElement();
						ArrayList tempoperators = (ArrayList) operatorsht.get(tempKey);
						map.put(tempKey,tempoperators);
					}
					}catch(Exception e){}
					Iterator iterator = map.keySet().iterator();
					while(iterator.hasNext()) {
					String operatorgroup = (String) iterator.next();
					ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
					for (int i = 0; i < operators.size(); i++) {
						    String operatorandtype = (String) operators.get(i);
							String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
							String opertor = operatorandtypes[0];
							String opertortype = operatorandtypes[1];
							String opertorsigntype = operatorandtypes[3];
							if(userids.contains(opertor)){
							    continue ;
							}else{
							    userids.add(opertor);
							}
							if(opertorsigntype.equals("-3")||opertorsigntype.equals("-4")) continue;
	                        intervenoruserids+=opertor+",";
							intervenoruseridsType +=opertortype+",";
	                        if("0".equals(opertortype)){
							intervenorusernames += "<A href='#"+opertor+"' onclick='pointerXY(event);javaScript:openhrm("+opertor+");'>"+ResourceComInfo.getResourcename(opertor)+"</A>";
							}else{
							intervenorusernames += "<A href='#"+opertor+"'>"+CustomerInfoComInfo.getCustomerInfoname(opertor)+"</A>";
							}
	                        //System.out.println("tempid="+tmpid+"/"+tmpname+" selectnodeid = "+nodeid+" nextnodeid = "+nextnodeid+" intervenorusernames = "+intervenorusernames);
					}
	                }
				}
	            
            }
        }
}
    
    if(intervenoruserids.length()>1){
        intervenoruserids=intervenoruserids.substring(0,intervenoruserids.length()-1);
		intervenoruseridsType=intervenoruseridsType.substring(0,intervenoruseridsType.length()-1);
    }

if(isremark.equals("5")){
%>
<script language="javascript">
	$GetEle("IntervenoridType",parent.document).value = "<%=intervenoruseridsType%>";
    <%if(intervenoruserids.length()>0){%>
		parent._writeBackData("Intervenorid", 2, {id:"<%=intervenoruserids%>",name:"<%=intervenorusernames%>"}, {isSingle:false,hasInput:true,replace:true});
    	parent.rightMenu.style.display="";
    <%}else{%>
    	parent._writeBackData("Intervenorid", 2, {id:"",name:"<%=SystemEnv.getHtmlLabelName(19046,user.getLanguage())%>"});
    <%}%>
</script>
<%}else if(intervenorright>0){
%>
<script language="javascript">
	$GetEle("IntervenoridType",parent.document).value = "<%=intervenoruseridsType%>";
    <%if(intervenoruserids.length()>0){%>
    	parent._writeBackData("Intervenorid", 2, {id:"<%=intervenoruserids%>",name:"<%=intervenorusernames%>"}, {isSingle:false,hasInput:true,replace:true});
    <%}else{%>
    	parent._writeBackData("Intervenorid", 2, {id:"",name:""});
    <%}%>
    parent.rightMenu.style.display="";
</script>
<%}%>