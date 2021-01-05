<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.fullsearch.yunwen.YunWenClient"%>
<%@page import="weaver.fullsearch.yunwen.IntentionModel"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fullsearch.yunwen.IntentionBean"%>
<%@page import="weaver.fullsearch.util.ECommonUtil"%>
<%@page import="weaver.fullsearch.yunwen.MergeUtil"%>
<%@page import="weaver.fullsearch.yunwen.parser.ParseUtil"%>
<%@page import="com.alibaba.fastjson.JSON"%>
<%@page import="weaver.fullsearch.yunwen.parser.WhoParser"%>
<%@page import="weaver.fullsearch.yunwen.parser.TimeParser"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!

private void recordIntoFAQ(final String ask,final String remark){
	ThreadPoolUtil.getThreadPool("eForecast", "5").execute((new Runnable() 
	{
		public void run() 
		{	
			String date=TimeUtil.getCurrentDateString();
			String time=TimeUtil.getOnlyCurrentTimeString();
	        RecordSet rs=new RecordSet();
	        rs.execute("select 1 from Fullsearch_E_Faq where ask='"+ask+"' and createrId=1");
	        if(!rs.next()){//已经存在. 忽略
		        //待完善语义,指令
	        	String sql="insert into Fullsearch_E_Faq(ask,createdate,createtime,status,commitTag,createrId,sendReply,readFlag,targetFlag,checkOutId,changeAsk,processdate,processtime,processId,sRemark) "+
				  "values('"+ask+"','"+date+"','"+time+"',1,1,1,1,1,2,0,'','"+date+"','"+time+"',1,'"+remark+"') ";
			 	rs.execute(sql);
	        }
		}
	}));
}


