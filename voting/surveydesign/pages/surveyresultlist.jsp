
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="surveyData.jsp" %>
<%@ include file="surveyResultData.jsp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>	
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
 <link rel="stylesheet" href="/voting/surveydesign/css/surveyresult_wev8.css">
  <link rel="stylesheet" href="/voting/surveydesign/css/popup_wev8.css">

</head>
<%
//是否查看结果。1 为查看结果
String viewResult = Util.null2String(request.getParameter("viewResult"));
boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean canParticular = HrmUserVarify.checkUserRight("Voting:particular",user);
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(24115,user.getLanguage());
String needfav ="1";
String needhelp ="";

String votingname = "";
String votingstatus = "";
RecordSet.executeSql("select subject,status from voting where id="+ votingid);
while (RecordSet.next()) {
	votingname = RecordSet.getString("subject");
	votingstatus = RecordSet.getString("status");
}

String surveytitledispaly = "none";
if("1".equals(viewResult)) surveytitledispaly = "";


//System.out.println(subcompanyids+"=subcompanyids");
String subcompanyspan = "";
if(!subcompanyids.equals("")){
	ArrayList SelectSubCompanys = Util.TokenizerString(subcompanyids,",");
	subcompanyids = "";
	for(int i=0;i<SelectSubCompanys.size();i++){
		//subcompanyspan += "<a href=\'javascript:void(0)\' onclick=\'openFullWindowForXtable(\"/hrm/company/HrmSubCompanyDsp.jsp?id="+SelectSubCompanys.get(i) +"\")\'>"+SubCompanyComInfo.getSubCompanyname(""+SelectSubCompanys.get(i))+"</a>&nbsp;";
		subcompanyids +=","+SelectSubCompanys.get(i);
		subcompanyspan += SubCompanyComInfo.getSubCompanyname(""+SelectSubCompanys.get(i))+",";
	 }
	 if(subcompanyspan.length() > 1) {
		 subcompanyids = subcompanyids.substring(1);
	 	 subcompanyspan = subcompanyspan.substring(0, subcompanyspan.length() - 1);
	 }
}

//System.out.println("subcompanyspan=="+subcompanyspan);

%>
<BODY style='overflow:hidden;'>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>


<script type="text/javascript">

		function onBtnSearchClick(){
			jQuery('#weaver').submit();
		}
</script>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM id=weaver name=weaver method=post action="surveyresultlist.jsp">
<input type=hidden name=votingid value="<%=votingid%>">
<input type=hidden name=currentudnum id=currentudnum value="0">
<input type=hidden name=currentdnum id=currentdnum value="0">
<input type=hidden name="viewResult" value="<%=viewResult%>">
<input type="hidden" name="txt_excel_content" />

   <table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
			    <%if (canmaint && null!=novotingperson && novotingperson.size()>0 && canParticular && "1".equals(votingstatus) && !"1".equals(viewResult)) {%>
					<input class="e8_btn_top middle" onclick="doReminders(<%=votingid%>)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(23756,user.getLanguage()) %>"/>
		     	<%}%>
		      <%if(canmaint||canParticular){%>
		      <input class="e8_btn_top middle" onclick="downloadExcel()" type="button" value="Excel"/>
		      <%}%>
		         
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"   class="cornerMenu"></span>
			</td>
		</tr>
	</table>

<%

