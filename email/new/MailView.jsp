<%@page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.email.service.MailResourceFileService"%>
<%@page import="java.io.*" %>
<%@page import="weaver.email.domain.*" %>
<%@page import="weaver.email.WeavermailComInfo"%>
<%@page import="weaver.general.*" %>
<%@page import="java.util.*" %>
<%@page import="weaver.hrm.*" %>
<%@page import="weaver.systeminfo.*" %>
<%@page import="weaver.hrm.settings.RemindSettings" %>
<%@page import="weaver.docs.category.security.AclManager" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.general.AttachFileUtil"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.email.service.MailManagerService"%>
<%@page import="weaver.email.service.MailFilePreviewService"%>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" />
<jsp:useBean id="mrfs" class="weaver.email.service.MailResourceFileService" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" />
<jsp:useBean id="rs0" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeavermailUtil" class="weaver.email.WeavermailUtil" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	String userid=""+user.getUID();
	int mailid = Util.getIntValue(request.getParameter("mailid"),-1);
    int folderid = Util.getIntValue(request.getParameter("folderid"),Integer.MIN_VALUE);
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),0);
	int star = Util.getIntValue(request.getParameter("star"),0);
	String isPrint = Util.null2String(request.getParameter("isPrint"));
	String fromable = Util.null2String(request.getParameter("fromable"));
	String loadjquery= Util.null2String(request.getParameter("loadjquery"));
    
	String recallState = "";
    
	if(mailid < 0) {
%>
    <body style="margin: 0px;padding: 0px;overflow: auto;">
        <div class="h-60">&nbsp;</div>
        <div class="w-all h-all">
            <div class="text-center font12"><%=SystemEnv.getHtmlLabelName(83118,user.getLanguage())%></div>
        </div>
    </body>
<%
        return;
    }
    
	// 读取邮件，并加载到缓存中
	mrs.setId(mailid+"");
	mrs.selectMailResource();
	WeavermailComInfo wmc = new WeavermailComInfo();
	int isInternalT = 0;
	if(mrs.next()){
	    
        //判断是否有权限查看邮件（当前用户是否是resourceids中一员）
		String resourceids=","+MailManagerService.getAllResourceids(""+userid)+",";
		if(!resourceids.contains(","+mrs.getResourceid()+",")){ 
			//response.sendRedirect("/notice/noright.jsp"); // 此种方法跳转报错
		    out.println("<script>window.window.location.href=\"/notice/noright.jsp\";</script>");
			return;
            
		}else{
            wmc.setPriority(mrs.getPrioority()) ;
            wmc.setRealeSendfrom(mrs.getSendfrom()) ;
            wmc.setRealeCC(mrs.getSendcc()) ;
            wmc.setRealeTO(mrs.getSendto()) ;
            wmc.setRealeBCC(mrs.getSendbcc()) ;
            wmc.setSendDate(mrs.getSenddate()) ;
            wmc.setSubject(mrs.getSubject()) ;
            wmc.setContent(mrs.getContent());
            wmc.setBccids(mrs.getBccids());
            wmc.setBccall(mrs.getBccall());
            wmc.setBccdpids(mrs.getBccdpids());
            wmc.setCcids(mrs.getCcids());
            wmc.setCcall(mrs.getCcall());
            wmc.setCcdpids(mrs.getCcdpids());
            wmc.setTodpids(mrs.getTodpids());
            wmc.setToids(mrs.getToids());
            wmc.setToall(mrs.getToall());
            wmc.setSendfrom(mrs.getSendfrom());
            isInternalT = mrs.getIsInternal();
            recallState = mrs.getRecallState();
            wmc.setContenttype(mrs.getMailtype());
            wmc.setReceiveNeedReceipt(mrs.getReceiveNeedReceipt());
            if(("1").equals(mrs.getHashtmlimage())){
                wmc.setHtmlimage(true);
            }else{
                wmc.setHtmlimage(false);
            }
        }
    }
	
	//更新内部邮件: 邮件读取时间
	mrs.updateMailResourceReaddate(String.valueOf(mailid));
	
	//删除邮件提醒信息
	mrs.removeMailRemindInfo(mailid,user.getUID());
	//布局信息
	mss.selectMailSetting(user.getUID());
	int layout = Util.getIntValue(mss.getLayout(), 3);
	
	SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
	
	SimpleDateFormat dateFormatlanguage = dateFormat2;
	if(user.getLanguage() == 8) {
		dateFormatlanguage = dateFormat1;
	}
	
	// 标记邮件为已读
	mrs.updateMailResourceStatus("1",mailid+"",user.getUID());
	
    /*
	//EML
	String _emlPath = Util.null2String(mrs.getEmlpath());
	String emlName = Util.null2String(mrs.getEmlname());
	String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;
	File eml = new File(emlPath + emlName + ".eml");
	if(!_emlPath.equals("")) eml = new File(_emlPath);
    */
	
	mrfs.selectMailResourceFileInfos(mailid+"","1");
	ArrayList filenames = new ArrayList() ;
	ArrayList filenums  = new ArrayList() ;
	ArrayList filenameencodes  = new ArrayList() ;
	int fileNum=0;
	
	int isEml = 0;
	rs.execute("select isEml from MailConfigureInfo");
	while(rs.next()){
		isEml = rs.getInt("isEml");
	}
	
	String showmode = "0";
	RecordSet rs2 = new RecordSet();
	rs2.executeSql("SELECT showmode FROM MailSetting WHERE userId="+user.getUID());
    if(rs2.next()) {
        showmode = Util.null2s(rs2.getString("showmode"), "0");
    }
	
	if("1".equals(loadjquery)){
%>	
	<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<%	
	}
%>
	<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect_wev8.css" />
    
    <script type="text/javascript"> 
        var languageid = '<%=user.getLanguage()%>';
    </script>
	<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect_wev8.js"></script>
	<script type="text/javascript" src="/email/js/leanModal/jquery.leanModal.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/js/init_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
	<script type="text/javascript" src="/email/js/waitdeal/jquery.qtip-1.0.0-rc3.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/email/js/tzSelect/jquery.tzSelect_wev8.css" /> 
	<script type="text/javascript" src="/email/js/tzSelect/jquery.tzSelect_wev8.js"></script>
    <style>
        * { font-family:"Microsoft YaHei"!important; }
        BUTTON.showallresource{
        	BORDER-RIGHT: medium none; 
        	BORDER-TOP: medium none; 
        	*PADDING-LEFT: 8px; 
        	FONT-SIZE: 8pt; BACKGROUND-IMAGE: url(/images/showallresource_wev8.gif);
        	PADDING-BOTTOM: 2px; MARGIN: 2px 0px 1px 2px; OVERFLOW: hidden; 
        	BORDER-LEFT: medium none; WIDTH: 70px; CURSOR: pointer; 
        	COLOR: #000000; PADDING-TOP: 1px; 
        	BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; 
        	FONT-FAMILY: Verdana; HEIGHT: 20px; 
        	BACKGROUND-COLOR: transparent; 
        	TEXT-ALIGN: center;
        }
        .clear{height:auto}
    </style>
    <script type="text/javascript">
        function setContentHeight(winheight) {
        	if(winheight < 250) {
        		winheight = 250;
        	}
        	$('#mailContent').height(winheight+60);
        }
    </script>
    
