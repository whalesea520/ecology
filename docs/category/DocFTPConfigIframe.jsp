
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

String operation=Util.null2String(request.getParameter("operation"));

String returnString="";

if(operation.equals("Delete")){
    int FTPConfigId=Util.getIntValue(request.getParameter("FTPConfigId"),0);
    try {
		    //文档主目录
			String mainCategoryString="";
			int mainCategoryId=0;
            RecordSet.executeSql("select mainCategoryId from DocMainCatFTPConfig where FTPConfigId=" + FTPConfigId);
			while(RecordSet.next()){
				mainCategoryId=Util.getIntValue(RecordSet.getString("mainCategoryId"));
				mainCategoryString+="<br>"+"/"+MainCategoryComInfo.getMainCategoryname(""+mainCategoryId);
			}

			//文档分目录
			String subCategoryString="";
			int subCategoryId=0;
            RecordSet.executeSql("select subCategoryId from DocsubCatFTPConfig where FTPConfigId=" + FTPConfigId);
			while(RecordSet.next()){
				subCategoryId=Util.getIntValue(RecordSet.getString("subCategoryId"));
				mainCategoryId=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subCategoryId));
				subCategoryString+="<br>"+"/"+MainCategoryComInfo.getMainCategoryname(""+mainCategoryId)+"/"+SubCategoryComInfo.getSubCategoryname(""+subCategoryId);
			}

			//文档子目录
			String secCategoryString="";
			int secCategoryId=0;
            RecordSet.executeSql("select secCategoryId from DocSecCatFTPConfig where FTPConfigId=" + FTPConfigId);
			while(RecordSet.next()){
				secCategoryId=Util.getIntValue(RecordSet.getString("secCategoryId"));
				subCategoryId=Util.getIntValue(SecCategoryComInfo.getSubCategoryid(""+secCategoryId));
				mainCategoryId=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+subCategoryId));
				secCategoryString+="<br>"+"/"+MainCategoryComInfo.getMainCategoryname(""+mainCategoryId)+"/"+SubCategoryComInfo.getSubCategoryname(""+subCategoryId)+"/"+SecCategoryComInfo.getSecCategoryname(""+secCategoryId);
			}

			//附件
			String imageFileString="";
            RecordSet.executeSql("select imageFileId,imageFileName from ImageFile where FTPConfigId=" + FTPConfigId);
			while(RecordSet.next()){
				imageFileString+="<br>"+Util.null2String(RecordSet.getString("imageFileName"))+"（"+Util.null2String(RecordSet.getString("imageFileId"))+"）";
			}

			if(!mainCategoryString.equals("")){
				returnString+="<br><br>"+SystemEnv.getHtmlLabelName(22578,user.getLanguage())+"："+mainCategoryString;
			}

			if(!subCategoryString.equals("")){
				returnString+="<br><br>"+SystemEnv.getHtmlLabelName(22579,user.getLanguage())+"："+subCategoryString;
			}

			if(!secCategoryString.equals("")){
				returnString+="<br><br>"+SystemEnv.getHtmlLabelName(22580,user.getLanguage())+"："+secCategoryString;
			}

			if(!imageFileString.equals("")){
				returnString+="<br><br>"+SystemEnv.getHtmlLabelName(22581,user.getLanguage())+"："+imageFileString;
			}
		

			if(!returnString.equals("")&&returnString.length()>8){
				returnString=returnString.substring(8);
			}


        } catch (Exception e) {
        }
%>
    <script language="javascript">
        window.parent.checkForDelete("<%=returnString%>");
    </script>
<%		
}else if(operation.equals("loadDocFTPConfigInfo")){
    int FTPConfigId=Util.getIntValue(request.getParameter("FTPConfigId"),0);

    String FTPConfigName = Util.null2String(DocFTPConfigComInfo.getFTPConfigName(""+FTPConfigId));
    String FTPConfigDesc = Util.null2String(DocFTPConfigComInfo.getFTPConfigDesc(""+FTPConfigId));
    String serverIP = Util.null2String(DocFTPConfigComInfo.getServerIP(""+FTPConfigId));
    String serverPort = Util.null2String(DocFTPConfigComInfo.getServerPort(""+FTPConfigId));
    String userName = Util.null2String(DocFTPConfigComInfo.getUserName(""+FTPConfigId));
    String userPassword = Util.null2String(DocFTPConfigComInfo.getUserPassword(""+FTPConfigId));
    String defaultRootDir = Util.null2String(DocFTPConfigComInfo.getDefaultRootDir(""+FTPConfigId));
    String maxConnCount = Util.null2String(DocFTPConfigComInfo.getMaxConnCount(""+FTPConfigId));
	String showOrder = Util.null2String(DocFTPConfigComInfo.getShowOrder(""+FTPConfigId));

    if(!userPassword.equals("")){
		userPassword="●●●●●●";
	}
    defaultRootDir=Util.StringReplace(defaultRootDir,"\\","\\\\");
%>
    <script language="javascript">
        window.parent.returnDocFTPConfigInfo("<%=FTPConfigName%>","<%=FTPConfigDesc%>","<%=serverIP%>","<%=serverPort%>","<%=userName%>","<%=userPassword%>","<%=defaultRootDir%>","<%=maxConnCount%>","<%=showOrder%>");
    </script>
<%
}
%>
