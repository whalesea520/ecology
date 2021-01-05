<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="weaver.proj.util.LabelUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.util.regex.*" %>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.proj.util.PrjTskFieldManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.proj.util.PrjTskCardGroupComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="LabelUtil" class="weaver.proj.util.LabelUtil" scope="page" />
<%


User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
int currentLanguageid=user.getLanguage();

String grouptablename="prj_tskcardgroup";

/**	
if(!HrmUserVarify.checkUserRight("DeptDefineInfo1:DeptMaintain1", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
}**/



  boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
  boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
  boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;

  String ajax=Util.null2String(request.getParameter("ajax"));
  String src = Util.null2String(request.getParameter("src"));
  
  int groupid=0;
  String groupnamecn="";
  String groupnameen="";
  String groupnametw="";
  if(src.equals("editgroupbatch")){//
  

  
	String dtinfo = Util.null2String(request.getParameter("dtinfo"));
	String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
	if(keepgroupids.endsWith(",")){
		keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
	}
	//System.out.println("dtinfo:"+dtinfo);
	
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		RecordSet.executeSql("delete from "+grouptablename+" where id not in("+keepgroupids+")");
		for(int i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=4){
				groupnamecn=Util.null2String( dtJsonArray2.getJSONObject(0).getString("groupnamecn"));
				groupnameen=Util.null2String( dtJsonArray2.getJSONObject(1).getString("groupnameen"));
				groupnametw=Util.null2String( dtJsonArray2.getJSONObject(2).getString("groupnametw"));
				groupid= Util.getIntValue( dtJsonArray2.getJSONObject(3).getString("groupid"),0);
				
				boolean newlabel=false;
				String labelname=7==currentLanguageid?groupnamecn:8==currentLanguageid?groupnameen:9==currentLanguageid?groupnametw:groupnamecn;
				
				
				
				int lableid= 0;
				RecordSetTrans=new RecordSetTrans();
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
					  
						LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
				  }else{
					  lableid=RecordSetTrans.getInt("indexid");
				  }
				  RecordSetTrans.commit();
				if(newlabel){
					  LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
				  }
				String sql="";
				if(groupid>0){
					sql="update "+grouptablename+" set groupname='"+labelname+"',grouplabel="+lableid+",dsporder="+(i+1)+" where id="+groupid;
				}else{
					sql="insert into "+grouptablename+"(groupname,grouplabel,dsporder,isopen) values('"+labelname+"','"+lableid+"','"+(i+1)+"','1') ";
				}
				
				RecordSet.executeSql(sql);
				
			}
		}	
	}
	
	CptFieldComInfo.removeCache();
	out.print("[]");
}else if("loadgroupdata".equalsIgnoreCase(src)){//
	JSONArray arr=new JSONArray();

	CptFieldComInfo.setTofirstRow();
	while(CptFieldComInfo.next()){
		JSONArray jsonArray=new JSONArray();
		
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("name", "groupnamecn");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( CptFieldComInfo.getLabel(),0),7));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnameen");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( CptFieldComInfo.getLabel(),0),8));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnametw");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( CptFieldComInfo.getLabel(),0),9));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupid");
		jsonObject.put("value", CptFieldComInfo.getGroupid());
		//if("1".equals( CptFieldComInfo.getIsSystem())||CptFieldComInfo.existsFields(CptFieldComInfo.getGroupid())){
		if(CptFieldComInfo.existsFields(CptFieldComInfo.getGroupid())){
			jsonObject.put("display", "none");
		}
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		
		arr.add(jsonArray);
	}
	
	//System.out.println("loadtime:\n"+new Date());
	out.print(arr.toString());
}
%>