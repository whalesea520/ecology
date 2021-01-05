/*********************************************************
 * JavaScript实现的ArrayList类 
 * 
 * @author       yoinn {yoinn@21cn.com}
 * @version      $Revision: 0.5 $ $Date: 2004/09/28 15:00:00 $
 * @description
 *               Method:
 *                      add(element);
 *                      addElementAt(index, element);
 *                      contains(element);
 *                      get(index);
 *                      isEmpty(index);
 *                      indexOf(element);
 *                      lastIndexOf(element);
 *                      remove()
 *                      setElementAt(index, element);
 *                      size();
 *                      toString();
 * @example
 *               var arrList = new ArrayList();
 *               //var arrList = new ArrayList(10);
 *               arrList.add("000");
 *               arrList.add("001");
 *               arrList.add("002");
 *
 *********************************************************/
var ArrayList = function(){

    var args = ArrayList.arguments;
    
    var initialCapacity = 10;
    
    if( args!=null && args.length>0 ){
        initialCapacity = args[0];
    }

    var elementData = new Array(initialCapacity);
    var elementCount = 0;

    this.size = function(){
        return elementCount;
    }

    this.add = function (element) {
        //alert("add");
        ensureCapacity(elementCount + 1);
        elementData[elementCount++] = element;
        return true;
    }

    this.addElementAt = function (index, element ){
        //alert("addElementAt");
        if ( index > elementCount || index < 0 ){
            alert( "IndexOutOfBoundsException, Index: " + index + ", Size: " + elementCount );
            return;
            //throw (new Error(-1,"IndexOutOfBoundsException, Index: "+index+", Size: " + elementCount));
        }
        ensureCapacity( elementCount+1 );
        for( var i=elementCount+1; i>index; i-- ){
            elementData[i] = elementData[i-1] 
        }
        elementData[index] = element;
        elementCount++;
    }

    this.setElementAt = function (index, element ){
        //alert("setElementAt");
        if ( index > elementCount || index < 0 ){
            alert( "IndexOutOfBoundsException, Index: "+index+", Size: " + elementCount );
            return;
            //throw (new Error(-1,"IndexOutOfBoundsException, Index: "+index+", Size: " + elementCount));
        }
        elementData[index] = element;
    }

    this.toString = function(){
        //alert("toString()");
        var str = "{";
        for(var i=0;i<elementCount;i++){
            if( i>0 ){
                str += ",";
            }
            str += elementData[i];
        }
        str += "}";
        return str;
    }
    
    this.get = function(index){
        //alert("elementAt");
        if ( index >= elementCount ) {
            alert( "ArrayIndexOutOfBoundsException, " + index + " >= " + elementCount );
            return;
            //throw ( new Error( -1,"ArrayIndexOutOfBoundsException, " + index + " >= " + elementCount ) );
        }
        return elementData[index];
    }
    
    this.remove = function(index){
        if ( index >= elementCount ) {
            alert( "ArrayIndexOutOfBoundsException, " + index + " >= " + elementCount );
            //return;
            throw ( new Error( -1,"ArrayIndexOutOfBoundsException, " + index + " >= " + elementCount ) );
        }
        var oldData = elementData[index];
        for( var i=index;i<elementCount - 1;i++ ){
            elementData[i] = elementData[i+1];     
        }
        elementData[elementCount - 1] = null;
        elementCount--;
        return oldData;
    }

    this.isEmpty = function() {
        return elementCount == 0;
    }

    this.indexOf = function(elem) {
        //alert("indexOf");
        for ( var i=0; i < elementCount; i++ ){
            if (elementData[i]==elem){
                return i;
            }
        }
        return -1;
    }

    this.lastIndexOf = function(elem) {
        for (var i = elementCount-1; i >= 0; i--){
            if ( elementData[i]==elem ){
                return i;
            }
        }
        return -1;
    }

    this.contains = function(elem) {
        return this.indexOf(elem) >= 0;
    }

    function ensureCapacity (minCapacity) {
        var oldCapacity = elementData.length;
        if (minCapacity > oldCapacity) {
            var oldData = elementData;
            var newCapacity = parseInt( (oldCapacity * 3)/2 + 1 );
            if (newCapacity < minCapacity){
                newCapacity = minCapacity;
            }
            elementData = new Array(newCapacity);
            for( var i=0;i<oldCapacity;i++ ){
                elementData[i] = oldData[i];
            }
        }
    }
}
