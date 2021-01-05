
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<!--
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
-->

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>


 <%@ include file="iWebOfficeConf.jsp" %>
<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int languageId=user.getLanguage();


String operation=Util.null2String(request.getParameter("operation"));

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

%>
<html>
<body onload="Load()" onunload="UnLoad()">

<FORM id=weaver name=weaver action="" method=post>

<table>
	<tr height='100%'>
		<td bgcolor=menu id="doccontenttd">
		</td>
	</tr>
</table>

</FORM>

</body>
</html>
<script language="javascript">

function Load(){

    document.getElementById("doccontenttd").innerHTML="<div style=\"POSITION: relative;width:100%;height:100%;OVERFLOW:hidden;\"><OBJECT id=\"WebOffice\" classid=\"<%=mClassId%>\" style=\"POSITION: relative;width:100.5%;height:98%;top:-20;\" codebase=\"<%=mClientUrl%>\"></OBJECT><div style=\"POSITION:relative;top:-12;\" align=\"center\"></div></div>";

<%

if(operation.equals("ClearDocAccessoriesTrace")||operation.equals("useTempletUpdate")){
%>
    weaver.WebOffice.WebUrl="<%=mServerUrl%>";
<%
    int docId=Util.getIntValue(request.getParameter("docId"),-1);
    int requestId=Util.getIntValue(request.getParameter("requestId"),-1);

    int workflowId=-1;
	RecordSet.executeSql("select workflowId from workflow_requestbase where requestId="+requestId);
	if (RecordSet.next()) {
		workflowId=Util.getIntValue(RecordSet.getString("workflowId"),-1);
	}

	WFManager.reset();
	WFManager.setWfid(workflowId);
	WFManager.getWfInfo();
	String isbill = WFManager.getIsBill();
	int formID = WFManager.getFormid();

	String tableName = "workflow_form";
	if(isbill.equals("1")){
		RecordSet.executeSql("select tablename from workflow_bill where id = " + formID);		//查询工作流单据表的信息
		if(RecordSet.next()){
			tableName = Util.null2String(RecordSet.getString("tablename"));		//获得单据的主表
		}else{
			return;
		}
	}

	//由获得附件字段的字段名称

	String sql_fieldname = "";
	if(isbill.equals("1")){
		sql_fieldname = "select * from workflow_billfield b where b.fieldhtmltype=6 and b.billid=" + formID;
	}else{
		sql_fieldname = "select * from workflow_formfield f, workflow_formdict d where f.fieldid=d.id and d.fieldhtmltype=6 and f.formid=" + formID;
	}
	RecordSet.execute(sql_fieldname);
	ArrayList extraFileList = new ArrayList();
	while(RecordSet.next()){
		String tmp_fieldName = Util.null2String(RecordSet.getString("fieldname"));
		if(!tmp_fieldName.trim().equals("") && !"null".equalsIgnoreCase(tmp_fieldName)){
			extraFileList.add(tmp_fieldName);
		}
	}

	int fieldCount = extraFileList.size();
	String tmp_fieldName=null;
	String fieldValue=null;
	String docIds=""+docId;

	RecordSet.executeSql("select * from " + tableName + " where requestid=" + requestId);
	if(RecordSet.next()){
		for(int i=0; i<fieldCount; i++){
			tmp_fieldName = (String)extraFileList.get(i);
			fieldValue = Util.null2String(RecordSet.getString(tmp_fieldName)).trim();
			fieldValue = "null".equalsIgnoreCase(fieldValue) ? "" : fieldValue;
		  
		  if (!"".equals(fieldValue)){
				  if (fieldValue.indexOf(",") > -1){		  		  
						  String[] imagedocids = fieldValue.split(",");				  		
				  		String onedocid = "";
				  		if (imagedocids.length > 1){
						  		fieldValue = "";
						  		for (int im = 0;im < imagedocids.length; im++){
						  				onedocid = imagedocids[im];
						  				int maxId = 0;
						  				RecordSet.executeSql("select max(a.id) as maxid from DocDetail a where a.doceditionid>0 and  exists(select 1 from DocDetail  where doceditionid=a.doceditionid and id="+onedocid+") ") ;
											if(RecordSet.next()){
												maxId = Util.getIntValue(RecordSet.getString("maxid"),0);
											}
											if(maxId > Integer.parseInt(onedocid)){
													fieldValue += maxId  + ",";
											}													
						  		}
						  }
				  } else {
				  		int maxId = 0;				  		
		  				RecordSet.executeSql("select max(a.id) as maxid from DocDetail a where a.doceditionid>0 and  exists(select 1 from DocDetail  where doceditionid=a.doceditionid and id="+fieldValue+") ") ;
							if(RecordSet.next()){
								maxId = Util.getIntValue(RecordSet.getString("maxid"),0);
							}
							if(maxId > Integer.parseInt(fieldValue)){
									fieldValue = "";
									fieldValue = maxId + "";
							}					  	
				  }
			}
			
			if(fieldValue.startsWith(",")){
			    fieldValue=fieldValue.substring(1);
		    }
		    if(fieldValue.endsWith(",")){
			    fieldValue=fieldValue.substring(0,fieldValue.length()-1);
		    }
            if(!fieldValue.equals("")){
				docIds+=","+fieldValue;
			}
		}
	}



	int docImageId = 0;
	try {
		//DocImageManager.resetParameter();
		//DocImageManager.setDocid(docId);
		//DocImageManager.selectDocImageInfo();
		//while(DocImageManager.next()){
	    RecordSet.executeSql("select * from DocImageFile where  docid in ("+docIds+") and docfiletype<>'1' and isextfile = '1' order by docId asc,id desc, versionId desc");
		while(RecordSet.next()){
			//String docFileType = DocImageManager.getDocfiletype();
			String docFileType = Util.null2String(RecordSet.getString("docFileType"));
			//只取消WORD文档的痕迹
			if(!"3".equals(docFileType)&&!"7".equals(docFileType)){
				continue;
			}

			//int temdiid = DocImageManager.getId();
			int temdiid = Util.getIntValue(RecordSet.getString("id"),-1);
			if (temdiid == docImageId) {
				continue;
			}
			docImageId = temdiid;
			int curdocid=Util.getIntValue(RecordSet.getString("docid"),-1);
			//String curimgid = DocImageManager.getImagefileid();
			//String curimgname = DocImageManager.getImagefilename();
			String curimgid = Util.null2String(RecordSet.getString("imageFileId"));
			String curimgname = Util.null2String(RecordSet.getString("imageFileName"));

			curimgname=Util.StringReplace(curimgname,"\\","\\\\");
			curimgname=Util.StringReplace(curimgname,"&lt;","<");
			curimgname=Util.StringReplace(curimgname,"&gt;",">");
			curimgname=Util.StringReplace(curimgname,"&quot;","\"");
			curimgname=Util.StringReplace(curimgname,""+'\n',"\n");
			curimgname=Util.StringReplace(curimgname,""+'\r',"\r");
			curimgname=Util.StringReplace(curimgname,"\"","\\\"");
			curimgname=Util.StringReplace(curimgname,"&#8226;","·");

			//int versionId = DocImageManager.getVersionId();
			int versionId = Util.getIntValue(RecordSet.getString("versionId"),-1);

			String filetype=".doc";
			if("7".equals(docFileType)){
				filetype=".docx";
			}else{
				filetype=".doc";
			}



%>
			weaver.WebOffice.RecordID="<%=(versionId==0?"":versionId+"")%>_<%=curdocid%>";
	        try{
				weaver.WebOffice.Compatible  = false;
            }catch(e){
            }
			weaver.WebOffice.FileType="<%=filetype%>";

	        try{

		        weaver.WebOffice.Template="";
		        if(weaver.WebOffice.WebOpen()){
		            weaver.WebOffice.WebObject.AcceptAllRevisions(); //接受痕迹
		            //weaver.WebOffice.FileName="<%=curimgname%>";
		            weaver.WebOffice.WebSetMsgByName("SAVETYPE","NEWVERSION");
		            weaver.WebOffice.WebSetMsgByName("NONEWVERSION","TRUE");
		            var vDetailonLoad="<%=SystemEnv.getHtmlLabelName(23601,languageId)%>";
		            weaver.WebOffice.WebSetMsgByName("VERSIONDETAIL", vDetailonLoad);
                    weaver.WebOffice.FileType=changeFileType(weaver.WebOffice.FileType);
<%
	    String imageFileNameNoPostfix=curimgname;
		List postfixList=new ArrayList();
		postfixList.add(".doc");
		postfixList.add(".dot");
		postfixList.add(".docx");
		postfixList.add(".xls");	
		postfixList.add(".xlt");
		postfixList.add(".xlw");
		postfixList.add(".xla");
		postfixList.add(".xlsx");
		postfixList.add(".ppt");
		postfixList.add(".pptx");
		postfixList.add(".wps");
		postfixList.add(".pgf");		
		
		String tempPostfix=null;
		for(int i=0;i<postfixList.size();i++){
			tempPostfix=(String)postfixList.get(i)==null?"":(String)postfixList.get(i);			
		    if(imageFileNameNoPostfix.endsWith(tempPostfix)){
			    imageFileNameNoPostfix=imageFileNameNoPostfix.substring(0,imageFileNameNoPostfix.indexOf(tempPostfix));
	 	    }
		}
%>
		            weaver.WebOffice.FileName="<%=imageFileNameNoPostfix%>"+weaver.WebOffice.FileType;
		            weaver.WebOffice.WebSave(<%=isNoComment%>);
		            weaver.WebOffice.WebSetMsgByName("NONEWVERSION","FALSE");
		        }
            }catch(e){
		    }
<%
		}
	} catch (Exception ex) {
	}

    if(operation.equals("ClearDocAccessoriesTrace")){
%>
        window.parent.returnClearDocAccessoriesTrace();
<%
    }

    if(operation.equals("useTempletUpdate")){
	    String returnVlaue = "";
	    try{
	        RecordSet.executeSql("update  DocDetail set hasUsedTemplet='1' where id ="+docId);
            RecordSet.executeSql("update  docimagefile set docId=-docId where docId<0 and docId=-"+docId); 

            returnVlaue = "true";
	    }catch(Exception e){
	        returnVlaue = "false";
	    }	
%>
        window.parent.iSignatureFunc("<%=returnVlaue%>");
<%
    }
%>


<%
}
%>

}


    function UnLoad(){
    try{
    if (!weaver.WebOffice.WebClose()){
    StatusMsg(weaver.WebOffice.Status);
    }else{
    StatusMsg("<%=SystemEnv.getHtmlLabelName(19716,languageId)%>...");
    }
    }catch(e){}
    }


function changeFileType(xFileType){
	return xFileType;
}
</script>