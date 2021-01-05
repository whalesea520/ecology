<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fullsearch.EAssistantMsg"%>
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

response.setContentType("application/json;charset=UTF-8");
FileUpload fu = new FileUpload(request);
Map result = new HashMap();
String type = Util.null2String(fu.getParameter("type"));
String userId=user.getUID()+"";
//获取待处理数据
if("getTodoList".equals(type)){
	RecordSet rs=new RecordSet();
	List<Map<String,String>> list=new LinkedList<Map<String,String>>();
	ResourceComInfo rci=new ResourceComInfo();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		rs.execute("select * from Fullsearch_E_Faq where status=0 order by createdate desc,createtime desc");
		Map<String,String> map=null;
		String checkOutId="";
		while(rs.next()){
			map=new HashMap<String,String>();
			map.put("id",rs.getString("id"));
			map.put("ask",rs.getString("ask"));
			map.put("createrId",rs.getString("createrId"));
			map.put("createrName",rci.getLastname(rs.getString("createrId")));
			map.put("commitTag",rs.getString("commitTag"));
			checkOutId=rs.getString("checkOutId");
			if("".equals(checkOutId)||"0".equals(checkOutId)){
				map.put("checkOutName","我来处理");
				map.put("canDo","true");
			}else{
				if(userId.equals(checkOutId)){
					map.put("canDo","true");
					map.put("checkOutName","我在处理中");
				}else{
					map.put("checkOutName",rci.getLastname(checkOutId)+"正在处理");
					map.put("canDo","false");
				}
			}
			map.put("createdate",rs.getString("createdate"));
			map.put("createtime",rs.getString("createtime"));
			map.put("commitTag",rs.getString("commitTag"));
			list.add(map);
		}
	}
	result.put("list",list);
	result.put("count",list.size());
}else if("getFinishList".equals(type)){
	RecordSet rs=new RecordSet();
	List list=new LinkedList();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	result.put("hasnext",false);
	result.put("pageno", 1);
	if(rs.next()){
		int pageno = Util.getIntValue(fu.getParameter("pageno"));
		int pagesize = Util.getIntValue(fu.getParameter("pagesize"));
		String timeSag = Util.null2String(fu.getParameter("timeSag"));
		String targetFlag = Util.null2String(fu.getParameter("targetFlag"));
		String keyword = Util.null2String(fu.getParameter("keyword"));
		pageno = pageno==-1?1:pageno;
		pagesize = pagesize==-1?10:pagesize;
		String backfields = "t1.*";
		String sqlFrom = "Fullsearch_E_Faq t1 ";
		String sqlWhere = "where status=1 and targetFlag in(0,1,2,3,4)";
		 
		if(!"".equals(keyword)){
			sqlWhere += " and t1.ask like '%" + keyword + "%'";
		}
		if(!"".equals(targetFlag)){
			sqlWhere += " and t1.targetFlag = '" + targetFlag + "'";
		}
		String begindate=TimeUtil.getDateByOption(timeSag,"0");
		String enddate=TimeUtil.getDateByOption(timeSag,"1");
		if(!"".equals(begindate)){
			sqlWhere += " and t1.processdate >= '" + begindate + "'";
		}
		if(!"".equals(enddate)){
			sqlWhere += " and t1.processdate <= '" + enddate + "'";
		}
		
		ResourceComInfo rci=new ResourceComInfo();
		
		SplitPageUtil spu = new SplitPageUtil();
		SplitPageParaBean spp = new SplitPageParaBean();
		Map<String, Integer> orderByMap = new LinkedHashMap<String, Integer>();
		
		orderByMap.put("processdate", spp.DESC);
		orderByMap.put("processtime", spp.DESC);
		spp.setOrderByMap(orderByMap);
		spp.setBackFields(backfields);
		spp.setSqlFrom(sqlFrom);
		spp.setSqlWhere(sqlWhere);
		spp.setPrimaryKey("t1.id");
		//spp.setIsPrintExecuteSql(true);
		spp.setSqlOrderBy("processdate,processtime");
		spp.setSortWay(spp.DESC);
		spp.setSqlWhere(sqlWhere);		
		spu.setSpp(spp);
		
		RecordSet recordSet = spu.getCurrentPageRs(pageno, pagesize);
		Map map=null;
		String dataTargetFlag="";
		while(recordSet.next()){
			map=new HashMap();
			map.put("id",recordSet.getString("id"));
			map.put("ask",recordSet.getString("ask"));
			map.put("createrId",recordSet.getString("createrId"));
			map.put("createrName",rci.getLastname(recordSet.getString("createrId")));
			map.put("createdate",recordSet.getString("createdate"));
			map.put("createtime",recordSet.getString("createtime"));
			map.put("processdate",recordSet.getString("processdate"));
			map.put("processtime",recordSet.getString("processtime"));
			map.put("processName",rci.getLastname(recordSet.getString("processId")));
			map.put("commitTag",recordSet.getString("commitTag"));
			dataTargetFlag=recordSet.getString("targetFlag");
			if("1".equals(dataTargetFlag)){
				dataTargetFlag= "录入问题库";
			}else if("2".equals(dataTargetFlag)){
				dataTargetFlag= "待完善语义";
			}else if("3".equals(dataTargetFlag)){
				dataTargetFlag= "已完善语义";
			}else if("4".equals(dataTargetFlag)){
				dataTargetFlag= "忽略";
			}else{
				dataTargetFlag="";
			} 
			map.put("targetFlag",dataTargetFlag);
			list.add(map);
		}
		result.put("hasnext", list.size() == pagesize ? true : false);
		result.put("pageno", pageno);
	}
	 
	result.put("list",list);
	result.put("count",list.size());
	
}else if("getInfo".equals(type)){//检查问题是否被占用.同时占用.
	boolean checkResut=false;
	boolean needHide=false;
	String msg="";
	RecordSet rs=new RecordSet();
	int checkOutId=0;
	ResourceComInfo rci=new ResourceComInfo();
	Map<String,String> obj=new HashMap<String,String>();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.null2String(fu.getParameter("faqId"));
		rs.execute("select * from Fullsearch_E_Faq where id="+faqId);
		if(rs.next()){
			int status=rs.getInt("status");
			checkOutId=rs.getInt("checkOutId");
			
			obj.put("id",rs.getString("id"));
			obj.put("ask",rs.getString("ask"));
			obj.put("answer",rs.getString("answer"));
			obj.put("createrName",rci.getLastname(rs.getString("createrId")));
			obj.put("createdate",rs.getString("createdate"));
			obj.put("createtime",rs.getString("createtime"));
			obj.put("processdate",rs.getString("processdate"));
			obj.put("processtime",rs.getString("processtime"));
			obj.put("processName",rci.getLastname(rs.getString("processId")));
			obj.put("commitTag",rs.getString("commitTag"));
			String dataTargetFlag=rs.getString("targetFlag");
			dataTargetFlag=rs.getString("targetFlag");
			if("1".equals(dataTargetFlag)){
				dataTargetFlag= "录入问题库";
			}else if("2".equals(dataTargetFlag)){
				dataTargetFlag= "待完善语义";
			}else if("3".equals(dataTargetFlag)){
				dataTargetFlag= "已完善语义";
			}else if("4".equals(dataTargetFlag)){
				dataTargetFlag= "忽略";
			}else{
				dataTargetFlag="";
			} 
			obj.put("targetFlag",dataTargetFlag);
			obj.put("status",status+"");			
			if(status==1){
				needHide=true;
				msg="问题已处理";
				checkResut=true;
				//是否是问题库.
				int faqTargetId=Util.getIntValue(rs.getString("faqTargetId"),0);
				if(faqTargetId>0){
					rs.execute("select faqDesc from fullSearch_FaqDetail where id="+faqTargetId);
					if(rs.next()){
						obj.put("answer","问题库：<a href='/mobile/plugin/fullsearch/ViewFaqDetailLib.jsp?faqId="+faqTargetId+"'>"+rs.getString("faqDesc")+"</a>");
					}
				}
				//转化问法
				if(!"".equals(rs.getString("changeAsk"))){
					obj.put("answer","转化问法："+rs.getString("changeAsk"));
				}
			}else{
				if(checkOutId==0){
					rs.execute("update Fullsearch_E_Faq set checkOutId="+userId+" where status=0 and id="+faqId+" and checkOutId=0");
					rs.execute("select checkOutId from Fullsearch_E_Faq where status=0 and id="+faqId);
					if(rs.next()){
						checkOutId=rs.getInt(1);
						if(user.getUID()==checkOutId){
							checkResut=true;
						}else{
							msg=rci.getLastname(checkOutId+"")+"正在处理";
						}
					}
				}else if(checkOutId==user.getUID()){
					checkResut=true;
				}else{
					msg=rci.getLastname(checkOutId+"")+"正在处理";
				}
			}
		}else{
			msg="参数无效";
		}
	}else{
		msg="没有权限";
	}
	result.put("msg",msg);
	result.put("checkResut",checkResut);
	result.put("needHide",needHide);
	result.put("obj",obj);
}else if("unDoCheckOut".equals(type)){//释放
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.null2String(fu.getParameter("faqId"));
		if(!"".equals(faqId)){
			rs.execute("update Fullsearch_E_Faq set checkOutId="+0+" where id="+faqId+" and checkOutId="+userId);
		}
	}
	result.put("result","success");
}else if("changeTargetFlag".equals(type)){//变更标识
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.null2String(fu.getParameter("faqId"));
		String targetFlag = Util.null2String(fu.getParameter("targetFlag"));
		if(!"".equals(faqId)&&!"".equals(targetFlag)){
			if("4".equals(targetFlag)){
				rs.execute("update Fullsearch_E_Faq set status=1,targetFlag=4,processdate='"+TimeUtil.getCurrentDateString()+"',processtime='"+TimeUtil.getOnlyCurrentTimeString()+"',processId="+userId+" where id="+faqId);
			}else if("-1".equals(targetFlag)){
				rs.execute("delete from Fullsearch_E_Faq where id="+faqId);
			}else{
				rs.execute("update Fullsearch_E_Faq set targetFlag="+targetFlag+" where id="+faqId);
			}
		}
	}
	result.put("result","success");
}else if("sendEMsg".equals(type)){//发送消息
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.getIntValue(fu.getParameter("faqId"),0)+"";
		String answer = Util.null2String(fu.getParameter("answer"));
		int faqTargetId = Util.getIntValue(fu.getParameter("faqTargetId"),0);
		rs.execute("select checkOutId from Fullsearch_E_Faq where id="+faqId);
		if(rs.next()){
			if(faqTargetId>0){
				answer="";
			}
			rs.execute("update Fullsearch_E_Faq set status=1,sendReply=1,readFlag=0,answer='"+answer+"',faqTargetId="+faqTargetId+",processdate='"+TimeUtil.getCurrentDateString()+"',processtime='"+TimeUtil.getOnlyCurrentTimeString()+"',processId="+userId+" where id="+faqId);
			//发送问题发起人
			EAssistantMsg.noticeCreater(faqId);
		}
	}
	result.put("result","success");
}else if("changeAsk".equals(type)){//转化问法
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.getIntValue(fu.getParameter("faqId"),0)+"";
		String answer = Util.null2String(fu.getParameter("answer"));
		rs.execute("update Fullsearch_E_Faq set status=1,sendReply=1,readFlag=0,targetFlag=4,changeAsk='"+answer+"',processdate='"+TimeUtil.getCurrentDateString()+"',processtime='"+TimeUtil.getOnlyCurrentTimeString()+"',processId="+userId+" where id="+faqId);
		//发送问题发起人
		EAssistantMsg.noticeCreater(faqId);
	}
	result.put("result","success");
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>