<body style="margin: 0px;padding: 0px;  overflow: auto;">
<form id="test">
<div class="w-all">
	<div id="MailViewMain">
	
	<div id="inBoxTitle" class="h-30 colorbgfff p-l-5 <%=layout==3?"p-t-2":"p-t-10"%>" style="display:<%=isPrint.equals("1")?"none":""%>">
		<div class="left mailviewtoolbar">
			
		<%
			 ArrayList lmsList = null;
			 ArrayList folderList = null;
			%>
			<%if(mrs.getFolderid().equals("-1")){%>
			<button class=" btnGray1 left" style="margin-left:0px;margin-right:0px;border-right:0px;" type="button" id="editBtn"><%=SystemEnv.getHtmlLabelName(83120, user.getLanguage())%></button>
			<%}%>
			<%if(Util.getIntValue(mrs.getFolderid()) >= 0){%>
				<button class=" btnGray1 left" style="margin-left:0px;margin-right:0px;border-right:0px;" type="button" id="replayBtn"><%=SystemEnv.getHtmlLabelName(117, user.getLanguage())%></button>
				<button class=" btnGray1 left" style="margin-left:0px;margin-right:0px;border-right:0px;" type="button" id="replayAllBtn"><%=SystemEnv.getHtmlLabelName(2053, user.getLanguage())%></button>
			<%}%>
			<%if(Util.getIntValue(mrs.getFolderid()) >= -1){%>
				<button class=" btnGray1 left" style="margin-left:0px;" type="button" id="forwardBtn"><%=SystemEnv.getHtmlLabelName(6011, user.getLanguage())%></button>
			<%}%>
		<%if(1 == isInternalT && wmc.getSendfrom().equals(user.getUID()+"") && !"1".equals(recallState)){%>
			<button class=" btnGray1 left m-l-5" type="button" id="recallBtn"><%=SystemEnv.getHtmlLabelName(32025, user.getLanguage())%></button>
		<%}%>
		<%if(1 == isInternalT && wmc.getSendfrom().equals(user.getUID()+"") && "1".equals(recallState)){%>
			<button class=" btnGray1 left m-l-5" disabled="disabled"  type="button"><%=SystemEnv.getHtmlLabelName(32412, user.getLanguage())%></button>
		<%}%>
			<%
			  if(layout==3){
				  %>
			<div class="left m-l-5">	  
			<%if(folderid != -3) {%>
			<button class=" btnGray1 left" type="button" id="delBtn" style="margin-left:0px;margin-right:0px;border-right:0px;"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></button>
			<%}%>
			<button class=" btnGray1 left" type="button" id="dropBtn" style="margin-left:0px;"><%=SystemEnv.getHtmlLabelName(2031, user.getLanguage())%></button>
			</div>
			<div class="left m-l-5">
			<div class="btnGrayDrop relative left " id="saveAs02" style="width: 80px;margin-left:0px;margin-right:0px;border-right:0px;" _xuhao=1><%=SystemEnv.getHtmlLabelName(81292,user.getLanguage()) %>...
				<ul class="btnGrayDropContent hide" style="width: 100px;position: absolute;" >
					<li class="item" onclick="doExportDocs02(event)"><%=SystemEnv.getHtmlLabelName(19821,user.getLanguage()) %></li>
					<li class="item" onclick="doExportContacts02(event)"><%=SystemEnv.getHtmlLabelName(19822,user.getLanguage()) %></li>
					<%if(isEml == 1) {%>
						<li class="item" onclick="doExportEML(event)"><%=SystemEnv.getHtmlLabelName(25986,user.getLanguage()) %></li>
					<% }%>
				</ul>
			</div>
            
            <div style="display:none;">
                <!-- 文档目录选择对话框 -->
                <brow:browser viewType="0" name="seccategory" browserValue="" idKey="id" nameKey="path" language='<%=""+user.getLanguage() %>'
                    _callback="cbDoExportDocs02" temptitle='<%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%>'
                    browserUrl='<%="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/category/MultiCategorySingleBrowser.jsp?operationcode="+AclManager.OPERATION_CREATEDOC %>'
                     isSingle="true" hasBrowser = "true" isMustInput='2'
                    browserBtnID="selectTaohongMouldBtn02"
                    linkUrl="#" width="30%">
                </brow:browser>
            </div>
            
			<!-- 标记为--start -->
			<div class="btnGrayDrop relative left " id="signAs02" style="width: 100px;margin-left:0px;margin-right:0px;border-right:0px;"><%=SystemEnv.getHtmlLabelName(81293 ,user.getLanguage()) %>...
			<ul class="btnGrayDropContent hide" style="width: 100px;position: absolute;" >
				<li  onclick="waitDeal('<%=mailid %>')">
					<div style="background:url('/email/images/mail_wait_deal_wev8.png') no-repeat;padding-left:18px;"><%=SystemEnv.getHtmlLabelName(83090 ,user.getLanguage()) %></div>
				</li>
				<%
				   lmsList= lms.getLabelManagerList(user.getUID());
					for(int i=0; i<lmsList.size();i++){
						MailLabel ml = (MailLabel)lmsList.get(i);
						%>
						<li class="markLabel item" target="<%=ml.getId()%>" ><div class="m-r-5 left " style="line-height:8px;margin-top:8px;border-radius:2px; height:8px;width:8px; background:<%=ml.getColor()%>;">&nbsp;</div><%=Util.getMoreStr(ml.getName(),5,"...") %></li>
						<%
					}
				%>
				<%if(lmsList.size()>0){
					%>
					<li style="height: 10px ;margin-bottom: -5px;margin-top: -4px"><div class="line-1 m-t-5"  style="overflow: hidden;"></div></li>
					<%
				} %>
				<!-- 取消所有标签--start -->
				<li class="item"  onclick="cancelLabel2(this)"><%=SystemEnv.getHtmlLabelName(31219 ,user.getLanguage()) %></li>
				<!-- 取消所有标签--end -->
				<!-- 新建并标记--start -->
				<li class="newitem"   onclick="createLabel2(1)">+<%=SystemEnv.getHtmlLabelName(31220 ,user.getLanguage()) %></li>
				<!-- 新建并标记--end -->
			</ul>
			</div>
			<!-- 标记为--end -->
			
			<!-- 移动到...start -->
			<div class="btnGrayDrop relative left " id="moveTo02" style="width: 100px;margin-left:0px;"><%=SystemEnv.getHtmlLabelName(81298 ,user.getLanguage()) %>...
				<ul class="btnGrayDropContent hide" style="width: 100px;position: absolute;" >
					<%
						folderList= fms.getFolderManagerList(user.getUID());
						for(int i=0; i<folderList.size();i++){
							MailFolder mf = (MailFolder)folderList.get(i);
							%>
							<li class="item" target="<%=mf.getId()%>"><%=Util.getMoreStr(mf.getFolderName(), 5, "...") %></li>
							<%
						}
						
					%>
					<%if(folderList.size()>0){
						%>
						<li style="height: 10px;margin-bottom: -5px;margin-top: -4px"><div class="line-1 m-t-5" style="overflow: hidden;"></div></li>
						<%
					} %>
					<!-- 新建并移动--start -->
					<li class="newitem"  onclick="createLabel2(2)">+<%=SystemEnv.getHtmlLabelName(31221 ,user.getLanguage()) %></li>
					<!-- 新建并移动--end -->
				</ul>
			</div>
			<!-- 移动到...end -->
			</div>
			<%} %>
		</div>
		<button class=" btnGray1 left m-l-5" type="button" id="printBtn" onclick="openSignPrint()"><%=SystemEnv.getHtmlLabelName(83121 ,user.getLanguage()) %></button>
		<div class="clear"></div>
	</div>
	
	<!--startprint-->
	<div class="" style="float: left;width: 100%">
		<div id="mailTitle" class="mailTitle p-t-5 p-l-15 p-b-5">
			<div id="subject">
				<div class="font14 bold p-r-5 left" title="<%=getSubject(mrs.getSubject(),user) %>"><%=Util.getMoreStr(getSubject(mrs.getSubject(),user), 100, "...")%></div>
				<%if(mrs.getStarred().equals("1")){ %>
					<div class=" fg2 fs2 left m-t-3 hand"  id="StarTarget"></div>
				<%}else{ %>
					<div class=" fg2 left m-t-3 hand"    id="StarTarget"></div>
				<%} %>
				<%if(mrs.getWaitdeal() == 1){
					String waitdealdiv = "<div class='nameInfo' id ='nameInfo"+mrs.getId()+"' title='"+SystemEnv.getHtmlLabelName(83115 ,user.getLanguage())+"' rel='/email/new/MailWaitDealWin.jsp?taget=mailview&mailId="+mrs.getId()+"&waitdealtime="+mrs.getWaitdealtime()+"&waitdealway="+mrs.getWaitdealway()+"&waitdealnote="+mrs.getWaitdealnote()+"&wdremindtime="+mrs.getWdremindtime()+"' style='padding-left:12px; ' ><img src='/email/images/mail_wait_deal_wev8.png'     /></div>";
				%>
				<div  class='left m-t-2 hand '>
					<%=waitdealdiv %>
				</div>
				<%}else{%>
				<div  class='left m-t-2 hand '>
					<div id ='waitdeal_set' title='<%=SystemEnv.getHtmlLabelName(83115,user.getLanguage())%>' onclick='showWaitDeal(<%=mailid%>)' style='padding-left:12px;' ><img src='/email/images/mail_set_waitdeal_wev8.png'  /></div>
				</div>
				<%}%>
				<%
				ArrayList mailLabels = lms.getMailLabels(mailid);
				String str ="";
				for(int i=0;i<mailLabels.size();i++){
					MailLabel ml = (MailLabel)mailLabels.get(i);
						str+="<div class='label hand left' style='  background:"+ml.getColor()+"'>"
						+	"<div class='left lbName'>"+ml.getName()+"</div>"
						+     "<input type='hidden' name='lableId' value='"+ml.getId()+"' />"
						+     "<input type='hidden' name='mailId' value='"+mailid+"' />"
						+	"<div class='left closeLb hand hide ' title='"+SystemEnv.getHtmlLabelName(81338,user.getLanguage())+"'></div>"
						+ "<div class='cleaer'></div>"	
						+"</div>";	
				}
				out.println(str);
				%>
				
				<div class='right' style="margin-right:5px;">
					<div onclick='showMailInfo(this)' id="showMailInfobtn" _status='<%=showmode %>' style='cursor:pointer;background: url("/email/images/icon_d_wev8.png") no-repeat center right;padding-right:10px;'>
					<%=SystemEnv.getHtmlLabelName(83122 ,user.getLanguage()) %>
					</div>
				</div>
				
				<%
				if(mrs.getResourceid().equals(mrs.getSendfrom())&&"-1".equals(mrs.getFolderid())){//发件人本人
				%>
				<div class='left' style="margin-left:8px;">
					<a href='javascript:showMailReadInfo()' style='cursor:pointer;color:#8fa7b3;' title="<%=SystemEnv.getHtmlLabelName(31970, user.getLanguage())%>">
					&nbsp;<img width=16 align='absMiddle' src='/email/images/mail-open-document-text_wev8.png' complete='complete'/>
					</a>
				</div>	
				<%}%>
				<div class="clear"></div>
			</div>
			
			<div id="simpleinfo" style="margin-top:8px;margin-bottom:8px;">
				<%
				String realName= "";
				String toName = "";
				
				String sendFrom="";
				String sendTo="";
				if(mrs.getIsInternal()==1){
					sendFrom=SptmForMail.getHrmShowNameHref(mrs.getSendfrom());
				}else{
					sendFrom=SptmForMail.getNameByEmail(mrs.getSendfrom(),userid);
				} 
				
				if(mrs.getIsInternal()==1){
					sendTo=SptmForMail.getHrmShowNameHrefTOP(mrs,10,1,false);
				}else{
					sendTo=SptmForMail.getNameByEmailTOP(mrs.getSendto(),userid,"");
				}
				
				%>
				<span style="font-weight:bold;color:#000"><%=sendFrom%></span>&nbsp;<%=SystemEnv.getHtmlLabelName(82894, user.getLanguage())%>&nbsp;<%=dateFormatlanguage.format(dateFormat1.parse(mrs.getSenddate()))%>&nbsp;<%=SystemEnv.getHtmlLabelName(83123, user.getLanguage())%>&nbsp;<span style="word-break:break-all"><%=sendTo %></span>
				<%if(mrfs.getCount()>0){%>
					<span style="margin-left:20px;color:#0284fe;cursor:pointer;" onclick="toAttachment()"><%=SystemEnv.getHtmlLabelName(367, user.getLanguage())%><%=mrfs.getCount()%><%=SystemEnv.getHtmlLabelName(83077, user.getLanguage())%></span>
				<%}%>
			</div>
			
			<div id="moreinfo" style="display:none;">
			<div id="from" class="m-t-5">
				<div class="addrtitle p-r-5 left""><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())%>:</div>
				<div class="color000 p-r-5 w-d left"> 
				
				<%
				
				if(mrs.getIsInternal()==1){
					out.print(SptmForMail.getHrmShowNameHref(mrs.getSendfrom()) );
				}else{
					out.print(SptmForMail.getNameByEmail(mrs.getSendfrom(),userid) );
				}
				
				//out.print(SptmForMail.getContactCard(mrs.getSendfrom(),userid,mrs.getIsInternal()));
				%>   
				</div>
				<%
				if(mrs.getIsInternal()!=1){
				int id = cms.getIdByMailAddress(mrs.getSendfrom(), user.getUID());
				if(id == -1){
				%>
				<div class="left ico_profileTips m-t-2" title="<%=SystemEnv.getHtmlLabelName(19956, user.getLanguage())%>" onclick="loadContactAdd(this,'<%=mrs.getSendfrom() %>')">
				</div>
				<%} else {%>
				<div class="left ico_profileTips m-t-2" title="<%=SystemEnv.getHtmlLabelName(81335, user.getLanguage())%>" onclick="loadContact(<%=id %>, this)">
				</div>
				<%}
				}%>
				
				<div class="addrtitle left m-l-30" style=""><%=SystemEnv.getHtmlLabelName(19736, user.getLanguage())%>:</div>
				<div class="color000 p-r-5 w-d left"> <%=mrs.getSenddate() %> </div>
				
				<div class="clear"></div>
			</div>
		
		
			<%
				String receiverHtml=""; 
				if(mrs.getIsInternal()==1){
					receiverHtml=SptmForMail.getHrmShowNameHrefTOP(mrs,10,1,false);
				}else{
					receiverHtml=SptmForMail.getNameByEmailTOP(mrs.getSendto(),userid,"");
				}
				if(!receiverHtml.equals("")){
			%>
				<!--收件人--start  -->
				<div id="to" class="m-t-5">
					<div class="addrtitle p-r-5 left"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%>:</div>
					<div class="color000 p-r-5  w-d" id="to_showpart" >
							<%=receiverHtml%>  
							<div class="clear"></div>
					</div>
					<div class="color000 p-r-5  w-d"   id="to_showall" ></div>
					<div class="clear"></div>
				</div>
				<!--收件人--end  -->
			<%}%>
			
			<%
			 boolean ccflag=false;
			 if(mrs.getIsInternal()==1){
				if("1".equals(mrs.getCcall())){
					ccflag=true;
				}else if(!"".equals(mrs.getCcdpids())){
					ccflag=true;
				}else if(!"".equals(mrs.getCcids())){
					ccflag=true;
				}		
			 }
				if(!mrs.getSendcc().trim().equals("")||ccflag){
					%>
				<div id="bcc" class="m-t-5">
					<div class="addrtitle p-r-5 left"><%=SystemEnv.getHtmlLabelName(17051, user.getLanguage())%>:</div>
					<div class="color000 p-r-5  w-d"   id="">
					<%
							if(mrs.getIsInternal()==1){
								//out.print(SptmForMail.getHrmShowNameHref(mrs.getSendto()));
								out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,2,false));
							}else{
								out.print(SptmForMail.getNameByEmailTOP(mrs.getSendcc(),userid,""));
							}
				%>
						<div class="clear"></div>
					</div>
					<div class="color000 p-r-5  w-d"   id="to_showall" ></div>
					<div class="clear"></div>
				</div>
				<%		
				}
			%>
			
			
			<%
				 boolean bccflag=false;
				 if(mrs.getIsInternal()==1){
					if("1".equals(mrs.getBccall())){
						bccflag=true;
					}else if(!"".equals(mrs.getBccdpids())){
						bccflag=true;
					}else if(!"".equals(mrs.getBccids())){
						bccflag=true;
					}		
				 }
				//密送人的判断
				//如果当前用户=改邮件的发送用户，就显示"密送人"
				boolean readBcc=false;
				//当前登陆者是否是邮件发送者
				boolean isSender = false;
				if((!mrs.getSendbcc().trim().equals("")&&mrs.getIsInternal()==1)||bccflag){
					//内部邮件------------------------------密送人处理-----------------------------------
					if(mrs.getSendfrom().equals(""+user.getUID())){
							isSender=true;
							readBcc=true;
					}
					String send_bcc=","+mrs.getSendbcc()+",";
					if(send_bcc.indexOf(","+user.getUID()+",")!=-1){
						readBcc=true;
					}else if("1".equals(mrs.getBccall())){
						//密送给所有人
						readBcc=true;
					}else if(!"".equals(mrs.getBccids())&&(","+mrs.getBccids()+",").indexOf(","+user.getUID()+",")!=-1){
						//密送给某些人,并且包含当前用户
						readBcc=true;
					}else if(!"".equals(mrs.getBccdpids())){
						//密送给某个部门,并且包含当前用户
						rs0.execute("select id from HrmResource where departmentid in("+mrs.getBccdpids()+") and id='"+user.getUID()+"'");
						if(rs0.next()){
							readBcc=true;
						}
					}	
					if(readBcc){
					%>
				<div id="bcc" class="m-t-5">
					<div class="addrtitle p-r-5 left"  <% if(!isSender)out.print("style='color: red'"); %>><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%>:</div>
					<div class="p-r-5  w-d"   id="">
					<%
							if(isSender) {
								if(mrs.getIsInternal()==1){
									out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,3,false));
								}else{
									out.print(SptmForMail.getNameByEmailTOP(mrs.getSendbcc(),userid,""));
								}
									
							}else {
								out.print("<div style='color: red'>"+SystemEnv.getHtmlLabelName(81749, user.getLanguage())+"</div>");
							}
					%>
					<div class="clear"></div>
					</div>
					<div class="color000 p-r-5  w-d"   id="to_showall" ></div>
					<div class="clear"></div>
				</div>
				<%		
					}
				}else if(!mrs.getSendbcc().trim().equals("")&&mrs.getIsInternal()!=1){
					//外部邮件------------------------------密送人处理-----------------------------------
					//得到当前用户的所有邮箱账号
					rs0.execute("SELECT accountMailAddress FROM MailAccount WHERE userId='"+user.getUID()+"'");
				
					while(rs0.next()){
						//判断该邮件是不是我发出的邮件
						if((mrs.getSendfrom().toLowerCase()).equals(rs0.getString("accountMailAddress").toLowerCase())){
								 readBcc=true;
								 break;
						}
					}
					//如果是我发送的，就能看到密送人，否则不能看到密送人
					if(readBcc){
				%>
				<div id="bcc" class="m-t-5">
					<div class="addrtitle p-r-5 left"><%=SystemEnv.getHtmlLabelName(81316, user.getLanguage())%>:</div>
					<div class="p-r-5  w-d"   id="">
					<%
							if(mrs.getIsInternal()==1){
								//out.print(SptmForMail.getHrmShowNameHrefTOP(mrs.getSendbcc(),10));
								out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,10,3,false));
							}else{
								out.print(SptmForMail.getNameByEmailTOP(mrs.getSendbcc(),userid,""));
							}
					%>
					<div class="clear"></div>  
					</div>
					<div class="p-r-5  w-d"   id="to_showall" ></div>	
					<div class="clear"></div>
				</div>	
				<%
						}
					}
				%>
			
			
			<%
			if(mrfs.getCount()>0){ %>
			<div id="attachment" class="m-t-5">
				<div class="addrtitle p-r-5 left" style=""><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>:</div>
				<div class="color333 p-r-5 "> 
					<%=mrfs.getCount()%><%=SystemEnv.getHtmlLabelName(27591, user.getLanguage())%>
					<span style="margin-left:20px;color:#0284fe;cursor:pointer;" onclick="toAttachment()"><%=SystemEnv.getHtmlLabelName(83124, user.getLanguage())%></span>
				 </div>
				<div class="clear"></div>
			</div>
			<%} %>
			</div>
		</div>	
	
	</div>
	<div class="clear"></div>
	</div>
