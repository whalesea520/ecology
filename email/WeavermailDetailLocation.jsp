<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeavermailSend" class="weaver.email.WeavermailSend" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
int msgid = Util.getIntValue(request.getParameter("msgid")) ;
if(msgid == -1) {
    response.sendRedirect("WeavermailLocation.jsp");
    return ;
}

int userId = user.getUID();
int resourceId = 0;

int mailtype = Util.getIntValue(request.getParameter("mailtype")) ;
String priority="",sendfrom="",sendcc="",sendto="",sendbcc="",senddate="",subject="",content="",hasHtmlImage="";
ConnStatement statement=new ConnStatement();
try{
	if("oracle".equals(statement.getDBType())){
		statement.setStatementSql("select t1.*,t2.mailcontent from MailResource t1,MailContent t2 where t1.id=t2.mailid and t1.id = " + msgid) ;
	}else{
		statement.setStatementSql("select * from MailResource where id = " + msgid) ;
	}
	statement.executeQuery();
	statement.next() ;
	resourceId = statement.getInt("resourceId");
	//TD5531===========================================
	if(userId!=resourceId){
		response.sendRedirect("/notice/noright.jsp");
	   return;
	}
	//=================================================
	priority = statement.getString("priority") ;
	sendfrom = statement.getString("sendfrom") ;
	sendcc = statement.getString("sendcc") ;
	sendbcc = statement.getString("sendbcc") ;
	sendto = statement.getString("sendto") ;
	senddate = statement.getString("senddate") ;
	subject = statement.getString("subject") ;
	if("oracle".equals(statement.getDBType())){
		CLOB theclob = statement.getClob("mailcontent");
		String readline = "";
		StringBuffer clobStrBuff = new StringBuffer("");
		BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
		while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
		clobin.close() ;
		content = clobStrBuff.toString();
	}else{
		content = statement.getString("content") ;
	}
	//begin add by zhouquan TD-1433
	hasHtmlImage = statement.getString("hasHtmlImage") ;
	//end
}catch(Exception e) {
	e.printStackTrace();
}finally {
	statement.close();
}
String lastname = Util.null2String(ResourceComInfo.getLastnameByEmail(sendfrom));
if(!lastname.equals("")) sendfrom = lastname + "  "+"&lt;"+sendfrom+"&gt;";
lastname = Util.null2String(ResourceComInfo.getLastnameByEmail(sendcc));
if(!sendcc.equals("") && !lastname.equals("")) sendcc = lastname + "  "+"&lt;"+sendcc+"&gt;";
sendto = Util.null2String(ResourceComInfo.getLastnameByEmail(sendto));
if(!sendto.equals("") && !lastname.equals("")) sendcc = lastname + "  "+"&lt;"+sendto+"&gt;";
sendbcc = Util.null2String(ResourceComInfo.getLastnameByEmail(sendbcc));
if(!sendbcc.equals("") && !lastname.equals("")) sendbcc = lastname + "  "+"&lt;"+sendbcc+"&gt;";

/*
String sql = "select lastname from HrmResource where email='"+sendfrom+"'";
rs.executeSql(sql);
if(rs.next()){
	String pers = rs.getString("lastname");
	sendfrom = pers + "  "+"&lt;"+sendfrom+"&gt;";
}

if(!sendcc.equals("")){
	sql = "select lastname from HrmResource where email='"+sendcc+"'";
	rs.executeSql(sql);
	if(rs.next()){
		String pers = rs.getString("lastname");
		sendcc = pers + "  "+"&lt;"+sendcc+"&gt;";
	}
}

if(!sendto.equals("")){
	sql = "select lastname from HrmResource where email='"+sendto+"'";
	rs.executeSql(sql);
	if(rs.next()){
		String pers = rs.getString("lastname");
		sendto = pers + "  "+"&lt;"+sendto+"&gt;";
	}
}

if(!sendbcc.equals("")){
	sql = "select lastname from HrmResource where email='"+sendbcc+"'";
	rs.executeSql(sql);
	if(rs.next()){
		String pers = rs.getString("lastname");
		sendbcc = pers + "  "+"&lt;"+sendbcc+"&gt;";
	}
}
*/

ArrayList  filenames = new ArrayList() ;
ArrayList  filenums  = new ArrayList() ;
ArrayList  filenameencodes  = new ArrayList() ;
int totlefile = 0 ;

WeavermailComInfo wmc = new WeavermailComInfo() ;
wmc.setPriority(priority) ;
wmc.setRealeSendfrom(sendfrom) ;
wmc.setRealeCC(sendcc) ;
wmc.setRealeTO(sendto) ;
wmc.setRealeBCC(sendbcc) ;
wmc.setSendDate(senddate) ;
wmc.setSubject(subject) ;
//begin modify by zhouquan TD-1433
wmc.setContent(content);
//end

//begin add by zhouquan TD-1433
if(("1").equals(hasHtmlImage)){
    wmc.setHtmlimage(true);
}
else{
    wmc.setHtmlimage(false);
}

