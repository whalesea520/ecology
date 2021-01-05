
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>

<%@ page import="org.json.*" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
	int docid = Util.getIntValue(request.getParameter("docid"),0);
	int doceditionid = Util.getIntValue(request.getParameter("doceditionid"),0);
	String readerCanViewHistoryEdition= Util.null2String(request.getParameter("readerCanViewHistoryEdition"));
	boolean canEditHis= Util.null2String(request.getParameter("canEditHis")).equals("true");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	JSONArray jsonArrayReturn= new JSONArray();
	
	int editionCount = 0;
	if(doceditionid>-1){
		rs.executeSql(" select count(0) as c from DocDetail where doceditionid = " + doceditionid);
		if(rs.next()){
			editionCount = Util.getIntValue(rs.getString("c"),0);
		}
	}


	if(doceditionid>-1){
		String   usertype=null;
		int docLastModUserId=0;
		String docsubject=null;
		String docLastModDate=null;
		String docLastModTime=null;
	    rs.executeSql(" select id,isHistory,usertype,docLastModUserId,docsubject,docLastModDate,docLastModTime from DocDetail where doceditionid = " + doceditionid + " order by id desc ");
	    while(rs.next()){
			JSONObject oJson= new JSONObject();
	        int currDocId = Util.getIntValue(rs.getString("id"));
	        int currIsHistory = Util.getIntValue(rs.getString("isHistory"));

	        usertype = Util.null2String(rs.getString("usertype"));
	        docLastModUserId = Util.getIntValue(rs.getString("docLastModUserId"));
	        docsubject = Util.null2String(rs.getString("docsubject"));
	        docLastModDate = Util.null2String(rs.getString("docLastModDate"));
	        docLastModTime = Util.null2String(rs.getString("docLastModTime"));

	        String currCreater = "";
			String currUserLinkUrl = "";
			if (Util.getIntValue(usertype) == 1) {
			    currCreater = ResourceComInfo.getLastname("" + docLastModUserId);
				currUserLinkUrl = "/hrm/resource/HrmResource.jsp?id=" + docLastModUserId;
			} else {
			    currCreater = CustomerInfoComInfo.getCustomerInfoname("" + docLastModUserId);
				currUserLinkUrl = "/CRM/data/ViewCustomer.jsp?CustomerID=" + docLastModUserId;
			}
			String tempImg="";
			if(currDocId==docid){
				tempImg="<img src='/images/replyDoc/openfld_wev8.gif'/>";
			}else{
				tempImg="<img src='/images/replyDoc/news_general_wev8.gif'/>";
			}

			if(currIsHistory==1&&!readerCanViewHistoryEdition.equals("1") && !canEditHis){
				oJson.put("",tempImg+docsubject);
			}else{
				oJson.put("docsubject",tempImg+"<a href='/docs/docs/DocDsp.jsp?id="+currDocId+"'>"+docsubject+"</a>");
			}

			oJson.put("versionid",DocComInfo.getEditionView(currDocId)+"("+DocComInfo.getStatusView(currDocId,user)+")");	
			oJson.put("docLastModUserId","<img src='/images/replyDoc/userinfo_wev8.gif' border='0'/><a href=\"javaScript:openhrm('"+docLastModUserId+"');\" onclick='pointerXY(event);'>"+currCreater+"</a>");
			oJson.put("doclastmoditime",docLastModDate+" "+docLastModTime);
			oJson.put("expanded",true);
			oJson.put("leaf",true);
			oJson.put("uiProvider","col");		

			jsonArrayReturn.put(oJson);
	    }
		
    } 
	out.println(jsonArrayReturn.toString());
%>


