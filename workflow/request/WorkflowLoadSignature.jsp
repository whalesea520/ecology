
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.*" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.FormSignatueConfigInfo" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.ShortCutButtonConfigInfo" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FormSignatureConfigUtil" class="weaver.odoc.workflow.workflow.utils.FormSignatureConfigUtil" scope="page" />

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int requestId = Util.getIntValue(request.getParameter("requestId"),0);
int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int nodeId = Util.getIntValue(request.getParameter("nodeId"),0);
RecordSet.writeLog("WorkflowLoadSignature.jsp requestId="+requestId+",workflowId="+workflowId+",nodeId="+nodeId);
FormSignatueConfigInfo formSignatueConfig = FormSignatureConfigUtil.getFormSignatureConfig(workflowId,nodeId,user);
List<ShortCutButtonConfigInfo> shortCutButtonConfigList = formSignatueConfig.getShortCutButtonConfig();
int formSignatureWidth = formSignatueConfig.getFormSignatureWidth();
int formSignatureHeight = formSignatueConfig.getFormSignatureHeight();
int defaultSignType = Util.getIntValue(formSignatueConfig.getDefaultSignType(),1) - 1;
int defaultOpenSignType = Util.getIntValue(formSignatueConfig.getDefaultOpenSignType(),1) - 1;
int defaultSignatureSource = Util.getIntValue(formSignatueConfig.getDefaultSignatureSource(),1) - 1;
String defaultFontName = "";
if(formSignatueConfig.getDefaultFont() > 0) {
    RecordSet.executeQuery("select f_name from fontinfo where id=?", formSignatueConfig.getDefaultFont());
    defaultFontName = RecordSet.next() ? RecordSet.getString("f_name") : "";
}

int workflowRequestLogId = Util.getIntValue(request.getParameter("workflowRequestLogId"),0);
String isSignMustInput= Util.null2String(request.getParameter("isSignMustInput"));

String isFromHtmlModel = Util.null2String(request.getParameter("isFromHtmlModel"));
String isFromWorkFlowSignUP= Util.null2String(request.getParameter("isFromWorkFlowSignUP"));
String opener="";
if(isFromWorkFlowSignUP.equals("1")){
	opener="opener.";
}

// 操作的用户信息

int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

   		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
   		String workflowPhrases[] = new String[RecordSet.getCounts()];
   		int x = 0 ;
   		if (isSuccess) {
   			while (RecordSet.next()){
   				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
   				x ++ ;
   			}
   		}

			if(workflowRequestLogId<=0){
				int intRecordId=RequestLogIdUpdate.getRequestLogNewId();
            	boolean bSuccess=false;
            	if("oracle".equalsIgnoreCase(RecordSet.getDBType())){
            		bSuccess=RecordSet.executeSql("insert into Workflow_FormSignRemark(requestLogId,remark) values("+intRecordId+",empty_clob())");
            	}else{
            		bSuccess=RecordSet.executeSql("insert into Workflow_FormSignRemark(requestLogId,remark) values("+intRecordId+",'')");
            	}
				if(bSuccess){
					workflowRequestLogId=intRecordId;
				}
			}
%>
		   <script  language="javascript">
            try {
		   <%=opener%>document.frmmain.workflowRequestLogId.value=<%=workflowRequestLogId%>;
            } catch(e) {}
			</script>

<%@ include file="/workflow/request/iWebRevisionConf.jsp" %>
<%
    String temStr = request.getRequestURI();
    temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

	String revisionServerUrl=temStr+revisionServerName;;
	String revisionClientUrl=temStr+revisionClientName;

	int RecordID=workflowRequestLogId;
	String UserName=username;
	String Consult_Enabled="1";

    String strInputList="";
	if(workflowPhrases.length>0){
		for (int i= 0 ; i <workflowPhrases.length;i++) {
			String workflowPhrase = workflowPhrases[i] ;
			if(workflowPhrase!=null&&!workflowPhrase.trim().equals("")){
				strInputList+=workflowPhrase+"\\r\\n";
			}
		}
		strInputList = Util.toScreenForJsBase(strInputList);
	}
%>

<script language=javascript>
// window.setInterval(function(){
	//if(window.console)console.log(document.frmmain.Consult.OpinionText);
