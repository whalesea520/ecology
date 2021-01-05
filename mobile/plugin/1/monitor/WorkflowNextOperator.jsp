
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>


<%@ page import="weaver.workflow.request.ComparatorUtilBean"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
	
	JSONArray internorTable = new JSONArray(); 
	int requestid = Util.getIntValue(request.getParameter("requestid"),0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	String nodetype= Util.null2String(request.getParameter("nodetype"));
	String isremark=Util.null2String(request.getParameter("isremark"));
	int intervenorright=Util.getIntValue(request.getParameter("intervenorright"),0);
	// 操作的用户信息
	
	int userid=Util.getIntValue(request.getParameter("userid"),0);                   //当前用户id
	String logintype = Util.null2String(request.getParameter("usertype"));     //当前用户类型  1: 类别用户  2:外部用户
	int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);           //工作流id

    String billtablename = "";
    int operatorsize = 0;
    int formid=Util.getIntValue(request.getParameter("formid"),0);
    int isbill=Util.getIntValue(request.getParameter("isbill"),0);
    int billid=Util.getIntValue(request.getParameter("billid"),0);
    int creater = Util.getIntValue(request.getParameter("creater"),0);
    int creatertype =Util.getIntValue(request.getParameter("creatertype"),0);
    int usertype = (logintype).equals("1") ? 0 : 1;
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();
    String intervenoruserids="";
	String intervenoruseridsType="";
    String intervenorusernames="";
	String messagerurl = "";
    if(isremark.equals("5")||intervenorright>0){
	if (isbill == 1) {
				RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息
	
				if (RecordSet.next())
					billtablename = RecordSet.getString("tablename");          // 获得单据的主表
	
	}
	
WFNodeMainManager.setWfid(workflowid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
	    int tmpid = WFNodeMainManager.getNodeid();
	    String tmpname = WFNodeMainManager.getNodename();
	    String tmptype = WFNodeMainManager.getNodetype();
		String isintervenor="1";	//是否干预
	    intervenoruserids="";
		intervenoruseridsType="";
	    intervenorusernames="";
	    //查询节点操作者
        if(tmptype.equals("3")) continue ;
        requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(tmpid);
		requestNodeFlow.setNodetype(tmptype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(userid);
		requestNodeFlow.setUsertype(usertype);
		requestNodeFlow.setCreaterid(creater);
		requestNodeFlow.setCreatertype(creatertype);
		requestNodeFlow.setIsbill(isbill);
		requestNodeFlow.setBillid(billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
        requestNodeFlow.setRecordSet(RecordSet);
        requestNodeFlow.setIsreject(1);
        requestNodeFlow.setRejectToNodeid(nodeid);
        //requestNodeFlow.setIsintervenor(isintervenor);
        //requestNodeFlow.getNextNodesIntervenor();
        requestNodeFlow.getNextNodes();
        ArrayList nextnodeids = requestNodeFlow.getNextnodeids();
        ArrayList nextuserids = requestNodeFlow.getOperatorshts();
        //System.out.println(" tmpid="+tmpid+"  tmpname="+tmpname+" nextnodeids.size() = "+nextnodeids.size()+"");
		for(int index = 0 ;  index <nextnodeids.size(); index++){
			operatorsht = new Hashtable();
            intervenorusernames="";
			operatorsht = (Hashtable)nextuserids.get(index);
            int nextnodeid = Util.getIntValue((String)nextnodeids.get(index));
            operatorsize = operatorsht.size();
            //System.out.println(" nextnodeid = "+nextnodeid+" selectnodeid = "+nodeid+" tmpid = "+tmpid);
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
                    Map<String,String> opertorMap = new HashMap<String,String>();
					while(iterator.hasNext()) {
					String operatorgroup = (String) iterator.next();
					ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
					for (int i = 0; i < operators.size(); i++) {
					    String operatorandtype = (String) operators.get(i);
							String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
							String opertor = operatorandtypes[0];
							String opertortype = operatorandtypes[1];
							String opertorsigntype = operatorandtypes[3];
	                        //去除重复操作者
	                        if(opertorMap.containsKey(opertor)){
	                            continue;
	                        }else{
	                            opertorMap.put(opertor,"");
	                        }
							String img_path=ResourceComInfo.getMessagerUrls(opertor);
							if(opertorsigntype.equals("-3")||opertorsigntype.equals("-4")) continue;
	                        intervenoruserids+=opertor+",";
							intervenoruseridsType +=opertortype+",";
							messagerurl +=img_path+",";
	                        if("0".equals(opertortype)){
							intervenorusernames += ResourceComInfo.getResourcename(opertor)+",";
							}else{
							intervenorusernames += CustomerInfoComInfo.getCustomerInfoname(opertor)+",";
							}
	                        //System.out.println("tempid="+tmpid+"/"+tmpname+" selectnodeid = "+nodeid+" nextnodeid = "+nextnodeid+" intervenorusernames = "+intervenorusernames);
					}
	                }
				}
	            hasnextnodeoperator = true ;
	            break ;
            }
        }
		if(hasnextnodeoperator) break ;
    }
}
    if(intervenoruserids.length()>1){
        intervenoruserids=intervenoruserids.substring(0,intervenoruserids.length()-1);
		intervenoruseridsType=intervenoruseridsType.substring(0,intervenoruseridsType.length()-1);
		intervenorusernames=intervenorusernames.substring(0,intervenorusernames.length()-1);
		messagerurl=messagerurl.substring(0,messagerurl.length()-1);
		
    }
	if(intervenoruserids.length()>1){
	String [] intervenoruseridsl = Util.TokenizerString2(intervenoruserids, ",");
	String [] intervenoruseridsTypel = Util.TokenizerString2(intervenoruseridsType, ",");
	String [] intervenorusernamesl = Util.TokenizerString2(intervenorusernames, ",");
	String [] messagerurll = Util.TokenizerString2(messagerurl, ",");
	for(int i=0;i<intervenoruseridsl.length;i++){
		JSONObject jsonObject=new JSONObject();
		String sql = "select id,lastname,messagerurl,sex from hrmresource where id in ("+intervenoruseridsl[i]+")";
		//System.out.println("创建新节点sql"+sql);
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			//String messagerurl1 = Util.null2String(RecordSet.getString(3));
			String sex = Util.null2String(RecordSet.getString(4));
			if("".equals(messagerurll[i])){
				if("0".equals(sex)){
					messagerurll[i] = "/messager/images/icon_m_wev8.jpg";
				}else{
					messagerurll[i] = "/messager/images/icon_w_wev8.jpg";
				}
			}

		}
		
		jsonObject.put("id",intervenoruseridsl[i]);
	jsonObject.put("intervenoruseridsType",intervenoruseridsTypel[i]);
	jsonObject.put("operatname",intervenorusernamesl[i]);
	jsonObject.put("messagerurl",messagerurll[i]);
	internorTable.put(jsonObject);
	
	}
	
	
}


	
	//jsonObject.put("internorTable", internorTable); 
	//String[] intervenoruserid =   intervenoruserids.split(",");
	//jsonObject.put("id",intervenoruserids);
	//jsonObject.put("intervenoruseridsType",intervenoruseridsType);
	//jsonObject.put("operatname",intervenorusernames);
	//jsonObject.put("messagerurl",messagerurl);
	

	out.println(internorTable.toString());
	
	
	
    //System.out.println(" intervenorusernames = "+intervenorusernames);
%>