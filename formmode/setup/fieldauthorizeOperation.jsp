<%@page import="weaver.conn.RecordSetTrans"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.log.LogType"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
  String operate = Util.null2String(request.getParameter("operate"));
  if(operate.equals("Addfieldauthorize")){	//新增模板
	  int modeId = Util.getIntValue(StringHelper.null2String(request.getParameter("modeId")),0);
	  int formId = Util.getIntValue(StringHelper.null2String(request.getParameter("formId")),0);
	  String[] fieldauthorize_ids = request.getParameterValues("fieldauthorize_id");
	  String[] fieldids = request.getParameterValues("fieldid");
	  String[] isopens = request.getParameterValues("isopen");
	  String[] opttypes = request.getParameterValues("opttype");
	  String[] layoutids = request.getParameterValues("layoutid");
	  String[] layoutlevels = request.getParameterValues("layoutlevel");
	  RecordSetTrans rst1 = new RecordSetTrans();
	  rst1.setAutoCommit(false);//设置为不自动提交
	  try{
		  for(int i=0;i<fieldids.length;i++){
			 int fieldauthorize_id = Util.getIntValue(fieldauthorize_ids[i],0);
			 int fieldid = Util.getIntValue(fieldids[i],0);
			 int isopen = Util.getIntValue(isopens[i],0);
			 int opttype = Util.getIntValue(opttypes[i],0);
			 int layoutid = Util.getIntValue(layoutids[i],0);
			 String layoutlevel = layoutlevels[i];
			 String sql = "";
			 if(fieldauthorize_id==0&&isopen==1){
				 sql="insert into ModeFieldAuthorize(modeid,formid,fieldid,opttype,layoutid,layoutlevel) values("+
						 modeId+","+formId+","+fieldid+","+opttype+","+layoutid+","+Util.getIntValue(layoutlevel)+")";
			 }else if(fieldauthorize_id!=0&&isopen==1){
				 sql="update ModeFieldAuthorize set modeid="+modeId+",formid="+formId+",fieldid="+fieldid+",opttype="+opttype
						 +",layoutid="+layoutid+",layoutlevel="+Util.getIntValue(layoutlevel)+" where id="+fieldauthorize_id;
			 }else if(fieldauthorize_id!=0&&isopen==0){
				 sql="delete from ModeFieldAuthorize where id="+fieldauthorize_id;
			 }
			 if(!StringHelper.isEmpty(sql))
				 rst1.executeSql(sql);//执行sql
		  }
		  rst1.commit();//提交
	  }catch(Exception e){
		  rst1.rollback();//回滚
		  e.printStackTrace();
	  }
	  response.sendRedirect("/formmode/setup/fieldauthorize.jsp?id="+modeId+"&formId="+formId);	  
  }else if("getBrowserLayout".equals(operate)){
	  String browserid = StringHelper.null2String(request.getParameter("browserid"));
	  int opttype = Util.getIntValue(StringHelper.null2String(request.getParameter("opttype")),0);
	  if(browserid.indexOf("browser")==-1)
		  return;
	  try{
	  Browser browser=(Browser)StaticObj.getServiceByFullname(browserid, Browser.class);
	  String customid = browser.getCustomid();
	  if(StringHelper.isEmpty(customid))
		  return;
	  rs.executeSql("select * from mode_custombrowser where id="+customid);
	  List<Map<String,String>> array = new ArrayList<Map<String,String>>();
	  if(rs.next()){
		  String tmpmodeid = rs.getString("modeid");
		  if(StringHelper.isEmpty(tmpmodeid))
			  return;
		  String sql="select * from modehtmllayout where type="+opttype+" and modeid="+tmpmodeid;
		  rs.executeSql(sql);
		  while(rs.next()){
			  Map<String,String> map = new HashMap<String,String>();
			  String layoutid = StringHelper.null2String(rs.getString("id"));
			  String layoutname = StringHelper.null2String(rs.getString("layoutname"));
			  map.put("layoutid", layoutid);
			  map.put("layoutname", layoutname);
			  array.add(map);
		  }
	  }
	  JSONArray data = JSONArray.fromObject(array);
	  out.print(data.toString());
	  }catch(org.apache.hivemind.ApplicationRuntimeException e){
	  }catch(Exception e){
		  e.printStackTrace();
	  }
  }
  %>