// <%if(isSignMustInput.equals("1")){%>
//	if(!document.frmmain.Consult.DocEmpty || document.frmmain.Consult.OpinionText != ""){
//		$GetEle("remarkSpan").innerHTML = "";
//	}else{
		//$GetEle("remarkSpan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
//	}
// <%}%>
//},1000);
//初始化名称为Consult的控件对象

function initializtion(){
    document.frmmain.Consult.WebUrl = "<%=revisionServerUrl %>";           //WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息
    document.frmmain.Consult.RecordID = "<%=RecordID %>";           //RecordID:本文档记录编号
    document.frmmain.Consult.FieldName = "Consult";                //FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以
    document.frmmain.Consult.UserName = "<%=UserName %>";           //UserName:签名用户名称
    document.frmmain.Consult.WebSetMsgByName("USERID","<%=user.getUID()%>");          //USERID:签名用户id
    document.frmmain.Consult.Enabled = "<%=Consult_Enabled %>";     //Enabled:是否允许修改，0:不允许 1:允许  默认值:1 
    document.frmmain.Consult.PenColor = "<%=formSignatueConfig.getDefaultColor() %>";                	//PenColor:笔的颜色，采用网页色彩值  默认值:#000000 
    document.frmmain.Consult.BorderStyle = "0";                    //BorderStyle:边框，0:无边框 1:有边框  默认值:1 
    document.frmmain.Consult.EditType = "<%=defaultSignType %>";                       //EditType:默认签章类型，0:签名 1:文字  默认值:0 
    document.frmmain.Consult.ShowPage = "<%=defaultOpenSignType %>";                       //ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0 
    document.frmmain.Consult.InputText = "";                       //InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容 
    document.frmmain.Consult.PenWidth = "<%=formSignatueConfig.getDefaultFontWidth() %>";                        //PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2 
    document.frmmain.Consult.FontSize = "<%=formSignatueConfig.getDefaultFontSize() %>";                      //FontSize:文字大小，默认值:11
    document.frmmain.Consult.ShowMenu = "0";
    document.frmmain.Consult.SignatureType = "<%=defaultSignatureSource %>";                  //SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0}
    document.frmmain.Consult.InputList = "<%=strInputList %>"; //InputList:设置文字批注信息列表 
    document.frmmain.Consult.ShowUserListMenu = "true";			//签批用户列表是否显示，"true"为显示
    document.frmmain.Consult.FontName="<%=defaultFontName %>";// 设置字体名称
    document.frmmain.Consult.CASignType = "<%=CASignType %>";//默认为不启用数字签名
    document.frmmain.Consult.SetFieldByName("DocEmptyJuggle",<%=DocEmptyJuggle %>);
}

function LoadSignature(){

	enableAllmenu();

    initializtion();                                              //js方式设置控件属性

    document.frmmain.Consult.LoadSignature();                              //调用签章数据信息
    document.frmmain.Consult.ImgWidth="<%=formSignatureWidth %>";
    document.frmmain.Consult.ImgHeight="<%=formSignatureHeight %>";

	displayAllmenu();

	return true;
}

if (window.addEventListener){
    window.addEventListener("load", LoadSignature, false);
}else if (window.attachEvent){
    window.attachEvent("onload", LoadSignature);
}else{
    window.onload=LoadSignature;
}

//作用：切换读取签章的来源方式  针对签章窗体Consult
function chgReadSignatureType(){
  if (document.frmmain.Consult.SignatureType=="1"){
    document.frmmain.Consult.SignatureType="0";
    alert("<%=SystemEnv.getHtmlLabelName(21436,user.getLanguage())%>");
  }else{
    document.frmmain.Consult.SignatureType="1";
    alert("<%=SystemEnv.getHtmlLabelName(21437,user.getLanguage())%>");
  }
}

var isDocEmpty=0;

/**
 * 目标字符串是否为空

 */
function isEmptyString(str) {
	if (str == null || str == undefined || str == "") {
		return true;
	}
	
	return false;
}
//作用：保存签章数据信息  
//保存流程：先保存签章数据信息，成功后再提交到DocumentSave，保存表单基本信息

