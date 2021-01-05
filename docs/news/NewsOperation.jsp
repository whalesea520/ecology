<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
  String operation = Util.null2String(request.getParameter("operation"));
	
  String isDialog = Util.null2String(request.getParameter("isdialog"));
  
  String to = Util.null2String(request.getParameter("to"));

  if(operation.equalsIgnoreCase("add")){
  	if(!HrmUserVarify.checkUserRight("DocFrontpageAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  	String frontpagename= Util.fromScreen(request.getParameter("frontpagename"),user.getLanguage());
  	String frontpagedesc= Util.fromScreen(request.getParameter("frontpagedesc"),user.getLanguage());
  	String isactive=Util.fromScreen(request.getParameter("isactive"),user.getLanguage());
  	int departmentid =Util.getIntValue(request.getParameter("departmentid"),0);
  	String hasdocsubject= Util.fromScreen(request.getParameter("hasdocsubject"),user.getLanguage());
  	String hasfrontpagelist= Util.fromScreen(request.getParameter("hasfrontpagelist"),user.getLanguage());
  	int newsperpage = Util.getIntValue(request.getParameter("newsperpage"),0);
  	int titlesperpage = Util.getIntValue(request.getParameter("titlesperpage"),0);
  	int defnewspicid = Util.getIntValue(request.getParameter("defnewspicid"),0);
  	int backgroundpicid = Util.getIntValue(request.getParameter("backgroundpicid"),0);
  	String importdocid = request.getParameter("importdocid");
	if(importdocid==null) importdocid="";
  	int headerdocid = Util.getIntValue(request.getParameter("headerdocid"),0);
  	int footerdocid = Util.getIntValue(request.getParameter("footerdocid"),0);
  	int publishtype=Util.getIntValue(request.getParameter("publishtype"),1);
  	int languageid=Util.getIntValue(request.getParameter("languageid"),0);
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);

  	String continueoperation=Util.fromBaseEncoding(Util.null2String(request.getParameter("continueoperation")),user.getLanguage());
  	String continuevalue=Util.fromScreen(request.getParameter("continuevalue"),user.getLanguage());
  	int continuedepart=Util.getIntValue(request.getParameter("continuedepart"),0);
  	String continuetime=Util.fromScreen(request.getParameter("continuetime"),user.getLanguage());
  	int continuelanguagenameid=Util.getIntValue(request.getParameter("continuelanguagenameid"),0);
  	String condition=Util.fromBaseEncoding(Util.null2String(request.getParameter("condition")),user.getLanguage());
    int newstypeid=Util.getIntValue(request.getParameter("newstypeid"));
    int typeordernum=Util.getIntValue(request.getParameter("typeordernum"),0);
    int ishead = 0;
  	String newsclause = " ";
  	if(!continueoperation.equals("") && !continuevalue.equals("")){
  		ishead = 1;
  		newsclause += " docseclevel ";
  		newsclause += continueoperation;
  		newsclause += continuevalue;
  	}
  	if(continuedepart!=0){
  		if(ishead == 0) {
  			ishead=1;
  			newsclause += " docdepartmentid=";
  			newsclause += continuedepart;
  		}
  		else{
  			newsclause += " and docdepartmentid=";
  			newsclause += continuedepart;
  		}
  	}
  	if(continuelanguagenameid!=0){
  		if(ishead == 0) {
  			ishead=1;
  			newsclause += " doclangurage=";
  			newsclause += continuelanguagenameid;
  		}
  		else{
  			newsclause += " and doclangurage=";
  			newsclause += continuelanguagenameid;
  		}
  	}
  	if(!condition.equals("")){
  		if(ishead == 0) {
  			ishead=1;
  			newsclause += " ( " + condition + " ) " ;
  		}
  		else{
  			newsclause += " and ";
  			newsclause += " ( " + condition + " ) " ;
  		}
  	}
  	int datebefore = Util.getIntValue(continuetime,0)*(-1);
  	if(datebefore!=0){
  	Calendar ca = Calendar.getInstance();
  	ca.add(Calendar.DAY_OF_MONTH,datebefore);
  	String tmpdate = Util.add0(ca.get(Calendar.YEAR), 4) +"-"+ Util.add0(ca.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(ca.get(Calendar.DAY_OF_MONTH), 2);
                         if(ishead==0){
                         	ishead = 1;
                         	newsclause += " doccreatedate >='";
                         	newsclause += tmpdate;
                         	newsclause += "'";
                         }
                         else{
  				newsclause += " and doccreatedate >='";
                         	newsclause += tmpdate;
                         	newsclause += "'";
                         }
       }

  	DocNewsManager.resetParameter();
  	DocNewsManager.setClientip(request.getRemoteAddr());
	DocNewsManager.setUserid(user.getUID());

	DocNewsManager.setFrontpagename(frontpagename);
	DocNewsManager.setFrontpagedesc(frontpagedesc);
	DocNewsManager.setIsactive(isactive);
	DocNewsManager.setDepartmentid(departmentid);
	DocNewsManager.setHasdocsubject(hasdocsubject);
	DocNewsManager.setHasfrontpagelist(hasfrontpagelist);
	DocNewsManager.setNewsperpage(newsperpage);
	DocNewsManager.setTitlesperpage(titlesperpage);
	DocNewsManager.setDefnewspicid(defnewspicid);
	DocNewsManager.setBackgroundpicid(backgroundpicid);
	DocNewsManager.setImportdocid(importdocid);
	DocNewsManager.setHeaderdocid(headerdocid);
	DocNewsManager.setFooterdocid(footerdocid);
	DocNewsManager.setSecopt(continueoperation);
	DocNewsManager.setSeclevelopt(Util.getIntValue(continuevalue,0));
	DocNewsManager.setDepartmentopt(continuedepart);
	DocNewsManager.setDateopt(Util.getIntValue(continuetime,0));
	DocNewsManager.setLanguageopt(continuelanguagenameid);
	DocNewsManager.setClauseopt(condition);
	DocNewsManager.setNewsclause(newsclause);
	DocNewsManager.setPublishtype(publishtype);
	DocNewsManager.setLanguageid(languageid);
    DocNewsManager.setNewstypeid(newstypeid);
    DocNewsManager.setTypeordernum(typeordernum);
    DocNewsManager.setAction(operation);
    DocNewsManager.setSubcompanyid(subcompanyid);
	DocNewsManager.AddDocNewsInfo();
	DocNewsComInfo.removeDocNewsCache();
	 if(isDialog.equals("1")){
      	response.sendRedirect("DocNewsAdd.jsp?isclose=1&to="+to+"&id="+DocNewsManager.getId());
      }else{
		response.sendRedirect("DocNews.jsp");
		}
  }
  else if(operation.equalsIgnoreCase("edit")){
  	if(!HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  	int id = Util.getIntValue(request.getParameter("id"));

  	String frontpagename= Util.fromScreen(request.getParameter("frontpagename"),user.getLanguage());
  	String frontpagedesc= Util.fromScreen(request.getParameter("frontpagedesc"),user.getLanguage());
  	String isactive=Util.fromScreen(request.getParameter("isactive"),user.getLanguage());
  	int departmentid =Util.getIntValue(request.getParameter("departmentid"),0);
  	int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
  	String hasdocsubject= Util.fromScreen(request.getParameter("hasdocsubject"),user.getLanguage());
  	String hasfrontpagelist= Util.fromScreen(request.getParameter("hasfrontpagelist"),user.getLanguage());
  	int newsperpage = Util.getIntValue(request.getParameter("newsperpage"),20);
  	int titlesperpage = Util.getIntValue(request.getParameter("titlesperpage"),20);
  	int defnewspicid = Util.getIntValue(request.getParameter("defnewspicid"),0);
  	int backgroundpicid = Util.getIntValue(request.getParameter("backgroundpicid"),0);

    String importdocid = request.getParameter("importdocid");

  	int headerdocid = Util.getIntValue(request.getParameter("headerdocid"),0);
  	int footerdocid = Util.getIntValue(request.getParameter("footerdocid"),0);
  	int publishtype=Util.getIntValue(request.getParameter("publishtype"),1);
  	int languageid=Util.getIntValue(request.getParameter("languageid"),0);
  	String continueoperation=Util.fromBaseEncoding(Util.null2String(request.getParameter("continueoperation")),user.getLanguage());
  	String continuevalue=Util.fromScreen(request.getParameter("continuevalue"),user.getLanguage());
  	int continuedepart=Util.getIntValue(request.getParameter("continuedepart"),0);
  	String continuetime=Util.fromScreen(request.getParameter("continuetime"),user.getLanguage());
  	int continuelanguagenameid=Util.getIntValue(request.getParameter("continuelanguagenameid"),0);
  	String condition=Util.fromBaseEncoding(Util.null2String(request.getParameter("condition")),user.getLanguage());
    int newstypeid=Util.getIntValue(request.getParameter("newstypeid"));
    int typeordernum=Util.getIntValue(request.getParameter("typeordernum"),0);
    int ishead = 0;
  	String newsclause = " ";
  	if(!continueoperation.equals("") && !continuevalue.equals("")){
  		ishead = 1;
  		newsclause += " docseclevel ";
  		newsclause += continueoperation;
  		newsclause += continuevalue;
  	}
  	if(continuedepart!=0){
  		if(ishead == 0) {
  			ishead=1;
  			newsclause += " docdepartmentid=";
  			newsclause += continuedepart;
  		}
  		else{
  			newsclause += " and docdepartmentid=";
  			newsclause += continuedepart;
  		}
  	}
  	if(continuelanguagenameid!=0){
  		if(ishead == 0) {
  			ishead=1;
  			newsclause += " doclangurage=";
  			newsclause += continuelanguagenameid;
  		}
  		else{
  			newsclause += " and doclangurage=";
  			newsclause += continuelanguagenameid;
  		}
  	}
  	if(!condition.equals("")){
  		if(ishead == 0) {
  			ishead=1;
  			newsclause += condition  ;
  		}
  		else{
  			newsclause += " and ";
  			newsclause +=  condition ;
  		}
  	}
  	int datebefore = Util.getIntValue(continuetime,0)*(-1);
  	if(datebefore!=0){
  	Calendar ca = Calendar.getInstance();
  	ca.add(Calendar.DAY_OF_MONTH,datebefore);
  	String tmpdate = Util.add0(ca.get(Calendar.YEAR), 4) +"-"+ Util.add0(ca.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(ca.get(Calendar.DAY_OF_MONTH), 2);
                         if(ishead==0){
                         	ishead = 1;
                         	newsclause += " doccreatedate >='";
                         	newsclause += tmpdate;
                         	newsclause += "'";
                         }
                         else{
  				newsclause += " and doccreatedate >='";
                         	newsclause += tmpdate;
                         	newsclause += "'";
                         }
       }

  	DocNewsManager.resetParameter();
  	DocNewsManager.setClientip(request.getRemoteAddr());
	DocNewsManager.setUserid(user.getUID());

	DocNewsManager.setId(id);
	DocNewsManager.setFrontpagename(frontpagename);
	DocNewsManager.setFrontpagedesc(frontpagedesc);
	DocNewsManager.setIsactive(isactive);
	DocNewsManager.setDepartmentid(departmentid);
	DocNewsManager.setHasdocsubject(hasdocsubject);
	DocNewsManager.setHasfrontpagelist(hasfrontpagelist);
	DocNewsManager.setNewsperpage(newsperpage);
	DocNewsManager.setTitlesperpage(titlesperpage);
	DocNewsManager.setDefnewspicid(defnewspicid);
	DocNewsManager.setBackgroundpicid(backgroundpicid);
	DocNewsManager.setImportdocid(importdocid); 
	DocNewsManager.setHeaderdocid(headerdocid);
	DocNewsManager.setFooterdocid(footerdocid);
	DocNewsManager.setSecopt(continueoperation);
	DocNewsManager.setSeclevelopt(Util.getIntValue(continuevalue,0));
	DocNewsManager.setDepartmentopt(continuedepart);
	DocNewsManager.setDateopt(Util.getIntValue(continuetime,0));
	DocNewsManager.setLanguageopt(continuelanguagenameid);
	DocNewsManager.setClauseopt(condition);
	DocNewsManager.setNewsclause(newsclause);
	DocNewsManager.setPublishtype(publishtype);
	DocNewsManager.setLanguageid(languageid);
    DocNewsManager.setNewstypeid(newstypeid);
    DocNewsManager.setTypeordernum(typeordernum);
    DocNewsManager.setCheckOutStatus(0);
    DocNewsManager.setCheckOutUserId(-1);
	DocNewsManager.setSubcompanyid(subcompanyid);
    DocNewsManager.setAction(operation);
	DocNewsManager.EditDocNewsInfo();
	DocNewsComInfo.removeDocNewsCache();
	if(isDialog.equals("1")){
      	response.sendRedirect("DocNewsEdit.jsp?isdialog=1&id="+DocNewsManager.getId());
      }else{
		response.sendRedirect("DocNews.jsp");
		}
  }
  else if(operation.equalsIgnoreCase("delete")){
  	if(!HrmUserVarify.checkUserRight("DocFrontpageEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  	int id = Util.getIntValue(request.getParameter("id"));
  	String frontpagename= Util.fromScreen(request.getParameter("frontpagename"),user.getLanguage());
	if(frontpagename.equals("")){
		rs.executeSql("select * from DocFrontpage where id="+id);
		if(rs.next()){
			frontpagename= Util.fromScreen(rs.getString("frontpagename"),user.getLanguage());
		}
	}
  	DocNewsManager.resetParameter();
  	DocNewsManager.setClientip(request.getRemoteAddr());
	DocNewsManager.setUserid(user.getUID());

	DocNewsManager.setId(id);
	DocNewsManager.setFrontpagename(frontpagename);

	DocNewsManager.setAction(operation);
	DocNewsManager.DeleteDocNewsInfo();
	DocNewsComInfo.removeDocNewsCache();
	if(isDialog.equals("2")){//ajax请求
		response.getWriter().println("1");
	}else{
		response.sendRedirect("DocNews.jsp");
	}
  }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">