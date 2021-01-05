
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="cpinfoTransMethod" class="weaver.cpcompanyinfo.CompanyInfoTransMethod" scope="page" />
<%@ page import="net.sf.json.*" %>
<%@page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="infoMeth" class="weaver.cpcompanyinfo.CompanyInfoTransMethod" scope="page" />
<%
	String searchcondition = "";
	//searchcondition = URLDecoder.decode(searchcondition,"utf-8");
	String companyid = Util.null2String(request.getParameter("companyid"));
	
	String method = Util.null2String(request.getParameter("method"));
	String isadd = Util.null2String(request.getParameter("isadd"));
	
	if(method.equals("search&save")){
		String now = Util.date(2);
		String searchname =  Util.null2String(request.getParameter("searchname"));
		String userId = String.valueOf(user.getUID()); //当前用户Id
		String moudel = Util.null2String(request.getParameter("moudel"));
		String field0 = Util.null2String(request.getParameter("field0"));
		String ship0 = Util.null2String(request.getParameter("ship0"));
		String field1 = Util.null2String(request.getParameter("field1"));
		String ship1 = Util.null2String(request.getParameter("ship1"));
		String field2 = Util.null2String(request.getParameter("field2"));
		String ship2 = Util.null2String(request.getParameter("ship2"));
		String field3 = Util.null2String(request.getParameter("field3"));
		String ship3 = Util.null2String(request.getParameter("ship3"));
		String field4 = Util.null2String(request.getParameter("field4"));
		String ship4 = Util.null2String(request.getParameter("ship4"));
		String field5 = Util.null2String(request.getParameter("field5"));
		String ship5 = Util.null2String(request.getParameter("ship5"));
		String field6 = Util.null2String(request.getParameter("field6"));
		String ship6 = Util.null2String(request.getParameter("ship6"));
		String field7 = Util.null2String(request.getParameter("field7"));
		String ship7 = Util.null2String(request.getParameter("ship7"));
		String field8 = Util.null2String(request.getParameter("field8"));
		String ship8 = Util.null2String(request.getParameter("ship8"));
		String field9 = Util.null2String(request.getParameter("field9"));
		searchname = URLDecoder.decode(searchname,"utf-8");
		field0 = URLDecoder.decode(field0,"utf-8");
		field1 = URLDecoder.decode(field1,"utf-8");
		field2 = URLDecoder.decode(field2,"utf-8");
		field3 = URLDecoder.decode(field3,"utf-8");
		field4 = URLDecoder.decode(field4,"utf-8");
		field5 = URLDecoder.decode(field5,"utf-8");
		field6 = URLDecoder.decode(field6,"utf-8");
		field7 = URLDecoder.decode(field7,"utf-8");
		field8 = URLDecoder.decode(field8,"utf-8");
		field9 = URLDecoder.decode(field9,"utf-8");
		ship0 = URLDecoder.decode(ship0,"utf-8");
		ship1 = URLDecoder.decode(ship1,"utf-8");
		ship2 = URLDecoder.decode(ship2,"utf-8");
		ship3 = URLDecoder.decode(ship3,"utf-8");
		ship4 = URLDecoder.decode(ship4,"utf-8");
		ship5 = URLDecoder.decode(ship5,"utf-8");
		ship6 = URLDecoder.decode(ship6,"utf-8");
		ship7 = URLDecoder.decode(ship7,"utf-8");
		ship8 = URLDecoder.decode(ship8,"utf-8");
		String searchid = Util.null2String(request.getParameter("searchid"));
		if(searchid.equals("")){
			String addsql = "insert into CPCOMPANYAFFIXSEARCH"
							+"(SEARCHFIELD0,SEARCHFIELD1,SEARCHFIELD2,SEARCHFIELD3,SEARCHFIELD4,"
							+"SEARCHFIELD5,SEARCHFIELD6,SEARCHFIELD7,SEARCHFIELD8,SEARCHFIELD9,"
							+"SEARCHSHIP0,SEARCHSHIP1,SEARCHSHIP2,SEARCHSHIP3,SEARCHSHIP4,"
							+"SEARCHSHIP5,SEARCHSHIP6,SEARCHSHIP7,SEARCHSHIP8,"
							+"WHICHMOUDEL,SEARCHCONDITION,SEARCHNAME,CREATEDATETIME,LASTUPDATETIME,ISDEL,userid,companyid)"
							+"values('"+field0+"','"+field1+"','"+field2+"','"+field3+"','"+field4+"','"
							+field5+"','"+field6+"','"+field7+"','"+field8+"','"+field9+"','"
							+ship0+"','"+ship1+"','"+ship2+"','"+ship3+"','"+ship4+"','"
							+ship5+"','"+ship6+"','"+ship7+"','"+ship8+"','"
							+moudel+"','"+searchcondition+"','"+searchname+"','"+now+"','"
							+now+"','T',"+userId+","+companyid+")";
			rs.execute(addsql);
			if(rs.execute(" select max(id)  from CPCOMPANYAFFIXSEARCH")&&rs.next()){
					out.clear();
					out.println(rs.getString("id"));
			}
		}else{
			
			String editsql = "update CPCOMPANYAFFIXSEARCH set SEARCHFIELD0='"+field0+"',"
						+"SEARCHFIELD1='"+field1+"',SEARCHFIELD2='"+field2+"',"
						+"SEARCHFIELD3='"+field3+"',SEARCHFIELD4='"+field4+"',"
						+"SEARCHFIELD5='"+field5+"',SEARCHFIELD6='"+field6+"',"
						+"SEARCHFIELD7='"+field7+"',SEARCHFIELD8='"+field8+"',"
						+"SEARCHFIELD9='"+field9+"',SEARCHSHIP0='"+ship0+"',"
						+"SEARCHSHIP1='"+ship1+"',SEARCHSHIP2='"+ship2+"',"
						+"SEARCHSHIP3='"+ship3+"',SEARCHSHIP4='"+ship4+"',"
						+"SEARCHSHIP5='"+ship5+"',SEARCHSHIP6='"+ship6+"',"
						+"SEARCHSHIP7='"+ship7+"',SEARCHSHIP8='"+ship8+"',"
						+"SEARCHNAME='"+searchname+"',LASTUPDATETIME='"+now+"'"
						+"where id='"+searchid+"'";
						
			//System.out.println("修改策略"+editsql);
			rs.execute(editsql);
		}
		
	}else  if(method.equals("del")){
		String affsearchids = Util.null2String(request.getParameter("affsearchids"));
		String _searchid =  affsearchids.substring(0,affsearchids.length()-1);
		String sqldel = "update CPCOMPANYAFFIXSEARCH set isdel='F' where id in("+_searchid+")";
		rs.execute(sqldel);
	}
	
	else  if(method.equals("refsh")){
	
	
			
						
				List list = cpinfoTransMethod.setStale(companyid);
				JSONArray jsa = new JSONArray();
				//SystemEnv.getHtmlLabelName(103,user.getLanguage())
				jsa.add(SystemEnv.getHtmlLabelName(30942,user.getLanguage())+list.get(2)+SystemEnv.getHtmlLabelName(30943,user.getLanguage()));
				if(!list.get(5).toString().split("/")[0].equals("0")){ 
						jsa.add(list.get(5).toString().split("/")[0]+""+SystemEnv.getHtmlLabelName(125,user.getLanguage())+"<br>"+list.get(5).toString().split("/")[1]+""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"");
				}else{
					jsa.add("");
				}
				if(!list.get(6).toString().split("/")[0].equals("0")){ 
						jsa.add(list.get(6).toString().split("/")[0] +""+SystemEnv.getHtmlLabelName(125,user.getLanguage())+"<br>"+list.get(6).toString().split("/")[1]+""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"");
				}else{
					jsa.add("");
				}
				if(!list.get(7).toString().split("/")[0].equals("0")){ 
						jsa.add(list.get(7).toString().split("/")[0]+""+SystemEnv.getHtmlLabelName(125,user.getLanguage())+"<br>"+list.get(7).toString().split("/")[1]+""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"");
				}else{
					jsa.add("");
				}
				
				String listr="";
				String upsql = "select * from CPCOMPANYUPGRADE where companyid="+companyid+" order by CREATEDATETIME desc"; 
				rs.execute(upsql);
				while (rs.next()){
					listr+="<li><span class=\"FR\">"+rs.getString("CREATEDATETIME")+"</span>"+rs.getString("discription")+"</li>";
				} 
				jsa.add(listr);
				List listsb=infoMeth.setStale(companyid);
				if(null!=listsb){
					jsa.add(listsb.get(0));//法人
					jsa.add(listsb.get(1));//懂事
					jsa.add(listsb.get(3));//股东
				}
					
			out.clear();
			out.println(jsa);
	} 
	
	
%>
