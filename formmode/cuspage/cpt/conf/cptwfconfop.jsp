<%@page import="weaver.workflow.action.WorkflowActionManager"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.util.regex.*" %>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptWfConfComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<jsp:useBean id="workflowActionManager" class="weaver.workflow.action.WorkflowActionManager" scope="page" />
<%

User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
int currentLanguageid=user.getLanguage();

String grouptablename="uf4mode_cptwfconf";

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
  String wftype = Util.null2String(request.getParameter("wftype"));//apply,fetch,mend,move,discard,back,lend,loss

//action动作是否异步开关
String isasync="0";
String actname="";
if(wftype.length()>1){
	//actname="action.Cpt"+wftype.substring(0, 1).toUpperCase()+wftype.substring(1)+"Action";
	actname="Mode4Cpt"+wftype.substring(0, 1).toUpperCase()+wftype.substring(1)+"Action";
}
  
  
  int groupid=0;
  String wfid="";
  String sqr="";
  String zczl="";
  String zc="";
  String sl="";
  String zcz="";
  String jg="";
  String rq="";
  String ggxh="";
  String cfdd="";
  String bz="";
  String wxqx="";
  String wxdw="";
  String acttype="";
  String actnode="";
  String actlink="";
  String actmethod="";
  
  if(src.equals("editgroupbatch")){//批量编辑分组
  

  
	String dtinfo = Util.null2String(request.getParameter("dtinfo"));
	int dtrowcount = Util.getIntValue(request.getParameter("dtrowcount"),0);
	String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
	if(keepgroupids.endsWith(",")){
		keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
	}
	//System.out.println("dtinfo1:"+dtinfo);
	dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
	//System.out.println("dtinfo2:"+dtinfo);
	
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		RecordSet.executeSql("delete from "+grouptablename+" where wftype='"+wftype+"' and id not in("+keepgroupids+")");
		//删除配置的action也要删除
		rs2.executeSql("select * from "+grouptablename+" where wftype='"+wftype+"' and id not in("+keepgroupids+")");
		while(rs2.next()){
			int tmpwfid=rs2.getInt("wfid");
			String sql2="select id from workflowactionset where actionname='"+actname+"' and workflowid="+tmpwfid;
			rs3.executeSql(sql2);
			while(rs3.next()){
				int tmpactid=RecordSet.getInt("id");
				new WorkflowActionManager().doDeleteWsAction(tmpactid);
			}
		}
		
		
		for(int i=0;i<dtJsonArray.size() ;i++){
			JSONArray arr= (JSONArray)dtJsonArray.get(i);
			JSONArray dtJsonArray2= JSONArray.fromObject(arr );
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=15){
				
				wfid=Util.null2String( dtJsonArray2.getJSONObject(0).getString("wfid"));
				sqr=Util.null2String( dtJsonArray2.getJSONObject(1).getString("sqr"));
				zczl=Util.null2String( dtJsonArray2.getJSONObject(2).getString("zczl"));
				zc=Util.null2String( dtJsonArray2.getJSONObject(3).getString("zc"));
				sl=Util.null2String( dtJsonArray2.getJSONObject(4).getString("sl"));
				zcz=Util.null2String( dtJsonArray2.getJSONObject(5).getString("zcz"));
				jg=Util.null2String( dtJsonArray2.getJSONObject(6).getString("jg"));
				rq=Util.null2String( dtJsonArray2.getJSONObject(7).getString("rq"));
				if("mend".equalsIgnoreCase(wftype)){
					ggxh="";
					cfdd="";
					wxqx=Util.null2String( dtJsonArray2.getJSONObject(8).getString("wxqx"));
					wxdw=Util.null2String( dtJsonArray2.getJSONObject(9).getString("wxdw"));
				}else{
					ggxh=Util.null2String( dtJsonArray2.getJSONObject(8).getString("ggxh"));
					cfdd=Util.null2String( dtJsonArray2.getJSONObject(9).getString("cfdd"));
					wxqx="";
					wxdw="";
				}
				bz=Util.null2String( dtJsonArray2.getJSONObject(10).getString("bz"));
				
				acttype=""+Util.getIntValue( dtJsonArray2.getJSONObject(11).getString("acttype"),-1);
				actnode=""+Util.getIntValue( dtJsonArray2.getJSONObject(12).getString("actnode"),0);
				actlink=""+Util.getIntValue( dtJsonArray2.getJSONObject(13).getString("actlink"),0);
				actmethod=""+Util.getIntValue( dtJsonArray2.getJSONObject(14).getString("actmethod"),0);
				
				groupid= Util.getIntValue( dtJsonArray2.getJSONObject(15).getString("groupid"),0);
				
				
				String sql="";
				if(groupid>0){
					sql="UPDATE "+grouptablename+" SET wftype = '"+wftype+"',wfid = '"+wfid+"',sqr = '"+sqr+"',zczl = '"+zczl+"',zc = '"+zc+"',sl = '"+sl+"',zcz = '"+zcz+"',jg = '"+jg+"',rq = '"+rq+"',ggxh = '"+ggxh+"',cfdd = '"+cfdd+"',bz = '"+bz+"',wxqx = '"+wxqx+"',wxdw = '"+wxdw+"',isasync = '"+isasync+"',actname = '"+(acttype+","+actnode+","+actlink+","+actmethod)+"' where id="+groupid;
					RecordSet.executeSql(sql);
				}else{
					sql=" INSERT INTO "+grouptablename+"(wftype,wfid,sqr,zczl,zc,sl,zcz,jg,rq,ggxh,cfdd,bz,wxqx,wxdw,isasync,actname) "+
						" VALUES ('"+wftype+"','"+wfid+"','"+sqr+"','"+zczl+"','"+zc+"','"+sl+"','"+zcz+"','"+jg+"','"+rq+"','"+ggxh+"','"+cfdd+"','"+bz+"','"+wxqx+"','"+wxdw+"','"+isasync+"','"+(acttype+","+actnode+","+actlink+","+actmethod)+"') ";
					RecordSet.executeSql(sql);
					//老的流程归档节点插action
					//sql= "select t1.nodeid from workflow_flownode t1 where t1.nodetype=3 and t1.workflowid="+wfid+" and not exists(select 1 from workflow_addinoperate t2 where t2.objid=t1.nodeid and t2.isnode=1)";
					//RecordSet.executeSql(sql);
					//if(RecordSet.next()){
						/**
						sql=" insert into workflow_addinoperate(objid,isnode,workflowid,customervalue,type,ispreadd)"+
							" values('"+RecordSet.getString("nodeid")+"',1,'"+wfid+"','"+actname+"',2,1) ";
						rs1.executeSql(sql);
						**/
					//}
					
				}
				
				//插action
				String sql2="select id from workflowactionset where actionname='"+actname+"' and workflowid="+wfid;
				RecordSet.executeSql(sql2);
				while(RecordSet.next()){
					int tmpactid=RecordSet.getInt("id");
					new WorkflowActionManager().doDeleteWsAction(tmpactid);
				}
				
				if(!"-1".equals(acttype) ){
					workflowActionManager.setActionid(0);
					workflowActionManager.setWorkflowid(Util.getIntValue( wfid));
					workflowActionManager.setActionorder(0);
					if("0".equals(acttype)){
						workflowActionManager.setNodeid(0);
						workflowActionManager.setNodelinkid(Util.getIntValue( actlink,0));
					}else if("1".equals(acttype)){
						workflowActionManager.setNodeid(Util.getIntValue( actnode,0));
						workflowActionManager.setNodelinkid(0);
					}
					workflowActionManager.setIspreoperator(Util.getIntValue( actmethod,0));
					workflowActionManager.setActionname(actname);
					workflowActionManager.setInterfaceid(actname);
					workflowActionManager.setInterfacetype(3);
					workflowActionManager.setIsused(1);
					workflowActionManager.doSaveWsAction();
				}
				
				
				
			}
		}
		CptFieldComInfo.removeCache();
		if(!"apply".equalsIgnoreCase(wftype)){
			CptWfUtil.regenTrgCptFrozennumUpdate();
		}
		
	}else{//全部删除

		rs2.executeSql("select * from "+grouptablename+" where wftype='"+wftype+"' ");
		while(rs2.next()){
			int tmpwfid=rs2.getInt("wfid");
			String sql2="select id from workflowactionset where actionname='"+actname+"' and workflowid="+tmpwfid;
			rs3.executeSql(sql2);
			while(rs3.next()){
				int tmpactid=rs3.getInt("id");
				new WorkflowActionManager().doDeleteWsAction(tmpactid);
			}
		}
		
		RecordSet.executeSql("delete from "+grouptablename+" where wftype='"+wftype+"' ");
		CptFieldComInfo.removeCache();
		if(!"apply".equalsIgnoreCase(wftype)){
			CptWfUtil.regenTrgCptFrozennumUpdate();
		}
	}
	
	out.print("[]");
}else if("loadgroupdata".equalsIgnoreCase(src)){//读取保存的信息
	
	//存表单字段信息
	HashMap<String,String> hm=new HashMap<String,String>();
	rs1.executeSql("select * from workflow_billfield where billid in(select formid from workflow_base where id in(select wfid from "+grouptablename+" where wftype='"+wftype+"' ))");
	while(rs1.next()){
		hm.put(rs1.getString("id"), rs1.getString("fieldlabel"));
	}
	
	JSONArray arr=new JSONArray();

	RecordSet.executeSql("select * from "+grouptablename+" where wftype='"+wftype+"' order by id ");
	
	while(RecordSet.next()){
		JSONArray jsonArray=new JSONArray();
		
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("name", "wfid");
		jsonObject.put("value", RecordSet.getString("wfid"));
		jsonObject.put("label", WorkflowComInfo.getWorkflowname( RecordSet.getString("wfid")));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "sqr");
		jsonObject.put("value", RecordSet.getString("sqr"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("sqr")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "zczl");
		jsonObject.put("value", RecordSet.getString("zczl"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("zczl")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "zc");
		jsonObject.put("value", RecordSet.getString("zc"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("zc")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "sl");
		jsonObject.put("value", RecordSet.getString("sl"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("sl")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "zcz");
		jsonObject.put("value", RecordSet.getString("zcz"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("zcz")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "jg");
		jsonObject.put("value", RecordSet.getString("jg"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("jg")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "rq");
		jsonObject.put("value", RecordSet.getString("rq"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("rq")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		if("mend".equalsIgnoreCase(wftype)){
			jsonObject=new JSONObject();
			jsonObject.put("name", "wxqx");
			jsonObject.put("value", RecordSet.getString("wxqx"));
			jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("wxqx")),0),user.getLanguage())));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "browser");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "wxdw");
			jsonObject.put("value", RecordSet.getString("wxdw"));
			jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("wxdw")),0),user.getLanguage())));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "browser");
			jsonArray.add(jsonObject);
		}else{
			jsonObject=new JSONObject();
			jsonObject.put("name", "ggxh");
			jsonObject.put("value", RecordSet.getString("ggxh"));
			jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("ggxh")),0),user.getLanguage())));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "browser");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "cfdd");
			jsonObject.put("value", RecordSet.getString("cfdd"));
			jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("cfdd")),0),user.getLanguage())));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "browser");
			jsonArray.add(jsonObject);
		}
		
		
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "bz");
		jsonObject.put("value", RecordSet.getString("bz"));
		jsonObject.put("label", Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue( hm.get(RecordSet.getString("bz")),0),user.getLanguage())));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "browser");
		jsonArray.add(jsonObject);
		
		//节点配置below==============================
		String actconf=Util.null2String( RecordSet.getString("actname"));
		String[]s= Util.TokenizerString2(actconf, ",");
		if(s!=null&&s.length>=4){
			acttype=s[0];
			actnode=s[1];
			actlink=s[2];
			actmethod=s[3];
		}
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "acttype");
		jsonObject.put("value", acttype);
		jsonObject.put("label", "");
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "select");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "actnode");
		jsonObject.put("value", actnode);
		jsonObject.put("label", "");
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "select");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "actlink");
		jsonObject.put("value", actlink);
		jsonObject.put("label", "");
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "select");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "actmethod");
		jsonObject.put("value", actmethod);
		jsonObject.put("label", "");
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "select");
		jsonArray.add(jsonObject);
		
		//节点配置up==============================
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupid");
		jsonObject.put("value", RecordSet.getString("id"));
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		arr.add(jsonArray);
	}
	
	//System.out.println("str:"+arr.toString());
	out.print(arr.toString());
}
%>