
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String nodetype=Util.null2String(request.getParameter("nodetype"));
%>

<!-- 
<script language=vbs>
sub onShowBrowser4opM(url,index,tmpindex)
	tmpid = "id_"&index
	tmpname = "name_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = mid(id(1),2,len(id(1)))
			document.all(tmpid).value=mid(id(0),2,len(id(0)))
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
</script>

-->

<script type="text/javascript">
function onShowBrowser4opM(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "id_"+index+"span";
	datas = window.showModalDialog(url + "?resourceids=," + $G(tmpid).value);
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html("<a href='#"+datas.id.substr(1)+"'>"+datas.name.substr(1)+"</a>");
			
			$("input[name="+tmpid+"]").val(datas.id.substr(1));
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}
</script>

<script language=vbs>
sub onChangetype(objval)
	if objval=1 then
		odiv_1.style.display=""
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=2 then
		odiv_1.style.display="none"
		odiv_2.style.display=""
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=3 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display=""
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=4 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display=""
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=5 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display=""
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=6 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display=""
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=7 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display=""
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=8 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display=""
        odiv_9.style.display="none"
	end if
    if objval=9 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display=""
	end if

end sub

sub onShowBrowser(url,index,tmpindex)
	tmpid = "id_"&index
	tmpname = "name_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub


sub onShowBrowserLevel(url,index,tmpindex)
tmpid = "level_"&index
	tmpname = "templevel_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub

sub onShowBrowser4opLevel(url,index,tmpindex)
	tmpid = "level_"&index
	tmpname = "templevel_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub


sub onShowBrowserM(url,index,tmpindex)
	tmpid = "id_"&index
	tmpname = "name_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = mid(id(1),2,len(id(1)))
			document.all(tmpid).value=mid(id(0),2,len(id(0)))
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowser4s(wfid,formid,isbill)
    
 
	src=document.all("fromsrc").value
	url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
            'document.all("conditions").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">"
			document.all("conditionss").value=id(0)
			document.all("conditions").innerHTML=id(1)
			document.all("conditioncn").value=id(1)
			document.all("fromsrc").value="2"
		    else
            document.all("conditions").innerHTML=""
			document.all("conditionss").value=""
			document.all("conditioncn").value=""
		   end if
	end if
    
end sub

</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>

<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function onShowBrowsers(wfid,formid,isbill){
	var src=$("#fromsrc").val();
	var url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill;
	
	id = window.showModalDialog(url);
	if (id != null && id != undefined) {
	        if (wuiUtil.getJsonValueByIndex(id, 0)!="") {
				$("#conditionss").val(wuiUtil.getJsonValueByIndex(id, 0));
				$("#conditions").html(wuiUtil.getJsonValueByIndex(id, 1));
				$("#conditioncn").val(wuiUtil.getJsonValueByIndex(id, 1));
				$("#fromsrc").val("2");
			}else{
				$("#conditionss").val("");
				$("#conditions").html("");
				$("#conditioncn").val("");
			}
	}
}

function onShowBrowser4op(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "id_"+index+"span";
	url=url+"?selectedids=" + $G(tmpid).value;
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html("<a href='#"+datas.id.substr(0)+"'>"+datas.name.substr(0)+"</a>");
			$("input[name="+tmpid+"]").val(datas.id.substr(0));
			tmpindex.checked = true;
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}
</script>

