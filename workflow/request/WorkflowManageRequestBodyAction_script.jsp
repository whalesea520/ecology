<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.browserData.BrowserManager"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.formmode.tree.CustomTreeUtil"%>
<%@page import="weaver.formmode.tree.CustomTreeData"%>
<%@page import="weaver.workflow.field.FileElement"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<%@ page import="weaver.workflow.request.WFFreeFlowManager"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ page import="weaver.workflow.request.RequestConstants" %>
<%@ page import="weaver.general.LocateUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet_nf2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo1" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo1" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>

<%
	String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码

	User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	String userid = ""+user.getUID();
	String selectInitJsStr = Util.null2String(request.getParameter("selectInitJsStr"));
	String newfromdate = Util.null2String(request.getParameter("newfromdate"));
	String newenddate = Util.null2String(request.getParameter("newenddate"));
	int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	int isremark = Util.getIntValue(request.getParameter("isremark"), 0); //当前操作状态
	int workflowid = Util.getIntValue(request .getParameter("workflowid"));

	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String bodychangattrstr = Util.null2String(request.getParameter("bodychangattrstr"));;

	String requestname = Util.null2String((String) session
			.getAttribute(userid + "_" + requestid + "requestname"));//update by fanggsh 20060509 TD4294

	String isbill = Util.null2String(request.getParameter("isbill"));
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	String isrequest = Util.null2String(request.getParameter("isrequest"));
%>


<!--请求的标题结束 -->
<%
	int creater = Util.getIntValue(request.getParameter("creater"), 0);
	int creatertype = Util.getIntValue(request.getParameter("creatertype"), 0);
	String currentdate = Util.null2String(request.getParameter("currentdate"));
	String currenttime = Util.null2String(request.getParameter("currenttime"));
	String fieldCode =  Util.null2String(request.getParameter("fieldCode"));
	
	//判断是否是E8新版保存
    boolean isE8Save = Util.null2String(request.getParameter("isE8Save")).equals("true");
	
	String fieldIdSelect = Util.null2String(request.getParameter("fieldIdSelect"));
	String departmentFieldId = Util.null2String(request.getParameter("departmentFieldId"));
	String subCompanyFieldId = Util.null2String(request.getParameter("subCompanyFieldId"));
	String supSubCompanyFieldId = Util.null2String(request.getParameter("supSubCompanyFieldId"));
	String yearFieldId = Util.null2String(request.getParameter("yearFieldId"));
	String yearFieldHtmlType = Util.null2String(request.getParameter("yearFieldHtmlType"));
	String monthFieldId = Util.null2String(request.getParameter("monthFieldId"));
	String dateFieldId = Util.null2String(request.getParameter("dateFieldId"));
	String docCategory =  Util.null2String(request.getParameter("docCategory"));
	int uploadType = Util.getIntValue(request.getParameter("uploadType"), 0);
	String selectedfieldid = Util.null2String(request.getParameter("selectedfieldid"));
	String keywordismand =  Util.null2String(request.getParameter("keywordismand"));
	String keywordisedit = Util.null2String(request.getParameter("keywordisedit"));
	int titleFieldId = Util.getIntValue(request.getParameter("titleFieldId"), 0);
	int keywordFieldId = Util.getIntValue(request.getParameter("keywordFieldId"), 0);
	ArrayList managefckfields_body = (ArrayList)Util.stringToList(Util.null2String(request.getParameter("managefckfields_body")));
	//获得触发字段名 mackjoe 2005-07-22
  	DynamicDataInput ddi = new DynamicDataInput(workflowid + "");
  	String trrigerfield = ddi.GetEntryTriggerFieldName();
	boolean editbodyactionflag =  Util.null2String(request.getParameter("editbodyactionflag")).equals("true");
	//字段队列
	ArrayList fieldids = (ArrayList)Util.stringToList(Util.null2String(request.getParameter("fieldids"))); 

%>
<script language="javascript">

function funcClsDateTime(){
	//var onlstr = new clsDateTime();
}                

if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}

<%=bodychangattrstr%>
<%String isFormSignature = null;
			RecordSet
					.executeSql("select isFormSignature from workflow_flownode where workflowId="
							+ workflowid + " and nodeId=" + nodeid);
			if (RecordSet.next()) {
				isFormSignature = Util.null2String(RecordSet
						.getString("isFormSignature"));
			}%>
