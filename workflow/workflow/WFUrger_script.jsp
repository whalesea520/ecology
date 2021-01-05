<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
 String ajax=Util.null2String(request.getParameter("ajax"));
 String rowsum = Util.null2String(request.getParameter("rowsum"));
%>
<%if(!ajax.equals("1")){%>

<script type="text/javascript">
//<!--

function onChangetypeByUrger(objval){
	if (objval==1){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==2 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==3) {
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==4 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if(objval==5){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==6){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==7){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==8){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
}
//-->
</script>
<script language=vbs>
sub onShowBrowserLevel(url,index,tmpindex)
	tmpid = "wflevel_"&index
	tmpname = "tempwflevel_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.wfurgerform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowserM(url,index,tmpindex)
	tmpid = "wfid_"&index
	tmpname = "wfname_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = mid(id(1),2,len(id(1)))
			document.all(tmpid).value=mid(id(0),2,len(id(0)))
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.wfurgerform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowser4s(wfid,formid,isbill)
    
	src=document.all("wffromsrc").value
	url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
            'document.all("wfconditions").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">"
			document.all("wfconditionss").value=id(0)
			document.all("wfconditions").innerHTML=id(1)
			document.all("wfconditioncn").value=id(1)
			document.all("wffromsrc").value="2"
		    else
			document.all("wfconditionss").value=""
			document.all("wfconditioncn").value=""
		   end if
	end if
    
end sub
sub changelevelByUrger(tmpindex)
		tmpindex.checked = true
        tmpid = tmpindex.id
        document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
        document.wfurgerform.selectvalue.value = tmpindex.value
end sub
</script>
<script language=javascript>
var rowColor="" ;
rowindex = <%=rowsum%>;

function setSelIndexByUrger(selindex, selectvalue) {
    document.wfurgerform.selectindex.value = selindex ;
    document.wfurgerform.selectvalue.value = selectvalue ;
}

function addRow()
{		
	for(i=0;i<50;i++){
		if(document.wfurgerform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
			case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
				if(document.all("wfid_"+i).value ==0 || document.all("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
				if(document.all("wfid_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 4:
            case 24:
			case 25:
			case 26:
			case 32:

				if(document.all("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames; 
			var k=1;
            if (i==3)  //露脿脠脣脕娄脳脢脭麓
			{
			var stmps = document.all("wfid_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = "";
			if($("#wfid_"+i+"span").children().length>0){
				$("#wfid_"+i+"span").find("a").each(function(index){
					if(index==0){
						sHtmls =$(this).html();
					}else{
						sHtmls +=","+$(this).html();
					}					
				});	
			}else{
				sHtmls = $G("wfid_"+i+"span").innerHTML;
			}
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{
			rowColor = getRowBg();
			ncol = oTable.cols;
			oRow = oTable.insertRow();
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell();
				oCell.style.height=24;
				oCell.style.background= rowColor;
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='wfcheck_node' value='0'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>";

						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

                        var rowtypevalue = document.wfurgerform.selectvalue.value ;
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						oCell.appendChild(oDiv1);
						break;
					case 2:
						if (i==3)
						var stmp=""+hrmids[m];
					    else
						var stmp = document.all("wfid_"+i).value;

						var oDiv = document.createElement("div");
						var sHtml = "";
						if(i>= 5 && i <= 21 || i == 27 || i == 31 || i == 30 || i==38 || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49){
							var srcList = document.all("wfid_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						}
						else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
							{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = document.all("wfname_"+i).innerHTML;
						  }
                        
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

						var oDiv2= document.createElement("div");
                         var stemp=stmp;
						var sHtml1 = "<input type='hidden'  name='group_"+rowindex+"_id' value='"+stmp+"'>";
						oDiv2.innerHTML = sHtml1;
						oCell.appendChild(oDiv2);
						break;
					case 3:
						var oDiv = document.createElement("div");

						var sval = "";
						var sval2 = "";
						var sHtml="";
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46){
							sval=document.all("wflevel_"+i).value;
							sval2 = document.all("wflevel2_"+i).value;
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }
						}
						if(i == 2 ){
							sval=document.all("wflevel_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
						}

						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex+"_level'  value='"+sval+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex+"_level2'  value='-1'>";
                        }
						oDiv3.innerHTML = sHtml1;
						oCell.appendChild(oDiv3);
                        break;
                    case 4:
						var oDiv = document.createElement("div");
						var sval = document.all("wfconditionss").value;
						var sval1 = document.all("wfconditioncn").value;
						while (sval.indexOf("'")>0)
						{
						sval=sval.replace("'","&#39");
						}
						while (sval1.indexOf("'")>0)
						{
						sval1=sval1.replace("'","&#39");
						}
						var sHtml="<input type='hidden' name='group_"+rowindex+"_condition' value='"+sval+"'>";
						sHtml+=document.all("wfconditioncn").value;
						sHtml+="<input type='hidden' name='group_"+rowindex+"_conditioncn' value='"+sval1+"'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
				}
			}
			rowindex = rowindex*1 +1;
			}
			document.all("wffromsrc").value="1";
			document.all("wfconditionss").value="";
			document.all("wfconditioncn").value="";
			document.all("wfconditions").innerHTML="";
			
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}

function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='wfcheck_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='wfcheck_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

function selectall(this){
    for(var i=0; i<=rowindex; i++){
        if(document.all("group_"+i+"level")){
            alert(document.all("group_"+i+"level").value);
        }
    }
	document.forms[0].groupnum.value=rowindex;
	window.document.forms[0].submit();
    obj.disabled=true;
}

function ondelete(obj){
    if (isdel()) {
    obj.disabled=true;
    document.forms[0].src.value="delgroups";
    window.document.forms[0].submit();
  }
}
</script>
<%}else{%>
<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //禄帽碌脙麓掳驴脷碌脛麓鹿脰卤脦禄脰脙;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //禄帽碌脙麓掳驴脷碌脛脣庐脝陆脦禄脰脙;
function setSelIndexByUrger(selindex, selectvalue) {
    document.wfurgerform.selectindex.value = selindex ;
    document.wfurgerform.selectvalue.value = selectvalue ;
}

function onChangetypeByUrger(objval){
	if (objval==1){
		$("#odiv_urger_1").css("display","");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==2 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==3) {
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==4 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if(objval==5){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==6){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==7){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==8){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","");
	}
}

function changelevelByUrger(tmpindex) {
    tmpindex.checked = true;
    changeRadioStatus(tmpindex, true);
    tmpid = tmpindex.id;
    //wfurgerform.selectindex.value = Mid(tmpid, 9, len(tmpid));
    wfurgerform.selectindex.value = tmpid.substring(8);
    wfurgerform.selectvalue.value = tmpindex.value;
}

function onChangeJobField(obj){
	var tmpval = jQuery("select[name=wflevel_"+obj+"]").val();
	if(tmpval=="3"){
		jQuery("#relatedshareSpan_60").hide();
		jQuery("#relatedshareformSpan_60").show();
		jQuery("#relatedshareform_"+obj+"span").html("");
		jQuery("#relatedshareform_"+obj).val("");
		jQuery("#relatedshareform_"+obj+"spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	}
}

//岗位指定级别选择
function onChangeSharetype(obj){
	var tmpval = jQuery("select[name=wflevel_"+obj+"]").val();
	jQuery("#relatedshareSpan_"+obj).show();
	jQuery("#relatedshareSpan_"+obj).show();
	jQuery("#relatedshareformSpan_"+obj).hide();
	jQuery("#relatedshareid_"+obj+"span").html("");
	jQuery("#relatedshareid_"+obj).val("");
	jQuery("#relatedshareid_"+obj+"spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	if(tmpval=="2"){
		//jQuery("#relatedshareSpan").css("display","none");
		jQuery("#relatedshareSpan_"+obj).hide();
	}else if(tmpval=="3"){
		jQuery("#relatedshareSpan_"+obj).hide();
		jQuery("#relatedshareformSpan_"+obj).show();
		jQuery("#relatedshareform_"+obj+"span").html("");
		jQuery("#relatedshareform_"+obj).val("");
		jQuery("#relatedshareform_"+obj+"spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	}
	
}

//岗位指定级别浏览按钮
function onChangeResource(obj){
	var tmpval = jQuery("select[name=wflevel_"+obj+"]").val();
	var url = "";
	if (tmpval == "0") {
		url = onShowMutiDepartment(obj);
	}else if(tmpval=="1"){
	    url = onShowMutiSubcompany(obj);
	}else if(tmpval=="2"){
		jQuery("select[name=sharetype]").parent().find(".e8_os").hide();
	}else if(tmpval=="3"){
		var groupid = jQuery("select[name=wfid_"+obj+"]").val().split("_@@_")[1];
		var isbill = jQuery("select[name=wfid_"+obj+"]").val().split("_@@_")[2];
		var formid = jQuery("select[name=wfid_"+obj+"]").val().split("_@@_")[3];
		url = "/workflow/workflow/formFieldList.jsp?selectedids="+jQuery("#relatedshareid_"+obj).val()+"&groupid="+groupid+"&isbill="+isbill+"&formid="+formid;
	}
	return url;
}

function onShowMutiDepartment(obj) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?show_virtual_org=-1&selectedids="+jQuery("#relatedshareid_"+obj).val();
	return url;
}

function onShowMutiSubcompany(obj) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="+jQuery("#relatedshareid_"+obj).val();
	return url;
}

function getajaxurl(obj) {
	var tmpval = jQuery("select[name=wflevel_"+obj+"]").val();
	var url = "";	
	if (tmpval == "0") {
		url = "/data.jsp?type=4&show_virtual_org=-1";
	}else if (tmpval == "1") {
		url = "/data.jsp?type=194&show_virtual_org=-1";
	}	
	return url;
}

function onShowBrowsersByWFU(obj,rid,rformid,risbill){
	var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=4&formid="+rformid+"&isbill="+risbill+"&linkid="+rid+"&isnew=1";
	var rownum = 0;
	if(jQuery("#oTableByUrger").find("tr").length >0){
		rownum = jQuery("#oTableByUrger").find("tr:last").find("[name=wfcheck_node]").attr("rowindex");
		rownum = (parseInt(rownum)+1);
	}
	url+="&rownum="+rownum;
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(81953,user.getLanguage()) %>";
	dialog.Width = 850;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function callbackMeth(event,data,name,paras){
	if(name.indexOf("wfid_")==0){
		var tmpname=name.replace('wfid_','tmptype_');
		var obj=$("#"+tmpname);
		$("input[name='tmptype']").attr("checked",false).next().removeClass("jNiceChecked");
		obj.attr("checked",true).next().addClass("jNiceChecked");
	    $("input[name=selectindex]").val(obj.attr("id").substr(8));
	    $("input[name=selectvalue]").val(obj.val());
	}
}

function addRowByUrger()
{
    var rowindex4op = 0;
    var rows=document.getElementsByName('wfcheck_node');
    var len = document.wfurgerform.elements.length;
    var rowsum1 = 0;
    var obj;
    var relatedshareid;
    for(i=0; i < len;i++) {
		if (document.wfurgerform.elements[i].name=='wfcheck_node'){
			rowsum1 += 1;
            obj=document.wfurgerform.elements[i];
            }
    }

    if(rowsum1>0) {
    	rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }

    for(i=0;i<62;i++){

        if(document.wfurgerform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
            case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
			case 50:
				if($GetEle("wfid_"+i).value ==0 || $GetEle("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
			case 59://人力资源字段岗位
				if($GetEle("wfid_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");
					return;
				}
				break;

			case 4:
            case 24:
			case 25:
			case 26:
			case 32:

				if($GetEle("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");
					return;
				}
				break;
			case 58://岗位
			case 60://人力资源字段 下岗位属性
				relatedshareid = jQuery("#relatedshareid_"+i).val();
				var relatedshareform = jQuery("#relatedshareform_"+i).val();
				if((($G("wflevel_"+i).value != '2' && $G("wflevel_"+i).value != '3') && ( relatedshareid == '' || relatedshareid == null)) || $G("wfid_"+i).value ==0 || ($G("wflevel_"+i).value == '3' &&  ( relatedshareform == '' || relatedshareform == null))){
				//if(($G("wflevel_"+i).value != '2' && ( relatedshareid == '' || relatedshareid == null)) || $G("wfid_"+i).value ==0){
					Dialog.alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames;
            var jobids,jobnames;
			var k=1;
            if (i==3)  //露脿脠脣脕娄脳脢脭麓
			{
			var stmps = $G("wfid_"+i).value;
			if (stmps == null) {
				stmps = "";
			}
			hrmids=stmps.split(",");
			var sHtmls = "";
			if($("#wfid_"+i+"span").children().length>0){
				$("#wfid_"+i+"span").find("a").each(function(index){
					if(index==0){
						sHtmls =$(this).html();
					}else{
						sHtmls +=","+$(this).html();
					}					
				});	
			}else{
				sHtmls = $G("wfid_"+i+"span").innerHTML;
			}
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
            
            /*if (i==58)  //岗位
			 {
				var stmps = $G("wfid_"+i).value;
				jobids=stmps.split(",");
				var sHtmls = "";
				if(jQuery("#wfid_"+i+"span").children().length>0){
					jQuery("#wfid_"+i+"span").find("a").each(function(index){
						if(index==0){
							sHtmls =jQuery(this).html();
						}else{
							sHtmls +=","+jQuery(this).html();
						}					
					});	
				}else{
					sHtmls = $G("wfid_"+i+"span").innerHTML;
				}
				jobnames=sHtmls.split(",");
				k=jobids.length;
			}*/
            
			for (m=0;m<k;m++)
			{ rowColor = getRowBg();
			ncol = jQuery(oTableByUrger).attr("cols");
			oRow = oTableByUrger.insertRow(-1);
			
			$(oRow).attr('class','DataLight');
			
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				oCell.style.background= "#fff";

				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='wfcheck_node' value='0' rowindex="+rowindex4op+">";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>";
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>";
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%>";
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340, user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555, user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559, user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560, user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561, user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562, user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564, user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565, user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566, user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567, user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568, user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569, user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570, user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571, user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572, user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573, user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574, user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575, user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079, user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080, user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576, user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577, user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081, user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282, user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078, user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579, user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278, user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580, user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581, user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563, user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578, user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676, user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677, user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204, user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678, user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679, user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680, user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681, user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309, user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570, user.getLanguage())%>";
						if(i== 58 ){
							sHtml="<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
						}
						if(i== 59 ){
							sHtml="<%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
						}
						if(i== 60 ){
							sHtml="<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
						}
						if(i== 61 ){
							sHtml="<%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%>";
						}
                        oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

                        var rowtypevalue = document.wfurgerform.selectvalue.value ;

						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_type'  value='"+rowtypevalue+"'>";
						
						if($G("wflevel_"+i)){
							var jobval = $G("wflevel_"+i).value;
							if(jobval==0 || jobval==1){
								if($G("relatedshareid_"+i)){
									relatedshareid = $G("relatedshareid_"+i).value;
								}
							}else if(jobval==3){
								if($G("relatedshareform_"+i)){
									relatedshareid = $G("relatedshareform_"+i).value;
								}
							}
						}
						
						if(relatedshareid == null){
							relatedshareid="";
						}
						sHtml1 += "<input type='hidden' name='group_"+rowindex4op+"_jobfield'  value='"+relatedshareid+"'>";
						
						oDiv1.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv1);
						break;
					case 2:
					{
						var stmp="";

						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = $GetEle("wfid_"+i).value;
					    }

						var oDiv = document.createElement("div");
						var sHtml = "";
						if(i>= 5 && i <= 21 || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50){
							var srcList = $GetEle("wfid_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						} else if(i == 59 || i == 60){
							var sHtml = jQuery("select[name=wfid_"+i+"] option:selected").text();
						} else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39 || i == 61){
							sHtml = stmp;
						}
						else
					      {
							if (i==3)
							sHtml=hrmnames[m];
							else
								if(i==2 || i==58){
									if($("#wfid_"+i+"span").children().length>0){
										$("#wfid_"+i+"span").find("a").each(function(index){			
											if(index==0){
												sHtml =$(this).html();
											}else{
												sHtml +=","+$(this).html();
											}				
										});	
									}else{
										sHtml = $G("wfid_"+i+"span").innerHTML;
									}
								}else{
									if($("#wfid_"+i+"span").children().length>0){
										$("#wfid_"+i+"span").find("a").each(function(index){			
											if(index==0){
												sHtml =$(this).html();
											}else{
												sHtml +=","+$(this).html();
											}				
										});	
									}else{
										if($("#wfid_"+i+"span")){
											sHtml = $G("wfid_"+i+"span").innerHTML;
										}else{
											sHtml = $G("name_"+i).innerHTML;
										}
									}
									
								}	
						  }
						  if (i==50)  sHtml =sHtml+"/"+$GetEle("tempwflevel_"+i).innerHTML;
						if(sHtml=="")sHtml="&nbsp;"
						oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

						var oDiv2= document.createElement("div");

						var stemp=stmp;

						var sHtml1 = "<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";

						if(i==58){
                        	sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_id' value='0'>";
                        	sHtml1+="<input type='hidden'  name='group_"+rowindex4op+"_jobobj' value='"+stemp+"'>";
                        }else if(i==60){
                        	stemp = stemp.split("_@@_")[0];
                        	sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }
						
						oDiv2.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv2);
						break;
					}
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";

						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46||i == 42){
                            sval = $GetEle("wflevel_"+i).value;
                            sval2 = $GetEle("wflevel2_"+i).value;

                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						if (i==50)
							{
                            sval = $GetEle("wflevel_"+i).value;

							}
						if(i == 2 ){
							sval = $GetEle("wflevel_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%>";
						}
						if (i==58 || i==60){
							sval = $G("wflevel_"+i).value;
							
							var relatedsharename = "";
							if(sval==0 || sval==1){
								if(jQuery("#relatedshareid_"+i+"span").children().length>0){
									jQuery("#relatedshareid_"+i+"span").find("a").each(function(index){
										if(index==0){
											relatedsharename =jQuery(this).html();
										}else{
											relatedsharename +=","+jQuery(this).html();
										}					
									});	
								}else{
									relatedsharename = $G("relatedshareid_"+i+"span").innerHTML;
								}
							}else if(sval==3){
								if(jQuery("#relatedshareform_"+i+"span").children().length>0){
									jQuery("#relatedshareform_"+i+"span").find("a").each(function(index){
										if(index==0){
											relatedsharename =jQuery(this).html();
										}else{
											relatedsharename +=","+jQuery(this).html();
										}					
									});	
								}else{
									relatedsharename = $G("relatedshareform_"+i+"span").innerHTML;
								}
							}
							//alert("relatedsharename = "+relatedsharename);
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%>("+relatedsharename+")";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%>("+relatedsharename+")";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							if(sval==3)
								sHtml="<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%>("+relatedsharename+")";
		                }
						
						if (i==59 || i==61){
							sval = $G("wflevel_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%>";
							if(sval==3)
								sHtml="<%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%>";
							if(sval==4)
								sHtml="<%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%>";
							if(sval==5)
								sHtml="<%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%>";
							if(sval==6)
								sHtml="<%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%>";
		                }

						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex4op+"_level'  value='"+jQuery.trim(sval)+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='"+jQuery.trim(sval2)+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='-1'>";
                        }

						oDiv3.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv3);
						break;

						case 4:
						var oDiv = document.createElement("div");
						var sval = $GetEle("wfconditionss").value;
						var sval1 = $GetEle("wfconditioncn").value;
						var sval2= $GetEle("rulemaplistids").value;
						while (sval.indexOf("'")>0)
						{
						sval=sval.replace("'","&#39;");
						}
						
						sval1 = sval1.replace(new RegExp("'","gm"),"&#39;");
						//if(sval1=="")sval1="&nbsp;";
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_condition' value='"+jQuery.trim(sval)+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_conditioncn' value='"+jQuery.trim(sval1)+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_rulemaplistids' value='"+jQuery.trim(sval2)+"'>";
						sHtml+=sval1;
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
			rowindex4op = rowindex4op*1 +1;
			}
			$GetEle("wffromsrc").value="1";
			$GetEle("wfconditionss").value="";
			$GetEle("wfconditioncn").value="";
			$GetEle("rulemaplistids").value ="";
			$GetEle("wfconditions").innerHTML="";
			jQuery("body").jNice();
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584, user.getLanguage())%>!");

}


function deleteRowByUrger(){
	var obj=$("input[name='wfcheck_node']:checked");
	if(obj.size()==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	}else{
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
			obj.each(function(){
				$(this).closest("tr").remove();
			});
		});
	}
}

function wfurgersave(obj){
        var rowindex4op = 0;
        var rowsum1 = jQuery("input[name=wfcheck_node]").length;
        if (rowsum1 > 0) {
            var obj=jQuery("input[name=wfcheck_node]")[rowsum1-1];
            var rowindex=jQuery(obj).attr("rowindex");
            rowindex4op = parseInt(rowindex) + 1;
        }
        wfurgerform.groupnum.value = rowindex4op;

        obj.disabled = true;
        wfurgerform.submit();
}
</script>
<%} %>