function SaveSignature(src){
    
    var obj = document.frmmain.Consult;
//开启表单签章后不应校验必填
<%if(isSignMustInput.equals("1") || isSignMustInput.equals("2")){%>
<%if(isSignMustInput.equals("2")) { %>
	if("reject" == src) {
<%} %>
	//判断签批区域是否为空内容 （检测范围包含当签章类型为文字时的输入内容）
    if(obj.DocEmpty && obj.OpinionText == ""){
        isDocEmpty=1;
        return false;
    }
<%if(isSignMustInput.equals("2")) { %>
	}
<%} %>
<%}%>
    saveSignatureOrPic(obj);
    return true;
}

function saveSignatureOrPic(obj) {
    var requestLogId = 0;
    var isAutoResizeSignImage = <%=formSignatueConfig.isAutoResizeSignImage() %>;
    var timestamp = Date.parse(new Date());
    timestamp = timestamp / 1000;
    if (obj.Modify){                    //判断签章数据信息是否有改动
        var saveFlag = isAutoResizeSignImage ? obj.SaveAsGifEx(timestamp+".gif","All","Remote") : obj.SaveSignature();
        if(!saveFlag) {
            return false;
        }
        requestLogId = obj.WebGetMsgByName("RECORDID");
        if(requestLogId > 0 && isAutoResizeSignImage) {
            obj.WebSetMsgByName("TEMPCALL","1");
            obj.WebSetMsgByName("TEMPID",requestLogId);
            saveFlag = obj.SaveSignature();
        }
    } else {
        requestLogId = <%=RecordID %>;
    }
    if(requestLogId > 0) {
        <%=opener%>document.frmmain.workflowRequestLogId.value = requestLogId;
        obj.RecordID = requestLogId;
    }
}

//作用：保存签章数据信息  
//点击保存按钮时调用，不验证签章是否为空

function SaveSignature_save() {   
    var obj = document.frmmain.Consult;
    saveSignatureOrPic(obj);
    return true;
}

jQuery(".ViewForm").bind('click',function(){
   if(document.frmmain.Consult.DocEmpty && document.frmmain.Consult.OpinionText == ""){
      jQuery(".signaturebyhand").css("display","none");
      jQuery("#remarkShadowDiv").css("display","");
      jQuery("#signrighttool").css("display","none");
      jQuery("#signtabtoolbar").css("display","none");
   }
});
<%
	//System.err.println("select remark from workflow_formsignremark where requestLogId = " + RecordID);
	RecordSet.executeSql("select remark from workflow_formsignremark where requestLogId = " + RecordID);
    if(RecordSet.next()){
    //	System.err.println("remark:"+RecordSet.getString("remark"));
    	if(null!=RecordSet.getString("remark")&&!"".equals(RecordSet.getString("remark").trim())){
    		%>
    		  jQuery(document).ready(function(){
    		  		jQuery("#remarkShadowDiv1").trigger("click");
    		  });
    		<%
    	}
    }
%>
</script>
<style type="text/css">
  #consulttab{
    height: 110px;
  }
  #tooltab {
    border:#ccc 1px solid;
  }
  #tooltab a,#tooltab span{
  	FONT-SIZE: 9pt;
  	COLOR: #999; 
  	FONT-FAMILY: "宋体";
  	cursor:pointer;
  	TEXT-DECORATION: none;
  	margin-right:15px;
  }
  #tooltab img{
    cursor: pointer;
  }
  #DivID {
  	border:0px solid #cccccc;
  	border-right:0px;
  	border-top:0px;
  }
  #Consult{
    margin:0px 0px;
  }