function createDoc(fieldbodyid,docVlaue,isedit)
{
	
	/*
   for(i=0;i<=1;i++){
  		parent.$GetEle("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$GetEle("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$GetEle("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$GetEle("oTDtype_1").className="cycleTDCurrent";
	*/
  	if("<%=isremark%>"==9||"<%=isremark%>"==5||<%=!editbodyactionflag%>){
  		$GetEle("frmmain").action = "RequestDocView.jsp?requestid=<%=requestid%>&docValue="+docVlaue;
  	}else{
  		$GetEle("frmmain").action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
  	}
	$GetEle("frmmain").method.value = "crenew_"+fieldbodyid ;
	$GetEle("frmmain").target="delzw";
    parent.delsave();
	if(check_form($GetEle("frmmain"),'requestname')){
		if( $GetEle("needoutprint"))  $GetEle("needoutprint").value = "1";//标识点正文





		$GetEle("src").value='save';
		$GetEle("isremark").value='0';

//保存签章数据
<%if ("1".equals(isFormSignature)) {%>
	                    try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              if(SaveSignature_save()){
		                            //附件上传
		                            StartUploadAll();
		                            checkuploadcompletBydoc();
		                        }else{
									if(isDocEmpty==1){
										alert("\""+"<%=SystemEnv.getHtmlLabelName(17614, user
										.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423, user
										.getLanguage())%>");
										isDocEmpty=0;
									}else{
										alert("<%=SystemEnv.getHtmlLabelName(21442, user
										.getLanguage())%>");
									}
									return ;
								}
					        }
					    }catch(e){
					        //附件上传
					        StartUploadAll();
                            checkuploadcompletBydoc();
					    }
<%} else {%>
        //附件上传
        StartUploadAll();
        checkuploadcompletBydoc();
<%}%>

    }


}

function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

	// isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。





	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isAppendTypeField=1");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&fromrequest=1");
}

function onNewDoc(fieldid) {
	$GetEle("frmmain").action = "RequestOperation.jsp" ;
	$GetEle("frmmain").method.value = "docnew_"+fieldid ;
	$GetEle("frmmain").isMultiDoc.value = fieldid ;
	$GetEle("frmmain").src.value='save';
    //附件上传
        StartUploadAll();
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
        checkuploadcomplet();
}

function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo)
{
    YearFrom  = parseInt(YearFrom,10);
    MonthFrom = parseInt(MonthFrom,10);
    DayFrom = parseInt(DayFrom,10);
    YearTo    = parseInt(YearTo,10);
    MonthTo   = parseInt(MonthTo,10);
    DayTo = parseInt(DayTo,10);
    if(YearTo<YearFrom)
    return false;
    else{
        if(YearTo==YearFrom){
            if(MonthTo<MonthFrom)
            return false;
            else{
                if(MonthTo==MonthFrom){
                    if(DayTo<DayFrom)
                    return false;
                    else
                    return true;
                }
                else
                return true;
            }
            }
        else
        return true;
        }
}


function checktimeok(){         <!-- 结束日期不能小于开始日期 -->
    if ("<%=newenddate%>"!="b" && "<%=newfromdate%>"!="a" && $GetEle("<%=newenddate%>").value != "")
    {
        YearFrom=$GetEle("<%=newfromdate%>").value.substring(0,4);
        MonthFrom=$GetEle("<%=newfromdate%>").value.substring(5,7);
        DayFrom=$GetEle("<%=newfromdate%>").value.substring(8,10);
        YearTo=$GetEle("<%=newenddate%>").value.substring(0,4);
        MonthTo=$GetEle("<%=newenddate%>").value.substring(5,7);
        DayTo=$GetEle("<%=newenddate%>").value.substring(8,10);
        if (!DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo )){
            window.alert("<%=SystemEnv.getHtmlLabelName(15273, user.getLanguage())%>");
            return false;
        }
    }
    return true;
}

