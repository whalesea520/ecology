
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.net.*"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.*" %>
<%@ page import="org.apache.commons.codec.binary.Base64"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.docs.news.*"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.mobile.plugin.ecology.service.AuthService"%>
<%@page import="weaver.mobile.plugin.ecology.service.DocumentService"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);
String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));
String detailid = Util.null2String(fu.getParameter("detailid"));
String pageindex = Util.null2String(fu.getParameter("pageindex"));
String pagesize = Util.null2String(fu.getParameter("pagesize"));

String keywordurl = Util.null2String(fu.getParameter("keyword"));
String keyword = URLDecoder.decode(keywordurl, "UTF-8");

String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String setting = Util.null2String(fu.getParameter("setting"));
String mconfig = Util.null2String(fu.getParameter("config"));
int hrmorder = Util.getIntValue(fu.getParameter("_hrmorder_"), 0);

//-------------------------------------------
// mobile6.0新增接口参数 startr
//-------------------------------------------
//待办是否包含抄送(1)
int showcopy = Util.getIntValue(Util.null2String(fu.getParameter("showcopy")), 0);
//已办是否包含办结(1)
int showcompele = Util.getIntValue(Util.null2String(fu.getParameter("showcompele")), 0);
//流程时间排序规则：0：倒序， 1：正序
int wforder = Util.getIntValue(Util.null2String(fu.getParameter("wforder")), 0);
//是否需要获取流程类型集合
int isneedgetwfids = Util.getIntValue(Util.null2String(fu.getParameter("isneedgetwfids")), 0);

//流程ID
int workflowid = Util.getIntValue(Util.null2String(fu.getParameter("workflowid")), 0);

//流程类型ID
int workflowtypeid = Util.getIntValue(Util.null2String(fu.getParameter("workflowtypeid")), 0);

//流程归档状态：1：全部， 2：未归档， 3：已归档
int archivestatus = Util.getIntValue(Util.null2String(fu.getParameter("archivestatus")), 1);
//流程编号
String requestmark = Util.null2String(fu.getParameter("requestmark"));
//创建人ID
int createid = Util.getIntValue(Util.null2String(fu.getParameter("createid")), 0);
//创建人类型
int createtype = Util.getIntValue(Util.null2String(fu.getParameter("createtype")), 0);
//起始和结束创建日期， 格式：yyyy-MM-dd
String createdatestart = Util.null2String(fu.getParameter("createdatestart"));
String createdateend = Util.null2String(fu.getParameter("createdateend"));
//-------------------------------------------
// mobile6.0新增接口参数 end
//-------------------------------------------

// mobile6.0 新增接口：流程选择框 start
boolean isBrow = (1 == Util.getIntValue(Util.null2String(fu.getParameter("isbrow")), 0));
boolean isAllWf = (1 == Util.getIntValue(Util.null2String(fu.getParameter("isallwf")), 0));
if (isBrow) {
    setting = "";
    scope = "-1";
    
    if (isAllWf) {
        module = "-9";
    }
}
//mobile6.0 新增接口：流程选择框 end

//因客户端使用GBK编码，故需要转码。
//keyword = new String(keyword.getBytes("iso8859-1"), "UTF-8");

