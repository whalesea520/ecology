<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="imgManger" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="deu" class="weaver.docs.docs.DocExtUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="dv" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="MessagerSettingCominfo" class="weaver.messager.MessagerSettingCominfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	//request.setCharacterEncoding("utf-8");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	FileUpload fu = new FileUpload(request,"utf-8");
	String accSaveDir=Util.null2String(MessagerSettingCominfo.getSettingValueByName("accSaveDir"));

	if(!"".equals(accSaveDir)){
		String sendTo = Util.null2String(fu.getParameter("sendTo"));
		
		
		
		
		int secId=Util.getIntValue(accSaveDir);
		int subId=Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secId));
		int mainId=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subId));
		
		int docid=deu.uploadDocToImg(fu,user, "Filedata",mainId,subId,secId,"","");
		
		if(sendTo.indexOf("@")!=-1) sendTo=sendTo.substring(0,sendTo.indexOf("@"));
		rs.execute("select id from hrmresource where loginid='"+sendTo+"'");
		rs.next();
		String shareuserid=Util.null2String(rs.getString("id"));
		String strSql="insert into docshare(docid,sharetype,sharelevel,userid,DOWNLOADLEVEL) values ("+docid+",1,1,"+shareuserid+",1)";
		rs.execute(strSql);
		dv.setDocShareByDoc("" + docid);
		//rs.execute(strSql);		
		out.println("{type:'docid',value:'"+docid+"'}");
	} else {		
		int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
	    Calendar today = Calendar.getInstance();
	    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	    String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	            Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	            Util.add0(today.get(Calendar.SECOND), 2) ;
		rs.executeSql("insert into imagefiletemp(imagefileid,docid,createid,createdate,createtime) values("+imagefileid+","+0+","+user.getUID()+",'"+currentdate+"','"+currenttime+"')");
		out.println("{type:'imagefileid',value:'"+imagefileid+"'}");
	}
%>