</div>

<iframe id="mailContent" class="" frameborder="0" width="100%" height="100%" style="overflow:hidden" src="MailContentView.jsp?mailid=<%=mailid%>"></iframe>
</form>

<!--endprint-->
<%
	wmc.setTotlefile(fileNum);
	wmc.setFilenames(filenames);
	wmc.setFilenums(filenums);
	wmc.setFilenameencodes(filenameencodes);
	session.setAttribute("WeavermailComInfo", wmc);
%>

<%if(mrfs.getCount()>0){%>
<div style="border-top:1px solid #dadada;border-bottom:dotted 1px #dadada;padding-top:10px;padding-bottom:10px;">
<div style="padding-left:10px;">
<img src="/email/images/icon_attach_wev8.png" align="absmiddle">&nbsp;<%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>(<%=mrfs.getCount()%><%=SystemEnv.getHtmlLabelName(27591, user.getLanguage())%>)
<span style="margin-left:20px;color:#0284fe">
	<%String batchurl = "/weaver/weaver.email.FileDownloadLocation?downtype=batch&mailId="+mailid ;%>
	<a href="<%=batchurl%>" style='cursor:pointer;color: blue;'><%=SystemEnv.getHtmlLabelName(32407, user.getLanguage())%></a>
</span>
</div>
<%
	while(mrfs.next()){ 
		int fileId = mrfs.getId();
		int fileSize=Util.getIntValue(mrfs.getFilesize(),0);
		String fileSizeName="";
		DecimalFormat df=new DecimalFormat("#.##");
		if(fileSize>(1024*1024))
			fileSizeName=df.format(fileSize/(1024.0*1024.0))+"M";
		else if(fileSize>1024)
			fileSizeName=df.format(fileSize/(1024.0))+"K";
		else
			fileSizeName=fileSize+"B";
		filenames.add(mrfs.getFilename()) ;
		filenums.add(fileId+"") ;
		filenameencodes.add("1") ;
		fileNum++ ; 
		String fileUrl = "/weaver/weaver.email.FileDownloadLocation?fileid="+fileId;
		String fileExtendName = mrfs.getFilename().substring(mrfs.getFilename().lastIndexOf(".")+1).toLowerCase();
		String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,16);
	%>
	<div style="margin-top:5px;margin-left:30px;">
		<div class="left" style="margin-top:2px;"><%=imgSrc%></div>
		<div class="left" style="margin-left:5px;margin-top:2px;width:240px;">
			<a href="javascript:downLoad(<%=fileId%>)" style="color:#000;font-weight:bold;"><%=Util.toScreen(mrfs.getFilename(), user.getLanguage())%></a>
		</div>
		<div class="left" style="margin-left:30px;">
            <button class=" btnGray1 left" type="button" style="margin-right:10px;" onclick="openfile('<%=MailFilePreviewService.getNewPreviewUrl(fileId) %>')"><%=SystemEnv.getHtmlLabelName(221, user.getLanguage())%></button>
		 	<button class=" btnGray1 left" type="button" onclick="downLoad(<%=fileId%>)"><%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%>（<%=fileSizeName%>）</button>
		</div>
		<div class="clear"></div>
	</div>
	<%}%>

