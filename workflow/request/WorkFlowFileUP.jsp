
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import = "weaver.general.Util"%>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rsfgs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<BODY id="flowbody" onload="this.focus();">
<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;

String fieldvalue=Util.null2String(request.getParameter("fieldvalue"));
String fieldname=Util.null2String(request.getParameter("fieldname"));
String isbill = Util.null2String(request.getParameter("isbill"));
String fieldid=Util.null2String(request.getParameter("fieldid"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
int isedit=Util.getIntValue(request.getParameter("isedit"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"));
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"));
//int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
//int ismonitor=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0);
String selectfieldvalue=Util.null2String(request.getParameter("selectfieldvalue"));
String candelacc = "";
String forbidAttDownload="";
 RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
 String docCategory_ = "";
 if(RecordSet.next()){
	docCategory_ = RecordSet.getString("docCategory");
	candelacc = RecordSet.getString("candelacc");
	forbidAttDownload=RecordSet.getString("forbidAttDownload");
 }
String fieldtype="1";
ArrayList tempname=Util.TokenizerString(fieldname,"_");
if(tempname.size()==3){
    fieldtype=(String)tempname.get(1);
}
//fieldname=field49943_0_2_6
int isdetail = 0;
if(tempname.size()==4){
    fieldtype=(String)tempname.get(2);
    isdetail = 1;
}


int fieldimgwidth=0;                            //图片字段宽度
int fieldimgheight=0;                           //图片字段高度
int fieldimgnum=0;                              //每行显示图片个数
if(fieldid.length()>5){
    String id=fieldid.substring(5);
    if (isbill.equals("1")) {
        RecordSet.executeSql("select imgwidth,imgheight,textheight from workflow_billfield where id="+id);
        if (RecordSet.next()) {
            fieldimgwidth = RecordSet.getInt("imgwidth");
            fieldimgheight = RecordSet.getInt("imgheight");
            fieldimgnum = RecordSet.getInt("textheight");
        }
    }else{
        fieldimgwidth=FieldComInfo.getImgWidth(id);
        fieldimgheight=FieldComInfo.getImgHeight(id);
        fieldimgnum=FieldComInfo.getImgNumPreRow(id);
    }
String tempcurrentnodetype = "";
RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid="+requestid);
if(RecordSet.next()) tempcurrentnodetype = RecordSet.getString("currentnodetype");

//requestid为-1时，则此流程为新建

if ("".equals(tempcurrentnodetype) && requestid == -1) {
	tempcurrentnodetype = "0";
}

 int maxUploadImageSize =5;
 String mainId="";
 String subId="";
 String secId="";


 int uploadType =Util.getIntValue(request.getParameter("uploadType"), 0);
 
 String selectedfieldid = Util.null2String(request.getParameter("selectedfieldid"));
 boolean isCanuse = RequestManager.hasUsedType(Util.getIntValue(workflowid,-1));
 if(selectedfieldid.equals("") || selectedfieldid.equals("0")){
 	isCanuse = false;
 }
 else
 {
	//查询选择框的所有可以选择的值

	char flag= Util.getSeparator() ;
	String isAccordToSubCom="";
	RecordSet.executeProc("workflow_SelectItemSelectByid",""+selectedfieldid+flag+isbill);
	 while(RecordSet.next())
	 {
	     //获取选择目录的附件大小信息
          isAccordToSubCom = Util.null2String(RecordSet.getString("isAccordToSubCom"));
	     String tdocCategory = Util.toScreen(RecordSet.getString("docCategory"),user.getLanguage());
          String tmpselectvalue = Util.null2String(RecordSet.getString("selectvalue"));
		  if(isAccordToSubCom.equals("1")){	    		    	
		    	int subCompanyIdfgs=0;
		    	try{
		    		subCompanyIdfgs=Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()),0);
		    	}catch(Exception ex){
		    		
		    	}
			    	
			    rsfgs2.executeSql("SELECT docCategory FROM Workflow_SelectitemObj where fieldid="+selectedfieldid+" and selectvalue="+tmpselectvalue+" and  isBill="+isbill+" and objType='1' and objId= "+subCompanyIdfgs);		  
				while (rsfgs2.next()){
			    	 tdocCategory=Util.null2String(rsfgs2.getString("docCategory"));
					 
				   }

		 }	   

	     if(!"".equals(tdocCategory))
	     {
	    	
            if(uploadType==1&&selectfieldvalue.equals(tmpselectvalue)){
                docCategory_=tdocCategory;
            }
	     }
	 }
 }
if(docCategory_!=null && !docCategory_.equals("") && !docCategory_.equals(",,")){
     mainId=docCategory_.substring(0,docCategory_.indexOf(','));
     subId=docCategory_.substring(docCategory_.indexOf(',')+1,docCategory_.lastIndexOf(','));
     secId=docCategory_.substring(docCategory_.lastIndexOf(',')+1);
     maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secId),5);
 }
 //如果附件存放方式为选择目录，则重置默认值

 if(uploadType==1&&selectfieldvalue.equals(""))
 {
	 maxUploadImageSize = 5;
 }
 if(maxUploadImageSize<=0){
 maxUploadImageSize = 5;
 }   
%>
<%
	if(fieldvalue.trim().equals("")&&isedit<=0){
		String tempVa = "<h1><font color='red'> 被转发、抄送特殊处理，能查看、下载附件!!</font></h1>";
		out.println(tempVa);
	}	
%>
<table cols=3 id="<%=fieldid%>_tab">
<form name="frmmain" method="post" action="WorkFlowFileUPOption.jsp" enctype="multipart/form-data">

    <input type=hidden name="uploadType" value="<%=uploadType%>">
    <input type=hidden name="selectedfieldid" value="<%=selectedfieldid%>">
    <input type=hidden name="selectvalue" value="0">
   <input type=hidden name="workflowid" value="<%=workflowid%>">
    <input type=hidden name="imgwidth" value="<%=fieldimgwidth%>">
    <input type=hidden name="imgheight" value="<%=fieldimgheight%>">
   <input type=hidden name="imgnumprerow" value="<%=fieldimgnum%>">
<TBODY >
<COL width="90%" >
<COL width="5%" >
<COL width="5%">
<%
if(isedit>0){
%>
    <tr>
            <td valign="top" colspan="3">
            <%
            String picfiletypes="*.*";
          String filetypedesc="All Files";
          if(fieldtype.equals("2")){
              picfiletypes=BaseBean.getPropValue("PicFileTypes","PicFileTypes");
              filetypedesc="Images Files";
          }
                boolean canupload=true;
                if(uploadType == 0){if("".equals(mainId) && "".equals(subId) && "".equals(secId)){
                    canupload=false;
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}}else if(!isCanuse){
               canupload=false;
           %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}
           if(canupload){
           %>
            <script>		   
          var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=mainId%>",
                "subId":"<%=subId%>",
                "secId":"<%=secId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=maxUploadImageSize%> MB",
            file_types : "<%=picfiletypes%>",
            file_types_description : "<%=filetypedesc%>",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancelFor<%=fieldid%>",
                SubmitButtonId : "btnSubmit<%=fieldid%>",
                uploadspan : "<%=fieldid%>span",
                uploadfiedid : "<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/js/swfupload/add_wev8.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete
        };
        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileupload<%=fieldid%>, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileupload<%=fieldid%>);
  			}else{
  			    window.onload=fileupload<%=fieldid%>;
  			}	
        </script>
      <TABLE class="">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:pointer;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();" id="btnCancelFor<%=fieldid%>">
									<span><img src="/js/swfupload/delete_wev8.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=maxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                                &nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#262626;cursor:pointer;TEXT-DECORATION:none" onclick="dosubmit();" id="btnSubmit<%=fieldid%>"><img src="/images/docs/submit_wev8.gif" border="0">
                                <span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(530,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%></font><!--开始上传--></span></span>
                      <span id="<%=fieldid%>span"></span>
                  </div>
                  <input  class=InputStyle  type=hidden name="<%=fieldid%>" viewtype="0" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
    <input type=hidden name='<%=fieldid%>_num' value="1">
    <input type=hidden name="fieldname" value="<%=fieldname%>">
    <input type=hidden name="fieldid" value="<%=fieldid%>">
    </td>
          </tr>
<%}
if(!fieldvalue.trim().equals("")){
    String sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
    int linknum=-1;
    int imgnum=fieldimgnum;
    boolean isfrist=false;
    RecordSet.executeSql(sql);
    int AttachmentCounts=RecordSet.getCounts();
    while(RecordSet.next()){
        isfrist=false;
        linknum++;
        String showid = Util.null2String(RecordSet.getString(1)) ;
        String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
        int accessoryCount=RecordSet.getInt(3);

        DocImageManager.resetParameter();
        DocImageManager.setDocid(Integer.parseInt(showid));
        DocImageManager.selectDocImageInfo();

        String docImagefileid = "";
        long docImagefileSize = 0;
        String docImagefilename = "";
        String fileExtendName = "";
        int versionId = 0;

        String imgSrc=AttachFileUtil.getImgSrcByDocId(showid,"20");

        if(DocImageManager.next()){
            docImagefileid = DocImageManager.getImagefileid();
            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
            docImagefilename = DocImageManager.getImagefilename();
            fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1);
            versionId = DocImageManager.getVersionId();
        }
        boolean nodownload=SecCategoryComInfo1.getNoDownload(secId).equals("1")?true:false;
        if(fieldtype.equals("2")){
              if(linknum==0){
              isfrist=true;
              %>
           	<% 
            if(!"1".equals(forbidAttDownload) && AttachmentCounts>1 && !nodownload && linknum==0 ){
            %>
            <tr> 
              <td colSpan=3><nobr>
                  <button type=button class=btn accessKey=1  onclick="top.location='/weaver/weaver.file.FileDownload?fieldvalue=<%=fieldvalue%>&download=1&downloadBatch=1&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>'">
                  <%="&nbsp;&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>  
                  </button>            
              </td>
            </tr> 
            <%}%> 
            <tr>
                <td colSpan=3>
                    <table cellspacing="0" cellpadding="0">
                        <tr>
              <%}
                  if(imgnum>0&&linknum>=imgnum){
                      imgnum+=fieldimgnum;
                      isfrist=true;
              %>
              </tr>
              <tr>
              <%
                  }
              %>
                  <input type=hidden name="<%=fieldid%>_del_<%=linknum%>" value="0">
                  <input type=hidden name="<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
                  <td <%if(!isfrist){%>style="padding-left:15"<%}%>>
                     <table>
                      <tr>
                          <td colspan="2" align="center"><img src="/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>" style="cursor:pointer;" alt="<%=docImagefilename%>" <%if(fieldimgwidth>0){%>width="<%=fieldimgwidth%>"<%}%> <%if(fieldimgheight>0){%>height="<%=fieldimgheight%>"<%}%> onclick="addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')">
                          </td>
                      </tr>
                      <tr>
                              <%
                                  //创建节点，并且该流程允许创建人删除附件才有权限删除附件。

                                  if (isedit>0&&(!candelacc.equals("1") || (candelacc.equals("1") && tempcurrentnodetype.equals("0")))) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","<%=fieldid%>_del_<%=linknum%>");return false;'>[<span style="cursor:pointer;color:black;"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>]</a>
                                    <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><b><font COLOR="#FF0033">√</font></b><span></td>
                              <%}
                                  if (!nodownload) {
                              %>
                              <td align="center"><nobr>
                                  <a href="#" style="text-decoration:underline" onmouseover="this.style.color='blue'" onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>';return false;">[<span style="cursor:pointer;color:black;"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></span>]</a>
                              </td>
                              <%}%>
                      </tr>
                        </table>
                    </td>
              <%}else{
              %>
        <tr>
            <INPUT type=hidden name="<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td valign="top">
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <!--<a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&versionId=<%=versionId%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp-->
                <a href="javascript:addDocReadTag('<%=showid%>');openDocExt('<%=showid%>','<%=versionId%>','<%=docImagefileid%>','<%=isedit%>')"><%=tempshowname%></a>&nbsp
              <%} else if(DocDsp.isPDF(Util.getIntValue(showid),Util.getIntValue(docImagefileid),1)){ %>
                <a href="javascript:addDocReadTag('<%=showid%>');openDocPDF('<%=showid%>','<%=versionId%>','<%=docImagefileid%>','<%=isedit%>')"><%=tempshowname%></a>&nbsp
              <%}else{%>
                <!--<a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp-->
                <a href="javascript:addDocReadTag('<%=showid%>');openAccessory('<%=docImagefileid%>')"><%=docImagefilename%></a>&nbsp

              <%}%>
              <input type=hidden name="<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td valign="top">
                <%if(isedit>0&&(!candelacc.equals("1")||(tempcurrentnodetype.equals("0")&&candelacc.equals("1")))){%>
                <BUTTON type="button" class=btn accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","<%=fieldid%>_del_<%=linknum%>")'><U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                  <span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden">
                    <B><FONT COLOR="#FF0033">√</FONT></B>
                  <span>
                </BUTTON>
                <%}%>
            </td>
            <td valign="top">
              <span id = "selectDownload">
                <%if(((!Util.isExt(fileExtendName))||!nodownload)){%>
                <BUTTON type="button" class=btn accessKey=1  onclick="addDocReadTag('<%=showid%>');top.location='/weaver/weaver.file.FileDownload?fileid=<%=docImagefileid%>&download=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>'">
                  <U><%=linknum%></U>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                </BUTTON>
                
                  <% 
                    //if(isDownloadAll && AttachmentCounts>1 && (linknum+1)==AttachmentCounts){
                    if(!"1".equals(forbidAttDownload) && AttachmentCounts>1 && !nodownload && linknum==0){
                  %>  
                <BUTTON type=button class=btn accessKey=1  onclick="top.location='/weaver/weaver.file.FileDownload?fieldvalue=<%=fieldvalue%>&download=1&downloadBatch=1&requestid=<%=requestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>'">
                  <%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(258,user.getLanguage())%>      
                  <%}%> 
                
                <%}%>
              </span>
            </td>
          </tr>
