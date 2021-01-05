<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ExcelParse" class="weaver.file.ExcelParse" scope="page" />
<jsp:useBean id="FileManage" class="weaver.file.FileManage" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<FORM id=frmMain name=frmMain action="InputReportDataConfirm.jsp">

<%
FileUploadToPath fu = new FileUploadToPath(request) ;
Hashtable ht = new Hashtable() ;

Enumeration eu = fu.getParameterNames() ;
while(eu.hasMoreElements() ) {
    String keyname = (String)eu.nextElement() ;
    if(keyname.equals("") || keyname.equals("excelfile")) continue ;
    String keyvalue = Util.null2String(fu.getParameter(keyname)) ;
    ht.put(keyname , keyvalue) ;
%>
  <input type=hidden name="<%=keyname%>" value="<%=keyvalue%>" >
<%}


String filename = fu.uploadFiles("excelfile") ;


if(!filename.equals("")) {
    ExcelParse.init( filename ) ;

    String inprepid = Util.null2String(fu.getParameter("inprepid"));

    RecordSet.executeProc("T_IRItem_SelectByInprepid",inprepid);

    while (RecordSet.next()) {
        String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
        if(itemfieldtype.equals("5") ) continue ;

        String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
        String itemexcelsheet = Util.null2String(RecordSet.getString("itemexcelsheet")) ;
        String itemexcelrow = Util.null2String(RecordSet.getString("itemexcelrow")) ;
        String itemexcelcolumn = Util.null2String(RecordSet.getString("itemexcelcolumn")) ;

        String itemvalue = Util.toScreen(ExcelParse.getValue(itemexcelsheet,itemexcelrow,itemexcelcolumn),user.getLanguage(),"0") ;

    %>
      <input type=hidden name="<%=itemfieldname%>" value="<%=itemvalue%>">
    <%}


    FileManage.DeleteFile( filename ) ;
}
%>

</form>

<script language=javascript>
    document.frmMain.submit() ;
</script>

