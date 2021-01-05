
<%@ page language="java" contentType="text/html; charset=UTF-8"%><%@ page
	import="java.util.*"%><%@ page import="weaver.hrm.*"%><%@ page
	import="weaver.systeminfo.*"%><%@ page import="weaver.general.*"%><%@ page
	import="weaver.workflow.layout.RequestDisplayInfo"%><%@page
	import="weaver.conn.RecordSet"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
boolean charsetgbk = "true".equals(Util.null2String((String)request.getParameter("charsetgbk")));
boolean ismobile = "true".equals(Util.null2String((String)request.getParameter("ismobile")));


	User user = HrmUserVarify.getUser(request , response) ;
	int workflowid =  Util.getIntValue(request.getParameter("wfid"), 0);
	
	
	int requestid = Util.getIntValue(request.getParameter("requestid"), -1);
	//查询formid isBill isCust id workflowname
	String isBill = "";
	String formid = "";
	String isCust = "";
	String workflowname = "";
	RecordSet rst = new RecordSet();
		if (workflowid == 0) {
			// 查询请求的相关工作流基本信息
			rst.executeProc("workflow_Requestbase_SByID", requestid + "");
			if (rst.next()) {
				workflowid = Util.getIntValue(rst.getString("workflowid"), 0);
			}
		}
		//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
		rst.executeProc("workflow_Workflowbase_SByID", workflowid+"");
		if (rst.next()) {
			formid = Util.null2String(rst.getString("formid"));
			isCust = Util.null2String(rst.getString("isCust"));
			workflowname = Util.null2String(rst.getString("workflowname"));
			isBill = "" + Util.getIntValue(rst.getString("isbill"), 0);
		}
	RequestDisplayInfo reqDisplayInfo = new RequestDisplayInfo(String.valueOf(workflowid), String.valueOf(requestid));
	reqDisplayInfo.setIsnewDesign(false);
	reqDisplayInfo.setUser(user);
	Map reqDisBean = reqDisplayInfo.getReqDisInfo();
	List nodeDisInfo = (List)reqDisBean.get("nodeinfo");
	List nodeLinkLineInfo = (List)reqDisBean.get("lineinfo");
	
	String wfnodelindeXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><TopFlow id=\""+workflowid+"\" formid=\""+formid+"\" isBill=\""+isBill+"\" isCust=\""+isCust+"\" text=\""+Util.toXmlText(workflowname)+"\" isView=\"true\"><Procs>";
	//把 节点操作者的信息拼接成XML
		Iterator iterator = nodeDisInfo.iterator();
		for(int icount=0;iterator.hasNext();icount++) {
			Map picBean = (Map)iterator.next();
			int[] nodePoint = (int[])picBean.get("nodePoint");
			int[] nodeDecPoint = (int[])picBean.get("nodeDecPoint"); //节点的 x轴 y轴
			String nodeColor = (String)picBean.get("nodeColor");
			
			String nodeName = (String)picBean.get("nodeName");//nodename
			int optType = ((Integer)picBean.get("nodeType")).intValue(); //节点状态  0: 已通过  1: 当前 2:其它
			Object t_isPass = picBean.get("ispass");
			boolean ispass = false;
			if (t_isPass != null) {
				ispass = Boolean.parseBoolean(t_isPass.toString());
			}
			boolean iscurrent = false;
			Object t_iscurrent = picBean.get("iscurrent");
			if (t_iscurrent != null) {
				iscurrent = Boolean.parseBoolean(t_iscurrent.toString());
			}
			
	    	//String nodeOperatorName = (String)picBean.get("nodeOperatorName");
			//String nodeOperatorGropId = (String)picBean.get("nodeOperatorGropId");
			
			String nodeid = (String)picBean.get("nodeid"); //nodeid
			String nodetype = (String)picBean.get("ntype"); //nodetype
			String nodeattribute = (String)picBean.get("nodeattribute"); //nodeattribute
			
			
			List nodeNotOperatorNameList = (List)picBean.get("nodeNotOperatorNameList"); //为操作者信息
			List nodeOperatorNameList = (List)picBean.get("nodeOperatorNameList");  //已操作者信息
			List nodeViewNameList = (List)picBean.get("nodeViewNameList"); //查看者信息
			//List nodeOperatorGropIdList = (List)picBean.get("nodeOperatorGropIdList");
			//boolean isCurrentNode = (Boolean)picBean.get("isCurrentNode");
			String nodeOperatorName = Util.null2String((String)picBean.get("nodeOperatorName")).replace(">","&gt;");
			
			String nodeNotOperatorNames = "";
			String nodeOperatorNames = "";
			String nodeViewNames = "";
				String splitstring = " ";
				if (reqDisplayInfo.isIsnewDesign()) {
					splitstring = "_#WFSPSTR#_";
				}
				for (int i=0; i<nodeNotOperatorNameList.size(); i++) {
					if (i != 0) {
						nodeNotOperatorNames += splitstring;
					}
					nodeNotOperatorNames += Util.null2String(nodeNotOperatorNameList.get(i)).replace(">","&gt;");
				}
				for (int i=0; i<nodeOperatorNameList.size(); i++) {
					if (i != 0) {
						nodeOperatorNames += splitstring;
					}
					nodeOperatorNames += Util.null2String(nodeOperatorNameList.get(i)).replace(">","&gt;");
				}
				
				for (int i=0; i<nodeViewNameList.size(); i++) {
					if (i != 0) {
						nodeViewNames += splitstring;
					}
					nodeViewNames +=  Util.null2String(nodeViewNameList.get(i)).replace(">","&gt;");
				}
				
				//for (Iterator it=nodeNotOperatorNameList.iterator(); it.hasNext();) {
				//	nodeNotOperatorNames += it.next() + splitstring;
			    //}
				//for (Iterator it=nodeOperatorNameList.iterator(); it.hasNext();) {
				//	nodeOperatorNames += it.next() + splitstring;
			    //}
				//for (Iterator it=nodeViewNameList.iterator(); it.hasNext();) {
				//	nodeViewNames += it.next() + splitstring;
			    //}
				
					wfnodelindeXml += "<Proc>"
						+"<BaseProperties id=\""+nodeid+"\" nodeOperatorName=\"" + nodeOperatorName  + "\" nodeViewNames=\""+nodeViewNames+"\"  nodeOperatorNames=\""+nodeOperatorNames+"\"  nodeNotOperatorNames=\""+nodeNotOperatorNames+"\"  text=\""+Util.toXmlText(nodeName)+"\"  hasNodePro=\"false\" "
						+"hasCusRigKey=\"false\"  hasNodeBefAddOpr=\"false\"  hasNodeAftAddOpr=\"false\" "
						+"hasLogViewSco=\"false\"  hasNodeForFie=\"false\"  nodetype=\""+nodetype+"\""+" optType=\"" + optType + "\" ";
						if(iscurrent == true){
							wfnodelindeXml += "iscurrent=\"true\""+"\t";
						}
						if(ispass == true){
							wfnodelindeXml += "ispass=\"true\""+"\t";
						}else{
							wfnodelindeXml += "ispass=\"false\""+"\t";
						}
						
						
						if("1".equals(nodeattribute)){
							wfnodelindeXml += "procType=\"fork\"/>";
						}else if("3".equals(nodeattribute) || "4".equals(nodeattribute)){
							wfnodelindeXml += "procType=\"join\"/>";
						}else {
							//System.out.println("nodetype");
							switch (Integer.parseInt(nodetype)) {
								case 0:
									wfnodelindeXml += "procType=\"create\"/>";
									break;
								case 1:
									wfnodelindeXml += "procType=\"approve\"/>";
									break;
								case 2:
									wfnodelindeXml += "procType=\"realize\"/>";
									break;
								case 3:
									wfnodelindeXml += "procType=\"process\"/>";
								default:
									break;
							}
							
						}
						wfnodelindeXml += "<VMLProperties shapetype=\"RoundRect\" x=\""+(nodeDecPoint[0] - 60)+"\"  y=\""+(nodeDecPoint[1] - 40)+"\""+"\t"
						+"width=\""+10+"\" height=\""+10+"\" zIndex=\""+-1+"\" nodeattribute=\""+nodeattribute+"\" passNum=\""+0+"\"/>"
					+"</Proc>";
				}			                     
		wfnodelindeXml += "</Procs><Steps>";
	//把出口条件信息拼接成XML
	for (Iterator it=nodeLinkLineInfo.iterator();it.hasNext();) {
		
		Map lineBean = (Map)it.next();
		
		List lines = (List)lineBean.get("lines");
		String t_isPass = Util.null2String((String)lineBean.get("ispass"));
		
		boolean ispass = Boolean.parseBoolean(t_isPass);
		String linkid = (String)lineBean.get("linkid");
		String linkname = (String)lineBean.get("linkname");
		String directfrom = (String)lineBean.get("directfrom");
		String directto = (String)lineBean.get("directto");
		String startDirection = Util.getIntValue((String)lineBean.get("startDirection"), -1) + "";
		String endDirection = Util.getIntValue((String)lineBean.get("endDirection"), -1) + "";
		String points = (String)lineBean.get("points");
		String newPoints = (String)lineBean.get("newPoints");
		boolean hasCondition = ((Boolean)lineBean.get("hasCondition")).booleanValue();
		//String startDirection = "0";
		//String endDirection = "0";
		
		wfnodelindeXml += "<Step>"
			+"<BaseProperties id=\""+linkid+"\" startDirection=\""+startDirection+"\" endDirection=\""+endDirection+"\" text=\""+Util.toXmlText(linkname)+"\" from=\""+directfrom+"\" to=\""+directto+"\""+"\t"
			+"remindMsg=\"\" isBuildCode=\"false\" isreject=\"" + lineBean.get("isreject") + "\" ismustpass=\"0\""+"\t";
			if(ispass == true){
				wfnodelindeXml += "ispass=\"true\""+"\t";
			}else{
				wfnodelindeXml += "ispass=\"false\""+"\t";
			}
			wfnodelindeXml += "hasRole=\"false\" hasCondition=\"" + hasCondition + "\" />"
			+"<VMLProperties points=\"" + points + "\"" + " newPoints=\"" + newPoints + "\""
		    +" shapetype=\"PolyLine\" />"
			+"</Step>";
		
		for (Iterator lineIt=lines.iterator();lineIt.hasNext();) {
			Map line = (Map)lineIt.next();
		}
	}
	wfnodelindeXml += "</Steps>";
	wfnodelindeXml += "<Groups>";
	RecordSet rs = new RecordSet();
	rs.execute("select * from workflow_groupinfo where workflowid=" + workflowid);
    while (rs.next()) {
    	wfnodelindeXml += "<Group id=\"" + rs.getInt("id") 
    	+ "\" workflowid=\"" + rs.getInt("workflowid") 
    	+ "\" text=\"" + Util.toXmlText(rs.getString("groupname")) 
    	+ "\" direction=\"" + rs.getInt("direction") 
    	+ "\" x=\"" + rs.getDouble("x") 
    	+ "\" y=\"" + rs.getDouble("y") 
    	+ "\" width=\"" + rs.getDouble("width") 
    	+ "\" height=\"" + rs.getDouble("height") + "\" isNew=\"true\"/>";
    }
    wfnodelindeXml += "</Groups>";
    wfnodelindeXml += "</TopFlow>";
	//public String getWfNodeLineXml(String nodetype){
	//}
	//System.out.println("xml:\r\n" + wfnodelindeXml);
	response.getWriter().write(wfnodelindeXml);
	
%>