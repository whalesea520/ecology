<%@ page import="weaver.general.Util" %>
<%@page import="weaver.interfaces.outter.OutterUtil"%> 
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
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
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = SystemEnv.getHtmlLabelName(125496,user.getLanguage());//"选择MD5加密解密时，我们会使用标准的MD5加密，如果填写了加密密钥，将可以进行解密还原出明文；如果选择的是自定义加密算法，那么需要填写加密程序的路径以及方法，传递的参数将只有需要加密的需求本身，返回值必须是加密后的数据。";
String typename = Util.null2String(request.getParameter("typename"));
boolean select_att = false;	//功能类的新建是，类型默认不能选择
if("1".equals(typename)||"2".equals(typename)||"3".equals(typename)||"4".equals(typename)||"8".equals(typename)){
	select_att = true;
}



int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));
String backto = Util.null2String(request.getParameter("backto"));

String addipinf=SystemEnv.getHtmlLabelName(18890,user.getLanguage())+"["+SystemEnv.getHtmlLabelName(83726,user.getLanguage())+"]"+SystemEnv.getHtmlLabelName(125421,user.getLanguage())+".";

//得到网段策略
ArrayList ips=new ArrayList();
RecordSet rs=new RecordSet();
String sql="select id,inceptipaddress,endipaddress from HrmnetworkSegStr order by id ";
rs.executeSql(sql);
while(rs.next()){
	String inceptipaddress=Util.null2String(rs.getString("inceptipaddress"));
	String endipaddress=Util.null2String(rs.getString("endipaddress"));
	ips.add(inceptipaddress+"~"+endipaddress);
}

OutterUtil ut=new OutterUtil();
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
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
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
<script language=javascript>
<%
if(msgid!=-1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!');
<%}%>
</script>
<FORM id=weaver name=frmMain action="OutterSysOperation.jsp" method=post enctype="multipart/form-data">

