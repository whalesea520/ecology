<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
if(!HrmUserVarify.checkUserRight("HrmTrainTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
String name=Util.null2String(request.getParameter("name"));
String description=Util.null2String(request.getParameter("description"));
String typecontent=Util.null2String(request.getParameter("typecontent"));
String typeaim=Util.null2String(request.getParameter("typeaim"));
String typeoperator=Util.null2String(request.getParameter("typeoperator"));

String usertype = user.getLogintype();

String mainid=Util.null2String(request.getParameter("mainid"));
String subid=Util.null2String(request.getParameter("subid"));

int secid=Util.getIntValue(request.getParameter("typedocurl"),0);

String categoryname="";
String subcategoryid="";
String cusertype="";

ArrayList mainids=new ArrayList();
ArrayList subids=new ArrayList();
ArrayList secids=new ArrayList();
char flag = 2;
String tempsubcategoryid="";

if(user.getType()==0)
{
    RecordSet.executeProc("DocUserCategory_SMainByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
      mainids.add(RecordSet.getString("mainid"));
    }
    RecordSet.executeProc("DocUserCategory_SSubByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
      subids.add(RecordSet.getString("subid"));
    }    

    RecordSet.executeProc("DocUserCategory_SSecByUser",""+user.getUID()+flag+user.getType());
    while(RecordSet.next()){
      secids.add(RecordSet.getString("secid"));
    }    
}else{
    String subid2="";
    RecordSet.executeProc("DocSecCategory_SByCustomerType",""+user.getType()+flag+user.getSeclevel());
    
    while(RecordSet.next()){
        secids.add(RecordSet.getString("id"));
        if(!tempsubcategoryid.equals(RecordSet.getString("subcategoryid"))){
            subids.add(RecordSet.getString("subcategoryid"));
        }
        tempsubcategoryid=RecordSet.getString("subcategoryid");
    }
    for(int m=0;m<subids.size();m++){
        if(m<subids.size()-1)
        subid2 += (String)subids.get(m)+",";
        else 
        subid2 += (String)subids.get(m);
    }

    String sql="select distinct(maincategoryid) from DocSubCategory where id in ("+subid2+")  order by maincategoryid";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        mainids.add(RecordSet.getString("maincategoryid"));
    }
}

if(secid!=0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",secid+"");
	RecordSet.next();
	 categoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	 subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));	 	 	 
	 cusertype=Util.null2String(""+RecordSet.getString("cusertype"));
	 cusertype = cusertype.trim();	 
}


String testmainid=Util.null2String(request.getParameter("testmainid"));
String testsubid=Util.null2String(request.getParameter("testsubid"));
int testsecid=Util.getIntValue(request.getParameter("typetesturl"),0);

String testcategoryname="";
String testsubcategoryid="";
String testcusertype="";

ArrayList testmainids=new ArrayList();
ArrayList testsubids=new ArrayList();
ArrayList testsecids=new ArrayList();
char testflag = 2;
String testtempsubcategoryid="";

if(user.getType()==0)
{
    RecordSet.executeProc("DocUserCategory_SMainByUser",""+user.getUID()+testflag+user.getType());
    while(RecordSet.next()){
      testmainids.add(RecordSet.getString("mainid"));
    }
    RecordSet.executeProc("DocUserCategory_SSubByUser",""+user.getUID()+testflag+user.getType());
    while(RecordSet.next()){
      testsubids.add(RecordSet.getString("subid"));
    }    

    RecordSet.executeProc("DocUserCategory_SSecByUser",""+user.getUID()+testflag+user.getType());
    while(RecordSet.next()){
      testsecids.add(RecordSet.getString("secid"));
    }    
}else{
    String testsubid2="";
    RecordSet.executeProc("DocSecCategory_SByCustomerType",""+user.getType()+testflag+user.getSeclevel());
    
    while(RecordSet.next()){
        testsecids.add(RecordSet.getString("id"));
        if(!testtempsubcategoryid.equals(RecordSet.getString("subcategoryid"))){
            testsubids.add(RecordSet.getString("subcategoryid"));
        }
        testtempsubcategoryid=RecordSet.getString("subcategoryid");
    }
    for(int m=0;m<testsubids.size();m++){
        if(m<testsubids.size()-1)
        testsubid2 += (String)testsubids.get(m)+",";
        else 
        testsubid2 += (String)testsubids.get(m);
    }

    String sql="select distinct(maincategoryid) from DocSubCategory where id in ("+testsubid2+")  order by maincategoryid";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        testmainids.add(RecordSet.getString("maincategoryid"));
    }
}

