
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CategoryUtil" class="weaver.docs.category.CategoryUtil" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;
String userId=""+user.getUID();
boolean canedit=false;
if(HrmUserVarify.checkUserRight("SendDoc:Manage",user)) {
	canedit=true;
   }
if (!canedit) response.sendRedirect("/notice/noright.jsp");
String id = ""+Util.getIntValue(request.getParameter("id"),0);
String method = Util.null2String(request.getParameter("method"));
String docNumber_1 = Util.null2String(request.getParameter("docNumber_1"));
String docNumberYear_1 = Util.null2String(request.getParameter("docNumberYear_1"));
String docNumberIssue_1 = Util.null2String(request.getParameter("docNumberIssue_1"));
String sqlStr="";
int docCount=Util.getIntValue(request.getParameter("docCount"),0);
    if (method.equals("save")){
       sqlStr="update DocSendDocDetail set docNumber_1='"+docNumber_1+"',docNumberYear_1='"+docNumberYear_1+"',docNumberIssue_1='"+docNumberIssue_1+"',signer="+userId+",signDate='"+currentdate+"',status='1' where id="+id;
       RecordSet.executeSql(sqlStr);
       for(int i=0;i<docCount;i++){
           String docId=""+Util.getIntValue(request.getParameter("docId_"+i),0);
           String secIdNew=""+Util.getIntValue(request.getParameter("secId_"+i),0);
           String subCategoryId = SecCategoryComInfo.getSubCategoryid(secIdNew);
           String mainCategoryId = SubCategoryComInfo.getMainCategoryid(subCategoryId);
           String secIdOld="";
           RecordSet.executeSql("select seccategory from DocDetail where id="+docId);
           RecordSet.next();
           secIdOld=RecordSet.getString("seccategory");
           if(!secIdNew.equals(secIdOld)) {
               RecordSet.executeSql("update DocDetail set maincategory="+mainCategoryId+",subcategory="+subCategoryId+",seccategory="+secIdNew+" where id="+docId);
               DocManager.setSeccategory(Util.getIntValue(secIdNew,0));
               DocManager.setId(Util.getIntValue(docId,0));
               DocManager.AddShareInfo() ;
               DocViewer.setDocShareByDoc(docId);
           }
       }
    }
response.sendRedirect("/docs/sendDoc/docCheckDetail.jsp?sendDocId="+id);
%>