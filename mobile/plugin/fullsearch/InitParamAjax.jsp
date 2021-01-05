<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.fullsearch.MobileSchemaUtil"%>
<%@page import="weaver.fullsearch.MobileSchemaBean"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="fs" class="weaver.mobile.plugin.ecology.service.FullSearchService" scope="page" />

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
//获取url点击跳转.
if("goPage".equals(type)){
	String viewmodule = Util.null2String(fu.getParameter("viewmodule"));
	//对标准模块权限放开 start
	Map<String,MobileSchemaBean > urlMap=MobileSchemaUtil.getInstance().getSchemaUrlMap();
	Map<String,MobileSchemaBean > cusMap=MobileSchemaUtil.getInstance().getSchemaCusMap();

	Map<String,MobileSchemaBean> pageMap = new HashMap<String,MobileSchemaBean>();
	pageMap.putAll(urlMap); //深拷贝

	String authModule=viewmodule;//文档,流程,人员,客户,FAQ
	String authModules[]=authModule.split(",");
	for(int i=0;i<authModules.length;i++){
		if(Util.getIntValue(authModules[i],-1)>=-1) continue; 
		//判断有没有自定义(建模),可以替换标准模块的跳转
		if(cusMap.containsKey(authModules[i])){
			MobileSchemaBean msb=cusMap.get(authModules[i]);
			pageMap.put(msb.getSechma(),msb);
		}
	}
	//对标准模块权限放开 end
	result.put("pageMap",pageMap);
	
}else if("InitParam".equals(type)){//获取初始化配置信息
	//当前需要查询的模块
	String auth=",DOC,WF,WFTYPE,CRM,RSC,FAQ,";
	//当前不支持的语音查询模块
	String noauth="";
	List schemas=fs.getAllSchemas(sessionkey);
	for(Object s:schemas){
		String[] ss=((String)s).split(":");
		if(auth.indexOf(ss[0])>-1) continue;
		noauth+="".equals(noauth)?ss[0]:","+ss[0];
	}
	
	result.put("noauth",noauth);//没有的权限.
	
	//默认微搜1.0,通过接口获取到值可能是:ES2.0
	String es_version=fs.getEs_version();
	result.put("es_version",es_version);
	//是否启用记录日志功能.
	
	//判断是否已经维护客服
	int count=0;
	RecordSet.execute("select count(1) c from FullSearch_CustomerSerDetail");
	if(RecordSet.next()){
		count=Util.getIntValue(RecordSet.getString("c"));
	}
	boolean hasCS=count>0;
	result.put("hasCS",hasCS);
	
	//-------------通过数据获取相关设置--------start-------------------
	String sKey="";
	String sValue="";
	//允许手动提交问题
	boolean intoFAQ=false;
	boolean showFAQTips=false;
	//加载调试人员
	String degbugPeople="";
	//日志记录交互指令
	boolean recordInstruction=false;
	
	//是否es2.0,只有2.0版本才可以记录日志.
	boolean esRecordInstruction="ES2.0".equals(es_version);
	String recordInstructionUrl="";
	RecordSet.execute("select sKey,sValue from FullSearch_EAssistantSet where sKey='DebugPeople' or  sKey='recordInstruction' or  sKey='recordInstructionUrl' or sKey='ALLOWSUBMITFAQ' or sKey='ShowFAQTips'");
	while(RecordSet.next()){
		sKey=RecordSet.getString("sKey");
		sValue=Util.null2String(RecordSet.getString("sValue"));
		if("ALLOWSUBMITFAQ".equalsIgnoreCase(sKey)){
			intoFAQ="1".equals(sValue);
		}else if("DebugPeople".equalsIgnoreCase(sKey)){
			degbugPeople=sValue;
		}else if("recordInstruction".equalsIgnoreCase(sKey)){
			recordInstruction="1".equals(sValue);
		}else if("recordInstructionUrl".equalsIgnoreCase(sKey)){
			recordInstructionUrl=sValue;
		}else if("ShowFAQTips".equalsIgnoreCase(sKey)){
			showFAQTips="1".equals(sValue);
		}
	}

	//微搜2.0 后台开启记录日程  记录日志url不为空 都满足
	if(esRecordInstruction && recordInstruction && !"".equals(recordInstructionUrl)){
		recordInstruction=true;
	}else{
		recordInstruction=false;
	}
	//-------------通过数据获取相关设置--------end------------------- 
	
	result.put("intoFAQ",intoFAQ);//提交问题
	result.put("showFAQTips",showFAQTips);//tips提醒
	result.put("degbugPeople",degbugPeople);//debug人员
	result.put("recordInstruction",recordInstruction);//日志记录
}else if("instruction".equals(type)){//获取指令相关
	//获取固定指令
	List<Map<String,String>> fixedInstList=new LinkedList<Map<String,String>>();
	Map<String,String> map=null;
	RecordSet.execute("select * from FullSearch_FixedInst ORDER BY showorder,id");
	while(RecordSet.next()){
		map=new HashMap<String,String>();
		map.put("id",RecordSet.getString("id"));
		map.put("name",RecordSet.getString("instructionName"));
		map.put("example",RecordSet.getString("showExample"));
		map.put("img",!"".equals(RecordSet.getString("instructionImgSrc"))?RecordSet.getString("instructionImgSrc"):RecordSet.getString("defaultImgSrc"));
		fixedInstList.add(map);
	}
	//各指令明细
	int helpDetailMaxSize=0;
	Map<String,List<String>> fixedInstMap=new HashMap<String,List<String>>();
	List<String> list=null;
	RecordSet.execute("select * from FullSearch_FixedInstShow");
	while(RecordSet.next()){
		String id=RecordSet.getString("instructionId");
		if(fixedInstMap.containsKey(id)){
			list=fixedInstMap.get(id);
		}else{
			list=new LinkedList<String>();
		}
		list.add(RecordSet.getString("showValue"));
		helpDetailMaxSize=list.size()>helpDetailMaxSize?list.size():helpDetailMaxSize;
		fixedInstMap.put(id,list);
	}
	
	result.put("fixedInstList",fixedInstList);
	result.put("fixedInstMap",fixedInstMap);
	result.put("helpDetailMaxSize",helpDetailMaxSize);
	
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>