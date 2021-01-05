
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.mobile.webservices.workflow.*" %>
<%@page import="net.sf.json.JSONObject"%>

<jsp:useBean id="wsi" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="page"/>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
FileUpload fu = new FileUpload(request);

String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));
String title = Util.null2String((String)fu.getParameter("title"));
String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

//现已将提交请求方式修改为post，故不需要解码。
String keyword = Util.null2String((String)fu.getParameter("keyword"));

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

char flag=Util.getSeparator() ;

String[] conditions = new String[2];
conditions[0] = keyword;
conditions[1] = weaver.mobile.plugin.ecology.RequestOperation.AVAILABLE_WORKFLOW;


//20151201 多账号对应 Start
//WorkflowExtInfo[] wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
String belongtoshow = user.getBelongtoshowByUserId(user.getUID());
WorkflowExtInfo[] wbis;
if("1".equals(belongtoshow)){
    wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions,true);
}else{
    wbis = wsi.getCreateWorkflowList(0, 99999999, 0, user.getUID(), 0, conditions);
}

//20151201 多账号对应 End

Map<String, List<Map<String, String>>> createwfkv = new LinkedHashMap<String, List<Map<String, String>>>();
List<Map<String,String>> typeList = new ArrayList<Map<String,String>>();
String wtid = "";
String orderid = "";
for(int i=0;wbis!=null&&i<wbis.length;i++) { 
	String typename = wbis[i].getWorkflowTypeName();
	String wfid = wbis[i].getWorkflowId();
	String wfname = wbis[i].getWorkflowName();
	orderid = wbis[i].getWorkflowDsOrder();
	String f_weaver_belongto_userid = wbis[i].getF_weaver_belongto_userid();
    String f_weaver_belongto_usertype = wbis[i].getF_weaver_belongto_usertype();
	//String url = "/mobile/plugin/1/client.jsp?workflowid=" + wfid + "&method=create&module=" +  module + "&scope=" + scope + "&clienttype=" + clienttype + "&clientlevel=" + clientlevel;
    String url = "/mobile/plugin/1/client.jsp?workflowid=" + wfid + "&method=create&module=" +  module + "&scope=" + scope + "&clienttype=" + clienttype + "&clientlevel=" + clientlevel + "&f_weaver_belongto_userid=" + f_weaver_belongto_userid + "&f_weaver_belongto_usertype=" + f_weaver_belongto_usertype;
	
	
	
	if (i == 0) {
		createwfkv.put(wtid, typeList);
	}
	
	if(!wbis[i].getWorkflowTypeId().equals(wtid)) {
		typeList = new ArrayList<Map<String,String>>();
		createwfkv.put(wtid, typeList);
		
		wtid = wbis[i].getWorkflowTypeId();
	}
	
	
	Map<String, String> item = new LinkedHashMap<String, String>();
	item.put("id", wfid);
	item.put("name", wfname);
	item.put("url", url);
	item.put("typename", typename);
	
	typeList.add(item);
}

JSONObject jo = JSONObject.fromObject(createwfkv);
String result = jo.toString();
if(!"".equals(result)){
	result = result.replace("&nbsp;"," ");
}
out.println(result);
%>