function datainput(parfield){                <!--数据导入-->
      //var xmlhttp=XmlHttp.create();
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	}catch(e){}  
      var detailsum="0";
      try{
          detailsum=$GetEle("detailsum").value;
      }catch(e){ detailsum="0";}
      var tempdata = "";
      var temprand = $GetEle("rand").value ;
      var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum="+detailsum+"&trg="+parfield;
      <%if (!trrigerfield.trim().equals("")) {
				ArrayList Linfieldname = ddi.GetInFieldName();
				ArrayList Lcondetionfieldname = ddi.GetConditionFieldName();
				for (int i = 0; i < Linfieldname.size(); i++) {
					String temp = (String) Linfieldname.get(i);%>
          if($GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>")) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>").value);
      <%}
				for (int i = 0; i < Lcondetionfieldname.size(); i++) {
					String temp = (String) Lcondetionfieldname.get(i);%>
          if($GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>")) StrData+="&<%=temp%>="+escape($GetEle("<%=temp.substring(temp.indexOf("|") + 1)%>").value);
      <%}
			}%>
      
      var tempParfieldArr = parfield.split(",");
	  for(var i=0;i<tempParfieldArr.length;i++){
		  	var tempParfield = tempParfieldArr[i];
		  	if (tempParfield != "") {
		  		tempdata += $G(tempParfield).value+"," ;
		  	}
	  }
	  StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
	  StrData = StrData.replace(/\+/g,"%2B");
      //$GetEle("datainputform").src="DataInputFrom.jsp?"+StrData;
      if($GetEle("datainput_"+parfield)){
		  	$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }
      //xmlhttp.open("POST", "DataInputFrom.jsp", false);
      //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      //xmlhttp.send(StrData);
  }
function getWFLinknum(wffiledname){
    if($GetEle(wffiledname) != null){
        return $GetEle(wffiledname).value;
    }else{
        return 0;
    }
}

function changeKeyword(){
<%if (titleFieldId > 0 && keywordFieldId > 0) {%>
	    var titleObj= $GetEle("field<%=titleFieldId%>");
	    var keywordObj= $GetEle("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		     $GetEle("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordDataEscape&docTitle="+escape(URLencode(titleObj.value))+"&docKeyword="+escape(URLencode(keywordObj.value));
	    }
<%} else if (titleFieldId == -3 && keywordFieldId > 0) {%>
	    var titleObj= $GetEle("requestname");
	    var keywordObj= $GetEle("field<%=keywordFieldId%>");

        if(titleObj!=null&&keywordObj!=null){

		     $GetEle("workflowKeywordIframe").src="/docs/sendDoc/WorkflowKeywordIframe.jsp?operation=UpdateKeywordDataEscape&docTitle="+escape(URLencode(titleObj.value))+"&docKeyword="+escape(URLencode(keywordObj.value));
	    }
<%}%>
}

function URLencode(sStr) 
{	
	   return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F'); 
}
function updateKeywordData(strKeyword){
<%if (keywordFieldId > 0) {%>
	var keywordObj= $GetEle("field<%=keywordFieldId%>");

    var keywordismand=<%=keywordismand%>;
    var keywordisedit=<%=keywordisedit%>;

	if(keywordObj!=null){
		if(keywordisedit==1){
			keywordObj.value=strKeyword;
			if(keywordismand==1){
				checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
			}
		}else{
			keywordObj.value=strKeyword;
			field<%=keywordFieldId%>span.innerHTML=strKeyword;
		}

	}
<%}%>
}


