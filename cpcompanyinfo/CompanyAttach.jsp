<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<%
	if(!cu.canOperate(user,"3"))//不具有入口权限
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}	
	String directory="";
	String luji="";	
	//select * from mytrainaccessoriestype where accessoriesname='lmdirectors'"
	//select * from mytrainaccessoriestype where accessoriesname='lmlic4ense'
	//select * from mytrainaccessoriestype where accessoriesname='lmconstitution'
	//select * from mytrainaccessoriestype where accessoriesname='lmshare'
	String [] list_road=new String[4];
	String [] list_roadDesc=new String[4];
	//查出这条配置数据
	String sql="select * from  mytrainaccessoriestype where  accessoriesname in('lmdirectors','lmlicense','lmconstitution','lmshare') ";
	RecordSet.execute(sql);
	while(RecordSet.next()){
		String mainid="";
		String subid="";
		String secid="";
		String accessoriesname="";
		mainid=RecordSet.getString("mainid");
		subid=RecordSet.getString("subid");
		secid=RecordSet.getString("secid");
		accessoriesname=RecordSet.getString("accessoriesname");
		luji=mainid+";"+subid+";"+secid;
		directory="/"+MainCCI.getMainCategoryname(mainid)+"/"+SubCCI.getSubCategoryname(subid)+"/"+SecCCI.getSecCategoryname(secid);
		if("///".equals(directory)){
			directory="";
		}
		if("lmdirectors".equals(accessoriesname)){
				//懂事会
				list_road[0]=luji;
				list_roadDesc[0]=directory;
		}else if("lmlicense".equals(accessoriesname)){
				//公司证照
				list_road[1]=luji;
				list_roadDesc[1]=directory;
		}else if("lmconstitution".equals(accessoriesname)){
			   //章程
				list_road[2]=luji;
				list_roadDesc[2]=directory;
		}else if("lmshare".equals(accessoriesname)){
				//股东
				list_road[3]=luji;
				list_roadDesc[3]=directory;	
		}
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(30985,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30986,user.getLanguage())+",javascript:dosave_gd(),_self} " ;    
	RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<body oncontextmenu="return false;" >	
	<FORM id=frmMain  name=frmMain action="/cpcompanyinfo/CompanyServiceOperate.jsp" method=post >
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
			<col width="10">
			<col width="">
			<col width="10">
			<tr>
			<td height="10" colspan="3"></td>
			</tr>
			<tr>
			<td ></td>
			<td valign="top">
			<TABLE class=Shadow>
			<tr>
			<td valign="top">
					<input type="hidden" name=temp_type   id="temp_type" value="CompanyAttach">
					<TABLE class=viewform  id="webTable2gd">
					  <COLGROUP>
					  <COL width="20%">
					   <COL width="80%">
					  <TBODY>
					  <TR class=spacing style="height:1px;">
					    <TD class=line1 colSpan=2></TD></TR>
					    
					  	
					    
					      		 <tr>
									<td class=Field> 
										<%=SystemEnv.getHtmlLabelName(30936,user.getLanguage()) %>
								</td> 
								<td> 
									<BUTTON class="Browser" id="selectannexCategoryid" onClick="onShowAnnexCatalog(this)"></BUTTON>		
									<span _spanid="lmdirectors">
											<%out.println(list_roadDesc[0]);%>
									</span>
									<input type="hidden"  value="<%=list_road[0]%>">
								</td> 
								</tr>
								<TR style='height:1px;'><TD class=Line colSpan=2></TD></TR>
								
								
								
								 <tr>
									<td class=Field> 
										<%=SystemEnv.getHtmlLabelName(30958,user.getLanguage()) %>
								</td> 
								<td> 
									<BUTTON class="Browser" id="selectannexCategoryid" onClick="onShowAnnexCatalog(this)"></BUTTON>		
									<span _spanid="lmlicense">
											<%out.println(list_roadDesc[1]);%>
									</span>
									<input type="hidden"  value="<%=list_road[1]%>">
								</td> 
								</tr>
								<TR style='height:1px;'><TD class=Line colSpan=2></TD></TR>
								
								
								<tr>
									<td class=Field> 
										<%=SystemEnv.getHtmlLabelName(30940,user.getLanguage()) %>
								</td> 
								<td> 
									<BUTTON class="Browser" id="selectannexCategoryid" onClick="onShowAnnexCatalog(this)"></BUTTON>		
									<span _spanid="lmconstitution">
											<%out.println(list_roadDesc[2]);%>
									</span>
									<input type="hidden"  value="<%=list_road[2]%>">
								</td> 
								</tr>
								<TR style='height:1px;'><TD class=Line colSpan=2></TD></TR>
									<tr>
									<td class=Field> 
										<%=SystemEnv.getHtmlLabelName(28421,user.getLanguage()) %>
								</td> 
								<td> 
									<BUTTON class="Browser" id="selectannexCategoryid" onClick="onShowAnnexCatalog(this)"></BUTTON>		
									<span _spanid="lmshare">
											<%out.println(list_roadDesc[3]);%>
									</span>
									<input type="hidden"  value="<%=list_road[3]%>">
								</td> 
								</tr>
								<TR style='height:1px;'><TD class=Line colSpan=2></TD></TR>
					 </TBODY>
					 </TABLE>
			</td>
			</tr>
			</TABLE>
			</td>
			<td></td>
			</tr>
			<tr>
			<td height="10" colspan="3"></td>
			</tr>
			</table>
	</form>			
			
	<script type="text/javascript">
		// {tag:"1",id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,path2:""+parth2};
		function onShowAnnexCatalog(obj) {
			var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
			if (result != null) {
				if (result.id > 0)  {
					$(obj).next().html(result.path);
					$(obj).next().next().val(result.mainid+";"+result.subid+";"+result.id);
				}else{
					$(obj).next().html("");
					$(obj).next().next().val("0;0;0");
				}
			}
		}
		function dosave_gd(){
			 var lmdirectors;
			 var lmlicense;
			 var lmconstitution;
			 var lmshare;
			$("span[_spanid='lmdirectors']").each(function(){
					lmdirectors=$(this).next().val()
			});	
			$("span[_spanid='lmlicense']").each(function(){
					lmlicense=$(this).next().val()
			});	
			$("span[_spanid='lmconstitution']").each(function(){
					lmconstitution=$(this).next().val()
			});	
			$("span[_spanid='lmshare']").each(function(){
					lmshare=$(this).next().val()
			});	
			var o4params = {
				lmdirectors:lmdirectors,
				lmlicense:lmlicense,
				lmconstitution:lmconstitution,
				lmshare:lmshare,
				temp_type:$("#temp_type").val()
			}
			$.post("/cpcompanyinfo/CompanyServiceOperate.jsp",o4params,function(data){
					alert(data);
			});
		}
	</script>

</body>
</html>
<BODY>