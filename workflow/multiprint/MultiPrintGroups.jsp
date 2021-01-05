<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.*,net.sf.json.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />

<%--
此页面为点击批量打印后的中间处理页面，将所有请求按照当前所处的节点分组，每个分组打开一个打印的窗口
--%>

<%!
    /**
    * 根据流程id，节点id获取当前页面的打印方式，仅限于模板模式
    */
	private int getModeid(String workflowid,String nodeid){
		int isbill = 0;
		int modeid=0;
		int printdes=0;
		String formid = "";
		String ismode="";
		String sql = "select * from workflow_base where id="+workflowid;
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		if(rs.next()){
			isbill = Util.getIntValue(rs.getString("isbill"), 0);
			formid = Util.null2String(rs.getString("formid"));
		}
		
		sql = "select ismode,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid;
		rs.executeSql(sql);
		if(rs.next()){
			ismode=Util.null2String(rs.getString("ismode"));
			printdes=Util.getIntValue(Util.null2String(rs.getString("printdes")),0);
		}
		if(printdes != 1){
			sql = "select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid;
			rs.executeSql(sql);
			if(rs.next()){
				modeid=rs.getInt("id");
			}else{
				sql = "select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc";
				rs.executeSql(sql);
				while(rs.next()){
					if(modeid < 1){
						modeid = rs.getInt("id");
					}
				}
			}
		}
		return modeid;
	}

	private int getHtmlModeid(String workflowid,String nodeid){
		String sql = " select id from workflow_nodehtmllayout "
				   + " where isactive=1 and workflowid = " + workflowid + " and nodeid = " + nodeid + " and type = '1'";
		RecordSet rs = new RecordSet();
		int modeid = -1;
		rs.executeSql(sql);
		if(rs.next()){
			modeid = rs.getInt("id");
		}
		return modeid;
	}
	
%>

<%

	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	String multirequestid = Util.null2String(request.getParameter("multirequestid"));
	List<String> modeList = new ArrayList<String>();  //模板模式
	//List<String> reqList = new ArrayList<String>();   //html模式
	Map<String,String> reqMap = new HashMap<String,String>();  //html模式
	
	Map result = new HashMap();
	if(!"".equals(multirequestid)){
		multirequestid = multirequestid + "0";
		String sql = "select requestid,workflowid from workflow_requestbase where requestid in (" + multirequestid + ")";
		recordSet.executeSql(sql);
		int userid = user.getUID();
		int logintype = Util.getIntValue(user.getLogintype(),1);
		
		while(recordSet.next()){
			String workflowid = recordSet.getString("workflowid");
			int reqid = recordSet.getInt("requestid");
			int nodeid = WFLinkInfo.getCurrentNodeid(reqid,userid,logintype);    //当前人员最后操作的节点
			int modeid = getModeid(workflowid,nodeid+"");   //取模板模式的打印模板id
			if(modeid > 0){
				modeList.add(reqid + "");
			}else{
				modeid = getHtmlModeid(workflowid,nodeid+"");    //取html模式的打印模板id
				if(modeid > 0){
					String groupid = workflowid + "-" + nodeid;
					if(reqMap.containsKey(groupid)){
						String reqids = reqMap.get(groupid);
						reqids += reqid + ",";
						reqMap.put(groupid,reqids);
					}else{
						reqMap.put(groupid,reqid+",");
					}
					//reqList.add(reqid + "");
				}
			}
		}	
		
		int msize = modeList.size();
		String htmlreqids = "";
		String modereqids = "";
		for(int i = 0; i < msize; i++){
			modereqids += modeList.get(i) + ",";
		}
		
		if(msize > 0){
			result.put("modereqids",modereqids);
		}
		
		if(!reqMap.isEmpty()){   //html模式打印
			result.put("htmlreqids",reqMap);
		}
		JSONObject jsobject = JSONObject.fromObject(result);
		out.print(jsobject.toString());
	}
%>