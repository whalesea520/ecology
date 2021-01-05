<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.eassistant.interfaces.EAssistant"%>
<%@page import="weaver.eassistant.interfaces.impl.EAssistantImpl"%>
<%@page import="weaver.fullsearch.interfaces.rmi.SearchRmi"%>
<%@page import="weaver.fullsearch.interfaces.service.SearchRmiService"%>
<%@page import="weaver.eassistant.CONSTS"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="com.time.nlp.TimeNormalizer"%>
<%@page import="com.time.nlp.TimeUnit"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.fullsearch.util.ECommonUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!
private void recordIntoFAQ(final String ask,final String text,final String createId,final String processId,final String createdate,final String createtime,final int type){
	ThreadPoolUtil.getThreadPool("eAssistant", "5").execute((new Runnable() 
	{
		public void run() 
		{	
	        RecordSet rs=new RecordSet();
	        if(type==0){//待完善语义,指令
	        	String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId,changeAsk,processdate,processtime,processId) "+
				  "values('"+ask+"','"+createdate+"','"+createtime+"',1,0,"+createId+",1,1,2,0,'"+text+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"',"+processId+") ";
			 	rs.execute(sql);
	        }else if(type==1){//直接展示给用户的内容 6
	        	String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId,answer,processdate,processtime,processId) "+
				  "values('"+ask+"','"+createdate+"','"+createtime+"',1,0,"+createId+",1,1,6,0,'"+text+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"',"+processId+") ";
			 	rs.execute(sql);
	        }else if(type==2){//人工处理的指令  5
	        	String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId,answer,processdate,processtime,processId) "+
				  "values('"+ask+"','"+createdate+"','"+createtime+"',1,0,"+createId+",1,1,5,0,'"+text+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"',"+processId+") ";
			 	rs.execute(sql);
	        }else if(type==3){//微搜搜索  7
	        	String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId,answer,processdate,processtime,processId) "+
				  "values('"+ask+"','"+createdate+"','"+createtime+"',1,0,"+createId+",1,1,7,0,'"+text+"','"+TimeUtil.getCurrentDateString()+"','"+TimeUtil.getOnlyCurrentTimeString()+"',"+processId+") ";
			 	rs.execute(sql);
	        }
		}
	}));
}

