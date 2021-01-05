
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%
  String operation = Util.null2String(request.getParameter("operation"));
  int docSecCategoryMouldId = Util.getIntValue(request.getParameter("docSecCategoryMouldId"));
  int secCategoryId = Util.getIntValue(request.getParameter("seccategory"));
  int mould = Util.getIntValue(request.getParameter("mould"));
  int userid=user.getUID();
  int subid = Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secCategoryId));
  int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subid),0);
  MultiAclManager am = new MultiAclManager();
  CategoryManager cm = new CategoryManager();
  boolean hasSecManageRight = false;
  int parentid = Util.getIntValue(SecCategoryComInfo.getParentId(""+secCategoryId));
  if(parentid>0)
		hasSecManageRight = am.hasPermission(parentid, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);	
  if(!HrmUserVarify.checkUserRight("DocSecCategoryAdd:Add", user) && !hasSecManageRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
  }
  
  if(operation.equalsIgnoreCase("save") ){
    String[] bookMarkIds = request.getParameterValues("bookMarkId");
    String[] docSecCategoryDocPropertyIds = request.getParameterValues("docSecCategoryDocPropertyId");
    if (bookMarkIds!=null&&docSecCategoryDocPropertyIds!=null) {
		int intBookMarkId=-1;
		int intDocSecCategoryDocPropertyId=-1;
    	for(int i=0;i<bookMarkIds.length;i++){
    		//RecordSet1.executeSql("select count(0) from DocSecCategoryMouldBookMark where DocSecCategoryMouldId = " + docSecCategoryMouldId + " and BookMarkId = " + bookMarkIds[i]);
    		//if(RecordSet1.next()&&RecordSet1.getInt(1)>0)
    		//	RecordSet.executeSql("update DocSecCategoryMouldBookMark set DocSecCategoryDocPropertyId = " + docSecCategoryDocPropertyIds[i] + " where DocSecCategoryMouldId = " + docSecCategoryMouldId + " and BookMarkId = " + bookMarkIds[i]);
    		//else
			//	RecordSet.executeSql("insert into DocSecCategoryMouldBookMark (DocSecCategoryMouldId,BookMarkId,DocSecCategoryDocPropertyId) values ("+docSecCategoryMouldId+","+bookMarkIds[i]+","+docSecCategoryDocPropertyIds[i]+")"); 
			intBookMarkId = Util.getIntValue(bookMarkIds[i],-1);
			intDocSecCategoryDocPropertyId=Util.getIntValue(Util.null2String(docSecCategoryDocPropertyIds[i]).trim(),-1);
			RecordSet1.executeSql("select count(0) from DocSecCategoryMouldBookMark where DocSecCategoryMouldId = " + docSecCategoryMouldId + " and BookMarkId = " + intBookMarkId);
			if(RecordSet1.next()&&RecordSet1.getInt(1)>0){
    			RecordSet.executeSql("update DocSecCategoryMouldBookMark set DocSecCategoryDocPropertyId = " + intDocSecCategoryDocPropertyId + " where DocSecCategoryMouldId = " + docSecCategoryMouldId + " and BookMarkId = " + intBookMarkId);
    		}else if(intBookMarkId>0&&intDocSecCategoryDocPropertyId>0){
				RecordSet.executeSql("insert into DocSecCategoryMouldBookMark (DocSecCategoryMouldId,BookMarkId,DocSecCategoryDocPropertyId) values ("+docSecCategoryMouldId+","+intBookMarkId+","+intDocSecCategoryDocPropertyId+")"); 
		    }
    	}
    }
	response.sendRedirect("/docs/category/ContentSetting.jsp?isclose=1&seccategory="+secCategoryId+"&tab=4&id="+docSecCategoryMouldId+"&mould="+mould);
  }
%>