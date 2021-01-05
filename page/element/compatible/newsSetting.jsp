
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.RecordSet"  %>
<%@ page import="weaver.general.GCONST"  %>
<%@ page import="weaver.docs.news.DocNewsComInfo" %>
<%@ page import="weaver.docs.docs.DocComInfo"%>
<%@ page import="weaver.docs.category.*" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.file.Prop"  %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>
<link href='/css/Weaver_wev8.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver_wev8.js'></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<style>
body   {   
  overflow-y   :   auto   ;   
  overflow-x   :   hidden   ;   
    
  }
</style>
<%
 String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
 String eid = Util.null2String(request.getParameter("eid"));
 String tabId = Util.null2String(request.getParameter("tabId"));
 String tabTitle = "";	
 String value = "";
 String ebaseid = Util.null2String(request.getParameter("ebaseid"));
 String method = Util.null2String(request.getParameter("method"));
 String topDocIds = "";
 String topDocNames = "";
 
 RecordSet rs = new RecordSet();
 if (session.getAttribute(eid + "_Add") != null) {
	Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
	if (tabAddList.containsKey(tabId)) {
		Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
		value = (String) tabInfo.get("tabWhere");
		tabTitle = (String) tabInfo.get("tabTitle");
	}
	
}
if("".equals(value) && "".equals(tabTitle)){
	 rs.execute("select sqlwhere,tabtitle from hpnewstabinfo where eid="+eid+" and tabid="+tabId);
    if(rs.next()){ 
    	value=rs.getString("sqlWhere");
    	tabTitle=rs.getString("tabtitle");
    }
}
boolean isNewReply = weaver.docs.docs.reply.DocReplyUtil.isUseNewReply();	//是否启用新的文档回复
 if(value.indexOf("^topdoc^")!=-1){
		//out.println(strsqlwhere);	
		value = Util.StringReplace(value, "^topdoc^","#");
		String[] temp = Util.TokenizerString2(value, "#");
		//out.println(temp.length);	
		value = Util.null2String(temp[0]);
		if(temp.length==2){
			topDocIds = Util.null2String(temp[1]);	
		}
		if(!topDocIds.equals("")){
			DocComInfo dci=new DocComInfo();	 			
			topDocNames=dci.getMuliDocName2(topDocIds);
		}
	}
 String divString ="";
 String setValue1="";
	String setValue2=""; 
	String setValue3="";
	String setValue4="";

 //if("^,^1".equals(value)||"^,^2".equals(value)||"^,^3".equals(value))  return divString;
	if(value.length()<5) {
		setValue1="0";
		setValue2="1"; 
		setValue3="None";
		setValue4="0";
		
	} else {
		if("^,^".equals(value.substring(0,3)))  {
			divString="1|0|0"+divString;
			//return divString;
		}

	   
		if(!"".equals(value)){
			try {
				value = Util.StringReplace(value, "^,^","&");
			} catch (Exception e) {					
				e.printStackTrace();
			}
			ArrayList newsSetList=Util.TokenizerString(value,"&");
			setValue1=(String)newsSetList.get(0);
			if(newsSetList.size()>1){
				setValue2=(String)newsSetList.get(1);
			}
			if(newsSetList.size()>=4) {
				setValue3=(String)newsSetList.get(2);
				setValue4=(String)newsSetList.get(3);
			}

			if(newsSetList.size()==3) {
				setValue1 = "";
				setValue2 = (String)newsSetList.get(0);
				setValue3 = (String)newsSetList.get(1);
				setValue4 = (String)newsSetList.get(2);
			}
		}
	}
	try {
		DocNewsComInfo dnc=new DocNewsComInfo();
		tabTitle = Util.toHtml2(tabTitle.replaceAll("&","&amp;"));
		
		
		//文档来源设置部分的修改开始
		String srcType="";
		
		String strSrcType1="";
		String strSrcType2=""; 
		String strSrcType3="";
		String strSrcType4="";
		String strSrcType5="";
		String strSrcType6="";
		
		String srcContent="";
		String strSrcContent1="0";
		String strSrcContent2="0";
		String strSrcContent3="0";
		String strSrcContent4="0"; 
		String strSrcContent5="0"; 
		String strSrcContent6="0"; 
		
		String strSrcContentName1="";
		String strSrcContentName2="";
		String strSrcContentName3="";
		String strSrcContentName4="";
		String strSrcContentName5="";
		String strSrcContentName6="";
		
		String srcReply="0";
		String srcReply1="";
		String srcReply2="";
		String srcReply3="";
		String srcReply4=""; 
		String srcReply5=""; 
		String srcReply6=""; 
		
		
		ArrayList docSrcList=Util.TokenizerString(setValue1, "|");
		if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
		if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
		if (docSrcList.size()>2) srcReply=(String)docSrcList.get(2);
		String initValue="";
		if("0".equals(srcType)) strSrcType1=" checked ";
		if("1".equals(srcType)) {
			strSrcType1=" checked ";
			strSrcContent1=srcContent;
			if("1".equals(srcReply)) srcReply1=" checked ";
			if(!"".equals(srcContent)){
				strSrcContentName1="<a target='_blank' href='/docs/news/NewsDsp.jsp?id="+srcContent+"' target='_blank'>"+dnc.getDocNewsname(srcContent)+"</a>";
			}
			initValue="1|"+srcContent+"|"+srcReply; 
		} 
		else if("2".equals(srcType)) {
			
			if("1".equals(srcReply)) srcReply2=" checked ";
			strSrcType2=" checked "; 
			strSrcContent2=srcContent;
			SecCategoryComInfo scc=new SecCategoryComInfo();
			ArrayList secidList=Util.TokenizerString(srcContent, ",");
			for(int i=0;i<secidList.size();i++){
				String secid=(String)secidList.get(i);
				String secname=scc.getAllParentName(secid,true);		
				strSrcContentName2+="<a target='_blank'  href='/docs/search/DocSummaryList.jsp?showtype=0&displayUsage=0&seccategory="+secid+"'>"+secname+"</a>&nbsp;";
			}
			//strSrcContentName2=scc.getPath(srcContent);
			initValue="2|"+srcContent+"|"+srcReply;
		}
		else if("3".equals(srcType)) {
			if("1".equals(srcReply)) srcReply3=" checked ";
			strSrcType3=" checked ";
			strSrcContent3=srcContent;
			DocTreeDocFieldComInfo dtfci=new DocTreeDocFieldComInfo();
			strSrcContentName3=dtfci.getMultiTreeDocFieldNameOther(srcContent);
			initValue="3|"+srcContent+"|"+srcReply; 
		}
		else if("4".equals(srcType)) {
			if("1".equals(srcReply)) srcReply4=" checked ";
			strSrcType4=" checked ";
			strSrcContent4=srcContent;
			DocComInfo dci=new DocComInfo();	 			
			strSrcContentName4=dci.getMuliDocName2(srcContent);
			initValue="4|"+srcContent+"|"+srcReply; 
		}
		/*else if("5".equals(srcType)) {
			if("1".equals(srcReply)) srcReply5=" checked ";
			strSrcType5=" checked ";
			strSrcContent5=srcContent+"|"+srcReply; 
						
			strSrcContentName5="";
			initValue="5|"+srcContent;
		}else if("6".equals(srcType)) {
			if("1".equals(srcReply)) srcReply6=" checked ";
			strSrcType6=" checked "; 
			strSrcContent6=srcContent; 
						
			strSrcContentName6="";
			initValue="6|"+srcContent+"|"+srcReply; 
		}*/
		%>
		<%
		String showMode1="";
		String showMode2="";
		String showMode3="";
	    String showMode4="";
	    String showMode5 ="";

	    if("1".equals(setValue2)) showMode1=" selected ";
		if("2".equals(setValue2)) showMode2=" selected ";
		if("3".equals(setValue2)) showMode3=" selected ";
	    if("4".equals(setValue2)) showMode4=" selected ";
	    if("5".equals(setValue2))showMode5 = "selected";
	    
	    
	    String showDirection0="";
		String showDirection1="";
		String showDirection2="";
		String showDirection3="";
    	String showDirection4="";

     	if("None".equals(setValue3)) showDirection0=" selected ";
		if("Left".equals(setValue3)) showDirection1=" selected ";
		if("Right".equals(setValue3)) showDirection2=" selected ";
     	if("Up".equals(setValue3)) showDirection3=" selected ";
		if("Down".equals(setValue3)) showDirection4=" selected ";
		
		String showOpenFirsetAss0="";
		String showOpenFirsetAss1="";
		if("0".equals(setValue4)) showOpenFirsetAss0=" selected ";
		if("1".equals(setValue4)) showOpenFirsetAss1=" selected ";
	%>
	
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"/>  
		</jsp:include>
		
		  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
	  <%
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
	  RCMenuHeight += RCMenuHeightStep ;
	
	  %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top"
							onclick="checkSubmit();" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
			<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
	      <wea:item>
	      	<input  class=inputStyle name='tabTitle_<%=eid %>' id='tabTitle_<%=eid %>' type='text' value="<%=tabTitle %>"  onchange='checkinput("tabTitle_<%=eid %>","tabTitleSpan_<%=eid %>")' /><SPAN id='tabTitleSpan_<%=eid %>'>
			<%
			if(tabTitle.equals("")){
				%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%
			}
			%>
			</SPAN>
		    </wea:item>
		    <wea:item><%=SystemEnv.getHtmlLabelName(23784,user.getLanguage())%></wea:item>
		    <wea:item>
		    	   
		         <brow:browser viewType='0' name='<%="topdocids_"+eid%>' browserValue='<%=topDocIds%>'  nameSplitFlag='<br>'
							browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids='
							hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px'
							 linkUrl='#'
							browserSpanValue='<%=topDocNames %>'></brow:browser> 
		     </wea:item>
		     <wea:item>
		     	<%=SystemEnv.getHtmlLabelName(20532,Util.getIntValue(userLanguageId)) %>
		     </wea:item>
		     <wea:item>
		     	<input type=hidden id=_whereKey_<%=eid %> name=_whereKey_<%=eid %> value='<%=initValue %>'>
		  <TABLE >
		  <tr> 
			<TD  style='word-wrap:break-word;word-break:break-all;'>
				<input style="float:left" type=radio <%=strSrcType1 %> onclick=onNewContentCheck(this,<%=eid %>,'news')  name=rdi_<%=eid %> id=news_<%=eid %>  value='<%=strSrcContent1 %>' selecttype=1 >
				<span  >&nbsp;<%=SystemEnv.getHtmlLabelName(16356,Util.getIntValue(userLanguageId))%>&nbsp;&nbsp;</span><!--新闻中心-->&nbsp;&nbsp;
				 
				<input type="hidden" selecttype=1 id="brow_news_<%=eid%>" name="brow_news_<%=eid%>" value="<%=strSrcContent1%>">
			    <button type="button" class="Browser" onclick="onShowNew(brow_news_<%=eid%>,brow_news_<%=eid%>span,'<%=eid%>')"></button> <span id="brow_news_<%=eid%>span"><%= Util.StringReplace(strSrcContentName1,"<br>","&nbsp;") %></span> 
		        
			</TD>
		  </TR>

		  <TR>
			<TD  style='word-wrap:break-word;word-break:break-all;'>
				<input style="float:left" type=radio  <%=strSrcType2 %> onclick=onNewContentCheck(this,<%=eid %>,'cate')  name=rdi_<%=eid %> id=cate_<%=eid %> value='<%=strSrcContent2 %>' selecttype=2 >
				<span   >&nbsp;<%=SystemEnv.getHtmlLabelName(16398,Util.getIntValue(userLanguageId))%>&nbsp;&nbsp;</span><!--文档目录-->&nbsp;&nbsp;			
			
		       <input type="hidden" selecttype=2 id="brow_cate_<%=eid%>" name="brow_cate_<%=eid%>" value="<%=strSrcContent2%>">
			   <button type="button" class="Browser" onclick="onShowMultiCatalog(brow_cate_<%=eid%>,brow_cate_<%=eid%>span,'<%=eid%>')"></button> <span id="brow_cate_<%=eid%>span"><%= Util.StringReplace(strSrcContentName2,"<br>","&nbsp;") %></span> 
				<span style="<%=isNewReply ? "display:none" : "" %>"  >
		  &nbsp;&nbsp;<input id=chkcate_<%=eid %> type=checkbox value=1 <%=srcReply2 %> onclick="chkReplyClick(this,'<%=eid %>','cate')"> <%=SystemEnv.getHtmlLabelName(20568,Util.getIntValue(userLanguageId))%>
		  		</span>
			</TD>
		  </TR>

		  <TR>
			<TD  style='word-wrap:break-word;word-break:break-all;'>	
				<input style="float:left" type=radio  <%=strSrcType3 %> onclick=onNewContentCheck(this,<%=eid %>,'dummy')  name=rdi_<%=eid %> id=dummy_<%=eid %>  value='<%=strSrcContent3%>' selecttype=3 >
				<span  > &nbsp;<%=SystemEnv.getHtmlLabelName(20482,Util.getIntValue(userLanguageId))%>&nbsp;&nbsp;</span><!--虚拟目录-->&nbsp;&nbsp;
				
			   
			   <input type="hidden" selecttype=3 id="brow_dummy_<%=eid%>" name="brow_dummy_<%=eid%>" value="<%=strSrcContent3%>">
			   <button type="button" class="Browser" onclick="onShowMutiDummy(brow_dummy_<%=eid%>,brow_dummy_<%=eid%>span,'<%=eid%>')"></button> <span id="brow_dummy_<%=eid%>span"><%= Util.StringReplace(strSrcContentName3,"<br>","&nbsp;") %></span> 
								
			<span style="<%=isNewReply ? "display:none" : "" %>"  >
		     &nbsp;&nbsp;<input id=chkdummy_<%=eid %> type=checkbox  value=1 <%=srcReply3 %>  onclick="chkReplyClick(this,'<%=eid %>','dummy')"><%=SystemEnv.getHtmlLabelName(20568,Util.getIntValue(userLanguageId)) %>
		     </span>
			</TD>
		  </TR>

		  <TR>
			<TD  style='word-wrap:break-word;word-break:break-all;'>
				<input style="float:left" type=radio <%=strSrcType4 %>  onclick=onNewContentCheck(this,<%=eid %>,'docids')  name=rdi_<%=eid %> id=docids_<%=eid %>  value='<%=strSrcContent4 %>' selecttype=4>
				<span  > &nbsp;<%=SystemEnv.getHtmlLabelName(20533,Util.getIntValue(userLanguageId)) %>&nbsp;&nbsp;</span><!--指定文档-->&nbsp;&nbsp;
			   <input type="hidden" selecttype=4 id="brow_docids_<%=eid%>" name="brow_docids_<%=eid%>" value="<%=strSrcContent4%>">
			   <button type="button" class="Browser" onclick="onShowMDocs(brow_docids_<%=eid%>,brow_docids_<%=eid%>span,'<%=eid%>')"></button> <span id="brow_docids_<%=eid%>span"><%= Util.StringReplace(strSrcContentName4,"<br>","&nbsp;") %></span> 
								
		
			</TD>
		  </TR>
		  </TABLE>
		  </wea:item>
		  		
		  <wea:item>
		  	<%=SystemEnv.getHtmlLabelName(89,Util.getIntValue(userLanguageId))+SystemEnv.getHtmlLabelName(599,Util.getIntValue(userLanguageId))%>
		  </wea:item>  
		  <wea:item>
		  		<select name="_whereKey_<%=eid%>">
					<option value=1 <%=showMode1%>><%=SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))%></option>
                 <option value=4 <%=showMode4%>><%=SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))%>2</option>
                 <option value=2 <%=showMode2%>><%=SystemEnv.getHtmlLabelName(19526,Util.getIntValue(userLanguageId))%></option>
					<option value=3 <%=showMode3%>><%=SystemEnv.getHtmlLabelName(19527,Util.getIntValue(userLanguageId))%></option>
					<option value=5 <%=showMode5%>><%=SystemEnv.getHtmlLabelName(23804,Util.getIntValue(userLanguageId))%></option>
					</select>
		  </wea:item>
		  <wea:item>
		  		<%=SystemEnv.getHtmlLabelName(20281,Util.getIntValue(userLanguageId)) %>
		  </wea:item>
		  <wea:item>
		  	<select  name="_whereKey_<%=eid %>">
				<option value="None" <%=showDirection0 %>><%=SystemEnv.getHtmlLabelName(557,Util.getIntValue(userLanguageId)) %></option>
				<option value="Left" <%=showDirection1 %>><%=SystemEnv.getHtmlLabelName(20282,Util.getIntValue(userLanguageId)) %></option>
				<option value="Right" <%=showDirection2 %>><%=SystemEnv.getHtmlLabelName(20283,Util.getIntValue(userLanguageId)) %></option>
				<option value="Up" <%=showDirection3 %>><%=SystemEnv.getHtmlLabelName(20284,Util.getIntValue(userLanguageId)) %></option>
				<option value="Down" <%=showDirection4 %>><%=SystemEnv.getHtmlLabelName(20285,Util.getIntValue(userLanguageId)) %></option>
		    </select>
		  </wea:item>
		  <wea:item>
		  	<%=SystemEnv.getHtmlLabelName(20895,Util.getIntValue(userLanguageId)) %>
		  </wea:item>
		  <wea:item>
		  	<select  name="_whereKey_<%=eid %>">
				<!--不是--><option value=0 <%=showOpenFirsetAss0 %>><%=SystemEnv.getHtmlLabelName(19843,Util.getIntValue(userLanguageId)) %></option>
				<!--是--><option value=1 <%=showOpenFirsetAss1 %>><%=SystemEnv.getHtmlLabelName(163,Util.getIntValue(userLanguageId)) %></option>
		    </select>&nbsp;(<%=SystemEnv.getHtmlLabelName(20896,Util.getIntValue(userLanguageId)) %>) 
		  </wea:item>
	    </wea:group>
    </wea:layout>
		
		
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
	</div>	
		
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%
} catch (Exception e) {			
e.printStackTrace();
}
%>
 	
