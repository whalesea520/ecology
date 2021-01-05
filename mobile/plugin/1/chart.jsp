
<%@ page language="java" contentType="text/html; charset=UTF-8"%><%@ page
	import="java.util.*"%><%@ page import="weaver.hrm.*"%><%@ page
	import="weaver.systeminfo.*"%><%@ page import="weaver.general.*"%><%@ page
	import="weaver.workflow.layout.RequestDisplayInfo"%><%@ page
	import="weaver.workflow.layout.FreeWorkflowNode"%><%@page
	import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");


//User user = HrmUserVarify.getUser(request , response) ;
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

int requestid = Util.getIntValue(request.getParameter("requestid"), -1) ;
String type = Util.null2String(request.getParameter("type"));
int workflowid = Util.getIntValue((String)request.getParameter("workflowid"), 0);

String error = Util.null2String(request.getParameter("error"));
if("error".equals(error)){
    Map errorresult = new HashMap();
    //抱歉,您没有流程内容查看权限...
    errorresult.put("error",SystemEnv.getHtmlLabelName(126351,user.getLanguage()));
    errorresult.put("errorno","126351");
    JSONObject errorjo = JSONObject.fromObject(errorresult);
    response.getWriter().write(errorjo.toString());
    return;
}
RecordSet rst = new RecordSet();
if (workflowid == 0) {
	// 查询请求的相关工作流基本信息
	rst.executeProc("workflow_Requestbase_SByID", requestid + "");
	if (rst.next()) {
		workflowid = Util.getIntValue(rst.getString("workflowid"), 0);
	}
}

Map result = new HashMap();
List nodes = new ArrayList();
List lines = new ArrayList();
List groups = new ArrayList();
result.put("nodes", nodes);
result.put("lines", lines);
result.put("groups", groups);

RequestDisplayInfo reqDisplayInfo = new RequestDisplayInfo(String.valueOf(workflowid), String.valueOf(requestid));
reqDisplayInfo.setIsnewDesign(false);
reqDisplayInfo.setUser(user);
Map reqDisBean = reqDisplayInfo.getReqDisInfo();

