<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.interfaces.outter.OutterUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
%>
<%
OutterUtil ut=new OutterUtil();
String sysid = Util.null2String(request.getParameter("id"));
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
sysid = java.net.URLDecoder.decode(sysid,"UTF-8");  
//sysid = new String(sysid.getBytes("iso8859-1"),"GBK");
String tiptitle = SystemEnv.getHtmlLabelName(125496,user.getLanguage());//"选择MD5加密解密时，我们会使用标准的MD5加密，如果填写了加密密钥，将可以进行解密还原出明文；如果选择的是自定义加密算法，那么需要填写加密程序的路径以及方法，传递的参数将只有需要加密的需求本身，返回值必须是加密后的数据.";
rs.executeSql("select * from outter_sys where sysid='"+sysid+"'");
//out.println("select * from outter_sys where sysid='"+sysid+"'");

String name = "";
String iurl = "";
   String ourl = "";
   String requesttype = "";
String baseparam1="";
String urlparaencrypt1 = "";
String encryptcode1 = "";
String baseparam2="";
String urlparaencrypt2 = "";
String encryptcode2 = "";
String typename = "";
String accountcode = "";
String urlparaencrypt = "";
String encryptcode = "";
String encrypttype = "";
String encryptclass = "";
String encryptmethod = "";

 String urllinkimagid ="";
String urlencodeflag ="";
String autologinflag ="";
String encryptclassId ="";  //自定义加密id
String imagewidth ="";  //宽度
String imageheight =""; //高度
String encodeflag =""; //登录系统编码方式
String client_id = "";
String client_secret = "";

String email263_domain = "";
String email263_cid = "";
String email263_key = "";


int basetype1=0;
int basetype2=0;
	if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	iurl = Util.toScreenToEdit(rs.getString("iurl"),user.getLanguage());
    ourl = Util.toScreenToEdit(rs.getString("ourl"),user.getLanguage());
    requesttype = Util.toScreenToEdit(rs.getString("requesttype"),user.getLanguage());
	baseparam1 = Util.toScreenToEdit(rs.getString("baseparam1"),user.getLanguage());
	urlparaencrypt1 = Util.toScreenToEdit(rs.getString("urlparaencrypt1"),user.getLanguage());
	encryptcode1 = Util.toScreenToEdit(rs.getString("encryptcode1"),user.getLanguage());
	baseparam2 = Util.toScreenToEdit(rs.getString("baseparam2"),user.getLanguage());
	urlparaencrypt2 = Util.toScreenToEdit(rs.getString("urlparaencrypt2"),user.getLanguage());
	encryptcode2 = Util.toScreenToEdit(rs.getString("encryptcode2"),user.getLanguage());
	basetype1 = Util.getIntValue(rs.getString("basetype1"),0);
	basetype2 = Util.getIntValue(rs.getString("basetype2"),0);
	urlparaencrypt = Util.toScreenToEdit(rs.getString("urlparaencrypt"),user.getLanguage());
	encryptcode = Util.toScreenToEdit(rs.getString("encryptcode"),user.getLanguage());
	typename = Util.toScreenToEdit(rs.getString("typename"),user.getLanguage());
	accountcode = Util.toScreenToEdit(rs.getString("ncaccountcode"),user.getLanguage());
	encrypttype = Util.toScreenToEdit(rs.getString("encrypttype"),user.getLanguage());
	encryptclass = Util.toScreenToEdit(rs.getString("encryptclass"),user.getLanguage());
	encryptmethod = Util.toScreenToEdit(rs.getString("encryptmethod"),user.getLanguage());
	
	urllinkimagid = Util.toScreenToEdit(rs.getString("urllinkimagid"),user.getLanguage());
	urlencodeflag = Util.toScreenToEdit(rs.getString("urlencodeflag"),user.getLanguage());
	autologinflag = Util.toScreenToEdit(rs.getString("autologin"),user.getLanguage());
	encryptclassId = Util.toScreenToEdit(rs.getString("encryptclassId"),user.getLanguage());
	imagewidth = Util.toScreenToEdit(rs.getString("imagewidth"),user.getLanguage());
	imageheight = Util.toScreenToEdit(rs.getString("imageheight"),user.getLanguage());
	encodeflag = Util.toScreenToEdit(rs.getString("encodeflag"),user.getLanguage());
	client_id = Util.toScreenToEdit(rs.getString("client_id"),user.getLanguage());
	client_secret = Util.toScreenToEdit(rs.getString("client_secret"),user.getLanguage());
	
	email263_domain = Util.null2String(rs.getString("email263_domain"));
	email263_cid =  Util.null2String(rs.getString("email263_cid"));
	email263_key =  Util.null2String(rs.getString("email263_key"));
}

if("".equals(encrypttype))
{
	encrypttype = "0";
}
if("".equals(imagewidth))
{
	imagewidth = "32";
}
if("".equals(imageheight))
{
	imageheight = "32";
}
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;


//得到网段策略

String addipinf=SystemEnv.getHtmlLabelName(18890,user.getLanguage())+"["+SystemEnv.getHtmlLabelName(83726,user.getLanguage())+"]"+SystemEnv.getHtmlLabelName(125421,user.getLanguage())+".";
ArrayList ips=new ArrayList();

String sql="select id,inceptipaddress,endipaddress from HrmnetworkSegStr order by id ";
rs.executeSql(sql);
while(rs.next()){
	String inceptipaddress=Util.null2String(rs.getString("inceptipaddress"));
	String endipaddress=Util.null2String(rs.getString("endipaddress"));
	ips.add(inceptipaddress+"~"+endipaddress);
}


ArrayList outternetwork=new ArrayList();
sql="select id,inceptipaddress,endipaddress from outter_network where sysid='"+sysid+"' order by id ";
rs.executeSql(sql);
while(rs.next()){
	String inceptipaddress=Util.null2String(rs.getString("inceptipaddress"));
	String endipaddress=Util.null2String(rs.getString("endipaddress"));
	outternetwork.add(inceptipaddress+"~"+endipaddress);
}