if ("1".equals(votingstatus) && !"1".equals(viewResult)) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(23756,user.getLanguage())+",javascript:doReminders("+votingid+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(canmaint||canParticular){
	RCMenu += "{Excel,javascript:downloadExcel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if ("1".equals(viewResult)) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if (false) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:save_excel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}


%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="advancedSearchDiv" id="advancedSearchDiv"  >
	     <wea:layout type="4col">
				   <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>' attributes="{'groupDisplay':'none'}">
				         <wea:item><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></wea:item>
				         <wea:item>
				                <brow:browser viewType="0" name="subcompanyids" browserValue='<%=subcompanyids %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" linkUrl="" width="60%"
								browserSpanValue='<%=subcompanyspan %>'></brow:browser>
				         </wea:item>
				         
				         <wea:item><%=SystemEnv.getHtmlLabelName(31889,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19071,user.getLanguage())%></wea:item>
				         <wea:item>
				            <select class=inputstyle name=statics style='width:90%' size=1 >
								<option value="0"></option>
								<option value="0" <%if("0".equals(statisform)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1823,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31889,user.getLanguage())%></option>
								<option value="1" <%if("1".equals(statisform)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(31889,user.getLanguage())%></option>
						             
							</select>
				         </wea:item>
				        
				    	
				    </wea:group>
				    
				    <wea:group context="">
				    	<wea:item type="toolbar">
							<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_submit"/>
								<span class="e8_sep_line">|</span>
							<input type="reset" name="reset" onclick="resetCondtion()"   value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_cancel" >
								<span class="e8_sep_line">|</span>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				    	</wea:item>
				    </wea:group>
		 </wea:layout>
</div>

<div id = "div_excel_content" style='overflow:auto;'>
<div id="surveyreport">

    <!--标题区域-->
    <div class="surveytitle" style="display:none">
        <h2 class="votetitle">
        </h2>
    </div>

    <div class="questions questionsclone">
        
		 <div class='subcompanyname'>
		 
		 </div>
           
        <!--组合选择-->
        <div class="question  matrixclone">
            <div class='questiondetail'><span class="i i_detail_gray" title="<%=SystemEnv.getHtmlLabelName(126097,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%>"></span></div>
		 
            <div class="subject">
                 <span class="questiontitle"></span>
                <span class="rules"></span>
            </div>
            <div>
                <table class="result">
                    <thead>

                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>

        <!--选择-->
        <div class="question selectsignalclone">
            <div class='questiondetail'><span class="i i_detail_gray" title="<%=SystemEnv.getHtmlLabelName(126097,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%>"></span></div>

            <div class="subject">
                 <span class="questiontitle"></span>
                <span class="rules"></span>
            </div>
            <div>
                <table class="result">
                    <colgroup>
                        <col >
                        <col style="width: 150px">
                        <col style="width: 350px">
                    </colgroup>
                    <thead>
                        <th class="first"><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></th>
                        <th><%=SystemEnv.getHtmlLabelName(127895,user.getLanguage())%></th>
                        <th><%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%></th>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>

          <!--填空题-->
        <div  class="question blankfillingclone">
		    <div class="subject">
                 <span class="questiontitle"></span>
                <span class="rules"></span>
            </div>
            <div>
                <div class="blankfilldetail">

                </div>
            </div>
        </div>

    </div>
</div>


 <!--填空查看弹出框-->
<div id="popup" style="left: 433px;width: 600px;min-width:410px;height: 515px; position: absolute; top: 433.5px; z-index: 9999; opacity: 0; display: none;">
    <span class="button b-close"><span>X</span></span>
    <p class="head"></p>

    <div class="ascontainer" style="height: 400px;width: 98%;padding: 5px ; overflow:auto;">
          
    </div>
</div>


<!--调查问题详细信息-->
<div id="imgpopup" style="left: 433px;width: 785px;min-width:410px;height: 515px; position: absolute; top: 433.5px; z-index: 9999; opacity: 0; display: none;">
    <span class="button b-close"><span>X</span></span>
    <p class="head"><%=SystemEnv.getHtmlLabelName(126097,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2121,user.getLanguage())%></p>

    <div class="asdetailcontainer" style="height: 400px;width: 100%; overflow:auto;">
			        <table class='result detailquestion'>
					        <thead>
		                        <th class="first"><%=SystemEnv.getHtmlLabelName(1025,user.getLanguage())%></th>
		                        <th><%=SystemEnv.getHtmlLabelName(127895,user.getLanguage())%></th>
		                        <th><%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%></th>
		                        <th><%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%></th>
		                    </thead>
		                    <tbody>
		                    </tbody>
					</table>
    </div>
</div>


<div class="votingpersondata">
        <table class="result">
			 <thead>
				<TH>
					<div align="left"><%=SystemEnv.getHtmlLabelName(21727, user.getLanguage())%></div>
				</TH>
			</thead>
			 <TR>
				<td style="text-align: left;color: #38a0e5">
				<span id=validityMoreSpan2>
				<%
				int k1=0;
				if(null!=votingperson && votingperson.size()>0&&k1<=200)
				{
					for(Iterator i = votingperson.iterator();i.hasNext();)
					{
						String tpname = (String)i.next();
						k1++;
					
				%>
		        <%=tpname%>&nbsp;&nbsp;
		        <%
		        	}
				}
				%>
				</span>
				</td>
			 </TR>
			  <%if(votingperson.size()>200){%>
			 <TR>
				<td style="text-align: center;color: #38a0e5" >
				<a href="#" style="cursor:hand;" onclick="showMoreDoPerson();"><font color=black style=" font-weight:bold" >加载更多</font></a>
				</td>
			 </TR>
			 <%}%>
			 <thead>
				<TH >
					<div align="left"><%=SystemEnv.getHtmlLabelName(21728, user.getLanguage())%></div>
				</TH>
			 </thead>
			 <TR>
				<td style="text-align: left">
				<span id=validityMoreSpan>
				<%
                int k2=0;
				int morudo=novotingperson.size();
				if(null!=novotingperson&&novotingperson.size()>0&&k2<=200)
				{
					for(Iterator i = novotingperson.iterator();i.hasNext();)
					{
						String tpnoname = (String)i.next();
						tpnoname=ResourceComInfo.getResourcename(tpnoname);
						k2++;
				%>
		        <%=tpnoname%>&nbsp;&nbsp;
		        <%
					}
		        }%>
				</span>
				</td>
			 </TR>
			 <%if(novotingperson.size()>200){%>
			  <TR>
				<td style="text-align: center;color: #38a0e5" >
				<a href="#" style="cursor:hand;" onclick="showMoreUnDoPerson();"><font color=black style=" font-weight:bold" >加载更多</font></a>
				</td>
			 </TR>
			 <%}%>
		</table>
    </div>

</FORM>
</div>

<script src="/voting/surveydesign/js/jquery-ui_wev8.js"></script>
<script src="/voting/surveydesign/js/surveyresult_wev8.js"></script> 
<script src="/voting/surveydesign/js/jquery.bpopup.min_wev8.js"></script>
<script>
    jQuery(document).ready(function(){
           var pageitems=<%=pageitems%>;
		   var votersitems=<%=votersitems%>;
		   var subcompanyid=<%=subcomidsobj%>;
		   var subnames=<%=subnamesitems%>;
		   var optionvoteritems=<%=optionvoteritems%>;
		   surveyresult.setOpters(optionvoteritems);
           $("#div_excel_content").css("height",($(window).height()-10)+'px');
		   for(var i=0;i<votersitems.length;i++){
		       surveyresult.addQuestionsContainer(subcompanyid[i],subnames[i]);
			   surveyresult.generatorAllQuestion(pageitems);
		       surveyresult.generatorAllQuesitonRs(votersitems[i]);   
		   }
		    surveyresult.registerQestionDetail();
});
		 
var dialog = null;

function doReminders(votingid){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(17599, user.getLanguage()) %>";
    dialog.URL = "/voting/VotingReminders.jsp?votingid="+votingid;
	dialog.Width = 560;
	dialog.Height = 320;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
	
}

function showMoreDoPerson(){
	
	
    var currentnum=parseInt(jQuery("#currentdnum").val());
	jQuery("#currentdnum").val(currentnum+200);
	currentnum=currentnum+200;
	jQuery.post("getMoreUnDoPerson.jsp",{"votingid":"<%=votingid%>","currentnum":currentnum,"opeation":"1"},function(data){
		if(data){
			//alert(data);
			var html = jQuery("#validityMoreSpan2").html(); 
			jQuery("#validityMoreSpan2").html(html+" "+data);
			 
		}else{
		
		   // jQuery("#validityMoreSpan").html("");
		}
			
		});		


}
function showMoreUnDoPerson(){
	
	
    var currentnum=parseInt(jQuery("#currentudnum").val());
	jQuery("#currentudnum").val(currentnum+200);
	currentnum=currentnum+200;
	jQuery.post("getMoreUnDoPerson.jsp",{"votingid":"<%=votingid%>","currentnum":currentnum,"opeation":"2"},function(data){
		if(data){
			//alert(data);
			var html = jQuery("#validityMoreSpan").html(); 
			jQuery("#validityMoreSpan").html(html+" "+data);
			 
		}else{
		
		   // jQuery("#validityMoreSpan").html("");
		}
			
		});		


}

function downloadExcel(){
	location.href="/voting/ObtainExcelData.jsp?votingid=<%=votingid%>"
}

function MainCallback(){
	dialog.close();
}

function goback(){
  window.open('/voting/VotingList.jsp?viewResult=<%=viewResult%>','mainFrame','') ;
}

function save_excel(){
	weaver.txt_excel_content.value = document.getElementById("div_excel_content").innerHTML.replace("border=0","border=1");
	 document.weaver.action = "save_excel.jsp";
    document.weaver.submit();
}
</script>
</BODY></HTML>