</style>
<%
String isIE = (String)session.getAttribute("browser_isie");
if ("true".equals(isIE)) {
%>
   <div id="consultdiv" style="width:100%;height:<%=formSignatureHeight-1%>px;">
          <table id="tooltab" height="30px" cellspacing="0" cellpadding="0" align="center" style="width:inherit ;padding:0px;background:rgb(240, 240, 238);margin-left:5px;<%if(isFromHtmlModel.equals("0")){%>display:none;<%}%>">
          <tbody >
          <tr  height='30px'>
            <td style="vertical-align: middle;">
            <% 
            for(ShortCutButtonConfigInfo btnConfig : shortCutButtonConfigList) {
                if(!btnConfig.isOpen()) {
                    continue;
                }
                if(btnConfig.getId() == 1) {
            %>
                <img src="/images/sign/opensign_wev8.png" style="vertical-align: middle;" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}">
                <a title="" onClick="if (!Consult.OpenSignature()){alert(Consult.Status);}" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(21431,user.getLanguage())%>
                </a>
            <% 
                } else if(btnConfig.getId() == 2) {
            %>
                <img src="/images/sign/filesign_wev8.png" style="vertical-align: middle;" onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};">
                <a onclick="if (Consult.EditType==0){Consult.EditType=1;}else{Consult.EditType=0;};" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(21441,user.getLanguage())%>
                </a>
            <%         
                } else if(btnConfig.getId() == 3) {
            %>
                <img src="/images/sign/signlist_wev8.png" style="vertical-align: middle;" onClick="Consult.ShowSignature();">
                <a title="" onClick="Consult.ShowSignature();" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(21432,user.getLanguage())%>
                </a>
            <%         
                } else if(btnConfig.getId() == 4) {
            %>
                <img src="/images/sign/cancel_wev8.png" style="vertical-align: middle;" onclick="Consult.Clear();">
                <a onclick="Consult.Clear();" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(21433,user.getLanguage())%>
                </a>
            <%        
                } else if(btnConfig.getId() == 5) {
            %>
                <img src="/images/sign/cancelbox_wev8.png" style="vertical-align: middle;" onclick="Consult.ClearAll();">
                <a onclick="Consult.ClearAll();" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(21434,user.getLanguage())%>
                </a>
            <%         
                } else if(btnConfig.getId() == 6) {
            %>
                <img src="/images/sign/trigger_wev8.png" style="vertical-align: middle;" onclick="chgReadSignatureType();">
                <a onclick="chgReadSignatureType();" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(21435,user.getLanguage())%>
                </a>
            <% 
                } else if(btnConfig.getId() == 7) {
            %>
                <img src="/images/sign/trigger_wev8.png" style="vertical-align: middle;" onclick="Consult.ShowZoomInHandWrite();">
                <a onclick="Consult.ShowZoomInHandWrite();" style="vertical-align: middle;">
                    <%=SystemEnv.getHtmlLabelName(131881,user.getLanguage())%>
                </a>
            <%         
                }    
            } 
            %>
            </td>
          </tr>
          </tbody>
          </table>

          <table  id="consulttab" width="<%=formSignatureWidth%>px" height="<%=formSignatureHeight%>px"  cellspacing="0" cellpadding="0" align="left">
          <tbody >
          <tr>
            <td id="formSignatureTd" style="border: 1px solid #ccc;border-top: 0px;">
				<script>
				var str = '';
				str += '<div id="DivID" style="height:<%=formSignatureHeight%>px;width:100%;" >';
				str += '<OBJECT id="Consult" width="<%=formSignatureWidth%>px" height="<%=formSignatureHeight-2%>px" classid="<%=revisionClassId%>" codebase="<%=revisionClientUrl%>" >';
				str += '</object>';
				str += '</div>';
				document.write(str);
				</script>
            </td>
          </tr>
          </tbody>
          </table>
       </div>
<%
} else {
%>
<table style="border: 1px solid #ccc;border-right:0px;border-top:0px;" width="<%=formSignatureWidth%>px" height="<%=formSignatureHeight+1%>px"  cellspacing="0" cellpadding="0" align="left">
    <tr  height='100%'>
    	<td height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			 <%=SystemEnv.getHtmlLabelName(124846,user.getLanguage())%> 
        </td>
    </tr>
</table>

<%
}
%>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")){
%>
     <!-- 
			  <img src="/images/BacoError_wev8.gif" align=absmiddle>
	 -->
<%
	}
%>
              </span>
          <input type=hidden name="remark" value="">
          
<script type="text/javascript">
   //判断IE浏览器是否安装金格插件

   jQuery(window).bind("load",function(){
   	   if(JinGeController() == false&&jQuery.browser.msie){
   	   	  alert("<%=SystemEnv.getHtmlLabelName(84531,user.getLanguage())%>");
   	   }
   });
   
   function JinGeController(){
     try{
     	if(eval("document.frmmain.Consult.DocEmpty") == undefined){
     	   return false;
     	}else{
     	   return true;
     	}
     }catch(e){
     	return false;
     }
   }
</script>