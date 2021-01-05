
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

String styleid =Util.null2String(request.getParameter("styleid"));
String titlename = SystemEnv.getHtmlLabelName(22914,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());

%>




<html>
 <head>
	<!--Base Css And Js-->
   	<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
	<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>
	<link href="/js/jquery/plugins/menu/menuh/menuh_wev8.css" type="text/css" rel=stylesheet>

	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
	
	<!--For Menu-->
	<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuh/menuh_wev8.js"></script>


	<style id="styleMenu">
	<%=mhsc.getCss(styleid)%>
	</style>
 </head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width="100%">
	<tr style="height:30px;"><td colspan="1"></td></tr>
	<tr>
		<td width="100%">
		<div style="width:95%;height:100%;position:relative;" id="divPreview">
			<fieldset> 
			<legend><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></legend> 
				<div class="menuhContainer" id="menuhContainer" cornerTop='<%=mhsc.getCornerTop(styleid) %>'  cornerTopRadian='<%=mhsc.getCornerTopRadian(styleid) %>'  cornerBottom='<%=mhsc.getCornerBottomRadian(styleid) %>'  cornerBottomRadian='<%=mhsc.getCornerBottomRadian(styleid) %>'>
				<span id="menuh" class="menuh" >	
					<ul>
						<li><a href="#"   class="main">Menu1</a></li>
						<li><a href="#" class="main">Menu2</a><ul>
						  <li><a href="#" class="sub">Menu2-1</a></li>
						  <li><a href="#" class="sub">Menu2-2</a><ul>
							<li><a href="#" class="sub">Menu2-2-1</a></li>
							<li><a href="#" class="sub">Menu2-2-2</a></li>												
							<li><a href="#" class="sub">Menu2-2-3</a></li>
							</ul>
						  </li>
						  </ul>
						</li>
						<li ><a href="#" class="main">Menu3</a></li>
					</ul>
					<br style="clear: left" />
				</span>
				</div>
			</fieldset> 
		</div>										
		<div style="clear:both"></div>	
		</td>
	</tr>
</table>
</body>
</html>


<script language="javascript">
		$(document).ready(function(){	
			menuh.arrowimages.down[1]="<%=mhsc.getIconMainDown(styleid)%>";
			menuh.arrowimages.right[1]="<%=mhsc.getIconSubDown(styleid)%>";

			menuh.init({
				mainmenuid: "menuh", 
				contentsource: "markup"
			})
			
			$('.radian').each(function(){
				var cValue="";
				if(this.name=="cornerTopRadian"){
					cValue="<%=mhsc.getCornerTopRadian(styleid)%>"
				} else if(this.name=="cornerBottomRadian"){
					cValue="<%=mhsc.getCornerBottomRadian(styleid)%>"
				} 

				this.value=cValue;
				$(this).bind("blur",function(){
					var prevObj=this.previousSibling.previousSibling.previousSibling ;		
							
					if(prevObj.value=="Right") { //直角
						$("."+(prevObj.parentNode.r_id)).uncornerById(prevObj.loc); 
						
					} else { //圆角
						$("."+(prevObj.parentNode.r_id)).uncornerById(prevObj.loc); 						
						$("."+(prevObj.parentNode.r_id)).corner("Round "+prevObj.loc+" "+this.value,prevObj.loc); 
					}			
				});	
			});
			
			$(".corner").each(function(){
				var cornerTop="<%=mhsc.getCornerTop(styleid)%>"
				var cornerBottom="<%=mhsc.getCornerBottom(styleid)%>"					
				
				var r_id=this.r_id;
				var cValue="";
				var cPos="";		
				if(this.pos=="top") {
					cValue=cornerTop;
					cPos="top";
				} else {
					cValue=cornerBottom;
					cPos="bottom";
				}
				for(var i=0;i<this.children.length;i++){		
					var child=this.children[i];		
					//alert(child);
					$(child).bind("click",function(){	
						if(this.checked){
							if(this.value=="Right") { //直角
								$("."+r_id).uncornerById(cPos); 
								
							} else { //圆角
								$("."+r_id).uncornerById(cPos); 
								var cValueRadian=$(this).parent().children("INPUT.radian").val();
								//alert(cValueRadian);
								//alert(r_id)
								$("."+r_id).corner(" "+this.value+" "+cPos+" "+cValueRadian,cPos); 
							}
						}					
					});
					if(child.value==cValue){
						child.checked=true;
						$(child).trigger("click");
					}
				}
			});

			  
		});	
		/*当主菜单和子菜单的图标发生更改时，处理图标的是否显示判断*/
		  $(".downarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".downarrowclass").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		  
		  $(".rightarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".rightarrowclass").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		
		window.onscroll=function(){
			$("#divPreview").css("top",document.body.scrollTop);
		};
		
		function onBack(){
			location.href='/page/maint/style/MenuStyleList.jsp';
		}	
	</script>
