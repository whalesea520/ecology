<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocTreelistComInfo" class="weaver.docs.category.DocTreelistComInfo" scope="page"/>
<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%  
    if((!HrmUserVarify.checkUserRight("DocMainCategoryEdit:Edit", user))&&(!HrmUserVarify.checkUserRight("DocMainCategoryEdit:Delete", user))&&(!HrmUserVarify.checkUserRight("DocMainCategoryAdd:add", user))){
	    response.sendRedirect("/notice/noright.jsp");
	    return ;
	}
    MainCategoryManager.setClientAddress(request.getRemoteAddr());
    MainCategoryManager.setUserid(user.getUID());
    String message = MainCategoryManager.foruploadfile(request);
    String isEntryDetail = MainCategoryManager.getIsEntryDetail();
    if(!message.equals("")&&!message.equals("-1")&&!message.equals("-2")) {
        int spit = message.indexOf('_');
        int id = Util.getIntValue(message.substring(0,spit),0);
        int messageid = Util.getIntValue(message.substring(spit+1,message.length()),0);
        response.sendRedirect("DocMainCategoryEdit.jsp?id="+id+"&message="+messageid);
    }else if(message.equals("-1")){
    	String operation = MainCategoryManager.getAction();
    	int id = MainCategoryManager.getId();
    	if(MainCategoryManager.getIsDialog().equals("1")){
    		if(operation.equals("add")){
            	response.sendRedirect("DocMainCategoryAdd.jsp?isdialog=1&errorcode=10");
            }else if(operation.equals("edit")){
           		response.sendRedirect("DocMainCategoryBaseInfoEdit.jsp?isdialog=1&errorcode=10&id="+id);
           	}
            return;
         }else if(MainCategoryManager.getIsDialog().equals("2")){
    		if(operation.equals("add")){
            	response.sendRedirect("DocSubCategoryAdd.jsp?isdialog=2&errorcode=10");
            }else if(operation.equals("edit")){
           		response.sendRedirect("DocSubCategoryBaseInfoEdit.jsp?isdialog=2&errorcode=10&id="+id);
           	}
            return;
         }
        response.sendRedirect("DocMainCategoryAdd.jsp?errorcode=10");
        return;
    }else if(message.equals("-2")){
        response.sendRedirect("DocMainCategoryBaseInfoEdit.jsp?errorcode=10&id="+MainCategoryManager.getId());
        return;
    }else {
    	int id = MainCategoryManager.getId();
    	String operation = MainCategoryManager.getAction();
    	if(id>0&&!"delete".equals(operation)){
            MainCategoryComInfo.removeMainCategoryCache();
			DocTreelistComInfo.removeGetDocListInfoCache();
            if(isEntryDetail.equals("1")){//主目录
            	if(operation.equals("add")){
            		response.sendRedirect("DocMainCategoryAdd.jsp?isclose=1&id="+id);
            	}else if(operation.equals("edit")){
            		response.sendRedirect("DocMainCategoryBaseInfoEdit.jsp?isclose=1&id="+id);
            	}
            }else if(isEntryDetail.indexOf("_")>-1){//从主目录详细中新建主目录，需返回原页面
            	response.sendRedirect("DocMainCategoryAdd.jsp?isclose=1&id="+isEntryDetail.substring(1));
            }else if(MainCategoryManager.getIsDialog().equals("1")){//主目录
            	if(operation.equals("add")){
            		response.sendRedirect("DocMainCategoryAdd.jsp?isclose=1");
            	}else if(operation.equals("edit")){
            		response.sendRedirect("DocMainCategoryBaseInfoEdit.jsp?isclose=1");
            	}
            }else{
            	response.sendRedirect("DocMainCategoryBaseInfoEdit.jsp?refresh=1&id="+id);
            }
            
    	} else {
            MainCategoryComInfo.removeMainCategoryCache();
			DocTreelistComInfo.removeGetDocListInfoCache();
            //response.sendRedirect("DocMainCategoryList.jsp");
            if(!"".equals(MainCategoryManager.getIsDialog())){
            	out.println("1");
            }else{
           		out.println(Util.sendRedirect("DocCategoryTab.jsp","0","undefined",MainCategoryManager.getIsDialog(),"parent"));
           }
    	}
    }
%>
<input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">