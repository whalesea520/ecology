
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.email.po.MailAccountComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />

<%
String sql = "";
int mailAccountId = Util.getIntValue(request.getParameter("id"));
String mailAccountIds = Util.null2String(request.getParameter("ids"));
String showTop = Util.null2String(request.getParameter("showTop"));
String operation = Util.null2String(request.getParameter("operation"));
String accountName = Util.null2String(request.getParameter("accountName"));
String accountMailAddress = Util.null2String(request.getParameter("accountMailAddress"));
String accountId = Util.null2String(request.getParameter("accountId"));
String accountPassword = Util.null2String(request.getParameter("accountPassword"));
int serverType = Util.getIntValue(request.getParameter("serverType"));
String popServer = Util.null2String(request.getParameter("popServer"));
int popServerPort = Util.getIntValue(request.getParameter("popServerPort"));
String smtpServer = Util.null2String(request.getParameter("smtpServer"));
int smtpServerPort = Util.getIntValue(request.getParameter("smtpServerPort"));
String needCheck = Util.null2String(request.getParameter("needCheck"));
String needSave = Util.null2String(request.getParameter("needSave"));
String getneedSSL = Util.null2String(request.getParameter("getneedSSL"));
String sendneedSSL = Util.null2String(request.getParameter("sendneedSSL"));
String isStartTls = Util.null2o(request.getParameter("isStartTls"));

int defaultMailAccountId = Util.getIntValue(request.getParameter("isDefault"));
defaultMailAccountId = Util.getIntValue(request.getParameter("isclear"))==1?0:defaultMailAccountId;

int autoreceive = Util.getIntValue(request.getParameter("autoreceive"),0);
accountPassword = EmailEncoder.EncoderPassword(accountPassword);
int receiveScope = Util.getIntValue(request.getParameter("receiveScope"));//1为最近一个月，2为最近三个月，3为最近半年，4为最近一年，5为全部

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
Calendar calendar = Calendar.getInstance();
calendar.setTime(new Date());
String receiveDateScope = "";
if(1 == receiveScope){
	calendar.add(Calendar.MONTH,-1 );
}
if(2 == receiveScope){
	calendar.add(Calendar.MONTH,-3 );
}
if(3 == receiveScope){
	calendar.add(Calendar.MONTH,-6 );
}
if(4 == receiveScope){
	calendar.add(Calendar.MONTH,-12 );
}
if(5 != receiveScope){
	receiveDateScope = dateFormat.format(calendar.getTime());
}

MailAccountComInfo mailAccountComInfo = new MailAccountComInfo();

if(operation.equals("add")){
	sql = "INSERT INTO MailAccount (userId, accountName, accountMailAddress, accountId, accountPassword, serverType, popServer, popServerPort, smtpServer, smtpServerPort, isStartTls, needCheck, needSave,autoreceive,encryption,sendneedSSL,getneedSSL  , receiveScope , receiveDateScope,sendStatus,receiveStatus) VALUES ("+user.getUID()+", '"+accountName+"', '"+accountMailAddress+"', '"+accountId+"', '"+accountPassword+"', "+serverType+", '"+popServer+"', "+popServerPort+", '"+smtpServer+"', "+smtpServerPort+", '"+isStartTls+"','"+needCheck+"', '"+needSave+"','"+autoreceive+"',1,'"+sendneedSSL+"','"+getneedSSL+"','"+receiveScope+"','"+receiveDateScope+"',1,1)";
	rs.executeSql(sql);
	//out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
    
     // 更新缓存
    rs.executeQuery("select max(id) as maxid from MailAccount where userid=" + user.getUID() + " and accountId='" + accountId + "'");
    if(rs.next()) {
        mailAccountComInfo.addCache(rs.getString(1));
    }
    
	return;
}else if(operation.equals("update")){
	sql = "UPDATE MailAccount SET accountName='"+accountName+"', accountMailAddress='"+accountMailAddress+"', accountId='"+accountId+"', accountPassword='"+accountPassword+"', serverType="+serverType+", popServer='"+popServer+"', popServerPort="+popServerPort+", smtpServer='"+smtpServer+"', smtpServerPort="+smtpServerPort+", isStartTls='"+isStartTls+"', needCheck='"+needCheck+"', needSave='"+needSave+"',autoreceive='"+autoreceive+"',encryption=1,sendneedSSL = '"+sendneedSSL+"',getneedSSL = '"+getneedSSL+"',receiveScope='"+receiveScope+"' ,receiveDateScope='"+receiveDateScope+"' ,sendStatus = 1 ,receiveStatus = 1 WHERE id="+mailAccountId+"";
	rs.executeSql(sql);
	//out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
    
    // 更新缓存
    mailAccountComInfo.updateCache(String.valueOf(mailAccountId));
	return;
}else if(operation.equals("default")){
	sql = "UPDATE MailAccount SET isDefault='0' WHERE userId="+user.getUID()+"";
	rs.executeSql(sql);
	sql = "UPDATE MailAccount SET isDefault='1' WHERE id="+defaultMailAccountId+"";
    
	// 更新缓存
	rs.executeQuery("select id from MailAccount where userid=" + user.getUID());
    while(rs.next()) {
        mailAccountComInfo.updateCache(rs.getString("id"));
    }
	
}else if(operation.equals("delete")){
	sql = "SELECT id FROM MailRule WHERE mailAccountId in ("+mailAccountIds+")";
	rs.executeSql(sql);
	if(rs.next()){
		out.println("ruleuse");
	}else{
		String mailids="";
		sql="select id from mailresource where mailAccountId in ("+mailAccountIds+") and (isInternal != 1 or isInternal is null)" ; 
		rs.execute(sql);
		while(rs.next()){
			mailids+=","+rs.getString("id");
		}
		mailids=mailids.length() > 0 ? mailids.substring(1) : mailids;
		
		//删除账户同时删除邮件
		String emlPath=application.getRealPath("")+"email\\eml\\";
		mrs.deleteMail(mailids, user.getUID(), emlPath);
		
		sql = "DELETE FROM MailAccount WHERE id in ("+mailAccountIds+")";
        
        // 清除缓存
        for(String id : mailAccountIds.split(",")) {
            mailAccountComInfo.deleteCache(id);
        }
        
		rs.executeSql(sql);
	}
	return;
}
rs.executeSql(sql);

if(showTop.equals("")) {
	response.sendRedirect("MailAccount.jsp");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailAccount.jsp?showTop=show800");
}

%>