<%
    }}
if(fieldtype.equals("2")&&linknum>-1){%>
            </tr></table></td></tr>
            <%}%>
    <input type=hidden name="<%=fieldid%>_idnum" value=<%=linknum+1%>>
<%
}%>
    <input type=hidden name='mainId' value=<%=mainId%>>
    <input type=hidden name='subId' value=<%=subId%>>
    <input type=hidden name='secId' value=<%=secId%>>
</tbody>
</form>
</table>
<%}%>
 </body>
</html>
<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>

<script language=javascript>

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

 // isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。

	if(isedit>0){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&isAppendTypeField=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>");
	}
}

function openDocPDF(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/docs/docs/DocDsp.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>");
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>");
}

function dosubmit(){
    //附件上传
     StartUploadAll();
     checkfileuploadcomplet4mode();
}

  function onChangeSharetype(delspan,delid){
  
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
    
    <%if(isdetail==1){%>
    	var fields = delid.split("_");
	    fieldid=fields[0]+"_"+fields[1];
	    linknum=delid.substr(delid.lastIndexOf("_")+1);
    <%}%>
    
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($G(delspan).style.visibility=='visible'){
      $G(delspan).style.visibility='hidden';
      $G(delid).value='0';
        var tempvalue=$G(fieldid).value;
          if(tempvalue==""){
              tempvalue=$G(delfieldid).value;
          }else{
              tempvalue+=","+$G(delfieldid).value;
          }
	     $G(fieldid).value=tempvalue;
    }else{
      $G(delspan).style.visibility='visible';
      $G(delid).value='1';
        var tempvalue=$G(fieldid).value;
        var tempdelvalue=","+$G(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $G(fieldid).value=tempvalue;
    }
  }

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}

</script>