private String recognition(IntentionBean bean,JSONObject yunWenObj,String voiceInputStr,User user){
	if(!"".equals(bean.getDefaultJson())){
		String defaultJson=bean.getDefaultJson();
		//识别人的类型.
		Map whoMap=new WhoParser().parse(voiceInputStr);
		
		//日期识别
		Map dateMap=new TimeParser().parse(voiceInputStr);
		
		//#person_name# 人名识别
		if(defaultJson.indexOf("#person_name#")>-1){//需要替换参数人名
			//意图识别中
			Object pObj=yunWenObj.get("person_name");
	    	if(pObj!=null){
	    		JSONArray objs=(JSONArray) pObj;
	    		defaultJson=defaultJson.replace("#person_name#",objs.getString(0));
	    		if(whoMap.isEmpty()){
	    			whoMap.put("who","people");
	    			whoMap.put("people",objs.getString(0));
	    		}
	    	}else{
	    		//微搜识别人名
	    		//默认自己  //Util.formatMultiLang(Util.null2String(resource.getLastname(userid)),7+"");
	    		defaultJson=defaultJson.replace("#person_name#","");
	    	}
		}
		//#org_name# 客户识别
		if(defaultJson.indexOf("#org_name#")>-1){//需要替换参数客户
			//意图识别中
			Object pObj=yunWenObj.get("org_name");
	    	if(pObj!=null){
	    		JSONArray objs=(JSONArray) pObj;
	    		defaultJson=defaultJson.replace("#org_name#",objs.getString(0));
	    	}else{
	    		defaultJson=defaultJson.replace("#org_name#","");
	    	}
		}
		
		if(defaultJson.indexOf("#keys#")>-1){//需要识别关键字
			//意图识别中
			Object obj=yunWenObj.get("noun");
	    	if(obj!=null){
	    		JSONArray objs=(JSONArray) obj;
	    		String keys="";
	    		for(int i=0;i<objs.size();i++){
	    			if(voiceInputStr.indexOf(objs.getString(i))>-1){
		    			keys+=objs.getString(i)+" ";
	    			}
	    		}
	    		defaultJson=defaultJson.replace("#keys#",keys.trim());
	    	}else{
	    		defaultJson=defaultJson.replace("#keys#","");
	    	}
		}
		
		//替换指令中的text
		try{
			Map sourceMap = JSON.parseObject(defaultJson);
			sourceMap.put("text",voiceInputStr);
			if("openQA".equals(sourceMap.get("service").toString())){
				//替换意图
				((Map)sourceMap.get("answer")).put("text","识别意图:"+bean.getName());
				recordIntoFAQ(voiceInputStr,"FAQ意图代替->"+bean.getName());
			}
			
	
			//合并时间
			if(!dateMap.isEmpty()){
				sourceMap=MergeUtil.mergeMap(sourceMap,dateMap);
			}
			//合并识别团队与下属等
			if(!whoMap.isEmpty()){
				sourceMap=MergeUtil.mergeMap(sourceMap,whoMap);
			}
			
			//合并解析实现类
			List<String> parserclazzes=bean.getPaserClazzs();
			if(parserclazzes.size()>0){
				for(String parserClazz:parserclazzes){
					if(!"".equals(parserClazz)){
						Map map=ParseUtil.getPaserMap(parserClazz,voiceInputStr);
						if(map!=null&&!map.isEmpty()){
							sourceMap=MergeUtil.mergeMap(sourceMap,map);
						}
					}
				}
			}
			
			return JSONObject.fromObject(sourceMap).toString();
		}catch(Exception e1){
			e1.printStackTrace();
			
		}
	}else{
		//云问识别,未提供操作..
		//记录. 原样返回
		 
	}
	return "";
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
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String type = Util.null2String(fu.getParameter("type"));
String userId=user.getUID()+"";
//预测
if("forecast".equals(type)){
	//从数据库抓取缓存
	
	String url="http://47.97.91.13:8080/nlp/getInfo";
	boolean enableYunWen=false;
	String debugPeople="";
	double intentScore=0.5;
	String sKey="";
	String sValue="";
	String jsonStr=fu.getParameter("iFly_json");//讯飞解析串.已经经过编码
	if(!"".equals(jsonStr)){
		try{
			JSONObject iflyObj=JSONObject.fromObject(jsonStr);
			String voiceInputStr=iflyObj.get("text").toString();//语音输入内容
			//从数据库抓取缓存机制
			boolean immediatelyDoing=false;
			String immediatelyString="";
			if(!"".equals(voiceInputStr)){
				RecordSet.executeQuery("SELECT answer,targetFlag FROM Fullsearch_E_Faq where targetFlag=8 and ask=? order by processdate desc,processtime desc",voiceInputStr);
				if(RecordSet.next()){
					immediatelyDoing=true;
					immediatelyString=RecordSet.getString("answer");
				}
			}
			if(immediatelyDoing){
				//替换指令中的text
				try{
					JSONObject immediatelyObj=JSONObject.fromObject(immediatelyString);
					immediatelyObj.put("text",voiceInputStr);
					out.println(immediatelyObj.toString()); //一个可执行指令.
					return;
				}catch(Exception e1){
					new BaseBean().writeLog("fullsearch-小e缓存:"+voiceInputStr+">>无效...");
				}
			}else{
				boolean cacheDoing=false;
				//doType=1 为人员列表
				String typeValue="";
				String afterDoAction="";
				String intenCacheExpress="";
				//判断是否有意图表
				if(RecordSet.execute("select 1 from FullSearch_IntentionDesc where 1=2")){
					//判断是否有意图缓存
					if(!"".equals(voiceInputStr)){
						RecordSet.executeQuery("SELECT typeValue,afterDoAction FROM FullSearch_IntentionDesc t1 join FullSearch_IntentionType t2 on t1.intentionType=t2.id where t1.desc_n=? and t2.doType=1 order by updateDate desc,updateTime desc",voiceInputStr);
						if(RecordSet.next()){
							cacheDoing=true;
							typeValue=RecordSet.getString("typeValue");
							afterDoAction=RecordSet.getString("afterDoAction");
							intenCacheExpress=voiceInputStr;
						}
					}
					//找负责人
					if(!cacheDoing && jsonStr.indexOf("\"needRscCache\":\"true\"")>-1){
						//找到对应的name知道
						JSONObject semanticObj=iflyObj.getJSONObject("semantic");
						if(semanticObj!=null){
							JSONObject slotsObj=semanticObj.getJSONObject("slots");
							if(slotsObj!=null){
								String queryName=slotsObj.getString("name");
								String sendMsg=Util.null2String(slotsObj.get("sendMsg"));
								if(!"".equals(queryName)){
									RecordSet.executeQuery("SELECT typeValue,afterDoAction FROM FullSearch_IntentionDesc t1 join FullSearch_IntentionType t2 on t1.intentionType=t2.id where t1.desc_n=? and t2.doType=1 order by updateDate desc,updateTime desc",queryName);
									if(RecordSet.next()){
										cacheDoing=true;
										typeValue=RecordSet.getString("typeValue");
										afterDoAction=RecordSet.getString("afterDoAction");
										intenCacheExpress=!"".equals(sendMsg)?sendMsg:queryName;
									}
								}
							}
						}
					}
				}
				//意图缓存直接反馈.
				if(cacheDoing&&!"".equals(typeValue)){
					String[] typeValues=typeValue.split(",");
					ResourceComInfo rsc=new  ResourceComInfo();
					JobTitlesComInfo job=new JobTitlesComInfo(); 
					SubCompanyComInfo subcomp=new SubCompanyComInfo();
					DepartmentComInfo dept=new DepartmentComInfo();
					List list=new LinkedList();
					Map resultData = new HashMap();
					for(String hrmId:typeValues){
						if("".equals(hrmId)) continue;
						
						Map map=new HashMap();
						map.put("schema","RSC");
						map.put("id",hrmId);
						map.put("simpleTitle",rsc.getLastname(hrmId));
						map.put("simpleDesc","");
						map.put("url","");
						map.put("afterDoAction",afterDoAction);
						map.put("intenCacheExpress",intenCacheExpress);
						
						
						Map other=new HashMap();
						other.put("URL",rsc.getMessagerUrls(hrmId));
						other.put("SEX",rsc.getSexs(hrmId)); 
						other.put("MOBILE",rsc.getMobile(hrmId)); 
						other.put("SUBCOMP",subcomp.getSubcompanyname(rsc.getSubCompanyID(hrmId))); 
						other.put("JOBTITLENAME",job.getJobTitlesname(rsc.getJobTitle(hrmId))); 
						other.put("DEPT", dept.getDepartmentname(rsc.getDepartmentID(hrmId))); 
							
						map.put("other",JSONObject.fromObject(other).toString());
						list.add(map);
					}
					resultData.put("list",list);
					resultData.put("count",list.size());
					if(list.size()>0){
						result.put("text",voiceInputStr);
						result.put("rc","0");
						result.put("service","IntentCache");
						result.put("resultData",resultData);
						JSONObject jo = JSONObject.fromObject(result);
						out.println(jo.toString());
						return;
					}
					
				}else{
					//数据库读取是否启用云问意图预测,后续定义为 意图预测 相关参数.
					RecordSet.execute("select sKey,sValue from FullSearch_EAssistantSet where sKey='YunWenEnable' or  sKey='YunWenUrl' or sKey='YunWenDebugPeople' or sKey='IntentScore'");
					while(RecordSet.next()){
						sKey=RecordSet.getString("sKey");
						sValue=RecordSet.getString("sValue");
						if("YunWenEnable".equalsIgnoreCase(sKey)){//是否启用
							enableYunWen="1".equals(sValue);
						}else if("YunWenUrl".equalsIgnoreCase(sKey)){//第三方url
							url=sValue;
						}else if("YunWenDebugPeople".equalsIgnoreCase(sKey)){//调试人员
							debugPeople=sValue;
						}else if("IntentScore".equalsIgnoreCase(sKey)){//意图得分
							intentScore=Util.getDoubleValue(sValue,intentScore);
							if(intentScore>1){
								intentScore=intentScore/100;
							}
						}
					}
					if(enableYunWen && !"".equals(debugPeople)){//开启意图识别,设置了调试人员
						enableYunWen=ECommonUtil.isDebugPeople(debugPeople,user);
					}
					
					if(enableYunWen){
						if(!"".equals(url)){
							YunWenClient client=new YunWenClient();
							JSONObject obj=client.testGramma(url,voiceInputStr);
							if(obj!=null){
								String yitu=Util.null2String(obj.get("label"));
								double score=Util.getDoubleValue(Util.null2String(obj.get("value")));
								//通过意图,加载规则
								IntentionBean bean=IntentionModel.getInstance().loadIntention(yitu);
								double currentIntentscore=Util.getDoubleValue(bean.getScore(),intentScore);
								if(bean!=null){//有定义语义对应
									if("0".equals(iflyObj.getString("rc"))){//讯飞识别
										//判断识别意图和讯飞意图比较.. 返回需要处理的json
										if(IntentionModel.getInstance().isSameIntention(bean,jsonStr)){
											//相同识别,原样返回.
											out.println(jsonStr);
											return;
										}else{
											if("2".equals(bean.getPriority()) && jsonStr.indexOf("\"absolutely\":\"yes\"")==-1){//以云问为准
												if(!"".equals(bean.getDefaultJson())){
													String ret=recognition(bean,obj,voiceInputStr,user);
													if(!"".equals(ret)){
														out.println(ret); //一个可执行指令.
														return;
													} 
												}else{
													//云问识别,未提供操作..
													//记录. 原样返回
													recordIntoFAQ(voiceInputStr,"冲突->"+bean.getName());
												}
											}else{//其他以讯飞为准
												 
											}
										}
									}else{//讯飞未识别..
										//需要判断>0.2
										if(bean.getRules().size()==0){//不支持的功能
											out.println("{\"service\":\"FW_CMD\",\"text\":\""+voiceInputStr+"\",\"semantic\":{\"slots\":{\"type\":\"noFunction\"}},\"rc\":0}");
											return;
										}else{
											if(score>=currentIntentscore){
												if(!"".equals(bean.getDefaultJson())){
													String ret=recognition(bean,obj,voiceInputStr,user);
													if(!"".equals(ret)){
														out.println(ret); //一个可执行指令.
														return;
													}
												}else{
													//云问识别,未提供操作..
													//记录. 原样返回
													//recordIntoFAQ(voiceInputStr,"未识别->"+bean.getName());
												}
											}
										} 
									}
								}
							}
						}
					}
				}
			}
		}catch(Exception e){
			out.println("{}");
			return;
		}
	}else{
		
	}
	//原样返回
	out.println(jsonStr);
	return;
}else if("timeNLP".equals(type)){//测试用.
	String text=fu.getParameter("text");//讯飞解析串.已经经过编码
	Map map=ECommonUtil.getTimeNLP(text);
	if(map.isEmpty()){
		result.put("result","未识别时间");
	}else{
		result.putAll(ECommonUtil.getTimeNLP(text));
	}
}
JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>