</div>
<%}%>

<iframe id="downLoadFrame" style="display:none;"></iframe>

<!-- 快捷回复 -->
<div title="" style="margin-top:10px;margin-bottom:5px;display:<%=isPrint.equals("1")?"none":""%>">
	<div id="successEmail"  style="display:none;padding-left: 10px;padding-top:5px; border:1px solid #bbbbbb; height: 30px;background:url('../images/btnGray_wev8.png')">
		<span style="cursor: pointer;color: green;" ><%=SystemEnv.getHtmlLabelName(2044, user.getLanguage())%>！<%=SystemEnv.getHtmlLabelName(32431, user.getLanguage())%></span>
	</div>
	
	<div id="sendEmail" style="padding:8px;">
		<textarea style="width: 100%;border:1 solid #dadada;" class="color999 quick_normal remarkContent" id="replycontent" name="replycontent" onclick="setSize(true)"><%=SystemEnv.getHtmlLabelName(32110, user.getLanguage())%>:</textarea>
		<div style="padding-top: 5px;display:none;" id="btnDiv">
			<button class="btnGreen" type="button" onclick="fastReply()"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage())%></button> 
			<button class="btnGray" type="button" onclick="setSize(false)"><%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></button>
			<span style="text-align: right;cursor: pointer;" class="p-r-10 right" onclick="sendMail()">
				<img src="/email/images/sign_wev8.png"/><a><%=SystemEnv.getHtmlLabelName(83125, user.getLanguage())%></a>
			</span>
		</div>
	</div>
</div>

<div id="footer"></div>

<!-- 添加联系人 -->
<div id="contactAdd" class="popWindow hide "></div>

<!-- 修改联系人 -->
<div id="contactEdit" class="popWindow hide "></div>

<!-- 静态初始化一个leanModal遮罩 -->
<div id="lean_overlay"></div>

<!-- 联系人卡片 -->
<div id="contactCard" style="border:1px solid #dadada;height:100px;width:180px;display:none;position: absolute;background:#fff">
<div id="contactName" style="height:30px;padding-left:5px;font-weight:bold;line-height:30px;">fwtest</div>
<div id="contactInfo" style="height:39px;padding-left:5px;">fwtest&lt;fwtest@163.com&gt;</div>
<div style="border-top: 1px solid #dadada;background:#f9f9f9;height:30px;"></div>
	<div class="left">
		<span style="font-size:20px;">+</span>
		
	</div>
	<div class="right"></div>
	<div class="clear"></div>
