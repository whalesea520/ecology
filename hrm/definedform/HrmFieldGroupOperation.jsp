<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.conn.RecordSetTrans"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="HrmFieldGroupComInfo" class="weaver.hrm.definedfield.HrmFieldGroupComInfo" scope="page" />
<%


User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
int currentLanguageid=user.getLanguage();

	String grouptablename="hrm_fieldgroup";

  String src = Util.null2String(request.getParameter("src"));
  
  int groupid=0;
  String groupnamecn="";
  String groupnameen="";
  String groupnametw="";
  if(src.equals("editgroupbatch")){//批量编辑分组
   
	String dtinfo = Util.null2String(request.getParameter("dtinfo"));
	int grouptype = Util.getIntValue(request.getParameter("grouptype"),0);//所属页面 基本信息页面 个人信息页面 工作信息页面
	String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
	if(keepgroupids.endsWith(",")){
		keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
	}
	//System.out.println("dtinfo:"+dtinfo);
	
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		RecordSet.executeSql("delete from "+grouptablename+" where id not in("+keepgroupids+") and grouptype = "+grouptype);
		for(int i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=4){
				groupnamecn=Util.null2String( dtJsonArray2.getJSONObject(0).getString("groupnamecn"));
				groupnameen=Util.null2String( dtJsonArray2.getJSONObject(1).getString("groupnameen"));
				groupnametw=Util.null2String( dtJsonArray2.getJSONObject(2).getString("groupnametw"));
				groupid= Util.getIntValue( dtJsonArray2.getJSONObject(3).getString("groupid"),0);
				//设置默认值
				if(groupnameen.length()==0)groupnameen=groupnamecn;
				if(groupnametw.length()==0)groupnametw=groupnamecn;
				
				int lableid = 0;
				boolean newlabel=false;
				RecordSetTrans RecordSetTrans = new RecordSetTrans();
				RecordSetTrans.setAutoCommit(false);
				String mysql=""+
						" select distinct t2.indexid from HtmlLabelInfo t2 where "+
						" exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+groupnamecn+"' and t1.languageid=7) "+
						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+groupnameen+"' and t1.languageid=8) "+ 
						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+groupnametw+"' and t1.languageid=9) " ;
				RecordSetTrans.executeSql(mysql);
				if(newlabel=(!RecordSetTrans.next())){
				  	lableid = CptFieldManager.getNewIndexId(RecordSetTrans);
					  RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
					  RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+groupnamecn+"')");
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+groupnamecn+"',7)");//中文
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+groupnameen+"',8)");//英文
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+groupnametw+"',9)");//繁体
					  
				  }else{
				  	lableid=RecordSetTrans.getInt("indexid");
				  }
				  RecordSetTrans.commit();
				  if(newlabel)LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
				String sql="";
				if(groupid>0){
					sql="update "+grouptablename+" set grouplabel="+lableid+",grouporder="+(i+1)+" where id="+groupid;
				}else{
					sql="insert into "+grouptablename+"(grouplabel,grouporder,grouptype) values('"+lableid+"','"+(i+1)+"',"+grouptype+") ";
				}
				RecordSet.executeSql(sql);
				
			}
		}	
	}
	
	HrmFieldGroupComInfo.removeCache();
	out.print("[]");
}else if("loadgroupdata".equalsIgnoreCase(src)){//读取保存的信息
	JSONArray arr=new JSONArray();
	String grouptype = Util.null2String(request.getParameter("grouptype"));
	HrmFieldGroupComInfo.setTofirstRow();
	while(HrmFieldGroupComInfo.next()){;
		if(!grouptype.equals(HrmFieldGroupComInfo.getType()))continue;
		JSONArray jsonArray=new JSONArray();
		
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("name", "groupnamecn");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmFieldGroupComInfo.getLabel(),0),7));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnameen");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmFieldGroupComInfo.getLabel(),0),8));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnametw");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmFieldGroupComInfo.getLabel(),0),9));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupid");
		jsonObject.put("value", HrmFieldGroupComInfo.getid());
		if(grouptype.equals("4")||grouptype.equals("5")){
			if(HrmFieldGroupComInfo.existsHrmFields(HrmFieldGroupComInfo.getid())){
				jsonObject.put("display", "none");
			}
		}else{
			if(HrmFieldGroupComInfo.existsFields(HrmFieldGroupComInfo.getid())){
				jsonObject.put("display", "none");
			}
		}
		
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		
		arr.add(jsonArray);
	}
	
	out.print(arr.toString());
}
%>