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
<jsp:useBean id="HrmResourceBaseTabComInfo" class="weaver.hrm.resource.HrmResourceBaseTabComInfo" scope="page" />
<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
int currentLanguageid=user.getLanguage();

String grouptablename="HrmResourceBaseTab";

if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }


  boolean isoracle = (RecordSet.getDBType()).equals("oracle") ;
  boolean isdb2 = (RecordSet.getDBType()).equals("db2") ;
  boolean issqlserver = (RecordSet.getDBType()).equals("sqlserver") ;

  String ajax=Util.null2String(request.getParameter("ajax"));
  String src = Util.null2String(request.getParameter("src"));
  String method = Util.null2String(request.getParameter("method"));
  
  int groupid=0;
  String groupnamecn="";
  String groupnameen="";
  String groupnametw="";
  String linkurl="";
  String isopen="";
  if(src.equals("editgroupbatch")){//批量编辑分组
  

  
	String dtinfo = Util.null2String(request.getParameter("dtinfo"));
	String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
	if(keepgroupids.endsWith(",")){
		keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
	}
	//System.out.println("dtinfo:"+dtinfo);
	
		JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
		if(!keepgroupids.equals("")){
			RecordSet.executeSql("delete from "+grouptablename+" where id not in("+keepgroupids+")");
		}else{
			RecordSet.executeSql("delete from "+grouptablename+" ");
		}
		for(int i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=4){
				groupnamecn=Util.null2String( dtJsonArray2.getJSONObject(0).getString("groupnamecn"));
				groupnameen=Util.null2String( dtJsonArray2.getJSONObject(1).getString("groupnameen"));
				groupnametw=Util.null2String( dtJsonArray2.getJSONObject(2).getString("groupnametw"));
				linkurl=Util.null2String( dtJsonArray2.getJSONObject(3).getString("linkurl"));
				groupid= Util.getIntValue( dtJsonArray2.getJSONObject(4).getString("groupid"),0);
				isopen=Util.null2String( dtJsonArray2.getJSONObject(5).getString("isopen"));
				if("".equals( isopen)){
					isopen="0";
				}else{
					isopen="1";
				}
				
				int lableid= 0;
				boolean newlabel=false;
				RecordSetTrans RecordSetTrans= new RecordSetTrans();
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
					sql="update "+grouptablename+" set isopen='"+isopen+"',linkurl='"+linkurl+"',groupname='"+groupnamecn+"',grouplabel="+lableid+",dsporder="+(i+1)+" where id="+groupid;
				}else{
					sql="insert into "+grouptablename+"(linkurl,groupname,grouplabel,dsporder,isopen) values('"+linkurl+"','"+groupnamecn+"','"+lableid+"','"+(i+1)+"','"+isopen+"') ";
				}
				RecordSet.executeSql(sql);
			}
		}	
	
	HrmResourceBaseTabComInfo.removeCache();
	out.print("[]");
}else if("loadgroupdata".equalsIgnoreCase(src)){//读取保存的信息
	JSONArray arr=new JSONArray();

	HrmResourceBaseTabComInfo.setTofirstRow();
	while(HrmResourceBaseTabComInfo.next()){
		JSONArray jsonArray=new JSONArray();
		
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("name", "groupnamecn");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmResourceBaseTabComInfo.getLabel(),0),7));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnameen");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmResourceBaseTabComInfo.getLabel(),0),8));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnametw");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmResourceBaseTabComInfo.getLabel(),0),9));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "linkurl");
		jsonObject.put("value", Util.null2String( HrmResourceBaseTabComInfo.getLinkurl()));
		jsonObject.put("iseditable", (!"1".equals( HrmResourceBaseTabComInfo.getIsSystem())));
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "isopen");
		jsonObject.put("value", Util.null2String( HrmResourceBaseTabComInfo.getIsopen()));
		jsonObject.put("iseditable", (!"1".equals( HrmResourceBaseTabComInfo.getIsSystem())));
		jsonObject.put("checked", ("1".equals( HrmResourceBaseTabComInfo.getIsopen())));
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupid");
		jsonObject.put("value", HrmResourceBaseTabComInfo.getGroupid());
		if("1".equals( HrmResourceBaseTabComInfo.getIsSystem())||"1".equals(HrmResourceBaseTabComInfo.getIsmand())){
			jsonObject.put("display", "none");
		}
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		
		arr.add(jsonArray);
	}
	
	//System.out.println("loadtime:\n"+new Date());
	out.print(arr.toString());
}else if(method.equals("save")){
  String[] isValidate=request.getParameterValues("isValidate");
  String ProcPara = "";
  RecordSet.executeSql("update HrmListValidate set validate_n=0 where tab_type=1 ");
  if(isValidate!=null){
      for(int i=0;i<isValidate.length;i++){
          ProcPara =  isValidate[i];
          RecordSet.executeProc("Hrmlist_Update",ProcPara);
  	}
  }
  response.sendRedirect("HrmValidate.jsp");
}
%>