
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.conn.ConnStatement" %>
 <%@ include file="/systeminfo/init.jsp" %>>
<jsp:useBean id="sc" class="weaver.security.sensitive.SensitiveCache" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
  String operation = Util.null2String(request.getParameter("operation"));
 
  if(operation.equalsIgnoreCase("add" )){
	if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String word = Util.toHtml5(Util.null2String(request.getParameter("word")).trim());
	if(word.equals("")){
		response.sendRedirect("/security/sensitive/AddSensitiveWord.jsp");
		return;
	}
	sc.addSesitiveWord(word);
	response.sendRedirect("/security/sensitive/SensitiveWords.jsp");
  } else if(operation.equalsIgnoreCase("edit" )){
	if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int id = Util.getIntValue(request.getParameter("id"));
	String word = Util.toHtml5(Util.null2String(request.getParameter("word")).trim());
	if(word.equals("")){
		response.sendRedirect("/security/sensitive/EditSensitiveWord.jsp?id="+id);
		return;
	}
	sc.updateSensitiveWord(id,word);
	response.sendRedirect("/security/sensitive/SensitiveWords.jsp");
  } else if(operation.equalsIgnoreCase("delete" )){
	if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String ids = Util.null2String(request.getParameter("id"));
	if(!ids.equals("")){
		String[] arrs = ids.split(",");
		int[] idArr = new int[arrs.length];
		int j = 0;
		for(int i=0;i<arrs.length;i++){
			int id = Util.getIntValue(arrs[i],-1);
			if(id>0){
				idArr[j] = id;
				j++;
			}
		}
		sc.deleteSensitiveWord(idArr);
	}
	response.sendRedirect("/security/sensitive/SensitiveTab.jsp");
  }else if(operation.equalsIgnoreCase("setting" )){
	if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	int id = Util.getIntValue(request.getParameter("id"));
	int status = Util.getIntValue(Util.null2String(request.getParameter("status")).trim(),0);
	String handleWay =  Util.null2String(Util.getIntValue(request.getParameter("handleWay"),0));
	String remindUsers = Util.null2String(request.getParameter("remindUsers"));
	sc.updateSetting(id,status,handleWay,remindUsers);
	response.sendRedirect("/security/sensitive/SensitiveSetting.jsp");
  } else{
	response.sendRedirect("/security/sensitive/SensitiveTab.jsp");
  }
 %>