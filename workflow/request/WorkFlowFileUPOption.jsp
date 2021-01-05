
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.general.Util"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import = "weaver.docs.docs.DocExtUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String acceptlanguage = request.getHeader("Accept-Language");
FileUpload fu = new FileUpload(request);
String fieldname=Util.null2String(fu.getParameter("fieldname"));
String fieldid=Util.null2String(fu.getParameter("fieldid"));
String imgwidth=Util.null2String(fu.getParameter("imgwidth"));
String imgheight=Util.null2String(fu.getParameter("imgheight"));
String imgnumprerow=Util.null2String(fu.getParameter("imgnumprerow"));
String fieldvalue=Util.null2String(fu.getParameter(fieldid));
String tempvalue=fieldvalue;
String tempname="";
String fieldtype="1";
ArrayList tempfieldname=Util.TokenizerString(fieldname,"_");
if(tempfieldname.size()==3){
    fieldtype=(String)tempfieldname.get(1);
}
//fieldname=field49943_0_2_6
int isdetail = 0;
if(tempfieldname.size()==4){
    fieldtype=(String)tempfieldname.get(2);
    isdetail = 1;
}

%>
<script language=javascript src="/js/characterConv_wev8.js"></script>
<script language=javascript >
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
function imgshoworhideopener(nowrow,nowcol){
    var showtype=opener.document.all("ChinaExcel").GetCellUserValue(nowrow,nowcol);
    var cellvalue=opener.document.all("ChinaExcel").GetCellValue(nowrow,nowcol);
    cellvalue = Simplized(cellvalue);
    if(showtype==2){
		var isProtect=opener.document.all("ChinaExcel").IsCellProtect(nowrow,nowcol);
		if(isProtect){
			opener.document.all("ChinaExcel").SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
		}
        if(cellvalue!=null && cellvalue!=""){
            opener.document.all("ChinaExcel").DeleteCellImage(nowrow,nowcol,nowrow,nowcol); 
        }else{
           opener.document.all("ChinaExcel").ReadHttpImageFile("/images/BacoBrowser_b_wev8.gif",nowrow,nowcol,true,true);
        }
		if(isProtect){
			opener.document.all("ChinaExcel").SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
		}
    }else if(showtype==1){
        var isProtect=opener.document.all("ChinaExcel").IsCellProtect(nowrow,nowcol);
		if(isProtect){
			opener.document.all("ChinaExcel").SetCellProtect(nowrow,nowcol,nowrow,nowcol,false);
		}
        if(cellvalue!=null && cellvalue!=""){
            opener.document.all("ChinaExcel").DeleteCellImage(nowrow,nowcol,nowrow,nowcol);
        }else{
           opener.document.all("ChinaExcel").ReadHttpImageFile("/images/BacoBrowser_wev8.gif",nowrow,nowcol,true,true);
        }
		if(isProtect){
			opener.document.all("ChinaExcel").SetCellProtect(nowrow,nowcol,nowrow,nowcol,true);
		}
    }
}
</script>
<script language="javascript">
function adddetail(fieldname){
    var oTable=opener.document.getElementById("hidden_tab");
    oRow = oTable.insertRow(-1);
	oRow.id="tr"+fieldname;
    oCell = oRow.insertCell(-1); 
    var oDiv = opener.document.createElement("div");
    var sHtml = "<input type='hidden' id='"+fieldname+"' name='"+fieldname+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
}
try{
var wcell=opener.document.all("ChinaExcel");
var nrow=wcell.GetCellUserStringValueRow("<%=fieldname%>");
var ncol=wcell.GetCellUserStringValueCol("<%=fieldname%>");
<%
int indx=0;
if(!tempvalue.equals("")){

    RecordSet.executeSql("select t1.docId as id,t1.imageFileName as docsubject from DocImageFile t1,(select docid,max(versionid) versionid from DocImageFile group by docid) t2 where t1.docid=t2.docid and t1.versionid=t2.versionid  and t1.docId in ("+tempvalue+")");
    while(RecordSet.next()){
        String docid=RecordSet.getString("id");
       if(tempname.equals("")){
           tempname=RecordSet.getString("docsubject");
       }else{
           tempname+="&at;"+RecordSet.getString("docsubject");
       }
    indx++;    
    }
}
%>


<%
if(isdetail==1){
%>
opener.document.getElementById("<%=fieldid%>").value=  "<%=tempvalue%>";
opener.frmmain.ChinaExcel.SetCellVal(opener.getFirstRowNo("<%=fieldname%>"),opener.frmmain.ChinaExcel.GetCellUserStringValueCol("<%=fieldname%>"),"<%=tempname%>" );
imgshoworhideopener(opener.getFirstRowNo("<%=fieldname%>"),opener.frmmain.ChinaExcel.GetCellUserStringValueCol("<%=fieldname%>"));
<%
}else{
%>

opener.document.all("<%=fieldid%>").value="<%=tempvalue%>";
wcell.SetCellVal(nrow,ncol,getChangeField("<%=tempname%>"));
imgshoworhideopener(nrow,ncol);
wcell.RefreshViewSize();
<%
}
%>


}catch(e){}
window.close();
</script>