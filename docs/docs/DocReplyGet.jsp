
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.json.*" %>
<%@ page import="org.jdom.*" %>
<%@ page import="org.jdom.xpath.XPath" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="du" class="weaver.docs.docs.DocUtil" scope="page" />


<%!
	private  JSONArray getChildrenData(List nodeList,String CurrentDocId) throws Exception {
		
		JSONArray jsonArrayReturn= new JSONArray();
		if (nodeList==null || nodeList.size()==0) return  jsonArrayReturn;
		
		for (int i=0;i<nodeList.size();i++){
			JSONObject jsonObject=new JSONObject();				
			Element nodeDoc=(Element)nodeList.get(i);				
			List nodeChildRen=nodeDoc.getChildren();		

			String tempDocId=Util.null2String(nodeDoc.getAttributeValue("id"));		
			
			//System.out.println(tempDocId);
			
			String userImg=Util.null2String(nodeDoc.getAttributeValue("userImg"));
			String docImg=Util.null2String(nodeDoc.getAttributeValue("docImg"));
			String userLinkUrl=Util.null2String(nodeDoc.getAttributeValue("userLinkUrl"));
			String canRead=Util.null2String(nodeDoc.getAttributeValue("canRead"));
			
			//System.out.println(docid);			
			if (nodeChildRen==null || nodeChildRen.size()==0) {  	  //无子节点				
			     jsonObject.put("leaf",true);		
			} else {
				jsonObject.put("leaf",false);
				JSONArray tempChildren=getChildrenData(nodeChildRen,CurrentDocId);
				jsonObject.put("children",tempChildren);				
			}			
			jsonObject.put("doccreatorname","<img src='/images/replyDoc/"+userImg+"' border='0'/>&nbsp;&nbsp;<a href='javascript:void(0);' onclick='pointerXY(event);javascript:openhrm("+userLinkUrl+");'>"+nodeDoc.getAttributeValue("creater")+"</a>");	
			jsonObject.put("doclastmoditime",nodeDoc.getAttributeValue("date"));	
			
			if(tempDocId.equals(CurrentDocId))	jsonObject.put("iconCls","icon_replyDoc_this");	 
			else jsonObject.put("iconCls","icon_replyDoc");	

			jsonObject.put("uiProvider","col");					
			jsonObject.put("expanded",true);

			//jsonObject.put("docsubject","<a href='#' onclick='onClickReplyDoc(\""+tempDocId+"\")'>"+nodeDoc.getAttributeValue("subject")+"</a>");
			if("yes".equals(canRead))					
				jsonObject.put("docsubject","<a href='#' onclick='openFullWindowForXtable(\"/docs/docs/DocDsp.jsp?id="+tempDocId+"\")' style='vertical-align:baseline' class='x-grid3-cell-inner'>"+nodeDoc.getAttributeValue("subject")+"</a>");			
			else 
				jsonObject.put("docsubject","<font style='vertical-align:baseline' class='x-grid3-cell-inner'>"+nodeDoc.getAttributeValue("subject")+"</font>");
				
			jsonArrayReturn.put(jsonObject);		
		}
		
		
		return jsonArrayReturn;
	}
%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	int docid = Util.getIntValue(request.getParameter("docid"),0);
	
	boolean isReply = Util.null2String(request.getParameter("isReply")).equals("true")?true:false;
	int userId = user.getUID();
	String userType = user.getLogintype();
	int userLanguage = user.getLanguage();
	
	

	Document docReply=du.getReplyDocObj(docid,isReply, userId,	userType, userLanguage);
	List docList=XPath.selectNodes(docReply,"/ROOT/DOC");
	
	
	
	//XMLOutputter xmlout = new XMLOutputter();
	//String xmlStr=xmlout.outputString(docReply);  
	//JSONArray jsonArray=JSONML.toJSONArray(xmlStr)  ;
	out.println(getChildrenData(docList,""+docid).toString());
%>



