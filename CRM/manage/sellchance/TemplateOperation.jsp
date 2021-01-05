
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID();
	rs.executeSql(sql);
	if(!rs.next()) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String rownumber = "";
	String docsetid = "";
	int rownum = 0;
	String docIds = "";
	for(int i=1;i<8;i++){
		//rs.executeSql("delete from CRM_SellChance_Set where infotype in ("+i+","+i+""+i+")");
		
		rownumber = Util.fromScreen3(request.getParameter("rownum"+i),user.getLanguage());
		rownum = 0;
	    if(rownumber != null && !"".equals(rownumber)){
	    	rownum = Integer.parseInt(rownumber);
	    }
	    List ids = new ArrayList();
	    rs.executeSql("select id from CRM_SellChance_Set where infotype="+i);
	    while(rs.next()){
	    	ids.add(rs.getString(1));
	    }
	    for(int j=0;j<rownum;j++){
	    	String id = Util.fromScreen3(request.getParameter("id"+i+"_"+j),user.getLanguage());
	        String item = Util.fromScreen3(request.getParameter("item"+i+"_"+j),user.getLanguage());
	        String doc = "";
	        if(!"".equals(item)){
	        	if(i==6) doc = Util.fromScreen3(request.getParameter("itemdoc_"+j),user.getLanguage());
	        	if("".equals(id)){//新增记录
					rs.executeSql("insert into CRM_SellChance_Set (infotype,item,doc) values("+i+",'"+item+"','"+doc+"')");
		        }else{//编辑记录
		        	ids.remove(id);
		        	rs.executeSql("update CRM_SellChance_Set set item='"+item+"',doc='"+doc+"' where id="+id);
		        }
	        }
	  	}
	    //删除剩余记录
	    String delids = "";
	    for(int k=0;k<ids.size();k++){
	    	delids += "," + (String)ids.get(k);
	    }
	    if(!delids.equals("")){
	    	delids = delids.substring(1);
	    	rs.executeSql("delete from CRM_SellChance_Set where id in ("+delids+")");
	    }
	    if(i<7){
	    	docsetid = Util.fromScreen3(request.getParameter("docsetid"+i),user.getLanguage());
		    docIds = Util.null2String(request.getParameter("docIds"+i));
		    if(!docsetid.equals("")){
		    	rs.executeSql("update CRM_SellChance_Set set item='"+docIds+"' where id="+docsetid);
		    }else{
		    	rs.executeSql("insert into CRM_SellChance_Set (infotype,item) values("+i+""+i+",'"+docIds+"')");
		    }
	    }
	}
	
	rs.executeSql("delete from CRM_SellChance_Set where infotype in (111,222,333,444)");
	String pathcategory = Util.null2String(request.getParameter("pathcategory"));
	String maincategory = Util.null2String(request.getParameter("maincategory"));
	String subcategory = Util.null2String(request.getParameter("subcategory"));
	String seccategory = Util.null2String(request.getParameter("seccategory"));
	if(!pathcategory.equals("")){
    	rs.executeSql("insert into CRM_SellChance_Set (infotype,item) values(111,'"+maincategory+"')");
    	rs.executeSql("insert into CRM_SellChance_Set (infotype,item) values(222,'"+subcategory+"')");
    	rs.executeSql("insert into CRM_SellChance_Set (infotype,item) values(333,'"+seccategory+"')");
    	rs.executeSql("insert into CRM_SellChance_Set (infotype,item) values(444,'"+pathcategory+"')");
    }
	response.sendRedirect("TemplateInfo.jsp");
%>