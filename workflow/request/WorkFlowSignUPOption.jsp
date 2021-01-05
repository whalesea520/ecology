
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.general.Util"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import = "weaver.docs.docs.DocExtUtil"%>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<%
String acceptlanguage = request.getHeader("Accept-Language");
FileUpload fu = new FileUpload(request);
String fieldname=Util.null2String(fu.getParameter("fieldname"));
String fieldid=Util.null2String(fu.getParameter("fieldid"));
String fieldvalue=Util.null2String(fu.getParameter(fieldid));    
int idnum=Util.getIntValue(fu.getParameter(fieldid+"_idnum"), 0);
int accnum=Util.getIntValue(fu.getParameter(fieldid+"_num"), 0);

String tempvalue=fieldvalue;
String tempname="";

String isFormSignature=Util.null2String(fu.getParameter("isFormSignature"));

//签字意见
String remark = Util.null2String(fu.getParameter("remark"));
String signdocids = Util.null2String(fu.getParameter("signdocids"));
String signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
String signdocname="";
String signworkflowname="";
ArrayList templist=Util.TokenizerString(signdocids,",");
for(int i=0;i<templist.size();i++){
    String tempdocname=DocComInfo.getDocname((String)templist.get(i));
    if(tempdocname!=null&&!tempdocname.trim().equals("")){
        if(signdocname.equals("")){
            signdocname=tempdocname;
        }else{
            signdocname+=","+tempdocname;
        }
    }
}
templist=Util.TokenizerString(signworkflowids,",");
for(int i=0;i<templist.size();i++){
    String temprequestname=WorkflowRequestComInfo.getRequestName((String)templist.get(i));
    if(temprequestname!=null&&!temprequestname.trim().equals("")){
        if(signworkflowname.equals("")){
            signworkflowname=temprequestname;
        }else{
            signworkflowname+=","+temprequestname;
        }
    }
}
remark = Util.StringReplace(remark,"\r","");
remark = Util.StringReplace(remark,"\"","\\\"");
//如果字段类型是  html类型的多行文本显示框，则将其换行符(\n)替换掉。  否则将其替换成<br>
//换行标签。因为如果是html类型多行文本框，将其换行符直接替换成换行标签会影响其显示效果。
//remark = Util.StringReplace(remark,"\n","&at;");
//String hiddenremark = Util.StringReplace(remark,"&at;","<br>");
remark = Util.StringReplace(remark, "\n","");
String hiddenremark = remark;
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
try{
var wcell=opener.document.all("ChinaExcel");
var nrow=wcell.GetCellUserStringValueRow("<%=fieldname%>");
var ncol=wcell.GetCellUserStringValueCol("<%=fieldname%>");
<%
int indx=0;
if(!tempvalue.equals("")){
    //RecordSet.executeSql("select id,docsubject from docdetail where id in ("+tempvalue+")");
    RecordSet.executeSql("select docId as id,imageFileName as docsubject from DocImageFile where docId in ("+tempvalue+")");
    while(RecordSet.next()){
        String docid=RecordSet.getString("id");
       if(tempname.equals("")){
           tempname=RecordSet.getString("docsubject");
       }else{
           tempname+=","+RecordSet.getString("docsubject");
       }
    indx++;    
    }
}
    String showname="";
    if(!signdocname.equals("")){
        if(showname.equals("")){
            showname=SystemEnv.getHtmlLabelName(857,user.getLanguage())+":"+signdocname;
        }else{
            showname+="&at;"+SystemEnv.getHtmlLabelName(857,user.getLanguage())+":"+signdocname;
        }
    }
    if(!signworkflowname.equals("")){
        if(showname.equals("")){
            showname=SystemEnv.getHtmlLabelName(1044,user.getLanguage())+":"+signworkflowname;
        }else{
            showname+="&at;"+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+":"+signworkflowname;
        }
    }
    if(!tempname.equals("")){
        if(showname.equals("")){
            showname=SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":"+tempname;
        }else{
            showname+="&at;"+SystemEnv.getHtmlLabelName(22194,user.getLanguage())+":"+tempname;
        }
    }
    if(!isFormSignature.equals("1")){
        if(!remark.equals("")){
            if(showname.equals("")){
                showname=remark;
            }else{
                showname=remark+"&at;"+showname;
            }
        }
    }
%>
opener.document.all("<%=fieldid%>").value="<%=tempvalue%>";
opener.document.all("remark").value="<%=hiddenremark%>";
opener.document.all("signdocids").value="<%=signdocids%>";
opener.document.all("signworkflowids").value="<%=signworkflowids%>";
//设置单元格只显示HTML标签的结果，不显示html标签。以免影响显示效果。
wcell.SetCellHtmlType(nrow,ncol,nrow,ncol,true);
<%if(isFormSignature.equals("1")){%>
		if(opener.document.all("workflowRequestLogId").value>0)
			wcell.SetCellVal(nrow,ncol,getChangeField("<%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18695,user.getLanguage())%>&at;<%=showname%>"));
		else 
			wcell.SetCellVal(nrow,ncol,getChangeField("<%=showname%>"));
<%}else{%>
    wcell.SetCellVal(nrow,ncol,getChangeField("<%=showname%>"));
<%}%>
imgshoworhideopener(nrow,ncol);
wcell.RefreshViewSize();
}catch(e){}
window.close();
</script>