
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.*,
                 weaver.general.*,
                 java.util.*,
                 com.goldgrid.*,
                 weaver.sms.SMSSaveAndSend,weaver.sms.ReceiveSmsManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String smsserver = "";
	rs.executeSql("select smsserver from systemset");
	if(rs.next()) {
		smsserver = rs.getString("smsserver");
		smsserver=smsserver.replace("http:\\\\", "").replace("http://", "").replace("http:\\", "").replace("http:/", "");
		smsserver=smsserver.split(":")[0];
	}
	if(!Util.null2String(request.getRemoteAddr()).equals(Util.null2String(smsserver))) {
		out.write("ERROR1");
		return;
	}
    String strOption = request.getParameter("OPTION");
    String strRecord = request.getParameter("RECORD");
    String strMobile = request.getParameter("MOBILE");
    String message = request.getParameter("CONTENT");
    String strDateTime = request.getParameter("DATETIME");
    
    String mSql = "";
    boolean mResult = false;

    try {
        if (strOption.equalsIgnoreCase("GET")) {
        	strMobile=strMobile.replace("\"","");
        	strDateTime=strDateTime.replace("/","-");
        	ReceiveSmsManager receiveSmsManager = new ReceiveSmsManager();
        	receiveSmsManager.setSmsContent(message);
        	receiveSmsManager.setRescPhone(strMobile);
        	String recvTime = "";//时间格式20090214211314
        	strDateTime = SMSSaveAndSend.formatDateTime(strDateTime);
        	recvTime += SMSSaveAndSend.getYear(strDateTime)+SMSSaveAndSend.getMonth(strDateTime)+SMSSaveAndSend.getDay(strDateTime);
        	strDateTime = strDateTime.substring(recvTime.length()+2, strDateTime.length()).trim();
        	int tmpInt = -1;
        	tmpInt = strDateTime.indexOf(":");
        	if(tmpInt == -1){
        		recvTime += "000000";
        	}else{
        		recvTime += strDateTime.substring(0, tmpInt);
        		strDateTime = strDateTime.substring(tmpInt+1);
        	}
        	tmpInt = strDateTime.indexOf(":");
        	if(tmpInt == -1){
        		recvTime += "0000";
        	}else{
        		recvTime += strDateTime.substring(0, tmpInt);
        		strDateTime = strDateTime.substring(tmpInt+1);
        	}
        	if(!"".equals(strDateTime)){
        		recvTime += strDateTime+"0";
        		recvTime = recvTime.substring(0, 14);
        	}else{
        		recvTime += "00";
        	}
        	receiveSmsManager.setRecvTime(recvTime);
        	int flag = receiveSmsManager.doReceiveSms();
        	if(flag == 0){
        		mResult = true;
        	}
        } else {
        	if(strDateTime!=null&&!"".equals(strDateTime)&&!"null".equals(strDateTime)){
	            mSql = "Update SMS_Message Set " +
	                    "messagestatus='1'," +
	                    "finishtime='" + SMSSaveAndSend.formatDateTime(strDateTime) + "'," +
	                    "smsyear='"+SMSSaveAndSend.getYear(SMSSaveAndSend.formatDateTime(strDateTime))+"'," +
	                    "smsmonth='"+SMSSaveAndSend.getMonth(SMSSaveAndSend.formatDateTime(strDateTime))+"'," +
	                    "smsday='"+SMSSaveAndSend.getDay(SMSSaveAndSend.formatDateTime(strDateTime))+"'" +
	                    " where id=" + strRecord;
	            //System.out.println("UPDATE mSql:" + mSql);
	            rs.executeSql(mSql);
        	}
        }
        mResult = true;
    } catch (Exception e) {
        //System.out.println(e.toString());
    }
    out.clear();
    if (mResult) {
        out.write("OK");
    } else {
        out.write("ERROR2");
    }
%>
