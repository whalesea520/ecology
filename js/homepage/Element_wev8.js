function Element(eid,ebaseid,styleid,hpid,subCompanyId){  
	this.eid=eid;
	this.ebaseid=ebaseid;
	this.styleid=styleid;
    this.languageid=readCookie("languageidweaver");

    this.contentUrl="/homepage/element/ElementContent.jsp?eid="+eid+"&ebaseid="+ebaseid+"&styleid="+styleid+"&hpid="+hpid+"&subCompanyId="+subCompanyId;
	//this.contentUrl="/weaver/weaver.homepage.HomepageEContentServlet?eid="+eid+"&ebaseid="+ebaseid+"&styleid="+styleid+"&hpid="+hpid+"&subCompanyId="+subCompanyId;
	this.settingUrl="/homepage/element/ElementSetting.jsp?eid="+eid+"&ebaseid="+ebaseid+"&styleid="+styleid+"&hpid="+hpid+"&subCompanyId="+subCompanyId;

	this.loading=false;	
}



Element.prototype.contentLoad = function(){	
	var divContent=this.getObjectById("_divEcontent_"+this.eid);
	this.objectCreate(this.contentUrl,divContent,this.ebaseid==1);
}


Element.prototype.rssContentLoad = function(){	
	var divContent=this.getObjectById("_divEcontent_"+this.eid);

	this.objectCreate(this.contentUrl,divContent,true);
}

Element.prototype.objectCreate = function(strUrl,objDiv,isRss){
    if(this.languageid==8)
        objDiv.innerHTML="<img src=/images/loading2_wev8.gif> Executing..."
    else if(this.languageid==9)
         objDiv.innerHTML="<img src=/images/loading2_wev8.gif>處理中..."
    else
        objDiv.innerHTML="<img src=/images/loading2_wev8.gif> 处理中..."
    //alert(this.loading)
    if(this.loading)	return;

    this.loading = true;
	var Element= this;	
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET",strUrl, true);	
	xmlHttp.onreadystatechange = function () {
        //alert(xmlHttp.readyState)
        switch (xmlHttp.readyState) {
           case 3 :
                    if(this.languageid==8)
                        objDiv.innerHTML="<img src=/images/loading2_wev8.gif> Transfering...";
                    else if(this.languageid==9)
         				objDiv.innerHTML="<img src=/images/loading2_wev8.gif>傳輸中..."
                    else
                        objDiv.innerHTML="<img src=/images/loading2_wev8.gif> 传输中...";

		        break;
		   case 4 : 
			   if (xmlHttp.status==200)  {
                 if(isRss){
                     //alert(xmlHttp.responseText)
                     try{
                        eval("Element.parseRss(objDiv,"+xmlHttp.responseText+")");
                     }  catch(e){
                         objDiv.innerHTML=xmlHttp.responseText;                       
                     }
                 } else {                 	 
					 Element.parse(xmlHttp.responseText,objDiv);		
					 flashVideoIsInit=false;
				   	 initFlashVideo();
				 }
				 
			   } else {
				  //objDiv.style.width="50px"
				   //alert(objDiv.parentNode.outerHTML)
			   	 objDiv.innerHTML=xmlHttp.responseText;
			   
//                   if(this.languageid==8)
//                        objDiv.innerHTML="Element Error,Please contact administrator.";
//                    else
//                        objDiv.innerHTML="元素出现错误,请联系相关人员.";

			   }
			   var txtIsfromportal=document.getElementById("txtIsfromportal");			  
			   if(txtIsfromportal!=null){
				   var txtLastPageHeight=document.getElementById("txtLastPageHeight");

				   if(txtIsfromportal.value==1){ //从门户过的数据需要刷新页面宽度						
						var oFrm=parent.document.frames("mainFrame");	
						var realHeight=oFrm.document.body.scrollHeight;
						//alert(realHeight+":"+txtLastPageHeight.value)
						if(realHeight>txtLastPageHeight.value) {							
							txtLastPageHeight.value=realHeight;
							//alert(realHeight)
							parent.document.getElementById("mainFrame").height=realHeight;
							//alert(oFrm.height+":"+realHeight)
							//oFrm.height=realHeight+10;
						}
				   }
			   }
			   break;
		} 
	}		
	xmlHttp.setRequestHeader("Content-Type","text/xml")	
	xmlHttp.send(null);	
}


Element.prototype.parse=function(strXml,objDiv){	
	//alert (objDiv.style.posWidth)
	objDiv.innerHTML=strXml;
	this.loadEnd();
}