</div>
	<div id='mailaddrdiv' style="text-align: left;position:absolute; background-color: #ffffff;border:1px solid #DADADA;z-index:10;display:none;">
		<div class="mailaddarrow" style="background:url('/email/images/mail_box_sharp.png'); no-repeat;position:absolute;top: -7px;left: 30px;width: 14px;height: 7px;"></div>
		<div id="mailaddrname" style="height:26px;line-height:26px;padding-left:10px;"></div>
		<div id='mailaddrspan' style="height:26px;line-height:26px;padding-left:10px;"></div>
		<div style="border-top:1px solid #dadada;height:30px;line-height: 30px;">
			<div style="float:left;height:100%;width:100px;text-align: center;border-right: 1px solid #dadada;">
				<a href="javascript:void()" id='writeletterbtn'><%=SystemEnv.getHtmlLabelName(81300, user.getLanguage())%></a>
			</div>
			<div style="float:left;height: 100%;width:100px;text-align: center;">
				<a href="javascript:void()" id='addblackbtn'><%=SystemEnv.getHtmlLabelName(124900, user.getLanguage())%></a>
			</div>
			<div style="clear:both"></div>
		</div>
	</div>
<style>
<!--
	.tzSelect{
		top:8px !important ;
		top:4px ;
		display:inline-block !important ;
		display:inline ;
		margin-left: 2px;
	}
	.popWindow{
	      width:450px;
	      height:auto;
	      box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
	      border: 2px solid #90969E;
	      background: #ffffff;
	}
	#lean_overlay {
	    position: fixed;
	    z-index:100;
	    top: 0px;
	    left: 0px;
	    height:100%;
	    width:100%;
	    background: #000;
	    display: none;
	    filter: alpha(opacity=30);
	}
	.Bdy{
		padding:0px;
	}
	.ico_profileTips {
		background: url('/email/images/mailicon_wev8.png') -64px -220px no-repeat;
		border: 0px;
		border-image: initial;
		padding: 0px;
		width: 16px;
		height: 16px;
		padding-right:1px;
		vertical-align: top;
	}
	.mailTitle{
		background: #f8f8f8;
		border-top:1px solid #DADADA;
		border-bottom:1px solid #c8e8fd;
		
	}
	.workMail{
		background: #C58D44;
		color:#ffffff;
		width: 50px;
		padding:3 15 3 15;
		height: 15px;
	}
	.ico_mailtitle {
		background: url('/email/images/mailicon_wev8.png') 1px -82px no-repeat;
		width: 26px;
		height: 16px;
	}

	div{
		font-size: 12px;
	}
	
	.selectBox{
		height: 25px!important;
		margin-left: 3px;
	}
	.remarkContent_hover{
		border: 1px solid #7FBBF2;
		border-left-width: 3px;
		border-left-color: #7FBBF2;	
	}	
	.remarkContent{
/*		background: url('/images/sign/sign_wev8.png'); */
/*		background-repeat: no-repeat;*/
/*		padding-left: 25px; */
/*		background-position-x: 3px;*/
/*		background-position-y: 5px; */
		border-left-width: 3px;
		border-left-color: #0084FF;
	}
-->
</style>

<script>

jQuery(document).ready(function(){
	
	//$("#mailContent").css("height",document.body.clientHeight-40);
	/*
	if('<%=layout%>'==3){
		$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height()-10);
	}else if('<%=layout%>'==2){
		
		$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height());
		$("#mailContent").css("width",document.body.clientWidth/2);
	}else{
		$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height());
		//$("#mailContent").css("width",document.body.clientWidth);
	}
	*/
	
	$('#replycontent').hover(
		function(){
			  $(this).addClass("remarkContent_hover")
			  $(this).removeClass("remarkContent")
		},function(){
			  $(this).removeClass("remarkContent_hover")
			  $(this).addClass("remarkContent")
		}
	)
	
	mailViewInit();
	initwaitdeal();
	//zzl-更新tab页的标题
	if('<%=layout%>'==3){
		var subject="<%=getSubject(mrs.getSubject(),user)%>";
		$(window.parent.document).find(".active > .title").html(subject).attr("title",subject);
	}
	
	$(document).bind("click",function(){
			$(".btnGrayDropContent").hide();
	})
	
	if($('#mailContentdiv img').length>0){
		$('#mailContentdiv img').load(function(){
	     	initHeight();
		})
	}else
		initHeight();
		if("<%=isPrint%>"=="1"){
		setTimeout(function(){
			window.print();
		},500);
		}
		
	showMailInfo($("#showMailInfobtn"));
});


function initHeight(){
	/*
	var contentDivHeight=$("#mailContentdiv").height();
	if(contentDivHeight<300)
		$("#mailContentdiv").height(300);*/
		
//  var winheight = document.body.clientHeight-340;
 // $('#mailContent').height(winheight);
			
}

/**************start*****************MailContactAdd.jsp页面依赖代码******************************************/

//修改联系人
function editContacter() {
	//checkInput方法在contacts.jsp页面
	if(checkInput("contactEdit")) {
		var param = $("div#contactEdit #fMailContacter").serializeArray();
		$.post("/email/new/ContactManageOperation.jsp", param, function(){
			$("#addContact").close_modal("div#contactEdit");
		});
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30935, user.getLanguage())%>！");
	}
}

var dlg;
//在其子页面中，调用此方法打开相应的界面
function openDialog(title,url,height) {
			dlg=new window.top.Dialog();//定义Dialog对象
			dlg.currentWindow = window;
			dlg.Width=500;//定义长度
			dlg.Height=height?height:400;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
				
}

function closeWin(){
	dlg.close();
	location.reload();
}

function closeDialog() {
		dlg.close();
}

//载入指定的联系人
function loadContact(id, himself) {
	openDialog("<%=SystemEnv.getHtmlLabelName(31229, user.getLanguage())%>","/email/new/MailContacterAdd.jsp?id="+id,520);
}

//载入添加联系人页面
function loadContactAdd(himself ,sendfrom) {
	openDialog("<%=SystemEnv.getHtmlLabelName(19956, user.getLanguage())%>","/email/new/MailContacterAdd.jsp?sendFrom="+sendfrom,520);
}
/**************end*****************MailContactAdd.jsp页面依赖代码******************************************/

//导出文档
function doExportDocs02(event){
    stopEvent();
	var mainid;
	var subid;
	var secid;
	var mailids = <%=mailid%>;
	$("#saveAs02").find(".btnGrayDropContent").hide();
	
	if(mailids!=""){
		if(<%=Util.getIntValue(mss.getMainid(),-1)%><1 && <%=Util.getIntValue(mss.getSubid(),-1)%><1 && <%=Util.getIntValue(mss.getSecid(),-1)%><1){
	        $("#selectTaohongMouldBtn02").trigger("click");
		}else{
			mainid = '<%=Util.getIntValue(mss.getMainid(),-1)%>';
			subid = '<%=Util.getIntValue(mss.getSubid(),-1)%>';
			secid = '<%=Util.getIntValue(mss.getSecid(),-1)%>';
            if(secid=="" || secid==0 || mainid=="" || subid==""){
                return;
            }
            var param = {mailIds:mailids,operation:'exportDocs',mainId:mainid,subId:subid,secId:secid};
            $.post("/email/MailOperation.jsp",param,function(){
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
            });
		}		
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}
}

// 执行导出为文档
function cbDoExportDocs02(event, datas) {
    if(datas){
        var secid = datas.id;
        var mainid = datas.mainid;
        var subid = datas.subid;
        if(secid=="" || secid==0 || mainid=="" || subid==""){
            return;
        }
        var mailids = <%=mailid%>;
        var param = {mailIds:mailids,operation:'exportDocs',mainId:mainid,subId:subid,secId:secid};
        $.post("/email/MailOperation.jsp",param,function(){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
        })
    }
}

//导出客户联系
function doExportContacts02(event){
	
	var mailids = <%=mailid%>;
	$("#saveAs02").find(".btnGrayDropContent").hide();
	if(mailids!=""){
		
		crmIds = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
		if(crmIds){
			try{
				if(crmIds.id!=""){
					var temp = crmIds.id;
					//$("formMailList").crmIds.value =crmIds.id;
					//alert($("formMailList").crmIds.value);
					//$("formMailList").operation.value = "exportContacts";
					//$("formMailList").submit();
					var param = {mailIds:mailids,operation:'exportContacts',crmIds:temp}
					$.post("/email/MailOperation.jsp",param,function(){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
					})
					//hideRightClickMenu();
					//showMsgBox($("actionMsgBox"), "<img src='/images/loading2_wev8.gif'> <%=SystemEnv.getHtmlLabelName(19949,user.getLanguage())%>...");
				}
			}catch(e){
				//TODO
				window.top.Dialog.alert("error");
			}
		}
   }else{
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!")
   }
	stopEvent();
}

