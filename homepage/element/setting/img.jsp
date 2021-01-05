
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<body align="center">
<%
	String para=Util.null2String(request.getParameter("para"));
	
	String eid="";
	String background="";
	int pos=para.indexOf("_");
	if(pos==-1){
		eid=para;
	} else {
		eid=para.substring(0,pos);
		background=para.substring(pos+1);
	}	
	//out.println(eid);
	//out.println(":");
	//out.println(background); 
%>
<br>
<FORM id=frmImg name=frmImg action="imgupload.jsp" method=post enctype="multipart/form-data">	
	<TABLE width="100%">
	<TR>
		<TD><input type="file" class="inputStyle" name="Filedata" style="width:100%" onchange="onImgChange(this)"></TD>
	</TR>


	<TR>
		<TD height="350" style="border:1px solid #C5C5C5"><div style="width:480;height:380;overflow:auto;" id="divPreview"><%if(!"".equals(background)){%><img src="/weaver/weaver.file.FileDownload?fileid=<%=background%>" border=0><%}%></div></TD>
	</TR>

	<TR>
		<TD>
			<button type="button" class="btnSave" onclick="frmImg.submit();"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
			&nbsp;
			<button type="button" class="btnDelete" onclick="window.parent.close();"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>	
			&nbsp;
			<button type="button"  class="btnReset" onclick="btnclear_onclick();"><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></button>

		</TD>
	</TR>
	</TABLE>
	
	
</FORM>
</body>
<SCRIPT LANGUAGE="javascript">
function onImgChange(obj){
	if(obj!="")	document.getElementById("divPreview").innerHTML="<img src='"+obj.value+"' border=0>";
}
	
</SCRIPT>



<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
</SCRIPT>