function onShowKeyword(isbodymand){
<%
	if (keywordFieldId > 0) {
	char setSeparator = Util.getSeparator();
	char setSeparator_temp = Util.getSeparator_temp();
%>
	var keywordObj= $GetEle("field<%=keywordFieldId%>");
	var getSeparator = "<%=setSeparator%>";
	var getSeparator_temp = "<%=setSeparator_temp%>";
	if(keywordObj!=null){
		strKeyword=keywordObj.value;
		strKeyword=strKeyword.replace(/%/g,getSeparator);  //因为%作为特殊字符，%也作为转码的字符，如果通过url传参就出现不可解析出现乱码;此处替换后，待显示再替换回来。





		strKeyword=strKeyword.replace(/"/g,getSeparator_temp);
        tempUrl="/docs/sendDoc/WorkflowKeywordBrowserMulti.jsp?strKeyword="+jQuery(keywordObj).data("keywordid");
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("21517",user.getLanguage())%>";
		dialog.Height = 600;
		dialog.Width = 500;
		dialog.Drag = true;
		dialog.URL = tempUrl;
		dialog.callbackfun = function(params,data){
			if(data){
				keywordObj.value=data.name?data.name.replace(/,/g," "):"";
				jQuery(keywordObj).data("keywordid",data.id);
				if(isbodymand==1){
					checkinput('field<%=keywordFieldId%>','field<%=keywordFieldId%>span');
				}
			}
		}
		dialog.show();
	}
<%
    }
%>
}


function uescape(url){
    return escape(url);
}
//** iframe自动适应页面 **//

    function dyniframesize()
    {
    var dyniframe;
    <%for (int i = 0; i < managefckfields_body.size(); i++) {%>
    if (document.getElementById)
    {
        //自动调整iframe高度
        dyniframe =  $GetEle("<%=managefckfields_body.get(i)%>");
        if (dyniframe && !window.opera)
        {
            if (dyniframe.contentDocument && dyniframe.contentDocument.body.offsetHeight){ //如果用户的浏览器是NetScape
                dyniframe.height = dyniframe.contentDocument.body.offsetHeight+20;
            }else if (dyniframe.Document && dyniframe.Document.body.scrollHeight){ //如果用户的浏览器是IE
                //alert(dyniframe.name+"|"+dyniframe.Document.body.scrollHeight);
                dyniframe.Document.body.bgColor="transparent";
                dyniframe.height = dyniframe.Document.body.scrollHeight+20;
            }
        }
    }
    <%}%>
    <%if (fieldids.size() < 1) {%>
    alert("<%=SystemEnv.getHtmlLabelName(22577, user
								.getLanguage())%>");
    <%}%>
    }
    
    if (window.addEventListener)
    window.addEventListener("load", dyniframesize, false);
    else if (window.attachEvent)
    window.attachEvent("onload", dyniframesize);
    else
    window.onload=dyniframesize;

    function changeChildField(obj, fieldid, childfieldid){
        var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+obj.value;
        $GetEle("selectChange").src = "SelectChange.jsp?"+paraStr;
        //alert($GetEle("selectChange").src);
    }
    function doInitChildSelect(fieldid,pFieldid,finalvalue){
    	try{
    		var pField = $GetEle("field"+pFieldid);
    		if(pField != null){
    			var pFieldValue = pField.value;
    			if(pFieldValue==null || pFieldValue==""){
    				jQuery('#field'+fieldid +' option:gt(0)').remove();
    				return;
    			}
    			if(pFieldValue!=null && pFieldValue!=""){
    				var field = $GetEle("field"+fieldid);
    			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
    				$GetEle("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
    			}
    		}
    	}catch(e){}
    }
    <%=selectInitJsStr%>

<%ArrayList currentdateList = Util.TokenizerString(currentdate, "-");
			int departmentId = Util.getIntValue(ResourceComInfo
					.getDepartmentID("" + creater), -1);
			int subCompanyId = Util.getIntValue(DepartmentComInfo1
					.getSubcompanyid1("" + departmentId), -1);
			int supSubCompanyId = Util.getIntValue(SubCompanyComInfo1
					.getSupsubcomid("" + subCompanyId), -1);
			if (supSubCompanyId <= 0) {
				supSubCompanyId = subCompanyId;//若上级分部为空，则认为上级分部为分部
			}%>

    var workflowId=<%=workflowid%>;
    var formId=<%=formid%>;
    var isBill=<%=isbill%>;
	var yearId=-1;
	var monthId=-1;
	var dateId=-1;
	var fieldId=-1;
	var fieldValue=-1;
	var supSubCompanyId=-1;
	var subCompanyId=-1;
	var departmentId=-1;
	var recordId=-1;
	//发文字号初始值取得(TD18867)
	var hasinitfieldvalue=false
	var initfieldValue = -1;
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
		if(!hasinitfieldvalue) {
			initfieldvalue =  $GetEle("field<%=fieldCode%>").value;
			hasinitfieldvalue = true;
		}
	}

	var yearFieldValue=-1;
    var yearFieldHtmlType=-1;
	var monthFieldValue=-1;
	var dateFieldValue=-1;	
	var createrdepartmentid=<%=departmentId%>;

function initDataForWorkflowCode(){
	yearId="";
	monthId="";
	dateId="";
	fieldId="";
	fieldValue="";
	supSubCompanyId="";
	subCompanyId="";
	departmentId="";
	recordId=-1;

	yearFieldValue=-1;
	yearFieldHtmlType="<%=yearFieldHtmlType%>";
	monthFieldValue=-1;
	dateFieldValue=-1;	

	<%
		if(yearFieldId.indexOf("~~wfcode~~")>-1){
			String [] yearlist = yearFieldId.split("~~wfcode~~");
			if(yearlist.length>0){
				for(int yidx=0;yidx < yearlist.length;yidx++){
	%>		
					if( $GetEle("field<%=yearlist[yidx]%>")!=null){
						if(yearFieldHtmlType==5){//年份为下拉框
						  try{
							  var objYear= $GetEle("field<%=yearlist[yidx]%>");
							  var yvalue = "";
							  try{
							  	yvalue = objYear.options[objYear.selectedIndex].text;
							  }catch(e){
								yvalue = "-1";
							  }
							  
							  if(yearId==""){
							  	yearId = yvalue; 
							  }else{
							  	yearId += ","+yvalue; 
							  }
						  	
							}catch(e){}
						}else{
							try{
						    	yearFieldValue= $GetEle("field<%=yearlist[yidx]%>").value;
							}catch(e){
								yearFieldValue = "-1";
							}
						    if(yearFieldValue.indexOf("-")>0){
							    var yearFieldValueArray = yearFieldValue.split("-") ;
							    if(yearFieldValueArray.length>=1){
							    	if(yearId==""){
								    	yearId=yearFieldValueArray[0];
							    	}else{
							    		yearId+= ","+yearFieldValueArray[0];
							    	}
							    }
						    }else{
						    	if(yearId==""){
							    	yearId=yearFieldValue;
						    	}else{
						    		yearId+= ","+yearFieldValue;
						    	}
						    }
						}
					}else{
						<%if (currentdateList.size() >= 1) {%>
						if(yearId==""){
					    	yearId=<%=(String) currentdateList.get(0)%>;
				    	}else{
				    		yearId+= ","+<%=(String) currentdateList.get(0)%>;
				    	}
						<%}%>
					}
	<%		
				}
			}
		}else{
	%>
			if( $GetEle("field<%=yearFieldId%>")!=null){
				if(yearFieldHtmlType==5){//年份为下拉框
				  try{
					  objYear= $GetEle("field<%=yearFieldId%>");
					  yearId=objYear.options[objYear.selectedIndex].text; 
				  }catch(e){
				  }
				}else{
				    yearFieldValue= $GetEle("field<%=yearFieldId%>").value;
				    if(yearFieldValue.indexOf("-")>0){
					    var yearFieldValueArray = yearFieldValue.split("-") ;
					    if(yearFieldValueArray.length>=1){
						    yearId=yearFieldValueArray[0];
					    }
				    }else{
					    yearId=yearFieldValue;
				    }
				}
			}
		<%}%>

		
		<%
		if(monthFieldId.indexOf("~~wfcode~~")>-1){
			String [] monlist = monthFieldId.split("~~wfcode~~");
			if(monlist.length>0){
				for(int midx=0;midx < monlist.length;midx++){
		%>	
					if( $GetEle("field<%=monlist[midx]%>")!=null){
						monthFieldValue= $GetEle("field<%=monlist[midx]%>").value;
						if(monthFieldValue.indexOf("-")>0){
							var monthFieldValueArray = monthFieldValue.split("-") ;
							if(monthFieldValueArray.length>=2){
								//yearId=monthFieldValueArray[0];
								if(monthId==""){
									monthId=monthFieldValueArray[1];
						    	}else{
						    		monthId+= ","+monthFieldValueArray[1];
						    	}
							}
						}
					}else{
						<%if (currentdateList.size() >= 2) {%>
							if(monthId==""){
								monthId="<%=(String) currentdateList.get(1) %>";
					    	}else{
					    		monthId+= ",<%=(String) currentdateList.get(1)%>";
					    	}
						<%}%>
					}
		<%		
				}
			}
		}else{
		%>
			if( $GetEle("field<%=monthFieldId%>")!=null){
				monthFieldValue= $GetEle("field<%=monthFieldId%>").value;
				if(monthFieldValue.indexOf("-")>0){
					var monthFieldValueArray = monthFieldValue.split("-") ;
					if(monthFieldValueArray.length>=2){
						//yearId=monthFieldValueArray[0];
						monthId=monthFieldValueArray[1];
					}
				}
			}
		<%}%>

		
		<%
		if(dateFieldId.indexOf("~~wfcode~~")>-1){
			String [] dlist = dateFieldId.split("~~wfcode~~");
			if(dlist.length>0){
				for(int didx=0;didx < dlist.length;didx++){
		%>	
					if( $GetEle("field<%=dlist[didx]%>")!=null){
						dateFieldValue= $GetEle("field<%=dlist[didx]%>").value;
						if(dateFieldValue.indexOf("-")>0){
							var dateFieldValueArray = dateFieldValue.split("-") ;
							if(dateFieldValueArray.length>=3){
								//yearId=dateFieldValueArray[0];
								//monthId=dateFieldValueArray[1];
								//dateId=dateFieldValueArray[2];
								if(dateId==""){
									dateId=dateFieldValueArray[2];
						    	}else{
						    		dateId+= ","+dateFieldValueArray[2];
						    	}
							}
						}
					}else{
						<%if (currentdateList.size() >= 3) {%>
						if(dateId==""){
							dateId="<%=(String) currentdateList.get(2)%>";
				    	}else{
				    		dateId+= ",<%=(String) currentdateList.get(2)%>";
				    	}
						<%}%>
					}
		<%		
				}
			}
		}else{
		%>
			if( $GetEle("field<%=dateFieldId%>")!=null){
				dateFieldValue= $GetEle("field<%=dateFieldId%>").value;
				if(dateFieldValue.indexOf("-")>0){
					var dateFieldValueArray = dateFieldValue.split("-") ;
					if(dateFieldValueArray.length>=3){
						//yearId=dateFieldValueArray[0];
						//monthId=dateFieldValueArray[1];
						dateId=dateFieldValueArray[2];
					}
				}
			}
		<%}%>

<%if (currentdateList.size() >= 1) {%>
	    if(yearId==""||yearId<=0){
	        yearId=<%=(String) currentdateList.get(0)%>;
        }
<%}%>
<%if (currentdateList.size() >= 2) {%>
	    if(monthId==""||monthId<=0){
	        monthId=<%=(String) currentdateList.get(1)%>;
        }
<%}%>
<%if (currentdateList.size() >= 3) {%>
	    if(dateId==""||dateId<=0){
	        dateId=<%=(String) currentdateList.get(2)%>;
        }
<%}%>


	<%
	if(fieldIdSelect.indexOf("~~wfcode~~")>-1){
		String [] fieldlist = fieldIdSelect.split("~~wfcode~~");
		if(fieldlist.length>0){
			for(int fld=0;fld < fieldlist.length;fld++){
	%>	
				if( $GetEle("field<%=fieldlist[fld]%>")!=null){
					if(fieldId == ""){
						fieldId=<%=fieldlist[fld]%>;
						var fval = $GetEle("field<%=fieldlist[fld]%>").value;
						if(fval == ""){
							fval = "-1";
						}
						fieldValue= fval;
						if(fieldId == ""){
							fieldId = "-1";
						}
					}else{
						<%if(fieldlist[fld].equals(""))
							fieldlist[fld] = "-1";
						%>
						fieldId+=","+<%=fieldlist[fld]%>;
						var fval = $GetEle("field<%=fieldlist[fld]%>").value;
						if(fval == ""){
							fval = "-1";
						}
						fieldValue+=","+fval;
					}
					
				}else{
					if(fieldId == ""){
						fieldId = "-1";
						fieldValue = "-1";
					}else{
						fieldId = ","+"-1";
						fieldValue = ","+"-1";
					}
				}
	<%		
			}
		}
	}else{
	%>
		if( $GetEle("field<%=fieldIdSelect%>")!=null){
			<%if(fieldIdSelect.equals(""))
				fieldIdSelect = "-1";
			%>
			var fval = $GetEle("field<%=fieldIdSelect%>").value;
			if(fval == ""){
				fval = "-1";
			}
			fieldId=<%=fieldIdSelect%>;
			fieldValue= fval;
		}else{
			fieldId = "-1";
			fieldValue = "-1";
		}
	<%}%>

	
	<%
	if(supSubCompanyFieldId.indexOf("~~wfcode~~")>-1){
		String [] supsublist = supSubCompanyFieldId.split("~~wfcode~~");
		if(supsublist.length>0){
			for(int supsubld=0;supsubld < supsublist.length;supsubld++){
	%>	
				if( $GetEle("field<%=supsublist[supsubld]%>")!=null){
					if(supSubCompanyId == ""){
						supSubCompanyId= $GetEle("field<%=supsublist[supsubld]%>").value;
					}else{
						supSubCompanyId+=","+$GetEle("field<%=supsublist[supsubld]%>").value;
					}
				}else{
					if(supSubCompanyId == ""){
						supSubCompanyId="-1";
					}else{
						supSubCompanyId+=",-1";
					}
				}
	<%		
			}
		}
	}else{
	%>
		if( $GetEle("field<%=supSubCompanyFieldId%>")!=null){
			supSubCompanyId= $GetEle("field<%=supSubCompanyFieldId%>").value;
		}
		if(supSubCompanyId==""||(supSubCompanyId<=0&&supSubCompanyId>-1)){
		    supSubCompanyId="-1";
		}
	<%}%>
		
	
	
	<%
	if(subCompanyFieldId.indexOf("~~wfcode~~")>-1){
		String [] subcomlist = subCompanyFieldId.split("~~wfcode~~");
		if(subcomlist.length>0){
			for(int subcomld=0;subcomld < subcomlist.length;subcomld++){
	%>
				if( $GetEle("field<%=subcomlist[subcomld]%>")!=null){
					if(subCompanyId == ""){
						subCompanyId= $GetEle("field<%=subcomlist[subcomld]%>").value;
					}else{
						subCompanyId+=","+$GetEle("field<%=subcomlist[subcomld]%>").value;
					}
				}else{
					if(subCompanyId == ""){
						subCompanyId="-1";
					}else{
						subCompanyId+=",-1";
					}
				}
	<%		
			}
		}
	}else{
	%>
		if( $GetEle("field<%=subCompanyFieldId%>")!=null){
			subCompanyId= $GetEle("field<%=subCompanyFieldId%>").value;
		}
		if(subCompanyId==""||(subCompanyId<=0&&subCompanyId>-1)){
		    subCompanyId="-1";
		}
	<%}%>
	
	
	<%
	if(departmentFieldId.indexOf("~~wfcode~~")>-1){
		String [] deptlist = departmentFieldId.split("~~wfcode~~");
		if(deptlist.length>0){
			for(int deptld=0;deptld < deptlist.length;deptld++){
	%>
				if( $GetEle("field<%=deptlist[deptld]%>")!=null){
					if(departmentId == ""){
						departmentId= $GetEle("field<%=deptlist[deptld]%>").value;
					}else{
						departmentId+= ","+$GetEle("field<%=deptlist[deptld]%>").value;
					}
				}else{
					if(departmentId == ""){
						departmentId="-1";
					}else{
						departmentId+=",-1";
					}
				}
	<%		
			}
		}
	}else{
	%>
		if( $GetEle("field<%=departmentFieldId%>")!=null){
			departmentId= $GetEle("field<%=departmentFieldId%>").value;
		}
		if(departmentId==""||(departmentId<=0&&departmentId>-1)){
		    departmentId="-1";
		}
	<%}%>
}

//发文字号变更(TD18867)
function onChangeCode(ismand){
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
		initDataForWorkflowCode();
		if( $GetEle("field<%=fieldCode%>").value == "" ||  $GetEle("field<%=fieldCode%>").value == initfieldvalue) {
			return;
		} else {
        	$GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=ChangeCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&returnCodeStr="+ escape($GetEle("field<%=fieldCode%>").value) +"&oldCodeStr="+initfieldvalue;
        }
	}
}