String contentencode = wmc.getContentencode() ; 
//end 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",WeavermailAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(mailtype == 0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2054,user.getLanguage())+",WeavermailAdd.jsp?operation=reply&location=1,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2053,user.getLanguage())+",WeavermailAdd.jsp?operation=replyall&location=1,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(mailtype == 0 || mailtype == 1 ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2052,user.getLanguage())+",WeavermailAdd.jsp?operation=forward&location=1&msgid="+msgid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(mailtype == 2) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+",WeavermailAdd.jsp?operation=send&location=1&msgid="+msgid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if (mailtype == 3) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2050,user.getLanguage())+",javascript:doMoveL(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2048,user.getLanguage())+",javascript:doMoveS(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2049,user.getLanguage())+",javascript:doMoveC(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(mailtype == 0 || mailtype == 1 || mailtype==2 ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2030,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doDeleteforever(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",WeavermailLocation.jsp?mailtype="+mailtype+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver ACTION="WeavermailOperation.jsp" METHOD="POST">
  <input type="hidden" name="fromLogin" value="1">
  <input type = hidden name=operation value=movemaill>
  <input type = hidden name=themail value=<%=msgid%>>
  <input type = hidden name=mailtype value=<%=mailtype%>>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		  <table class=ViewForm>
			<tbody> 
			<tr class=Spacing> 
			  <td class=Line1 colspan=4></td>
			</tr>
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage())%></td>
			  <td class=Field><%=WeavermailSend.getNameAndEmailStrs(Util.toScreen(sendfrom,user.getLanguage()))%>
			  </td>
			  <td>CC</td>
			  <td class=Field><%=WeavermailSend.getNameAndEmailStrs(Util.toScreen(sendcc,user.getLanguage()))%>
			  </td>
			</tr>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(2046,user.getLanguage())%></td>
			  <td class=Field>
                  <%out.println(WeavermailSend.getNameAndEmailStrs(sendto));%>
              </td>
			  <td><%=SystemEnv.getHtmlLabelName(2047,user.getLanguage())%></td>
			  <td class=Field><%=senddate%> </td>
			</tr>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
			  <td class=Field colspan="3"><%=Util.toScreen(subject,user.getLanguage())%></td>
			</tr>
			<tr class=Spacing> 
			  <td class=Line1 colspan=4></td>
			</tr>
			<tr> 
			  <td colspan="4"><br>
			  <%String mailcontent = "" ; 
                
				if(wmc.getContenttype().equals("0")) { 
					mailcontent = Util.toHtml(Util.toScreen(content,user.getLanguage(),contentencode)) ;
                }
				else { 
					mailcontent = Util.toScreen(content,user.getLanguage(),contentencode) ;
				}
	
                if(wmc.hasHtmlimage()) {
                    RecordSet.executeSql("select id ,isfileattrachment,fileContentId from MailResourceFile where mailid = " + msgid +" and isfileattrachment = 0");
				  
				    int thefilenum = 0;
					while(RecordSet.next()) { 
						String isfileattrachment =  RecordSet.getString("isfileattrachment") ;
						//out.println(isfileattrachment);
						thefilenum++;
						
						String fileId = RecordSet.getString("id");
                        String thecontentid = RecordSet.getString("fileContentId");

						
					
						String oldsrc = "cid:" + thecontentid ;
						String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+fileId;
		                
						mailcontent = Util.StringReplaceOnce(mailcontent , oldsrc , newsrc ) ;
					}
				}

                %>
                <%=mailcontent%>
			  <br><br></td>
			</tr>
			<tr class=Spacing> 
			  <td class=Line1 colspan=4></td>
			</tr>
			<% 
			RecordSet.executeSql("select * from MailResourceFile where mailid = " + msgid+" and isfileattrachment = 1");

			while(RecordSet.next()) { 
				String fileId = RecordSet.getString("id");
				filenames.add(RecordSet.getString("filename")) ;
				filenums.add(fileId) ;
				filenameencodes.add("1") ;
				totlefile ++ ; 
				String attachUrl = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+fileId;
			%>
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
			  <td class=Field colspan="3"><a href="<%=attachUrl%>"><%=Util.toScreen(RecordSet.getString("filename"),user.getLanguage())%></a>   &nbsp;&nbsp;<BUTTON class=btn accessKey="<%=totlefile%>"  onclick="location.href='<%=attachUrl%>&download=1'"><U><%=totlefile%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></BUTTON></td>
			</tr>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<%}
			wmc.setTotlefile(totlefile) ;
			wmc.setFilenames(filenames) ;
			wmc.setFilenums(filenums) ;
			wmc.setFilenameencodes(filenameencodes) ;  
			session.setAttribute("WeavermailComInfo" , wmc) ;
			%>
			</tbody> 
		  </table>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
 </form>
</BODY>
<script>
function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='deletelocation';
	document.weaver.submit();
	}
}

function doDeleteforever(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='deleteforeverlocation';
	document.weaver.submit();
	}
}

function doMoveL(){
    document.weaver.mailtype.value='0';
	document.weaver.submit();
}

function doMoveS(){
	document.weaver.mailtype.value='1';
	document.weaver.submit();
}

function doMoveC(){
	document.weaver.mailtype.value='2';
	document.weaver.submit();
}

</script>

</html>