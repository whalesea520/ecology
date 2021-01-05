var draged=false;
tdiv=null;

var moveEid;
var srcFlagObj;

function dragStart(){
	ao=event.srcElement;
	if(((ao.tagName=="TD")||(ao.tagName=="TR"))&&!isSetting) {
		ao=ao.offsetParent;
	}
	else return;		
	draged=true;	
	//for(var i=0;i<objAreaFlags.length;i++)
	//	objAreaFlags[i].style.border='1px solid #33CCFF';
	
	tdiv=document.createElement("div");
	tdiv.innerHTML=ao.outerHTML;
	tdiv.style.display="block";
	tdiv.style.position="absolute";
	tdiv.style.filter="alpha(opacity=70)";
	tdiv.style.cursor="move";
	tdiv.style.width=ao.offsetWidth;
	tdiv.style.height=ao.offsetHeight;
	tdiv.style.top=getInfo(ao).top;
	tdiv.style.left=getInfo(ao).left;
	document.body.appendChild(tdiv);

	lastX=event.clientX;
	lastY=event.clientY;
	lastLeft=tdiv.style.left;
	lastTop=tdiv.style.top;		
	
	moveEid=ao.eid;
	srcFlagObj=ao.parentNode;
	try{
		ao.dragDrop();
	}catch(e){	
		alert(e.description)
	}
}


function draging(){		
	if(!draged)return;

	tblMove.style.display='';
	var tX=event.clientX;
	var tY=event.clientY;
	tdiv.style.left=parseInt(lastLeft)+tX-lastX;
	tdiv.style.top=parseInt(lastTop)+tY-lastY;

	for(var i=0;i<objAreaFlags.length;i++){
		var areaPos=getInfo(objAreaFlags[i]);					
		if(tX>=areaPos.left&&tX<=areaPos.right&&tY>=areaPos.top&&tY<=areaPos.bottom){				
			var elementTables=objAreaFlags[i].children;
			

			if(elementTables.length==0){				   
				if(tX>=areaPos.left&&tX<=areaPos.right&&tY>=areaPos.top&&tY<=areaPos.bottom){
					//objAreaFlags[i].appendChild(ao);
					objAreaFlags[i].appendChild(tblMove);
					break;
					
				}
			} else {			
				if(tX>=areaPos.left&&tX<=areaPos.right&&tY>areaPos.bottom-15){					
					objAreaFlags[i].appendChild(tblMove);
					
				}

				for(var j=0;j<elementTables.length;j++){
					var elementTablePos=getInfo(elementTables[j]);
					
					if(tX>=elementTablePos.left&&tX<=elementTablePos.right&&tY>=elementTablePos.top&&tY<=elementTablePos.bottom){
						//objAreaFlags[i].insertBefore(ao,elementTables[j]);
						objAreaFlags[i].insertBefore(tblMove,elementTables[j]);							
					} 
				}
				

			}

		}
	}
}

function dragEnd(){
	if(!draged)return;	
	tdiv.removeNode(true);
	ao.swapNode(tblMove)
	tblMove.style.display='none';
	//mm=ff(150,15);	

	moveElement(moveEid,srcFlagObj)
	draged=false;


	//for(var i=0;i<objAreaFlags.length;i++)
		//objAreaFlags[i].style.border='0px';
}

/*取得坐标*/
function getInfo(o){
	var to=new Object();
	to.left=to.right=to.top=to.bottom=0;
	var twidth=o.offsetWidth;
	var theight=o.offsetHeight;
	while(o!=document.body){
		to.left+=o.offsetLeft;
		to.top+=o.offsetTop;
		o=o.offsetParent;
	}
	to.right=to.left+twidth;
	to.bottom=to.top+theight;
	return to;
}

/*用于恢复位置*/
function ff(aa,ab){
	var ac=parseInt(getInfo(tdiv).left);
	var ad=parseInt(getInfo(tdiv).top);
	var ae=(ac-getInfo(ao).left)/ab;
	var af=(ad-getInfo(ao).top)/ab;
	return setInterval(function(){
		if(ab<1){
			clearInterval(mm);
			tdiv.removeNode(true);
			ao=null;
			return
		}
		ab--;
		ac-=ae;
		ad-=af;
		tdiv.style.left=parseInt(ac)+"px";
		tdiv.style.top=parseInt(ad)+"px"
	}
	,aa/ab)
}