function onCreateCodeAgain(ismand){
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
        initDataForWorkflowCode();
        $GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=CreateCodeAgain&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&createrdepartmentid="+createrdepartmentid;
	}
}
function onCreateCodeAgainReturn(newCode,ismand){

		if(typeof(newCode)!="undefined"&&newCode!=""){
			 $GetEle("field<%=fieldCode%>").value=newCode;
			 $GetEle("field<%=fieldCode%>span").innerHTML = "";
			//发文字号重新赋值(TD18867)
			initfieldvalue = newCode;

			if(parent.document.getElementById("requestmarkSpan")!=null){
				parent.document.getElementById("requestmarkSpan").innerText=newCode;
			}

			if( $GetEle("requestmarkSpan")!=null){
				 $GetEle("requestmarkSpan").innerText=newCode;
			}

		}

}

function onChooseReservedCode(ismand){
	if( $GetEle("field<%=fieldCode%>")!=null&& $GetEle("field<%=fieldCode%>span")!=null){
        //initDataForWorkflowCode();
        //url=uescape("/workflow/workflow/showChooseReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	    //con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "" , "dialogWidth=550px;dialogHeight=550px");

		//if(typeof(con)!="undefined"&&con!=""){
		//	$GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=chooseReservedCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&codeSeqReservedIdAndCode="+con+"&ismand="+ismand;	
		//}	
		
		var urls="/systeminfo/BrowserMain.jsp?url="+escape("/workflow/workflow/showChooseReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&createrdepartmentid="+createrdepartmentid);	
		var dialognew = new window.top.Dialog();
		dialognew.currentWindow = window;
		//dialog.callbackfunParam = {id:"test", name:"testname"};
		dialognew.URL = urls;
		dialognew.callbackfun = function (paramobj, con) {
			//alert(con.id);
			//alert(con.name);
			if(typeof(con)!="undefined"&&con!=""){
				var idanname = con.id+"~~wfcodecon~~"+con.name;
				initDataForWorkflowCode();
				$GetEle("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=chooseReservedCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&codeSeqReservedIdAndCode="+encodeURI(idanname)+"&ismand="+ismand+"&createrdepartmentid="+createrdepartmentid;	
			}	
		} ;
		dialognew.Title = "<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>";
		dialognew.Modal = true;
		dialognew.Width = 550 ;
		dialognew.Height = 500 ;
		dialognew.isIframe=false;
		dialognew.show();
		
	}

}

function onNewReservedCode(ismand){
    initDataForWorkflowCode();
    //url=uescape("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
	//con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth=550px;dialogHeight=550px");

	var urls="/systeminfo/BrowserMain.jsp?url="+escape("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&createrdepartmentid="+createrdepartmentid);	
	var dialognew = new window.top.Dialog();
	dialognew.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialognew.URL = urls;
	dialognew.Title = "<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>";
	dialognew.Modal = true;
	dialognew.Width = 550 ;
	dialognew.Height = 500 ;
	dialognew.isIframe=false;
	dialognew.show();
}

jQuery(".wffbtn").mouseover(function(){
   jQuery(this).css("color","red");
}).mouseout(function(){
   jQuery(this).css("color","#123885");
});

function changecancleon(obj){
	/*jQuery(obj).children().eq(1).css("cssText","background-color:#f4fcff!important;padding-left:0px!important");
	jQuery(obj).children().eq(2).css("cssText","background-color:#f4fcff!important;padding-left:0px!important");
	jQuery(obj).children().eq(3).css("cssText","background-color:#f4fcff!important;padding-left:0px!important");*/
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
	//jQuery(obj).children().eq(3).find("span").css("display","block");
}

function changecancleout(obj){
	/*jQuery(obj).children().eq(1).css("cssText","background-color:#ffffff!important;padding-left:0px!important");
	jQuery(obj).children().eq(2).css("cssText","background-color:#ffffff!important;padding-left:0px!important");
	jQuery(obj).children().eq(3).css("cssText","background-color:#ffffff!important;padding-left:0px!important");*/
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
	//jQuery(obj).children().eq(3).find("span").css("display","none");
}

</script>

