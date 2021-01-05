<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fullsearch.EAssistantMsg"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
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
		while(rs.next()){
			map=new HashMap<String,String>();
			map.put("id",rs.getString("id"));
			map.put("ask",rs.getString("ask"));
			map.put("createrId",rs.getString("createrId"));
			map.put("createrName",rci.getLastname(rs.getString("createrId")));
			map.put("checkOutId",rs.getString("checkOutId"));
			map.put("checkOutName",rci.getLastname(rs.getString("checkOutId")));
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
		String sqlWhere = "where status=1";
		 
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
		result.put("totailcount",spu.getRecordCount());
		Map map=null;
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
			map.put("commitTag",recordSet.getString("commitTag"));
			map.put("targetFlag",recordSet.getString("targetFlag"));
			list.add(map);
		}
		result.put("hasnext", list.size() == pagesize ? true : false);
		result.put("pageno", pageno);
	}
	
	result.put("list",list);
	result.put("count",list.size());
	
}else if("checkOut".equals(type)){//检查问题是否被占用.同时占用
	boolean checkResut=false;
	boolean needHide=false;
	String msg="";
	RecordSet rs=new RecordSet();
	int checkOutId=0;
	ResourceComInfo rci=new ResourceComInfo();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.null2String(fu.getParameter("faqId"));
		rs.execute("select checkOutId,status from Fullsearch_E_Faq where id="+faqId);
		if(rs.next()){
			int status=rs.getInt("status");
			checkOutId=rs.getInt("checkOutId");
			if(status==1){
				needHide=true;
				msg=SystemEnv.getHtmlLabelName(130386,user.getLanguage());
			}else{
				if(checkOutId==0){
					rs.execute("update Fullsearch_E_Faq set checkOutId="+userId+" where status=0 and id="+faqId+" and checkOutId=0");
					rs.execute("select checkOutId from Fullsearch_E_Faq where status=0 and id="+faqId);
					if(rs.next()){
						checkOutId=rs.getInt(1);
						if(user.getUID()==checkOutId){
							checkResut=true;
						}else{
							msg=rci.getLastname(checkOutId+"")+SystemEnv.getHtmlLabelName(125473,user.getLanguage());
						}
					}
				}else if(checkOutId==user.getUID()){
					checkResut=true;
				}else{
					msg=rci.getLastname(checkOutId+"")+SystemEnv.getHtmlLabelName(125473,user.getLanguage());
				}
			}
		}else{
			msg=SystemEnv.getHtmlLabelNames("561,2245",user.getLanguage());
		}
	}else{
		msg=SystemEnv.getHtmlLabelName(2011,user.getLanguage());
	}
	
	result.put("checkOutId",checkOutId);
	result.put("msg",msg);
	result.put("checkResut",checkResut);
	result.put("needHide",needHide);
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
			if("4".equals(targetFlag)||"2".equals(targetFlag)){
				rs.execute("update Fullsearch_E_Faq set status=1,targetFlag="+targetFlag+",processdate='"+TimeUtil.getCurrentDateString()+"',processtime='"+TimeUtil.getOnlyCurrentTimeString()+"',processId="+userId+" where id="+faqId);
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
}else if("addOtherAskToFAQ".equals(type)){//增加其他问法到问题库,同时更新标识.
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.null2String(fu.getParameter("faqId"));//小e FAQ
		String addFaqId = Util.null2String(fu.getParameter("addFaqId"));//插入FAQ
		String otherAsk = Util.null2String(fu.getParameter("otherAsk"));
		String oldAsk="";
		rs.execute("select faqLabel from fullSearch_FaqDetail where id="+addFaqId);
		if(rs.next()){
			oldAsk=rs.getString("faqLabel");
		}
		oldAsk+=" "+otherAsk;
		rs.execute("update fullSearch_FaqDetail set faqLabel='"+oldAsk+"' where id="+addFaqId);
		String updLogSql = "INSERT INTO  INDEXUPDATELOG (DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES ("+addFaqId+",'FAQ','UPDATE','"+ TimeUtil.getCurrentDateString()+" "+ TimeUtil.getOnlyCurrentTimeString() +"','"+TimeUtil.getCurrentDateString()+"',0) ";
		if("oracle".equals(rs.getDBType())){
    		updLogSql = "INSERT INTO  INDEXUPDATELOG (ID,DOCID,CTYPE,MODTYPE,CREATETIME,DOCCREATEDATE,DONEFLAG) VALUES (indexupdatelog_Id.nextval,"+addFaqId+",'FAQ','UPDATE','"+ TimeUtil.getCurrentDateString()+" "+ TimeUtil.getOnlyCurrentTimeString() +"','"+TimeUtil.getCurrentDateString()+"',0) ";
    	}
		rs.executeSql(updLogSql);
		//更新标识
		rs.execute("update Fullsearch_E_Faq set targetFlag=1 where id="+faqId);
	}
	result.put("result","success");
}else if("saveRemark".equals(type)){//保存备注.
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.null2String(fu.getParameter("faqId"));//小e FAQ
		String remark = Util.null2String(fu.getParameter("remark")); 
		rs.execute("update Fullsearch_E_Faq set sRemark='"+remark+"' where id="+faqId);
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
}else if("changeText".equals(type)){//转缓存或者是变更文本内容
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.getIntValue(fu.getParameter("faqId"),0)+"";
		String answer = Util.null2String(fu.getParameter("answer"));
		String status = Util.null2String(fu.getParameter("status"));
		String targetFlag="6";
		if("dealed".equals(status)){
			targetFlag="5";
		}else if(status.startsWith("esearch")){
			targetFlag="7";
		}
		rs.execute("update Fullsearch_E_Faq set status=1,sendReply=1,readFlag=1,checkOutId=0,targetFlag="+targetFlag+",answer='"+answer+"',processdate='"+TimeUtil.getCurrentDateString()+"',processtime='"+TimeUtil.getOnlyCurrentTimeString()+"',processId="+userId+"  where id="+faqId);
	}
	result.put("result","success");
}else if("saveInstructions".equals(type)){//执行动作
	RecordSet rs=new RecordSet();
	rs.execute("select 1 from FullSearch_CustomerSerDetail where serviceID="+userId);
	if(rs.next()){
		String faqId = Util.getIntValue(fu.getParameter("faqId"),0)+"";
		String answer = Util.null2String(fu.getParameter("answer"));
		rs.execute("update Fullsearch_E_Faq set status=1,sendReply=1,readFlag=1,checkOutId=0,targetFlag=8,answer='"+answer+"',processdate='"+TimeUtil.getCurrentDateString()+"',processtime='"+TimeUtil.getOnlyCurrentTimeString()+"',processId="+userId+"  where id="+faqId);
	}
	result.put("result","success");
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>