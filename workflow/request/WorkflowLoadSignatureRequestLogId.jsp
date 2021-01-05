
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int tempRequestLogId = Util.getIntValue(request.getParameter("tempRequestLogId"),0);
int tempRequestLogIdInit=tempRequestLogId;
String utilRandom=Util.getNumberRandom();
tempRequestLogId=tempRequestLogId+(Util.getIntValue(utilRandom,0)%100000);

// 操作的用户信息
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());



%>


<%@ include file="/workflow/request/iWebRevisionConf.jsp" %>

<%
    String temStr = request.getRequestURI();
    temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

	String revisionServerUrl=temStr+revisionServerName;;
	String revisionClientUrl=temStr+revisionClientName;

	String UserName=username;

%>
          <table border=0  cellspacing="0" cellpadding="0">
          <tbody >
          <tr height='100%'>
            <td style="border: 0px;">
	            <div id="DivID<%=tempRequestLogId%>" style="border:0px !important;display:none;">
		            <OBJECT id="Consult<%=tempRequestLogId%>" width="100%" height="100%" classid="<%=revisionClassId%>" codebase="<%=revisionClientUrl%>" style="border: 0px;"></object>
	            </div>
<script type="text/javascript" src="/js/odoc/common/commonjs.js"></script>
<script language=javascript>
//初始化名称为Consult的控件对象
function initializtion<%=tempRequestLogId%>(){

  document.getElementById("Consult<%=tempRequestLogId%>").WebUrl = "<%=revisionServerUrl%>";           //WebUrl:系统服务器路径，与服务器交互操作，如打开签章信息
  document.getElementById("Consult<%=tempRequestLogId%>").RecordID = "<%=tempRequestLogIdInit%>";           //RecordID:本文档记录编号
  document.getElementById("Consult<%=tempRequestLogId%>").FieldName = "Consult<%=tempRequestLogId%>";                //FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以
  document.getElementById("Consult<%=tempRequestLogId%>").UserName = "<%=UserName%>";           //UserName:签名用户名称
  document.getElementById("Consult<%=tempRequestLogId%>").WebSetMsgByName("USERID","<%=user.getUID()%>");          //USERID:签名用户id
  document.getElementById("Consult<%=tempRequestLogId%>").Enabled = "0";     //Enabled:是否允许修改，0:不允许 1:允许  默认值:1
  document.getElementById("Consult<%=tempRequestLogId%>").PenColor = "#FF0000";                	//PenColor:笔的颜色，采用网页色彩值  默认值:#000000
  document.getElementById("Consult<%=tempRequestLogId%>").BorderStyle = "0";                    //BorderStyle:边框，0:无边框 1:有边框  默认值:1
  document.getElementById("Consult<%=tempRequestLogId%>").EditType = "0";                       //EditType:默认签章类型，0:签名 1:文字  默认值:0
  document.getElementById("Consult<%=tempRequestLogId%>").ShowPage = "0";                       //ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0
  document.getElementById("Consult<%=tempRequestLogId%>").InputText = "";                       //InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容
  document.getElementById("Consult<%=tempRequestLogId%>").PenWidth = "1";                      	//PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2
  document.getElementById("Consult<%=tempRequestLogId%>").FontSize = "14";                      //FontSize:文字大小，默认值:11
  document.getElementById("Consult<%=tempRequestLogId%>").ShowMenu = "0";
  document.getElementById("Consult<%=tempRequestLogId%>").SignatureType = "0";                  //SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0}
  document.getElementById("Consult<%=tempRequestLogId%>").InputList = ""; //InputList:设置文字批注信息列表
  document.getElementById("Consult<%=tempRequestLogId%>").ShowUserListMenu = "true";			//签批用户列表是否显示，"true"为显示

}

 function LoadSignature<%=tempRequestLogId%>(){
	if(jQuery('#Consult<%=tempRequestLogId%>').parent().length <=0 ){
		setTimeout("LoadSignature<%=tempRequestLogId%>",500);
		return;
	}
    initializtion<%=tempRequestLogId%>();                                              //js方式设置控件属性
    document.getElementById("Consult<%=tempRequestLogId%>").LoadSignature();                              //调用签章数据信息
    document.getElementById("Consult<%=tempRequestLogId%>").style.width=document.getElementById("Consult<%=tempRequestLogId%>").ImgWidth;
    document.getElementById("Consult<%=tempRequestLogId%>").style.height=document.getElementById("Consult<%=tempRequestLogId%>").ImgHeight;
    jQuery('#Consult<%=tempRequestLogId%>').parent().width(document.getElementById("Consult<%=tempRequestLogId%>").ImgWidth);
	jQuery('#Consult<%=tempRequestLogId%>').parent().height(document.getElementById("Consult<%=tempRequestLogId%>").ImgHeight);
	jQuery('#Consult<%=tempRequestLogId%>').parent().css("display","block");
	return true;
}
try {
	LoadSignature<%=tempRequestLogId%>();
} catch(e) {
	// 
	var recordId = "<%=tempRequestLogIdInit%>";
	$("#DivID<%=tempRequestLogId%>").html("<img src=''></img>");
	var img = $("#DivID<%=tempRequestLogId%>").find("img");
	var imageFileId;
	queryData({"url":"GetFileUrl.jsp","recordId":recordId},function(params, res){
		imageFileId = res[0].imageFileId;
	});
	
	$(img).attr("src","/weaver/weaver.file.FileDownload?fileid="+imageFileId)
}
</script>
            </td>
          </tr>
          </tbody>
          </table>