function Observer() {
    this.fns = [];
}
Observer.prototype = {
    subscribe: function (fn) {
        this.fns.push(fn);
    },
    unsubscribe: function (fn) {
        this.fns = this.fns.filter(
                        function (el) {
                            if (el !== fn) {
                                return el;
                            }
                        }
                    );
    },
    update: function (o, thisObj) {
        var scope = thisObj || window;
        this.fns.forEach(
                        function (el) {
                            el.call(scope, o);
                        }
                    );
    }
};
if(typeof(window.top.myprjtypetreeobserver)=="undefined"){
	window.top.myprjtypetreeobserver = new Observer();
}