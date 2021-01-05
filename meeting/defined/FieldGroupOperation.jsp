<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="MeetingFieldGroupComInfo" class="weaver.meeting.defined.MeetingFieldGroupComInfo" scope="page" />
<jsp:useBean id="LabelUtil" class="weaver.proj.util.LabelUtil" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<%


User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
  int currentLanguageid=user.getLanguage();	
  String grouptablename="meeting_fieldgroup";
  String src = Util.null2String(request.getParameter("src"));
  int groupid=0;
  int grouplabel=0;

  //系统设置了几种语言,遍历保存
  int current_langId=7;  
  if(src.equals("editgroupbatch")){//批量编辑分组
   
	String dtinfo = Util.null2String(request.getParameter("dtinfo"));
	int grouptype = Util.getIntValue(request.getParameter("grouptype"),1);//所属页面 1.基本信息页面, 2会议议程 3会议服务 4会议回执 5预留
	String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
	if(keepgroupids.endsWith(",")){
		keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
	}
	if(keepgroupids.length()>0){
		RecordSet.executeSql("delete from "+grouptablename+" where id not in("+keepgroupids+") and grouptype = "+grouptype);
	}
	
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		for(int i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			Map<String,String> jsonMap=new HashMap<String,String>();
			String key="";
			for(int j=0;j<dtJsonArray2.size();j++){
				 JSONObject dtJsonObj=dtJsonArray2.getJSONObject(j);
				 Iterator<String> it= dtJsonObj.keySet().iterator();
				 while(it.hasNext()){
					 key=it.next();
					 jsonMap.put(key,dtJsonObj.getString(key));
				 }
			}

			groupid= Util.getIntValue(Util.null2String(jsonMap.get("groupid")),0);
			grouplabel= Util.getIntValue(Util.null2String(jsonMap.get("grouplabel")),0);
			String labelname=jsonMap.get("groupname_"+currentLanguageid);
			int labelid= LabelUtil.getLabelId(labelname,current_langId);
			String sql="";
			if(groupid>0){
				sql="update "+grouptablename+" set grouplabel="+labelid+",grouporder="+(i+1)+" where id="+groupid;
			}else{
				sql="insert into "+grouptablename+"(grouplabel,grouporder,grouptype) values('"+labelid+"','"+(i+1)+"',"+grouptype+") ";
			}
			RecordSet.executeSql(sql);
			
			if(labelid<-1){//更新标签库
				RecordSet.executeSql("delete from HtmlLabelIndex where id="+labelid);
				RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+labelid);
				RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+labelid+",'"+labelname+"')");
				LanguageComInfo.setTofirstRow();
			    while(LanguageComInfo.next()){
				  current_langId=Util.getIntValue(LanguageComInfo.getLanguageid());
				  RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+labelid+",'"+jsonMap.get("groupname_"+current_langId)+"',"+current_langId+")");//中文
			    }
				LabelComInfo.addLabeInfoCache(""+labelid);
			}
		}	
	}
	MeetingFieldGroupComInfo.removeCache();
	out.print("[]");
}else if("loadgroupdata".equalsIgnoreCase(src)){//读取保存的信息
	JSONArray arr=new JSONArray();
	String grouptype = Util.null2String(request.getParameter("grouptype"));
	//System.out.println("grouptype:"+grouptype);
	MeetingFieldGroupComInfo.setTofirstRow();
	while(MeetingFieldGroupComInfo.next()){;
	
		if("".equals(grouptype)||!grouptype.equals(MeetingFieldGroupComInfo.getType()))continue;
		//System.out.println("MeetingFieldGroupComInfo.getid():"+MeetingFieldGroupComInfo.getid());
		JSONArray jsonArray=new JSONArray();
		//System.out.println();
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("name", "grouplabel");
		jsonObject.put("value", MeetingFieldGroupComInfo.getLabel());
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		LanguageComInfo.setTofirstRow();
		  while(LanguageComInfo.next()){
			 current_langId=Util.getIntValue(LanguageComInfo.getLanguageid());
				 jsonObject=new JSONObject();
				jsonObject.put("name", "groupname_"+current_langId);
				jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( MeetingFieldGroupComInfo.getLabel(),0),current_langId));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "input");
				jsonArray.add(jsonObject);
		  }
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupid");
		jsonObject.put("value", MeetingFieldGroupComInfo.getid());
		if(MeetingFieldGroupComInfo.existsFields(MeetingFieldGroupComInfo.getid())){//组下是否有字段,有则不允许删除
			jsonObject.put("display", "none");
		}
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		
		arr.add(jsonArray);
	}
	
	out.print(arr.toString());
}
%>