//导出为EML
function doExportEML(event){
	var mailids = '<%=mailid%>';
	$("#saveAs02").find(".btnGrayDropContent").hide();
	stopEvent();
	
    jQuery.post("/email/new/MailManageOperation.jsp",{'mailIds': mailids, 'operation':'checkEml'},function(isexist){
		isexist = jQuery.trim(isexist);
    		if(isexist == 'false') {
    			window.top.Dialog.alert("EML<%=SystemEnv.getHtmlLabelName(20041,user.getLanguage()) %>");	
    			return;
    		} else {
                if(mailids.indexOf(',') > 0) {
                    $("#downLoadFrame").attr("src","/weaver/weaver.email.FileDownloadLocation?downtype=batch&downfiletype=eml&mailId="+mailids);
                } else {
                    $("#downLoadFrame").attr("src","/weaver/weaver.email.FileDownloadLocation?download=1&downfiletype=eml&mailId="+mailids);
                }
            }
	});
}

function mailViewInit(){
	//绑定导出为按钮事件
	$("#saveAs02").bind("click",function(event){
		 var x=$(this).offset().left
		 var y=$(this).offset().top
		 //alert($(this).offset().left);
		 //$("#saveAs02").find(".btnGrayDropContent").css("top",y+25);
		 //$("#saveAs02").find(".btnGrayDropContent").css("left",x);
		 
		$(".btnGrayDropContent").hide();
		$("#saveAs02").find(".btnGrayDropContent").show();
		
		stopEvent();
	})
	
	$("#signAs02").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		 var x=$(this).offset().left;
		 var y=$(this).offset().top;
		 //alert($(this).offset().left);
		// $("#signAs02").find(".btnGrayDropContent").css("top",y+25);
		// $("#signAs02").find(".btnGrayDropContent").css("left",x);
		$("#signAs02").find(".btnGrayDropContent").show(); 
		stopEvent();
	}).find(".item").bind("click", function(event){
			var mails = '<%=mailid%>';
			var labelid = $(this).attr("target");
			if(mails==""){
				return;
			}
			var param = {"mailsId": mails, "operation": "addLable", "lableId": labelid};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
			});
			$(".btnGrayDropContent").hide();
			stopEvent();
			window.document.location.reload();
	});
	
	$("#signAs02").find("li").mouseover(function(){
			$(this).css("background-color","#cccccc");
	}).mouseout(function(){
			$(this).css("background-color","rgb(248, 248, 248)");
	});
	$("#moveTo02").bind("click",function(event){
		$(".btnGrayDropContent").hide();
		var x=$(this).offset().left;
		var y=$(this).offset().top;
		 //alert($(this).offset().left);
		//$("#moveTo02").find(".btnGrayDropContent").css("top",y+25);
		//$("#moveTo02").find(".btnGrayDropContent").css("left",x);
		$("#moveTo02").find(".btnGrayDropContent").show();
		stopEvent();
	}).find(".item").bind("click", function(event){
		var mails = '<%=mailid%>';
		var folderid = $(this).attr("target");
		if(mails==""){
			return;
		}
		moveMailToFolder(mails,folderid)
	});
	
	$("#moveTo02").find("li").mouseover(function(){
			$(this).css("background-color","#cccccc");
	}).mouseout(function(){
			$(this).css("background-color","rgb(248, 248, 248)");
	});
	
	jQuery("#editBtn").bind("click",function(){
			//回复
			var url="/email/new/MailAdd.jsp?flag=5&id=<%=mailid%>";
			window.parent.addTab("1",url,"<%=SystemEnv.getHtmlLabelName(81300,user.getLanguage()) %>","");
	})
	
	jQuery("#replayBtn").bind("click",function(){
			//回复
			
			var url="/email/new/MailAdd.jsp?flag=1&id=<%=mailid%>"
			
					window.parent.addTab("1",url,"Re:<%=getSubject(mrs.getSubject(),user)%>","");
			
	})

	jQuery("#replayAllBtn").bind("click",function(){
		//回复全部
		var url="/email/new/MailAdd.jsp?flag=2&id=<%=mailid%>"
		
			window.parent.addTab("1",url,"Re:<%=getSubject(mrs.getSubject(),user)%>","");
		
	})
	jQuery("#forwardBtn").bind("click",function(){
		//转发
		var url="/email/new/MailAdd.jsp?flag=3&id=<%=mailid%>"
		window.parent.addTab("1",url,"<%=SystemEnv.getHtmlLabelName(132408, user.getLanguage()) + getSubject(mrs.getSubject(),user)%>",""); //转发:  Fw:
		
	})
	<%if(folderid != -3) {%>
	jQuery("#delBtn").bind("click",function(){
		//删除
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			moveMailToFolder('<%=mailid%>',"-3");
		});
	})
	<%}%>
	jQuery("#dropBtn").bind("click",function(){
		//删除全部
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
			deleteMail('<%=mailid%>');
			//window.parent.deleteTab();
		});
	})
	
	jQuery("#recallBtn").bind("click",function(){
	
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32436,user.getLanguage())%>",function(){
			//撤回
			var param = {"mailId": <%=mailid%>, "operation": "recall"};
			$.post("/email/new/MailManageOperation.jsp", param, function(flag){
				flag = flag.replace(/(^\s*)|(\s*$)/g, "");//清除空格
				if("true" == flag){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32025,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>");
					jQuery("#recallBtn").html("<%=SystemEnv.getHtmlLabelName(32412,user.getLanguage())%>");
					jQuery("#recallBtn").attr("disabled","disabled");
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32025,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>");
				}
			});
		});
		
	});

	
	
	initLableTarget();
	initStarTarget();
		
}

//标签功能
function initLableTarget(){
	//初始化标签中的closeLb按钮
	$("div.label").find("div.closeLb").bind("click", function(){
		var self = this;
		var hisParent = $(self).parent();
		var mailId = $(hisParent).find("input[name=mailId]").val();
		var lableId = $(hisParent).find("input[name=lableId]").val();
		var param = {"mailId": mailId, "lableId": lableId, "operation": "removeLable"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			$(hisParent).remove();
		});
	});
	
	$(".label").mouseenter(function(){
		var obj = $(this);
		t=setTimeout(function(){
			
			$(obj).find(".closeLb").show();
		},500);
	}).mouseleave(function(){
		var obj = $(this);
		
		$(obj).find(".closeLb").hide();
		clearTimeout(t);
		
	});
}

//移动邮件到指定文件夹
function moveMailToFolder(mailIds,folderid){
	if(mailIds!=""){
		var param = {"mailId": mailIds,movetoFolder:folderid, "operation": "move"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			if("<%=layout%>"==3){//平铺
				window.parent.deleteTab('<%=folderid%>');
			}else{
				window.parent.parent.deleteTab('<%=folderid%>');
			}
		});
	}
}

//星标功能
function initStarTarget(){

	$(".fg2").bind("click", function(){
		var self = this;
		var mailId = '<%=mailid%>';
		if($(self).hasClass("fs2")) {
			var param = {"mailId": mailId, "star": 0, "operation": "updateStar"};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				$(self).removeClass("fs2");
			});
		} else {
			var param = {"mailId": mailId, "star": 1, "operation": "updateStar"};
			$.post("/email/new/MailManageOperation.jsp", param, function(){
				$(self).addClass("fs2");
			});
		}
	});
}

function Goto(url){	
	
	//window.open(url,"mainFrame");
	window.location.href=url;
	
}

//彻底删除邮件
function deleteMail(maiId){
	if(maiId!=""){
		var param = {"mailId": maiId, "operation": "delete"};
		$.post("/email/new/MailManageOperation.jsp", param, function(){
			if("<%=fromable%>"=="element"){
				window.parent.close();
			}else if("<%=layout%>"==3){//平铺
				window.parent.deleteTab('<%=folderid%>');
			}else{
				window.parent.parent.deleteTab('<%=folderid%>');
			}
		});
	}
}

//重载当前页面
function reloadCurrentPage() {
	var url = "MailView.jsp?mailid="+<%=mailid%>+"&folderid=<%=folderid%>";
	$("#mailContentContainer").load(url,function(){
		mailViewInit(<%=mailid%>,url);
	});
}

