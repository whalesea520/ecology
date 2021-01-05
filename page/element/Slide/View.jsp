<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%

	String sql2=" select name,value from hpelementSetting where eid="+eid;
	rs.execute(sql2);
	String[] colNames=rs.getColumnName();
	HashMap values=new HashMap();
	if(rs.getCounts()<=0){

	}else{
		while(rs.next()){
			values.put(rs.getString(colNames[0]),rs.getString(colNames[1]));
		}

		String showType=Util.null2String(values.get("slide_t_picShow"));

		String sql1="select * from slideelement where eid="+eid;
		rs.execute(sql1);
		ArrayList iconImgList=new ArrayList();
		ArrayList iconImg_overList=new ArrayList();
		ArrayList bigImage=new ArrayList();
		String bigImageArea="";
		int i=0;
		while(rs.next()){
			iconImgList.add("'"+rs.getString("url2")+"'");
			iconImg_overList.add("'"+rs.getString("url3")+"'");
			String link = (String)rs.getString("link");
			link = link.equals("")?"void(0);":"window.open('"+link+"')";
			if(showType.equals("normal")){
				bigImageArea+="<div class=slideDiv index="+i+"  alt='"+rs.getString("title")+"...' "+
						"style=\"background:url('"+"') no-repeat;cursor: pointer;\"><img onclick=\"javascript:"+link+"\" src=\""+rs.getString("url1")+"\"  />"
						+"<div class='slideDiv' onclick=\"javascript:"+link+";\" style='cursor: pointer;'></div></div>";
			}else{
				bigImageArea+="<div class='slideDiv' index="+i+"  alt='"+rs.getString("title")+"...' "+
						"style=\"background:url('"+"') no-repeat;cursor: pointer;width:100%;height:100%;\"><img onclick=\"javascript:"+link+"\" src=\""+rs.getString("url1")+"\"  style='width:100%;height:100%;'/>"
						+"<div class='slideDiv' onclick=\"javascript:"+link+";\" style='cursor: pointer;'></div></div>";
			}
			i++;

		}

%>


<script>

    $(function() {
        var iconImgList=<%=iconImgList.toString()%>;
        var iconImg_overList=<%=iconImg_overList.toString()%>;

        $('#slideArea_<%=eid%> .slideContinar').cycle({  //turnUp   //fade  //uncover
            fx:      '<%=values.get("slide_t_changeStyle")%>',  //blindX     * blindY    * blindZ    * cover    * curtainX    * curtainY    * fade    * fadeZoom    * growX    * growY    * none   * scrollUp    * scrollDown    * scrollLeft    * scrollRight    * scrollHorz    * scrollVert    * shuffle    * slideX    * lideY   * toss    * turnUp    * turnDown    * turnLeft    * turnRight    * uncover    * wipe    * zoom*/
            timeout:  <%=Util.getIntValue((String)values.get("slide_t_AutoChangeTime")) %>,
            //speed: <%=Util.getIntValue((String)values.get("slide_t_ChangeTime")) %>,
            pager:   '#slideArea_<%=eid%> .slideTitleNavContainer',
            pagerAnchorBuilder: pagerFactory,
            before:        function(currSlideElement, nextSlideElement, options, forwardFlag) {
                var nextIndex=$(nextSlideElement).attr("index");
                var slidnavtitleArray=$("#slideArea_<%=eid%> .slidnavtitle");
                var newTop=0;
                var newLeft=0;
                if(slidnavtitleArray.length==0){

                } else {
                    var nextSlidnavtitle=$($("#slideArea_<%=eid%> .slidnavtitle")[nextIndex]);
                    newTop=nextSlidnavtitle.position().top;
                    newLeft=nextSlidnavtitle.position().<%=values.get("slide_t_position").equals("2")?"right":"left"%>;
                }

                $("#slideArea_<%=eid%> .slideTitleFloat").css({
                    "display":"block",
                    <%if(values.get("slide_t_position").equals("3")){%>
                    top :newTop-10,
                    <%}else{%>
                    top :newTop,
                <%}%>
                <%=values.get("slide_t_position").equals("2")?"right":"left"%>:newLeft,
                    <%if(showType.equals("normal")){%>
                    "background":"url('"+iconImg_overList[nextIndex]+"') no-repeat",
                    <%}else{%>
                    "background":"url('"+iconImg_overList[nextIndex]+"') no-repeat",
                    "background-size":"100% 100%"
                <%}%>

            });

            },
            fit:1,
            <%if(showType.equals("normal")){%>
            width:'100%',
            height:'100%'
            <%}else{%>
            width:"100%"
            <%}%>
        });

        $('#slideArea_<%=eid%>  .slideContinar').addClass("slideritem");
        $('#slideArea_<%=eid%>  .slideContinar').css("width","100%");
        $('#slideArea_<%=eid%>  .slideContinar').css("overflow","hidden");

        $('#content_view_id_<%=eid%>').css("overflow","hidden");

        function pagerFactory(idx, slide) {
            <%if(values.get("slide_t_position").equals("3")){%>
            var s = idx > 3 ? ' style="display:true"' : '';
            <%}else{%>
            var s = idx > 3 ? ' style="display:none"' : '';
            <%}%>
            <%if(showType.equals("normal")){%>
            return '<div '+s+' class="slidnavtitle"  style="background:url('+iconImgList[idx]+') no-repeat;">&nbsp;</div>';
            <%}else{%>
            return '<div '+s+' class="slidnavtitle"  style="background:url('+iconImgList[idx]+') no-repeat;background-size:100% 100%;">&nbsp;</div>';
            <%}%>
        };

        <%if(values.get("slide_t_position").equals("3")){%>
        $("#slideArea_<%=eid%>").find(".slideTitleNavContainer").css({
            "margin":"0 auto"
        });
        $("#slideArea_<%=eid%>   .slideTitleFloat").css({
            "margin":"0 auto",
            "top":10+Math.round($(".slideTitleFloat").offset().top)+"px"
        });
        <%}%>



        $('#slideArea_<%=eid%>  .slideTitle').css("z-index","1001");
        $('#slideArea_<%=eid%>  .slideTitle').css("position","relative");
        <% if("1".equals(values.get("slide_t_position"))){%>
        $('#slideArea_<%=eid%>  .slideTitle').css("width","150px");
        $('#slideArea_<%=eid%>  .slideTitle').css("float","left");
        <%}
     if("2".equals(values.get("slide_t_position"))){
     %>
        $('#slideArea_<%=eid%>  .slideTitle').css("width","150px");
        $('#slideArea_<%=eid%>  .slideTitle').css("float","right");
        <%}if("3".equals(values.get("slide_t_position"))){%>
        $('#slideArea_<%=eid%>  .slideTitle').css("height","40px");
        $('#slideArea_<%=eid%>  .slideTitle').css("padding-top","10px");
        $('#slideArea_<%=eid%>  .slideTitle').css("text-align","center");
        <%}%>

        var  slidnavtitle=  $('#slideArea_<%=eid%>  .slideTitle  .slidnavtitle');
        slidnavtitle.css("cursor","pointer");
        <%if("3".equals(values.get("slide_t_position"))){%>
        slidnavtitle.css("margin-right","5px");
        slidnavtitle.css("height","40px");
        slidnavtitle.css("width","75px");
        slidnavtitle.css("float","left");
        <%}else{%>
        slidnavtitle.css("height","40px");
        <%}%>

        var  slidnavtitle=  $('#slideArea_<%=eid%>  .slideTitleFloat');
        slidnavtitle.css("position","absolute");
        slidnavtitle.css("display","none");
        <%if("3".equals(values.get("slide_t_position"))){%>
        slidnavtitle.css("height","40px");
        slidnavtitle.css("width","79px");
        <%}else{%>
        slidnavtitle.css("height","40px");
        slidnavtitle.css("width","165px");
        <%}%>



        var  slideContinar=  $('#slideArea_<%=eid%>  .slideContinar');
        slideContinar.css("padding","0");
        slideContinar.css("overflow","hidden");
        slideContinar.css("table-layout","fixed");
        slideContinar.css("width","auto");
        slideContinar.css("margin","0");
        <% if("3".equals(values.get("slide_t_position"))){%>
        slideContinar.css("height","220px");
        <%}else{%>
        slideContinar.css("height","160px");
        <%}%>

        <%if(!showType.equals("normal")){%>
        var DivH =  "160px";
        var  slideDiv=  $('#slideArea_<%=eid%>  .slideContinar .slideDiv');
        slideContinar.css("width","100%");
        <% if("3".equals(values.get("slide_t_position"))){%>
        slideDiv.css("height","220px");
        DivH =  "220px";
        <%}else{%>
        slideDiv.css("height","160px");
        <%}%>
        $('#slideArea_<%=eid%>  .slideContinar .slideDiv').find('img').css("height",DivH);
        <%}%>


        var slideTitleNavContainer=$("#slideArea_<%=eid%>").find(".slideTitleNavContainer");
        <% if("3".equals(values.get("slide_t_position"))){%>
        slideTitleNavContainer.css("display","inline-block");
        slideTitleNavContainer.css("_display","block");
        <%}%>



    });
</script>

<table style="width:100%;height:165px;table-layout: fixed;" id="slideArea_<%=eid%>" border="0" cellspacing="0" cellpadding="0" >

	<%if("1".equals(values.get("slide_t_position"))){ %>
	<colgroup>
		<col width="150px"/>
		<col width="100%"/>
	</colgroup>
	<tr>
		<td style="width:150px;">
			<div class="slideTitle">
				<div class="slideTitleFloat"></div>
				<DIV class="slideTitleNavContainer" ></DIV>
			</div>
		</td>
		<td  width="*">
			<div  class="slideContinar" style="cursor: pointer;">
				<%=bigImageArea %>
			</div>
		</td>
	</tr>
	<%} else if("2".equals(values.get("slide_t_position"))){ %>
	<colgroup>
		<col width="100%"/>
		<col width="150px"/>

	</colgroup>
	<tr>
		<td width="*">
			<div  class="slideContinar" style="cursor: pointer;">
				<%=bigImageArea %>
			</div>
		</td>
		<td style="width:150px;">
			<div class="slideTitle">
				<div class="slideTitleFloat"></div>
				<DIV class="slideTitleNavContainer" ></DIV>
			</div>
		</td>
	</tr>
	<%}else{%>
	<tr>
		<td>
			<div  class="slideContinar" style="cursor: pointer;">
				<%=bigImageArea %>
			</div>
		</td>
	</tr>
	<tr>
		<td >
			<div class="slideTitle">
				<div class="slideTitleFloat"></div>
				<DIV class="slideTitleNavContainer" ></DIV>
			</div>
		</td>
	</tr>
	<%} %>
</table>
<%}%>