<script type="text/javascript">
<!--

//-->

function openDocSetDialog(inputId,spanId,url){


   	    var dlg=new window.top.Dialog();//定义Dialog对象
		dlg.Model=true;
		dlg.Width=550;//定义长度
		dlg.Height=550;
        dlg.URL = url;
		dlg.callback=function(result){
			if (!!result) {

				console.dir(jQuery("#"+inputId));
				
				jQuery("#"+inputId).val(result.id);
                jQuery("#"+spanId).html("<a href='#'>"+result.name+"</a>");

				doCallBack(null,result,inputId);
				dlg.close();
			}
			return ;
		}
		dlg.show();



}



function doCallBack(event,datas,name,_callbackParams){
	var input = name.replace("brow_","")
	$("#"+input).val($("#"+name).val())
	onNewContentCheck($GetEle(input),<%=eid%>,"");
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

function checkSubmit(){
	var dialog = parent.getDialog(window);
	parentWin = dialog.currentWindow;
	parentWin.doTabSave('<%=eid %>','<%=ebaseid %>','<%=tabId %>','<%=method %>');
}

function getNewsSettingString(eid){
	var whereKeyStr="";
	var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
	//得到上传的SQLWhere语句
	for(var k=0;k<_whereKeyObjs.length;k++){
		var _whereKeyObj=_whereKeyObjs[k];	
		if(_whereKeyObj.nodeName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;			
		whereKeyStr+=_whereKeyObj.value+"^,^";			
	}
	if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
	var topDocIds = document.getElementById("topdocids_"+eid).value;
	return whereKeyStr+"^topdoc^"+topDocIds;
}
 
function chkReplyClick(obj,eid,name){

		onNewContentCheck(document.getElementById(name+"_"+eid),eid,name);
}


	function onNewContentCheck(obj,eid,name){	
	
		obj.checked=true;			
		var isHaveReply="0";
		try{
			if(document.getElementById("chk"+name+"_"+eid).checked) isHaveReply="1";
		} catch(e){
		}
		document.getElementById("_whereKey_"+eid).value=$(obj).attr("selecttype")+"|"+obj.value+"|"+isHaveReply;		
		
	}

	function onShowCatalog(input,span,eid) {
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
		var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
		if (result != null) {
		    if (result[0] > 0)  {
				input.value=result[1];
				span.innerHTML=result[5];
			}else{
				input.value="0";
				span.innerHTML="";
			}
		}
		onNewContentCheck(input,eid,'cate');
	}


</script>
<script type="text/javascript">
$(document).ready(function(){
	$('.tab_box').height($('.tab_box').height()-41)
})

function onShowNew(input,span,eid){
   splitflag = ",,,"
   var dlg=new window.top.Dialog();//定义Dialog对象
   dlg.Model=true;
   dlg.Width=550;//定义长度
   dlg.Height=610;
   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp?para="+input.value+"&splitflag="+splitflag;
   dlg.Title="<%=SystemEnv.getHtmlLabelName(16356,user.getLanguage())%>";
   dlg.callbackfun=function(params,datas){
	   if (datas){
			if(datas.id!=""){
				$(span).html("<a target='_blank' href='/docs/news/NewsDsp.jsp?id="+datas.id+"' target='_blank'>"+datas.name+"</a>");
				$(input).val(datas.id);
			}
			else {
				$(span).html("");
				$(input).val("");
			}
			onNewContentCheck(input,eid,"news");
		}
   }
  dlg.show();
}

function onShowMDocs(input,span,eid){
   splitflag = ",,,"
   var dlg=new window.top.Dialog();//定义Dialog对象
   dlg.Model=true;
   dlg.Width=550;//定义长度
   dlg.Height=550;
   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+input.value;
   dlg.Title="<%=SystemEnv.getHtmlLabelName(21478,user.getLanguage())%>";
   dlg.callbackfun=function(params,datas){
		if (datas){
			if (datas.id!=""){
				ids = datas.id.split(",");
				names =datas.name.split(",");
				sHtml = "";
				for( var i=0;i<ids.length;i++){
					if(ids[i]!=""){
						sHtml = sHtml+"<a target='_blank'  href=/docs/docs/DocDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
					}
				}
				$(span).html(sHtml);
				$(input).val(datas.id);
				
			}else {
				$(span).html("");
				$(input).val("");
			}
			
			onNewContentCheck(input,eid,"");
			
		}
   }
    dlg.show();
}

function onShowMultiCatalog(input,span,eid){	
       splitflag = ",,,"
	   var dlg=new window.top.Dialog();//定义Dialog对象
	   dlg.Model=true;
	   dlg.Width=550;//定义长度
	   dlg.Height=550;
	   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategoryMBrowser.jsp?selectids="+input.value+"&splitflag="+splitflag;
	   dlg.Title="<%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%>";
	   dlg.callbackfun=function(params,datas){
			if (datas) {
			    if (datas.id!= "") {
			        ids = (datas.id+",").split(",");
				    names =(datas.path+",").split(",");
				    sHtml = "";
				    for( var i=0;i<ids.length;i++){
					    if(ids[i]!=""){
					    	sHtml = sHtml+"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+ids[i]+"' target='_blank'>"+names[i]+"</a>&nbsp";
					    }
				    }
				    $(span).html(sHtml);
				    $(input).val(datas.id);
			    }
			    else	{
		    	     $(span).html("");
				     $(input).val("");
			    }
			    onNewContentCheck(input,eid,"cate");
			}
	   }
	   dlg.show();	
}



function onShowMutiDummy(input,span,eid){	
	splitflag = ",,,"
   var dlg=new window.top.Dialog();//定义Dialog对象
   dlg.Model=true;
   dlg.Width=550;//定义长度
   dlg.Height=550;
   dlg.URL="/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"&splitflag=,,,";
   dlg.Title="<%=SystemEnv.getHtmlLabelName(20482,user.getLanguage())%>";
   dlg.callbackfun=function(params,datas){
		if (datas) {
			if (datas.id!= ""){
				dummyidArray=datas.id.split(",");
				dummynames=datas.name.split(",");
				dummyLen=dummyidArray.length;
				sHtml="";
				for(var k=0;k<dummyLen;k++){
					sHtml = sHtml+"<a target='_blank' href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp;";
				}
				input.value=datas.id;
				span.innerHTML=sHtml;
			}
			else{			
				input.value="";
				span.innerHTML="";
			}
			onNewContentCheck(input,eid,"");
		}
   }
   dlg.show();	
}

</script>

<span id="encodeHTML" style="display:none"></span> 
