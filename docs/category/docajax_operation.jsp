<%@page import="weaver.docs.docs.CustomFieldManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.Writer" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.JSONObject" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="mouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="CustomDictManager" class="weaver.docs.docs.CustomDictManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>
<jsp:useBean id="SecCategoryCustomSearchComInfo" class="weaver.docs.category.SecCategoryCustomSearchComInfo" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<%
  User user = HrmUserVarify.getUser(request,response);
  String src = Util.null2String(request.getParameter("src"));
  if(src.equals("checkDocCusSame")){  //检查字段是否已存在
  	String fieldname = Util.null2String(request.getParameter("fieldname"));
  	String fieldid = Util.null2String(request.getParameter("fieldid"));
     String sql = "select 1 from cus_formdict where fieldname = '"+fieldname+"'";
     if(!fieldid.equals("")){
     	sql += " and id!="+fieldid;
     }
     if(fieldname.equals("")){
     	out.println("1");//失败
     	return;
     }
     if(rs.execute(sql)){
     	if(rs.next()){
     		out.println("1");
     	}else{
     		out.println("0");//成功
     	}
     }else{
     	out.println("1");
     }

  }else if(src.equalsIgnoreCase("attachSecCategory") ){//关联自定义字段
	String secCategoryId = Util.null2String(request.getParameter("secCategoryId"));
	String fieldids = Util.null2String(request.getParameter("fieldids"));
	String[] fieldArr = fieldids.split(",");
	String sql = "select fieldid from cus_formfield where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId;
	if(!fieldids.equals("")){
		sql += " and fieldid in("+fieldids+")";
	}
	List<String> cusids = new ArrayList<String>();
	rs.executeSql(sql);
	while(rs.next()){
		cusids.add(rs.getString(1));
	}
	sql = "select fieldid from DocSecCategoryDocProperty where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId;
	if(!fieldids.equals("")){
		sql += " and fieldid in("+fieldids+")";
	}
	rs.executeSql(sql);
	List<String> secProp = new ArrayList<String>();
	while(rs.next()){
		secProp.add(rs.getString(1));
	}
	try{
		rst.setAutoCommit(false);
		String logsql = "";
		//先执行删除字段操作
		sql = "delete from cus_formfield where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId;
		if(!fieldids.equals("")){
			sql += " and fieldid not in("+fieldids+")";
		}
		logsql = sql;
		rst.executeSql(sql);
		sql = "delete from DocSecCategoryDocProperty where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId;
		if(!fieldids.equals("")){
			sql += " and fieldid not in("+fieldids+")";
		}
		logsql = logsql+";"+ sql;
		rst.executeSql(sql);

		int maxfieldorder=0;

		rst.executeSql("select max(fieldOrder) from cus_formfield where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId);
		if(rst.next()){
			maxfieldorder=Util.getIntValue(rst.getString(1),-1);
			maxfieldorder++;
		}

		int maxviewindex=0;
		rst.executeSql("select max(viewindex) from DocSecCategoryDocProperty where seccategoryId="+secCategoryId);
		if(rst.next()){
			maxviewindex=Util.getIntValue(rst.getString(1),-1);
			maxviewindex++;
		}

		for(int i=0;!fieldids.equals("")&&i<fieldArr.length;i++){
			if(cusids.indexOf(fieldArr[i])!=-1){
				sql = "update cus_formfield set fieldorder="+i+" where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId+" and fieldid="+fieldArr[i];
			}else{
				sql = "insert into cus_formfield(scope,scopeid,fieldid,fieldorder) values('DocCustomFieldBySecCategory',"+secCategoryId+","+fieldArr[i]+","+(maxfieldorder+i)+")";
			}
			logsql = logsql+";"+ sql;
			rst.executeSql(sql);
			
			if(secProp.indexOf(fieldArr[i])!=-1){
				//sql = "update DocSecCategoryDocProperty set viewindex="+i+" where scope='DocCustomFieldBySecCategory' and scopeid="+secCategoryId+" and fieldid="+fieldArr[i];
			}else{
				sql = "insert into DocSecCategoryDocProperty(scope,scopeid,seccategoryid,fieldid,viewindex,iscustom,visible,type,mustinput) values('DocCustomFieldBySecCategory',"+secCategoryId+","+secCategoryId+","+fieldArr[i]+","+(maxviewindex+i)+",1,1,0,0)";
				logsql = logsql+";"+ sql;
				rst.executeSql(sql);
			}
		}
		log.insSysLogInfo(user, Util.getIntValue(secCategoryId), SecCategoryComInfo.getSecCategoryname(secCategoryId), logsql, "3", "24", 0, request.getRemoteAddr());
		rst.commit();
		SubCategoryComInfo.removeMainCategoryCache();
		SecCategoryComInfo.removeMainCategoryCache();
		
		SecCategoryDocPropertiesComInfo.removeCache();
		SecCategoryCustomSearchComInfo.checkDefaultCustomSearch(Util.getIntValue(secCategoryId));
		out.println("0");
	}catch(Exception e){
		e.printStackTrace();
		rst.writeLog(e);
		rst.rollback();
		out.println("1");
	}
	
}else if(src.equals("docCusFieldDelete")){//删除自定义字段
  	 String id = Util.null2String(request.getParameter("id"));
  	 String[] idArr = id.split(",");
  	 boolean success = true;
  	String scope = Util.null2String(request.getParameter("scope"));
  	if(scope.equals(""))scope = "DocCustomFieldBySecCategory";
  	 for(int i=0;i<idArr.length;i++){
  		CustomDictManager.setScope(scope);
  		CustomDictManager.setClientAddress(request.getRemoteAddr());
  		CustomDictManager.setUser(user);
  	 	success = CustomDictManager.deleteField(idArr[i]);
  	 }
  	 if(success){
  	 	out.println("0");//删除成功
  	 }else{
  	 	out.println("1");//删除失败
  	 }
  	 
}else if(src.equals("prjtypeCusFieldDelete")){//4prj删除项目类型自定义字段
 	 String id = Util.null2String(request.getParameter("id"));
 	 String scopeid = Util.null2String(request.getParameter("scopeid"));
	String[] idArr = id.split(",");
	 boolean success = true;
	 for(int i=0;i<idArr.length;i++){
		 String sql=" delete cus_formfield where scope='ProjCustomField' and scopeid='"+scopeid+"' and fieldid='"+idArr[i]+"' ";
		 rs.executeSql(sql);
		 rs.executeSql("select fieldname from cus_formdict where id='"+idArr[i]+"' ");
		 if(rs.next()){
			 String fieldname= rs.getString("fieldname");
			 boolean isused= CustomFieldManager.fieldIsUsed4all( fieldname);
			 if(!isused){
				 success = CustomDictManager.deleteField(idArr[i]);
			 }
		 }
	 }
	 if(success){
	 	out.println("0");//删除成功
	 }else{
	 	out.println("1");//删除失败
	 }

}else if(src.equalsIgnoreCase("getSecMaxUploadSize")){
	String id = Util.null2String(request.getParameter("secid"));
	int maxUploadSize = DocUtil.getMaxUploadImageSize(Util.getIntValue(id,-1));
	JSONObject json = new JSONObject();
	json.put("maxUploadSize",maxUploadSize);
	out.println(json.toString());
}else{
  	out.println("1");
  }
  
  %>