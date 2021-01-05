var replyDocInfoTR;
var TD0 ;

function initRow(){
	replyDocInfoTR = tbl.insertRow(); 
	TD0 = replyDocInfoTR.insertCell();	
	TD0.colSpan=3;	
	replyDocInfoTR.style.display="none";
}



function clickLink (innerTR,outerTR,docid) {

	if(replyDocInfoTR==null) initRow();

	if (innerTR.hrefStatus=="close")	{
		replyDocInfoTR.style.display="";
		TD0.innerHTML="";

		TD0.appendChild(createNewTableObj(innerTR));

		replyDocInfoTR.style.display="";
		outerTR.insertAdjacentElement("afterEnd",replyDocInfoTR)

		getDocContent(docid);
		innerTR.hrefStatus="open";
	} else {
		replyDocInfoTR.style.display="none";
		innerTR.hrefStatus="close";
	}

	
	
}


function createNewTableObj(preInnerRow) {
	var preRow = preInnerRow;

	var newTable = document.createElement("TABLE");
	var contentDiv = document.createElement("DIV");
	contentDiv.id="contentDiv"
	contentDiv.className="ReplyContentDiv";
	contentDiv.innerHTML=SystemEnv.getHtmlNoteName(3512,readCookie("languageidweaver"));
	
	newTable.width="100%";
	newTable.cellSpacing="0";
	newTable.cellPadding="0";

	var newTR = newTable.insertRow();
	var cell1= newTR.insertCell();
	
	cell1.width=preRow.childNodes(0).width;
	cell1.innerHTML="&nbsp;";

	var cell2 = newTR.insertCell();
	cell2.width="20px"
	var cell3 = newTR.insertCell();
	cell3.appendChild(contentDiv);   
	cell3.colSpan=3;
    cell3.vAlign="top";
	
	
   
	 
	return newTable;
}


function getDocContent(docid) {
	var docContent="";
	var req = false;
	var url="/docs/docs/DocOperate.jsp?operation=GetDocContent&docid="+docid;
    // branch for native XMLHttpRequest object
    if(window.XMLHttpRequest) {
    	try {
			req = new XMLHttpRequest();
        } catch(e) {
			req = false;
        }
    // branch for IE/Windows ActiveX version
    } else if(window.ActiveXObject) {
       	try {
        	req = new ActiveXObject("Msxml2.XMLHTTP");
      	} catch(e) {
        	try {
          		req = new ActiveXObject("Microsoft.XMLHTTP");
        	} catch(e) {
          		req = false;
        	}
		}
    }
	if(req) {
		req.onreadystatechange = function () {				
			switch (req.readyState) {
			   case 0 :  //uninitialized
					break ;
			   case 1 :   //loading							
					break ;
			   case 2 :   //loaded				  
				   break ;
			   case 3 :   //interactive			     
				   break ;
			   case 4 :  //complete
				   if (req.status==200)  {	                       
					  docContent = req.responseText;	    
                      contentDiv.innerHTML=docContent					
				   } else {				
						//出错处理
				   }	  		
			} 
		}		

		req.open("GET", url, true);
		req.send("");
	}
   
	
}