private Map getTimeNLP(String text){
	Map semanticMap=new HashMap();
	//做时间分析
	TimeNormalizer normalizer = new TimeNormalizer();
	normalizer.setPreferFuture(false);
	normalizer.parse(text);// 抽取时间
	TimeUnit[] unit = normalizer.getTimeUnit();
	if(unit.length>0){
		if(unit.length==1){
			String Time_Expression=unit[0].Time_Expression;
			semanticMap.put("date_orig",Time_Expression);
			semanticMap.put("begindate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));
			semanticMap.put("begintime",com.time.util.DateUtil.formatJustTimeDefault(unit[0].getTime()));
			if(unit[0].getIsAllDayTime()){//整天
				semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
				semanticMap.put("endtime","18:00");	
				if("00:00".equals(com.time.util.DateUtil.formatJustTimeDefault(unit[0].getTime()))){
					semanticMap.put("begintime","09:00");
				}
			}else{//非整天.
				boolean hasRecognize=false;
				String rule = "凌晨|半夜|午夜|午夜时分";
				String[] rules= rule.split("\\|");
		        for(String s:rules){
		        	if(Time_Expression.endsWith(s)){
		        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
						semanticMap.put("endtime","01:00");
						hasRecognize=true;
		        		break;
		        	}
		        }
		        if(!hasRecognize){
			        rule = "早上|今早|早晨|早饭时|早餐时|一早";
					rules= rule.split("\\|");
			        for(String s:rules){
			        	if(Time_Expression.endsWith(s)){
			        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
							semanticMap.put("endtime","09:00");
							hasRecognize=true;
			        		break;
			        	}
			        }
		        }
		        if(!hasRecognize){
			        rule = "上午|早饭后|早餐后";
					rules= rule.split("\\|");
			        for(String s:rules){
			        	if(Time_Expression.endsWith(s)){
			        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
							semanticMap.put("endtime","12:00");
							hasRecognize=true;
			        		break;
			        	}
			        }
		        }
		        if(!hasRecognize){
			        rule = "中午|午休|午间|午饭时|午餐时";
					rules= rule.split("\\|");
			        for(String s:rules){
			        	if(Time_Expression.endsWith(s)){
			        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
							semanticMap.put("endtime","13:00");
							hasRecognize=true;
			        		break;
			        	}
			        }
		        }
		        if(!hasRecognize){
			        rule = "下午|午休后|午饭后|午餐后";
					rules= rule.split("\\|");
			        for(String s:rules){
			        	if(Time_Expression.endsWith(s)){
			        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
							semanticMap.put("endtime","18:00");
							hasRecognize=true;
			        		break;
			        	}
			        }
		        }
		        if(!hasRecognize){
			        rule = "傍晚|晚饭时|晚餐时";
					rules= rule.split("\\|");
			        for(String s:rules){
			        	if(Time_Expression.endsWith(s)){
			        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
							semanticMap.put("endtime","19:00");
							hasRecognize=true;
			        		break;
			        	}
			        }
		        }
		        if(!hasRecognize){
			        rule = "晚上|晚饭后|晚餐后";
					rules= rule.split("\\|");
			        for(String s:rules){
			        	if(Time_Expression.endsWith(s)){
			        		semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[0].getTime()));	
							semanticMap.put("endtime","22:00");
							hasRecognize=true;
			        		break;
			        	}
			        }
		        }
			}
		}else{
			for(int i=0;i<unit.length;i++){
				if(i==0){
					semanticMap.put("date_orig",unit[i].Time_Expression);
					semanticMap.put("begindate",com.time.util.DateUtil.formatJustDateDefault(unit[i].getTime()));
					semanticMap.put("begintime",com.time.util.DateUtil.formatJustTimeDefault(unit[i].getTime()));
				}else if(i==1){
					semanticMap.put("enddate",com.time.util.DateUtil.formatJustDateDefault(unit[i].getTime()));
					semanticMap.put("endtime",com.time.util.DateUtil.formatJustTimeDefault(unit[i].getTime()));
				}
			}
		}
	}
	return semanticMap;
}
%>
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
String deptId=user.getUserDepartment()+"";
String compId=user.getUserSubCompany1()+"";
String createDate=TimeUtil.getCurrentDateString();
String createTime=TimeUtil.getOnlyCurrentTimeString();
//获取url点击跳转.
if("Workbench".equals(type)){
	String text = Util.null2String(fu.getParameter("text"));
	//判断是否开启了工作台.
	RecordSet.execute("select sKey,sValue from FullSearch_EAssistantSet where sKey='EnableWorkbench' or sKey='WorkbenchDebugPeople'");
	boolean EnableWorkbench=false;
	String sKey="";
	String WorkbenchDebugPeople="";
	while(RecordSet.next()){
		sKey=RecordSet.getString("sKey");
		if("WorkbenchDebugPeople".equalsIgnoreCase(sKey)){
			WorkbenchDebugPeople=RecordSet.getString("sValue");
		}else if("EnableWorkbench".equals(sKey)){
			EnableWorkbench="1".equals(RecordSet.getString("sValue"));
		}
	}
	//通过数据库查询已经处理过的内容,直接处理.
	boolean immediatelyDoing=false;
	String immediatelyType="";//5表示指令,6表示直接显示 7 微搜搜索
	String immediatelyString="";
	if(!"".equals(text)){
		RecordSet.executeQuery("SELECT answer,targetFlag FROM Fullsearch_E_Faq where (targetFlag=5 or targetFlag=6 or targetFlag=7) and ask=? order by processdate desc,processtime desc",text);
		if(RecordSet.next()){
			immediatelyDoing=true;
			immediatelyType=RecordSet.getString("targetFlag");
			immediatelyString=RecordSet.getString("answer");
		}
	}
	if(immediatelyDoing){
		//把jsonstring 转成 json
		try{
			JSONObject jo=JSONObject.fromObject(immediatelyString);
			if("5".equals(immediatelyType)){//标识指令
				Map semanticMap=getTimeNLP(text);
				if(jo.containsKey("content")){
					semanticMap.put("content",jo.get("content").toString());
				}
				jo.put("semantic",semanticMap);
			}
			out.println(jo.toString());
		}catch(Exception e){ //加载异常 当微搜处理
			result.put("text",text);
			result.put("status",CONSTS.ESEARCH);
			JSONObject jo = JSONObject.fromObject(result);
			out.println(jo.toString());
		}
		return;
	}else{
		boolean isDebugPeople=ECommonUtil.isDebugPeople(WorkbenchDebugPeople,user);
		
		if(EnableWorkbench&&!"".equals(text)&&isDebugPeople){
			//分词.
			SearchRmi localISearcher = SearchRmiService.getSearchRmi();
			String words="";
	        Map paraMap = new HashMap();
	        paraMap.put("type", "analysis");
	        //paraMap.put("stopWordFilter", "true");
	        paraMap.put("key", text);
	        if (localISearcher != null) {
	        	Map map = localISearcher.search(paraMap, null, null);
	        	if(map.containsKey("terms")){
	        		List<String> list=(List)map.get("terms");
	        		for(String s:list){
	        			if(",".equals(s)) continue;
	        			words+=("".equals(words)?"":",")+s;
	        		}
	        	}
	        }
	        
	        EAssistant ea = new EAssistantImpl();
			Map data = ea.getEAssistantResult(text,words,userId);
			data.remove("addTime");
			data.remove("dealingTimeRemain");
			data.remove("timeRemain");
			data.remove("createDate");
			data.remove("creator");
			data.remove("words");
			if(data.containsKey("content")&&"".equals(data.get("content").toString())){
				data.remove("content");
			}
			result.putAll(data);
			
			Map recordMap = new HashMap();
			recordMap.putAll(data);
			recordMap.remove("processId");
			recordMap.remove("isRecord");
			if(data.containsKey("status")){
				if(CONSTS.DEALED.equalsIgnoreCase(data.get("status").toString())){
					if(data.containsKey("isRecord")&&"true".equals(data.get("isRecord").toString())){
						recordIntoFAQ(text,JSONObject.fromObject(recordMap).toString(),userId,data.containsKey("processId")?data.get("processId").toString():"1",createDate,createTime,2);
					}else{
						recordIntoFAQ(text,data.get("text").toString(),userId,data.containsKey("processId")?data.get("processId").toString():"1",createDate,createTime,0);
					}
					
					Map semanticMap=getTimeNLP(text);
					if(data.containsKey("content")){
						semanticMap.put("content",data.get("content").toString());
					}
					result.put("semantic",semanticMap);
				}else if(CONSTS.SHOW.equalsIgnoreCase(data.get("status").toString())){
					if(data.containsKey("isRecord")&&"true".equals(data.get("isRecord").toString())){
						recordIntoFAQ(text,JSONObject.fromObject(recordMap).toString(),userId,data.containsKey("processId")?data.get("processId").toString():"1",createDate,createTime,1);
					}
				}else{
					//直接转微搜的, 没有区分类型不进入.
					if(!CONSTS.ESEARCH.equalsIgnoreCase(data.get("status").toString())){
						if(data.containsKey("isRecord")&&"true".equals(data.get("isRecord").toString())){
							recordIntoFAQ(text,JSONObject.fromObject(recordMap).toString(),userId,data.containsKey("processId")?data.get("processId").toString():"1",createDate,createTime,3);
						}
					}
				}
			}
		}else{
			result.put("text",text);
			result.put("status",CONSTS.ESEARCH);
		}
	}
}

result.remove("processId");
result.remove("isRecord");
JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>