<input class=inputstyle type=hidden name="backto" value="<%=typename %>">
<input class=inputstyle type="hidden" name=operation value="add">
 <wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82743,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="typename" style='width:120px!important;' name="typename" onchange="onChangeTypeFun(this.value)" >
			  <option value="0"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
			  <option value="1" <%if(typename.equals("1")) out.print("selected"); %>>NC</option>
			  <option value="2" <%if(typename.equals("2")) out.print("selected"); %>>EAS</option>
			  <option value="3" <%if(typename.equals("3")) out.print("selected"); %>>U8</option>
			  <option value="4" <%if(typename.equals("4")) out.print("selected"); %>>K3</option>
			  <option value="5" <%if(typename.equals("5")) out.print("selected"); %>>NC6.X</option>
			  <option value="6" <%if(typename.equals("6")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(128546,user.getLanguage()) %></option>
			  <option value="7" <%if(typename.equals("7")) out.print("selected"); %>>263<%=SystemEnv.getHtmlLabelName(128627,user.getLanguage())%></option>
			  <option value="8" <%if(typename.equals("8")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(129791,user.getLanguage())%></option>
			</select>
		</wea:item>
        <wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="sysidimage" required="true" value="">
				<input class=inputstyle type='text' onpaste="return false" style='width:280px!important;' size='30' maxlength="30" name="sysid"  _noMultiLang='true'  onkeyup="this.value=this.value.replace(/[^0-9a-zA-Z]/g,'');checkinput('sysid','sysidimage');" >
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="nameimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=30 maxlength="30" name="name"  value="" onchange='checkinput("name","nameimage");'>
            </wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(82627,user.getLanguage())%></wea:item>
		<wea:item>
  		<input class=inputstyle type="file" style='width:280px!important;' name="urllinkimagid" id="urllinkimagid" onchange="isimag(this);">
		<%=SystemEnv.getHtmlLabelName(82744,user.getLanguage())%> gif,png,jpg,jpeg,ico,bmp 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125422,user.getLanguage())%></wea:item>
		<wea:item>
		<%=SystemEnv.getHtmlLabelName(33818,user.getLanguage())%>&nbsp;
		<input class=inputstyle type=text style='width:30px!important;' size=30 maxlength="30" name="imagewidth" value='32'   onchange="vaidDataNum(this);checkinput('imagewidth','imagewidthSpan');" _noMultiLang=true>
		<span name="imagewidthSpan" id="imagewidthSpan">
				<img src="/images/BacoError_wev8.gif" align=absmiddle>
		</span>
		&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(33819,user.getLanguage())%>&nbsp;
		<input class=inputstyle type=text style='width:30px!important;' size=30 maxlength="30" name="imageheight" value='32'  onchange="vaidDataNum(this);checkinput('imageheight','imageheightSpan');" _noMultiLang=true>
		<span name="imageheightSpan" id="imageheightSpan">
				<img src="/images/BacoError_wev8.gif" align=absmiddle>
		</span>
		 </wea:item>
		<%
			String qqemail_type = typename.equals("6")?"{'samePair':'qqemail_type','display':'none'}":"{'samePair':'qqemail_type','display':'true'}";
			String username_type = typename.equals("8")?"{'samePair':'username_type','display':'none'}":"{'samePair':'username_type','display':'true'}";
			
		%>
		
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(125423,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
		<input class='Inputstyle' type='checkbox' tzCheckbox="true" name="autologinflag" id="autologinflag" value='1' onclick="changeautologinflag();">
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
								
					</table>
		</div>
		</wea:item>
		
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(20963,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
            <wea:required id="iurlimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="iurl"  value="" onchange='checkinput("iurl","iurlimage")' _noMultiLang=true>
            </wea:required>
		</wea:item>
		<wea:item attributes="<%=qqemail_type %>"><%=SystemEnv.getHtmlLabelName(20964,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=qqemail_type %>">
            <wea:required id="ourlimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="ourl"   value="" onchange='checkinput("ourl","ourlimage")' _noMultiLang=true>
            </wea:required>
		</wea:item>
		<%
		String urlencodeflag_encodeflag_encrypttype_samePair = "{'samePair':'urlencodeflag_encodeflag_encrypttype_samePair'}";
		%>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>"><%=SystemEnv.getHtmlLabelName(32343,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>">
			<select style='width:120px!important;' name="requesttype" onchange="onChangeRequestType(this.value)">
			  <option value="POST">POST</option>
			  <option value="GET" selected>GET</option>
			</select>
			<span id="encodespan">
			<input type=radio name="urlencodeflag" id="urlencodeflag1" value=1 checked><%=SystemEnv.getHtmlLabelName(82628,user.getLanguage())%>
		    <input type=radio name="urlencodeflag" id="urlencodeflag0" value=0 ><%=SystemEnv.getHtmlLabelName(82631,user.getLanguage())%>
			</span>
		</wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>"><%=SystemEnv.getHtmlLabelName(127225,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>">
			<select style='width:120px!important;' name="encodeflag" >
			  <option value="0"　selected>UTF-8</option>
			  <option value="1" >GBK</option>
			</select>
		</wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>"><%=SystemEnv.getHtmlLabelName(32344,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=urlencodeflag_encodeflag_encrypttype_samePair %>">
			<select id="encrypttype" style='width:120px!important;' name="encrypttype" onchange="changeEncryptType(this.value);" title="<%=tiptitle %>"><!-- 加密算法 -->
          	  <option value="0"></option>
          	   <option value="3">MD5<%=SystemEnv.getHtmlLabelName(17589,user.getLanguage())%></option><!-- 加密 -->
			  <option value="1">PBE<%=SystemEnv.getHtmlLabelName(17589,user.getLanguage())%></option><!-- 加密 -->
			  <option value="2"><%=SystemEnv.getHtmlLabelName(32345,user.getLanguage())%></option><!-- 自定义加密算法 -->
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
       			  <option value="<%=tid%>" ><%=encryptclassname%></option>
       			 <% 
          	  }
          	  }
          	  %>
			</select> &nbsp;<a style="color:#00B2FC;" href="javascript:newencryptclass();"><%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%></a>
			</SPAN>
			<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=tiptitle %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
		</wea:item>
		<wea:item attributes="{'samePair':'encrypt1'}"><%=SystemEnv.getHtmlLabelName(32345,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'encrypt1'}">
            <wea:required id="encryptclassimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=30 maxlength="200" name="encryptclass" value='' onchange='checkinput("encryptclass","encryptclassimage")'>
            </wea:required>
		</wea:item>
		<wea:item attributes="{'samePair':'encrypt2'}"><%=SystemEnv.getHtmlLabelName(32346,user.getLanguage())%><!-- 加密方法 --></wea:item>
		<wea:item attributes="{'samePair':'encrypt2'}">
			<wea:required id="encryptmethodimage" required="true" value="">
				<input class=inputstyle type=text style='width:280px!important;' size=30 maxlength="200" name="encryptmethod" value='' onchange='checkinput("encryptmethod","encryptmethodimage")'>
            </wea:required>
		</wea:item>
		<wea:item attributes="<%=username_type %>"><%=SystemEnv.getHtmlLabelName(20965,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=username_type %>">
			<wea:required id="baseparam1image" required="true" value="">
				<input class=inputstyle style='width:120px!important;' type=text size=30 maxlength="30" id="baseparam1" name="baseparam1" value="" onchange='checkinput("baseparam1","baseparam1image")' _noMultiLang=true>
            </wea:required>
		    <input type=radio name=basetype1 value=1 checked><%=SystemEnv.getHtmlLabelName(20974,user.getLanguage())%>
		    <input type=radio name=basetype1 value=0><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		    &nbsp;&nbsp;<span class="isencrypt"><%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%><input class='Inputstyle' type='checkbox' tzCheckbox="true" name="urlparaencrypt1" value='1' onclick="changeurlparaencrypt(this);" >&nbsp;&nbsp;<span class="encryptcode"><%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>:<input class=inputstyle type=password style='width:80px!important;' maxLength=10 name="encryptcode1" value=''><SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(32349,user.getLanguage())%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN></span></span>
		</wea:item>
		<%
			String password_type = "{'samePair':'password_type'}";
		%>
		
		<wea:item attributes="<%=password_type %>"><%=SystemEnv.getHtmlLabelName(20966,user.getLanguage())%></wea:item>
		<wea:item attributes="<%=password_type %>">
			<wea:required id="baseparam2image" required="true" value="">
				<input class=inputstyle style='width:120px!important;' type=text size=30 maxlength="30" id="baseparam2" name="baseparam2"   value="" onchange='checkinput("baseparam2","baseparam2image")' _noMultiLang=true>
            </wea:required>
		    <input type=radio name=basetype2 value=1 checked><%=SystemEnv.getHtmlLabelName(20975,user.getLanguage())%>
		    <input type=radio name=basetype2 value=0 ><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%>
		    &nbsp;&nbsp;<span class="isencrypt"><%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%><input class='Inputstyle' type='checkbox' tzCheckbox="true" name="urlparaencrypt2" value='1' onclick="changeurlparaencrypt(this);">&nbsp;&nbsp;<span class="encryptcode"><%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>:<input class=inputstyle style='width:80px!important;' type=password maxLength=10 name="encryptcode2" value=''></span></span>
		</wea:item>
		<%
		String temptype = !typename.equals("1")?"{'samePair':'acc_id1','display':'none'}":"{'samePair':'acc_id1','display':'online'}";
		%>
	    <wea:item attributes='<%=temptype%>'><%=SystemEnv.getHtmlLabelName(24427,user.getLanguage())%></wea:item>
	    <wea:item attributes='<%=temptype %>'>
			 <wea:required id="accountcodeimage" required="true" value="">
			 	<input class=inputstyle style='width:280px!important;' type=text size=30 maxlength="30" name="accountcode"  value="" onchange='checkinput("accountcode","accountcodeimage")' _noMultiLang=true>
			 </wea:required>
	    </wea:item>
	    
	    <%
		String client_type = !typename.equals("6")?"{'samePair':'client_type','display':'none'}":"{'samePair':'client_type','display':'online'}";
		%>
	    <wea:item attributes='<%=client_type%>'><%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())+SystemEnv.getHtmlLabelName(83594,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=client_type%>'>
            <wea:required id="client_idimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="client_id"  value="" onchange='checkinput("client_id","client_idimage")' _noMultiLang=true>
            </wea:required>
		</wea:item>
		<wea:item attributes='<%=client_type%>'><%=SystemEnv.getHtmlLabelName(32363,user.getLanguage())+"Key"%></wea:item>
		<wea:item attributes='<%=client_type%>'>
            <wea:required id="client_secretimage" required="true" value="">
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="200" name="client_secret"   value="" onchange='checkinput("client_secret","client_secretimage")' _noMultiLang=true>
            </wea:required>
		</wea:item>
		
		
		 <%
		String email263_type = !typename.equals("7")?"{'samePair':'email263_type','display':'none'}":"{'samePair':'email263_type','display':'online'}";
		%>
	    <wea:item attributes='<%=email263_type%>'><%=SystemEnv.getHtmlLabelName(128624,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=email263_type%>'>
            <wea:required id="email263_domainimage" required="true" value="">
            	<input class='inputstyle' type='text' style='width:280px!important;' size='100' maxlength="200" name="email263_domain"  value="" onchange='checkinput("email263_domain","email263_domainimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		 <wea:item attributes='<%=email263_type%>'><%=SystemEnv.getHtmlLabelName(128625,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=email263_type%>'>
            <wea:required id="email263_cidimage" required="true" value="">
            	<input class='inputstyle' type='text' style='width:280px!important;' size='100' maxlength="200" name="email263_cid"  value="" onchange='checkinput("email263_cid","email263_cidimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		 <wea:item attributes='<%=email263_type%>'><%=SystemEnv.getHtmlLabelName(128626,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=email263_type%>'>
            <wea:required id="email263_keyimage" required="true" value="">
            	<input class='inputstyle' type='password' style='width:280px!important;' size='100' maxlength="200" name="email263_key"  value="" onchange='checkinput("email263_key","email263_keyimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>
		
	</wea:group>
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
</wea:layout>
<br>
 <%if("1".equals(isDialog)){ %>
 <input type="hidden" name="isdialog" value="<%=isDialog%>">
 <%} %>
 </form>

<script language=javascript>
jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
	changeEncryptType('');
	reshowCheckBox();
	checkinput('imagewidth','imagewidthSpan');
	checkinput('imageheight','imageheightSpan');
});
function submitData() {
	var checkvalue = "";
	var typenametmp = document.getElementById("typename").value;
	var encrypttype = document.getElementById("encrypttype").value;
	
	if(typenametmp == 1 || typenametmp == 5) {
		checkvalue = "sysid,name,iurl,ourl,accountcode";
	} else if(typenametmp == 6){
		checkvalue = "sysid,name,client_id,client_secret";
	}else if(typenametmp == 7) {
		checkvalue = "sysid,name,iurl,ourl,email263_domain,email263_cid,email263_key";
	}
	else {
		checkvalue = "sysid,name,iurl,ourl";
	}
	checkvalue+= ",imagewidth,imageheight";
    if(check_form(frmMain,checkvalue)){
    	jQuery("#typename").selectbox("enable");
        frmMain.submit();
    }
}
function doBack()
{
	document.location.href="/interface/outter/OutterSys.jsp?typename=<%=typename%>";
}
function iniIsEncrypt()
{
   changeurlparaencrypt($("input[name=urlparaencrypt1]"));
   changeurlparaencrypt($("input[name=urlparaencrypt2]"));
   var paramtypes=$("input[name=tempparaencrypts]");
    jQuery.each(paramtypes, function(i, n){
      var obj = n;
     // jQuery(obj).trigger("rbeauty");
      //jQuery($(obj)).trigger("checked",true);
      changeurlparaencrypt1(obj);
     
     
   });
   	
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
	{   $("#EncryptclassSpan").hide();
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
function onTypeChange(obj){
 
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
		$(obj.nextSibling.nextSibling.nextSibling).find("input[type=text]").eq(0).val("");
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
      onTypeChange(obj);
   });
}

function onChangeTypeFun(obj){
	if(obj == "1"||obj=="5") {
		document.getElementById("baseparam1").value = "username";
		document.getElementById("baseparam2").value = "password";
		document.getElementById("baseparam1").readOnly = true;
		document.getElementById("baseparam2").readOnly = true;
		document.getElementById("baseparam1image").style.display = "none";
		document.getElementById("baseparam2image").style.display = "none";
  		showEle("acc_id1");
  		showEle("qqemail_type");
  		showEle("username_type");
  		showEle("password_type");
  		document.getElementById("ncpkcode_id1").style.display = "";
  		hideEle("client_type");
  		showGroup("SetInfo");
  		showEle("urlencodeflag_encodeflag_encrypttype_samePair");
  		hideEle("email263_type");
  		
	} else {
	    document.getElementById("baseparam1").readOnly = false;
		document.getElementById("baseparam2").readOnly = false;
		document.getElementById("baseparam1image").style.display = "none";
		document.getElementById("baseparam2image").style.display = "none";
		hideEle("acc_id1");
  		document.getElementById("ncpkcode_id1").style.display = "none";
  		if(obj == "6"){
  			showEle("client_type");
  			hideEle("qqemail_type");
  			hideEle("username_type");
  			hideEle("urlencodeflag_encodeflag_encrypttype_samePair");
  			hideEle("password_type");
  			hideGroup("SetInfo");
  			hideEle("email263_type");
  			
  		}else{
  			hideEle("client_type");
  			showEle("qqemail_type");
  			showEle("username_type");
  			showEle("password_type");
  			showEle("urlencodeflag_encodeflag_encrypttype_samePair");
  			showGroup("SetInfo");
  			
  			if(obj == "7"){
	         hideEle("password_type");
	         hideEle("urlencodeflag_encodeflag_encrypttype_samePair");
	         hideGroup("SetInfo");
  			showEle("email263_type");
  			document.getElementById("baseparam1").value = "uid";
  			document.getElementById("baseparam1").readOnly = true;
  			document.getElementById("baseparam2").value = "";
  		    }else{
  		    	if(obj == "8") {// coremail邮箱
  			 		hideEle("urlencodeflag_encodeflag_encrypttype_samePair");
  			 		showEle("qqemail_type");
  			 		hideEle("username_type");
	         		hideGroup("SetInfo");
	         		hideEle("email263_type");
	         		document.getElementById("baseparam1").value = "";
	         		document.getElementById("baseparam2").value = "password";
  					document.getElementById("baseparam2").readOnly = true;
  					$("input[type=radio][name=basetype2][value=0]").trigger("checked",true);
  					
  			 	}else{
	  		     showEle("password_type");
	  		     showEle("urlencodeflag_encodeflag_encrypttype_samePair");
		         showGroup("SetInfo");
	  			 hideEle("email263_type");
	  			 document.getElementById("baseparam1").readOnly = false;
  				}
  		    }
  		}

	}
	
}
function changeParamValue(obj)
{
	if(obj.checked)
	{
	   $(obj).val("1");
		obj.nextSibling.nextSibling.value='1';
		}
	else
	{
	   $(obj).val("0");
		obj.nextSibling.nextSibling.value='0';
	}
	//alert(obj.nextSibling.outerHTML);
}
var maybelast="<select name=paramtypes onchange='onTypeChange(this)' style='width:80px;'>"+
               "<option value=0><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"+
               "<option value=1><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%></option>"+
               "<option value=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>"+
               "<option value=3><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option>"+
               "<option value=4><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></option>"+
               "<option value=5><%=SystemEnv.getHtmlLabelName(125424,user.getLanguage())%></option>"+
               "</select>"+
               "<span style='display:none;'>"+
                 "  &nbsp;&nbsp;<a style='color:#00B2FC;' href='#' onclick='setexpression(this);' ><%=SystemEnv.getHtmlLabelName(125420,user.getLanguage())%></a>&nbsp;&nbsp; "+
                "</span>"+
               "<span style='display:inline-block;'>"+
               "<INPUT class='Inputstyle'   style='width:120px!important;' type='text' name='paramvalues'  value='' _noMultiLang=true>"+
               "<SPAN class='e8tips' style='CURSOR: hand;display:none;'  title='<%=SystemEnv.getHtmlLabelName(125497,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"+
               "</span>";
var items=[
    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(20968,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='paramnames'  value='' _noMultiLang=true>"},
    {width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='labelnames'  value='' _noMultiLang=true>"},
    {width:"37%",tdclass:"maybelast",colname:"<%=SystemEnv.getHtmlLabelName(20969,user.getLanguage())%>",itemhtml:maybelast},
    {width:"10%",tdclass:"isencrypt",colname:"<%=SystemEnv.getHtmlLabelName(28640,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='radio' tzCheckbox='true' name='tempparaencrypts' value=0 onclick='changeParamValue(this); changeurlparaencrypt1(this);'><INPUT type='hidden' name='paraencrypts' value='1'>"},
    {width:"20%",tdclass:"encryptcode_head",colname:"<%=SystemEnv.getHtmlLabelName(32348,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='password' name='encryptcodes' value=''>"}];

var option= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:false,
   optionHeadDisplay:"none",
   colItems:items,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   addAccesskey:"A",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   delAccesskey:"D",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
      changeEncryptType(jQuery("#encrypttype").val());
      //alert(jQuery("#typename").val());
      onChangeTypeFun(jQuery("#typename").val());
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>",width:"7%"},
   initdatas:eval('')
};
var group=null;
jQuery(document).ready(function(){
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#outtersetting").append(group.getContainer());
    var params=group.getTableSeriaData();
    
    var paramnctr = "<TR id='ncpkcode_id1' <%if(!typename.equals("1")) out.print("style='display:none;'"); %>>"+
		            "<TD><INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'></TD>"+
		            "<TD><INPUT class='Inputstyle' type='text' name='paramnames_nc'  value='pkcorp' _noMultiLang=true></TD>"+
					"<TD><INPUT class='Inputstyle' type='text' name='labelnames_nc'  value='<%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%>' _noMultiLang=true></TD>"+
		            "<TD class='maybelast'>"+
		            "<select name='paramtypes_nc' onchange='onTypeChange(this)' style='width:80px;'>"+
		               "<option value=0><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"+
		               "<option value=1><%=SystemEnv.getHtmlLabelName(20976,user.getLanguage())%></option>"+
		               "<option value=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>"+
		               "<option value=3><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option>"+
		               "<option value=4><%=SystemEnv.getHtmlLabelName(15636,user.getLanguage())%></option>"+
		               "<option value=5><%=SystemEnv.getHtmlLabelName(125424,user.getLanguage())%></option>"+
		            "</select>"+
		            "<span style='display:none;'>"+
		              "  &nbsp;&nbsp;<a style='color:#00B2FC;' href='#' onclick='setexpression(this);' ><%=SystemEnv.getHtmlLabelName(125420,user.getLanguage())%></a>&nbsp;&nbsp; "+
		            "</span>"+
		            "<span style='display:inline-block;'>"+
		               "<INPUT class='Inputstyle'   style='width:120px!important;' type='text' name='paramvalues_nc'  value='pkcorp' _noMultiLang=true>"+
		               "<SPAN class='e8tips' style='CURSOR: hand;display:none;'  title='<%=SystemEnv.getHtmlLabelName(125497,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></SPAN>"+
		            "</span>"+
		            
		            "<TD class='isencrypt'><INPUT class='Inputstyle' type='radio' tzCheckbox='true' name='paraencrypt_nc'  value='1'></TD>"+
		            "<TD class='encryptcode'><INPUT class='Inputstyle' type='text' name='encryptcode_nc'  value='pkcorp' _noMultiLang=true></TD>"+
		            "</TR>";
	group.addCustomRow(paramnctr);
    reshowCheckBox();
    changeEncryptType('');
    onChangeTypeFun('<%=typename%>');
    onInitTypeChange();
    jQuery(".optionhead").hide();
    jQuery(".tablecontainer").css("padding-left","0px");
});
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

function onChangeRequestType(obj){

//var radiovar=document.getElementsByName("urlencodeflag");
//alert(radiovar.length);
	if(obj == "GET") {  //get
	
	 jQuery("#urlencodeflag1").trigger("checked",true);
	  jQuery("#encodespan").show();
	 
	
    } else { 
	 jQuery("#urlencodeflag0").trigger("checked",true);
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
 }
 
 function changeautologinflag(){
  var checked = $("#autologinflag").attr("checked");
	
		if(!checked){
		$("#autologinspan").hide();	
		hideEle("networkview");
			
		} else {
			$("#autologinspan").show();	
			showEle("networkview");
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
var v=$(obj).val();

var encrypttype=jQuery("#encrypttype").val();
if(encrypttype==1){
if(v=="1"){
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
	openDialog2(url,title);
}
//新建子目录
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
      jQuery("#encryptclassId").selectbox("detach");
 	  __jNiceNamespace__.beautySelect("#encryptclassId");

}

	  
</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onBack();"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
			if(<%=select_att%>){
				jQuery("#typename").selectbox("disable");
			}else{
				jQuery("#typename").selectbox("enable");
			}
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>