<script language=javascript>
function changelevel(tmpindex) {
	tmpindex.checked = true;
	tmpid = tmpindex.id;
	//document.addopform.selectindex.value = Mid(tmpid, 9, len(tmpid));
	document.addopform.selectindex.value = tmpid.substring(8);// Mid(tmpid, 9, len(tmpid));
	document.addopform.selectvalue.value = tmpindex.value;
	if($GetEle("tmptype_42").checked){
		$GetEle("Tab_Coadjutant").style.display='';
	}else {
		$GetEle("Tab_Coadjutant").style.display='none';
	}
    //alert("selindex:"+Mid(tmpid,9,len(tmpid)))+"   selectvalue:"+tmpindex.value;
}
function onShowCoadjutantBrowser() {
   
    url = encode("/workflow/workflow/showCoadjutantOperate.jsp?iscoadjutant=" + $GetEle("IsCoadjutant").value + "+signtype=" + $GetEle("signtype").value + "+issyscoadjutant=" + $GetEle("issyscoadjutant").value + "+coadjutants=" + $GetEle("coadjutants").value + "+coadjutantnames=" + $GetEle("coadjutantnames").value + "+issubmitdesc=" + $GetEle("issubmitdesc").value + "+ispending=" + $GetEle("ispending").value + "+isforward=" + $GetEle("isforward").value + "+ismodify=" + $GetEle("ismodify").value);
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (data) {
        if (wuiUtil.getJsonValueByIndex(data, 0) != "") {
            
            $GetEle("IsCoadjutant").value = wuiUtil.getJsonValueByIndex(data, 0);
            $GetEle("signtype").value = wuiUtil.getJsonValueByIndex(data, 1);
            $GetEle("issyscoadjutant").value = wuiUtil.getJsonValueByIndex(data, 2);
            $GetEle("coadjutants").value = wuiUtil.getJsonValueByIndex(data, 3);
            $GetEle("coadjutantnames").value = wuiUtil.getJsonValueByIndex(data, 4);
            $GetEle("issubmitdesc").value = wuiUtil.getJsonValueByIndex(data, 5);
            $GetEle("ispending").value = wuiUtil.getJsonValueByIndex(data, 6);
            $GetEle("isforward").value = wuiUtil.getJsonValueByIndex(data, 7);
            $GetEle("ismodify").value = wuiUtil.getJsonValueByIndex(data, 8);
            $GetEle("Coadjutantconditions").value = wuiUtil.getJsonValueByIndex(data, 9);
            $GetEle("Coadjutantconditionspan").innerHTML = wuiUtil.getJsonValueByIndex(data,9);
        } else {
            $GetEle("IsCoadjutant").value = "";
            $GetEle("signtype").value = "";
            $GetEle("issyscoadjutant").value = "";
            $GetEle("coadjutants").value = "";
            $GetEle("coadjutantnames").value = "";
            $GetEle("issubmitdesc").value = "";
            $GetEle("ispending").value = "";
            $GetEle("isforward").value = "";
            $GetEle("ismodify").value = "";
            $GetEle("Coadjutantconditions").value = "";
            $GetEle("Coadjutantconditionspan").innerHTML = "";
        }
    }
}
var rowColor="" ;
rowindex = 0;
theselectradio = null ;

function onShowBrowser4opM1(url,index,tmpindex){
	var tempid = "id_"+index;
	var url1 = url+"?selectedids="+document.all(tempid).value;
	onShowBrowser4opM(url1,index,tmpindex);
	}