if(ps.verify(sessionkey)) {
	
	List conditions = new ArrayList();
	
	String listtypeidcondition = "";
	
	if(StringUtils.isNotEmpty(setting)) {
		if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")  || module.equals("-1004") || module.equals("-1005")) {
			String condition = "";
			String cfgstr = setting;
			cfgstr = cfgstr.startsWith(",")?cfgstr.substring(1):cfgstr;
			if(StringUtils.isNotEmpty(cfgstr)) {
				String strSubClause = Util.getSubINClause(WorkflowVersion.getAllVersionStringByWFIDs(cfgstr), "t1.workflowid", "IN");
				if("".equals(condition)){
					 condition += strSubClause;
				} else {
					 condition += " or " + strSubClause;
				}
				if (condition != null && !"".equals(condition)) {
					condition = " (" + condition + ") ";
				}
				//保存基础条件
				listtypeidcondition = condition;
				conditions.add(condition);
			}
		} else if(module.equals("2")||module.equals("3")) {
			String where =DocumentService.getWheresBySettings(setting);
			if(where!=null&&!where.trim().equals("")){
				conditions.add(where);
			}
		}
	}
	
	Map result = new HashMap();
	
	if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")||module.equals("-9") ||module.equals("-1004")||module.equals("-1005")) {
		if(StringUtils.isNotEmpty(keyword)) {
			conditions.add(" (t1.requestnamenew like '%" + keyword + "%') ");
		}
		
		if(StringUtils.isNotEmpty(detailid)) {
			conditions.add(" (t1.requestid = "+detailid+") ");
		}
	
		//-------------------------------------------
		// mobile6.0新增查询条件 start
		//-------------------------------------------
		
		//添加工作流过滤
	    if (workflowid > 0) {
	        String strSubClause = Util.getSubINClause(WorkflowVersion.getAllVersionStringByWFIDs(workflowid + ""), "t1.workflowid", "IN");
	        conditions.add(strSubClause);
        }else if (workflowid < 0) {
	        String strSubClause = Util.getSubINClause(workflowid + "", "t1.workflowid", "IN");
	        conditions.add(strSubClause);
        }
		
	  	//添加工作流类型过滤
	    if (workflowtypeid > 0) {
	        String strSubClause = " t1.workflowid in (select id from workflow_base where  ";
			//流程类型=
			strSubClause += " workflowtype=" + workflowtypeid + ") ";
			conditions.add(strSubClause);
	    }else if (workflowtypeid < 0){
	    	 String strSubClause = " t1.workflowid in (select workflowid from ofs_workflow where  ";
				//流程类型=
			strSubClause += " sysid=" + workflowtypeid + ") ";
			conditions.add(strSubClause);
	    }
	  	//流程归档状态
	  	if ((module.equals("8") || module.equals("9")) && archivestatus > 1) {
	  		//未归档
	  	    if (archivestatus == 2) {
	  	  		conditions.add(" t1.currentnodetype <> 3 ");
	  	    }
	  		//已归档
	  	    if (archivestatus == 3) {
	  	  		conditions.add(" t1.currentnodetype = 3 ");
	  	    }
	  	}
	  	
	  	//流程编号
	  	if (!"".equals(requestmark)) {
	  	  conditions.add(" t1.requestmark like '%" + requestmark + "%' ");
	  	}
	  	
	  	//创建人
		if (createid > 0) {
		    conditions.add(" t1.creater=" + createid + " and t1.creatertype=" + createtype + " ");
		}
	  	
		//创建起始日期
		if (!"".equals(createdatestart)) {
		    conditions.add(" t1.createdate>='" + createdatestart + "' ");
		}
		
		//创建结束日期
		if (!"".equals(createdateend)) {
		    conditions.add(" t1.createdate<='" + createdateend + "' ");
		}
		
		//-------------------------------------------
		// mobile6.0新增查询条件 end
		//-------------------------------------------
		
		//-------------------------------------------------------
		// mobile6.0新增接口（待办包含抄送，已办包含办结） start
		//-------------------------------------------------------
		Map<String, String> otherParaMap = new HashMap<String, String>();
		otherParaMap.put("isshowcopy", String.valueOf(showcopy));
		otherParaMap.put("isshowprocessed", String.valueOf(showcompele));
		otherParaMap.put("isneedgetwfids", String.valueOf(isneedgetwfids));
		otherParaMap.put("order", String.valueOf(wforder));
		
		otherParaMap.put("listtypeidcondition", listtypeidcondition);
		
		otherParaMap.put("isbrow", Util.null2String(Util.null2String(fu.getParameter("isbrow"))));
		//-------------------------------------------------------
		// mobile6.0新增接口（待办包含抄送，已办包含办结） end
		//-------------------------------------------------------
		//result = (Map) ps.getWorkflowList(Util.getIntValue(module), Util.getIntValue(scope), conditions, Util.getIntValue(pageindex), Util.getIntValue(pagesize), sessionkey);
		result = (Map) ps.getWorkflowList(Util.getIntValue(module), Util.getIntValue(scope), conditions, Util.getIntValue(pageindex), Util.getIntValue(pagesize), sessionkey, otherParaMap);
	}
	
	if(module.equals("2")||module.equals("3")) {
		if(StringUtils.isNotEmpty(keyword)) {
			conditions.add(" (docsubject like '%"+keyword+"%') ");
		}
		
		if(StringUtils.isNotEmpty(detailid)) {
			conditions.add(" (id = "+detailid+") ");
		}

		result = ps.getDocumentList(conditions, Util.getIntValue(pageindex), Util.getIntValue(pagesize), sessionkey);
	}
	
	if(module.equals("6")) {
		if(StringUtils.isNotEmpty(keyword)) {
			conditions.add(" (lastname like '%"+keyword+"%' or pinyinlastname like '%"+keyword+"%' or workcode like '%"+keyword+"%' or mobile like '%"+keyword+"%' or telephone like '%"+keyword+"%') ");
		}
		
		if(StringUtils.isNotEmpty(detailid)) {
			conditions.add(" (id = "+detailid+") ");
		}

		result = ps.getUserList(conditions, Util.getIntValue(pageindex), Util.getIntValue(pagesize), hrmorder, sessionkey);
	}
	
	String key = "list";

	if(result!=null&&result.get("list")!=null) {
		
		List<Map<String,Object>> list = (List<Map<String,Object>>) result.get("list");

		if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")||module.equals("-9") ||module.equals("-1004") ||module.equals("-1005")) {
			List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> d:list) {
				Map<String,Object> newdata = new HashMap<String,Object>();
				
				String time = StringUtils.defaultIfEmpty((String) d.get("recivetime"),"");
				String image = StringUtils.defaultIfEmpty((String) d.get("creatorpic"),"");
				String id = StringUtils.defaultIfEmpty((String) d.get("wfid"),"");
				String isnew = StringUtils.defaultIfEmpty((String) d.get("isnew"),"");
				String subject = StringUtils.defaultIfEmpty((String) d.get("wftitle"),"").replace("&quot;", "\"");
				String description = "" +
									 "[" + StringUtils.defaultIfEmpty((String) d.get("wftype"),"") + "]" +
									 "   接收时间 : " + StringUtils.defaultIfEmpty((String) d.get("recivetime"),"") +
									 "   流程状态 : " + StringUtils.defaultIfEmpty((String) d.get("status"),"") +
									 "   创建人 : " + StringUtils.defaultIfEmpty((String) d.get("creator"),"") +
									 "   创建时间 : " + StringUtils.defaultIfEmpty((String) d.get("createtime"),"");
				
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", Util.toHtmlMode(subject));
				newdata.put("description", description);
				
				//------------------------------------------
				// mobile6.0 说明拆分为单个对象 start
				//------------------------------------------
				newdata.put("wftype", StringUtils.defaultIfEmpty((String) d.get("wftype"),""));
				newdata.put("recivetime", StringUtils.defaultIfEmpty((String) d.get("recivetime"),""));
				newdata.put("status", StringUtils.defaultIfEmpty((String) d.get("status"),""));
				newdata.put("creator", StringUtils.defaultIfEmpty((String) d.get("creator"),""));
				newdata.put("createtime", StringUtils.defaultIfEmpty((String) d.get("createtime"),""));
				
				newdata.put("canmultisubmit", StringUtils.defaultIfEmpty((String) d.get("canMultiSubmit"),""));
				//创建人ID
				newdata.put("creatorid", StringUtils.defaultIfEmpty((String) d.get("creatorid"),""));
				//------------------------------------------
				// mobile6.0 说明拆分为单个对象 end
				//------------------------------------------
				
				//添加流程表单签名信息
				newdata.put("formsignaturemd5", StringUtils.defaultIfEmpty((String) d.get("formsignaturemd5"), ""));
				if(module.equals("-1004")){
				    newdata.put("isurge","1");
				}
				if(module.equals("-1005")){
				    newdata.put("ismonitor","1");
				}
				
				//手机签字意见的， 1 代表  不需要客户端显示 意见了，
				newdata.put("hassign","1");
				newdata.put("url", StringUtils.defaultIfEmpty((String) d.get("appurl"),""));//####
				//主次账号统一显示
                String f_weaver_belongto_userid = StringUtils.defaultIfEmpty((String) d.get("f_weaver_belongto_userid"),"");
                newdata.put("f_weaver_belongto_userid", f_weaver_belongto_userid);
                String f_weaver_belongto_usertype = StringUtils.defaultIfEmpty((String) d.get("f_weaver_belongto_usertype"),"");
                newdata.put("f_weaver_belongto_usertype", f_weaver_belongto_usertype);
				newlist.add(newdata);
			}
			result.put(key,newlist);
		} else if(module.equals("2")||module.equals("3")) {
			AuthService as = new AuthService();
			User user = as.getCurrUser(sessionkey);
			List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> d:list) {
				Map<String,Object> newdata = new HashMap<String,Object>();
				
				String time = StringUtils.defaultIfEmpty((String) d.get("modifytime"),"");
				String image = StringUtils.defaultIfEmpty((String) d.get("docimg"),"");
				String id = StringUtils.defaultIfEmpty((String) d.get("docid"),"");
				String isnew = StringUtils.defaultIfEmpty((String) d.get("isnew"),"");
				String subject = StringUtils.defaultIfEmpty((String) d.get("docsubject"),"");
				String description = "" +
									 "   "+SystemEnv.getHtmlLabelName(79,user.getLanguage())+" : " + StringUtils.defaultIfEmpty((String) d.get("owner"),"") +
									 "   "+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+" : " + StringUtils.defaultIfEmpty((String) d.get("createtime"),"") +
									 "   "+SystemEnv.getHtmlLabelName(26805,user.getLanguage())+" : " + StringUtils.defaultIfEmpty((String) d.get("modifytime"),"");
				
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", subject);
				newdata.put("description", description);

                //手机签字意见的， 1 代表  不需要客户端显示 意见了，
                newdata.put("hassign","1");

                //主次账号统一显示
                String f_weaver_belongto_userid = StringUtils.defaultIfEmpty((String) d.get("f_weaver_belongto_userid"),"");
                newdata.put("f_weaver_belongto_userid", f_weaver_belongto_userid);
                String f_weaver_belongto_usertype = StringUtils.defaultIfEmpty((String) d.get("f_weaver_belongto_usertype"),"");
                newdata.put("f_weaver_belongto_usertype", f_weaver_belongto_usertype);
                
				newlist.add(newdata);
			}
			result.put(key,newlist);
		} else if(module.equals("6")) {
			List<Map<String,Object>> newlist = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> d:list) {
				Map<String,Object> newdata = new HashMap<String,Object>();
				
				String time = "";
				String image = StringUtils.defaultIfEmpty((String) d.get("msgerurl"),"");
				String id = StringUtils.defaultIfEmpty((String) d.get("id"),"");
				String isnew = "";
				String subject = StringUtils.defaultIfEmpty((String) d.get("lastname"),"");
				String description = "" +
									 " [" + StringUtils.defaultIfEmpty((String) d.get("jobtitle"),"") + "]" +
									 " " + StringUtils.defaultIfEmpty((String) d.get("dept"),"") + " / " +
									 "" + StringUtils.defaultIfEmpty((String) d.get("subcom"),"");
				
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", subject);
				newdata.put("description", description);
				
                //手机签字意见的， 1 代表  不需要客户端显示 意见了，
                newdata.put("hassign","1");

                //主次账号统一显示
                String f_weaver_belongto_userid = StringUtils.defaultIfEmpty((String) d.get("f_weaver_belongto_userid"),"");
                newdata.put("f_weaver_belongto_userid", f_weaver_belongto_userid);
                String f_weaver_belongto_usertype = StringUtils.defaultIfEmpty((String) d.get("f_weaver_belongto_usertype"),"");
                newdata.put("f_weaver_belongto_usertype", f_weaver_belongto_usertype);
                
				newlist.add(newdata);
			}
			result.put(key,newlist);
		}
		
	}	
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>