if(testsecid!=0){
	RecordSet.executeProc("Doc_SecCategory_SelectByID",testsecid+"");
	RecordSet.next();
	 testcategoryname=Util.toScreenToEdit(RecordSet.getString("categoryname"),user.getLanguage());
	 subcategoryid=Util.null2String(""+RecordSet.getString("subcategoryid"));	 	 	 
	 testcusertype=Util.null2String(""+RecordSet.getString("cusertype"));
	 testcusertype = cusertype.trim();	 
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(6130,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/traintype/HrmTrainType.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="TrainTypeOperation.jsp" method=post >
<input class=inputstyle type="hidden" name=operation value=add>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
    <wea:item><input class=inputstyle type=text size=30 maxlength="50" name="name" value='<%=name%>' onchange="checkinput('name','nameimage')">
        <SPAN id=nameimage>
         <%if(name.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
        </SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
    <wea:item>
		<wea:required id="descriptionSpan" required='<%=description.length() == 0%>'>
			<input class=inputstyle type=text size=60 maxlength="60" name="description" value="<%=description%>" onchange="checkinput('description','descriptionSpan');">
		</wea:required>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%> </wea:item>
    <wea:item>
      <textarea class=inputstyle  cols=50 rows=4 name=typecontent value=<%=typecontent%>><%=typecontent%></textarea>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </wea:item>
    <wea:item>
      <textarea class=inputstyle cols=50 rows=4 name=typeaim value=<%=typeaim%>><%=typeaim%></textarea>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(16167,user.getLanguage())%> </wea:item>
    <wea:item>
			<brow:browser viewType="0" name="typeoperator" browserValue="" 
		    browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="
		    hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
		    completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="240px" browserSpanValue="">
	    </brow:browser>
 		</wea:item>	   
	</wea:group>
</wea:layout>
   <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>		
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
 </form>
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&resourceids&"')>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub
</script>
<script language=javascript>
 function mainchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  function subchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  function testmainchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  function testsubchange(){
    document.frmMain.action="HrmTrainTypeAdd.jsp";
    document.frmMain.submit();
  }
  
  function onTypeOperator(){
  	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
  	if (data!=null){
  		if (data.id!= ""){
  			jQuery("#typeoperatorspan").html(data.name.substring(1,data.name.length));
  			jQuery("#typeoperator").val(data.id);
  		}else{
  			jQuery("#typeoperatorspan").html("<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>");
  			jQuery("#typeoperator").val("");
  		}
  	}
  }

  function checkTextLength(textObj,maxlength){
    var len = trim(textObj.value).length
    if(len >  maxlength){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83448,user.getLanguage())%>"+maxlength);
        return false;
    }
    return true;
  }
  function submitData() {
     if(checkTextLength(document.all.frmMain.typecontent,500)&&checkTextLength(document.all.frmMain.typeaim,500)){
         if(check_formM(frmMain,'name,description,typeoperator')){
			frmMain.submit();
         }
     }
}

function check_formM(thiswins,items)
{
	thiswin = thiswins
	items = ","+items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="typeoperator"){
		if(tmpvalue == 0){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}
 /**
 * trim function ,add by Huang Yu
 */
 function trim(value) {
   var temp = value;
   var obj = /^(\s*)([\W\w]*)(\b\s*$)/;
   if (obj.test(temp)) { temp = temp.replace(obj, '$2'); }
   return temp;
}
</script>
</BODY>
</HTML>
