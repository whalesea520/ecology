
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.category.security.AclManager,
                 weaver.docs.category.CategoryTree,
                 weaver.docs.category.CommonCategory" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(73,user.getLanguage());
String needfav ="1";
String needhelp ="";
String  saved=Util.null2String(request.getParameter("saved"));
%>
<script language=javascript>
function onLoad(){
    if(<%=(saved.equals("true")?"true":"false")%>){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!");
    }
}
</script>
<BODY onload="onLoad()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
int userid=0;
userid=user.getUID();
String logintype = user.getLogintype();
String usertype="";
if(logintype.equals("1"))
     usertype = "0";
if(logintype.equals("2"))
     usertype = "1";
char flag=2;

UserDefaultManager.setUserid(userid);
UserDefaultManager.selectUserDefault();
ArrayList selectArr=UserDefaultManager.getSelectedcategory();
String useUnselected = UserDefaultManager.getUseunselected();
int numperpage=UserDefaultManager.getNumperpage();
String commonuse = UserDefaultManager.getCommonuse();
%>
<FORM id=weaver name=frmmain action="DocUserDefaultOperation.jsp" method=post >
<input type="hidden" name="id" value=<%=UserDefaultManager.getId()%>>
<input type="hidden" name="useUnselected" value="true">
<wea:layout attributes="{'cw1':'50%','cw2':'50%'}">
  <wea:group context='<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>'>
	<wea:item>
	  <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>
	  <input type="text" style="width:100px;" class=InputStyle  id="numperpage"name="numperpage" value=<%=numperpage%> size="3" maxlength=2 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
	  <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
	</wea:item>
	<wea:item>
	  <input type="checkbox" name="commonuse" value="1" <%if(!commonuse.equals("-1")){%>checked <%}%>>
	  <%=SystemEnv.getHtmlLabelName(28183,user.getLanguage())%>
	  
	</wea:item>
 </wea:group>
  <%
      ArrayList mainids=new ArrayList();
      ArrayList subids=new ArrayList();
      ArrayList secids=new ArrayList();

      AclManager am = new AclManager();
      CategoryTree tree = am.getPermittedTree(user, AclManager.OPERATION_CREATEDOC);
      Vector alldirs = tree.allCategories;
      for (int i=0;i<alldirs.size();i++) {
          CommonCategory temp = (CommonCategory)alldirs.get(i);
          if (temp.type == AclManager.CATEGORYTYPE_MAIN) {
              mainids.add(Integer.toString(temp.id));
          } else if (temp.type == AclManager.CATEGORYTYPE_SEC) {
              secids.add(Integer.toString(temp.id));
              if (subids.indexOf(Integer.toString(temp.superiorid)) == -1) {
                  subids.add(Integer.toString(temp.superiorid));
              }
          }
      }


      //RecordSet.executeProc("DocUserCategory_SMainByUser",""+userid+flag+usertype);
      //while(RecordSet.next()){
      //    mainids.add(RecordSet.getString("mainid"));
      //}
      //RecordSet.executeProc("DocUserCategory_SSubByUser",""+userid+flag+usertype);
      //while(RecordSet.next()){
      //    subids.add(RecordSet.getString("subid"));
      //}
  %>

  <wea:group context='<%=SystemEnv.getHtmlLabelName(65,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(66,user.getLanguage())%>'>
	  <%
		int maincate = mainids.size();
		int rownum = maincate/2;
		if((maincate-rownum*2)!=0)  rownum=rownum+1;
	  %>
	  <wea:item attributes="{'isTableList':'true'}">
			<wea:layout type="4col" needImportDefaultJsAndCss="false" attributes="{'formTableId':'treeTable'}">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item attributes="{'colspan':'half','isTableList':'true'}">
							<wea:layout needImportDefaultJsAndCss="false">
								<wea:group context="" attributes="{'groupDisplay':'none'}">
									<%
								int needtd=rownum;
								for(int i=0;i<mainids.size()/2;i++){
									String mainid = (String)mainids.get(i);
									String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
									needtd--;
								%>
										<wea:item attributes="{'colspan':'full'}">
										  <%if(useUnselected.equals("true")){ %>
											  <% if(selectArr.size()==0||selectArr.indexOf("M"+mainid)!=-1){%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
											  <%}%>
										  <%}else{ %>
											  <% if(selectArr.indexOf("M"+mainid)==-1){%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
											  <%}%>
										  <%} %>
										  <b><%=mainname%></b> 
										</wea:item>
									<%
										for(int j=0;j<subids.size();j++){
											String subid = (String)subids.get(j);
											String subname=SubCategoryComInfo.getSubCategoryname(subid);
											String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
											if(!curmainid.equals(mainid)) continue;
									%>
									  <wea:item>&nbsp;</wea:item>
									  <%System.out.println(j==subids.size()-1);%>
									  <wea:item>
										  <%if(useUnselected.equals("true")){ %>
											  <% if(selectArr.size()==0||selectArr.indexOf("S"+subid)!=-1){%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
											  <%}%>
										  <%}else{ %>
											  <% if(selectArr.indexOf("S"+subid)==-1){%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
											  <%}%>
										  <%} %>
										  <%=subname%>
									  </wea:item>
									<%
										}
									%>
								<%
								}
								%>
							</wea:group>
						</wea:layout>
					</wea:item>
					<wea:item attributes="{'isTableList':'true'}">
							<wea:layout needImportDefaultJsAndCss="false" attributes="{'formTableId':'treeTable'}">
								<wea:group context="" attributes="{'groupDisplay':'none'}">
									<%
								int needtd=rownum;
								for(int i=mainids.size()/2;i<mainids.size();i++){
									String mainid = (String)mainids.get(i);
									String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
									needtd--;
								%>
										<wea:item attributes="{'colspan':'full'}">
										  <%if(useUnselected.equals("true")){ %>
											  <% if(selectArr.size()==0||selectArr.indexOf("M"+mainid)!=-1){%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
											  <%}%>
										  <%}else{ %>
											  <% if(selectArr.indexOf("M"+mainid)==-1){%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="m<%=mainid%>" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
											  <%}%>
										  <%} %>
										  <b><%=mainname%></b> 
										</wea:item>
									<%
										for(int j=0;j<subids.size();j++){
											String subid = (String)subids.get(j);
											String subname=SubCategoryComInfo.getSubCategoryname(subid);
											String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
											if(!curmainid.equals(mainid)) continue;
									%>
									  <wea:item>&nbsp;</wea:item>
									  <%System.out.println(j==subids.size()-1);%>
									  <wea:item>
										  <%if(useUnselected.equals("true")){ %>
											  <% if(selectArr.size()==0||selectArr.indexOf("S"+subid)!=-1){%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
											  <%}%>
										  <%}else{ %>
											  <% if(selectArr.indexOf("S"+subid)==-1){%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')">
											  <%} else {%>
											  <input type="checkbox" id="s<%=mainid%>" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
											  <%}%>
										  <%} %>
										  <%=subname%>
									  </wea:item>
									<%
										}
									%>
								<%
								}
								%>
							</wea:group>
						</wea:layout>
					</wea:item>
		</wea:group>
	</wea:layout>
	</wea:item>
  </wea:group>
</wea:layout>
</form>

<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</style>
<div id="loading">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>
<script>
function checkMain(id) {
var mainchecked=document.getElementById("m"+id).checked ;
var checkboxs = jQuery("#treeTable").find("input[name='s"+id+"']");
 checkboxs.each(function(){
	changeCheckboxStatus(this,mainchecked);
 });
}

function checkSub(id) {
var checkboxs = jQuery("#treeTable").find("input[name='s"+id+"']:checked");
if(checkboxs>0){
	changeCheckboxStatus(document.getElementById("m"+id),true);
}
changeCheckboxStatus(document.getElementById("m"+id),false);
}

function onSave(){
    if(document.getElementById("numperpage").value != ""&& document.getElementById("numperpage").value*1<=0 ){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83440,user.getLanguage())%>");
        return;
    }

    jQuery("#allContent").hide();
	jQuery("#loading").show();
    if(jQuery("#treeTable").find("input:checked").length>0){
    	
	    jQuery("#treeTable").find("input[type=checkbox]").each(function(){
			//alert($(this).attr("checked"))
			$(this).attr("checked",!$(this).attr("checked"))
	    })
    }
    frmmain.submit();
}
</script>
</body>
</html>