//为指定的元素添加按键响应 mailContentContainer
function pageTurning(event) {
	switch(event.keyCode) {
	case 37:
		nextMail(<%=mailid%>);
		stopEvent();
		break;
	case 39:
		prevMail(<%=mailid%>);
		stopEvent();
		break;
	}
}

$(".btnSpan").hover(
	function(){$(this).addClass("btnSpanOver")},
	function(){$(this).removeClass("btnSpanOver")}
);

$(".label").mouseenter(function(){
	var obj = $(this);
	t=setTimeout(function(){
		
		$(obj).find(".closeLb").show();
	},500);
}).mouseleave(function(){
	var obj = $(this);
	
	$(obj).find(".closeLb").hide();
	clearTimeout(t);
	
});

function openShowNameHref(to,obj,type){
	if(type==1){
		window.parent.addTab("1","/email/new/MailAdd.jsp?to="+to,"<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}else{
		window.parent.addTab("1","/email/new/MailAdd.jsp?to="+to+"&isInternal=0","<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}
}

//阻止事件冒泡
function stopEvent() {
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

function cancelLabel2(obj){
	var mails = "<%=mailid%>";
	var param = {"mailsId": mails, "operation": "cancelLabel"};
	$.post("/email/new/MailManageOperation.jsp", param, function(){
		$(obj).parent().hide();
	});
}
function createLabel2(type){
	var mails = "<%=mailid%>";
	if(type==1){
		openDialogcreateLabel2("<%=SystemEnv.getHtmlLabelName(31220, user.getLanguage())%>","/email/new/LabelCreate.jsp?mailsId="+mails+"&type=1",1);
	}else{
		openDialogcreateLabel2("<%=SystemEnv.getHtmlLabelName(31221, user.getLanguage())%>","/email/new/FolderManageAdd.jsp?mailsId="+mails+"&type=2",2);
	}
	
}
var dlgcreateLabel2;
//在其子页面中，调用此方法打开相应的界面
function openDialogcreateLabel2(title,url,type) {
			dlgcreateLabel2=new window.top.Dialog();//定义Dialog对象
			dlgcreateLabel2.currentWindow = window;
			dlgcreateLabel2.Width=450;//定义长度
			if(type==2){
				dlgcreateLabel2.Height=150;
			}else{
				dlgcreateLabel2.Height=200;
			}
			dlgcreateLabel2.URL=url;
			dlgcreateLabel2.Title=title;
			dlgcreateLabel2.show();			
}
function closeDialogcreateLabel() {
		dlgcreateLabel2.close();
		window.document.location.reload();
}

function showALL(obj,type){

	if($(obj).parents("#simpleinfo").length>0){
		var status=$("#showMailInfobtn").attr("_status");
		if(status!="1")
			showMailInfo($("#showMailInfobtn"));
		showALL($("#moreinfo .showAllBtn:first"),type);
		return ;
	}
	
		
	var alldiv=$(obj).parent().next();
	if(alldiv.html()!=""){
	   alldiv.show();
	   $(obj).parent().hide();
	   return ;
	}
	//延迟加载数据，达到一种好的加载效果
	 setTimeout(
	 	function(){
	 				$.post("/email/new/MailLoadHrmAjax.jsp?type="+type, "", function(data){
							$(obj).parent().hide();
							alldiv.html(data).show();
							if(alldiv.height()>=100){
								alldiv.height("100px");
								alldiv.css("overflow-x","none").css("overflow-y","auto");
							}
					});
	 	}
	 ,1500);
}	

function showALLTO(obj,mailaddress){

	if($(obj).parents("#simpleinfo").length>0){
		var status=$("#showMailInfobtn").attr("_status");
		if(status!="1")
			showMailInfo($("#showMailInfobtn"));
		showALLTO($("#moreinfo .showAllBtn:first"),mailaddress);
		return ;
	}

	var alldiv=$(obj).parent().next();
	if(alldiv.html()!=""){
	   alldiv.show();
	   $(obj).parent().hide();
	   return ;
	}
	 setTimeout(
	 	function(){
	 				$.post("/email/new/MailManageOperation.jsp?operation=getAllTO",{mailaddress:mailaddress}, function(data){
							$(obj).parent().hide();
							alldiv.html(data).show();
							if(alldiv.height()>=100){
								alldiv.height("100px");
								alldiv.css("overflow-x","none").css("overflow-y","auto");
							}
					});
	 	}
	 ,500);
}

function hideALL(obj){
	var partdiv=$(obj).parent().prev().show();
	$(obj).parent().hide();
}

function isdel(){

	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
		return true;
	},function(){
		return false;
	});
 }
 


$(function(){
	doResize();
});

function getMailWaitDealDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:400;	
	diag.Height =height?height:450;
	diag.ShowButtonRow=false;
	diag.Title = title;
	return diag;
} 

function　mailUnreadUpdate(){
 	try{
		window.parent.parent.mailUnreadUpdate();
	}catch(e){
			try{
				//说明是老版的模式查看
				window.parent.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.mailUnreadUpdate();	
			}catch(e){
				//左右树形结构查看
				window.parent.parent.document.getElementById("mailFrameLeft").contentWindow.mailUnreadUpdate();
			}	

	}
}

//添加黑名单
function addBlackInfo(mailaddr) {
		var param = {"mailaddress": mailaddr, "operation": "saveblacklist"};
		$.post("/email/MailOperation.jsp", param, function(){
			$('#mailaddrdiv').hide();
		});
}

function showmailaddrdiv(ev, obj) {
    var rel = obj.attr('rel');
    if(!rel || rel.indexOf('@') == -1) {
        return;
    }
	var oEvent=ev||event;
	var oTop=(oEvent.clientY+15)+'px'
	$('#mailaddrdiv').css("left",obj.offset().left);
	$('#mailaddrdiv').css("top",obj.offset().top + 25);	
	$('#mailaddrspan').html(obj.attr('rel'));
	$('#mailaddrname').html('<strong>'+obj.attr('re1l')+'</strong>');
	$('#addblackbtn').click(function(){
			addBlackInfo(obj.attr('rel'));
	});
	$('#writeletterbtn').click(function(){
			openShowNameHref(obj.attr('rel'),obj.attr('isInternal'));
	});
	$('#mailaddrdiv').show();
}

function initwaitdeal() {
		//邮件标题提示框控制
		$(".mailaddresstitle").bind("mouseenter",function(){
			showmailaddrdiv(event, $(this));
			
		});
		$(".mailaddresstitle").bind("mouseleave",function(){
			setTimeout(function(){
				if(!$('#mailaddrdiv').is(":hover"))
						$('#mailaddrdiv').hide();
			},'500');
			
		});
		$("#mailaddrdiv").bind("mouseleave",function(){
			setTimeout(function(){
			if(!$('#mailaddresstitle').is(":hover"))
				$('#mailaddrdiv').hide();
			},'500');
		});


	bindwaitdeal();
}

function bindwaitdeal(){
	// 使用each（）方法来获得每个元素的属性
	$('.nameInfo').each(function(){
		$(this).qtip({
			content: {
				// 设置您要使用的文字图像的HTML字符串，正确的src URL加载图像
	//			text: '<img class="throbber" src="images/throbber.gif" alt="Loading..." />',
				url: $(this).attr('rel'), // 使用的URL加载的每个元素的rel属性
				title:{
					text: '<%=SystemEnv.getHtmlLabelName(83115,user.getLanguage())%>', // 给工具提示使用每个元素的文本标题
					button: '关闭' // 在标题中显示关闭文字按钮
				}
			},
			position: {
				corner: {
					target: 'bottomMiddle', // 定位上面的链接工具提示
					tooltip: 'topMiddle'
				},
				adjust: {
					screen: true // 在任何时候都保持提示屏幕上的
				}
			},
			show: { 
				when: 'click', //或click 
				solo: true // 一次只显示一个工具提示
			},
			hide: 'unfocus',
			style: {
				tip: true, // 设置一个语音气泡提示在指定工具提示角落的工具提示
				border: {
					width: 0,
					radius: 4
				},
				name: 'light', // 使用默认的淡样式
				width: 450, // 设置提示的宽度
				height: 110
			}
		})
	});

}

//setInterval("doResize()",200);
window.onresize=function(){
	doResize();
}

function doResize(){
	// $("#mailContent")[0].contentWindow.initHeight();
	/*
	if(document.location.href.indexOf("MailView")>-1){

		$("#mailContent").css("width","100%");
		//$("#mailContent").css("height","0px");
		//$("#mailContent").css("height",document.body.clientHeight-$("#MailViewMain").height());	
	}else{
		if(<%=layout%>==2){
			$("#mailContent").css("width",$(".centerDiv ").width());
			//$("#mailContent").css("height","0px");
			//$("#mailContent").css("height",$(document).height()-$("#MailViewMain").height());	
		}else{
			$("#mailContent").css("width","100%");
			//$("#mailContent").css("height","0px");
			//$("#mailContent").css("height",$(".centerDiv ").height()-$("#MailViewMain").height());	
		}
		
		
	}
	*/
	
}
var diag = null;
function showMailReadInfo(){
	diag = new window.top.Dialog();
	diag.currentWindow = window;
 	diag.Width = 650;
	diag.Height = 500;
	diag.Title = "<%=SystemEnv.getHtmlLabelNames("367,31970", user.getLanguage())%>";
	diag.ShowButtonRow=false;
	diag.URL = "/email/new/MailReadInfo.jsp?mailid="+<%=mailid%>+"&"+new Date().getTime();
	diag.show();
	jQuery("body").trigger("click");

}
//待办成功关闭窗口
function closeDialog1() {
	if(diag){
		diag.close();
		var waitdealdiv = "<div class='nameInfo' id ='nameInfo<%=mailid%>' title='<%=SystemEnv.getHtmlLabelName(83115 ,user.getLanguage())%>' rel='/email/new/MailWaitDealWin.jsp?taget=mailview&mailId=<%=mrs.getId()%>' style='padding-left:12px; ' ><img src='/email/images/mail_wait_deal_wev8.png'     /></div>";
		var waitdealmain = $('#waitdeal_set').parent();
		waitdealmain.html(waitdealdiv);
		bindwaitdeal();
		mailUnreadUpdate();
	}
}

var state = false;//展开状态

//设定快速回复页面效果图
$(function(){
	$("#btnDiv").hide();
	$("#successEmail").hide();
	
	$("#successEmail").bind("click",function(){
		$("#successEmail").hide();
		$("#sendEmail").show();
		state = false;
		setSize(true);
	})
});

function setSize(flag){
	if(flag && !state){
		$("#btnDiv").show();
		$("#replycontent").removeClass("quick_normal").addClass("quick_active");
		$("#replycontent").val("");
		state = true;
	}
	
	if(!flag){
		$("#btnDiv").hide();
		$("#replycontent").val("<%=SystemEnv.getHtmlLabelName(32110,user.getLanguage())%>:");
		$("#replycontent").addClass("quick_normal").removeClass("quick_active");
		state = false;
	}
	
	toAttachment();
}
//快速回复
function fastReply(obj){
	//快捷回复
	if("" == jQuery("#replycontent").val()){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32110,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())+SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>")
		return;
	}
	var param = {"mailId": <%=mailid%>, "operation": "fastReply","replycontent":jQuery("#replycontent").val()};
	$.post("/email/new/MailManageOperation.jsp", param, function(flag){
		flag = flag.replace(/(^\s*)|(\s*$)/g, "");//清除空格
		if(flag == "true"){
			$("#successEmail").show();
			$("#sendEmail").hide();
		}else{
			location.href="/email/new/MailDone.jsp?isSent="+flag+"";
		}
	});
}