function setSelIndex(selindex, selectvalue) {
	document.addopform.selectindex.value = selindex ;
	document.addopform.selectvalue.value = selectvalue ;
	if($GetEle("tmptype_42").checked){
		$GetEle("Tab_Coadjutant").style.display='';
	}else{
		$GetEle("Tab_Coadjutant").style.display='none';
	}
}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('addoperatorgroup');
}
function addRow4op(){
    var rowindex4op = 0;
    var rows=document.getElementsByName('check_node');
    var len = document.addopform.elements.length;
    var rowsum1 = 0;
    var obj;
    for(i=0; i < len;i++) {
		if (document.addopform.elements[i].name=='check_node'){
			rowsum1 += 1;
            obj=document.addopform.elements[i];
            }
    }

    if(rowsum1>0) {
    	rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }

    for(i=0;i<56;i++){
    	var belongtype ="0";
        if(document.addopform.selectindex.value == i){
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
				
				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')     $G("level_"+i).value = '0';
				if($GetEle("id_"+i).value ==0 || $GetEle("level_"+i).value =="" || ($GetEle("level_"+i).value =="0"&&i==50)){
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
			case 51:
			
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;

			case 52:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 53:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 54:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 55:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 4:   //所有人
            case 24:  //创建人下属
			case 25:  //创建人本分部
			case 26:  //创建人本部门 
			case 39:  //创建人上级部门
			case 32:  //创建客户

				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')    $G("level_"+i).value = '0';
				if($G("level_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames; 
			var k=1;
			var subcompanyids,subcompanynames; 
			var belongtypeStr = "";
			var singerorder_flag = 0;
			try{
				singerorder_flag = parseInt(document.getElementById("singerorder_flag").value);
			}catch(e){
				singerorder_flag = 0;
			}
			var singerorder_type = document.getElementById("singerorder_type").value;
      if (i==0){//多分部
			var stmps = $G("id_"+i).value;
			var sHtmls = $G("name_"+i).innerHTML;
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="30"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "30";
			}else{
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
            }
			}
			var departmentids,departmentnames; 
      if (i==1){//多部门
			var stmps = $G("id_"+i).value;
			var sHtmls = $G("name_"+i).innerHTML;
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="1"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "1";
			}else{
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
            }
			}
		if(i==2){//角色
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag > 0){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = "1";
                document.getElementById("singerorder_type").value = "2";
			}
		}
            if (i==3)  //多人力资源
			{
			var stmps = $G("id_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = $G("name_"+i).innerHTML;
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{ rowColor = getRowBg();
//			ncol = oTable4op.cols;
			ncol = oTable4op.rows[0].cells.length
			oRow = oTable4op.insertRow(-1);
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				oCell.style.background= rowColor;
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='check_node' value='0' rowindex="+rowindex4op+" belongtype="+belongtype+">";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"+belongtypeStr;
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"+belongtypeStr;
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>"+belongtypeStr;
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
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>";
						if(i== 51 )
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 52 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%>";
						if(i== 53 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%>";
						if(i== 54 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%>";
						if(i== 55 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%>";
                        oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

                        var rowtypevalue = document.addopform.selectvalue.value ;
						
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv1);
						break;
					case 2:
					{
						var stmp="";
					if(i==0){
					  	stmp=""+subcompanyids[m];
					  }else if(i==1){
					  	stmp=""+departmentids[m];
					  }else{ 
						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = $G("id_"+i).value;
					    }
            }
						var oDiv = document.createElement("div");
						var sHtml = "";
						if((i>= 5 && i <= 21) || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50|| i == 51|| i == 52 || i == 53 || i == 54 || i == 55){
							var srcList = $G("id_"+i);
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
						    if(i==0){ sHtml=subcompanynames[m];}
						    else if(i==1){ sHtml=departmentnames[m];}
					    else{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = $G("name_"+i).innerHTML;
							}
						  }
						  if (i==50)  sHtml =sHtml+"/"+$G("templevel_"+i).innerHTML;

						oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

						var oDiv2= document.createElement("div");
                       
						var stemp=stmp;
						
                        var sHtml1;
                        if(i==0 || i==1){
                        	sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_subcompanyids' value='"+stemp+"'>";
                        	sHtml1 += "<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }else{
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
					
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46||i == 42||i == 51){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						if (i==50){

                            sval = $G("level_"+i).value;
							sval2 = $G("level2_"+i).value;
							if(sval2=="1"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%>";
							}else if(sval2=="2"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%>";
							}else if(sval2=="3"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%>";
							}else{
								sHtml = "<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							}
						}
						if(i == 2 ){
							sval = $G("level_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							if(sval==3)
								sHtml="<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>";
						}
					
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex4op+"_level'  value='"+sval+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='-1'>";
                        }
						
						oDiv3.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv3);
						break;

						case 4:
						var oDiv = document.createElement("div");
						var sval = "";
						var sHtml="";
					
						if(i == 5|| i == 42|| i == 43|| i == 49||i == 50||i == 40||i == 41||i == 31||i == 51||i == 52||i == 53||i == 54||i == 55 ||i == 31 ){

							if($G("signorder")){
								sval = document.all("signorder");
							}else{

								sval = document.all("signorder_"+i);
							}

							if(sval[0].checked){
                                sHtml="<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>";
								sval = "0";
                            }
                            else if(sval[1].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>";
								sval = "1";
							}else if(sval[2].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>";
								sval = "2";
							}else if(sval[3].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>";
								sval = "3";
							}else if(sval[4].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>";
								sval = "4";
							}
						}
						if(i==0 || i==1 || i==2){
							sval = $G("signorder_"+i).value;
						}
                        sHtml += "<input type='hidden' size='32' name='group_"+rowindex4op+"_signorder'  value='"+sval+"'>";

						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
						case 5:
						var oDiv = document.createElement("div");
						var sval = $G("conditionss").value;
						var sval1 = $G("conditioncn").value;
                        var sval2 = $G("Coadjutantconditions").value;
						/*var temp = document.all("signorder_5");
						if(document.all("tmptype_5").checked&&(temp[3].checked||temp[4].checked)){
							sval="";
							sval1="";
						}*/
                        if(!$G("tmptype_42").checked){
                            sval2="";
                        }
						while (sval.indexOf("'")>0)
						{
							sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
							sval1=sval1.replace("'","’");
						}
						var hashead=0;
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_conditioncn' value='"+sval1+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_Coadjutantconditions' value='"+sval2+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_IsCoadjutant' value='"+$G("IsCoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_signtype' value='"+$G("signtype").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issyscoadjutant' value='"+$G("issyscoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_coadjutants' value='"+$G("coadjutants").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issubmitdesc' value='"+$G("issubmitdesc").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ispending' value='"+$G("ispending").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_isforward' value='"+$G("isforward").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ismodify' value='"+$G("ismodify").value+"'>";
                        if(sval1!=""){
						    sHtml+="<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>:"+sval1;
                            hashead=1;
                        }
                        if(sval2!=""){
                            if(hashead==1) sHtml+="<br>";
                            sHtml+="<%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>:"+sval2;
                        }
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
						case 6:
							var sval = "";
							if(($G("signordertr")&&$G("signordertr").style.display!="none"
								&&(i == 5||i == 6||i == 7||i == 8||i == 9||i == 38||i == 42||i == 52||i == 53||i == 54||i == 55||i == 51||i == 43
								||i == 49||i == 50||i == 22||i == 23||i == 24||i == 25||i == 26||i == 39||i == 40||i == 41))
								||i == 31||((i == 2||i == 3)&&$G("signorder_"+i))){
								if(i==31||i==2||i==3)
								{
									sval = document.all("signorder_"+i);
								}
								else
								{
									sval = document.all("signorder");
								}
								if(sval)
								{
									
									if(sval[0]&&sval[0].checked){ 
										sval = "0";
		                            }else if(sval[1]&&sval[1].checked){ 
										sval = "1";
									}else if(sval[2]&&sval[2].checked){ 
										sval = "2";
									}else if(sval[3]&&sval[3].checked){ 
										sval = "3";
									}else if(sval[4]&&sval[4].checked){ 
										sval = "4";
									} 
								}
							} 
							
						var oDiv = document.createElement("div");

						//var sval1 = document.getElementById("orders").value;
						var sval1 = $G("orders").value;

						var temp = document.all("signorder");
						var f_check = true;
						if(temp)
						{
							if(document.getElementById("signordertr")&&document.getElementById("signordertr").style.display!="none"&&(temp[3].checked||temp[4].checked)){
								sval1="";
								f_check = false;
							}
						}
						if (sval1==null || sval1 == ''){
							sval1=0;
						}
						//alert(sval1);
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_orderold' value='"+sval1+"'>";
						var nodetype_operatorgroup = $GetEle("nodetype_operatorgroup").value;
						//如果是会签抄送不显示批次
						if(sval=='3'||sval=='4'){
							sHtml += '';
						} 
						else{
							if(nodetype_operatorgroup == 1 || nodetype_operatorgroup == 2 || nodetype_operatorgroup == 3){
								sHtml+="<input type='text' class='Inputstyle' name='group_"+rowindex4op+"_order' value='"+sval1+"' onchange=\"check_number('group_"+rowindex4op+"_order');checkDigit(this,5,2)\"  maxlength=\"5\" style=\"width:80%\">";
							}else{
								sHtml += sval1;
							}
						}
						if(f_check == false){
							sHtml = "";
						}
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
			rowindex4op = rowindex4op*1 +1;
			}
			$G("fromsrc").value="1";
			$G("conditionss").value="";
			$G("conditioncn").value="";
			$G("conditions").innerHTML="";
			$G("IsCoadjutant").value="";
			$G("signtype").value="";
			$G("issyscoadjutant").value="";
			$G("coadjutants").value="";
			$G("issubmitdesc").value="";
			$G("ispending").value="";
			$G("isforward").value="";
			$G("ismodify").value="";
            $G("Coadjutantconditions").value="";
			$G("Coadjutantconditionspan").innerHTML="";
			//for(itmp = 0;itmp < 32;itmp++)
				//document.form1.tmptype(itmp).checked = false;
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}

function addRow()
{		
	for(i=0;i<51;i++){
		if(document.addopform.selectindex.value == i){
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
				if($GetEle("id_"+i).value ==0 || $GetEle("level_"+i).value =="" || ($GetEle("level_"+i).value =="0"&&i==50)){
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
			
				if(document.all("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;

			case 4:
            case 24:
			case 25:
			case 26:
			case 32:

				if(document.all("level_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
			var subcompanyids,subcompanynames; 
      if (i==0){//多分部
				var stmps = document.all("id_"+i).value;
				subcompanyids=stmps.split(",");
				var sHtmls = document.all("name_"+i).innerHTML;
				subcompanynames=sHtmls.split(",");
				k=subcompanyids.length;
			}
			var departmentids,departmentnames; 
      if (i==1){//多部门
				var stmps = document.all("id_"+i).value;
				departmentids=stmps.split(",");
				var sHtmls = document.all("name_"+i).innerHTML;
				departmentnames=sHtmls.split(",");
				k=departmentids.length;
			}
            var hrmids,hrmnames; 
			var k=1;
            if (i==3)  //多人力资源
			{
			var stmps = document.all("id_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = document.all("name_"+i).innerHTML;
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
						var sHtml = "<input type='checkbox' name='check_node' value='0'>";
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
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

                        var rowtypevalue = document.addopform.selectvalue.value ;
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						oCell.appendChild(oDiv1);
						break;
					case 2:

							var stmp="";
					  if(i==0){
					  	stmp=""+subcompanyids[m];
					  }else if(i==1){
					  	stmp=""+departmentids[m];
					  }else{ 
						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = document.all("id_"+i).value;
					    }
            }           
						var oDiv = document.createElement("div");
						var sHtml = "";
						if(i>= 5 && i <= 21 || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50){
							var srcList = document.all("id_"+i);
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
					    if(i==0){ sHtml=subcompanynames[m];}
					    else if(i==1){ sHtml=departmentnames[m];}
					    else{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = document.all("name_"+i).innerHTML;
							}
						  }
						  if (i==50)  sHtml =sHtml+"/"+document.all("templevel_"+i).innerHTML;

						oDiv.innerHTML = sHtml;

						oCell.appendChild(oDiv);

						var oDiv2= document.createElement("div");
                       
						var stemp=stmp;
						
						var sHtml1 = "<input type='hidden'  name='group_"+rowindex+"_id' value='"+stemp+"'>";
						oDiv2.innerHTML = sHtml1;
						oCell.appendChild(oDiv2);
						break;
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";
					
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46||i == 42){
                            sval = document.all("level_"+i).value;
                            sval2 = document.all("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						if (i==50)
							{
                            sval = document.all("level_"+i).value;
							
							}
						if(i == 2 ){
							sval = document.all("level_"+i).value;
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
						var sval = "";
						var sHtml="";
						if(i == 5|| i == 42|| i == 43|| i == 49||i == 50||i == 40||i == 41||i == 31 ){

							sval = document.all("signorder_"+i);

							if(sval[0].checked){
                                sHtml="<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>";
								sval = "0";
                            }
                            else if(sval[1].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>";
								sval = "1";
							}else if(sval[2].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>";
								sval = "2";
							}else if(sval[3].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>";
								sval = "3";
							}else if(sval[4].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>";
								sval = "4";
							}
						}
                        sHtml += "<input type='hidden' size='32' name='group_"+rowindex+"_signorder'  value='"+sval+"'>";

						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
						case 5:
						var oDiv = document.createElement("div");
						var sval = $G("conditionss").value;
						var sval1 = $G("conditioncn").value;
						var sval2 = $G("Coadjutantconditions").value;
						if(!$G("tmptype_42").checked){
                            sval2="";
                        }
						while (sval.indexOf("'")>0)
						{
						sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
						sval1=sval1.replace("'","’");
						}
						var hashead=0;
						var sHtml="<input type='hidden' name='group_"+rowindex+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex+"_conditioncn' value='"+sval1+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex+"_Coadjutantconditions' value='"+sval2+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_IsCoadjutant' value='"+$G("IsCoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_signtype' value='"+$G("signtype").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_issyscoadjutant' value='"+$G("issyscoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_coadjutants' value='"+$G("coadjutants").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_issubmitdesc' value='"+$G("issubmitdesc").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_ispending' value='"+$G("ispending").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_isforward' value='"+$G("isforward").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_ismodify' value='"+$G("ismodify").value+"'>";
						if(sval1!=""){
						    sHtml+="<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>:"+sval1;
                            hashead=1;
                        }
                        if(sval2!=""){
                            if(hashead==1) sHtml+="<br>";
                            sHtml+="<%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>:"+sval2;
                        }
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
						case 6:
						var oDiv = document.createElement("div");
						
						var sval1 = document.all("orders").value;
						if (sval1==null || sval1 == ''){
							sval1=0;
						}
						
						var sHtml="<input type='hidden' name='group_"+rowindex+"_orderold' value='"+sval1+"'>";
						<%if (!nodetype.equals("0")&&!nodetype.equals("3")){%>
							sHtml1+="<input type='text' class='Inputstyle' name='group_"+rowindex+"_order' value='"+sval1+"' onchange=\"check_number('group_"+rowindex+"_order');checkDigit(this,5,2)\"  maxlength=\"5\" style=\"width:80%\">";
						<%}else{%>
							sHtml1+=sval1;
						<%}%>
						oDiv.innerHTML = sHtml1;
						oCell.appendChild(oDiv);
						break;
				}
			}
			rowindex = rowindex*1 +1;
			}
			document.all("fromsrc").value="1";
			document.all("conditionss").value="";
			document.all("conditioncn").value="";
			document.all("conditions").innerHTML="";
			
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}


function deleteRow()
{
	var flag = false;
	var ids = document.getElementsByName('check_node');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
    	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
    	top.Dialog.confirm(str, function (){
			len = document.forms[0].elements.length;
			var i=0;
			var rowsum1 = 0;
			for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name=='check_node')
					rowsum1 += 1;
			}
			for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name=='check_node'){
					if(document.forms[0].elements[i].checked==true) {
						oTable.deleteRow(rowsum1+1);
					}
					rowsum1 -=1;
				}
		
			}
    	}, function () {}, 320, 90,true);
    }else{
    	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
function deleteRow4op()
{
	len = document.addopform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node'){
			if(document.addopform.elements[i].checked==true) {
                if(document.addopform.elements[i].belongtype=="2"){
        			var singerorder_flag = 0;
        			try{
        				singerorder_flag = parseInt($G("singerorder_flag").value);
        			}catch(e){
        				singerorder_flag = 0;
        			}
        			if(singerorder_flag > 0){
        				singerorder_flag = singerorder_flag - 1;
        			}
                    $GetEle("singerorder_flag").value = ""+singerorder_flag;
                    if(singerorder_flag == 0){
                    	$G("singerorder_type").value = "";
                    }
                }
				oTable4op.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
}

function selectall(){    
    if(check_form(window.document.forms[0],'groupname')){

		document.forms[0].groupnum.value=rowindex;
		window.document.forms[0].submit();
		designOnClose();
	}
	
}
function nodeopaddsave(obj){
	
    var sss=document.addopform.groupname.value;
    if(sss.length>60){
    alert("<%=SystemEnv.getHtmlLabelName(18686,user.getLanguage())%>");
    }else{
    
	    if (check_form(addopform, 'groupname')) {
	        var rowindex4op = 0;
	        var len = document.addopform.elements.length;
	        var rowsum1 = 0;
	        var obj;
	        for (i = 0; i < len; i++) {
	            if (document.addopform.elements[i].name == 'check_node') {
	                rowsum1 += 1;
	                obj = document.addopform.elements[i];
	            }
	        }
	
	        if (rowsum1 > 0) {
	            rowindex4op = parseInt(obj.rowindex) + 1;
	        }
	
	        addopform.groupnum.value = rowindex4op;
			
	        obj.disabled = true;
	        addopform.submit();
			designOnClose();
	    }
   }
}

function checkDigit(elementName,p,s){
	tmpvalue = elementName.value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    elementName.value=newValue;
}
function nodeopdelete(obj){
	if (isdel()) {
    obj.disabled=true;
    addopform.src.value="delgroups";
    addopform.submit();
	designOnClose();
  }
}
function encode(str){
    return escape(str);
}
</script>