List nodeDisInfo = (List)reqDisBean.get("nodeinfo");
List nodeLinkLineInfo = (List)reqDisBean.get("lineinfo");
FreeWorkflowNode fwf = new FreeWorkflowNode();
weaver.workflow.workflow.WFManager wfManager = new weaver.workflow.workflow.WFManager();
wfManager.setWfid(workflowid);
wfManager.getWfInfo();
String isFree = wfManager.getIsFree();
int maxWidth = 0;
int maxHeight = 0;
boolean isold = false;
int sss=0;
for (Iterator it=nodeLinkLineInfo.iterator(); it.hasNext();) {
	Map bean = (Map)it.next();
	Map line = new HashMap();
	
	boolean ispass = Boolean.parseBoolean(Util.null2String((String)bean.get("ispass")));

	String startDirection = Util.getIntValue((String)bean.get("startDirection"), -1) + "";
	String endDirection = Util.getIntValue((String)bean.get("endDirection"), -1) + "";
	String points = (String)bean.get("points");
	String newPoints = Util.null2String((String)bean.get("newPoints"));
	String isFreeNode = Util.null2String((String)bean.get("isFreeNode"));
	String directfrom = (String)bean.get("directfrom");
	String directto = (String)bean.get("directto");
	
	if (!"".equals(newPoints)) {
		String[] ps = newPoints.split(",");
		
		if (ps.length >= 4) {
			newPoints = "";
			for (int j=0; j<ps.length; j+=2) {
				double point =  Double.parseDouble(ps[j]);
				double point2 =  Double.parseDouble(ps[j + 1]);
				
				if (j == 0) {
					if (Integer.parseInt(startDirection) == 90) {
						point += 10;
					} else if (Integer.parseInt(startDirection) == 180) {
						point2 += 10;
					} else if (Integer.parseInt(startDirection) == -90) {
						point -= 10;
					} else if (Integer.parseInt(startDirection) == 0) {
						point2 -= 10;
					} 
				}
				
				if (j == ps.length - 2) {
					if (Integer.parseInt(endDirection) == 90) {
						point += 10;
					} else if (Integer.parseInt(endDirection) == 180) {
						point2 += 10;
					} else if (Integer.parseInt(endDirection) == -90) {
						point -= 10;
					} else if (Integer.parseInt(endDirection) == 0) {
						point2 -= 10;
					} 
				}
				newPoints += point + "," + point2 + ",";
			}
			newPoints = newPoints.substring(0, newPoints.length() - 1);
		}
	} else {
		isold = true;
	}
	if("1".equals(isFreeNode)){
       RecordSet  directrs = new RecordSet();
	   String x1="",y1="",x2="",y2="";
	   String directsql1 = " SELECT drawxpos,drawypos FROM workflow_nodebase  WHERE id="+directfrom;
       directrs.executeSql(directsql1);
	   if(directrs.next()){
          x1 = (Util.getIntValue(directrs.getString("drawxpos"),-1)+50) +"";
		  y1 = Util.getIntValue(directrs.getString("drawypos"),-1) +"";
	   }
       String directsql2 = " SELECT drawxpos,drawypos FROM workflow_nodebase  WHERE id="+directto;
       directrs.executeSql(directsql2);
	   if(directrs.next()){
          x2 = (Util.getIntValue(directrs.getString("drawxpos"),-1)-50) +"";
		  y2 = Util.getIntValue(directrs.getString("drawypos"),-1)+"";
	   }
	   points = x1+","+y1+","+x2+","+y2;
	}

	if(requestid>0 && isFree.equals("1")){
		Map<String, Map<String, Integer>> freeNodePositions = null;
		freeNodePositions = fwf.getNodePositions(workflowid+"", requestid+"");
		Map<String, Integer> fromposition = freeNodePositions.get(directfrom);
		Map<String, Integer> toposition = freeNodePositions.get(directto);
		int fromx = 0;
		int fromy = 0;
		int tox = 0;
		int toy = 0;
		if (fromposition != null) {
			fromx = fromposition.get("x");
			fromy = fromposition.get("y");
		}
		if (toposition != null) {
			tox = toposition.get("x");
			toy = toposition.get("y");
		}
		if(Integer.parseInt(startDirection) == 90 && Integer.parseInt(endDirection) == -90){
			newPoints = (fromx-50)+","+(fromy+5)+","+(tox+50)+","+(toy+5);
		}
		if(Integer.parseInt(startDirection) == 90 && Integer.parseInt(endDirection) == 0){
			//newPoints = (fromx)+","+(fromy)+","+(fromx)+","+(fromy+50)+","+(tox+50)+","+(toy)+","+(tox)+","+(toy);
			if(nodeLinkLineInfo.size() == 1){
				newPoints = (fromx+47)+","+(fromy+5)+","+(tox-50)+","+(toy+5);
			}else{
				newPoints = "";
			}
		}
		if(Integer.parseInt(startDirection) == 0){
			newPoints = (fromx)+","+(fromy+50)+","+(tox)+","+(toy-45);
		}
		if(Integer.parseInt(startDirection) == -90 && Integer.parseInt(endDirection) == 90){
			newPoints = (fromx+47)+","+(fromy+5)+","+(tox-50)+","+(toy+5);
		}
		if(Integer.parseInt(startDirection) == -1){
			newPoints = (fromx+47)+","+(fromy+5)+","+(tox-50)+","+(toy+5);
		}
		points = "";
	}
	
	line.put("newPoints", newPoints);
	line.put("points", points);
	line.put("ispass", ispass);
	lines.add(line);
}
//对数据做预处理 START
Iterator iterator = nodeDisInfo.iterator();
for(int icount=0; iterator.hasNext(); icount++) {
	Map bean = (Map)iterator.next();
	Map nodeBean = new HashMap();
	int nodetype = Util.getIntValue((String)bean.get("ntype")); //nodetype
	String nodeattribute = (String)bean.get("nodeattribute"); //nodeattribute
	int optType = ((Integer)bean.get("nodeType")).intValue(); //节点状态  0: 已通过  1: 当前 2:其它
	
	String nodeImageName = "";
	if (nodetype == 0) {
		nodeImageName = "c";  //起始节点
		if (isold) {
			nodeBean.put("width", 90);
			nodeBean.put("height", 90);
		} else {
			nodeBean.put("width", 82);
			nodeBean.put("height", 82);
		}
	} else if (nodetype == 1) {
		nodeImageName = "a";  //审批节点 
		if (isold) {
			nodeBean.put("width", 100);
			nodeBean.put("height", 90);
		} else {
			nodeBean.put("width", 100);
			nodeBean.put("height", 90);
		}
	} else if (nodetype == 2) {
		nodeImageName = "r";  //提交节点
		if (isold) {
			nodeBean.put("width", 100);
			nodeBean.put("height", 70);
		} else {
			nodeBean.put("width", 100);
			nodeBean.put("height", 62);
		}
	} else if (nodetype == 3) {
		nodeImageName = "p";  //归档节点
		
		if (isold) {
			nodeBean.put("width", 90);
			nodeBean.put("height", 90);
		} else {
			nodeBean.put("width", 82);
			nodeBean.put("height", 82);
		}
	}
	
	//图片说明：*1：未通过节点的
	//*2：当前节点的
	//*3：已通过过节点的
	if (optType == 1) {
		nodeImageName += "2_wev8.png";
	} else if (optType == 0) {
		nodeImageName += "3_wev8.png";
	} else {
		nodeImageName += ".png";
	}
	
	String nodeNotOperatorNames = "";
	String nodeViewNames = "";
	String nodeOperatorNames = "";
	List nodeNotOperatorNameList = null;
	
	if (optType == 2) {
		nodeNotOperatorNameList = (List)bean.get("nodeOperatorNameList"); //未操作者信息
	} else {
		nodeNotOperatorNameList = (List)bean.get("nodeNotOperatorNameList"); //未操作者信息
	}
	
	List nodeViewNameList = (List)bean.get("nodeViewNameList"); //查看者信息
	List nodeOperatorNameList = (List)bean.get("nodeOperatorNameList");  //已操作者信息
	for (Iterator it=nodeNotOperatorNameList.iterator(); it.hasNext();) {
		nodeNotOperatorNames += it.next() + " ";
    }
	for (Iterator it=nodeOperatorNameList.iterator(); it.hasNext();) {
		nodeOperatorNames += it.next() + " ";
    }
	for (Iterator it=nodeViewNameList.iterator(); it.hasNext();) {
		nodeViewNames += it.next() + " ";
    }
	
	int x = ((int[])bean.get("nodeDecPoint"))[0] ;
	int y = ((int[])bean.get("nodeDecPoint"))[1];
	
	if (isold) {
		x = x- 30 -20;
		y = y - 30 - 10;
	} else {
		x = x - 30 - 20 + 2 + 3;
		y = y - 30 + 3 + 3;
	}
	if (x + 150 > maxWidth) {
		maxWidth = x + 150;
	}
	if (y + 150 > maxHeight) {
		maxHeight = y + 150;
	}
	
	//节点名称
	nodeBean.put("id", bean.get("nodeid"));
	nodeBean.put("nodeName", bean.get("nodeName"));
	nodeBean.put("x", x);
	nodeBean.put("y", y);
	nodeBean.put("operatorName", Util.null2String((String)bean.get("nodeOperatorName")));
	nodeBean.put("notOperatorNames", nodeNotOperatorNames);
	nodeBean.put("viewOperatorNames", nodeViewNames);
	nodeBean.put("operatorNames", nodeOperatorNames);
	nodeBean.put("imgName", nodeImageName);
	nodeBean.put("nodeType", nodetype);
	nodeBean.put("operatortType", optType);
	nodes.add(nodeBean);
}

//对数据做预处理 END

RecordSet rs = new RecordSet();
rs.execute("select * from workflow_groupinfo where workflowid=" + workflowid);

while (rs.next()) {
   	Map group = new HashMap();
   	//group.put("id", rs.getInt("id"));
   	//group.put("workflowid", rs.getInt("workflowid"));
   	group.put("text", Util.toXmlText(rs.getString("groupname")));
   	
   	int direction = rs.getInt("direction");
   	int x = rs.getInt("x");
   	int y = rs.getInt("y");
   	int width = rs.getInt("width");
   	int height = rs.getInt("height");
   	
   	if (direction == 0) {
		if (x + width > maxWidth) {
			maxWidth = x + width;
		}
		if (y + height > maxHeight) {
			maxHeight = y + height;
		}
	} else if (direction == 1) {
		if (y + height > maxHeight) {
			maxHeight = y + height;
		}
	} else if (direction == 2) {
		if (x + width > maxWidth) {
			maxWidth = x + width;
		}
	}
   	
   	group.put("direction", direction);
   	group.put("x", x);
   	group.put("y", y);
   	group.put("width", width);
   	group.put("height", height);
   	groups.add(group);
}


result.put("maxWidth", maxWidth);
result.put("maxHeight", maxHeight);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>