//弹出是否需要回执
var dlog = null;
jQuery(function(){
	
	if("<%=wmc.getReceiveNeedReceipt()%>"=="1"){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32473,user.getLanguage()) %>",function(){
			saveRecipt('1');
		}, function () {
			saveRecipt('0');
		});
	}
});

function saveRecipt(state){
	if(state == "0"){
		var param = {"mailId":<%=mailid%>,"operation":"readReceipt"}
		$.post("/email/new/MailManageOperation.jsp",param,function(flag){
				// alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
		});
		Dialog.close(); 
	}else{
		var param = {"mailId":<%=mailid%>,"operation":"receiveNeedReceipt"}
		$.post("/email/new/MailManageOperation.jsp",param,function(flag){
				// alert("<%=SystemEnv.getHtmlLabelName(31228,user.getLanguage()) %>")
		});
		Dialog.close(); 
	}
}

jQuery(function(){
	if(<%=(null != folderList && folderList.size()>15)%>){
		jQuery("#moveTo02").find(".btnGrayDropContent").css("overflow-y","scroll");
		jQuery("#moveTo02").find(".btnGrayDropContent").css("height","400px");
		jQuery("#moveTo02").find(".btnGrayDropContent").css("width","100px");
	}
	
	if(<%=(null != lmsList && lmsList.size()>12)%>){
		jQuery("#signAs02").find(".btnGrayDropContent").css("overflow-y","scroll");
		jQuery("#signAs02").find(".btnGrayDropContent").css("height","400px");
		jQuery("#signAs02").find(".btnGrayDropContent").css("width","100px");
	}
});

function showMailInfo(obj){
	var status=$(obj).attr("_status");
	if(status=="1"){
	    $("#simpleinfo").show();
	    $("#moreinfo").hide();
	    $(obj).attr("_status","0").css("background-image","url('/email/images/icon_d_wev8.png')").html("<%=SystemEnv.getHtmlLabelName(83122,user.getLanguage()) %>");
	}else{
		$("#simpleinfo").hide();
	    $("#moreinfo").show();
	    $(obj).attr("_status","1").css("background-image","url('/email/images/icon_u_wev8.png')").html("<%=SystemEnv.getHtmlLabelName(83126,user.getLanguage()) %>");
	}
}

function downLoad(fileid){
	$("#downLoadFrame").attr("src","/weaver/weaver.email.FileDownloadLocation?download=1&fileid="+fileid+"&mailid=<%=mailid%>"); 
}

function toAttachment(){
	$('body,html').animate({scrollTop:$('#footer').offset().top},200);
}

function onShowCard(obj,contactid,isInternals){
	var event=event?event:window.event;
	var contactName=$(obj).attr("_contactName");
	var contactInfo=$(obj).attr("_contactInfo");
	$("#contactName").html(contactName);
	$("#contactInfo").html(contactInfo);
	$("#contactCard").css({
		"left":$(obj).offset().left,
		"top":$(obj).offset().top+20
	}).show();
	
	if(isInternal==1){
		//pointerXY(event);
		//openhrm(contactid);
	}
}

$(window).scroll(function(){     
        var bodyTop = document.documentElement.scrollTop + document.body.scrollTop;             
        //当滚动条滚到一定距离时，执行代码  
        if(5<=bodyTop){
        	$("#inBoxTitle").addClass("fixeddiv");
        }else{
        	//alert(2);
        	$("#inBoxTitle").removeClass("fixeddiv");
        }
});

function openSignPrint() {
	var redirectUrl = "MailView.jsp?isPrint=1&loadjquery=1&mailid=<%=mailid%>";
	var width = screen.width ;
	var height = screen.height ;
	if (height == 768 ) height -= 75 ;
	if (height == 600 ) height -= 60 ;
	if(width >1000) width=1000;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="toolbar=no," ;
	szFeatures +="scrollbars=no," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"_blank",szFeatures) ;
}


function sendMail(){
	var url="/email/new/MailAdd.jsp?flag=1&id=<%=mailid%>"
	window.parent.addTab("1",url,"Re:<%=getSubject(mrs.getSubject(),user)%>","");
}

//打开附件预览
function openfile(url) {
/*
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("156,221",user.getLanguage()) %>";
	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.maxiumnable=true;
	dialog.URL = url;
	dialog.show();
*/
    window.open(url);
}

function showWaitDeal(mailids) {
	if(mailids!=""){
	    var title="<%=SystemEnv.getHtmlLabelName(83114,user.getLanguage()) %>";
		diag=getMailWaitDealDialog(title,400,500);
		diag.URL = "/email/new/MailWaitDeal.jsp?mailids="+mailids;
		diag.show();
		document.body.click();
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31226,user.getLanguage()) %>!");
	}
}

function waitDeal(mailid){
	$(".btnGrayDropContent").hide();
	stopEvent();
	showWaitDeal(mailid);
}

</script>

<%!
    public String getSubject(String subject ,User user){
    	subject=subject.replaceAll("(\r\n|\r|\n|\n\r)",""); //替换换行符
    	if(subject.equals("")){
    		return SystemEnv.getHtmlLabelName(31240,user.getLanguage());
    	}else{
    		return subject;
    	}
    }
%>
