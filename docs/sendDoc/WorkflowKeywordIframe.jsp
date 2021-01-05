
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="WorkflowKeywordManager" class="weaver.docs.senddoc.WorkflowKeywordManager" scope="page" />
<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String operation=Util.null2String(request.getParameter("operation"));

String returnString="";

if(operation.equals("EditSave")){

    String newKeywordId=Util.null2String(request.getParameter("newKeywordId"));
	String newKeywordName = Util.fromScreen(request.getParameter("newKeywordName"),user.getLanguage());
    String newParentId=Util.null2String(request.getParameter("newParentId"));

	try {
            String keywordId="";             	
            String keywordName="";        	
            String parentId="";                    

            WorkflowKeywordComInfo.setTofirstRow();
            while(WorkflowKeywordComInfo.next()){
            	keywordId=WorkflowKeywordComInfo.getId();
            	keywordName = WorkflowKeywordComInfo.getKeywordName();
            	parentId=WorkflowKeywordComInfo.getParentId();
           	
            	if(newKeywordId!=null&&!newKeywordId.equals(keywordId)
            		  &&newParentId!=null&&newParentId.equals(parentId)
            		  &&newKeywordName!=null&&keywordName!=null
            	      &&newKeywordName.trim().equals(keywordName.trim())
            	  ){
            		returnString="2";         		
            	}
            }
               
        } catch (Exception e) {

        }
}else if(operation.equals("AddSave")){

	String newKeywordName = Util.fromScreen(request.getParameter("newKeywordName"),user.getLanguage());
    String newParentId=Util.null2String(request.getParameter("newParentId"));
    try {
        	//判断同级字段名称是否重复           	
            String keywordName="";
            String parentId="";          
            
            WorkflowKeywordComInfo.setTofirstRow();
            while(WorkflowKeywordComInfo.next()){
            	keywordName = WorkflowKeywordComInfo.getKeywordName();
            	parentId=WorkflowKeywordComInfo.getParentId();
            	if(newParentId!=null&&newParentId.equals(parentId)
            		  &&newKeywordName!=null&&keywordName!=null
            	      &&newKeywordName.trim().equals(keywordName.trim())
            	  ){
            		returnString="2";          		
            	}
            }
        } catch (Exception e) {

        }
}else if(operation.equals("Delete")){
    	//错误类型 1:当前字段有下级节点，不能删除。
    String keywordId=Util.null2String(request.getParameter("keywordId"));
    try {
        	//判断是否有下级节点，如果有下级节点则不可删除
            String parentId="";
            WorkflowKeywordComInfo.setTofirstRow();
            while(WorkflowKeywordComInfo.next()){
            	parentId = WorkflowKeywordComInfo.getParentId();
            	if(keywordId!=null&&keywordId.equals(parentId)){
            		returnString="1";       		
            	}
            }
        } catch (Exception e) {
        }	
}else if(operation.equals("UpdateKeywordData")){
	String docTitle=Util.null2String(request.getParameter("docTitle"));
	String docKeyword=Util.null2String(request.getParameter("docKeyword"));
	returnString=WorkflowKeywordManager.getKeyWordByDocTitle(docTitle,docKeyword);
}else if(operation.equals("UpdateKeywordDataEscape")){
	String docTitle=Util.null2String(request.getParameter("docTitle"));
	String docKeyword=Util.null2String(request.getParameter("docKeyword"));
	docTitle = weaver.general.Escape.unescape(docTitle);
	docKeyword = weaver.general.Escape.unescape(docKeyword);
	returnString=WorkflowKeywordManager.getKeyWordByDocTitle(docTitle,docKeyword);
}

%>
<script language="javascript">

<%if(operation.equals("EditSave")){%>

window.parent.checkForEditSave("<%=returnString%>");

<%}else if(operation.equals("AddSave")){%>

window.parent.checkForAddSave("<%=returnString%>");

<%}else if(operation.equals("Delete")){%>

window.parent.checkForDelete("<%=returnString%>");

<%}else if(operation.equals("UpdateKeywordData")){%>

window.parent.updateKeywordData("<%=returnString%>");

<%}else if(operation.equals("UpdateKeywordDataEscape")){%>

window.parent.updateKeywordData("<%=returnString%>");

<%}%>
</script>