
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	FileUpload fu = new FileUpload(request,"utf-8");
	int mainId=Util.getIntValue(fu.getParameter("mainId"),0);
	int subId=Util.getIntValue(fu.getParameter("subId"),0);
	int secId=Util.getIntValue(fu.getParameter("secId"),0);
	String fieldname=Util.null2String(fu.getParameter("fieldname"));
	//fieldname= new String(fieldname.getBytes("GBK"), "utf-8"); 
	String sellchanceid=Util.getIntValue(fu.getParameter("sellchanceid"),0)+"";
	String setid=Util.null2String(fu.getParameter("setid"));
	
	StringBuffer restr = new StringBuffer();
	if(secId!=0){	
		int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
		if(!"0".equals(sellchanceid)){
			String addfilename = "";
			DocImageManager.resetParameter();
	        DocImageManager.setDocid(docid);
	        DocImageManager.selectDocImageInfo();
	        if(DocImageManager.next()) addfilename = DocImageManager.getImagefilename();
			
			String fieldvalue = docid+"";
			String oldfileids = "";
			
			if(setid.equals("")){
				rs.executeSql("select "+fieldname+" from CRM_SellChance where id="+sellchanceid);
			}else{
				rs.executeSql("select remark from CRM_SellChance_Other where type=4 and setid="+setid+" and sellchanceid="+sellchanceid);
			}
			
			if(rs.next()){
				oldfileids = Util.null2String(rs.getString(1));
			}
			fieldvalue = cmutil.cutString(fieldvalue,",",3);
			if(!"".equals(fieldvalue)) {
				String currentdate = TimeUtil.getCurrentDateString();
				String currenttime = TimeUtil.getOnlyCurrentTimeString();
				if("".equals(oldfileids)) oldfileids = ",";
				oldfileids = oldfileids + fieldvalue + ",";
				if(setid.equals("")){
					rs.executeSql("update CRM_SellChance set "+fieldname+"='"+oldfileids+"' where id="+sellchanceid);
				}else{
					rs.executeSql("update CRM_SellChance_Other set remark='"+oldfileids+"' where type=4 and setid="+setid+" and sellchanceid="+sellchanceid);
				}	
				rs.executeSql("insert into CRM_SellChanceLog (sellchanceid,type,operator,operatedate,operatetime,operatefield,oldvalue,newvalue)"
						+" values("+sellchanceid+",9,"+user.getUID()+",'"+currentdate+"','"+currenttime+"','"+fieldname+"','','"+addfilename+"')");
				rs.executeSql("update CRM_SellChance set updateuserid="+user.getUID()+",updatedate='"+TimeUtil.getCurrentDateString()+"',updatetime='"+TimeUtil.getOnlyCurrentTimeString()+"' where id="+sellchanceid);
			}
			List fileidList = Util.TokenizerString(oldfileids,",");
			for(int i=0;i<fileidList.size();i++){
				DocImageManager.resetParameter();
	            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
	            DocImageManager.selectDocImageInfo();
	            DocImageManager.next();
	            String docImagefileid = DocImageManager.getImagefileid();
	            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
	            String docImagefilename = DocImageManager.getImagefilename();
				restr.append("<div class='txtlink txtlink"+fileidList.get(i)+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>");
				restr.append("<div style='float: left;'>");
				restr.append("<a href=javaScript:openFullWindowHaveBar('/CRM/sellchance/manage/util/ViewDoc.jsp?id=" + fileidList.get(i)+"&sellchanceid="+sellchanceid+"')>"+docImagefilename+"</a>");
				restr.append("&nbsp;<a href='/CRM/sellchance/manage/util/ViewDoc.jsp?id="+fileidList.get(i)+"&sellchanceid="+sellchanceid+"&fileid="+docImagefileid+"'>涓嬭浇("+docImagefileSize/1000+"K)</a>");
				restr.append("</div>");
				restr.append("<div class='btn_del' onclick=doDelItem('"+fieldname+"','"+fileidList.get(i)+"','"+setid+"')></div>");
				restr.append("<div class='btn_wh'></div>");
				restr.append("</div>");
			}
		}else{
			restr.append(docid);
		}
		
		out.println(restr.toString());
	} 
%>