Map mEncryptclass=ut.getEncryptclass();
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
			if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
				canEdit = true;
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSave()"/>
			<%}
			if(HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
			<%
			}
			%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM id=weaver name=frmMain action="OutterSysOperation.jsp?isdialog=1" method=post enctype="multipart/form-data" >
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20961,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(typename.equals("1")){%>NC<%}
			else if(typename.equals("5")){%>NC6.X<%}
			  else if(typename.equals("2")){%>EAS<%}
			  else if(typename.equals("3")){%>U8<%}
			  else if(typename.equals("4")){%>K3<%}
			  else if(typename.equals("9")){%>K3/Cloud<%}
			  else if(typename.equals("6")){%><%=SystemEnv.getHtmlLabelName(128546,user.getLanguage()) %><%}
			  else if(typename.equals("7")){%>263<%=SystemEnv.getHtmlLabelName(128627,user.getLanguage())%><%}
			  else{%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%} %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
		<!-- QC293001　[80][90]集成登录-编辑集成登陆设置页面，名称内含的符号未反转义           -->
			<%if(canEdit){%>
            <wea:required id="nameimage" required="true" value='<%=name%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=30 maxlength="30" name="name" id="name"  value="<%=name%>" onchange="isExist(this.value);checkinput('name','nameimage');" >
            </wea:required>
            <%}else{%><%=name%><%}%>
		</wea:item>
		
		
		<%if(!urllinkimagid.equals("0")&&!urllinkimagid.equals("") ){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(82627,user.getLanguage())%></wea:item>
		       	<wea:item>
		       		<BUTTON class=delbtn accessKey=D onClick="delpic()" type="button" title="<%=SystemEnv.getHtmlLabelName(82746,user.getLanguage())%>"></BUTTON>
		       		<span style="vertical-align: middle;"><%=SystemEnv.getHtmlLabelName(82746,user.getLanguage())%></span>
		       		<input class=inputstyle type=hidden name=oldurllinkimagid value="<%=urllinkimagid%>">
		       	</wea:item>
						<%}else{%>
						<wea:item><%=SystemEnv.getHtmlLabelName(82627,user.getLanguage())%></wea:item>
						<wea:item><input class=inputstyle type=file name=urllinkimagid id="urllinkimagid" value='<%=urllinkimagid%>' style="width: 280px" onchange="isimag(this);"><%=SystemEnv.getHtmlLabelName(82744,user.getLanguage())%> gif,png,jpg,jpeg,ico,bmp
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(125422,user.getLanguage())%></wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(33818,user.getLanguage())%>&nbsp;
							<input class=inputstyle type=text style='width:30px!important;' size=30 maxlength="30" name="imagewidth" value='<%=imagewidth%>'    onchange="vaidDataNum(this);checkinput('imagewidth','imagewidthSpan');" _noMultiLang=true>
							<span name="imagewidthSpan" id="imagewidthSpan">
							<img src="/images/BacoError_wev8.gif" align=absmiddle>
							</span>
							&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(33819,user.getLanguage())%>&nbsp;
							<input class=inputstyle type=text style='width:30px!important;' size=30 maxlength="30" name="imageheight" value='<%=imageheight%>'  onchange="vaidDataNum(this);checkinput('imageheight','imageheightSpan');" _noMultiLang=true>
							<span name="imageheightSpan" id="imageheightSpan">
							<img src="/images/BacoError_wev8.gif" align=absmiddle>
							</span>
					 </wea:item>
						<%}%>
						<%if(!urllinkimagid.equals("0")&&urllinkimagid.length()>0){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(82747,user.getLanguage())%></wea:item>
    				<wea:item>
    				<img class="ContactsAvatar" style="right: 0;z-index: 999;width:32px;height:32px" border=0 id=urllinkimagid src="/weaver/weaver.file.FileDownload?fileid=<%=urllinkimagid%>">
    				</wea:item>
    				<wea:item><%=SystemEnv.getHtmlLabelName(125422,user.getLanguage())%></wea:item>
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(33818,user.getLanguage())%>&nbsp;
							<input class=inputstyle type=text style='width:30px!important;' size=30 maxlength="30" name="imagewidth" value='<%=imagewidth%>'    onchange="vaidDataNum(this);checkinput('imagewidth','imagewidthSpan');" _noMultiLang=true>
							<span name="imagewidthSpan" id="imagewidthSpan">
							<img src="/images/BacoError_wev8.gif" align=absmiddle>
							</span>
							&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(33819,user.getLanguage())%>&nbsp;
							<input class=inputstyle type=text style='width:30px!important;' size=30 maxlength="30" name="imageheight" value='<%=imageheight%>'  onchange="vaidDataNum(this);checkinput('imageheight','imageheightSpan');" _noMultiLang=true>
							<span name="imageheightSpan" id="imageheightSpan">
							<img src="/images/BacoError_wev8.gif" align=absmiddle>
							</span>
					 </wea:item>
    				
					<%} %>
						
		<%
			String qqemail_type = typename.equals("6")?"{'samePair':'qqemail_type','display':'none'}":"{'samePair':'qqemail_type','display':'true'}";
			String password_type = (typename.equals("6")||typename.equals("7"))?"{'samePair':'password_type','display':'none'}":"{'samePair':'password_type','display':'true'}";
	
		%>				
						
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(125423,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
		<input class='Inputstyle' type='checkbox' tzCheckbox="true" name="autologinflag" id="autologinflag" value='<%=autologinflag%>' onclick="changeautologinflag();" <%if(autologinflag.equals("1")) out.print("checked");%>>
		<span id="autologinspan" style="display:none">
		<select id="inneripselecct" style='width:260px!important;' name="inneripselecct"  >
		<%
		if(ips!=null&&ips.size()>0)
		{
			for(int i=0;i<ips.size();i++){
			%>
			 <option value="<%=ips.get(i)%>"><%=ips.get(i)%></option>
			<%
			}
		}
		%>
          
		</select> &nbsp;&nbsp;<a style="color:#00B2FC;" href="javascript:addtr();"><%=SystemEnv.getHtmlLabelName(83476,user.getLanguage())%></a>   &nbsp;&nbsp;<SPAN class="e8tips" style="CURSOR: hand"  title="<%=addipinf%>""><img src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>&nbsp;&nbsp;  <a style="color:#00B2FC;" href="javascript:setNetwork();" ><%=SystemEnv.getHtmlLabelName(83726,user.getLanguage())%></a>
		</span>
		</wea:item>
		<wea:item attributes="{'samePair':'networkview','display':'none'}">&nbsp;</wea:item>
		<wea:item attributes="{'samePair':'networkview','isTableList':'true','display':'none'}">
		<div style="width:100%;" >
				<table  cellSpacing="0" cellpadding="0" id="networktable"  width="100%">
								<colgroup>
									<col width="30%">
									<col width="10%">
									<col width="100%">
								</colgroup>
								<%
									if(outternetwork!=null&&outternetwork.size()>0)
									 {
										for(int i=0;i<outternetwork.size();i++){
								%>
								<tr class="field">
								<td class="field"><%=outternetwork.get(i)%></td>
								<td class="field"><a href="#" id="testa" onclick="deltr(this)"><%=SystemEnv.getHtmlLabelName(125426,user.getLanguage())%></a></td>
								<td class="field"><input type='hidden' name='outternetworks' id='outternetworks' value='<%=outternetwork.get(i)%>'></td>
								</tr>
								<%
									}
								}
								%>
								
					</table>
		</div>
		</wea:item>
		
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(20963,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
            <%if(canEdit){%>
            <wea:required id="iurlimage" required="true" value='<%=iurl%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="iurl"  value="<%=iurl%>" onchange='checkinput("iurl","iurlimage")' _noMultiLang=true>
            </wea:required>
           <%}else{%><%=iurl%><%}%>
		</wea:item>
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(20964,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
            <%if(canEdit){%>
            <wea:required id="ourlimage" required="true" value='<%=ourl%>'>
            	<input class=inputstyle style='width:280px!important;' type=text size=100 maxlength="200" name="ourl"   value="<%=ourl%>" onchange='checkinput("ourl","ourlimage")' _noMultiLang=true>
            </wea:required>
           <%}else{%><%=ourl%><%}%>
		</wea:item>
		<%
			String urlencodeflag_encodeflag_encrypttype_samePair = (typename.equals("6")||typename.equals("7"))?"{'samePair':'urlencodeflag_encodeflag_encrypttype_samePair','display':'none'}":"{'samePair':'urlencodeflag_encodeflag_encrypttype_samePair','display':''}";
		%>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>"><%=SystemEnv.getHtmlLabelName(32343,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>">
			<select name="requesttype" style='width:120px!important;' onchange="onChangeRequestType(this.value)">
				<option value="POST" <%if("POST".equals(requesttype)) out.println("selected"); %>>POST</option>
				<option value="GET" <%if("GET".equals(requesttype)) out.println("selected"); %>>GET</option>
			</select>
			<span id="encodespan" <%if("POST".equals(requesttype)) out.println("style=display:none"); %>>
			<input type=radio name=urlencodeflag value=1 <%if(urlencodeflag.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(82628,user.getLanguage())%>
		    <input type=radio name=urlencodeflag value=0 <%if(urlencodeflag.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(82631,user.getLanguage())%>
			</span>
		</wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>"><%=SystemEnv.getHtmlLabelName(127225,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>">
			<select style='width:120px!important;' name="encodeflag" >
			  <option value="0"　<%if("0".equals(encodeflag)) out.println("selected"); %>>UTF-8</option>
			  <option value="1" <%if("1".equals(encodeflag)) out.println("selected"); %> >GBK</option>
			</select>
		</wea:item>
		<%
			String qqemail_type2 = typename.equals("6")?"{'samePair':'qqemail_type2','display':'none'}":"{'samePair':'qqemail_type2','display':'true','colspan':'full'}";
		%>	
		
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>"><%=SystemEnv.getHtmlLabelName(32344,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>">
			<select style='width:120px!important;' id="encrypttype" name="encrypttype" onchange="changeEncryptType(this.value);" title="<%=tiptitle %>"><!-- 加密算法 -->
          	  <option value="0" <%if("0".equals(encrypttype)) out.println("selected"); %>></option>
          	  <option value="3" <%if("3".equals(encrypttype)) out.println("selected"); %>>MD5<%=SystemEnv.getHtmlLabelName(17589,user.getLanguage())%></option><!-- 加密 -->
			  <option value="1" <%if("1".equals(encrypttype)) out.println("selected"); %>>PBE<%=SystemEnv.getHtmlLabelName(17589,user.getLanguage())%></option><!-- 加密 -->
			  <option value="2" <%if("2".equals(encrypttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(32345,user.getLanguage())%></option><!-- 自定义加密算法 -->
			</select>
			<SPAN id="EncryptclassSpan"> 
			<select style='width:120px!important;' id="encryptclassId" name="encryptclassId" onchange="" ><!-- 自定义加密算法  -->
          	  <% 
          	  if(mEncryptclass!=null&&mEncryptclass.size()>0){
          		  
          		mEncryptclass=ut.sortMapByKey(mEncryptclass);
          		for(Object obj : mEncryptclass.keySet()){
       			 String tid=obj.toString();
       			 if(tid==null||tid.equals("")){
       				 continue;
       			 }
       			 String  encryptclassname=mEncryptclass.get(tid)==null?"":(String)mEncryptclass.get(tid);
       			 %>
       			  <option value="<%=tid%>" <%if(tid.equals(encryptclassId)) out.println("selected"); %>><%=encryptclassname%></option>
       			 <% 
          	  }
          	  }
          	  %>
			</select> &nbsp;<a style="color:#00B2FC;" href="javascript:newencryptclass();"><%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%></a>
			</SPAN>
			<SPAN class="e8tips" style="CURSOR: hand"  title="<%=tiptitle %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
		</wea:item>
		<wea:item attributes="{'samePair':'encrypt1'}"><%=SystemEnv.getHtmlLabelName(32345,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'encrypt1'}">
            <wea:required id="encryptclassimage" required="true" value='<%=encryptclass %>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=30 maxlength="200" name="encryptclass" value='<%=encryptclass %>' onchange='checkinput("encryptclass","encryptclassimage")'>
            </wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'encrypt2'}"><%=SystemEnv.getHtmlLabelName(32346,user.getLanguage())%><!-- 加密方法 --></wea:item>
		<wea:item attributes="{'samePair':'encrypt2'}">
			<wea:required id="encryptmethodimage" required="true" value='<%=encryptmethod %>'>
				<input class=inputstyle type=text style='width:280px!important;' size=30 maxlength="200" name="encryptmethod" value='<%=encryptmethod %>' onchange='checkinput("encryptmethod","encryptmethodimage")'>
            </wea:required>
		</wea:item>
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(20965,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
			<%if(canEdit){%>
			<wea:required id="baseparam1image" required="true" value="<%=baseparam1%>">
				<input class='inputstyle' type='text' style='width:120px!important;' size='30' maxlength="30" name="baseparam1" id="baseparam1" value="<%=baseparam1%>" onchange='checkinput("baseparam1","baseparam1image")' _noMultiLang=true>
            </wea:required>
            <%}else{%><%=baseparam1%><%}%>
		    <input type=radio name=basetype1 value=1 <%if(basetype1==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20974,user.getLanguage())%>
		    <input type=radio name=basetype1 value=0 <%if(basetype1==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		    &nbsp;&nbsp;<span class="isencrypt"><%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%><input class='Inputstyle' type='checkbox' tzCheckbox="true" name="urlparaencrypt1" <%if(urlparaencrypt1.equals("1")){%>checked<%}%> value='1' onclick="changeurlparaencrypt(this);">&nbsp;&nbsp;<span class="encryptcode"  ><%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>:<input class=inputstyle type=password style='width:80px!important;' maxLength=10 name="encryptcode1" value='<%=encryptcode1 %>'><SPAN class="e8tips" style="CURSOR: hand"  title="<%=SystemEnv.getHtmlLabelName(32349,user.getLanguage())%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN></span></span>
		</wea:item>
		

		<wea:item attributes="<%=password_type %>"><%=SystemEnv.getHtmlLabelName(20966,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=password_type %>">
			<%if(canEdit){%>
			<wea:required id="baseparam2image" required="true" value='<%=baseparam2%>'>
				<input class=inputstyle type=text style='width:120px!important;' size=30 maxlength="30" name="baseparam2"  id="baseparam2"  value="<%=baseparam2%>" onchange='checkinput("baseparam2","baseparam2image")' _noMultiLang=true>
            </wea:required><%}else{%><%=baseparam2%><%}%>
		    <input type=radio name=basetype2 value=1 <%if(basetype2==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20975,user.getLanguage())%>
		    <input type=radio name=basetype2 value=0 <%if(basetype2==0){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		    &nbsp;&nbsp;<span class="isencrypt"><%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%><input class='Inputstyle' type='checkbox' tzCheckbox="true" name="urlparaencrypt2" <%if(urlparaencrypt2.equals("1")){%>checked<%}%> value='1'  onclick="changeurlparaencrypt(this);">&nbsp;&nbsp;<span class="encryptcode"><%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>:<input class=inputstyle type=password style='width:80px!important;' maxLength=10 name="encryptcode2" value='<%=encryptcode2 %>'></span></span>
		</wea:item>
		
		<%
		if("1".equals(typename)||"5".equals(typename)){
	   %>
	   <wea:item><%=SystemEnv.getHtmlLabelName(24427,user.getLanguage())%></wea:item>
	   <wea:item>
			<%if(canEdit){%>
			 <wea:required id="accountcodeimage" required="true" value='<%=accountcode%>'>
			 	<input class=inputstyle type=text style='width:80px!important;' size=30 maxlength="30" name="accountcode"  value="<%=accountcode%>" onchange='checkinput("accountcode","accountcodeimage")' _noMultiLang=true>
			 </wea:required>
            <%}else{%><%=accountcode%><%}%>
	   </wea:item>
		<%}%>
		
		
		<%
		String client_type = !typename.equals("6")?"{'samePair':'client_type','display':'none'}":"{'samePair':'client_type','display':'true'}";
		%>
	    <wea:item attributes='<%=client_type%>'><%=SystemEnv.getHtmlLabelName(129950,user.getLanguage())+"(corpid)"%></wea:item>
		<wea:item attributes='<%=client_type%>'>
            <wea:required id="client_idimage" required="true" value="<%=client_id%>">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="client_id"  value="<%=client_id%>" onchange='checkinput("client_id","client_idimage")' _noMultiLang=true>
            </wea:required>
		</wea:item>
		<wea:item attributes='<%=client_type%>'><%=SystemEnv.getHtmlLabelName(129951,user.getLanguage())+"(corpsecret)"%></wea:item>
		<wea:item attributes='<%=client_type%>'>
            <wea:required id="client_secretimage" required="true" value="<%=client_secret%>">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="client_secret"   value="<%=client_secret%>" onchange='checkinput("client_secret","client_secretimage")' _noMultiLang=true>
            </wea:required>
		</wea:item>
		
		
		 <%
		String email263_type = !typename.equals("7")?"{'samePair':'email263_type','display':'none'}":"{'samePair':'email263_type','display':''}";
		%>
	    <wea:item attributes='<%=email263_type%>'><%=SystemEnv.getHtmlLabelName(128624,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=email263_type%>'>
            <wea:required id="email263_domainimage" required="true" value="<%=email263_domain%>">
            	<input class='inputstyle' type='text' style='width:280px!important;' size='100' maxlength="200" name="email263_domain"  value="<%=email263_domain%>"  onchange='checkinput("email263_domain","email263_domainimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		 <wea:item attributes='<%=email263_type%>'><%=SystemEnv.getHtmlLabelName(128625,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=email263_type%>'>
            <wea:required id="email263_cidimage" required="true" value="<%=email263_cid%>">
            	<input class='inputstyle' type='text' style='width:280px!important;' size='100' maxlength="200" name="email263_cid"  value="<%=email263_cid%>"  onchange='checkinput("email263_cid","email263_cidimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		 <wea:item attributes='<%=email263_type%>'><%=SystemEnv.getHtmlLabelName(128626,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=email263_type%>'>
            <wea:required id="email263_keyimage" required="true" value="<%=email263_key%>">
            	<input class='inputstyle' type='password' style='width:280px!important;' size='100' maxlength="200" name="email263_key"  value="<%=email263_key%>"  onchange='checkinput("email263_key","email263_keyimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		
	</wea:group>
	
	<%
		if(!"6".equals(typename)&&!"7".equals(typename)){
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20967,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow()" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow()" ACCESSKEY="G" class="delbtn"/>
		  </div>
	    </wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<div id="outtersetting">
			</div>
		</wea:item>
	</wea:group>
	<%} %>
</wea:layout>
<br>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=sysid value="<%=sysid%>">
 <input class=inputstyle type=hidden name=typename value="<%=typename%>">
 <input class=inputstyle type=hidden name=backto value="<%=backto%>">
 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>
<script language=javascript>

//QC293001　[80][90]集成登录-编辑集成登陆设置页面，名称内含的符号未反转义　　－－－START
//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}

function isExist(newvalue){
	newvalue = $.trim(newvalue);
	document.getElementById("name").value = newvalue;

	if(isSpecialChar(newvalue)){
		//名称包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
		document.getElementById("name").value = "";
		
	}
}
//QC293001　[80][90]集成登录-编辑集成登陆设置页面，名称内含的符号未反转义　　－－－END

function onSave(){
	var checkvalue = "";
	var typenametmp = "<%=typename%>";
	if(typenametmp == 1 || typenametmp == 5) {
		checkvalue = "sysid,name,iurl,ourl,accountcode";
	} else if(typenametmp ==6){
		checkvalue = "sysid,name,client_id,client_secret";
	} else if(typenametmp ==7){
		checkvalue = "sysid,name,iurl,ourl,email263_domain,email263_cid,email263_key";
	}
	else {
		checkvalue = "sysid,name,iurl,ourl";
	}
	checkvalue += ",imagewidth,imageheight";
	var encrypttype = document.getElementById("encrypttype").value;
    if(check_form(frmMain,checkvalue)){
    	document.frmMain.operation.value="edit";

        /*QC340720 [80][90][建议]集成登录-参数名做必填项处理，输入框后添加必填感叹号 start*/
        if(check_form(frmMain,"paramnames")){
            /*QC339532 [80][90][优化]集成登录-优化集成登录其它参数配置参数名不能重复 start*/
			var param = new Array();
			var isSame = false;
			$("input[name='paramnames']").each(function(i){//参数名存入数组
				param[i] = $.trim($(this).val());
			});
			$.each(param,function(i,vi){
				$.each(param,function(j,vj){
					if(i != j && vi == vj){
						isSame = true;
						//将重复的行删除或清空
						/*$("input[name='paramnames']").each(function(k){
							//alert("k:"+k+",j:"+j);
							if(k == i){
								$(this).val("");
							}
						});*/
					}
				});
				if(isSame){
					return false;
				}
			});
			if(isSame){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132214,user.getLanguage())%>");
				return false;
			}
			/*QC339532 [80][90][优化]集成登录-优化集成登录其它参数配置参数名不能重复 end*/
			document.frmMain.submit();
        }
        /*QC340720 [80][90][建议]集成登录-参数名做必填项处理，输入框后添加必填感叹号 end*/
    }
}
function doAdd()
{
	document.location.href="/interface/outter/OutterSysAdd.jsp?typename=<%=backto%>";
}
function doBack()
{
	document.location.href="/interface/outter/OutterSys.jsp?typename=<%=backto%>";
}
function onDelete(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>", function (){
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}, function () {}, 320, 90);
}
function changeEncryptType(val)
{
	if(val=="1")
	{
	    $("#EncryptclassSpan").hide();
	    // $("#encryptclassId").empty();
	  	$("#encryptclassId").attr("value","");
		hideEle("encrypt1");
		hideEle("encrypt2");
		//$(".encrypt").hide();
		$(".encryptcode").hide();
		$(".encryptcode_head").hide();
		$(".isencrypt").show();
		
		$(".maybelast").attr("colspan","1");
		
		 iniIsEncrypt();
		
		
	}
	else if(val=="2")
	{    
	    $("#EncryptclassSpan").show();
		//showEle("encrypt1");
		//showEle("encrypt2");
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").hide();
		$(".encryptcode_head").hide();
		$(".isencrypt").show();
		$(".maybelast").attr("colspan","2");
	}else if(val=="3")
	{    
	   $("#EncryptclassSpan").hide();
	   // $("#encryptclassId").empty();
	  	$("#encryptclassId").attr("value","");
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").hide();
		$(".encryptcode_head").hide();
		$(".isencrypt").show();
		$(".maybelast").attr("colspan","2");
	}
	else
	{
	  	$("#EncryptclassSpan").hide();
	  	// $("#encryptclassId").empty();
	  	$("#encryptclassId").attr("value","");
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").hide();
		$(".encryptcode_head").hide();
		$(".isencrypt").hide();
		$(".maybelast").attr("colspan","3");
		
	}
	 onInitTypeChange();
	
}
function onChangeTypeFun(obj){
	if(obj == "1") {
		
	} else {
	    document.all("baseparam1").readOnly = false;
		document.all("baseparam2").readOnly = false;
		document.getElementById("baseparam1image").style.display = "none";
		document.getElementById("baseparam2image").style.display = "none";
	}
}
function onTypeChange(obj,isinit){
	if(obj.value==0||obj.value==5){
		obj.nextSibling.nextSibling.style.display='none';
		obj.nextSibling.nextSibling.nextSibling.style.display='inline-block';
		$(obj.nextSibling.nextSibling.nextSibling).find("input[type=text]").eq(0).attr("readonly","");
		if(obj.value==5){
		$(obj.nextSibling.nextSibling.nextSibling).find("*[class=e8tips]").eq(0).show();
		$(obj).closest("tr").find("*[class=isencrypt]").eq(0).hide();
		
		}else{
		$(obj.nextSibling.nextSibling.nextSibling).find("*[class=e8tips]").eq(0).hide();
		if($("#encrypttype").val()!="0"){
		$(obj).closest("tr").find("*[class=isencrypt]").eq(0).show();
		}
		}
	}else if(obj.value==4){
		obj.nextSibling.nextSibling.style.display='inline-block';
		obj.nextSibling.nextSibling.nextSibling.style.display='inline-block';
		if(isinit==null||isinit!="isinit"){
		$(obj.nextSibling.nextSibling.nextSibling).find("input[type=text]").eq(0).val("");
		}
		$(obj.nextSibling.nextSibling.nextSibling).find("input[type=text]").eq(0).attr("readonly","readonly");
		$(obj.nextSibling.nextSibling.nextSibling).find("*[class=e8tips]").eq(0).hide();
		if($("#encrypttype").val()!="0"){
		$(obj).closest("tr").find("*[class=isencrypt]").eq(0).show();
		}
	}
    else{
		obj.nextSibling.nextSibling.style.display='none';
		obj.nextSibling.nextSibling.nextSibling.style.display='none';
		if($("#encrypttype").val()!="0"){
		$(obj).closest("tr").find("*[class=isencrypt]").eq(0).show();
		}
	}
}
function onInitTypeChange(){
	var paramtypes = jQuery("select[name='paramtypes']");
    jQuery.each(paramtypes, function(i, n){
      var obj = n;
      //alert( "Item #" + i + ": " + n +" obj.value : "+obj.outerHTML);
      onTypeChange(obj,"isinit");
   });
}
function changeParamValue(obj)
{
	if(obj.checked)
		obj.nextSibling.nextSibling.value='1';
	else
		obj.nextSibling.nextSibling.value='0';
	//alert(obj.nextSibling.outerHTML);
	
}
<%
   
	StringBuffer ajaxdata = new StringBuffer();
	rs.executeSql("SELECT * FROM outter_sysparam where sysid='"+sysid+"' order by indexid");
	//System.out.println("SELECT * FROM outter_sysparam where sysid='"+sysid+"' order by indexid");
	while (rs.next()) 
	{
		// System.out.println("============"+ut.ProcessCharacter(rs.getString("paramvalue")));
        int paramtype= Util.getIntValue(rs.getString("paramtype"),0);
        String paraencrypts= Util.null2String(rs.getString("paraencrypt"));
        String encryptcodes= Util.null2String(rs.getString("encryptcode"));
        String checked="false";
        if(paraencrypts.equals("1")){
        	checked="true";
        }
       
		ajaxdata.append("[");
        ajaxdata.append("{name:'paramid',value:'',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'paramids',value:'',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'paramnames',value:'"+rs.getString("paramname")+"',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'labelnames',value:'"+rs.getString("labelname") +"',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'paramtypes',value:'"+paramtype+"',iseditable:true,type:'select'},");
        ajaxdata.append("{name:'paramvalues',value:'"+ut.ProcessCharacter(rs.getString("paramvalue")) +"',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'tempparaencrypts',value:'"+paraencrypts +"',iseditable:true,checked:"+checked+",type:'checkbox'},");
        ajaxdata.append("{name:'paraencrypts',value:'"+paraencrypts +"',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'encryptcodes',value:'"+ encryptcodes +"',iseditable:true,type:'input'}");
        ajaxdata.append("],");
	}
	String tempajaxdata = ajaxdata.toString();
	if(!"".equals(tempajaxdata))
	{
		tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
	}
	tempajaxdata = "["+tempajaxdata+"]";
	
%>
var maybelast="<select name=paramtypes onchange='onTypeChange(this)' style='width:80px;'>"+
               "<option value=0><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"+
               "<option value=1><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%></option>"+
               "<option value=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>"+
               "<option value=3><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option>"+
              "<option value=4><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></option>"+
               "<option value=5><%=SystemEnv.getHtmlLabelName(125424,user.getLanguage())%></option>"+
               "</select>"+
               "<span style='display:none;'>"+
                 "  &nbsp;&nbsp;<a style='color:#00B2FC;' href='#' onclick='setexpression(this);'><%=SystemEnv.getHtmlLabelName(125420,user.getLanguage())%></a>&nbsp;&nbsp; "+
                "</span>"+
               "<span style='display:inline-block;'>"+
               "<INPUT class='Inputstyle'   style='width:120px!important;' type='text' name='paramvalues'  value='' _noMultiLang=true>"+
               "<SPAN class='e8tips' style='CURSOR: hand;display:none;'  title='<%=SystemEnv.getHtmlLabelName(125497,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"+
               "</span>";
var items=[
    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(20968,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='paramnames'  value='' _noMultiLang=true onchange='checkparamnames(this);' onblur='checkParamnamesRepet(this);'><span class='mustinput'></span>"},
    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='labelnames'  value='' _noMultiLang=true>"},
    {width:"37%",tdclass:"maybelast",colname:"<%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%>",itemhtml:maybelast},
    {width:"10%",tdclass:"isencrypt",colname:"<%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='checkbox' tzCheckbox='true' name='tempparaencrypts' value=1 onclick='changeParamValue(this); changeurlparaencrypt1(this);'><INPUT type='hidden' name='paraencrypts' value='1'>"},
    {width:"20%",tdclass:"encryptcode_head",colname:"<%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='password' name='encryptcodes' value=''>"}];

var option= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:false,
   optionHeadDisplay:"none",
   colItems:items,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
      changeEncryptType(jQuery("#encrypttype").val());
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>",width:"7%"},
   initdatas:eval("<%=tempajaxdata%>")
};
var group=null;
jQuery(document).ready(function(){
	group=new WeaverEditTable(option);
    jQuery("#outtersetting").append(group.getContainer());
    var params=group.getTableSeriaData();
    reshowCheckBox();
    changeEncryptType(jQuery("#encrypttype").val());
    onChangeTypeFun('<%=typename%>');
    onInitTypeChange();
    jQuery(".optionhead").hide();
    jQuery(".tablecontainer").css("padding-left","0px");
    changeautologinflag();
   // hideEle("encrypt1");
	//hideEle("encrypt2");
	checkinput('imagewidth','imagewidthSpan');
	checkinput('imageheight','imageheightSpan');
    iniIsEncrypt();
    jQuery(".e8tips").wTooltip({html:true});
});
function iniIsEncrypt()
{
   changeurlparaencrypt($("input[name=urlparaencrypt1]"));
   changeurlparaencrypt($("input[name=urlparaencrypt2]"));
   var paramtypes=$("input[name=tempparaencrypts]");
    jQuery.each(paramtypes, function(i, n){
      var obj = n;
      //jQuery(obj).trigger("rbeauty");
      //jQuery($(obj)).trigger("checked",true);
      changeurlparaencrypt1(obj);
     
     
   });
    
	
}
function addRow()
{
	if(null!=group)
	{
		group.addRow(null);
		jQuery(".e8tips").wTooltip({html:true});
	}
}
function removeRow()
{
	var count = 0;//删除数据选中个数
	jQuery("#outtersetting input[name='paramid']").each(function(){
		if($(this).is(':checked')){
			count++;
		}
	});
	//alert(v+":"+count);
	if(count==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
	}else{
		  if(null!=group)
		{
			group.deleteRows();
		}
	}
}
function onBack()
{
	parentWin.closeDialog();
}

function delpic(){
      if(confirm("<%=SystemEnv.getHtmlLabelName(82748,user.getLanguage())%>？")){
	  document.frmMain.operation.value = "delpic";
	  document.frmMain.submit();
       }
  }

  function onChangeRequestType(obj){
	if(obj == "GET") {  //get
	  jQuery("#encodespan").show();
    } else { 
	  jQuery("#encodespan").hide();
	 
	}
	//alert($("#urlencodeflag").val());
}

   function isimag(obj){   
	
	  var file = obj.value.match(/[^\/\\]+$/gi)[0]; 
	  var rx = new RegExp('\\.(gif)$','gi');
	   var rx1 = new RegExp('\\.(png)$','gi');
	    var rx2 = new RegExp('\\.(jpg)$','gi');
		 var rx3 = new RegExp('\\.(jpeg)$','gi');
		  var rx4 = new RegExp('\\.(ico)$','gi');
		    var rx5 = new RegExp('\\.(bmp)$','gi');
	  if(file&&!file.match(rx)&&!file.match(rx1)&&!file.match(rx2)&&!file.match(rx3)&&!file.match(rx4)&&!file.match(rx5))
		  {    
		  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82744,user.getLanguage())%> gif,png,jpg,jpeg,ico,bmp !");
		  //alert("选择的文件不是图片文件，请选择图片文件!");       //重新构建input file       
	
		var file=document.getElementById("urllinkimagid");
		file.outerHTML=file.outerHTML;
	 
			}   
	  }
	  
	  
function addtr(){
if($("#networktable").find("tr").length == 0) {
	showEle("networkview");
}
var val=$("#inneripselecct").val();
var temp=$("#networktable tr").find("td:eq(0)");
if(val==temp1){
top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126052,user.getLanguage())%>!");
return ;
}
if(temp!=null&&temp.length>0)
{
for(var i=0;i<temp.length;i++){
var temp1=$(temp[i]).html();
if(val==temp1){
top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125425,user.getLanguage())%>!");
return ;
}
}
}
 str = "<tr><td class='field'>"+val+"</td><td class='field'><a href='#' id='testa' onclick='deltr(this)'><%=SystemEnv.getHtmlLabelName(125426,user.getLanguage())%></a></td><td class='field'><input type='hidden' name='outternetworks' id='outternetworks' value='"+val+"'></td></tr>";
 $('#networktable').append(str);
 }
 //删除对应的行
 function deltr(obj){
 $(obj).parent().parent().remove();
 //$("#testa").closest("tr").eq(0).remove();
 	if($("#networktable").find("tr").length == 0) {
	 	hideEle("networkview");
	}
 }
 
 function changeautologinflag(){
  var checked = $("#autologinflag").attr("checked");
	
		if(!checked){
		$("#autologinflag").val("0");	
		$("#autologinspan").hide();	
		hideEle("networkview");
			
		} else {
			/*QC318959 [80][缺陷]集成登录-切换成腾讯企业邮箱，会显示自动内外网登录地址  start*/
			var typename = <%=typename%>;
			$("#autologinflag").val("1");	
			$("#autologinspan").show();	
			if($("#networktable").find("tr").length == 0) {
		 		hideEle("networkview");
			} else if(typename != "6" && $("#networktable").find("tr").length != 0) {
				showEle("networkview");
			}
			/*QC318959 [80][缺陷]集成登录-切换成腾讯企业邮箱，会显示自动内外网登录地址 end*/
		}
 }
 
  function setexpression(obj){
     var url="/interface/outter/outter_expressiontab.jsp?";
     var paramnames = jQuery("input[name='paramnames']");
     var names="";
     var  expression=$(obj).closest("td").find("input[type=text]").eq(0).val();
     var temp=$(obj).closest("tr").find("input[type=text]").eq(0).val();
    
     names+=$("#baseparam1").val()+",";
     names+=$("#baseparam2").val()+",";
     jQuery.each(paramnames, function(i, n){
      var obj = n;
      if(temp!=obj.value){
       names+=obj.value+",";
       }
      //alert( "Item #" + i + ": " + n +" obj.value : "+obj.value);
   });

  var encodev="expression="+encodeURIComponent(encodeURIComponent(expression))+"&names="+encodeURIComponent(encodeURIComponent(names));
   url+=encodev;
	 var title = "<%=SystemEnv.getHtmlLabelNames("68,15636",user.getLanguage())%>";
   openDialog1(url,title,obj);
  
 }
 
 function changeurlparaencrypt(obj){
var ch=$(obj).attr("checked");
var encrypttype=jQuery("#encrypttype").val();
if(encrypttype==1){
if(ch){
$(obj).closest("tr").find(".encryptcode").eq(0).show();
}else{
$(obj).closest("tr").find(".encryptcode").eq(0).hide();
//$(".encryptcode").eq(0).hide();
}
}
}
 function changeurlparaencrypt1(obj){

var ch=$(obj).attr("checked");
var encrypttype=jQuery("#encrypttype").val();
if(encrypttype=="1"){
if(ch){
var tempparatype=$(obj).closest("tr").find("*[name=paramtypes]").eq(0).val();
if(tempparatype!="5"){
$(obj).closest("tr").find(".encryptcode_head").eq(0).show();
}
$(obj).closest("table").find(".encryptcode_head").eq(0).show();
$(".maybelast").attr("colspan","1");

}else{
$(obj).closest("tr").find(".encryptcode_head").eq(0).hide();
var flag=false;
var paramtypes= $(obj).closest("tbody").find("input[name=encryptcodes]");
    jQuery.each(paramtypes, function(i, n){
      var obj = n;
     
     if($(obj).is(":visible")){
     flag=true;
     return;
     }
     
   });

  if(!flag){
  $(obj).closest("table").find(".encryptcode_head").eq(0).hide();
  $(".maybelast").attr("colspan","2");
  }
}
}
}

function newencryptclass()
{
   var url = "/interface/outter/outter_encryptclassTab.jsp?urlType=1&backto=<%=backto%>&isdialog=1&mode=1";
	var title = "<%=SystemEnv.getHtmlLabelName(20961,user.getLanguage())%>";
	//openDialog(url,title);
	openDialog2(url,title);
}

function openDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = 750;
	dialog.Height = 596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function openDialog1(url,title,obj){
                  var browserDialog = new top.Dialog();
						browserDialog.currentWindow = window;
						browserDialog.Width = 620 ;
						browserDialog.Height = 550;
						//if(dialogMaxiumnable&&dialogMaxiumnable==true){
							//browserDialog.maxiumnable=true;
						//}
						browserDialog.URL = url;
						browserDialog.Title = title;
						browserDialog.checkDataChange = false;
						browserDialog.callback=function(datas,otherdatas){
   						   if(datas!=null&&datas.indexOf('###save')>-1){
      							$(obj).closest("td").find("input[type=text]").eq(0).val(datas.substr(0, datas.indexOf('###save')));
    						}
   						 }
						browserDialog.show();
						
						
	
}
function openDialog2(url,title){
                  var browserDialog = new top.Dialog();
						browserDialog.currentWindow = window;
						browserDialog.Width = 620 ;
						browserDialog.Height = 550;
						//if(dialogMaxiumnable&&dialogMaxiumnable==true){
							//browserDialog.maxiumnable=true;
						//}
						browserDialog.URL = url;
						browserDialog.Title = title;
						browserDialog.checkDataChange = false;
						browserDialog.callback=reloadEncryptclass;
						browserDialog.show();

}

function openDialog3(url,title){
                  var browserDialog = new top.Dialog();
						browserDialog.currentWindow = window;
						browserDialog.Width = 980 ;
						browserDialog.Height = 650;
						
						browserDialog.URL = url;
						browserDialog.Title = '';
						browserDialog.checkDataChange = false;
						browserDialog.callback=refreshNetwork;
						browserDialog.show();
						

}

function setNetwork()
{
   var url = "/interface/outter/outter_netWorkTab.jsp?urlType=1&backto=<%=backto%>&isdialog=1&mode=1";
	var title = "";
	openDialog3(url,title);
}

function refreshNetwork(datas,otherdatas)
{
   getNetwork();
}

function getNetwork()
{
  $.ajax({ 
        	type:"POST",
            url: "/interface/outter/outter_getNetWork.jsp",
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
 
  			$("#inneripselecct option").remove();
   			$("#inneripselecct").append(data);
   			
       }
        });
      jQuery("#inneripselecct").selectbox("detach");
 	  __jNiceNamespace__.beautySelect("#inneripselecct");
}

function reloadEncryptclass(datas,otherdatas)
{
     $.ajax({ 
        	type:"POST",
            url: "/interface/outter/outter_getEncryptClass.jsp",
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
            
  			$("#encryptclassId option").remove();
   			$("#encryptclassId").append(data);

       }
        });
        jQuery("#encryptclassId").val(<%=encryptclassId%>);
      jQuery("#encryptclassId").selectbox("detach");
 	  __jNiceNamespace__.beautySelect("#encryptclassId");

}

function vaidDataNum(obj)
{
	var str =$(obj).val();
	var reg = /^[0-9]*$/;
	if(!reg.test(str)){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125427,user.getLanguage())%>!");
		$(obj).val("");
		$(obj).focus();
	}
	
}

/*QC340133 [80][90][优化]集成登录-优化集成登录其它参数配置参数名内含有特殊字符会产生乱码，格式不对等情况 start*/
//检查其他参数的参数名
function checkparamnames(obj){
	var value = $(obj).val();
	value = $.trim(value);
	if(isSpecialChar(value)){
	    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132223,user.getLanguage())%>");
	    $(obj).val("");
	    return false;
	}
	return true;
}
/*QC340133 [80][90][优化]集成登录-优化集成登录其它参数配置参数名内含有特殊字符会产生乱码，格式不对等情况 end*/
/*QC339532 [80][90][优化]集成登录-优化集成登录其它参数配置参数名不能重复 start*/
function checkParamnamesRepet(obj){
    var isSame = false;
	obj.value = $.trim(obj.value);
    $("input[name='paramnames']").each(function(){
        if(obj.value != "" &&  $(this)[0] != obj && $(this).val() == obj.value ){
            obj.value = "";
            isSame = true;
        }
    });
    if(isSame){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132214,user.getLanguage())%>");
        return false;
    }else{
        return true;
    }
}
/*QC339532 [80][90][优化]集成登录-优化集成登录其它参数配置参数名不能重复 end*/
 </script>
 <%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
 </div>
 <%} %>
</BODY>
</HTML>
