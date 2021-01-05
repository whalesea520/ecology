<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User  user= HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}

JSONObject jsonObject=new JSONObject();
RecordSet.executeSql("select cptdetachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
	detachable = RecordSet.getInt("cptdetachable");
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("addassortment")||operation.equals("editassortment")){
	String assortmentname = Util.fromScreen(request.getParameter("assortmentname"),user.getLanguage());
	String assortmentmark = Util.fromScreen(request.getParameter("assortmentmark"),user.getLanguage());
	String supassortmentid = Util.null2String(request.getParameter("supassortmentid"));
	String supassortmentstr = Util.null2String(request.getParameter("supassortmentstr"));
	String assortmentremark=Util.fromScreen(request.getParameter("Remark"),user.getLanguage());
	int subcompanyid1=Util.getIntValue(request.getParameter("subcompanyid1"),0);
	String tempsql11 = "";
	if(1==detachable){
		tempsql11=" and subcompanyid1="+subcompanyid1+" ";
	}else{
		tempsql11=" and (subcompanyid1='' or subcompanyid1 is null or subcompanyid1=0) ";
	}

 if(operation.equals("addassortment")){
	 if(!HrmUserVarify.checkUserRight("CptCapitalGroupAdd:Add",user)) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		   }
	String para = "";

	para  = assortmentname;
	para += separator+assortmentmark;
	para += separator+assortmentremark;
	para += separator+supassortmentid;
	para += separator+supassortmentstr;



	/*判断是否编号重复*/
	boolean invalid=false;
	RecordSet.executeProc("CptCapitalAssortment_SelectAll","");
	while(RecordSet.next()){
		String 	tempmark = RecordSet.getString("assortmentmark");
		String  tempsupassortmentstr = RecordSet.getString("supassortmentstr");
		if(assortmentmark.equals(tempmark)&&supassortmentstr.equals(tempsupassortmentstr)){
			//response.sendRedirect("CptAssortmentAdd.jsp?msgid=31&paraid="+supassortmentid);
			invalid=true;
			break;
		}
	}
	
	if(invalid){
		jsonObject.put("msgid", 31);
		out.print(jsonObject.toString());
	}else{
		/*判断统计资产组是否重名*/
		
		String sql = "select assortmentname from CptCapitalAssortment where assortmentname='"+assortmentname+"' "+tempsql11+" and supassortmentid="+supassortmentid;
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			//response.sendRedirect("CptAssortmentAdd.jsp?msgid=162&paraid="+supassortmentid);
			jsonObject.put("msgid", 162);
			out.print(jsonObject.toString());
		}else{

            RecordSet.executeSql("update CptCapitalAssortment set capitalcount=0 where id="+supassortmentid);
			RecordSet.executeProc("CptCapitalAssortment_Insert",para);
			RecordSet.next();
			int	id = RecordSet.getInt(1);
			if(id == -1)  {
				//response.sendRedirect("CptAssortmentAdd.jsp?msgid=34&paraid="+supassortmentid);
				jsonObject.put("msgid", 34);
				out.print(jsonObject.toString());
				//return ;
			}else{
				if(subcompanyid1>0){
					RecordSet.executeSql("update CptCapitalAssortment set subcompanyid1='"+subcompanyid1+"' where id= "+id);
				}
				
				

				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(id);
				SysMaintenanceLog.setRelatedName(assortmentname);
				SysMaintenanceLog.setOperateType("1");
				SysMaintenanceLog.setOperateDesc("CptCapitalAssortment_Insert,"+para);
				SysMaintenanceLog.setOperateItem("43");
				SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalGroupAdd:Add"));
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();

				CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
				
				out.print(jsonObject.toString());
			}
			
		}
		
	}
		
	//response.sendRedirect("CptAssortmentView.jsp?paraid="+id);
} //end (operation.equals("addassortment"))
 else if(operation.equals("editassortment")){
	if(!HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit",user)) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		   }
  	String assortmentid = Util.null2String(request.getParameter("assortmentid"));

	String para = "";
	para = assortmentid;
	para += separator+assortmentname;
	para += separator+assortmentmark;
	para += separator+assortmentremark;
	para += separator+supassortmentid;
	para += separator+supassortmentstr;


	/*判断是否编号重复*/
	boolean invalid=false;
	RecordSet.executeProc("CptCapitalAssortment_SelectAll","");
	while(RecordSet.next()){
		String  tempid = RecordSet.getString("id");
		String 	tempmark = RecordSet.getString("assortmentmark");
		String  tempsupassortmentstr = RecordSet.getString("supassortmentstr");
		if(assortmentmark.equals(tempmark)&&supassortmentstr.equals(tempsupassortmentstr)&&!assortmentid.equals(tempid)){
			//response.sendRedirect("CptAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=31");
			invalid=true;
			break;
		}
	}
	if(invalid){//编号重复
		jsonObject.put("msgid", 31);
		out.print(jsonObject.toString());
	}else{
		/*判断资产组是否重名*/
		String sql = "select assortmentname from CptCapitalAssortment where assortmentname='"+assortmentname+"' "+tempsql11+" and supassortmentid="+supassortmentid+"and id<>"+assortmentid;
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			//response.sendRedirect("/cpt/maintenance/CptAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=162");
			jsonObject.put("msgid", 162);
			out.print(jsonObject.toString());
		}else{
			//更新
			RecordSet.executeProc("CptCapitalAssortment_Update",para);

			if(RecordSet.next()) {
				//response.sendRedirect("CptAssortmentEdit.jsp?paraid="+assortmentid+"&msgid=13");
				jsonObject.put("msgid", 13);
				out.print(jsonObject.toString());
			}else{
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(Util.getIntValue(assortmentid));
				SysMaintenanceLog.setRelatedName(assortmentname);
				SysMaintenanceLog.setOperateType("2");
				SysMaintenanceLog.setOperateDesc("CptCapitalAssortment_Update,"+para);
				SysMaintenanceLog.setOperateItem("43");
				SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalGroupEdit:Edit"));
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
				out.print(jsonObject.toString());
			}
		}
	}
	//response.sendRedirect("CptAssortmentView.jsp?paraid="+assortmentid);
 }//end if (operation.equals("editassortment"))
}//end if (operation.equals("addassortment")||operation.equals("editassortment"))
 else if(operation.equals("deleteassortment")){
	 if(!HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit",user)) {
			response.sendRedirect("/notice/noright.jsp") ;
			return ;
		   }
  	int assortmentid = Util.getIntValue(request.getParameter("assortmentid"));
	String para = ""+assortmentid;
	RecordSet.executeSql("update CptCapitalAssortment set capitalcount=0 where id="+para);
	RecordSet.executeProc("CptCapitalAssortment_Delete",para);

	if(RecordSet.next() && RecordSet.getString(1).equals("-1")){
		//response.sendRedirect("CptAssortmentTab.jsp?paraid="+assortmentid+"&msgid=20");
		jsonObject.put("msgid", 20);
		out.print(jsonObject.toString());
	}else{
		 CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
		 out.print(jsonObject.toString());
	}
  
 }else if("batchdeleteassortment".equalsIgnoreCase (operation)){
	String assortmentid = Util.null2String(request.getParameter("assortmentid"));

	String [] arr= Util.TokenizerString2(assortmentid, ",");
	for(int i=0;i<arr.length;i++){
		String para = ""+arr[i];
		RecordSet.executeSql("update CptCapitalAssortment set capitalcount=0 where id="+para);
		RecordSet.executeProc("CptCapitalAssortment_Delete",para);
	}

    CapitalAssortmentComInfo.removeCapitalAssortmentCache() ;
    out.print(jsonObject.toString());
 }


%>

