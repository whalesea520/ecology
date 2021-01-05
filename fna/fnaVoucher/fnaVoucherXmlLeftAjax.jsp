<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	int userId = user.getUID();
	
	String id = Util.null2String(request.getParameter("id"));
	String name = Util.null2String(request.getParameter("name"));
    int fnaVoucherXmlId = Util.getIntValue(request.getParameter("fnaVoucherXmlId"), 0);

	if(fnaVoucherXmlId>0 && "".equals(id)){//初始化树
		String sql1 = "select a.* from fnaVoucherXml a "+
			" where a.id = "+fnaVoucherXmlId;
		rs1.executeSql(sql1);
		if(rs1.next()){
			String xmlName = Util.null2String(rs1.getString("xmlName")).trim();
			
			String isParent = "true";
			
			result.append("{"+
				"id:"+JSONObject.quote(fnaVoucherXmlId+"_"+0)+","+
				"name:"+JSONObject.quote(xmlName)+","+
				"isParent:"+isParent+""+
				//",iconSkin:"+JSONObject.quote("xmlFile")+
				"}");
		}
		
	}else{
		String[] idArray = id.split("_");
		int fnaVoucherXmlContentId = Util.getIntValue(idArray[1], 0);
		
		int idx = 0;
		String sql1 = "select a.* from fnaVoucherXmlContent a "+
			" where a.fnaVoucherXmlId = "+fnaVoucherXmlId+" "+
			" and a.contentParentId = "+fnaVoucherXmlContentId+" "+
			" ORDER BY a.contentType asc, a.orderId asc, a.id asc";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int _id = rs1.getInt("id");
			String contentType = Util.null2String(rs1.getString("contentType")).trim();//--?：xml头属性（默认主表中依据包含：version='1.0' encoding='UTF-8'）；a:属性；e：元素；
			String contentName = Util.null2String(rs1.getString("contentName")).trim();
			int contentParentId = rs1.getInt("contentParentId");
			
			boolean isAttr = ("?".equals(contentType) || "a".equals(contentType));
			
			String iconSkin = "xmlNode";
			//String full_contentName = "["+SystemEnv.getHtmlLabelName(15586, user.getLanguage())+"]"+contentName;//节点
			if(isAttr){
				iconSkin = "xmlAttr";
				//full_contentName = "["+SystemEnv.getHtmlLabelName(713, user.getLanguage())+"]"+contentName;//属性
			}
			
			if(idx>0){
				result.append(",");
			}
			
			String isParent = "true";
			if(isAttr){
				isParent = "false";
			}else{
				String sql2 = "select count(*) cnt from fnaVoucherXmlContent a where a.contentParentId = "+_id;
				rs2.executeSql(sql2);
				if(rs2.next() && rs2.getInt("cnt") > 0){
					isParent = "true";
				}else{
					isParent = "false";
				}
			}
			
			result.append("{"+
				"id:"+JSONObject.quote(fnaVoucherXmlId+"_"+_id)+","+
				"name:"+JSONObject.quote(contentName+"("+_id+")")+","+
				"isParent:"+isParent+""+
				",iconSkin:"+JSONObject.quote(iconSkin)+
				"}");
			idx++;
		}
		
	}

}
//System.out.println("result="+result.toString());
%><%="["+result.toString()+"]" %>