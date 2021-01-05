
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.common.xtable.TableSql" %>
<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	String importdate=TimeUtil.getCurrentDateString();
	String importtime=TimeUtil.getOnlyCurrentTimeString();

%>
<%@ include file="/docs/common.jsp" %>
<%
	String txtDummy=Util.null2String(request.getParameter("txtDummy"));
	String txtSql=Util.null2String(request.getParameter("txtSql"));
	
	if(txtSql!=null&&!"".equals(txtSql)){
		TableSql xTableSql = (TableSql)session.getAttribute(txtSql+"_sql");
		if(xTableSql!=null&&xTableSql.getSqlwhere()!=null)
		txtSql = xTableSql.getSqlwhere();
	}
	String txtDocs=Util.null2String(request.getParameter("txtDocs"));
	String txtStatus=Util.null2String(request.getParameter("txtStatus"));
	String method=Util.null2String(request.getParameter("method"));
	String strSql="";
	//out.println("txtDummy:"+txtDummy+"\n");
	//out.println("txtSql:"+txtSql+"\n");
	//out.println("txtDocs:"+txtDocs+"\n");
	//out.println("txtStatus:"+txtStatus+"\n");
	if("remove".equals(method)){
		if ("".equals(txtDocs)||"".equals(txtDummy)) return;			
		ArrayList docList=Util.TokenizerString(txtDocs,",");		
		for(int j=0;j<docList.size();j++){
			String docid=(String)docList.get(j);
			strSql="delete  DocDummyDetail where catelogid="+txtDummy+" and docid="+docid;
			rs.executeSql(strSql);
		}
	} else if ("copy".equals(method)){	//即为添加的功能
		String tdummy=Util.null2String(request.getParameter("tdummy"));  //target dummyids
		//out.println(txtDocs+"<br>");
		//out.println(txtDummy+"<br>");
		//out.println(tdummy+"<br>");

		if ("".equals(txtDocs)||"".equals(txtDummy)||"".equals(tdummy)) return;	

		ArrayList docList=Util.TokenizerString(txtDocs,",");
		//删除相关的文档				
		//for(int j=0;j<docList.size();j++){
		//	String docid=(String)docList.get(j);
		//	strSql="delete  DocDummyDetail where catelogid="+txtDummy+" and docid="+docid;
			//out.println(strSql+"<br>");
		//	rs.executeSql(strSql);
		//}

		//插入到相关的文档
		ArrayList dummyList=Util.TokenizerString(tdummy,",");
		for(int i=0;i<dummyList.size();i++){	
			for(int j=0;j<docList.size();j++){
				String dummyId=(String)dummyList.get(i);
				String docid=(String)docList.get(j);
				if(!DocTreeDocFieldComInfo.isHaveSameOne(dummyId,docid)) {
					strSql="insert into DocDummyDetail(catelogid,docid,importdate,importtime) values ("+dummyId+","+docid+",'"+importdate+"','"+importtime+"')";
					//out.println(strSql+"<br>");
					rs.executeSql(strSql);
				}
			}
		}
	} else if ("move".equals(method)){	//即为移动的功能
		String tdummy=Util.null2String(request.getParameter("tdummy"));  //target dummyids
		//out.println(txtDocs+"<br>");
		//out.println(txtDummy+"<br>");
		//out.println(tdummy+"<br>");

		if ("".equals(txtDocs)||"".equals(txtDummy)||"".equals(tdummy)) return;	

		ArrayList docList=Util.TokenizerString(txtDocs,",");
		//删除相关的文档				
		//for(int j=0;j<docList.size();j++){
		//	String docid=(String)docList.get(j);
		//	strSql="delete  DocDummyDetail where catelogid="+txtDummy+" and docid="+docid;
			//out.println(strSql+"<br>");
		//	rs.executeSql(strSql);
		//}

		//插入到相关的文档
		ArrayList dummyList=Util.TokenizerString(tdummy,",");
			
		for(int j=0;j<docList.size();j++){			
			String docid=(String)docList.get(j);
			for(int i=0;i<dummyList.size();i++){
				String dummyId=(String)dummyList.get(i);
				if(!DocTreeDocFieldComInfo.isHaveSameOne(dummyId,docid)) {
					strSql="insert into DocDummyDetail(catelogid,docid,importdate,importtime) values ("+dummyId+","+docid+",'"+importdate+"','"+importtime+"')";
					//out.println(strSql+"<br>");
					rs.executeSql(strSql);
				}
			}
			
			strSql="delete DocDummyDetail where catelogid="+txtDummy+" and docid="+docid;
			rs.executeSql(strSql);		
		}
	}else if ("add".equals(method)){
		if("2".equals(txtStatus)){  //所有文档
			if ("".equals(txtSql)||"".equals(txtDummy)) return;
			
			ArrayList dummyList=Util.TokenizerString(txtDummy,",");
			for(int i=0;i<dummyList.size();i++){	
				strSql="select t1.id from DocDetail  t1,"+tables+" t2 "+txtSql;
				
				rs.executeSql(strSql);
				while(rs.next()){
					String dummyId=(String)dummyList.get(i);
					String docid=Util.null2String(rs.getString("id"));
					if(!DocTreeDocFieldComInfo.isHaveSameOne(dummyId,docid)) {
						strSql="insert into DocDummyDetail(catelogid,docid,importdate,importtime) values ("+dummyId+","+docid+",'"+importdate+"','"+importtime+"')";
						//out.println(strSql);
						rs.executeSql(strSql);
					}
				}			
			}		
		} else { //选中文档
			if ("".equals(txtDocs)||"".equals(txtDummy)) return;
			
			ArrayList dummyList=Util.TokenizerString(txtDummy,",");
			ArrayList docList=Util.TokenizerString(txtDocs,",");

			for(int i=0;i<dummyList.size();i++){	
				for(int j=0;j<docList.size();j++){
					String dummyId=(String)dummyList.get(i);
					String docid=(String)docList.get(j);
					if(!DocTreeDocFieldComInfo.isHaveSameOne(dummyId,docid)) {
						strSql="insert into DocDummyDetail(catelogid,docid,importdate,importtime) values ("+dummyId+","+docid+",'"+importdate+"','"+importtime+"')";
						//out.println(strSql);
						rs.executeSql(strSql);
					}
				}
			}
		}		
	}
	out.println("success");
%>

	