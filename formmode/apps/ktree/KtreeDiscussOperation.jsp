
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.util.Date"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
	request.setCharacterEncoding("UTF-8");
	FileUpload fu = new FileUpload(request);
	User user = HrmUserVarify.getUser(request , response) ;
	
	String discussid = StringHelper.null2String(fu.getParameter("discussid"));
	String versionid = Util.null2String(request.getParameter("versionid"));
	String functionid = Util.null2String(request.getParameter("functionid"));  	
	String tabid=Util.null2String(request.getParameter("tabid"));
	String content = StringHelper.null2String(fu.getParameter("content"));
	int replayid = NumberHelper.string2Int(fu.getParameter("replayid"),0);//被回复的留言id
	String relatefiles =Util.fromScreen(fu.getParameter("relatedacc"),user.getLanguage());  //相关附件
	String operation = Util.fromScreen(fu.getParameter("method"),user.getLanguage());
	String createdate = DateHelper.getCurrentDate();
	String createtime = DateHelper.getCurrentTime().substring(0,5);
	RecordSet rs = new RecordSet();
	int floornum = 0;
	//System.out.println("fds "+operation);
	if(operation.equals("addKtreeDiscuss")){ 
		rs.executeSql("select max(floorNum)+1 as floornum from uf_ktree_discussion where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid+" ");
		if(rs.next()){
			floornum = NumberHelper.string2Int(rs.getString("floornum"),1);
		}
		rs.executeSql("insert into uf_ktree_discussion(versionid,functionid,tabId,content,files,floornum,replayid,creator,createdate,createtime) values("+
		""+versionid+","+functionid+","+tabid+",'"+content+"','"+relatefiles+"',"+floornum+","+replayid+",'"+user.getUID()+"','"+createdate+"','"+createtime+"')");
	}
	if(operation.equals("delKtreeDiscuss")){ 
		if(!StringHelper.isEmpty(discussid)){
			rs.executeSql("delete uf_ktree_discussion where id="+discussid);
			rs.executeSql("select COUNT(*) from uf_ktree_discussion where versionid="+versionid+" and functionid="+functionid+" and tabid="+tabid);
       		int discussionCount = 0;
       		if(rs.next()){
       			discussionCount =  rs.getInt(1);
       		}
       		out.print(discussionCount);
		}
	}
	if(operation.equals("saveKtreeDiscuss")){
		if(!StringHelper.isEmpty(discussid)){
			rs.executeSql("update uf_ktree_discussion set content='"+content+"' where id="+discussid);
		}
	}
	if(operation.equals("editKtreeDiscuss")){ 
		rs.executeSql("select * from uf_ktree_discussion where id="+discussid);
		String remark2html = "";
		if(rs.next()){
			String remark2 = Util.null2String(rs.getString("content"));
			remark2html = Util.StringReplace(remark2,"\r\n","");
		}
%>
	<div id="editdiv">
	   <table>
	        <tr>
		        <td>
			        <div class="discussContent">
			         	<input type=hidden name="discussid" id="discussid" value="<%=discussid%>">
			         	<input type="hidden" name="tabid" value="<%=tabid%>">
					 	<textarea id="discussContent" name="discussContent"><%=remark2html%></textarea>
					 	<div class="discussOperation" align="left">
						     <div style="clear: both;margin: 0px 0px 2px 0px;">
						       <button type="button" class="btnSubmit" onclick="doSave('discussContent','saveKtreeDiscuss')"><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
							   <button type="button" onclick="cancelEdit('<%=discussid%>');return false;" class="btnCancel"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
				             </div>
			         	</div>
		         	</div>   
	      		</td>
	        </tr>
	    </table>           
	</div>
<%}%>
