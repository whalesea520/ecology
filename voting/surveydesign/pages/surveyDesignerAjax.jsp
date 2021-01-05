<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires",0);
%>
<%@page import="weaver.general.Util" %>
<%@page import="org.json.JSONObject" %>
<%@page import="weaver.voting.SurveyDesigner" %>
<%@page import="weaver.voting.bean.*" %>
<%@page import="weaver.voting.SurveyOperator" %>

<%
	String opType = Util.null2String(request.getParameter("opType"));
	String questiontype = Util.null2String(request.getParameter("questiontype"));
	JSONObject obj = new JSONObject();
	
	SurveyOperator surveyOperator = new SurveyOperator();
	
	obj.put("flag","0");
	
	if("save".equals(opType)){  //新增、修改
	   if(questiontype.isEmpty()){ //保存（调查）标题
	       String title = request.getParameter("title");
	   	   String votingId = Util.null2String(request.getParameter("votingId"));
	   	   if(!votingId.isEmpty()){
	       	   surveyOperator.saveTitle(votingId,title.replaceAll("'","''"));
	       	   obj.put("flag","1");
	   	   }
	   }else{
		   String qid = Util.null2String(request.getParameter("qid"));
		   SurveyDesigner surveyDesigner = new SurveyDesigner(request);
		   Question question = surveyDesigner.getQuestion();
		   if(qid.isEmpty()){ //新增
		       question = surveyOperator.insertQuestion(question);
		   }else{//修改
		       question = surveyOperator.saveQuestion(question);
		   }
		    obj.put("returnData",surveyOperator.question2Map(question));
	   		obj.put("flag","1");
	   }
	
	}else if("deleteQuestion".equals(opType)){//删除问题
	    String qid = Util.null2String(request.getParameter("qid"));
		if(!qid.isEmpty()){
		    surveyOperator.deleteQuestion(qid);
	    	obj.put("flag","1");
		}
	    
	}else if("addPage".equals(opType)){ //新增一页
	    String votingId = Util.null2String(request.getParameter("votingId"));
	    String pagenum = Util.null2String(request.getParameter("pagenum"));
		if(!votingId.isEmpty() && !pagenum.isEmpty()){
		    surveyOperator.addPage(votingId,pagenum);
		    obj.put("flag","1");
		}
	}else if("deletePage".equals(opType)){//删除页
	    String votingId = Util.null2String(request.getParameter("votingId"));
	    String pagenum = Util.null2String(request.getParameter("pagenum"));
		if(!votingId.isEmpty() && !pagenum.isEmpty()){
		    surveyOperator.deletePage(votingId,pagenum);
	    	obj.put("flag","1");
		}
	}else if("order".equals(opType)){//排序
	    String objType = Util.null2String(request.getParameter("objType"));
	    String fromId = Util.null2String(request.getParameter("fromId"));
	    String toId = Util.null2String(request.getParameter("toId"));
	    String votingId = Util.null2String(request.getParameter("votingId"));
		if("question".equals(objType)){
		    if(!fromId.isEmpty() && !toId.isEmpty()){  //本页内移动
		        surveyOperator.orderQuestion(fromId,toId);
		        obj.put("flag","1");
		    }else{
		        String fromPage = Util.null2String(request.getParameter("fromPage"));
		        String toPage = Util.null2String(request.getParameter("toPage"));
		        if(!fromPage.isEmpty() && !toPage.isEmpty()){ //跨页移动
		            String qid = Util.null2String(request.getParameter("qid"));
		            surveyOperator.orderQuestionOffPage(qid,fromPage,toPage,votingId);
		            obj.put("flag","1");
		        }
		    }
		}else if("page".equals(objType) && !fromId.isEmpty() && !toId.isEmpty()){
		    surveyOperator.orderPage(votingId,fromId,toId);
		    obj.put("flag","1");
		}
	    
	}else if("dragPage".equals(opType)){ //拖拽页
	    String fromPage = Util.null2String(request.getParameter("fromPage"));
	    String toPage = Util.null2String(request.getParameter("toPage"));
	    String votingId = Util.null2String(request.getParameter("votingId"));
	    if(!fromPage.isEmpty() && !toPage.isEmpty() && !votingId.isEmpty()){
	    	surveyOperator.dragPage(votingId,fromPage,toPage);
	    	obj.put("flag","1");
	    }
	    
	}else if("dragQuestion".equals(opType)){//拖拽问题
	    String fromPage = Util.null2String(request.getParameter("fromPage"));
	    String toPage = Util.null2String(request.getParameter("toPage"));
	    String fromOrder = Util.null2String(request.getParameter("fromOrder"));
	    String toOrder = Util.null2String(request.getParameter("toOrder"));
	    String qid = Util.null2String(request.getParameter("qid"));
	    String votingId = Util.null2String(request.getParameter("votingId"));
	    if(!fromPage.isEmpty() && !toPage.isEmpty() && !votingId.isEmpty() && !fromOrder.isEmpty() && !toOrder.isEmpty() && !qid.isEmpty()){
	    	surveyOperator.dragQuestion(qid,votingId,fromPage,toPage,fromOrder,toOrder);
	    	obj.put("flag","1");
	    }
	    
	}else if("paste".equals(opType)){//粘贴
	    String qid = Util.null2String(request.getParameter("qid"));
	    String showorder = Util.null2String(request.getParameter("showorder"));
	    String pagenum = Util.null2String(request.getParameter("pagenum"));
	   // Question question = surveyOperator.paste(qid,pagenum,showorder);
    	//obj.put("returnData",surveyOperator.question2Map(question));
   		obj.put("flag","1");
	}

	out.println(obj.toString());
	
%>