Element.prototype.parseRss = function(objDiv,eid,rssUrl,imgSymbol,hasTitle,hasDate,hasTime,titleWidth,dateWidth,timeWidth,rssTitleLength,linkmode,size,perpage){		
	
	var returnStr="";	
	
	try{
		var rssRequest = XmlHttp.create();
		rssRequest.open("GET",rssUrl, true);	
		rssRequest.onreadystatechange = function () {
			//alert(rssRequest.readyState)
			switch (rssRequest.readyState) {
			   case 3 : 					
					break;
			   case 4 : 
				   if (rssRequest.status==200)  {

                     returnStr+="<TABLE id=\"_contenttable_"+eid+"\" class=\"Econtent\">"+
						  " <TR>"+
						  " <TD width=\"1px\"></TD>"+
						  " <TD width=\"*\" valign=\"center\">"+
						  "	    <TABLE  width=\"100%\">";
				   
						var items=rssRequest.responseXML;
						var titles=new Array(),pubDates=new Array(); dates=new Array(), times=new Array(), linkUrls=new Array(), descriptions=new Array()	
							
						var items_count=items.getElementsByTagName('item').length;

						if(items_count>perpage) items_count=perpage;
						//alert(items_count)

						for(var i=0; i<items_count; i++) {
							titles[i]="";
							pubDates[i]="";
							linkUrls[i]="";
							descriptions[i]="";
							dates[i]="";
							times[i]="";

							if(items.getElementsByTagName('item')[i].getElementsByTagName('title').length==1)
								titles[i]=items.getElementsByTagName('item')[i].getElementsByTagName('title')[0].firstChild.nodeValue;


							if(items.getElementsByTagName('item')[i].getElementsByTagName('pubDate').length==1)
								pubDates[i]=items.getElementsByTagName('item')[i].getElementsByTagName('pubDate')[0].firstChild.nodeValue;

							if(items.getElementsByTagName('item')[i].getElementsByTagName('link').length==1)
								linkUrls[i]=items.getElementsByTagName('item')[i].getElementsByTagName('link')[0].firstChild.nodeValue;

							
							returnStr+="<TR height=18px>"+
									   "  <TD width=\"8\">"+imgSymbol+"</TD>";

							
							if(hasTitle=="true"){
								 returnStr+="<TD width="+titleWidth+">";
								
								 if(linkmode=="1"){
									returnStr+="<a href=\""+linkUrls[i]+"\" target=\"_self\" title=\""+titles[i]+"\"><FONT class=\"limitstr\" style=\"width:"+(rssTitleLength/2)+"cm\" >"+titles[i]+"</FONT></a>";
								 } else {
									returnStr+="<a href=\"javascript:openFullWindowForXtable('"+linkUrls[i]+"')\" title=\""+titles[i]+"\"><FONT class=\"limitstr\" style=\"width:"+(rssTitleLength/2)+"cm\"  >"+titles[i]+"</FONT></a>";
								 } 
								 returnStr+="</TD>";
							} 
							if(pubDates[i]!=""){
								var d = new Date(pubDates[i]);
								dates[i]=d.getYear()+"-"+(d.getMonth() + 1) + "-"+d.getDate() ;

								if(d.getHours()<=9)	times[i]+="0"+d.getHours() + ":";
								else times[i]+= d.getHours() + ":";

								if(d.getMinutes()<=9)	times[i]+="0"+d.getMinutes() + ":";
								else times[i]+= d.getMinutes() + ":";

								if(d.getSeconds()<=9)	times[i]+="0"+d.getSeconds();
								else times[i]+= d.getSeconds() ;
							} else {
								dates[i]="";
								times[i]="";
							}
							if(hasDate=="true"){
								returnStr+="<TD width="+dateWidth+">"+dates[i]+"</TD>";
							}
							if(hasTime=="true"){
								returnStr+="<TD width="+timeWidth+">"+times[i]+"</TD>";
							}
							returnStr+="</TR>";

							if(i<items_count-1){
								returnStr+="<TR class=\"sparatorTr\"><TD  colspan="+(size+1)+"></TD></TR>";	
							}
					
						}
					

						returnStr+="		</TABLE>"+
								  "	</TD>"+
								  " <TD width=\"1px\"></TD>"+
								  " </TR>"+
								  "</TABLE>";
						
						objDiv.innerHTML=returnStr;
				   } else {
					   objDiv.innerHTML=rssRequest.responseText;
				   }
				   break;
			} 
		}	
		rssRequest.setRequestHeader("Content-Type","text/xml")	
		rssRequest.send(null);	
	} catch(e){      
        if(e.number==-2147024891){
            if(this.languageid==8)
                objDiv.innerHTML="RSS use client read，It need let this site's url into you IE trust list.！&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(How?)</a>";
            else if(this.languageid==9)
            	objDiv.innerHTML="RSS採用的是客戶端讀取，需把本站點添加到受信任站點！&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(怎樣添加?)</a>";
            else
                objDiv.innerHTML="RSS采用的是客户端读取，需把本站点添加到受信任站点！&nbsp;<a href='/homepage/HowToAdd.jsp' target='_blank'>(怎样添加?)</a>";
        }   else {
            objDiv.innerHTML=e.number+":"+e.description;
        }
    }
	this.loadEnd();	
}


Element.prototype.loadEnd = function(){	
	this.loading = false;
}


Element.prototype.reLoad = function(eid,ebaseid){
    this.contentLoad();
}

Element.prototype.getObjectById = function(id){			
	return document.getElementById(id);
}

