/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _reactDom = __webpack_require__(2);
	
	var _Router = __webpack_require__(3);
	
	var _Router2 = _interopRequireDefault(_Router);
	
	var _Route = __webpack_require__(41);
	
	var _Route2 = _interopRequireDefault(_Route);
	
	var _browserHistory = __webpack_require__(42);
	
	var _browserHistory2 = _interopRequireDefault(_browserHistory);
	
	var _useRouterHistory = __webpack_require__(45);
	
	var _useRouterHistory2 = _interopRequireDefault(_useRouterHistory);
	
	var _history = __webpack_require__(47);
	
	var _antd = __webpack_require__(70);
	
	var _Home = __webpack_require__(71);
	
	var _Home2 = _interopRequireDefault(_Home);
	
	var _Salary = __webpack_require__(74);
	
	var _Salary2 = _interopRequireDefault(_Salary);
	
	var _SalaryMobile = __webpack_require__(76);
	
	var _SalaryMobile2 = _interopRequireDefault(_SalaryMobile);
	
	var _SalarySet = __webpack_require__(77);
	
	var _SalarySet2 = _interopRequireDefault(_SalarySet);
	
	var _SalaryMsg = __webpack_require__(78);
	
	var _SalaryMsg2 = _interopRequireDefault(_SalaryMsg);
	
	var _PubnishVote = __webpack_require__(79);
	
	var _PubnishVote2 = _interopRequireDefault(_PubnishVote);
	
	var _VoteList = __webpack_require__(81);
	
	var _VoteList2 = _interopRequireDefault(_VoteList);
	
	var _StartVoting = __webpack_require__(82);
	
	var _StartVoting2 = _interopRequireDefault(_StartVoting);
	
	var _VoteDetail = __webpack_require__(83);
	
	var _VoteDetail2 = _interopRequireDefault(_VoteDetail);
	
	var _GroupUserList = __webpack_require__(84);
	
	var _GroupUserList2 = _interopRequireDefault(_GroupUserList);
	
	var _VoteOptionDetail = __webpack_require__(85);
	
	var _VoteOptionDetail2 = _interopRequireDefault(_VoteOptionDetail);
	
	__webpack_require__(86);
	
	__webpack_require__(90);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	//const ReactRouter = require('react-router');
	//let { Router, Route, Link ,browserHistory, useRouterHistory } from 'react-router';
	
	
	var history = (0, _useRouterHistory2["default"])(_history.createHashHistory)();
	
	var Root = function (_React$Component) {
	    _inherits(Root, _React$Component);
	
	    function Root() {
	        _classCallCheck(this, Root);
	
	        return _possibleConstructorReturn(this, (Root.__proto__ || Object.getPrototypeOf(Root)).apply(this, arguments));
	    }
	
	    _createClass(Root, [{
	        key: 'render',
	        value: function render() {
	            return _react2["default"].createElement(
	                _Router2["default"],
	                { history: history },
	                _react2["default"].createElement(_Route2["default"], { name: '/', breadcrumbName: '\u5165\u53E3', path: '/', component: _Home2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'show', breadcrumbName: '\u5DE5\u8D44\u67E5\u8BE2', path: '/show', component: _Salary2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'mobile', breadcrumbName: '\u79FB\u52A8\u5DE5\u8D44\u67E5\u8BE2', path: '/mobile', component: _SalaryMobile2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'set', breadcrumbName: '\u5DE5\u8D44\u8BBE\u7F6E', path: '/set', component: _SalarySet2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'msg', breadcrumbName: '\u5DE5\u8D44\u77ED\u4FE1', path: '/msg', component: _SalaryMsg2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'pubnishvote', breadcrumbName: '\u53D1\u5E03\u6295\u7968', path: '/pubnishvote', component: _PubnishVote2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'votelist', breadcrumbName: '\u6295\u7968\u5217\u8868', path: '/votelist', component: _VoteList2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'startvoting', breadcrumbName: '\u6295\u7968\u754C\u9762', path: '/startvoting', component: _StartVoting2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'votedetail', breadcrumbName: '\u6295\u7968\u8BE6\u60C5', path: '/votedetail', component: _VoteDetail2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'groupuserlist', breadcrumbName: '\u7FA4\u6210\u5458\u5217\u8868', path: '/groupuserlist', component: _GroupUserList2["default"] }),
	                _react2["default"].createElement(_Route2["default"], { name: 'voteoptiondetail', breadcrumbName: '\u6295\u7968\u9009\u9879\u8BE6\u60C5', path: '/voteoptiondetail', component: _VoteOptionDetail2["default"] })
	            );
	        }
	    }]);
	
	    return Root;
	}(_react2["default"].Component);
	
	(0, _reactDom.render)(_react2["default"].createElement(Root, null), document.getElementById("container"));

/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = React;

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports = ReactDOM;

/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _createHashHistory = __webpack_require__(4);
	
	var _createHashHistory2 = _interopRequireDefault(_createHashHistory);
	
	var _useQueries = __webpack_require__(21);
	
	var _useQueries2 = _interopRequireDefault(_useQueries);
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _createTransitionManager = __webpack_require__(24);
	
	var _createTransitionManager2 = _interopRequireDefault(_createTransitionManager);
	
	var _InternalPropTypes = __webpack_require__(37);
	
	var _RouterContext = __webpack_require__(38);
	
	var _RouterContext2 = _interopRequireDefault(_RouterContext);
	
	var _RouteUtils = __webpack_require__(36);
	
	var _RouterUtils = __webpack_require__(40);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	function isDeprecatedHistory(history) {
	  return !history || !history.__v2_compatible__;
	}
	
	/* istanbul ignore next: sanity check */
	function isUnsupportedHistory(history) {
	  // v3 histories expose getCurrentLocation, but aren't currently supported.
	  return history && history.getCurrentLocation;
	}
	
	var _React$PropTypes = _react2["default"].PropTypes;
	var func = _React$PropTypes.func;
	var object = _React$PropTypes.object;
	
	/**
	 * A <Router> is a high-level API for automatically setting up
	 * a router that renders a <RouterContext> with all the props
	 * it needs each time the URL changes.
	 */
	
	var Router = _react2["default"].createClass({
	  displayName: 'Router',
	
	
	  propTypes: {
	    history: object,
	    children: _InternalPropTypes.routes,
	    routes: _InternalPropTypes.routes, // alias for children
	    render: func,
	    createElement: func,
	    onError: func,
	    onUpdate: func,
	
	    // Deprecated:
	    parseQueryString: func,
	    stringifyQuery: func,
	
	    // PRIVATE: For client-side rehydration of server match.
	    matchContext: object
	  },
	
	  getDefaultProps: function getDefaultProps() {
	    return {
	      render: function render(props) {
	        return _react2["default"].createElement(_RouterContext2["default"], props);
	      }
	    };
	  },
	  getInitialState: function getInitialState() {
	    return {
	      location: null,
	      routes: null,
	      params: null,
	      components: null
	    };
	  },
	  handleError: function handleError(error) {
	    if (this.props.onError) {
	      this.props.onError.call(this, error);
	    } else {
	      // Throw errors by default so we don't silently swallow them!
	      throw error; // This error probably occurred in getChildRoutes or getComponents.
	    }
	  },
	  componentWillMount: function componentWillMount() {
	    var _this = this;
	
	    var _props = this.props;
	    var parseQueryString = _props.parseQueryString;
	    var stringifyQuery = _props.stringifyQuery;
	
	     true ? (0, _routerWarning2["default"])(!(parseQueryString || stringifyQuery), '`parseQueryString` and `stringifyQuery` are deprecated. Please create a custom history. http://tiny.cc/router-customquerystring') : void 0;
	
	    var _createRouterObjects = this.createRouterObjects();
	
	    var history = _createRouterObjects.history;
	    var transitionManager = _createRouterObjects.transitionManager;
	    var router = _createRouterObjects.router;
	
	
	    this._unlisten = transitionManager.listen(function (error, state) {
	      if (error) {
	        _this.handleError(error);
	      } else {
	        _this.setState(state, _this.props.onUpdate);
	      }
	    });
	
	    this.history = history;
	    this.router = router;
	  },
	  createRouterObjects: function createRouterObjects() {
	    var matchContext = this.props.matchContext;
	
	    if (matchContext) {
	      return matchContext;
	    }
	
	    var history = this.props.history;
	    var _props2 = this.props;
	    var routes = _props2.routes;
	    var children = _props2.children;
	
	
	    !!isUnsupportedHistory(history) ?  true ? (0, _invariant2["default"])(false, 'You have provided a history object created with history v3.x. ' + 'This version of React Router is not compatible with v3 history ' + 'objects. Please use history v2.x instead.') : (0, _invariant2["default"])(false) : void 0;
	
	    if (isDeprecatedHistory(history)) {
	      history = this.wrapDeprecatedHistory(history);
	    }
	
	    var transitionManager = (0, _createTransitionManager2["default"])(history, (0, _RouteUtils.createRoutes)(routes || children));
	    var router = (0, _RouterUtils.createRouterObject)(history, transitionManager);
	    var routingHistory = (0, _RouterUtils.createRoutingHistory)(history, transitionManager);
	
	    return { history: routingHistory, transitionManager: transitionManager, router: router };
	  },
	  wrapDeprecatedHistory: function wrapDeprecatedHistory(history) {
	    var _props3 = this.props;
	    var parseQueryString = _props3.parseQueryString;
	    var stringifyQuery = _props3.stringifyQuery;
	
	
	    var createHistory = void 0;
	    if (history) {
	       true ? (0, _routerWarning2["default"])(false, 'It appears you have provided a deprecated history object to `<Router/>`, please use a history provided by ' + 'React Router with `import { browserHistory } from \'react-router\'` or `import { hashHistory } from \'react-router\'`. ' + 'If you are using a custom history please create it with `useRouterHistory`, see http://tiny.cc/router-usinghistory for details.') : void 0;
	      createHistory = function createHistory() {
	        return history;
	      };
	    } else {
	       true ? (0, _routerWarning2["default"])(false, '`Router` no longer defaults the history prop to hash history. Please use the `hashHistory` singleton instead. http://tiny.cc/router-defaulthistory') : void 0;
	      createHistory = _createHashHistory2["default"];
	    }
	
	    return (0, _useQueries2["default"])(createHistory)({ parseQueryString: parseQueryString, stringifyQuery: stringifyQuery });
	  },
	
	
	  /* istanbul ignore next: sanity check */
	  componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
	     true ? (0, _routerWarning2["default"])(nextProps.history === this.props.history, 'You cannot change <Router history>; it will be ignored') : void 0;
	
	     true ? (0, _routerWarning2["default"])((nextProps.routes || nextProps.children) === (this.props.routes || this.props.children), 'You cannot change <Router routes>; it will be ignored') : void 0;
	  },
	  componentWillUnmount: function componentWillUnmount() {
	    if (this._unlisten) this._unlisten();
	  },
	  render: function render() {
	    var _state = this.state;
	    var location = _state.location;
	    var routes = _state.routes;
	    var params = _state.params;
	    var components = _state.components;
	    var _props4 = this.props;
	    var createElement = _props4.createElement;
	    var render = _props4.render;
	
	    var props = _objectWithoutProperties(_props4, ['createElement', 'render']);
	
	    if (location == null) return null; // Async match
	
	    // Only forward non-Router-specific props to routing context, as those are
	    // the only ones that might be custom routing context props.
	    Object.keys(Router.propTypes).forEach(function (propType) {
	      return delete props[propType];
	    });
	
	    return render(_extends({}, props, {
	      history: this.history,
	      router: this.router,
	      location: location,
	      routes: routes,
	      params: params,
	      components: components,
	      createElement: createElement
	    }));
	  }
	});
	
	exports["default"] = Router;
	module.exports = exports['default'];

/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _Actions = __webpack_require__(7);
	
	var _PathUtils = __webpack_require__(8);
	
	var _ExecutionEnvironment = __webpack_require__(9);
	
	var _DOMUtils = __webpack_require__(10);
	
	var _DOMStateStorage = __webpack_require__(11);
	
	var _createDOMHistory = __webpack_require__(12);
	
	var _createDOMHistory2 = _interopRequireDefault(_createDOMHistory);
	
	function isAbsolutePath(path) {
	  return typeof path === 'string' && path.charAt(0) === '/';
	}
	
	function ensureSlash() {
	  var path = _DOMUtils.getHashPath();
	
	  if (isAbsolutePath(path)) return true;
	
	  _DOMUtils.replaceHashPath('/' + path);
	
	  return false;
	}
	
	function addQueryStringValueToPath(path, key, value) {
	  return path + (path.indexOf('?') === -1 ? '?' : '&') + (key + '=' + value);
	}
	
	function stripQueryStringValueFromPath(path, key) {
	  return path.replace(new RegExp('[?&]?' + key + '=[a-zA-Z0-9]+'), '');
	}
	
	function getQueryStringValueFromPath(path, key) {
	  var match = path.match(new RegExp('\\?.*?\\b' + key + '=(.+?)\\b'));
	  return match && match[1];
	}
	
	var DefaultQueryKey = '_k';
	
	function createHashHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	  !_ExecutionEnvironment.canUseDOM ?  true ? _invariant2['default'](false, 'Hash history needs a DOM') : _invariant2['default'](false) : undefined;
	
	  var queryKey = options.queryKey;
	
	  if (queryKey === undefined || !!queryKey) queryKey = typeof queryKey === 'string' ? queryKey : DefaultQueryKey;
	
	  function getCurrentLocation() {
	    var path = _DOMUtils.getHashPath();
	
	    var key = undefined,
	        state = undefined;
	    if (queryKey) {
	      key = getQueryStringValueFromPath(path, queryKey);
	      path = stripQueryStringValueFromPath(path, queryKey);
	
	      if (key) {
	        state = _DOMStateStorage.readState(key);
	      } else {
	        state = null;
	        key = history.createKey();
	        _DOMUtils.replaceHashPath(addQueryStringValueToPath(path, queryKey, key));
	      }
	    } else {
	      key = state = null;
	    }
	
	    var location = _PathUtils.parsePath(path);
	
	    return history.createLocation(_extends({}, location, { state: state }), undefined, key);
	  }
	
	  function startHashChangeListener(_ref) {
	    var transitionTo = _ref.transitionTo;
	
	    function hashChangeListener() {
	      if (!ensureSlash()) return; // Always make sure hashes are preceeded with a /.
	
	      transitionTo(getCurrentLocation());
	    }
	
	    ensureSlash();
	    _DOMUtils.addEventListener(window, 'hashchange', hashChangeListener);
	
	    return function () {
	      _DOMUtils.removeEventListener(window, 'hashchange', hashChangeListener);
	    };
	  }
	
	  function finishTransition(location) {
	    var basename = location.basename;
	    var pathname = location.pathname;
	    var search = location.search;
	    var state = location.state;
	    var action = location.action;
	    var key = location.key;
	
	    if (action === _Actions.POP) return; // Nothing to do.
	
	    var path = (basename || '') + pathname + search;
	
	    if (queryKey) {
	      path = addQueryStringValueToPath(path, queryKey, key);
	      _DOMStateStorage.saveState(key, state);
	    } else {
	      // Drop key and state.
	      location.key = location.state = null;
	    }
	
	    var currentHash = _DOMUtils.getHashPath();
	
	    if (action === _Actions.PUSH) {
	      if (currentHash !== path) {
	        window.location.hash = path;
	      } else {
	         true ? _warning2['default'](false, 'You cannot PUSH the same path using hash history') : undefined;
	      }
	    } else if (currentHash !== path) {
	      // REPLACE
	      _DOMUtils.replaceHashPath(path);
	    }
	  }
	
	  var history = _createDOMHistory2['default'](_extends({}, options, {
	    getCurrentLocation: getCurrentLocation,
	    finishTransition: finishTransition,
	    saveState: _DOMStateStorage.saveState
	  }));
	
	  var listenerCount = 0,
	      stopHashChangeListener = undefined;
	
	  function listenBefore(listener) {
	    if (++listenerCount === 1) stopHashChangeListener = startHashChangeListener(history);
	
	    var unlisten = history.listenBefore(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopHashChangeListener();
	    };
	  }
	
	  function listen(listener) {
	    if (++listenerCount === 1) stopHashChangeListener = startHashChangeListener(history);
	
	    var unlisten = history.listen(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopHashChangeListener();
	    };
	  }
	
	  function push(location) {
	     true ? _warning2['default'](queryKey || location.state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.push(location);
	  }
	
	  function replace(location) {
	     true ? _warning2['default'](queryKey || location.state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.replace(location);
	  }
	
	  var goIsSupportedWithoutReload = _DOMUtils.supportsGoWithoutReloadUsingHash();
	
	  function go(n) {
	     true ? _warning2['default'](goIsSupportedWithoutReload, 'Hash history go(n) causes a full page reload in this browser') : undefined;
	
	    history.go(n);
	  }
	
	  function createHref(path) {
	    return '#' + history.createHref(path);
	  }
	
	  // deprecated
	  function registerTransitionHook(hook) {
	    if (++listenerCount === 1) stopHashChangeListener = startHashChangeListener(history);
	
	    history.registerTransitionHook(hook);
	  }
	
	  // deprecated
	  function unregisterTransitionHook(hook) {
	    history.unregisterTransitionHook(hook);
	
	    if (--listenerCount === 0) stopHashChangeListener();
	  }
	
	  // deprecated
	  function pushState(state, path) {
	     true ? _warning2['default'](queryKey || state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.pushState(state, path);
	  }
	
	  // deprecated
	  function replaceState(state, path) {
	     true ? _warning2['default'](queryKey || state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.replaceState(state, path);
	  }
	
	  return _extends({}, history, {
	    listenBefore: listenBefore,
	    listen: listen,
	    push: push,
	    replace: replace,
	    go: go,
	    createHref: createHref,
	
	    registerTransitionHook: registerTransitionHook, // deprecated - warning is in createHistory
	    unregisterTransitionHook: unregisterTransitionHook, // deprecated - warning is in createHistory
	    pushState: pushState, // deprecated - warning is in createHistory
	    replaceState: replaceState // deprecated - warning is in createHistory
	  });
	}
	
	exports['default'] = createHashHistory;
	module.exports = exports['default'];

/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Copyright 2014-2015, Facebook, Inc.
	 * All rights reserved.
	 *
	 * This source code is licensed under the BSD-style license found in the
	 * LICENSE file in the root directory of this source tree. An additional grant
	 * of patent rights can be found in the PATENTS file in the same directory.
	 */
	
	'use strict';
	
	/**
	 * Similar to invariant but only logs a warning if the condition is not met.
	 * This can be used to log issues in development environments in critical
	 * paths. Removing the logging code for production environments will keep the
	 * same logic and follow the same code paths.
	 */
	
	var warning = function() {};
	
	if (true) {
	  warning = function(condition, format, args) {
	    var len = arguments.length;
	    args = new Array(len > 2 ? len - 2 : 0);
	    for (var key = 2; key < len; key++) {
	      args[key - 2] = arguments[key];
	    }
	    if (format === undefined) {
	      throw new Error(
	        '`warning(condition, format, ...args)` requires a warning ' +
	        'message argument'
	      );
	    }
	
	    if (format.length < 10 || (/^[s\W]*$/).test(format)) {
	      throw new Error(
	        'The warning format should be able to uniquely identify this ' +
	        'warning. Please, use a more descriptive format than: ' + format
	      );
	    }
	
	    if (!condition) {
	      var argIndex = 0;
	      var message = 'Warning: ' +
	        format.replace(/%s/g, function() {
	          return args[argIndex++];
	        });
	      if (typeof console !== 'undefined') {
	        console.error(message);
	      }
	      try {
	        // This error was thrown as a convenience so that you can use this stack
	        // to find the callsite that caused this warning to fire.
	        throw new Error(message);
	      } catch(x) {}
	    }
	  };
	}
	
	module.exports = warning;


/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Copyright 2013-2015, Facebook, Inc.
	 * All rights reserved.
	 *
	 * This source code is licensed under the BSD-style license found in the
	 * LICENSE file in the root directory of this source tree. An additional grant
	 * of patent rights can be found in the PATENTS file in the same directory.
	 */
	
	'use strict';
	
	/**
	 * Use invariant() to assert state which your program assumes to be true.
	 *
	 * Provide sprintf-style format (only %s is supported) and arguments
	 * to provide information about what broke and what you were
	 * expecting.
	 *
	 * The invariant message will be stripped in production, but the invariant
	 * will remain to ensure logic does not differ in production.
	 */
	
	var invariant = function(condition, format, a, b, c, d, e, f) {
	  if (true) {
	    if (format === undefined) {
	      throw new Error('invariant requires an error message argument');
	    }
	  }
	
	  if (!condition) {
	    var error;
	    if (format === undefined) {
	      error = new Error(
	        'Minified exception occurred; use the non-minified dev environment ' +
	        'for the full error message and additional helpful warnings.'
	      );
	    } else {
	      var args = [a, b, c, d, e, f];
	      var argIndex = 0;
	      error = new Error(
	        format.replace(/%s/g, function() { return args[argIndex++]; })
	      );
	      error.name = 'Invariant Violation';
	    }
	
	    error.framesToPop = 1; // we don't care about invariant's own frame
	    throw error;
	  }
	};
	
	module.exports = invariant;


/***/ },
/* 7 */
/***/ function(module, exports) {

	/**
	 * Indicates that navigation was caused by a call to history.push.
	 */
	'use strict';
	
	exports.__esModule = true;
	var PUSH = 'PUSH';
	
	exports.PUSH = PUSH;
	/**
	 * Indicates that navigation was caused by a call to history.replace.
	 */
	var REPLACE = 'REPLACE';
	
	exports.REPLACE = REPLACE;
	/**
	 * Indicates that navigation was caused by some other action such
	 * as using a browser's back/forward buttons and/or manually manipulating
	 * the URL in a browser's location bar. This is the default.
	 *
	 * See https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onpopstate
	 * for more information.
	 */
	var POP = 'POP';
	
	exports.POP = POP;
	exports['default'] = {
	  PUSH: PUSH,
	  REPLACE: REPLACE,
	  POP: POP
	};

/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports.extractPath = extractPath;
	exports.parsePath = parsePath;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	function extractPath(string) {
	  var match = string.match(/^https?:\/\/[^\/]*/);
	
	  if (match == null) return string;
	
	  return string.substring(match[0].length);
	}
	
	function parsePath(path) {
	  var pathname = extractPath(path);
	  var search = '';
	  var hash = '';
	
	   true ? _warning2['default'](path === pathname, 'A path must be pathname + search + hash only, not a fully qualified URL like "%s"', path) : undefined;
	
	  var hashIndex = pathname.indexOf('#');
	  if (hashIndex !== -1) {
	    hash = pathname.substring(hashIndex);
	    pathname = pathname.substring(0, hashIndex);
	  }
	
	  var searchIndex = pathname.indexOf('?');
	  if (searchIndex !== -1) {
	    search = pathname.substring(searchIndex);
	    pathname = pathname.substring(0, searchIndex);
	  }
	
	  if (pathname === '') pathname = '/';
	
	  return {
	    pathname: pathname,
	    search: search,
	    hash: hash
	  };
	}

/***/ },
/* 9 */
/***/ function(module, exports) {

	'use strict';
	
	exports.__esModule = true;
	var canUseDOM = !!(typeof window !== 'undefined' && window.document && window.document.createElement);
	exports.canUseDOM = canUseDOM;

/***/ },
/* 10 */
/***/ function(module, exports) {

	'use strict';
	
	exports.__esModule = true;
	exports.addEventListener = addEventListener;
	exports.removeEventListener = removeEventListener;
	exports.getHashPath = getHashPath;
	exports.replaceHashPath = replaceHashPath;
	exports.getWindowPath = getWindowPath;
	exports.go = go;
	exports.getUserConfirmation = getUserConfirmation;
	exports.supportsHistory = supportsHistory;
	exports.supportsGoWithoutReloadUsingHash = supportsGoWithoutReloadUsingHash;
	
	function addEventListener(node, event, listener) {
	  if (node.addEventListener) {
	    node.addEventListener(event, listener, false);
	  } else {
	    node.attachEvent('on' + event, listener);
	  }
	}
	
	function removeEventListener(node, event, listener) {
	  if (node.removeEventListener) {
	    node.removeEventListener(event, listener, false);
	  } else {
	    node.detachEvent('on' + event, listener);
	  }
	}
	
	function getHashPath() {
	  // We can't use window.location.hash here because it's not
	  // consistent across browsers - Firefox will pre-decode it!
	  return window.location.href.split('#')[1] || '';
	}
	
	function replaceHashPath(path) {
	  window.location.replace(window.location.pathname + window.location.search + '#' + path);
	}
	
	function getWindowPath() {
	  return window.location.pathname + window.location.search + window.location.hash;
	}
	
	function go(n) {
	  if (n) window.history.go(n);
	}
	
	function getUserConfirmation(message, callback) {
	  callback(window.confirm(message));
	}
	
	/**
	 * Returns true if the HTML5 history API is supported. Taken from Modernizr.
	 *
	 * https://github.com/Modernizr/Modernizr/blob/master/LICENSE
	 * https://github.com/Modernizr/Modernizr/blob/master/feature-detects/history.js
	 * changed to avoid false negatives for Windows Phones: https://github.com/rackt/react-router/issues/586
	 */
	
	function supportsHistory() {
	  var ua = navigator.userAgent;
	  if ((ua.indexOf('Android 2.') !== -1 || ua.indexOf('Android 4.0') !== -1) && ua.indexOf('Mobile Safari') !== -1 && ua.indexOf('Chrome') === -1 && ua.indexOf('Windows Phone') === -1) {
	    return false;
	  }
	  return window.history && 'pushState' in window.history;
	}
	
	/**
	 * Returns false if using go(n) with hash history causes a full page reload.
	 */
	
	function supportsGoWithoutReloadUsingHash() {
	  var ua = navigator.userAgent;
	  return ua.indexOf('Firefox') === -1;
	}

/***/ },
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	/*eslint-disable no-empty */
	'use strict';
	
	exports.__esModule = true;
	exports.saveState = saveState;
	exports.readState = readState;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var KeyPrefix = '@@History/';
	var QuotaExceededErrors = ['QuotaExceededError', 'QUOTA_EXCEEDED_ERR'];
	
	var SecurityError = 'SecurityError';
	
	function createKey(key) {
	  return KeyPrefix + key;
	}
	
	function saveState(key, state) {
	  try {
	    if (state == null) {
	      window.sessionStorage.removeItem(createKey(key));
	    } else {
	      window.sessionStorage.setItem(createKey(key), JSON.stringify(state));
	    }
	  } catch (error) {
	    if (error.name === SecurityError) {
	      // Blocking cookies in Chrome/Firefox/Safari throws SecurityError on any
	      // attempt to access window.sessionStorage.
	       true ? _warning2['default'](false, '[history] Unable to save state; sessionStorage is not available due to security settings') : undefined;
	
	      return;
	    }
	
	    if (QuotaExceededErrors.indexOf(error.name) >= 0 && window.sessionStorage.length === 0) {
	      // Safari "private mode" throws QuotaExceededError.
	       true ? _warning2['default'](false, '[history] Unable to save state; sessionStorage is not available in Safari private mode') : undefined;
	
	      return;
	    }
	
	    throw error;
	  }
	}
	
	function readState(key) {
	  var json = undefined;
	  try {
	    json = window.sessionStorage.getItem(createKey(key));
	  } catch (error) {
	    if (error.name === SecurityError) {
	      // Blocking cookies in Chrome/Firefox/Safari throws SecurityError on any
	      // attempt to access window.sessionStorage.
	       true ? _warning2['default'](false, '[history] Unable to read state; sessionStorage is not available due to security settings') : undefined;
	
	      return null;
	    }
	  }
	
	  if (json) {
	    try {
	      return JSON.parse(json);
	    } catch (error) {
	      // Ignore invalid JSON.
	    }
	  }
	
	  return null;
	}

/***/ },
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _ExecutionEnvironment = __webpack_require__(9);
	
	var _DOMUtils = __webpack_require__(10);
	
	var _createHistory = __webpack_require__(13);
	
	var _createHistory2 = _interopRequireDefault(_createHistory);
	
	function createDOMHistory(options) {
	  var history = _createHistory2['default'](_extends({
	    getUserConfirmation: _DOMUtils.getUserConfirmation
	  }, options, {
	    go: _DOMUtils.go
	  }));
	
	  function listen(listener) {
	    !_ExecutionEnvironment.canUseDOM ?  true ? _invariant2['default'](false, 'DOM history needs a DOM') : _invariant2['default'](false) : undefined;
	
	    return history.listen(listener);
	  }
	
	  return _extends({}, history, {
	    listen: listen
	  });
	}
	
	exports['default'] = createDOMHistory;
	module.exports = exports['default'];

/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _deepEqual = __webpack_require__(14);
	
	var _deepEqual2 = _interopRequireDefault(_deepEqual);
	
	var _PathUtils = __webpack_require__(8);
	
	var _AsyncUtils = __webpack_require__(17);
	
	var _Actions = __webpack_require__(7);
	
	var _createLocation2 = __webpack_require__(18);
	
	var _createLocation3 = _interopRequireDefault(_createLocation2);
	
	var _runTransitionHook = __webpack_require__(19);
	
	var _runTransitionHook2 = _interopRequireDefault(_runTransitionHook);
	
	var _deprecate = __webpack_require__(20);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	function createRandomKey(length) {
	  return Math.random().toString(36).substr(2, length);
	}
	
	function locationsAreEqual(a, b) {
	  return a.pathname === b.pathname && a.search === b.search &&
	  //a.action === b.action && // Different action !== location change.
	  a.key === b.key && _deepEqual2['default'](a.state, b.state);
	}
	
	var DefaultKeyLength = 6;
	
	function createHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	  var getCurrentLocation = options.getCurrentLocation;
	  var finishTransition = options.finishTransition;
	  var saveState = options.saveState;
	  var go = options.go;
	  var getUserConfirmation = options.getUserConfirmation;
	  var keyLength = options.keyLength;
	
	  if (typeof keyLength !== 'number') keyLength = DefaultKeyLength;
	
	  var transitionHooks = [];
	
	  function listenBefore(hook) {
	    transitionHooks.push(hook);
	
	    return function () {
	      transitionHooks = transitionHooks.filter(function (item) {
	        return item !== hook;
	      });
	    };
	  }
	
	  var allKeys = [];
	  var changeListeners = [];
	  var location = undefined;
	
	  function getCurrent() {
	    if (pendingLocation && pendingLocation.action === _Actions.POP) {
	      return allKeys.indexOf(pendingLocation.key);
	    } else if (location) {
	      return allKeys.indexOf(location.key);
	    } else {
	      return -1;
	    }
	  }
	
	  function updateLocation(newLocation) {
	    var current = getCurrent();
	
	    location = newLocation;
	
	    if (location.action === _Actions.PUSH) {
	      allKeys = [].concat(allKeys.slice(0, current + 1), [location.key]);
	    } else if (location.action === _Actions.REPLACE) {
	      allKeys[current] = location.key;
	    }
	
	    changeListeners.forEach(function (listener) {
	      listener(location);
	    });
	  }
	
	  function listen(listener) {
	    changeListeners.push(listener);
	
	    if (location) {
	      listener(location);
	    } else {
	      var _location = getCurrentLocation();
	      allKeys = [_location.key];
	      updateLocation(_location);
	    }
	
	    return function () {
	      changeListeners = changeListeners.filter(function (item) {
	        return item !== listener;
	      });
	    };
	  }
	
	  function confirmTransitionTo(location, callback) {
	    _AsyncUtils.loopAsync(transitionHooks.length, function (index, next, done) {
	      _runTransitionHook2['default'](transitionHooks[index], location, function (result) {
	        if (result != null) {
	          done(result);
	        } else {
	          next();
	        }
	      });
	    }, function (message) {
	      if (getUserConfirmation && typeof message === 'string') {
	        getUserConfirmation(message, function (ok) {
	          callback(ok !== false);
	        });
	      } else {
	        callback(message !== false);
	      }
	    });
	  }
	
	  var pendingLocation = undefined;
	
	  function transitionTo(nextLocation) {
	    if (location && locationsAreEqual(location, nextLocation)) return; // Nothing to do.
	
	    pendingLocation = nextLocation;
	
	    confirmTransitionTo(nextLocation, function (ok) {
	      if (pendingLocation !== nextLocation) return; // Transition was interrupted.
	
	      if (ok) {
	        // treat PUSH to current path like REPLACE to be consistent with browsers
	        if (nextLocation.action === _Actions.PUSH) {
	          var prevPath = createPath(location);
	          var nextPath = createPath(nextLocation);
	
	          if (nextPath === prevPath && _deepEqual2['default'](location.state, nextLocation.state)) nextLocation.action = _Actions.REPLACE;
	        }
	
	        if (finishTransition(nextLocation) !== false) updateLocation(nextLocation);
	      } else if (location && nextLocation.action === _Actions.POP) {
	        var prevIndex = allKeys.indexOf(location.key);
	        var nextIndex = allKeys.indexOf(nextLocation.key);
	
	        if (prevIndex !== -1 && nextIndex !== -1) go(prevIndex - nextIndex); // Restore the URL.
	      }
	    });
	  }
	
	  function push(location) {
	    transitionTo(createLocation(location, _Actions.PUSH, createKey()));
	  }
	
	  function replace(location) {
	    transitionTo(createLocation(location, _Actions.REPLACE, createKey()));
	  }
	
	  function goBack() {
	    go(-1);
	  }
	
	  function goForward() {
	    go(1);
	  }
	
	  function createKey() {
	    return createRandomKey(keyLength);
	  }
	
	  function createPath(location) {
	    if (location == null || typeof location === 'string') return location;
	
	    var pathname = location.pathname;
	    var search = location.search;
	    var hash = location.hash;
	
	    var result = pathname;
	
	    if (search) result += search;
	
	    if (hash) result += hash;
	
	    return result;
	  }
	
	  function createHref(location) {
	    return createPath(location);
	  }
	
	  function createLocation(location, action) {
	    var key = arguments.length <= 2 || arguments[2] === undefined ? createKey() : arguments[2];
	
	    if (typeof action === 'object') {
	       true ? _warning2['default'](false, 'The state (2nd) argument to history.createLocation is deprecated; use a ' + 'location descriptor instead') : undefined;
	
	      if (typeof location === 'string') location = _PathUtils.parsePath(location);
	
	      location = _extends({}, location, { state: action });
	
	      action = key;
	      key = arguments[3] || createKey();
	    }
	
	    return _createLocation3['default'](location, action, key);
	  }
	
	  // deprecated
	  function setState(state) {
	    if (location) {
	      updateLocationState(location, state);
	      updateLocation(location);
	    } else {
	      updateLocationState(getCurrentLocation(), state);
	    }
	  }
	
	  function updateLocationState(location, state) {
	    location.state = _extends({}, location.state, state);
	    saveState(location.key, location.state);
	  }
	
	  // deprecated
	  function registerTransitionHook(hook) {
	    if (transitionHooks.indexOf(hook) === -1) transitionHooks.push(hook);
	  }
	
	  // deprecated
	  function unregisterTransitionHook(hook) {
	    transitionHooks = transitionHooks.filter(function (item) {
	      return item !== hook;
	    });
	  }
	
	  // deprecated
	  function pushState(state, path) {
	    if (typeof path === 'string') path = _PathUtils.parsePath(path);
	
	    push(_extends({ state: state }, path));
	  }
	
	  // deprecated
	  function replaceState(state, path) {
	    if (typeof path === 'string') path = _PathUtils.parsePath(path);
	
	    replace(_extends({ state: state }, path));
	  }
	
	  return {
	    listenBefore: listenBefore,
	    listen: listen,
	    transitionTo: transitionTo,
	    push: push,
	    replace: replace,
	    go: go,
	    goBack: goBack,
	    goForward: goForward,
	    createKey: createKey,
	    createPath: createPath,
	    createHref: createHref,
	    createLocation: createLocation,
	
	    setState: _deprecate2['default'](setState, 'setState is deprecated; use location.key to save state instead'),
	    registerTransitionHook: _deprecate2['default'](registerTransitionHook, 'registerTransitionHook is deprecated; use listenBefore instead'),
	    unregisterTransitionHook: _deprecate2['default'](unregisterTransitionHook, 'unregisterTransitionHook is deprecated; use the callback returned from listenBefore instead'),
	    pushState: _deprecate2['default'](pushState, 'pushState is deprecated; use push instead'),
	    replaceState: _deprecate2['default'](replaceState, 'replaceState is deprecated; use replace instead')
	  };
	}
	
	exports['default'] = createHistory;
	module.exports = exports['default'];

/***/ },
/* 14 */
/***/ function(module, exports, __webpack_require__) {

	var pSlice = Array.prototype.slice;
	var objectKeys = __webpack_require__(15);
	var isArguments = __webpack_require__(16);
	
	var deepEqual = module.exports = function (actual, expected, opts) {
	  if (!opts) opts = {};
	  // 7.1. All identical values are equivalent, as determined by ===.
	  if (actual === expected) {
	    return true;
	
	  } else if (actual instanceof Date && expected instanceof Date) {
	    return actual.getTime() === expected.getTime();
	
	  // 7.3. Other pairs that do not both pass typeof value == 'object',
	  // equivalence is determined by ==.
	  } else if (!actual || !expected || typeof actual != 'object' && typeof expected != 'object') {
	    return opts.strict ? actual === expected : actual == expected;
	
	  // 7.4. For all other Object pairs, including Array objects, equivalence is
	  // determined by having the same number of owned properties (as verified
	  // with Object.prototype.hasOwnProperty.call), the same set of keys
	  // (although not necessarily the same order), equivalent values for every
	  // corresponding key, and an identical 'prototype' property. Note: this
	  // accounts for both named and indexed properties on Arrays.
	  } else {
	    return objEquiv(actual, expected, opts);
	  }
	}
	
	function isUndefinedOrNull(value) {
	  return value === null || value === undefined;
	}
	
	function isBuffer (x) {
	  if (!x || typeof x !== 'object' || typeof x.length !== 'number') return false;
	  if (typeof x.copy !== 'function' || typeof x.slice !== 'function') {
	    return false;
	  }
	  if (x.length > 0 && typeof x[0] !== 'number') return false;
	  return true;
	}
	
	function objEquiv(a, b, opts) {
	  var i, key;
	  if (isUndefinedOrNull(a) || isUndefinedOrNull(b))
	    return false;
	  // an identical 'prototype' property.
	  if (a.prototype !== b.prototype) return false;
	  //~~~I've managed to break Object.keys through screwy arguments passing.
	  //   Converting to array solves the problem.
	  if (isArguments(a)) {
	    if (!isArguments(b)) {
	      return false;
	    }
	    a = pSlice.call(a);
	    b = pSlice.call(b);
	    return deepEqual(a, b, opts);
	  }
	  if (isBuffer(a)) {
	    if (!isBuffer(b)) {
	      return false;
	    }
	    if (a.length !== b.length) return false;
	    for (i = 0; i < a.length; i++) {
	      if (a[i] !== b[i]) return false;
	    }
	    return true;
	  }
	  try {
	    var ka = objectKeys(a),
	        kb = objectKeys(b);
	  } catch (e) {//happens when one is a string literal and the other isn't
	    return false;
	  }
	  // having the same number of owned properties (keys incorporates
	  // hasOwnProperty)
	  if (ka.length != kb.length)
	    return false;
	  //the same set of keys (although not necessarily the same order),
	  ka.sort();
	  kb.sort();
	  //~~~cheap key test
	  for (i = ka.length - 1; i >= 0; i--) {
	    if (ka[i] != kb[i])
	      return false;
	  }
	  //equivalent values for every corresponding key, and
	  //~~~possibly expensive deep test
	  for (i = ka.length - 1; i >= 0; i--) {
	    key = ka[i];
	    if (!deepEqual(a[key], b[key], opts)) return false;
	  }
	  return typeof a === typeof b;
	}


/***/ },
/* 15 */
/***/ function(module, exports) {

	exports = module.exports = typeof Object.keys === 'function'
	  ? Object.keys : shim;
	
	exports.shim = shim;
	function shim (obj) {
	  var keys = [];
	  for (var key in obj) keys.push(key);
	  return keys;
	}


/***/ },
/* 16 */
/***/ function(module, exports) {

	var supportsArgumentsClass = (function(){
	  return Object.prototype.toString.call(arguments)
	})() == '[object Arguments]';
	
	exports = module.exports = supportsArgumentsClass ? supported : unsupported;
	
	exports.supported = supported;
	function supported(object) {
	  return Object.prototype.toString.call(object) == '[object Arguments]';
	};
	
	exports.unsupported = unsupported;
	function unsupported(object){
	  return object &&
	    typeof object == 'object' &&
	    typeof object.length == 'number' &&
	    Object.prototype.hasOwnProperty.call(object, 'callee') &&
	    !Object.prototype.propertyIsEnumerable.call(object, 'callee') ||
	    false;
	};


/***/ },
/* 17 */
/***/ function(module, exports) {

	"use strict";
	
	exports.__esModule = true;
	var _slice = Array.prototype.slice;
	exports.loopAsync = loopAsync;
	
	function loopAsync(turns, work, callback) {
	  var currentTurn = 0,
	      isDone = false;
	  var sync = false,
	      hasNext = false,
	      doneArgs = undefined;
	
	  function done() {
	    isDone = true;
	    if (sync) {
	      // Iterate instead of recursing if possible.
	      doneArgs = [].concat(_slice.call(arguments));
	      return;
	    }
	
	    callback.apply(this, arguments);
	  }
	
	  function next() {
	    if (isDone) {
	      return;
	    }
	
	    hasNext = true;
	    if (sync) {
	      // Iterate instead of recursing if possible.
	      return;
	    }
	
	    sync = true;
	
	    while (!isDone && currentTurn < turns && hasNext) {
	      hasNext = false;
	      work.call(this, currentTurn++, next, done);
	    }
	
	    sync = false;
	
	    if (isDone) {
	      // This means the loop finished synchronously.
	      callback.apply(this, doneArgs);
	      return;
	    }
	
	    if (currentTurn >= turns && hasNext) {
	      isDone = true;
	      callback();
	    }
	  }
	
	  next();
	}

/***/ },
/* 18 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _Actions = __webpack_require__(7);
	
	var _PathUtils = __webpack_require__(8);
	
	function createLocation() {
	  var location = arguments.length <= 0 || arguments[0] === undefined ? '/' : arguments[0];
	  var action = arguments.length <= 1 || arguments[1] === undefined ? _Actions.POP : arguments[1];
	  var key = arguments.length <= 2 || arguments[2] === undefined ? null : arguments[2];
	
	  var _fourthArg = arguments.length <= 3 || arguments[3] === undefined ? null : arguments[3];
	
	  if (typeof location === 'string') location = _PathUtils.parsePath(location);
	
	  if (typeof action === 'object') {
	     true ? _warning2['default'](false, 'The state (2nd) argument to createLocation is deprecated; use a ' + 'location descriptor instead') : undefined;
	
	    location = _extends({}, location, { state: action });
	
	    action = key || _Actions.POP;
	    key = _fourthArg;
	  }
	
	  var pathname = location.pathname || '/';
	  var search = location.search || '';
	  var hash = location.hash || '';
	  var state = location.state || null;
	
	  return {
	    pathname: pathname,
	    search: search,
	    hash: hash,
	    state: state,
	    action: action,
	    key: key
	  };
	}
	
	exports['default'] = createLocation;
	module.exports = exports['default'];

/***/ },
/* 19 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	function runTransitionHook(hook, location, callback) {
	  var result = hook(location, callback);
	
	  if (hook.length < 2) {
	    // Assume the hook runs synchronously and automatically
	    // call the callback with the return value.
	    callback(result);
	  } else {
	     true ? _warning2['default'](result === undefined, 'You should not "return" in a transition hook with a callback argument; call the callback instead') : undefined;
	  }
	}
	
	exports['default'] = runTransitionHook;
	module.exports = exports['default'];

/***/ },
/* 20 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	function deprecate(fn, message) {
	  return function () {
	     true ? _warning2['default'](false, '[history] ' + message) : undefined;
	    return fn.apply(this, arguments);
	  };
	}
	
	exports['default'] = deprecate;
	module.exports = exports['default'];

/***/ },
/* 21 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _queryString = __webpack_require__(22);
	
	var _runTransitionHook = __webpack_require__(19);
	
	var _runTransitionHook2 = _interopRequireDefault(_runTransitionHook);
	
	var _PathUtils = __webpack_require__(8);
	
	var _deprecate = __webpack_require__(20);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	var SEARCH_BASE_KEY = '$searchBase';
	
	function defaultStringifyQuery(query) {
	  return _queryString.stringify(query).replace(/%20/g, '+');
	}
	
	var defaultParseQueryString = _queryString.parse;
	
	function isNestedObject(object) {
	  for (var p in object) {
	    if (Object.prototype.hasOwnProperty.call(object, p) && typeof object[p] === 'object' && !Array.isArray(object[p]) && object[p] !== null) return true;
	  }return false;
	}
	
	/**
	 * Returns a new createHistory function that may be used to create
	 * history objects that know how to handle URL queries.
	 */
	function useQueries(createHistory) {
	  return function () {
	    var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	    var history = createHistory(options);
	
	    var stringifyQuery = options.stringifyQuery;
	    var parseQueryString = options.parseQueryString;
	
	    if (typeof stringifyQuery !== 'function') stringifyQuery = defaultStringifyQuery;
	
	    if (typeof parseQueryString !== 'function') parseQueryString = defaultParseQueryString;
	
	    function addQuery(location) {
	      if (location.query == null) {
	        var search = location.search;
	
	        location.query = parseQueryString(search.substring(1));
	        location[SEARCH_BASE_KEY] = { search: search, searchBase: '' };
	      }
	
	      // TODO: Instead of all the book-keeping here, this should just strip the
	      // stringified query from the search.
	
	      return location;
	    }
	
	    function appendQuery(location, query) {
	      var _extends2;
	
	      var searchBaseSpec = location[SEARCH_BASE_KEY];
	      var queryString = query ? stringifyQuery(query) : '';
	      if (!searchBaseSpec && !queryString) {
	        return location;
	      }
	
	       true ? _warning2['default'](stringifyQuery !== defaultStringifyQuery || !isNestedObject(query), 'useQueries does not stringify nested query objects by default; ' + 'use a custom stringifyQuery function') : undefined;
	
	      if (typeof location === 'string') location = _PathUtils.parsePath(location);
	
	      var searchBase = undefined;
	      if (searchBaseSpec && location.search === searchBaseSpec.search) {
	        searchBase = searchBaseSpec.searchBase;
	      } else {
	        searchBase = location.search || '';
	      }
	
	      var search = searchBase;
	      if (queryString) {
	        search += (search ? '&' : '?') + queryString;
	      }
	
	      return _extends({}, location, (_extends2 = {
	        search: search
	      }, _extends2[SEARCH_BASE_KEY] = { search: search, searchBase: searchBase }, _extends2));
	    }
	
	    // Override all read methods with query-aware versions.
	    function listenBefore(hook) {
	      return history.listenBefore(function (location, callback) {
	        _runTransitionHook2['default'](hook, addQuery(location), callback);
	      });
	    }
	
	    function listen(listener) {
	      return history.listen(function (location) {
	        listener(addQuery(location));
	      });
	    }
	
	    // Override all write methods with query-aware versions.
	    function push(location) {
	      history.push(appendQuery(location, location.query));
	    }
	
	    function replace(location) {
	      history.replace(appendQuery(location, location.query));
	    }
	
	    function createPath(location, query) {
	       true ? _warning2['default'](!query, 'the query argument to createPath is deprecated; use a location descriptor instead') : undefined;
	
	      return history.createPath(appendQuery(location, query || location.query));
	    }
	
	    function createHref(location, query) {
	       true ? _warning2['default'](!query, 'the query argument to createHref is deprecated; use a location descriptor instead') : undefined;
	
	      return history.createHref(appendQuery(location, query || location.query));
	    }
	
	    function createLocation(location) {
	      for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
	        args[_key - 1] = arguments[_key];
	      }
	
	      var fullLocation = history.createLocation.apply(history, [appendQuery(location, location.query)].concat(args));
	      if (location.query) {
	        fullLocation.query = location.query;
	      }
	      return addQuery(fullLocation);
	    }
	
	    // deprecated
	    function pushState(state, path, query) {
	      if (typeof path === 'string') path = _PathUtils.parsePath(path);
	
	      push(_extends({ state: state }, path, { query: query }));
	    }
	
	    // deprecated
	    function replaceState(state, path, query) {
	      if (typeof path === 'string') path = _PathUtils.parsePath(path);
	
	      replace(_extends({ state: state }, path, { query: query }));
	    }
	
	    return _extends({}, history, {
	      listenBefore: listenBefore,
	      listen: listen,
	      push: push,
	      replace: replace,
	      createPath: createPath,
	      createHref: createHref,
	      createLocation: createLocation,
	
	      pushState: _deprecate2['default'](pushState, 'pushState is deprecated; use push instead'),
	      replaceState: _deprecate2['default'](replaceState, 'replaceState is deprecated; use replace instead')
	    });
	  };
	}
	
	exports['default'] = useQueries;
	module.exports = exports['default'];

/***/ },
/* 22 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	var strictUriEncode = __webpack_require__(23);
	
	exports.extract = function (str) {
		return str.split('?')[1] || '';
	};
	
	exports.parse = function (str) {
		if (typeof str !== 'string') {
			return {};
		}
	
		str = str.trim().replace(/^(\?|#|&)/, '');
	
		if (!str) {
			return {};
		}
	
		return str.split('&').reduce(function (ret, param) {
			var parts = param.replace(/\+/g, ' ').split('=');
			// Firefox (pre 40) decodes `%3D` to `=`
			// https://github.com/sindresorhus/query-string/pull/37
			var key = parts.shift();
			var val = parts.length > 0 ? parts.join('=') : undefined;
	
			key = decodeURIComponent(key);
	
			// missing `=` should be `null`:
			// http://w3.org/TR/2012/WD-url-20120524/#collect-url-parameters
			val = val === undefined ? null : decodeURIComponent(val);
	
			if (!ret.hasOwnProperty(key)) {
				ret[key] = val;
			} else if (Array.isArray(ret[key])) {
				ret[key].push(val);
			} else {
				ret[key] = [ret[key], val];
			}
	
			return ret;
		}, {});
	};
	
	exports.stringify = function (obj) {
		return obj ? Object.keys(obj).sort().map(function (key) {
			var val = obj[key];
	
			if (val === undefined) {
				return '';
			}
	
			if (val === null) {
				return key;
			}
	
			if (Array.isArray(val)) {
				return val.slice().sort().map(function (val2) {
					return strictUriEncode(key) + '=' + strictUriEncode(val2);
				}).join('&');
			}
	
			return strictUriEncode(key) + '=' + strictUriEncode(val);
		}).filter(function (x) {
			return x.length > 0;
		}).join('&') : '';
	};


/***/ },
/* 23 */
/***/ function(module, exports) {

	'use strict';
	module.exports = function (str) {
		return encodeURIComponent(str).replace(/[!'()*]/g, function (c) {
			return '%' + c.charCodeAt(0).toString(16).toUpperCase();
		});
	};


/***/ },
/* 24 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	exports["default"] = createTransitionManager;
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	var _computeChangedRoutes2 = __webpack_require__(27);
	
	var _computeChangedRoutes3 = _interopRequireDefault(_computeChangedRoutes2);
	
	var _TransitionUtils = __webpack_require__(29);
	
	var _isActive2 = __webpack_require__(31);
	
	var _isActive3 = _interopRequireDefault(_isActive2);
	
	var _getComponents = __webpack_require__(32);
	
	var _getComponents2 = _interopRequireDefault(_getComponents);
	
	var _matchRoutes = __webpack_require__(35);
	
	var _matchRoutes2 = _interopRequireDefault(_matchRoutes);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function hasAnyProperties(object) {
	  for (var p in object) {
	    if (Object.prototype.hasOwnProperty.call(object, p)) return true;
	  }return false;
	}
	
	function createTransitionManager(history, routes) {
	  var state = {};
	
	  // Signature should be (location, indexOnly), but needs to support (path,
	  // query, indexOnly)
	  function isActive(location) {
	    var indexOnlyOrDeprecatedQuery = arguments.length <= 1 || arguments[1] === undefined ? false : arguments[1];
	    var deprecatedIndexOnly = arguments.length <= 2 || arguments[2] === undefined ? null : arguments[2];
	
	    var indexOnly = void 0;
	    if (indexOnlyOrDeprecatedQuery && indexOnlyOrDeprecatedQuery !== true || deprecatedIndexOnly !== null) {
	       true ? (0, _routerWarning2["default"])(false, '`isActive(pathname, query, indexOnly) is deprecated; use `isActive(location, indexOnly)` with a location descriptor instead. http://tiny.cc/router-isActivedeprecated') : void 0;
	      location = { pathname: location, query: indexOnlyOrDeprecatedQuery };
	      indexOnly = deprecatedIndexOnly || false;
	    } else {
	      location = history.createLocation(location);
	      indexOnly = indexOnlyOrDeprecatedQuery;
	    }
	
	    return (0, _isActive3["default"])(location, indexOnly, state.location, state.routes, state.params);
	  }
	
	  var partialNextState = void 0;
	
	  function match(location, callback) {
	    if (partialNextState && partialNextState.location === location) {
	      // Continue from where we left off.
	      finishMatch(partialNextState, callback);
	    } else {
	      (0, _matchRoutes2["default"])(routes, location, function (error, nextState) {
	        if (error) {
	          callback(error);
	        } else if (nextState) {
	          finishMatch(_extends({}, nextState, { location: location }), callback);
	        } else {
	          callback();
	        }
	      });
	    }
	  }
	
	  function finishMatch(nextState, callback) {
	    var _computeChangedRoutes = (0, _computeChangedRoutes3["default"])(state, nextState);
	
	    var leaveRoutes = _computeChangedRoutes.leaveRoutes;
	    var changeRoutes = _computeChangedRoutes.changeRoutes;
	    var enterRoutes = _computeChangedRoutes.enterRoutes;
	
	
	    (0, _TransitionUtils.runLeaveHooks)(leaveRoutes, state);
	
	    // Tear down confirmation hooks for left routes
	    leaveRoutes.filter(function (route) {
	      return enterRoutes.indexOf(route) === -1;
	    }).forEach(removeListenBeforeHooksForRoute);
	
	    // change and enter hooks are run in series
	    (0, _TransitionUtils.runChangeHooks)(changeRoutes, state, nextState, function (error, redirectInfo) {
	      if (error || redirectInfo) return handleErrorOrRedirect(error, redirectInfo);
	
	      (0, _TransitionUtils.runEnterHooks)(enterRoutes, nextState, finishEnterHooks);
	    });
	
	    function finishEnterHooks(error, redirectInfo) {
	      if (error || redirectInfo) return handleErrorOrRedirect(error, redirectInfo);
	
	      // TODO: Fetch components after state is updated.
	      (0, _getComponents2["default"])(nextState, function (error, components) {
	        if (error) {
	          callback(error);
	        } else {
	          // TODO: Make match a pure function and have some other API
	          // for "match and update state".
	          callback(null, null, state = _extends({}, nextState, { components: components }));
	        }
	      });
	    }
	
	    function handleErrorOrRedirect(error, redirectInfo) {
	      if (error) callback(error);else callback(null, redirectInfo);
	    }
	  }
	
	  var RouteGuid = 1;
	
	  function getRouteID(route) {
	    var create = arguments.length <= 1 || arguments[1] === undefined ? true : arguments[1];
	
	    return route.__id__ || create && (route.__id__ = RouteGuid++);
	  }
	
	  var RouteHooks = Object.create(null);
	
	  function getRouteHooksForRoutes(routes) {
	    return routes.reduce(function (hooks, route) {
	      hooks.push.apply(hooks, RouteHooks[getRouteID(route)]);
	      return hooks;
	    }, []);
	  }
	
	  function transitionHook(location, callback) {
	    (0, _matchRoutes2["default"])(routes, location, function (error, nextState) {
	      if (nextState == null) {
	        // TODO: We didn't actually match anything, but hang
	        // onto error/nextState so we don't have to matchRoutes
	        // again in the listen callback.
	        callback();
	        return;
	      }
	
	      // Cache some state here so we don't have to
	      // matchRoutes() again in the listen callback.
	      partialNextState = _extends({}, nextState, { location: location });
	
	      var hooks = getRouteHooksForRoutes((0, _computeChangedRoutes3["default"])(state, partialNextState).leaveRoutes);
	
	      var result = void 0;
	      for (var i = 0, len = hooks.length; result == null && i < len; ++i) {
	        // Passing the location arg here indicates to
	        // the user that this is a transition hook.
	        result = hooks[i](location);
	      }
	
	      callback(result);
	    });
	  }
	
	  /* istanbul ignore next: untestable with Karma */
	  function beforeUnloadHook() {
	    // Synchronously check to see if any route hooks want
	    // to prevent the current window/tab from closing.
	    if (state.routes) {
	      var hooks = getRouteHooksForRoutes(state.routes);
	
	      var message = void 0;
	      for (var i = 0, len = hooks.length; typeof message !== 'string' && i < len; ++i) {
	        // Passing no args indicates to the user that this is a
	        // beforeunload hook. We don't know the next location.
	        message = hooks[i]();
	      }
	
	      return message;
	    }
	  }
	
	  var unlistenBefore = void 0,
	      unlistenBeforeUnload = void 0;
	
	  function removeListenBeforeHooksForRoute(route) {
	    var routeID = getRouteID(route, false);
	    if (!routeID) {
	      return;
	    }
	
	    delete RouteHooks[routeID];
	
	    if (!hasAnyProperties(RouteHooks)) {
	      // teardown transition & beforeunload hooks
	      if (unlistenBefore) {
	        unlistenBefore();
	        unlistenBefore = null;
	      }
	
	      if (unlistenBeforeUnload) {
	        unlistenBeforeUnload();
	        unlistenBeforeUnload = null;
	      }
	    }
	  }
	
	  /**
	   * Registers the given hook function to run before leaving the given route.
	   *
	   * During a normal transition, the hook function receives the next location
	   * as its only argument and can return either a prompt message (string) to show the user,
	   * to make sure they want to leave the page; or `false`, to prevent the transition.
	   * Any other return value will have no effect.
	   *
	   * During the beforeunload event (in browsers) the hook receives no arguments.
	   * In this case it must return a prompt message to prevent the transition.
	   *
	   * Returns a function that may be used to unbind the listener.
	   */
	  function listenBeforeLeavingRoute(route, hook) {
	    // TODO: Warn if they register for a route that isn't currently
	    // active. They're probably doing something wrong, like re-creating
	    // route objects on every location change.
	    var routeID = getRouteID(route);
	    var hooks = RouteHooks[routeID];
	
	    if (!hooks) {
	      var thereWereNoRouteHooks = !hasAnyProperties(RouteHooks);
	
	      RouteHooks[routeID] = [hook];
	
	      if (thereWereNoRouteHooks) {
	        // setup transition & beforeunload hooks
	        unlistenBefore = history.listenBefore(transitionHook);
	
	        if (history.listenBeforeUnload) unlistenBeforeUnload = history.listenBeforeUnload(beforeUnloadHook);
	      }
	    } else {
	      if (hooks.indexOf(hook) === -1) {
	         true ? (0, _routerWarning2["default"])(false, 'adding multiple leave hooks for the same route is deprecated; manage multiple confirmations in your own code instead') : void 0;
	
	        hooks.push(hook);
	      }
	    }
	
	    return function () {
	      var hooks = RouteHooks[routeID];
	
	      if (hooks) {
	        var newHooks = hooks.filter(function (item) {
	          return item !== hook;
	        });
	
	        if (newHooks.length === 0) {
	          removeListenBeforeHooksForRoute(route);
	        } else {
	          RouteHooks[routeID] = newHooks;
	        }
	      }
	    };
	  }
	
	  /**
	   * This is the API for stateful environments. As the location
	   * changes, we update state and call the listener. We can also
	   * gracefully handle errors and redirects.
	   */
	  function listen(listener) {
	    // TODO: Only use a single history listener. Otherwise we'll
	    // end up with multiple concurrent calls to match.
	    return history.listen(function (location) {
	      if (state.location === location) {
	        listener(null, state);
	      } else {
	        match(location, function (error, redirectLocation, nextState) {
	          if (error) {
	            listener(error);
	          } else if (redirectLocation) {
	            history.replace(redirectLocation);
	          } else if (nextState) {
	            listener(null, nextState);
	          } else {
	             true ? (0, _routerWarning2["default"])(false, 'Location "%s" did not match any routes', location.pathname + location.search + location.hash) : void 0;
	          }
	        });
	      }
	    });
	  }
	
	  return {
	    isActive: isActive,
	    match: match,
	    listenBeforeLeavingRoute: listenBeforeLeavingRoute,
	    listen: listen
	  };
	}
	
	//export default useRoutes
	
	module.exports = exports['default'];

/***/ },
/* 25 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports["default"] = routerWarning;
	exports._resetWarned = _resetWarned;
	
	var _warning = __webpack_require__(26);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	var warned = {};
	
	function routerWarning(falseToWarn, message) {
	  // Only issue deprecation warnings once.
	  if (message.indexOf('deprecated') !== -1) {
	    if (warned[message]) {
	      return;
	    }
	
	    warned[message] = true;
	  }
	
	  message = '[react-router] ' + message;
	
	  for (var _len = arguments.length, args = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
	    args[_key - 2] = arguments[_key];
	  }
	
	  _warning2["default"].apply(undefined, [falseToWarn, message].concat(args));
	}
	
	function _resetWarned() {
	  warned = {};
	}

/***/ },
/* 26 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Copyright 2014-2015, Facebook, Inc.
	 * All rights reserved.
	 *
	 * This source code is licensed under the BSD-style license found in the
	 * LICENSE file in the root directory of this source tree. An additional grant
	 * of patent rights can be found in the PATENTS file in the same directory.
	 */
	
	'use strict';
	
	/**
	 * Similar to invariant but only logs a warning if the condition is not met.
	 * This can be used to log issues in development environments in critical
	 * paths. Removing the logging code for production environments will keep the
	 * same logic and follow the same code paths.
	 */
	
	var warning = function() {};
	
	if (true) {
	  warning = function(condition, format, args) {
	    var len = arguments.length;
	    args = new Array(len > 2 ? len - 2 : 0);
	    for (var key = 2; key < len; key++) {
	      args[key - 2] = arguments[key];
	    }
	    if (format === undefined) {
	      throw new Error(
	        '`warning(condition, format, ...args)` requires a warning ' +
	        'message argument'
	      );
	    }
	
	    if (format.length < 10 || (/^[s\W]*$/).test(format)) {
	      throw new Error(
	        'The warning format should be able to uniquely identify this ' +
	        'warning. Please, use a more descriptive format than: ' + format
	      );
	    }
	
	    if (!condition) {
	      var argIndex = 0;
	      var message = 'Warning: ' +
	        format.replace(/%s/g, function() {
	          return args[argIndex++];
	        });
	      if (typeof console !== 'undefined') {
	        console.error(message);
	      }
	      try {
	        // This error was thrown as a convenience so that you can use this stack
	        // to find the callsite that caused this warning to fire.
	        throw new Error(message);
	      } catch(x) {}
	    }
	  };
	}
	
	module.exports = warning;


/***/ },
/* 27 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _PatternUtils = __webpack_require__(28);
	
	function routeParamsChanged(route, prevState, nextState) {
	  if (!route.path) return false;
	
	  var paramNames = (0, _PatternUtils.getParamNames)(route.path);
	
	  return paramNames.some(function (paramName) {
	    return prevState.params[paramName] !== nextState.params[paramName];
	  });
	}
	
	/**
	 * Returns an object of { leaveRoutes, changeRoutes, enterRoutes } determined by
	 * the change from prevState to nextState. We leave routes if either
	 * 1) they are not in the next state or 2) they are in the next state
	 * but their params have changed (i.e. /users/123 => /users/456).
	 *
	 * leaveRoutes are ordered starting at the leaf route of the tree
	 * we're leaving up to the common parent route. enterRoutes are ordered
	 * from the top of the tree we're entering down to the leaf route.
	 *
	 * changeRoutes are any routes that didn't leave or enter during
	 * the transition.
	 */
	function computeChangedRoutes(prevState, nextState) {
	  var prevRoutes = prevState && prevState.routes;
	  var nextRoutes = nextState.routes;
	
	  var leaveRoutes = void 0,
	      changeRoutes = void 0,
	      enterRoutes = void 0;
	  if (prevRoutes) {
	    (function () {
	      var parentIsLeaving = false;
	      leaveRoutes = prevRoutes.filter(function (route) {
	        if (parentIsLeaving) {
	          return true;
	        } else {
	          var isLeaving = nextRoutes.indexOf(route) === -1 || routeParamsChanged(route, prevState, nextState);
	          if (isLeaving) parentIsLeaving = true;
	          return isLeaving;
	        }
	      });
	
	      // onLeave hooks start at the leaf route.
	      leaveRoutes.reverse();
	
	      enterRoutes = [];
	      changeRoutes = [];
	
	      nextRoutes.forEach(function (route) {
	        var isNew = prevRoutes.indexOf(route) === -1;
	        var paramsChanged = leaveRoutes.indexOf(route) !== -1;
	
	        if (isNew || paramsChanged) enterRoutes.push(route);else changeRoutes.push(route);
	      });
	    })();
	  } else {
	    leaveRoutes = [];
	    changeRoutes = [];
	    enterRoutes = nextRoutes;
	  }
	
	  return {
	    leaveRoutes: leaveRoutes,
	    changeRoutes: changeRoutes,
	    enterRoutes: enterRoutes
	  };
	}
	
	exports["default"] = computeChangedRoutes;
	module.exports = exports['default'];

/***/ },
/* 28 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports.compilePattern = compilePattern;
	exports.matchPattern = matchPattern;
	exports.getParamNames = getParamNames;
	exports.getParams = getParams;
	exports.formatPattern = formatPattern;
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function escapeRegExp(string) {
	  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
	}
	
	function _compilePattern(pattern) {
	  var regexpSource = '';
	  var paramNames = [];
	  var tokens = [];
	
	  var match = void 0,
	      lastIndex = 0,
	      matcher = /:([a-zA-Z_$][a-zA-Z0-9_$]*)|\*\*|\*|\(|\)/g;
	  while (match = matcher.exec(pattern)) {
	    if (match.index !== lastIndex) {
	      tokens.push(pattern.slice(lastIndex, match.index));
	      regexpSource += escapeRegExp(pattern.slice(lastIndex, match.index));
	    }
	
	    if (match[1]) {
	      regexpSource += '([^/]+)';
	      paramNames.push(match[1]);
	    } else if (match[0] === '**') {
	      regexpSource += '(.*)';
	      paramNames.push('splat');
	    } else if (match[0] === '*') {
	      regexpSource += '(.*?)';
	      paramNames.push('splat');
	    } else if (match[0] === '(') {
	      regexpSource += '(?:';
	    } else if (match[0] === ')') {
	      regexpSource += ')?';
	    }
	
	    tokens.push(match[0]);
	
	    lastIndex = matcher.lastIndex;
	  }
	
	  if (lastIndex !== pattern.length) {
	    tokens.push(pattern.slice(lastIndex, pattern.length));
	    regexpSource += escapeRegExp(pattern.slice(lastIndex, pattern.length));
	  }
	
	  return {
	    pattern: pattern,
	    regexpSource: regexpSource,
	    paramNames: paramNames,
	    tokens: tokens
	  };
	}
	
	var CompiledPatternsCache = Object.create(null);
	
	function compilePattern(pattern) {
	  if (!CompiledPatternsCache[pattern]) CompiledPatternsCache[pattern] = _compilePattern(pattern);
	
	  return CompiledPatternsCache[pattern];
	}
	
	/**
	 * Attempts to match a pattern on the given pathname. Patterns may use
	 * the following special characters:
	 *
	 * - :paramName     Matches a URL segment up to the next /, ?, or #. The
	 *                  captured string is considered a "param"
	 * - ()             Wraps a segment of the URL that is optional
	 * - *              Consumes (non-greedy) all characters up to the next
	 *                  character in the pattern, or to the end of the URL if
	 *                  there is none
	 * - **             Consumes (greedy) all characters up to the next character
	 *                  in the pattern, or to the end of the URL if there is none
	 *
	 *  The function calls callback(error, matched) when finished.
	 * The return value is an object with the following properties:
	 *
	 * - remainingPathname
	 * - paramNames
	 * - paramValues
	 */
	function matchPattern(pattern, pathname) {
	  // Ensure pattern starts with leading slash for consistency with pathname.
	  if (pattern.charAt(0) !== '/') {
	    pattern = '/' + pattern;
	  }
	
	  var _compilePattern2 = compilePattern(pattern);
	
	  var regexpSource = _compilePattern2.regexpSource;
	  var paramNames = _compilePattern2.paramNames;
	  var tokens = _compilePattern2.tokens;
	
	
	  if (pattern.charAt(pattern.length - 1) !== '/') {
	    regexpSource += '/?'; // Allow optional path separator at end.
	  }
	
	  // Special-case patterns like '*' for catch-all routes.
	  if (tokens[tokens.length - 1] === '*') {
	    regexpSource += '$';
	  }
	
	  var match = pathname.match(new RegExp('^' + regexpSource, 'i'));
	  if (match == null) {
	    return null;
	  }
	
	  var matchedPath = match[0];
	  var remainingPathname = pathname.substr(matchedPath.length);
	
	  if (remainingPathname) {
	    // Require that the match ends at a path separator, if we didn't match
	    // the full path, so any remaining pathname is a new path segment.
	    if (matchedPath.charAt(matchedPath.length - 1) !== '/') {
	      return null;
	    }
	
	    // If there is a remaining pathname, treat the path separator as part of
	    // the remaining pathname for properly continuing the match.
	    remainingPathname = '/' + remainingPathname;
	  }
	
	  return {
	    remainingPathname: remainingPathname,
	    paramNames: paramNames,
	    paramValues: match.slice(1).map(function (v) {
	      return v && decodeURIComponent(v);
	    })
	  };
	}
	
	function getParamNames(pattern) {
	  return compilePattern(pattern).paramNames;
	}
	
	function getParams(pattern, pathname) {
	  var match = matchPattern(pattern, pathname);
	  if (!match) {
	    return null;
	  }
	
	  var paramNames = match.paramNames;
	  var paramValues = match.paramValues;
	
	  var params = {};
	
	  paramNames.forEach(function (paramName, index) {
	    params[paramName] = paramValues[index];
	  });
	
	  return params;
	}
	
	/**
	 * Returns a version of the given pattern with params interpolated. Throws
	 * if there is a dynamic segment of the pattern for which there is no param.
	 */
	function formatPattern(pattern, params) {
	  params = params || {};
	
	  var _compilePattern3 = compilePattern(pattern);
	
	  var tokens = _compilePattern3.tokens;
	
	  var parenCount = 0,
	      pathname = '',
	      splatIndex = 0;
	
	  var token = void 0,
	      paramName = void 0,
	      paramValue = void 0;
	  for (var i = 0, len = tokens.length; i < len; ++i) {
	    token = tokens[i];
	
	    if (token === '*' || token === '**') {
	      paramValue = Array.isArray(params.splat) ? params.splat[splatIndex++] : params.splat;
	
	      !(paramValue != null || parenCount > 0) ?  true ? (0, _invariant2["default"])(false, 'Missing splat #%s for path "%s"', splatIndex, pattern) : (0, _invariant2["default"])(false) : void 0;
	
	      if (paramValue != null) pathname += encodeURI(paramValue);
	    } else if (token === '(') {
	      parenCount += 1;
	    } else if (token === ')') {
	      parenCount -= 1;
	    } else if (token.charAt(0) === ':') {
	      paramName = token.substring(1);
	      paramValue = params[paramName];
	
	      !(paramValue != null || parenCount > 0) ?  true ? (0, _invariant2["default"])(false, 'Missing "%s" parameter for path "%s"', paramName, pattern) : (0, _invariant2["default"])(false) : void 0;
	
	      if (paramValue != null) pathname += encodeURIComponent(paramValue);
	    } else {
	      pathname += token;
	    }
	  }
	
	  return pathname.replace(/\/+/g, '/');
	}

/***/ },
/* 29 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports.runEnterHooks = runEnterHooks;
	exports.runChangeHooks = runChangeHooks;
	exports.runLeaveHooks = runLeaveHooks;
	
	var _AsyncUtils = __webpack_require__(30);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function createTransitionHook(hook, route, asyncArity) {
	  return function () {
	    for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
	      args[_key] = arguments[_key];
	    }
	
	    hook.apply(route, args);
	
	    if (hook.length < asyncArity) {
	      var callback = args[args.length - 1];
	      // Assume hook executes synchronously and
	      // automatically call the callback.
	      callback();
	    }
	  };
	}
	
	function getEnterHooks(routes) {
	  return routes.reduce(function (hooks, route) {
	    if (route.onEnter) hooks.push(createTransitionHook(route.onEnter, route, 3));
	
	    return hooks;
	  }, []);
	}
	
	function getChangeHooks(routes) {
	  return routes.reduce(function (hooks, route) {
	    if (route.onChange) hooks.push(createTransitionHook(route.onChange, route, 4));
	    return hooks;
	  }, []);
	}
	
	function runTransitionHooks(length, iter, callback) {
	  if (!length) {
	    callback();
	    return;
	  }
	
	  var redirectInfo = void 0;
	  function replace(location, deprecatedPathname, deprecatedQuery) {
	    if (deprecatedPathname) {
	       true ? (0, _routerWarning2["default"])(false, '`replaceState(state, pathname, query) is deprecated; use `replace(location)` with a location descriptor instead. http://tiny.cc/router-isActivedeprecated') : void 0;
	      redirectInfo = {
	        pathname: deprecatedPathname,
	        query: deprecatedQuery,
	        state: location
	      };
	
	      return;
	    }
	
	    redirectInfo = location;
	  }
	
	  (0, _AsyncUtils.loopAsync)(length, function (index, next, done) {
	    iter(index, replace, function (error) {
	      if (error || redirectInfo) {
	        done(error, redirectInfo); // No need to continue.
	      } else {
	        next();
	      }
	    });
	  }, callback);
	}
	
	/**
	 * Runs all onEnter hooks in the given array of routes in order
	 * with onEnter(nextState, replace, callback) and calls
	 * callback(error, redirectInfo) when finished. The first hook
	 * to use replace short-circuits the loop.
	 *
	 * If a hook needs to run asynchronously, it may use the callback
	 * function. However, doing so will cause the transition to pause,
	 * which could lead to a non-responsive UI if the hook is slow.
	 */
	function runEnterHooks(routes, nextState, callback) {
	  var hooks = getEnterHooks(routes);
	  return runTransitionHooks(hooks.length, function (index, replace, next) {
	    hooks[index](nextState, replace, next);
	  }, callback);
	}
	
	/**
	 * Runs all onChange hooks in the given array of routes in order
	 * with onChange(prevState, nextState, replace, callback) and calls
	 * callback(error, redirectInfo) when finished. The first hook
	 * to use replace short-circuits the loop.
	 *
	 * If a hook needs to run asynchronously, it may use the callback
	 * function. However, doing so will cause the transition to pause,
	 * which could lead to a non-responsive UI if the hook is slow.
	 */
	function runChangeHooks(routes, state, nextState, callback) {
	  var hooks = getChangeHooks(routes);
	  return runTransitionHooks(hooks.length, function (index, replace, next) {
	    hooks[index](state, nextState, replace, next);
	  }, callback);
	}
	
	/**
	 * Runs all onLeave hooks in the given array of routes in order.
	 */
	function runLeaveHooks(routes, prevState) {
	  for (var i = 0, len = routes.length; i < len; ++i) {
	    if (routes[i].onLeave) routes[i].onLeave.call(routes[i], prevState);
	  }
	}

/***/ },
/* 30 */
/***/ function(module, exports) {

	"use strict";
	
	exports.__esModule = true;
	exports.loopAsync = loopAsync;
	exports.mapAsync = mapAsync;
	function loopAsync(turns, work, callback) {
	  var currentTurn = 0,
	      isDone = false;
	  var sync = false,
	      hasNext = false,
	      doneArgs = void 0;
	
	  function done() {
	    isDone = true;
	    if (sync) {
	      // Iterate instead of recursing if possible.
	      doneArgs = [].concat(Array.prototype.slice.call(arguments));
	      return;
	    }
	
	    callback.apply(this, arguments);
	  }
	
	  function next() {
	    if (isDone) {
	      return;
	    }
	
	    hasNext = true;
	    if (sync) {
	      // Iterate instead of recursing if possible.
	      return;
	    }
	
	    sync = true;
	
	    while (!isDone && currentTurn < turns && hasNext) {
	      hasNext = false;
	      work.call(this, currentTurn++, next, done);
	    }
	
	    sync = false;
	
	    if (isDone) {
	      // This means the loop finished synchronously.
	      callback.apply(this, doneArgs);
	      return;
	    }
	
	    if (currentTurn >= turns && hasNext) {
	      isDone = true;
	      callback();
	    }
	  }
	
	  next();
	}
	
	function mapAsync(array, work, callback) {
	  var length = array.length;
	  var values = [];
	
	  if (length === 0) return callback(null, values);
	
	  var isDone = false,
	      doneCount = 0;
	
	  function done(index, error, value) {
	    if (isDone) return;
	
	    if (error) {
	      isDone = true;
	      callback(error);
	    } else {
	      values[index] = value;
	
	      isDone = ++doneCount === length;
	
	      if (isDone) callback(null, values);
	    }
	  }
	
	  array.forEach(function (item, index) {
	    work(item, index, function (error, value) {
	      done(index, error, value);
	    });
	  });
	}

/***/ },
/* 31 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol ? "symbol" : typeof obj; };
	
	exports["default"] = isActive;
	
	var _PatternUtils = __webpack_require__(28);
	
	function deepEqual(a, b) {
	  if (a == b) return true;
	
	  if (a == null || b == null) return false;
	
	  if (Array.isArray(a)) {
	    return Array.isArray(b) && a.length === b.length && a.every(function (item, index) {
	      return deepEqual(item, b[index]);
	    });
	  }
	
	  if ((typeof a === 'undefined' ? 'undefined' : _typeof(a)) === 'object') {
	    for (var p in a) {
	      if (!Object.prototype.hasOwnProperty.call(a, p)) {
	        continue;
	      }
	
	      if (a[p] === undefined) {
	        if (b[p] !== undefined) {
	          return false;
	        }
	      } else if (!Object.prototype.hasOwnProperty.call(b, p)) {
	        return false;
	      } else if (!deepEqual(a[p], b[p])) {
	        return false;
	      }
	    }
	
	    return true;
	  }
	
	  return String(a) === String(b);
	}
	
	/**
	 * Returns true if the current pathname matches the supplied one, net of
	 * leading and trailing slash normalization. This is sufficient for an
	 * indexOnly route match.
	 */
	function pathIsActive(pathname, currentPathname) {
	  // Normalize leading slash for consistency. Leading slash on pathname has
	  // already been normalized in isActive. See caveat there.
	  if (currentPathname.charAt(0) !== '/') {
	    currentPathname = '/' + currentPathname;
	  }
	
	  // Normalize the end of both path names too. Maybe `/foo/` shouldn't show
	  // `/foo` as active, but in this case, we would already have failed the
	  // match.
	  if (pathname.charAt(pathname.length - 1) !== '/') {
	    pathname += '/';
	  }
	  if (currentPathname.charAt(currentPathname.length - 1) !== '/') {
	    currentPathname += '/';
	  }
	
	  return currentPathname === pathname;
	}
	
	/**
	 * Returns true if the given pathname matches the active routes and params.
	 */
	function routeIsActive(pathname, routes, params) {
	  var remainingPathname = pathname,
	      paramNames = [],
	      paramValues = [];
	
	  // for...of would work here but it's probably slower post-transpilation.
	  for (var i = 0, len = routes.length; i < len; ++i) {
	    var route = routes[i];
	    var pattern = route.path || '';
	
	    if (pattern.charAt(0) === '/') {
	      remainingPathname = pathname;
	      paramNames = [];
	      paramValues = [];
	    }
	
	    if (remainingPathname !== null && pattern) {
	      var matched = (0, _PatternUtils.matchPattern)(pattern, remainingPathname);
	      if (matched) {
	        remainingPathname = matched.remainingPathname;
	        paramNames = [].concat(paramNames, matched.paramNames);
	        paramValues = [].concat(paramValues, matched.paramValues);
	      } else {
	        remainingPathname = null;
	      }
	
	      if (remainingPathname === '') {
	        // We have an exact match on the route. Just check that all the params
	        // match.
	        // FIXME: This doesn't work on repeated params.
	        return paramNames.every(function (paramName, index) {
	          return String(paramValues[index]) === String(params[paramName]);
	        });
	      }
	    }
	  }
	
	  return false;
	}
	
	/**
	 * Returns true if all key/value pairs in the given query are
	 * currently active.
	 */
	function queryIsActive(query, activeQuery) {
	  if (activeQuery == null) return query == null;
	
	  if (query == null) return true;
	
	  return deepEqual(query, activeQuery);
	}
	
	/**
	 * Returns true if a <Link> to the given pathname/query combination is
	 * currently active.
	 */
	function isActive(_ref, indexOnly, currentLocation, routes, params) {
	  var pathname = _ref.pathname;
	  var query = _ref.query;
	
	  if (currentLocation == null) return false;
	
	  // TODO: This is a bit ugly. It keeps around support for treating pathnames
	  // without preceding slashes as absolute paths, but possibly also works
	  // around the same quirks with basenames as in matchRoutes.
	  if (pathname.charAt(0) !== '/') {
	    pathname = '/' + pathname;
	  }
	
	  if (!pathIsActive(pathname, currentLocation.pathname)) {
	    // The path check is necessary and sufficient for indexOnly, but otherwise
	    // we still need to check the routes.
	    if (indexOnly || !routeIsActive(pathname, routes, params)) {
	      return false;
	    }
	  }
	
	  return queryIsActive(query, currentLocation.query);
	}
	module.exports = exports['default'];

/***/ },
/* 32 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _AsyncUtils = __webpack_require__(30);
	
	var _makeStateWithLocation = __webpack_require__(33);
	
	var _makeStateWithLocation2 = _interopRequireDefault(_makeStateWithLocation);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function getComponentsForRoute(nextState, route, callback) {
	  if (route.component || route.components) {
	    callback(null, route.component || route.components);
	    return;
	  }
	
	  var getComponent = route.getComponent || route.getComponents;
	  if (!getComponent) {
	    callback();
	    return;
	  }
	
	  var location = nextState.location;
	
	  var nextStateWithLocation = (0, _makeStateWithLocation2["default"])(nextState, location);
	
	  getComponent.call(route, nextStateWithLocation, callback);
	}
	
	/**
	 * Asynchronously fetches all components needed for the given router
	 * state and calls callback(error, components) when finished.
	 *
	 * Note: This operation may finish synchronously if no routes have an
	 * asynchronous getComponents method.
	 */
	function getComponents(nextState, callback) {
	  (0, _AsyncUtils.mapAsync)(nextState.routes, function (route, index, callback) {
	    getComponentsForRoute(nextState, route, callback);
	  }, callback);
	}
	
	exports["default"] = getComponents;
	module.exports = exports['default'];

/***/ },
/* 33 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	exports["default"] = makeStateWithLocation;
	
	var _deprecateObjectProperties = __webpack_require__(34);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function makeStateWithLocation(state, location) {
	  if (('development') !== 'production' && _deprecateObjectProperties.canUseMembrane) {
	    var stateWithLocation = _extends({}, state);
	
	    // I don't use deprecateObjectProperties here because I want to keep the
	    // same code path between development and production, in that we just
	    // assign extra properties to the copy of the state object in both cases.
	
	    var _loop = function _loop(prop) {
	      if (!Object.prototype.hasOwnProperty.call(location, prop)) {
	        return 'continue';
	      }
	
	      Object.defineProperty(stateWithLocation, prop, {
	        get: function get() {
	           true ? (0, _routerWarning2["default"])(false, 'Accessing location properties directly from the first argument to `getComponent`, `getComponents`, `getChildRoutes`, and `getIndexRoute` is deprecated. That argument is now the router state (`nextState` or `partialNextState`) rather than the location. To access the location, use `nextState.location` or `partialNextState.location`.') : void 0;
	          return location[prop];
	        }
	      });
	    };
	
	    for (var prop in location) {
	      var _ret = _loop(prop);
	
	      if (_ret === 'continue') continue;
	    }
	
	    return stateWithLocation;
	  }
	
	  return _extends({}, state, location);
	}
	module.exports = exports['default'];

/***/ },
/* 34 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports.canUseMembrane = undefined;
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	var canUseMembrane = exports.canUseMembrane = false;
	
	// No-op by default.
	var deprecateObjectProperties = function deprecateObjectProperties(object) {
	  return object;
	};
	
	if (true) {
	  try {
	    if (Object.defineProperty({}, 'x', {
	      get: function get() {
	        return true;
	      }
	    }).x) {
	      exports.canUseMembrane = canUseMembrane = true;
	    }
	    /* eslint-disable no-empty */
	  } catch (e) {}
	  /* eslint-enable no-empty */
	
	  if (canUseMembrane) {
	    deprecateObjectProperties = function deprecateObjectProperties(object, message) {
	      // Wrap the deprecated object in a membrane to warn on property access.
	      var membrane = {};
	
	      var _loop = function _loop(prop) {
	        if (!Object.prototype.hasOwnProperty.call(object, prop)) {
	          return 'continue';
	        }
	
	        if (typeof object[prop] === 'function') {
	          // Can't use fat arrow here because of use of arguments below.
	          membrane[prop] = function () {
	             true ? (0, _routerWarning2["default"])(false, message) : void 0;
	            return object[prop].apply(object, arguments);
	          };
	          return 'continue';
	        }
	
	        // These properties are non-enumerable to prevent React dev tools from
	        // seeing them and causing spurious warnings when accessing them. In
	        // principle this could be done with a proxy, but support for the
	        // ownKeys trap on proxies is not universal, even among browsers that
	        // otherwise support proxies.
	        Object.defineProperty(membrane, prop, {
	          get: function get() {
	             true ? (0, _routerWarning2["default"])(false, message) : void 0;
	            return object[prop];
	          }
	        });
	      };
	
	      for (var prop in object) {
	        var _ret = _loop(prop);
	
	        if (_ret === 'continue') continue;
	      }
	
	      return membrane;
	    };
	  }
	}
	
	exports["default"] = deprecateObjectProperties;

/***/ },
/* 35 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol ? "symbol" : typeof obj; };
	
	exports["default"] = matchRoutes;
	
	var _AsyncUtils = __webpack_require__(30);
	
	var _makeStateWithLocation = __webpack_require__(33);
	
	var _makeStateWithLocation2 = _interopRequireDefault(_makeStateWithLocation);
	
	var _PatternUtils = __webpack_require__(28);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	var _RouteUtils = __webpack_require__(36);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function getChildRoutes(route, location, paramNames, paramValues, callback) {
	  if (route.childRoutes) {
	    return [null, route.childRoutes];
	  }
	  if (!route.getChildRoutes) {
	    return [];
	  }
	
	  var sync = true,
	      result = void 0;
	
	  var partialNextState = {
	    location: location,
	    params: createParams(paramNames, paramValues)
	  };
	
	  var partialNextStateWithLocation = (0, _makeStateWithLocation2["default"])(partialNextState, location);
	
	  route.getChildRoutes(partialNextStateWithLocation, function (error, childRoutes) {
	    childRoutes = !error && (0, _RouteUtils.createRoutes)(childRoutes);
	    if (sync) {
	      result = [error, childRoutes];
	      return;
	    }
	
	    callback(error, childRoutes);
	  });
	
	  sync = false;
	  return result; // Might be undefined.
	}
	
	function getIndexRoute(route, location, paramNames, paramValues, callback) {
	  if (route.indexRoute) {
	    callback(null, route.indexRoute);
	  } else if (route.getIndexRoute) {
	    var partialNextState = {
	      location: location,
	      params: createParams(paramNames, paramValues)
	    };
	
	    var partialNextStateWithLocation = (0, _makeStateWithLocation2["default"])(partialNextState, location);
	
	    route.getIndexRoute(partialNextStateWithLocation, function (error, indexRoute) {
	      callback(error, !error && (0, _RouteUtils.createRoutes)(indexRoute)[0]);
	    });
	  } else if (route.childRoutes) {
	    (function () {
	      var pathless = route.childRoutes.filter(function (childRoute) {
	        return !childRoute.path;
	      });
	
	      (0, _AsyncUtils.loopAsync)(pathless.length, function (index, next, done) {
	        getIndexRoute(pathless[index], location, paramNames, paramValues, function (error, indexRoute) {
	          if (error || indexRoute) {
	            var routes = [pathless[index]].concat(Array.isArray(indexRoute) ? indexRoute : [indexRoute]);
	            done(error, routes);
	          } else {
	            next();
	          }
	        });
	      }, function (err, routes) {
	        callback(null, routes);
	      });
	    })();
	  } else {
	    callback();
	  }
	}
	
	function assignParams(params, paramNames, paramValues) {
	  return paramNames.reduce(function (params, paramName, index) {
	    var paramValue = paramValues && paramValues[index];
	
	    if (Array.isArray(params[paramName])) {
	      params[paramName].push(paramValue);
	    } else if (paramName in params) {
	      params[paramName] = [params[paramName], paramValue];
	    } else {
	      params[paramName] = paramValue;
	    }
	
	    return params;
	  }, params);
	}
	
	function createParams(paramNames, paramValues) {
	  return assignParams({}, paramNames, paramValues);
	}
	
	function matchRouteDeep(route, location, remainingPathname, paramNames, paramValues, callback) {
	  var pattern = route.path || '';
	
	  if (pattern.charAt(0) === '/') {
	    remainingPathname = location.pathname;
	    paramNames = [];
	    paramValues = [];
	  }
	
	  // Only try to match the path if the route actually has a pattern, and if
	  // we're not just searching for potential nested absolute paths.
	  if (remainingPathname !== null && pattern) {
	    try {
	      var matched = (0, _PatternUtils.matchPattern)(pattern, remainingPathname);
	      if (matched) {
	        remainingPathname = matched.remainingPathname;
	        paramNames = [].concat(paramNames, matched.paramNames);
	        paramValues = [].concat(paramValues, matched.paramValues);
	      } else {
	        remainingPathname = null;
	      }
	    } catch (error) {
	      callback(error);
	    }
	
	    // By assumption, pattern is non-empty here, which is the prerequisite for
	    // actually terminating a match.
	    if (remainingPathname === '') {
	      var _ret2 = function () {
	        var match = {
	          routes: [route],
	          params: createParams(paramNames, paramValues)
	        };
	
	        getIndexRoute(route, location, paramNames, paramValues, function (error, indexRoute) {
	          if (error) {
	            callback(error);
	          } else {
	            if (Array.isArray(indexRoute)) {
	              var _match$routes;
	
	               true ? (0, _routerWarning2["default"])(indexRoute.every(function (route) {
	                return !route.path;
	              }), 'Index routes should not have paths') : void 0;
	              (_match$routes = match.routes).push.apply(_match$routes, indexRoute);
	            } else if (indexRoute) {
	               true ? (0, _routerWarning2["default"])(!indexRoute.path, 'Index routes should not have paths') : void 0;
	              match.routes.push(indexRoute);
	            }
	
	            callback(null, match);
	          }
	        });
	
	        return {
	          v: void 0
	        };
	      }();
	
	      if ((typeof _ret2 === 'undefined' ? 'undefined' : _typeof(_ret2)) === "object") return _ret2.v;
	    }
	  }
	
	  if (remainingPathname != null || route.childRoutes) {
	    // Either a) this route matched at least some of the path or b)
	    // we don't have to load this route's children asynchronously. In
	    // either case continue checking for matches in the subtree.
	    var onChildRoutes = function onChildRoutes(error, childRoutes) {
	      if (error) {
	        callback(error);
	      } else if (childRoutes) {
	        // Check the child routes to see if any of them match.
	        matchRoutes(childRoutes, location, function (error, match) {
	          if (error) {
	            callback(error);
	          } else if (match) {
	            // A child route matched! Augment the match and pass it up the stack.
	            match.routes.unshift(route);
	            callback(null, match);
	          } else {
	            callback();
	          }
	        }, remainingPathname, paramNames, paramValues);
	      } else {
	        callback();
	      }
	    };
	
	    var result = getChildRoutes(route, location, paramNames, paramValues, onChildRoutes);
	    if (result) {
	      onChildRoutes.apply(undefined, result);
	    }
	  } else {
	    callback();
	  }
	}
	
	/**
	 * Asynchronously matches the given location to a set of routes and calls
	 * callback(error, state) when finished. The state object will have the
	 * following properties:
	 *
	 * - routes       An array of routes that matched, in hierarchical order
	 * - params       An object of URL parameters
	 *
	 * Note: This operation may finish synchronously if no routes have an
	 * asynchronous getChildRoutes method.
	 */
	function matchRoutes(routes, location, callback, remainingPathname) {
	  var paramNames = arguments.length <= 4 || arguments[4] === undefined ? [] : arguments[4];
	  var paramValues = arguments.length <= 5 || arguments[5] === undefined ? [] : arguments[5];
	
	  if (remainingPathname === undefined) {
	    // TODO: This is a little bit ugly, but it works around a quirk in history
	    // that strips the leading slash from pathnames when using basenames with
	    // trailing slashes.
	    if (location.pathname.charAt(0) !== '/') {
	      location = _extends({}, location, {
	        pathname: '/' + location.pathname
	      });
	    }
	    remainingPathname = location.pathname;
	  }
	
	  (0, _AsyncUtils.loopAsync)(routes.length, function (index, next, done) {
	    matchRouteDeep(routes[index], location, remainingPathname, paramNames, paramValues, function (error, match) {
	      if (error || match) {
	        done(error, match);
	      } else {
	        next();
	      }
	    });
	  }, callback);
	}
	module.exports = exports['default'];

/***/ },
/* 36 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	exports.isReactChildren = isReactChildren;
	exports.createRouteFromReactElement = createRouteFromReactElement;
	exports.createRoutesFromReactChildren = createRoutesFromReactChildren;
	exports.createRoutes = createRoutes;
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function isValidChild(object) {
	  return object == null || _react2["default"].isValidElement(object);
	}
	
	function isReactChildren(object) {
	  return isValidChild(object) || Array.isArray(object) && object.every(isValidChild);
	}
	
	function createRoute(defaultProps, props) {
	  return _extends({}, defaultProps, props);
	}
	
	function createRouteFromReactElement(element) {
	  var type = element.type;
	  var route = createRoute(type.defaultProps, element.props);
	
	  if (route.children) {
	    var childRoutes = createRoutesFromReactChildren(route.children, route);
	
	    if (childRoutes.length) route.childRoutes = childRoutes;
	
	    delete route.children;
	  }
	
	  return route;
	}
	
	/**
	 * Creates and returns a routes object from the given ReactChildren. JSX
	 * provides a convenient way to visualize how routes in the hierarchy are
	 * nested.
	 *
	 *   import { Route, createRoutesFromReactChildren } from 'react-router'
	 *
	 *   const routes = createRoutesFromReactChildren(
	 *     <Route component={App}>
	 *       <Route path="home" component={Dashboard}/>
	 *       <Route path="news" component={NewsFeed}/>
	 *     </Route>
	 *   )
	 *
	 * Note: This method is automatically used when you provide <Route> children
	 * to a <Router> component.
	 */
	function createRoutesFromReactChildren(children, parentRoute) {
	  var routes = [];
	
	  _react2["default"].Children.forEach(children, function (element) {
	    if (_react2["default"].isValidElement(element)) {
	      // Component classes may have a static create* method.
	      if (element.type.createRouteFromReactElement) {
	        var route = element.type.createRouteFromReactElement(element, parentRoute);
	
	        if (route) routes.push(route);
	      } else {
	        routes.push(createRouteFromReactElement(element));
	      }
	    }
	  });
	
	  return routes;
	}
	
	/**
	 * Creates and returns an array of routes from the given object which
	 * may be a JSX route, a plain object route, or an array of either.
	 */
	function createRoutes(routes) {
	  if (isReactChildren(routes)) {
	    routes = createRoutesFromReactChildren(routes);
	  } else if (routes && !Array.isArray(routes)) {
	    routes = [routes];
	  }
	
	  return routes;
	}

/***/ },
/* 37 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports.routes = exports.route = exports.components = exports.component = exports.history = undefined;
	exports.falsy = falsy;
	
	var _react = __webpack_require__(1);
	
	var func = _react.PropTypes.func;
	var object = _react.PropTypes.object;
	var arrayOf = _react.PropTypes.arrayOf;
	var oneOfType = _react.PropTypes.oneOfType;
	var element = _react.PropTypes.element;
	var shape = _react.PropTypes.shape;
	var string = _react.PropTypes.string;
	function falsy(props, propName, componentName) {
	  if (props[propName]) return new Error('<' + componentName + '> should not have a "' + propName + '" prop');
	}
	
	var history = exports.history = shape({
	  listen: func.isRequired,
	  push: func.isRequired,
	  replace: func.isRequired,
	  go: func.isRequired,
	  goBack: func.isRequired,
	  goForward: func.isRequired
	});
	
	var component = exports.component = oneOfType([func, string]);
	var components = exports.components = oneOfType([component, object]);
	var route = exports.route = oneOfType([object, element]);
	var routes = exports.routes = oneOfType([route, arrayOf(route)]);

/***/ },
/* 38 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol ? "symbol" : typeof obj; };
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _deprecateObjectProperties = __webpack_require__(34);
	
	var _deprecateObjectProperties2 = _interopRequireDefault(_deprecateObjectProperties);
	
	var _getRouteParams = __webpack_require__(39);
	
	var _getRouteParams2 = _interopRequireDefault(_getRouteParams);
	
	var _RouteUtils = __webpack_require__(36);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	var _React$PropTypes = _react2["default"].PropTypes;
	var array = _React$PropTypes.array;
	var func = _React$PropTypes.func;
	var object = _React$PropTypes.object;
	
	/**
	 * A <RouterContext> renders the component tree for a given router state
	 * and sets the history object and the current location in context.
	 */
	
	var RouterContext = _react2["default"].createClass({
	  displayName: 'RouterContext',
	
	
	  propTypes: {
	    history: object,
	    router: object.isRequired,
	    location: object.isRequired,
	    routes: array.isRequired,
	    params: object.isRequired,
	    components: array.isRequired,
	    createElement: func.isRequired
	  },
	
	  getDefaultProps: function getDefaultProps() {
	    return {
	      createElement: _react2["default"].createElement
	    };
	  },
	
	
	  childContextTypes: {
	    history: object,
	    location: object.isRequired,
	    router: object.isRequired
	  },
	
	  getChildContext: function getChildContext() {
	    var _props = this.props;
	    var router = _props.router;
	    var history = _props.history;
	    var location = _props.location;
	
	    if (!router) {
	       true ? (0, _routerWarning2["default"])(false, '`<RouterContext>` expects a `router` rather than a `history`') : void 0;
	
	      router = _extends({}, history, {
	        setRouteLeaveHook: history.listenBeforeLeavingRoute
	      });
	      delete router.listenBeforeLeavingRoute;
	    }
	
	    if (true) {
	      location = (0, _deprecateObjectProperties2["default"])(location, '`context.location` is deprecated, please use a route component\'s `props.location` instead. http://tiny.cc/router-accessinglocation');
	    }
	
	    return { history: history, location: location, router: router };
	  },
	  createElement: function createElement(component, props) {
	    return component == null ? null : this.props.createElement(component, props);
	  },
	  render: function render() {
	    var _this = this;
	
	    var _props2 = this.props;
	    var history = _props2.history;
	    var location = _props2.location;
	    var routes = _props2.routes;
	    var params = _props2.params;
	    var components = _props2.components;
	
	    var element = null;
	
	    if (components) {
	      element = components.reduceRight(function (element, components, index) {
	        if (components == null) return element; // Don't create new children; use the grandchildren.
	
	        var route = routes[index];
	        var routeParams = (0, _getRouteParams2["default"])(route, params);
	        var props = {
	          history: history,
	          location: location,
	          params: params,
	          route: route,
	          routeParams: routeParams,
	          routes: routes
	        };
	
	        if ((0, _RouteUtils.isReactChildren)(element)) {
	          props.children = element;
	        } else if (element) {
	          for (var prop in element) {
	            if (Object.prototype.hasOwnProperty.call(element, prop)) props[prop] = element[prop];
	          }
	        }
	
	        if ((typeof components === 'undefined' ? 'undefined' : _typeof(components)) === 'object') {
	          var elements = {};
	
	          for (var key in components) {
	            if (Object.prototype.hasOwnProperty.call(components, key)) {
	              // Pass through the key as a prop to createElement to allow
	              // custom createElement functions to know which named component
	              // they're rendering, for e.g. matching up to fetched data.
	              elements[key] = _this.createElement(components[key], _extends({
	                key: key }, props));
	            }
	          }
	
	          return elements;
	        }
	
	        return _this.createElement(components, props);
	      }, element);
	    }
	
	    !(element === null || element === false || _react2["default"].isValidElement(element)) ?  true ? (0, _invariant2["default"])(false, 'The root route must render a single element') : (0, _invariant2["default"])(false) : void 0;
	
	    return element;
	  }
	});
	
	exports["default"] = RouterContext;
	module.exports = exports['default'];

/***/ },
/* 39 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _PatternUtils = __webpack_require__(28);
	
	/**
	 * Extracts an object of params the given route cares about from
	 * the given params object.
	 */
	function getRouteParams(route, params) {
	  var routeParams = {};
	
	  if (!route.path) return routeParams;
	
	  (0, _PatternUtils.getParamNames)(route.path).forEach(function (p) {
	    if (Object.prototype.hasOwnProperty.call(params, p)) {
	      routeParams[p] = params[p];
	    }
	  });
	
	  return routeParams;
	}
	
	exports["default"] = getRouteParams;
	module.exports = exports['default'];

/***/ },
/* 40 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	exports.createRouterObject = createRouterObject;
	exports.createRoutingHistory = createRoutingHistory;
	
	var _deprecateObjectProperties = __webpack_require__(34);
	
	var _deprecateObjectProperties2 = _interopRequireDefault(_deprecateObjectProperties);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function createRouterObject(history, transitionManager) {
	  return _extends({}, history, {
	    setRouteLeaveHook: transitionManager.listenBeforeLeavingRoute,
	    isActive: transitionManager.isActive
	  });
	}
	
	// deprecated
	function createRoutingHistory(history, transitionManager) {
	  history = _extends({}, history, transitionManager);
	
	  if (true) {
	    history = (0, _deprecateObjectProperties2["default"])(history, '`props.history` and `context.history` are deprecated. Please use `context.router`. http://tiny.cc/router-contextchanges');
	  }
	
	  return history;
	}

/***/ },
/* 41 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _RouteUtils = __webpack_require__(36);
	
	var _InternalPropTypes = __webpack_require__(37);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	var _React$PropTypes = _react2["default"].PropTypes;
	var string = _React$PropTypes.string;
	var func = _React$PropTypes.func;
	
	/**
	 * A <Route> is used to declare which components are rendered to the
	 * page when the URL matches a given pattern.
	 *
	 * Routes are arranged in a nested tree structure. When a new URL is
	 * requested, the tree is searched depth-first to find a route whose
	 * path matches the URL.  When one is found, all routes in the tree
	 * that lead to it are considered "active" and their components are
	 * rendered into the DOM, nested in the same order as in the tree.
	 */
	
	var Route = _react2["default"].createClass({
	  displayName: 'Route',
	
	
	  statics: {
	    createRouteFromReactElement: _RouteUtils.createRouteFromReactElement
	  },
	
	  propTypes: {
	    path: string,
	    component: _InternalPropTypes.component,
	    components: _InternalPropTypes.components,
	    getComponent: func,
	    getComponents: func
	  },
	
	  /* istanbul ignore next: sanity check */
	  render: function render() {
	     true ?  true ? (0, _invariant2["default"])(false, '<Route> elements are for router configuration only and should not be rendered') : (0, _invariant2["default"])(false) : void 0;
	  }
	});
	
	exports["default"] = Route;
	module.exports = exports['default'];

/***/ },
/* 42 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _createBrowserHistory = __webpack_require__(43);
	
	var _createBrowserHistory2 = _interopRequireDefault(_createBrowserHistory);
	
	var _createRouterHistory = __webpack_require__(44);
	
	var _createRouterHistory2 = _interopRequireDefault(_createRouterHistory);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	exports["default"] = (0, _createRouterHistory2["default"])(_createBrowserHistory2["default"]);
	module.exports = exports['default'];

/***/ },
/* 43 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _Actions = __webpack_require__(7);
	
	var _PathUtils = __webpack_require__(8);
	
	var _ExecutionEnvironment = __webpack_require__(9);
	
	var _DOMUtils = __webpack_require__(10);
	
	var _DOMStateStorage = __webpack_require__(11);
	
	var _createDOMHistory = __webpack_require__(12);
	
	var _createDOMHistory2 = _interopRequireDefault(_createDOMHistory);
	
	/**
	 * Creates and returns a history object that uses HTML5's history API
	 * (pushState, replaceState, and the popstate event) to manage history.
	 * This is the recommended method of managing history in browsers because
	 * it provides the cleanest URLs.
	 *
	 * Note: In browsers that do not support the HTML5 history API full
	 * page reloads will be used to preserve URLs.
	 */
	function createBrowserHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	  !_ExecutionEnvironment.canUseDOM ?  true ? _invariant2['default'](false, 'Browser history needs a DOM') : _invariant2['default'](false) : undefined;
	
	  var forceRefresh = options.forceRefresh;
	
	  var isSupported = _DOMUtils.supportsHistory();
	  var useRefresh = !isSupported || forceRefresh;
	
	  function getCurrentLocation(historyState) {
	    try {
	      historyState = historyState || window.history.state || {};
	    } catch (e) {
	      historyState = {};
	    }
	
	    var path = _DOMUtils.getWindowPath();
	    var _historyState = historyState;
	    var key = _historyState.key;
	
	    var state = undefined;
	    if (key) {
	      state = _DOMStateStorage.readState(key);
	    } else {
	      state = null;
	      key = history.createKey();
	
	      if (isSupported) window.history.replaceState(_extends({}, historyState, { key: key }), null);
	    }
	
	    var location = _PathUtils.parsePath(path);
	
	    return history.createLocation(_extends({}, location, { state: state }), undefined, key);
	  }
	
	  function startPopStateListener(_ref) {
	    var transitionTo = _ref.transitionTo;
	
	    function popStateListener(event) {
	      if (event.state === undefined) return; // Ignore extraneous popstate events in WebKit.
	
	      transitionTo(getCurrentLocation(event.state));
	    }
	
	    _DOMUtils.addEventListener(window, 'popstate', popStateListener);
	
	    return function () {
	      _DOMUtils.removeEventListener(window, 'popstate', popStateListener);
	    };
	  }
	
	  function finishTransition(location) {
	    var basename = location.basename;
	    var pathname = location.pathname;
	    var search = location.search;
	    var hash = location.hash;
	    var state = location.state;
	    var action = location.action;
	    var key = location.key;
	
	    if (action === _Actions.POP) return; // Nothing to do.
	
	    _DOMStateStorage.saveState(key, state);
	
	    var path = (basename || '') + pathname + search + hash;
	    var historyState = {
	      key: key
	    };
	
	    if (action === _Actions.PUSH) {
	      if (useRefresh) {
	        window.location.href = path;
	        return false; // Prevent location update.
	      } else {
	          window.history.pushState(historyState, null, path);
	        }
	    } else {
	      // REPLACE
	      if (useRefresh) {
	        window.location.replace(path);
	        return false; // Prevent location update.
	      } else {
	          window.history.replaceState(historyState, null, path);
	        }
	    }
	  }
	
	  var history = _createDOMHistory2['default'](_extends({}, options, {
	    getCurrentLocation: getCurrentLocation,
	    finishTransition: finishTransition,
	    saveState: _DOMStateStorage.saveState
	  }));
	
	  var listenerCount = 0,
	      stopPopStateListener = undefined;
	
	  function listenBefore(listener) {
	    if (++listenerCount === 1) stopPopStateListener = startPopStateListener(history);
	
	    var unlisten = history.listenBefore(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopPopStateListener();
	    };
	  }
	
	  function listen(listener) {
	    if (++listenerCount === 1) stopPopStateListener = startPopStateListener(history);
	
	    var unlisten = history.listen(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopPopStateListener();
	    };
	  }
	
	  // deprecated
	  function registerTransitionHook(hook) {
	    if (++listenerCount === 1) stopPopStateListener = startPopStateListener(history);
	
	    history.registerTransitionHook(hook);
	  }
	
	  // deprecated
	  function unregisterTransitionHook(hook) {
	    history.unregisterTransitionHook(hook);
	
	    if (--listenerCount === 0) stopPopStateListener();
	  }
	
	  return _extends({}, history, {
	    listenBefore: listenBefore,
	    listen: listen,
	    registerTransitionHook: registerTransitionHook,
	    unregisterTransitionHook: unregisterTransitionHook
	  });
	}
	
	exports['default'] = createBrowserHistory;
	module.exports = exports['default'];

/***/ },
/* 44 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	exports["default"] = function (createHistory) {
	  var history = void 0;
	  if (canUseDOM) history = (0, _useRouterHistory2["default"])(createHistory)();
	  return history;
	};
	
	var _useRouterHistory = __webpack_require__(45);
	
	var _useRouterHistory2 = _interopRequireDefault(_useRouterHistory);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	var canUseDOM = !!(typeof window !== 'undefined' && window.document && window.document.createElement);
	
	module.exports = exports['default'];

/***/ },
/* 45 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports["default"] = useRouterHistory;
	
	var _useQueries = __webpack_require__(21);
	
	var _useQueries2 = _interopRequireDefault(_useQueries);
	
	var _useBasename = __webpack_require__(46);
	
	var _useBasename2 = _interopRequireDefault(_useBasename);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function useRouterHistory(createHistory) {
	  return function (options) {
	    var history = (0, _useQueries2["default"])((0, _useBasename2["default"])(createHistory))(options);
	    history.__v2_compatible__ = true;
	    return history;
	  };
	}
	module.exports = exports['default'];

/***/ },
/* 46 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(5);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _ExecutionEnvironment = __webpack_require__(9);
	
	var _PathUtils = __webpack_require__(8);
	
	var _runTransitionHook = __webpack_require__(19);
	
	var _runTransitionHook2 = _interopRequireDefault(_runTransitionHook);
	
	var _deprecate = __webpack_require__(20);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	function useBasename(createHistory) {
	  return function () {
	    var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	    var history = createHistory(options);
	
	    var basename = options.basename;
	
	    var checkedBaseHref = false;
	
	    function checkBaseHref() {
	      if (checkedBaseHref) {
	        return;
	      }
	
	      // Automatically use the value of <base href> in HTML
	      // documents as basename if it's not explicitly given.
	      if (basename == null && _ExecutionEnvironment.canUseDOM) {
	        var base = document.getElementsByTagName('base')[0];
	        var baseHref = base && base.getAttribute('href');
	
	        if (baseHref != null) {
	          basename = baseHref;
	
	           true ? _warning2['default'](false, 'Automatically setting basename using <base href> is deprecated and will ' + 'be removed in the next major release. The semantics of <base href> are ' + 'subtly different from basename. Please pass the basename explicitly in ' + 'the options to createHistory') : undefined;
	        }
	      }
	
	      checkedBaseHref = true;
	    }
	
	    function addBasename(location) {
	      checkBaseHref();
	
	      if (basename && location.basename == null) {
	        if (location.pathname.indexOf(basename) === 0) {
	          location.pathname = location.pathname.substring(basename.length);
	          location.basename = basename;
	
	          if (location.pathname === '') location.pathname = '/';
	        } else {
	          location.basename = '';
	        }
	      }
	
	      return location;
	    }
	
	    function prependBasename(location) {
	      checkBaseHref();
	
	      if (!basename) return location;
	
	      if (typeof location === 'string') location = _PathUtils.parsePath(location);
	
	      var pname = location.pathname;
	      var normalizedBasename = basename.slice(-1) === '/' ? basename : basename + '/';
	      var normalizedPathname = pname.charAt(0) === '/' ? pname.slice(1) : pname;
	      var pathname = normalizedBasename + normalizedPathname;
	
	      return _extends({}, location, {
	        pathname: pathname
	      });
	    }
	
	    // Override all read methods with basename-aware versions.
	    function listenBefore(hook) {
	      return history.listenBefore(function (location, callback) {
	        _runTransitionHook2['default'](hook, addBasename(location), callback);
	      });
	    }
	
	    function listen(listener) {
	      return history.listen(function (location) {
	        listener(addBasename(location));
	      });
	    }
	
	    // Override all write methods with basename-aware versions.
	    function push(location) {
	      history.push(prependBasename(location));
	    }
	
	    function replace(location) {
	      history.replace(prependBasename(location));
	    }
	
	    function createPath(location) {
	      return history.createPath(prependBasename(location));
	    }
	
	    function createHref(location) {
	      return history.createHref(prependBasename(location));
	    }
	
	    function createLocation(location) {
	      for (var _len = arguments.length, args = Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
	        args[_key - 1] = arguments[_key];
	      }
	
	      return addBasename(history.createLocation.apply(history, [prependBasename(location)].concat(args)));
	    }
	
	    // deprecated
	    function pushState(state, path) {
	      if (typeof path === 'string') path = _PathUtils.parsePath(path);
	
	      push(_extends({ state: state }, path));
	    }
	
	    // deprecated
	    function replaceState(state, path) {
	      if (typeof path === 'string') path = _PathUtils.parsePath(path);
	
	      replace(_extends({ state: state }, path));
	    }
	
	    return _extends({}, history, {
	      listenBefore: listenBefore,
	      listen: listen,
	      push: push,
	      replace: replace,
	      createPath: createPath,
	      createHref: createHref,
	      createLocation: createLocation,
	
	      pushState: _deprecate2['default'](pushState, 'pushState is deprecated; use push instead'),
	      replaceState: _deprecate2['default'](replaceState, 'replaceState is deprecated; use replace instead')
	    });
	  };
	}
	
	exports['default'] = useBasename;
	module.exports = exports['default'];

/***/ },
/* 47 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	var _createLocation2 = __webpack_require__(49);
	
	var _createLocation3 = _interopRequireDefault(_createLocation2);
	
	var _createBrowserHistory = __webpack_require__(54);
	
	var _createBrowserHistory2 = _interopRequireDefault(_createBrowserHistory);
	
	exports.createHistory = _createBrowserHistory2['default'];
	
	var _createHashHistory2 = __webpack_require__(62);
	
	var _createHashHistory3 = _interopRequireDefault(_createHashHistory2);
	
	exports.createHashHistory = _createHashHistory3['default'];
	
	var _createMemoryHistory2 = __webpack_require__(63);
	
	var _createMemoryHistory3 = _interopRequireDefault(_createMemoryHistory2);
	
	exports.createMemoryHistory = _createMemoryHistory3['default'];
	
	var _useBasename2 = __webpack_require__(64);
	
	var _useBasename3 = _interopRequireDefault(_useBasename2);
	
	exports.useBasename = _useBasename3['default'];
	
	var _useBeforeUnload2 = __webpack_require__(65);
	
	var _useBeforeUnload3 = _interopRequireDefault(_useBeforeUnload2);
	
	exports.useBeforeUnload = _useBeforeUnload3['default'];
	
	var _useQueries2 = __webpack_require__(66);
	
	var _useQueries3 = _interopRequireDefault(_useQueries2);
	
	exports.useQueries = _useQueries3['default'];
	
	var _Actions2 = __webpack_require__(50);
	
	var _Actions3 = _interopRequireDefault(_Actions2);
	
	exports.Actions = _Actions3['default'];
	
	// deprecated
	
	var _enableBeforeUnload2 = __webpack_require__(68);
	
	var _enableBeforeUnload3 = _interopRequireDefault(_enableBeforeUnload2);
	
	exports.enableBeforeUnload = _enableBeforeUnload3['default'];
	
	var _enableQueries2 = __webpack_require__(69);
	
	var _enableQueries3 = _interopRequireDefault(_enableQueries2);
	
	exports.enableQueries = _enableQueries3['default'];
	var createLocation = _deprecate2['default'](_createLocation3['default'], 'Using createLocation without a history instance is deprecated; please use history.createLocation instead');
	exports.createLocation = createLocation;

/***/ },
/* 48 */
/***/ function(module, exports) {

	//import warning from 'warning'
	
	"use strict";
	
	exports.__esModule = true;
	function deprecate(fn) {
	  return fn;
	  //return function () {
	  //  warning(false, '[history] ' + message)
	  //  return fn.apply(this, arguments)
	  //}
	}
	
	exports["default"] = deprecate;
	module.exports = exports["default"];

/***/ },
/* 49 */
/***/ function(module, exports, __webpack_require__) {

	//import warning from 'warning'
	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _Actions = __webpack_require__(50);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	function createLocation() {
	  var location = arguments.length <= 0 || arguments[0] === undefined ? '/' : arguments[0];
	  var action = arguments.length <= 1 || arguments[1] === undefined ? _Actions.POP : arguments[1];
	  var key = arguments.length <= 2 || arguments[2] === undefined ? null : arguments[2];
	
	  var _fourthArg = arguments.length <= 3 || arguments[3] === undefined ? null : arguments[3];
	
	  if (typeof location === 'string') location = _parsePath2['default'](location);
	
	  if (typeof action === 'object') {
	    //warning(
	    //  false,
	    //  'The state (2nd) argument to createLocation is deprecated; use a ' +
	    //  'location descriptor instead'
	    //)
	
	    location = _extends({}, location, { state: action });
	
	    action = key || _Actions.POP;
	    key = _fourthArg;
	  }
	
	  var pathname = location.pathname || '/';
	  var search = location.search || '';
	  var hash = location.hash || '';
	  var state = location.state || null;
	
	  return {
	    pathname: pathname,
	    search: search,
	    hash: hash,
	    state: state,
	    action: action,
	    key: key
	  };
	}
	
	exports['default'] = createLocation;
	module.exports = exports['default'];

/***/ },
/* 50 */
/***/ function(module, exports) {

	/**
	 * Indicates that navigation was caused by a call to history.push.
	 */
	'use strict';
	
	exports.__esModule = true;
	var PUSH = 'PUSH';
	
	exports.PUSH = PUSH;
	/**
	 * Indicates that navigation was caused by a call to history.replace.
	 */
	var REPLACE = 'REPLACE';
	
	exports.REPLACE = REPLACE;
	/**
	 * Indicates that navigation was caused by some other action such
	 * as using a browser's back/forward buttons and/or manually manipulating
	 * the URL in a browser's location bar. This is the default.
	 *
	 * See https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onpopstate
	 * for more information.
	 */
	var POP = 'POP';
	
	exports.POP = POP;
	exports['default'] = {
	  PUSH: PUSH,
	  REPLACE: REPLACE,
	  POP: POP
	};

/***/ },
/* 51 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _extractPath = __webpack_require__(53);
	
	var _extractPath2 = _interopRequireDefault(_extractPath);
	
	function parsePath(path) {
	  var pathname = _extractPath2['default'](path);
	  var search = '';
	  var hash = '';
	
	   true ? _warning2['default'](path === pathname, 'A path must be pathname + search + hash only, not a fully qualified URL like "%s"', path) : undefined;
	
	  var hashIndex = pathname.indexOf('#');
	  if (hashIndex !== -1) {
	    hash = pathname.substring(hashIndex);
	    pathname = pathname.substring(0, hashIndex);
	  }
	
	  var searchIndex = pathname.indexOf('?');
	  if (searchIndex !== -1) {
	    search = pathname.substring(searchIndex);
	    pathname = pathname.substring(0, searchIndex);
	  }
	
	  if (pathname === '') pathname = '/';
	
	  return {
	    pathname: pathname,
	    search: search,
	    hash: hash
	  };
	}
	
	exports['default'] = parsePath;
	module.exports = exports['default'];

/***/ },
/* 52 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Copyright 2014-2015, Facebook, Inc.
	 * All rights reserved.
	 *
	 * This source code is licensed under the BSD-style license found in the
	 * LICENSE file in the root directory of this source tree. An additional grant
	 * of patent rights can be found in the PATENTS file in the same directory.
	 */
	
	'use strict';
	
	/**
	 * Similar to invariant but only logs a warning if the condition is not met.
	 * This can be used to log issues in development environments in critical
	 * paths. Removing the logging code for production environments will keep the
	 * same logic and follow the same code paths.
	 */
	
	var warning = function() {};
	
	if (true) {
	  warning = function(condition, format, args) {
	    var len = arguments.length;
	    args = new Array(len > 2 ? len - 2 : 0);
	    for (var key = 2; key < len; key++) {
	      args[key - 2] = arguments[key];
	    }
	    if (format === undefined) {
	      throw new Error(
	        '`warning(condition, format, ...args)` requires a warning ' +
	        'message argument'
	      );
	    }
	
	    if (format.length < 10 || (/^[s\W]*$/).test(format)) {
	      throw new Error(
	        'The warning format should be able to uniquely identify this ' +
	        'warning. Please, use a more descriptive format than: ' + format
	      );
	    }
	
	    if (!condition) {
	      var argIndex = 0;
	      var message = 'Warning: ' +
	        format.replace(/%s/g, function() {
	          return args[argIndex++];
	        });
	      if (typeof console !== 'undefined') {
	        console.error(message);
	      }
	      try {
	        // This error was thrown as a convenience so that you can use this stack
	        // to find the callsite that caused this warning to fire.
	        throw new Error(message);
	      } catch(x) {}
	    }
	  };
	}
	
	module.exports = warning;


/***/ },
/* 53 */
/***/ function(module, exports) {

	"use strict";
	
	exports.__esModule = true;
	function extractPath(string) {
	  var match = string.match(/^https?:\/\/[^\/]*/);
	
	  if (match == null) return string;
	
	  return string.substring(match[0].length);
	}
	
	exports["default"] = extractPath;
	module.exports = exports["default"];

/***/ },
/* 54 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _Actions = __webpack_require__(50);
	
	var _ExecutionEnvironment = __webpack_require__(55);
	
	var _DOMUtils = __webpack_require__(56);
	
	var _DOMStateStorage = __webpack_require__(57);
	
	var _createDOMHistory = __webpack_require__(58);
	
	var _createDOMHistory2 = _interopRequireDefault(_createDOMHistory);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	/**
	 * Creates and returns a history object that uses HTML5's history API
	 * (pushState, replaceState, and the popstate event) to manage history.
	 * This is the recommended method of managing history in browsers because
	 * it provides the cleanest URLs.
	 *
	 * Note: In browsers that do not support the HTML5 history API full
	 * page reloads will be used to preserve URLs.
	 */
	function createBrowserHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	  !_ExecutionEnvironment.canUseDOM ?  true ? _invariant2['default'](false, 'Browser history needs a DOM') : _invariant2['default'](false) : undefined;
	
	  var forceRefresh = options.forceRefresh;
	
	  var isSupported = _DOMUtils.supportsHistory();
	  var useRefresh = !isSupported || forceRefresh;
	
	  function getCurrentLocation(historyState) {
	    historyState = historyState || window.history.state || {};
	
	    var path = _DOMUtils.getWindowPath();
	    var _historyState = historyState;
	    var key = _historyState.key;
	
	    var state = undefined;
	    if (key) {
	      state = _DOMStateStorage.readState(key);
	    } else {
	      state = null;
	      key = history.createKey();
	
	      if (isSupported) window.history.replaceState(_extends({}, historyState, { key: key }), null, path);
	    }
	
	    var location = _parsePath2['default'](path);
	
	    return history.createLocation(_extends({}, location, { state: state }), undefined, key);
	  }
	
	  function startPopStateListener(_ref) {
	    var transitionTo = _ref.transitionTo;
	
	    function popStateListener(event) {
	      if (event.state === undefined) return; // Ignore extraneous popstate events in WebKit.
	
	      transitionTo(getCurrentLocation(event.state));
	    }
	
	    _DOMUtils.addEventListener(window, 'popstate', popStateListener);
	
	    return function () {
	      _DOMUtils.removeEventListener(window, 'popstate', popStateListener);
	    };
	  }
	
	  function finishTransition(location) {
	    var basename = location.basename;
	    var pathname = location.pathname;
	    var search = location.search;
	    var hash = location.hash;
	    var state = location.state;
	    var action = location.action;
	    var key = location.key;
	
	    if (action === _Actions.POP) return; // Nothing to do.
	
	    _DOMStateStorage.saveState(key, state);
	
	    var path = (basename || '') + pathname + search + hash;
	    var historyState = {
	      key: key
	    };
	
	    if (action === _Actions.PUSH) {
	      if (useRefresh) {
	        window.location.href = path;
	        return false; // Prevent location update.
	      } else {
	          window.history.pushState(historyState, null, path);
	        }
	    } else {
	      // REPLACE
	      if (useRefresh) {
	        window.location.replace(path);
	        return false; // Prevent location update.
	      } else {
	          window.history.replaceState(historyState, null, path);
	        }
	    }
	  }
	
	  var history = _createDOMHistory2['default'](_extends({}, options, {
	    getCurrentLocation: getCurrentLocation,
	    finishTransition: finishTransition,
	    saveState: _DOMStateStorage.saveState
	  }));
	
	  var listenerCount = 0,
	      stopPopStateListener = undefined;
	
	  function listenBefore(listener) {
	    if (++listenerCount === 1) stopPopStateListener = startPopStateListener(history);
	
	    var unlisten = history.listenBefore(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopPopStateListener();
	    };
	  }
	
	  function listen(listener) {
	    if (++listenerCount === 1) stopPopStateListener = startPopStateListener(history);
	
	    var unlisten = history.listen(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopPopStateListener();
	    };
	  }
	
	  // deprecated
	  function registerTransitionHook(hook) {
	    if (++listenerCount === 1) stopPopStateListener = startPopStateListener(history);
	
	    history.registerTransitionHook(hook);
	  }
	
	  // deprecated
	  function unregisterTransitionHook(hook) {
	    history.unregisterTransitionHook(hook);
	
	    if (--listenerCount === 0) stopPopStateListener();
	  }
	
	  return _extends({}, history, {
	    listenBefore: listenBefore,
	    listen: listen,
	    registerTransitionHook: registerTransitionHook,
	    unregisterTransitionHook: unregisterTransitionHook
	  });
	}
	
	exports['default'] = createBrowserHistory;
	module.exports = exports['default'];

/***/ },
/* 55 */
/***/ function(module, exports) {

	'use strict';
	
	exports.__esModule = true;
	var canUseDOM = !!(typeof window !== 'undefined' && window.document && window.document.createElement);
	exports.canUseDOM = canUseDOM;

/***/ },
/* 56 */
/***/ function(module, exports) {

	'use strict';
	
	exports.__esModule = true;
	exports.addEventListener = addEventListener;
	exports.removeEventListener = removeEventListener;
	exports.getHashPath = getHashPath;
	exports.replaceHashPath = replaceHashPath;
	exports.getWindowPath = getWindowPath;
	exports.go = go;
	exports.getUserConfirmation = getUserConfirmation;
	exports.supportsHistory = supportsHistory;
	exports.supportsGoWithoutReloadUsingHash = supportsGoWithoutReloadUsingHash;
	
	function addEventListener(node, event, listener) {
	  if (node.addEventListener) {
	    node.addEventListener(event, listener, false);
	  } else {
	    node.attachEvent('on' + event, listener);
	  }
	}
	
	function removeEventListener(node, event, listener) {
	  if (node.removeEventListener) {
	    node.removeEventListener(event, listener, false);
	  } else {
	    node.detachEvent('on' + event, listener);
	  }
	}
	
	function getHashPath() {
	  // We can't use window.location.hash here because it's not
	  // consistent across browsers - Firefox will pre-decode it!
	  return window.location.href.split('#')[1] || '';
	}
	
	function replaceHashPath(path) {
	  window.location.replace(window.location.pathname + window.location.search + '#' + path);
	}
	
	function getWindowPath() {
	  return window.location.pathname + window.location.search + window.location.hash;
	}
	
	function go(n) {
	  if (n) window.history.go(n);
	}
	
	function getUserConfirmation(message, callback) {
	  callback(window.confirm(message));
	}
	
	/**
	 * Returns true if the HTML5 history API is supported. Taken from Modernizr.
	 *
	 * https://github.com/Modernizr/Modernizr/blob/master/LICENSE
	 * https://github.com/Modernizr/Modernizr/blob/master/feature-detects/history.js
	 * changed to avoid false negatives for Windows Phones: https://github.com/rackt/react-router/issues/586
	 */
	
	function supportsHistory() {
	  var ua = navigator.userAgent;
	  if ((ua.indexOf('Android 2.') !== -1 || ua.indexOf('Android 4.0') !== -1) && ua.indexOf('Mobile Safari') !== -1 && ua.indexOf('Chrome') === -1 && ua.indexOf('Windows Phone') === -1) {
	    return false;
	  }
	  // FIXME: Work around our browser history not working correctly on Chrome
	  // iOS: https://github.com/rackt/react-router/issues/2565
	  if (ua.indexOf('CriOS') !== -1) {
	    return false;
	  }
	  return window.history && 'pushState' in window.history;
	}
	
	/**
	 * Returns false if using go(n) with hash history causes a full page reload.
	 */
	
	function supportsGoWithoutReloadUsingHash() {
	  var ua = navigator.userAgent;
	  return ua.indexOf('Firefox') === -1;
	}

/***/ },
/* 57 */
/***/ function(module, exports, __webpack_require__) {

	/*eslint-disable no-empty */
	'use strict';
	
	exports.__esModule = true;
	exports.saveState = saveState;
	exports.readState = readState;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var KeyPrefix = '@@History/';
	var QuotaExceededError = 'QuotaExceededError';
	var SecurityError = 'SecurityError';
	
	function createKey(key) {
	  return KeyPrefix + key;
	}
	
	function saveState(key, state) {
	  try {
	    window.sessionStorage.setItem(createKey(key), JSON.stringify(state));
	  } catch (error) {
	    if (error.name === SecurityError) {
	      // Blocking cookies in Chrome/Firefox/Safari throws SecurityError on any
	      // attempt to access window.sessionStorage.
	       true ? _warning2['default'](false, '[history] Unable to save state; sessionStorage is not available due to security settings') : undefined;
	
	      return;
	    }
	
	    if (error.name === QuotaExceededError && window.sessionStorage.length === 0) {
	      // Safari "private mode" throws QuotaExceededError.
	       true ? _warning2['default'](false, '[history] Unable to save state; sessionStorage is not available in Safari private mode') : undefined;
	
	      return;
	    }
	
	    throw error;
	  }
	}
	
	function readState(key) {
	  var json = undefined;
	  try {
	    json = window.sessionStorage.getItem(createKey(key));
	  } catch (error) {
	    if (error.name === SecurityError) {
	      // Blocking cookies in Chrome/Firefox/Safari throws SecurityError on any
	      // attempt to access window.sessionStorage.
	       true ? _warning2['default'](false, '[history] Unable to read state; sessionStorage is not available due to security settings') : undefined;
	
	      return null;
	    }
	  }
	
	  if (json) {
	    try {
	      return JSON.parse(json);
	    } catch (error) {
	      // Ignore invalid JSON.
	    }
	  }
	
	  return null;
	}

/***/ },
/* 58 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _ExecutionEnvironment = __webpack_require__(55);
	
	var _DOMUtils = __webpack_require__(56);
	
	var _createHistory = __webpack_require__(59);
	
	var _createHistory2 = _interopRequireDefault(_createHistory);
	
	function createDOMHistory(options) {
	  var history = _createHistory2['default'](_extends({
	    getUserConfirmation: _DOMUtils.getUserConfirmation
	  }, options, {
	    go: _DOMUtils.go
	  }));
	
	  function listen(listener) {
	    !_ExecutionEnvironment.canUseDOM ?  true ? _invariant2['default'](false, 'DOM history needs a DOM') : _invariant2['default'](false) : undefined;
	
	    return history.listen(listener);
	  }
	
	  return _extends({}, history, {
	    listen: listen
	  });
	}
	
	exports['default'] = createDOMHistory;
	module.exports = exports['default'];

/***/ },
/* 59 */
/***/ function(module, exports, __webpack_require__) {

	//import warning from 'warning'
	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _deepEqual = __webpack_require__(14);
	
	var _deepEqual2 = _interopRequireDefault(_deepEqual);
	
	var _AsyncUtils = __webpack_require__(60);
	
	var _Actions = __webpack_require__(50);
	
	var _createLocation2 = __webpack_require__(49);
	
	var _createLocation3 = _interopRequireDefault(_createLocation2);
	
	var _runTransitionHook = __webpack_require__(61);
	
	var _runTransitionHook2 = _interopRequireDefault(_runTransitionHook);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	function createRandomKey(length) {
	  return Math.random().toString(36).substr(2, length);
	}
	
	function locationsAreEqual(a, b) {
	  return a.pathname === b.pathname && a.search === b.search &&
	  //a.action === b.action && // Different action !== location change.
	  a.key === b.key && _deepEqual2['default'](a.state, b.state);
	}
	
	var DefaultKeyLength = 6;
	
	function createHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	  var getCurrentLocation = options.getCurrentLocation;
	  var finishTransition = options.finishTransition;
	  var saveState = options.saveState;
	  var go = options.go;
	  var keyLength = options.keyLength;
	  var getUserConfirmation = options.getUserConfirmation;
	
	  if (typeof keyLength !== 'number') keyLength = DefaultKeyLength;
	
	  var transitionHooks = [];
	
	  function listenBefore(hook) {
	    transitionHooks.push(hook);
	
	    return function () {
	      transitionHooks = transitionHooks.filter(function (item) {
	        return item !== hook;
	      });
	    };
	  }
	
	  var allKeys = [];
	  var changeListeners = [];
	  var location = undefined;
	
	  function getCurrent() {
	    if (pendingLocation && pendingLocation.action === _Actions.POP) {
	      return allKeys.indexOf(pendingLocation.key);
	    } else if (location) {
	      return allKeys.indexOf(location.key);
	    } else {
	      return -1;
	    }
	  }
	
	  function updateLocation(newLocation) {
	    var current = getCurrent();
	
	    location = newLocation;
	
	    if (location.action === _Actions.PUSH) {
	      allKeys = [].concat(allKeys.slice(0, current + 1), [location.key]);
	    } else if (location.action === _Actions.REPLACE) {
	      allKeys[current] = location.key;
	    }
	
	    changeListeners.forEach(function (listener) {
	      listener(location);
	    });
	  }
	
	  function listen(listener) {
	    changeListeners.push(listener);
	
	    if (location) {
	      listener(location);
	    } else {
	      var _location = getCurrentLocation();
	      allKeys = [_location.key];
	      updateLocation(_location);
	    }
	
	    return function () {
	      changeListeners = changeListeners.filter(function (item) {
	        return item !== listener;
	      });
	    };
	  }
	
	  function confirmTransitionTo(location, callback) {
	    _AsyncUtils.loopAsync(transitionHooks.length, function (index, next, done) {
	      _runTransitionHook2['default'](transitionHooks[index], location, function (result) {
	        if (result != null) {
	          done(result);
	        } else {
	          next();
	        }
	      });
	    }, function (message) {
	      if (getUserConfirmation && typeof message === 'string') {
	        getUserConfirmation(message, function (ok) {
	          callback(ok !== false);
	        });
	      } else {
	        callback(message !== false);
	      }
	    });
	  }
	
	  var pendingLocation = undefined;
	
	  function transitionTo(nextLocation) {
	    if (location && locationsAreEqual(location, nextLocation)) return; // Nothing to do.
	
	    pendingLocation = nextLocation;
	
	    confirmTransitionTo(nextLocation, function (ok) {
	      if (pendingLocation !== nextLocation) return; // Transition was interrupted.
	
	      if (ok) {
	        // treat PUSH to current path like REPLACE to be consistent with browsers
	        if (nextLocation.action === _Actions.PUSH) {
	          var prevPath = createPath(location);
	          var nextPath = createPath(nextLocation);
	
	          if (nextPath === prevPath) nextLocation.action = _Actions.REPLACE;
	        }
	
	        if (finishTransition(nextLocation) !== false) updateLocation(nextLocation);
	      } else if (location && nextLocation.action === _Actions.POP) {
	        var prevIndex = allKeys.indexOf(location.key);
	        var nextIndex = allKeys.indexOf(nextLocation.key);
	
	        if (prevIndex !== -1 && nextIndex !== -1) go(prevIndex - nextIndex); // Restore the URL.
	      }
	    });
	  }
	
	  function push(location) {
	    transitionTo(createLocation(location, _Actions.PUSH, createKey()));
	  }
	
	  function replace(location) {
	    transitionTo(createLocation(location, _Actions.REPLACE, createKey()));
	  }
	
	  function goBack() {
	    go(-1);
	  }
	
	  function goForward() {
	    go(1);
	  }
	
	  function createKey() {
	    return createRandomKey(keyLength);
	  }
	
	  function createPath(location) {
	    if (location == null || typeof location === 'string') return location;
	
	    var pathname = location.pathname;
	    var search = location.search;
	    var hash = location.hash;
	
	    var result = pathname;
	
	    if (search) result += search;
	
	    if (hash) result += hash;
	
	    return result;
	  }
	
	  function createHref(location) {
	    return createPath(location);
	  }
	
	  function createLocation(location, action) {
	    var key = arguments.length <= 2 || arguments[2] === undefined ? createKey() : arguments[2];
	
	    if (typeof action === 'object') {
	      //warning(
	      //  false,
	      //  'The state (2nd) argument to history.createLocation is deprecated; use a ' +
	      //  'location descriptor instead'
	      //)
	
	      if (typeof location === 'string') location = _parsePath2['default'](location);
	
	      location = _extends({}, location, { state: action });
	
	      action = key;
	      key = arguments[3] || createKey();
	    }
	
	    return _createLocation3['default'](location, action, key);
	  }
	
	  // deprecated
	  function setState(state) {
	    if (location) {
	      updateLocationState(location, state);
	      updateLocation(location);
	    } else {
	      updateLocationState(getCurrentLocation(), state);
	    }
	  }
	
	  function updateLocationState(location, state) {
	    location.state = _extends({}, location.state, state);
	    saveState(location.key, location.state);
	  }
	
	  // deprecated
	  function registerTransitionHook(hook) {
	    if (transitionHooks.indexOf(hook) === -1) transitionHooks.push(hook);
	  }
	
	  // deprecated
	  function unregisterTransitionHook(hook) {
	    transitionHooks = transitionHooks.filter(function (item) {
	      return item !== hook;
	    });
	  }
	
	  // deprecated
	  function pushState(state, path) {
	    if (typeof path === 'string') path = _parsePath2['default'](path);
	
	    push(_extends({ state: state }, path));
	  }
	
	  // deprecated
	  function replaceState(state, path) {
	    if (typeof path === 'string') path = _parsePath2['default'](path);
	
	    replace(_extends({ state: state }, path));
	  }
	
	  return {
	    listenBefore: listenBefore,
	    listen: listen,
	    transitionTo: transitionTo,
	    push: push,
	    replace: replace,
	    go: go,
	    goBack: goBack,
	    goForward: goForward,
	    createKey: createKey,
	    createPath: createPath,
	    createHref: createHref,
	    createLocation: createLocation,
	
	    setState: _deprecate2['default'](setState, 'setState is deprecated; use location.key to save state instead'),
	    registerTransitionHook: _deprecate2['default'](registerTransitionHook, 'registerTransitionHook is deprecated; use listenBefore instead'),
	    unregisterTransitionHook: _deprecate2['default'](unregisterTransitionHook, 'unregisterTransitionHook is deprecated; use the callback returned from listenBefore instead'),
	    pushState: _deprecate2['default'](pushState, 'pushState is deprecated; use push instead'),
	    replaceState: _deprecate2['default'](replaceState, 'replaceState is deprecated; use replace instead')
	  };
	}
	
	exports['default'] = createHistory;
	module.exports = exports['default'];

/***/ },
/* 60 */
/***/ function(module, exports) {

	"use strict";
	
	exports.__esModule = true;
	exports.loopAsync = loopAsync;
	
	function loopAsync(turns, work, callback) {
	  var currentTurn = 0;
	  var isDone = false;
	
	  function done() {
	    isDone = true;
	    callback.apply(this, arguments);
	  }
	
	  function next() {
	    if (isDone) return;
	
	    if (currentTurn < turns) {
	      work.call(this, currentTurn++, next, done);
	    } else {
	      done.apply(this, arguments);
	    }
	  }
	
	  next();
	}

/***/ },
/* 61 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	function runTransitionHook(hook, location, callback) {
	  var result = hook(location, callback);
	
	  if (hook.length < 2) {
	    // Assume the hook runs synchronously and automatically
	    // call the callback with the return value.
	    callback(result);
	  } else {
	     true ? _warning2['default'](result === undefined, 'You should not "return" in a transition hook with a callback argument; call the callback instead') : undefined;
	  }
	}
	
	exports['default'] = runTransitionHook;
	module.exports = exports['default'];

/***/ },
/* 62 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _Actions = __webpack_require__(50);
	
	var _ExecutionEnvironment = __webpack_require__(55);
	
	var _DOMUtils = __webpack_require__(56);
	
	var _DOMStateStorage = __webpack_require__(57);
	
	var _createDOMHistory = __webpack_require__(58);
	
	var _createDOMHistory2 = _interopRequireDefault(_createDOMHistory);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	function isAbsolutePath(path) {
	  return typeof path === 'string' && path.charAt(0) === '/';
	}
	
	function ensureSlash() {
	  var path = _DOMUtils.getHashPath();
	
	  if (isAbsolutePath(path)) return true;
	
	  _DOMUtils.replaceHashPath('/' + path);
	
	  return false;
	}
	
	function addQueryStringValueToPath(path, key, value) {
	  return path + (path.indexOf('?') === -1 ? '?' : '&') + (key + '=' + value);
	}
	
	function stripQueryStringValueFromPath(path, key) {
	  return path.replace(new RegExp('[?&]?' + key + '=[a-zA-Z0-9]+'), '');
	}
	
	function getQueryStringValueFromPath(path, key) {
	  var match = path.match(new RegExp('\\?.*?\\b' + key + '=(.+?)\\b'));
	  return match && match[1];
	}
	
	var DefaultQueryKey = '_k';
	
	function createHashHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	  !_ExecutionEnvironment.canUseDOM ?  true ? _invariant2['default'](false, 'Hash history needs a DOM') : _invariant2['default'](false) : undefined;
	
	  var queryKey = options.queryKey;
	
	  if (queryKey === undefined || !!queryKey) queryKey = typeof queryKey === 'string' ? queryKey : DefaultQueryKey;
	
	  function getCurrentLocation() {
	    var path = _DOMUtils.getHashPath();
	
	    var key = undefined,
	        state = undefined;
	    if (queryKey) {
	      key = getQueryStringValueFromPath(path, queryKey);
	      path = stripQueryStringValueFromPath(path, queryKey);
	
	      if (key) {
	        state = _DOMStateStorage.readState(key);
	      } else {
	        state = null;
	        key = history.createKey();
	        _DOMUtils.replaceHashPath(addQueryStringValueToPath(path, queryKey, key));
	      }
	    } else {
	      key = state = null;
	    }
	
	    var location = _parsePath2['default'](path);
	
	    return history.createLocation(_extends({}, location, { state: state }), undefined, key);
	  }
	
	  function startHashChangeListener(_ref) {
	    var transitionTo = _ref.transitionTo;
	
	    function hashChangeListener() {
	      if (!ensureSlash()) return; // Always make sure hashes are preceeded with a /.
	
	      transitionTo(getCurrentLocation());
	    }
	
	    ensureSlash();
	    _DOMUtils.addEventListener(window, 'hashchange', hashChangeListener);
	
	    return function () {
	      _DOMUtils.removeEventListener(window, 'hashchange', hashChangeListener);
	    };
	  }
	
	  function finishTransition(location) {
	    var basename = location.basename;
	    var pathname = location.pathname;
	    var search = location.search;
	    var state = location.state;
	    var action = location.action;
	    var key = location.key;
	
	    if (action === _Actions.POP) return; // Nothing to do.
	
	    var path = (basename || '') + pathname + search;
	
	    if (queryKey) {
	      path = addQueryStringValueToPath(path, queryKey, key);
	      _DOMStateStorage.saveState(key, state);
	    } else {
	      // Drop key and state.
	      location.key = location.state = null;
	    }
	
	    var currentHash = _DOMUtils.getHashPath();
	
	    if (action === _Actions.PUSH) {
	      if (currentHash !== path) {
	        window.location.hash = path;
	      } else {
	         true ? _warning2['default'](false, 'You cannot PUSH the same path using hash history') : undefined;
	      }
	    } else if (currentHash !== path) {
	      // REPLACE
	      _DOMUtils.replaceHashPath(path);
	    }
	  }
	
	  var history = _createDOMHistory2['default'](_extends({}, options, {
	    getCurrentLocation: getCurrentLocation,
	    finishTransition: finishTransition,
	    saveState: _DOMStateStorage.saveState
	  }));
	
	  var listenerCount = 0,
	      stopHashChangeListener = undefined;
	
	  function listenBefore(listener) {
	    if (++listenerCount === 1) stopHashChangeListener = startHashChangeListener(history);
	
	    var unlisten = history.listenBefore(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopHashChangeListener();
	    };
	  }
	
	  function listen(listener) {
	    if (++listenerCount === 1) stopHashChangeListener = startHashChangeListener(history);
	
	    var unlisten = history.listen(listener);
	
	    return function () {
	      unlisten();
	
	      if (--listenerCount === 0) stopHashChangeListener();
	    };
	  }
	
	  function push(location) {
	     true ? _warning2['default'](queryKey || location.state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.push(location);
	  }
	
	  function replace(location) {
	     true ? _warning2['default'](queryKey || location.state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.replace(location);
	  }
	
	  var goIsSupportedWithoutReload = _DOMUtils.supportsGoWithoutReloadUsingHash();
	
	  function go(n) {
	     true ? _warning2['default'](goIsSupportedWithoutReload, 'Hash history go(n) causes a full page reload in this browser') : undefined;
	
	    history.go(n);
	  }
	
	  function createHref(path) {
	    return '#' + history.createHref(path);
	  }
	
	  // deprecated
	  function registerTransitionHook(hook) {
	    if (++listenerCount === 1) stopHashChangeListener = startHashChangeListener(history);
	
	    history.registerTransitionHook(hook);
	  }
	
	  // deprecated
	  function unregisterTransitionHook(hook) {
	    history.unregisterTransitionHook(hook);
	
	    if (--listenerCount === 0) stopHashChangeListener();
	  }
	
	  // deprecated
	  function pushState(state, path) {
	     true ? _warning2['default'](queryKey || state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.pushState(state, path);
	  }
	
	  // deprecated
	  function replaceState(state, path) {
	     true ? _warning2['default'](queryKey || state == null, 'You cannot use state without a queryKey it will be dropped') : undefined;
	
	    history.replaceState(state, path);
	  }
	
	  return _extends({}, history, {
	    listenBefore: listenBefore,
	    listen: listen,
	    push: push,
	    replace: replace,
	    go: go,
	    createHref: createHref,
	
	    registerTransitionHook: registerTransitionHook, // deprecated - warning is in createHistory
	    unregisterTransitionHook: unregisterTransitionHook, // deprecated - warning is in createHistory
	    pushState: pushState, // deprecated - warning is in createHistory
	    replaceState: replaceState // deprecated - warning is in createHistory
	  });
	}
	
	exports['default'] = createHashHistory;
	module.exports = exports['default'];

/***/ },
/* 63 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _Actions = __webpack_require__(50);
	
	var _createHistory = __webpack_require__(59);
	
	var _createHistory2 = _interopRequireDefault(_createHistory);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	function createStateStorage(entries) {
	  return entries.filter(function (entry) {
	    return entry.state;
	  }).reduce(function (memo, entry) {
	    memo[entry.key] = entry.state;
	    return memo;
	  }, {});
	}
	
	function createMemoryHistory() {
	  var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	
	  if (Array.isArray(options)) {
	    options = { entries: options };
	  } else if (typeof options === 'string') {
	    options = { entries: [options] };
	  }
	
	  var history = _createHistory2['default'](_extends({}, options, {
	    getCurrentLocation: getCurrentLocation,
	    finishTransition: finishTransition,
	    saveState: saveState,
	    go: go
	  }));
	
	  var _options = options;
	  var entries = _options.entries;
	  var current = _options.current;
	
	  if (typeof entries === 'string') {
	    entries = [entries];
	  } else if (!Array.isArray(entries)) {
	    entries = ['/'];
	  }
	
	  entries = entries.map(function (entry) {
	    var key = history.createKey();
	
	    if (typeof entry === 'string') return { pathname: entry, key: key };
	
	    if (typeof entry === 'object' && entry) return _extends({}, entry, { key: key });
	
	     true ?  true ? _invariant2['default'](false, 'Unable to create history entry from %s', entry) : _invariant2['default'](false) : undefined;
	  });
	
	  if (current == null) {
	    current = entries.length - 1;
	  } else {
	    !(current >= 0 && current < entries.length) ?  true ? _invariant2['default'](false, 'Current index must be >= 0 and < %s, was %s', entries.length, current) : _invariant2['default'](false) : undefined;
	  }
	
	  var storage = createStateStorage(entries);
	
	  function saveState(key, state) {
	    storage[key] = state;
	  }
	
	  function readState(key) {
	    return storage[key];
	  }
	
	  function getCurrentLocation() {
	    var entry = entries[current];
	    var key = entry.key;
	    var basename = entry.basename;
	    var pathname = entry.pathname;
	    var search = entry.search;
	
	    var path = (basename || '') + pathname + (search || '');
	
	    var state = undefined;
	    if (key) {
	      state = readState(key);
	    } else {
	      state = null;
	      key = history.createKey();
	      entry.key = key;
	    }
	
	    var location = _parsePath2['default'](path);
	
	    return history.createLocation(_extends({}, location, { state: state }), undefined, key);
	  }
	
	  function canGo(n) {
	    var index = current + n;
	    return index >= 0 && index < entries.length;
	  }
	
	  function go(n) {
	    if (n) {
	      if (!canGo(n)) {
	         true ? _warning2['default'](false, 'Cannot go(%s) there is not enough history', n) : undefined;
	        return;
	      }
	
	      current += n;
	
	      var currentLocation = getCurrentLocation();
	
	      // change action to POP
	      history.transitionTo(_extends({}, currentLocation, { action: _Actions.POP }));
	    }
	  }
	
	  function finishTransition(location) {
	    switch (location.action) {
	      case _Actions.PUSH:
	        current += 1;
	
	        // if we are not on the top of stack
	        // remove rest and push new
	        if (current < entries.length) entries.splice(current);
	
	        entries.push(location);
	        saveState(location.key, location.state);
	        break;
	      case _Actions.REPLACE:
	        entries[current] = location;
	        saveState(location.key, location.state);
	        break;
	    }
	  }
	
	  return history;
	}
	
	exports['default'] = createMemoryHistory;
	module.exports = exports['default'];

/***/ },
/* 64 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	var _ExecutionEnvironment = __webpack_require__(55);
	
	var _runTransitionHook = __webpack_require__(61);
	
	var _runTransitionHook2 = _interopRequireDefault(_runTransitionHook);
	
	var _extractPath = __webpack_require__(53);
	
	var _extractPath2 = _interopRequireDefault(_extractPath);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	function useBasename(createHistory) {
	  return function () {
	    var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	    var basename = options.basename;
	
	    var historyOptions = _objectWithoutProperties(options, ['basename']);
	
	    var history = createHistory(historyOptions);
	
	    // Automatically use the value of <base href> in HTML
	    // documents as basename if it's not explicitly given.
	    if (basename == null && _ExecutionEnvironment.canUseDOM) {
	      var base = document.getElementsByTagName('base')[0];
	
	      if (base) basename = _extractPath2['default'](base.href);
	    }
	
	    function addBasename(location) {
	      if (basename && location.basename == null) {
	        if (location.pathname.indexOf(basename) === 0) {
	          location.pathname = location.pathname.substring(basename.length);
	          location.basename = basename;
	
	          if (location.pathname === '') location.pathname = '/';
	        } else {
	          location.basename = '';
	        }
	      }
	
	      return location;
	    }
	
	    function prependBasename(location) {
	      if (!basename) return location;
	
	      if (typeof location === 'string') location = _parsePath2['default'](location);
	
	      var pname = location.pathname;
	      var normalizedBasename = basename.slice(-1) === '/' ? basename : basename + '/';
	      var normalizedPathname = pname.charAt(0) === '/' ? pname.slice(1) : pname;
	      var pathname = normalizedBasename + normalizedPathname;
	
	      return _extends({}, location, {
	        pathname: pathname
	      });
	    }
	
	    // Override all read methods with basename-aware versions.
	    function listenBefore(hook) {
	      return history.listenBefore(function (location, callback) {
	        _runTransitionHook2['default'](hook, addBasename(location), callback);
	      });
	    }
	
	    function listen(listener) {
	      return history.listen(function (location) {
	        listener(addBasename(location));
	      });
	    }
	
	    // Override all write methods with basename-aware versions.
	    function push(location) {
	      history.push(prependBasename(location));
	    }
	
	    function replace(location) {
	      history.replace(prependBasename(location));
	    }
	
	    function createPath(location) {
	      return history.createPath(prependBasename(location));
	    }
	
	    function createHref(location) {
	      return history.createHref(prependBasename(location));
	    }
	
	    function createLocation() {
	      return addBasename(history.createLocation.apply(history, arguments));
	    }
	
	    // deprecated
	    function pushState(state, path) {
	      if (typeof path === 'string') path = _parsePath2['default'](path);
	
	      push(_extends({ state: state }, path));
	    }
	
	    // deprecated
	    function replaceState(state, path) {
	      if (typeof path === 'string') path = _parsePath2['default'](path);
	
	      replace(_extends({ state: state }, path));
	    }
	
	    return _extends({}, history, {
	      listenBefore: listenBefore,
	      listen: listen,
	      push: push,
	      replace: replace,
	      createPath: createPath,
	      createHref: createHref,
	      createLocation: createLocation,
	
	      pushState: _deprecate2['default'](pushState, 'pushState is deprecated; use push instead'),
	      replaceState: _deprecate2['default'](replaceState, 'replaceState is deprecated; use replace instead')
	    });
	  };
	}
	
	exports['default'] = useBasename;
	module.exports = exports['default'];

/***/ },
/* 65 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _ExecutionEnvironment = __webpack_require__(55);
	
	var _DOMUtils = __webpack_require__(56);
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	function startBeforeUnloadListener(getBeforeUnloadPromptMessage) {
	  function listener(event) {
	    var message = getBeforeUnloadPromptMessage();
	
	    if (typeof message === 'string') {
	      (event || window.event).returnValue = message;
	      return message;
	    }
	  }
	
	  _DOMUtils.addEventListener(window, 'beforeunload', listener);
	
	  return function () {
	    _DOMUtils.removeEventListener(window, 'beforeunload', listener);
	  };
	}
	
	/**
	 * Returns a new createHistory function that can be used to create
	 * history objects that know how to use the beforeunload event in web
	 * browsers to cancel navigation.
	 */
	function useBeforeUnload(createHistory) {
	  return function (options) {
	    var history = createHistory(options);
	
	    var stopBeforeUnloadListener = undefined;
	    var beforeUnloadHooks = [];
	
	    function getBeforeUnloadPromptMessage() {
	      var message = undefined;
	
	      for (var i = 0, len = beforeUnloadHooks.length; message == null && i < len; ++i) {
	        message = beforeUnloadHooks[i].call();
	      }return message;
	    }
	
	    function listenBeforeUnload(hook) {
	      beforeUnloadHooks.push(hook);
	
	      if (beforeUnloadHooks.length === 1) {
	        if (_ExecutionEnvironment.canUseDOM) {
	          stopBeforeUnloadListener = startBeforeUnloadListener(getBeforeUnloadPromptMessage);
	        } else {
	           true ? _warning2['default'](false, 'listenBeforeUnload only works in DOM environments') : undefined;
	        }
	      }
	
	      return function () {
	        beforeUnloadHooks = beforeUnloadHooks.filter(function (item) {
	          return item !== hook;
	        });
	
	        if (beforeUnloadHooks.length === 0 && stopBeforeUnloadListener) {
	          stopBeforeUnloadListener();
	          stopBeforeUnloadListener = null;
	        }
	      };
	    }
	
	    // deprecated
	    function registerBeforeUnloadHook(hook) {
	      if (_ExecutionEnvironment.canUseDOM && beforeUnloadHooks.indexOf(hook) === -1) {
	        beforeUnloadHooks.push(hook);
	
	        if (beforeUnloadHooks.length === 1) stopBeforeUnloadListener = startBeforeUnloadListener(getBeforeUnloadPromptMessage);
	      }
	    }
	
	    // deprecated
	    function unregisterBeforeUnloadHook(hook) {
	      if (beforeUnloadHooks.length > 0) {
	        beforeUnloadHooks = beforeUnloadHooks.filter(function (item) {
	          return item !== hook;
	        });
	
	        if (beforeUnloadHooks.length === 0) stopBeforeUnloadListener();
	      }
	    }
	
	    return _extends({}, history, {
	      listenBeforeUnload: listenBeforeUnload,
	
	      registerBeforeUnloadHook: _deprecate2['default'](registerBeforeUnloadHook, 'registerBeforeUnloadHook is deprecated; use listenBeforeUnload instead'),
	      unregisterBeforeUnloadHook: _deprecate2['default'](unregisterBeforeUnloadHook, 'unregisterBeforeUnloadHook is deprecated; use the callback returned from listenBeforeUnload instead')
	    });
	  };
	}
	
	exports['default'] = useBeforeUnload;
	module.exports = exports['default'];

/***/ },
/* 66 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	var _warning = __webpack_require__(52);
	
	var _warning2 = _interopRequireDefault(_warning);
	
	var _queryString = __webpack_require__(67);
	
	var _runTransitionHook = __webpack_require__(61);
	
	var _runTransitionHook2 = _interopRequireDefault(_runTransitionHook);
	
	var _parsePath = __webpack_require__(51);
	
	var _parsePath2 = _interopRequireDefault(_parsePath);
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	var SEARCH_BASE_KEY = '$searchBase';
	
	function defaultStringifyQuery(query) {
	  return _queryString.stringify(query).replace(/%20/g, '+');
	}
	
	var defaultParseQueryString = _queryString.parse;
	
	function isNestedObject(object) {
	  for (var p in object) {
	    if (object.hasOwnProperty(p) && typeof object[p] === 'object' && !Array.isArray(object[p]) && object[p] !== null) return true;
	  }return false;
	}
	
	/**
	 * Returns a new createHistory function that may be used to create
	 * history objects that know how to handle URL queries.
	 */
	function useQueries(createHistory) {
	  return function () {
	    var options = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];
	    var stringifyQuery = options.stringifyQuery;
	    var parseQueryString = options.parseQueryString;
	
	    var historyOptions = _objectWithoutProperties(options, ['stringifyQuery', 'parseQueryString']);
	
	    var history = createHistory(historyOptions);
	
	    if (typeof stringifyQuery !== 'function') stringifyQuery = defaultStringifyQuery;
	
	    if (typeof parseQueryString !== 'function') parseQueryString = defaultParseQueryString;
	
	    function addQuery(location) {
	      if (location.query == null) {
	        var search = location.search;
	
	        location.query = parseQueryString(search.substring(1));
	        location[SEARCH_BASE_KEY] = { search: search, searchBase: '' };
	      }
	
	      // TODO: Instead of all the book-keeping here, this should just strip the
	      // stringified query from the search.
	
	      return location;
	    }
	
	    function appendQuery(location, query) {
	      var _extends2;
	
	      var queryString = undefined;
	      if (!query || (queryString = stringifyQuery(query)) === '') return location;
	
	       true ? _warning2['default'](stringifyQuery !== defaultStringifyQuery || !isNestedObject(query), 'useQueries does not stringify nested query objects by default; ' + 'use a custom stringifyQuery function') : undefined;
	
	      if (typeof location === 'string') location = _parsePath2['default'](location);
	
	      var searchBaseSpec = location[SEARCH_BASE_KEY];
	      var searchBase = undefined;
	      if (searchBaseSpec && location.search === searchBaseSpec.search) {
	        searchBase = searchBaseSpec.searchBase;
	      } else {
	        searchBase = location.search || '';
	      }
	
	      var search = searchBase + (searchBase ? '&' : '?') + queryString;
	
	      return _extends({}, location, (_extends2 = {
	        search: search
	      }, _extends2[SEARCH_BASE_KEY] = { search: search, searchBase: searchBase }, _extends2));
	    }
	
	    // Override all read methods with query-aware versions.
	    function listenBefore(hook) {
	      return history.listenBefore(function (location, callback) {
	        _runTransitionHook2['default'](hook, addQuery(location), callback);
	      });
	    }
	
	    function listen(listener) {
	      return history.listen(function (location) {
	        listener(addQuery(location));
	      });
	    }
	
	    // Override all write methods with query-aware versions.
	    function push(location) {
	      history.push(appendQuery(location, location.query));
	    }
	
	    function replace(location) {
	      history.replace(appendQuery(location, location.query));
	    }
	
	    function createPath(location, query) {
	      //warning(
	      //  !query,
	      //  'the query argument to createPath is deprecated; use a location descriptor instead'
	      //)
	      return history.createPath(appendQuery(location, query || location.query));
	    }
	
	    function createHref(location, query) {
	      //warning(
	      //  !query,
	      //  'the query argument to createHref is deprecated; use a location descriptor instead'
	      //)
	      return history.createHref(appendQuery(location, query || location.query));
	    }
	
	    function createLocation() {
	      return addQuery(history.createLocation.apply(history, arguments));
	    }
	
	    // deprecated
	    function pushState(state, path, query) {
	      if (typeof path === 'string') path = _parsePath2['default'](path);
	
	      push(_extends({ state: state }, path, { query: query }));
	    }
	
	    // deprecated
	    function replaceState(state, path, query) {
	      if (typeof path === 'string') path = _parsePath2['default'](path);
	
	      replace(_extends({ state: state }, path, { query: query }));
	    }
	
	    return _extends({}, history, {
	      listenBefore: listenBefore,
	      listen: listen,
	      push: push,
	      replace: replace,
	      createPath: createPath,
	      createHref: createHref,
	      createLocation: createLocation,
	
	      pushState: _deprecate2['default'](pushState, 'pushState is deprecated; use push instead'),
	      replaceState: _deprecate2['default'](replaceState, 'replaceState is deprecated; use replace instead')
	    });
	  };
	}
	
	exports['default'] = useQueries;
	module.exports = exports['default'];

/***/ },
/* 67 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	var strictUriEncode = __webpack_require__(23);
	
	exports.extract = function (str) {
		return str.split('?')[1] || '';
	};
	
	exports.parse = function (str) {
		if (typeof str !== 'string') {
			return {};
		}
	
		str = str.trim().replace(/^(\?|#|&)/, '');
	
		if (!str) {
			return {};
		}
	
		return str.split('&').reduce(function (ret, param) {
			var parts = param.replace(/\+/g, ' ').split('=');
			// Firefox (pre 40) decodes `%3D` to `=`
			// https://github.com/sindresorhus/query-string/pull/37
			var key = parts.shift();
			var val = parts.length > 0 ? parts.join('=') : undefined;
	
			key = decodeURIComponent(key);
	
			// missing `=` should be `null`:
			// http://w3.org/TR/2012/WD-url-20120524/#collect-url-parameters
			val = val === undefined ? null : decodeURIComponent(val);
	
			if (!ret.hasOwnProperty(key)) {
				ret[key] = val;
			} else if (Array.isArray(ret[key])) {
				ret[key].push(val);
			} else {
				ret[key] = [ret[key], val];
			}
	
			return ret;
		}, {});
	};
	
	exports.stringify = function (obj) {
		return obj ? Object.keys(obj).sort().map(function (key) {
			var val = obj[key];
	
			if (val === undefined) {
				return '';
			}
	
			if (val === null) {
				return key;
			}
	
			if (Array.isArray(val)) {
				return val.slice().sort().map(function (val2) {
					return strictUriEncode(key) + '=' + strictUriEncode(val2);
				}).join('&');
			}
	
			return strictUriEncode(key) + '=' + strictUriEncode(val);
		}).filter(function (x) {
			return x.length > 0;
		}).join('&') : '';
	};


/***/ },
/* 68 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	var _useBeforeUnload = __webpack_require__(65);
	
	var _useBeforeUnload2 = _interopRequireDefault(_useBeforeUnload);
	
	exports['default'] = _deprecate2['default'](_useBeforeUnload2['default'], 'enableBeforeUnload is deprecated, use useBeforeUnload instead');
	module.exports = exports['default'];

/***/ },
/* 69 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }
	
	var _deprecate = __webpack_require__(48);
	
	var _deprecate2 = _interopRequireDefault(_deprecate);
	
	var _useQueries = __webpack_require__(66);
	
	var _useQueries2 = _interopRequireDefault(_useQueries);
	
	exports['default'] = _deprecate2['default'](_useQueries2['default'], 'enableQueries is deprecated, use useQueries instead');
	module.exports = exports['default'];

/***/ },
/* 70 */
/***/ function(module, exports) {

	module.exports = antd;

/***/ },
/* 71 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _Link = __webpack_require__(72);
	
	var _Link2 = _interopRequireDefault(_Link);
	
	var _antd = __webpack_require__(70);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }
	
	function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }
	
	var Home = function (_Component) {
		_inherits(Home, _Component);
	
		function Home() {
			_classCallCheck(this, Home);
	
			return _possibleConstructorReturn(this, (Home.__proto__ || Object.getPrototypeOf(Home)).apply(this, arguments));
		}
	
		_createClass(Home, [{
			key: 'render',
			value: function render() {
				return _react2["default"].createElement(
					'div',
					{ className: 'code-box-demo', style: { background: '#ECECEC', padding: '30px' } },
					'/*    ',
					_react2["default"].createElement(
						_antd.Row,
						null,
						_react2["default"].createElement(
							_antd.Col,
							{ span: '12' },
							_react2["default"].createElement(
								_antd.Card,
								{ title: '\u666E\u901A\u7528\u6237\u529F\u80FD', bordered: false },
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/show' },
									'\u5DE5\u8D44\u67E5\u8BE2'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/mobile' },
									'\u79FB\u52A8\u5DE5\u8D44\u67E5\u8BE2'
								)
							)
						),
						_react2["default"].createElement(
							_antd.Col,
							{ span: '12' },
							_react2["default"].createElement(
								_antd.Card,
								{ title: '\u7BA1\u7406\u5458\u529F\u80FD', bordered: false },
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/set' },
									'\u5DE5\u8D44\u8BBE\u7F6E'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/msg' },
									'\u5DE5\u8D44\u77ED\u4FE1'
								)
							)
						)
					),
					'*/',
					_react2["default"].createElement(
						_antd.Row,
						null,
						_react2["default"].createElement(
							_antd.Col,
							{ span: '12' },
							_react2["default"].createElement(
								_antd.Card,
								{ title: '\u7FA4\u804A\u6295\u7968\u529F\u80FD', bordered: false },
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/pubnishvote' },
									'\u53D1\u5E03\u6295\u7968'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/votelist' },
									'\u6295\u7968\u5217\u8868'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/startvoting' },
									'\u6295\u7968\u754C\u9762'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/votedetail' },
									'\u6295\u7968\u8BE6\u60C5'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/groupuserlist' },
									'\u7FA4\u6210\u5458\u5217\u8868'
								),
								'\u3001',
								_react2["default"].createElement(
									_Link2["default"],
									{ to: '/voteoptiondetail' },
									'\u6295\u7968\u9009\u9879\u8BE6\u60C5'
								)
							)
						)
					)
				);
			}
		}]);
	
		return Home;
	}(_react.Component);
	
	exports["default"] = Home;

/***/ },
/* 72 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _react = __webpack_require__(1);
	
	var _react2 = _interopRequireDefault(_react);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	var _invariant = __webpack_require__(6);
	
	var _invariant2 = _interopRequireDefault(_invariant);
	
	var _PropTypes = __webpack_require__(73);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }
	
	var _React$PropTypes = _react2["default"].PropTypes;
	var bool = _React$PropTypes.bool;
	var object = _React$PropTypes.object;
	var string = _React$PropTypes.string;
	var func = _React$PropTypes.func;
	var oneOfType = _React$PropTypes.oneOfType;
	
	
	function isLeftClickEvent(event) {
	  return event.button === 0;
	}
	
	function isModifiedEvent(event) {
	  return !!(event.metaKey || event.altKey || event.ctrlKey || event.shiftKey);
	}
	
	// TODO: De-duplicate against hasAnyProperties in createTransitionManager.
	function isEmptyObject(object) {
	  for (var p in object) {
	    if (Object.prototype.hasOwnProperty.call(object, p)) return false;
	  }return true;
	}
	
	function createLocationDescriptor(to, _ref) {
	  var query = _ref.query;
	  var hash = _ref.hash;
	  var state = _ref.state;
	
	  if (query || hash || state) {
	    return { pathname: to, query: query, hash: hash, state: state };
	  }
	
	  return to;
	}
	
	/**
	 * A <Link> is used to create an <a> element that links to a route.
	 * When that route is active, the link gets the value of its
	 * activeClassName prop.
	 *
	 * For example, assuming you have the following route:
	 *
	 *   <Route path="/posts/:postID" component={Post} />
	 *
	 * You could use the following component to link to that route:
	 *
	 *   <Link to={`/posts/${post.id}`} />
	 *
	 * Links may pass along location state and/or query string parameters
	 * in the state/query props, respectively.
	 *
	 *   <Link ... query={{ show: true }} state={{ the: 'state' }} />
	 */
	var Link = _react2["default"].createClass({
	  displayName: 'Link',
	
	
	  contextTypes: {
	    router: _PropTypes.routerShape
	  },
	
	  propTypes: {
	    to: oneOfType([string, object]),
	    query: object,
	    hash: string,
	    state: object,
	    activeStyle: object,
	    activeClassName: string,
	    onlyActiveOnIndex: bool.isRequired,
	    onClick: func,
	    target: string
	  },
	
	  getDefaultProps: function getDefaultProps() {
	    return {
	      onlyActiveOnIndex: false,
	      style: {}
	    };
	  },
	  handleClick: function handleClick(event) {
	    if (this.props.onClick) this.props.onClick(event);
	
	    if (event.defaultPrevented) return;
	
	    !this.context.router ?  true ? (0, _invariant2["default"])(false, '<Link>s rendered outside of a router context cannot navigate.') : (0, _invariant2["default"])(false) : void 0;
	
	    if (isModifiedEvent(event) || !isLeftClickEvent(event)) return;
	
	    // If target prop is set (e.g. to "_blank"), let browser handle link.
	    /* istanbul ignore if: untestable with Karma */
	    if (this.props.target) return;
	
	    event.preventDefault();
	
	    var _props = this.props;
	    var to = _props.to;
	    var query = _props.query;
	    var hash = _props.hash;
	    var state = _props.state;
	
	    var location = createLocationDescriptor(to, { query: query, hash: hash, state: state });
	
	    this.context.router.push(location);
	  },
	  render: function render() {
	    var _props2 = this.props;
	    var to = _props2.to;
	    var query = _props2.query;
	    var hash = _props2.hash;
	    var state = _props2.state;
	    var activeClassName = _props2.activeClassName;
	    var activeStyle = _props2.activeStyle;
	    var onlyActiveOnIndex = _props2.onlyActiveOnIndex;
	
	    var props = _objectWithoutProperties(_props2, ['to', 'query', 'hash', 'state', 'activeClassName', 'activeStyle', 'onlyActiveOnIndex']);
	
	     true ? (0, _routerWarning2["default"])(!(query || hash || state), 'the `query`, `hash`, and `state` props on `<Link>` are deprecated, use `<Link to={{ pathname, query, hash, state }}/>. http://tiny.cc/router-isActivedeprecated') : void 0;
	
	    // Ignore if rendered outside the context of router, simplifies unit testing.
	    var router = this.context.router;
	
	
	    if (router) {
	      // If user does not specify a `to` prop, return an empty anchor tag.
	      if (to == null) {
	        return _react2["default"].createElement('a', props);
	      }
	
	      var location = createLocationDescriptor(to, { query: query, hash: hash, state: state });
	      props.href = router.createHref(location);
	
	      if (activeClassName || activeStyle != null && !isEmptyObject(activeStyle)) {
	        if (router.isActive(location, onlyActiveOnIndex)) {
	          if (activeClassName) {
	            if (props.className) {
	              props.className += ' ' + activeClassName;
	            } else {
	              props.className = activeClassName;
	            }
	          }
	
	          if (activeStyle) props.style = _extends({}, props.style, activeStyle);
	        }
	      }
	    }
	
	    return _react2["default"].createElement('a', _extends({}, props, { onClick: this.handleClick }));
	  }
	});
	
	exports["default"] = Link;
	module.exports = exports['default'];

/***/ },
/* 73 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	exports.__esModule = true;
	exports.router = exports.routes = exports.route = exports.components = exports.component = exports.location = exports.history = exports.falsy = exports.locationShape = exports.routerShape = undefined;
	
	var _react = __webpack_require__(1);
	
	var _deprecateObjectProperties = __webpack_require__(34);
	
	var _deprecateObjectProperties2 = _interopRequireDefault(_deprecateObjectProperties);
	
	var _InternalPropTypes = __webpack_require__(37);
	
	var InternalPropTypes = _interopRequireWildcard(_InternalPropTypes);
	
	var _routerWarning = __webpack_require__(25);
	
	var _routerWarning2 = _interopRequireDefault(_routerWarning);
	
	function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj["default"] = obj; return newObj; } }
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }
	
	var func = _react.PropTypes.func;
	var object = _react.PropTypes.object;
	var shape = _react.PropTypes.shape;
	var string = _react.PropTypes.string;
	var routerShape = exports.routerShape = shape({
	  push: func.isRequired,
	  replace: func.isRequired,
	  go: func.isRequired,
	  goBack: func.isRequired,
	  goForward: func.isRequired,
	  setRouteLeaveHook: func.isRequired,
	  isActive: func.isRequired
	});
	
	var locationShape = exports.locationShape = shape({
	  pathname: string.isRequired,
	  search: string.isRequired,
	  state: object,
	  action: string.isRequired,
	  key: string
	});
	
	// Deprecated stuff below:
	
	var falsy = exports.falsy = InternalPropTypes.falsy;
	var history = exports.history = InternalPropTypes.history;
	var location = exports.location = locationShape;
	var component = exports.component = InternalPropTypes.component;
	var components = exports.components = InternalPropTypes.components;
	var route = exports.route = InternalPropTypes.route;
	var routes = exports.routes = InternalPropTypes.routes;
	var router = exports.router = routerShape;
	
	if (true) {
	  (function () {
	    var deprecatePropType = function deprecatePropType(propType, message) {
	      return function () {
	         true ? (0, _routerWarning2["default"])(false, message) : void 0;
	        return propType.apply(undefined, arguments);
	      };
	    };
	
	    var deprecateInternalPropType = function deprecateInternalPropType(propType) {
	      return deprecatePropType(propType, 'This prop type is not intended for external use, and was previously exported by mistake. These internal prop types are deprecated for external use, and will be removed in a later version.');
	    };
	
	    var deprecateRenamedPropType = function deprecateRenamedPropType(propType, name) {
	      return deprecatePropType(propType, 'The `' + name + '` prop type is now exported as `' + name + 'Shape` to avoid name conflicts. This export is deprecated and will be removed in a later version.');
	    };
	
	    exports.falsy = falsy = deprecateInternalPropType(falsy);
	    exports.history = history = deprecateInternalPropType(history);
	    exports.component = component = deprecateInternalPropType(component);
	    exports.components = components = deprecateInternalPropType(components);
	    exports.route = route = deprecateInternalPropType(route);
	    exports.routes = routes = deprecateInternalPropType(routes);
	
	    exports.location = location = deprecateRenamedPropType(location, 'location');
	    exports.router = router = deprecateRenamedPropType(router, 'router');
	  })();
	}
	
	var defaultExport = {
	  falsy: falsy,
	  history: history,
	  location: location,
	  component: component,
	  components: components,
	  route: route,
	  // For some reason, routes was never here.
	  router: router
	};
	
	if (true) {
	  defaultExport = (0, _deprecateObjectProperties2["default"])(defaultExport, 'The default export from `react-router/lib/PropTypes` is deprecated. Please use the named exports instead.');
	}
	
	exports["default"] = defaultExport;

/***/ },
/* 74 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _weaCom = __webpack_require__(75);
	
	var TabPane = _antd.Tabs.TabPane;
	var FormItem = _antd.Form.Item;
	var MonthPicker = _antd.DatePicker.MonthPicker;
	//import Top from '../ComponentsV1/Top';
	
	
	function format(d, fmt) {
		//author: meizz 
		var o = {
			"M+": d.getMonth() + 1, //月份 
			"d+": d.getDate(), //日 
			"h+": d.getHours(), //小时 
			"m+": d.getMinutes(), //分 
			"s+": d.getSeconds(), //秒 
			"q+": Math.floor((d.getMonth() + 3) / 3), //季度 
			"S": d.getMilliseconds() //毫秒 
		};
		if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (d.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o) {
			if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}return fmt;
	}
	
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			return {
				datas: [],
				loading: false,
				date: ""
			};
		},
		getDatas: function getDatas(value) {
			var date = format(value, "yyyy-MM");
			var that = this;
			this.setState({
				date: date,
				loading: true
			});
			$.ajax({
				type: "POST",
				url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryDatasGet&date=" + date,
				success: function success(datas) {
					//console.log(datas);
					_antd.message.success("数据获取成功！");
					that.setState({
						datas: datas,
						loading: false
					});
				},
				error: function error(datas) {
					_antd.message.success("数据获取失败！");
					that.setState({
						loading: false
					});
				},
	
				dataType: "json"
			});
		},
		render: function render() {
			var that = this;
			return React.createElement(
				'div',
				{ style: { "padding-top": "10px", "padding-left": "15px", "padding-right": "15px" } },
				React.createElement(
					_weaCom.WeaTop,
					{ title: '\u5DE5\u8D44\u5355\u67E5\u8BE2' },
					React.createElement(MonthPicker, { defaultValue: '', onChange: this.getDatas })
				),
				this.state.datas.length > 0 && this.state.date != "" ? React.createElement(
					'div',
					{ style: { "padding-top": "8px", "text-align": "center" } },
					React.createElement(
						'h1',
						null,
						'\u5DE5\u8D44[',
						this.state.date,
						']'
					),
					React.createElement(
						_antd.Tabs,
						{ tabPosition: 'left' },
						this.state.datas.map(function (data) {
							return React.createElement(
								TabPane,
								{ tab: data.type, key: data.id },
								React.createElement(
									'div',
									null,
									that.getDetail(data.names, data.values)
								)
							);
						})
					)
				) : React.createElement(_antd.Alert, {
					message: '',
					description: this.state.date != "" ? "对不起，当前日期[" + this.state.date + "]暂无数据！" : "请选择日期！",
					type: 'info',
					showIcon: true })
			);
		},
		getDetail: function getDetail(names, values) {
			var nameArrTmp = names.split(",");
			var valueArrTmp = values.split(",");
			var nameArr = new Array();
			var valueArr = new Array();
			for (var i = 0; i < valueArrTmp.length; i++) {
				if (valueArrTmp[i] && parseFloat(valueArrTmp[i]) != 0) {
					valueArr.push(valueArrTmp[i]);
					nameArr.push(nameArrTmp[i]);
				}
			}
			//console.log(nameArr);
			var comArr1 = new Array();
			var comArr2 = new Array();
			var comArr3 = new Array();
			var comArr4 = new Array();
			for (var _i = 0; _i < nameArr.length; _i++) {
				var item = React.createElement(
					FormItem,
					{
						label: nameArr[_i] + "：",
						labelCol: { span: 12 },
						wrapperCol: { span: 10 } },
					React.createElement(_antd.Input, { defaultValue: valueArr[_i], disabled: true })
				);
				if (_i % 4 == 0) comArr1[comArr1.length] = item;
				if (_i % 4 == 1) comArr2[comArr2.length] = item;
				if (_i % 4 == 2) comArr3[comArr3.length] = item;
				if (_i % 4 == 3) comArr4[comArr4.length] = item;
			}
			//{comArr}
			return React.createElement(
				_antd.Form,
				{ horizontal: true },
				React.createElement(
					_antd.Row,
					{ style: { "margin-top": "10px" } },
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr1
					),
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr2
					),
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr3
					),
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr4
					)
				)
			);
		}
	});
	
	exports["default"] = Main;

/***/ },
/* 75 */
/***/ function(module, exports) {

	module.exports = weaCom;

/***/ },
/* 76 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _weaCom = __webpack_require__(75);
	
	var TabPane = _antd.Tabs.TabPane;
	var FormItem = _antd.Form.Item;
	var MonthPicker = _antd.DatePicker.MonthPicker;
	//import Top from '../ComponentsV1/Top';
	
	
	function format(d, fmt) {
		//author: meizz 
		var o = {
			"M+": d.getMonth() + 1, //月份 
			"d+": d.getDate(), //日 
			"h+": d.getHours(), //小时 
			"m+": d.getMinutes(), //分 
			"s+": d.getSeconds(), //秒 
			"q+": Math.floor((d.getMonth() + 3) / 3), //季度 
			"S": d.getMilliseconds() //毫秒 
		};
		if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (d.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o) {
			if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}return fmt;
	}
	
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			return {
				datas: [],
				loading: false,
				date: ""
			};
		},
		componentDidMount: function componentDidMount() {
			var ym = this.props.location.query.ym;
	
			ym && ym != "" && this.doGetData(ym);
		},
		getDatas: function getDatas(value) {
			var date = format(value, "yyyy-MM");
			this.doGetData(date);
		},
		doGetData: function doGetData(date) {
			var that = this;
			this.setState({
				date: date,
				loading: true
			});
			$.ajax({
				type: "POST",
				url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryDatasGet&date=" + date,
				success: function success(datas) {
					//console.log(datas);
					_antd.message.success("数据获取成功！");
					that.setState({
						datas: datas,
						loading: false
					});
				},
				error: function error(datas) {
					_antd.message.success("数据获取失败！");
					that.setState({
						loading: false
					});
				},
	
				dataType: "json"
			});
		},
		render: function render() {
			//console.log("this.props:",this.props);
			//console.log("this.props.datas:",this.props.datas);
			var ym = this.props.location.query.ym;
	
			var that = this;
			return React.createElement(
				'div',
				{ style: { "padding-top": "10px", "padding-left": "15px", "padding-right": "15px", overflow: "auto", "-webkit-overflow-scrolling": "touch" } },
				React.createElement(
					_weaCom.WeaTop,
					{ title: '\u5DE5\u8D44\u5355\u67E5\u8BE2' },
					React.createElement(MonthPicker, { defaultValue: ym, onChange: this.getDatas })
				),
				this.state.datas.length > 0 && this.state.date != "" ? React.createElement(
					'div',
					{ style: { "padding-top": "8px", "text-align": "center" } },
					React.createElement(
						'h1',
						null,
						'\u5DE5\u8D44[',
						this.state.date,
						']'
					),
					React.createElement(
						_antd.Tabs,
						{ tabPosition: 'top' },
						this.state.datas.map(function (data) {
							return React.createElement(
								TabPane,
								{ tab: data.type, key: data.id },
								React.createElement(
									'div',
									null,
									that.getMobileDetail(data.names, data.values)
								)
							);
						})
					)
				) : React.createElement(_antd.Alert, {
					message: '',
					description: this.state.date != "" ? "对不起，当前日期[" + this.state.date + "]暂无数据！" : "请选择日期！",
					type: 'info',
					showIcon: true })
			);
		},
		getMobileDetail: function getMobileDetail(names, values) {
			var nameArr = names.split(",");
			var valueArr = values.split(",");
			return React.createElement(
				'table',
				{ className: 'salary-table', width: '100%' },
				nameArr.map(function (name, index) {
					if (valueArr[index] && parseFloat(valueArr[index]) == 0) {
						return React.createElement('tr', null);
					}
					return React.createElement(
						'tr',
						null,
						React.createElement(
							'th',
							{ width: '50%' },
							name
						),
						React.createElement(
							'td',
							{ width: '50%' },
							valueArr[index]
						)
					);
				})
			);
		},
		getDetail: function getDetail(names, values) {
			var nameArr = names.split(",");
			var valueArr = values.split(",");
			//console.log(nameArr);
			var comArr1 = new Array();
			var comArr2 = new Array();
			var comArr3 = new Array();
			var comArr4 = new Array();
			for (var i = 0; i < nameArr.length; i++) {
				var item = React.createElement(
					FormItem,
					{
						label: nameArr[i] + "：",
						labelCol: { span: 12 },
						wrapperCol: { span: 10 } },
					React.createElement(_antd.Input, { defaultValue: valueArr[i], disabled: true })
				);
				if (i % 4 == 0) comArr1[comArr1.length] = item;
				if (i % 4 == 1) comArr2[comArr2.length] = item;
				if (i % 4 == 2) comArr3[comArr3.length] = item;
				if (i % 4 == 3) comArr4[comArr4.length] = item;
			}
			//{comArr}
			return React.createElement(
				_antd.Form,
				{ horizontal: true },
				React.createElement(
					_antd.Row,
					{ style: { "margin-top": "10px" } },
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr1
					),
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr2
					),
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr3
					),
					React.createElement(
						_antd.Col,
						{ span: '6' },
						comArr4
					)
				)
			);
		}
	});
	
	exports["default"] = Main;

/***/ },
/* 77 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _weaCom = __webpack_require__(75);
	
	var TabPane = _antd.Tabs.TabPane;
	var FormItem = _antd.Form.Item;
	var MonthPicker = _antd.DatePicker.MonthPicker;
	//import Top from '../ComponentsV1/Top';
	
	var Option = _antd.Select.Option;
	
	function format(d, fmt) {
		//author: meizz 
		var o = {
			"M+": d.getMonth() + 1, //月份 
			"d+": d.getDate(), //日 
			"h+": d.getHours(), //小时 
			"m+": d.getMinutes(), //分 
			"s+": d.getSeconds(), //秒 
			"q+": Math.floor((d.getMonth() + 3) / 3), //季度 
			"S": d.getMilliseconds() //毫秒 
		};
		if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (d.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o) {
			if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}return fmt;
	}
	
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			return {
				showUpload: false,
				loading: false,
				date: "",
				type: "",
				mainKey: "idCard",
				msgArr: null,
				datas: null,
				date1: ""
			};
		},
		getDatas: function getDatas(value) {
			var that = this;
			this.setState({
				loading: true
			});
			$.ajax({
				type: "POST",
				url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryDatasGet&isHr=0&date=" + value,
				success: function success(datas) {
					//console.log(datas);
					//console.log(datas.length);
					_antd.message.success("数据获取成功！");
					that.setState({
						datas: datas,
						loading: false,
						date1: value
					});
				},
				error: function error(datas) {
					_antd.message.success("数据获取失败！");
					that.setState({
						loading: false
					});
				},
	
				dataType: "json"
			});
		},
		handleChange: function handleChange(info) {
			//console.log("info:");
			//console.log(info.file.response);
			//console.log("msg");
			this.setState({
				msgArr: info.file.response,
				loading: false
			});
		},
		setValue: function setValue(name, e) {
			if (name == "date") {
				var date = format(e, "yyyy-MM");
				var type = this.state.type;
				var showUpload = date != "" && type != "" && date != null && type != null;
				this.setState({
					date: date,
					showUpload: showUpload
				});
				//console.log("name:"+name);
				//console.log("value:"+format(e,"yyyy-MM"));
			}
			if (name == "type") {
				var _date = this.state.date;
				var _type = e.target.value;
				var _showUpload = _date != "" && _type != "" && _date != null && _type != null;
				this.setState({
					type: _type,
					showUpload: _showUpload
				});
				//console.log("name:"+name);
				//console.log("value:"+e.target.value);
			}
			if (name == "mainKey") {
				//console.log("select value:"+e);
				this.setState({
					mainKey: e
				});
			}
			if (name == "date1") {
				var _date2 = format(e, "yyyy-MM");
				this.getDatas(_date2);
				//console.log("name:"+name);
				//console.log("value:"+format(e,"yyyy-MM"));
			}
			//console.log("value:"+e.target.value);
		},
		render: function render() {
			//console.log("action:/cloudstore/app/NO0000005/ControlServlet.jsp?action=Action_DoSalaryImport&date="+this.state.date+"&type="+this.state.type);
			//console.log("loading:"+this.state.loading);
			return React.createElement(
				'div',
				{ style: { "padding-top": "10px", "padding-left": "15px", "padding-right": "15px" } },
				React.createElement(_weaCom.WeaTop, { title: '\u5DE5\u8D44\u5BFC\u5165' }),
				React.createElement(
					'div',
					{ style: { "padding-top": "8px" } },
					React.createElement(
						_antd.Tabs,
						{ tabPosition: 'left' },
						React.createElement(
							TabPane,
							{ tab: '\u5BFC\u5165', key: '0' },
							this.impRender()
						),
						React.createElement(
							TabPane,
							{ tab: '\u7EF4\u62A4', key: '1' },
							this.dataRender()
						)
					)
				)
			);
		},
		impRender: function impRender() {
			var that = this;
			var fileProps = {
				name: "excelFile",
				action: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryImport",
				data: this.state,
				onChange: this.handleChange,
				beforeUpload: function beforeUpload(file) {
					//console.log(file.type);
					/*
	    const isJPG = file.type === 'image/jpeg';
	    if (!isJPG) {
	    	message.error('只能上传 JPG 文件哦！');
	    }
	    return isJPG;
	    */
					that.setState({
						loading: true
					});
					return true;
				}
			};
			return React.createElement(
				_antd.Form,
				{ horizontal: true },
				React.createElement(
					_antd.Row,
					{ style: { "margin-top": "10px" } },
					React.createElement(
						_antd.Col,
						{ span: '8' },
						React.createElement(
							FormItem,
							{
								label: '\u65E5\u671F\uFF1A',
								labelCol: { span: 6 },
								wrapperCol: { span: 16 },
								required: true },
							React.createElement(MonthPicker, { format: 'yyyy-MM', defaultValue: '', onChange: this.setValue.bind(this, 'date') })
						)
					)
				),
				React.createElement(
					_antd.Row,
					null,
					React.createElement(
						_antd.Col,
						{ span: '8' },
						React.createElement(
							FormItem,
							{
								label: '\u5DE5\u8D44\u7C7B\u578B\uFF1A',
								labelCol: { span: 6 },
								wrapperCol: { span: 16 },
								required: true },
							React.createElement(_antd.Input, { onChange: this.setValue.bind(this, 'type') })
						)
					)
				),
				React.createElement(
					_antd.Row,
					null,
					React.createElement(
						_antd.Col,
						{ span: '8', style: { "text-align": "left" } },
						React.createElement(
							FormItem,
							{
								label: '\u5BFC\u5165\u4E3B\u952E\uFF1A',
								labelCol: { span: 6 },
								wrapperCol: { span: 16 },
								required: true },
							React.createElement(
								_antd.Select,
								{ defaultValue: '\u8EAB\u4EFD\u8BC1', style: { width: 120 }, onChange: this.setValue.bind(this, 'mainKey') },
								React.createElement(
									Option,
									{ value: 'idCard' },
									'\u8EAB\u4EFD\u8BC1'
								),
								React.createElement(
									Option,
									{ value: 'workCode' },
									'\u5DE5\u53F7'
								)
							)
						)
					)
				),
				React.createElement(
					_antd.Row,
					null,
					React.createElement(
						_antd.Col,
						{ span: '8', style: { "text-align": "left" } },
						React.createElement(
							FormItem,
							{
								label: '\u64CD\u4F5C\uFF1A',
								labelCol: { span: 6 },
								wrapperCol: { span: 16 } },
							this.state.showUpload ? React.createElement(
								'div',
								null,
								React.createElement(
									_antd.Upload,
									fileProps,
									React.createElement(
										_antd.Button,
										{ type: 'ghost' },
										React.createElement(_antd.Icon, { type: 'upload' }),
										' \u9009\u62E9\u6587\u4EF6\u81EA\u52A8\u4E0A\u4F20'
									)
								)
							) : React.createElement(
								'p',
								{ className: 'ant-form-text' },
								'\u8BF7\u5148\u586B\u5199\u3010\u65E5\u671F\u3011\u548C\u3010\u5DE5\u8D44\u7C7B\u578B\u3011'
							)
						)
					)
				),
				React.createElement(
					_antd.Row,
					null,
					React.createElement(
						_antd.Col,
						{ span: '24', style: { "text-align": "left" } },
						React.createElement(
							FormItem,
							{
								label: '\u8BF4\u660E\uFF1A',
								labelCol: { span: 2 },
								wrapperCol: { span: 20 } },
							React.createElement(
								'div',
								null,
								React.createElement(_antd.Alert, {
									message: '',
									description: React.createElement(
										'div',
										null,
										React.createElement(
											'p',
											null,
											'\uFF081\uFF09\u5BFC\u5165\u540E\u8BF7\u5230\u7EF4\u62A4\u754C\u9762\u786E\u8BA4\uFF0C\u786E\u8BA4\u540E\u624D\u5DE5\u8D44\u6761\u4F1A\u53D1\u9001\u5230\u7528\u6237\u624B\u4E2D\uFF1B'
										),
										React.createElement(
											'p',
											null,
											'\uFF082\uFF09\u7CFB\u7EDF\u4E2D\u5FC5\u987B\u7EF4\u62A4\u4E3B\u952E\u76F8\u5173\u5B57\u6BB5\uFF0C\u5BFC\u5165\u65B9\u5F0F\u4E3A\u8986\u76D6\u5F0F\u5BFC\u5165\uFF1B'
										),
										React.createElement(
											'p',
											null,
											'\uFF083\uFF09\u9664\u4E86\u4E3B\u952E\u5217\u4EE5\u5916\u7684\u5217\u53EF\u4EE5\u81EA\u7531\u5B9A\u4E49\uFF0C\u6839\u636E\u4E0D\u540C\u3010\u5DE5\u8D44\u7C7B\u578B\u3011\u548C\u3010\u65E5\u671F\u3011\u53EF\u4EE5\u6709\u4E0D\u4E00\u6837\u7684\u5217\uFF1B'
										),
										React.createElement(
											'p',
											null,
											'\uFF084\uFF09\u7CFB\u7EDF\u4F1A\u6839\u636E\u3010\u5DE5\u8D44\u7C7B\u578B\u3011\u751F\u6210\u5DE5\u8D44\u5355\uFF0C\u5982\u679C\u6709\u4E0D\u540C\u7684\u3010\u5DE5\u8D44\u7C7B\u578B\u3011\u5C31\u4F1A\u751F\u6210\u4E0D\u540C\u7684\u5DE5\u8D44\u5355\uFF1B'
										),
										React.createElement(
											'p',
											null,
											'\uFF085\uFF09\u5982\u679C\u6709\u6587\u672C\u5B57\u6BB5\uFF0C\u6BD4\u5982\u5907\u6CE8\u5B57\u6BB5\uFF0C\u8BF7\u5728excel\u5217\u6807\u9898\u4E0A\u52A0\u4E0A\u201C[string]\u201D\u5B57\u7B26\u3002'
										),
										React.createElement(
											'p',
											null,
											'\uFF086\uFF09\u53C2\u8003\u6A21\u677F\uFF1A',
											React.createElement(
												'a',
												{ href: '/cloudstore/app/no0000005/demo1.xls' },
												'\u5BFC\u5165\u6A21\u677F1'
											),
											' ',
											React.createElement(
												'a',
												{ href: '/cloudstore/app/no0000005/demo1.xls' },
												'\u5BFC\u5165\u6A21\u677F2'
											)
										)
									),
									type: 'info',
									showIcon: true })
							)
						)
					)
				),
				this.state.msgArr ? React.createElement(
					_antd.Row,
					null,
					React.createElement(
						_antd.Col,
						{ span: '24', style: { "text-align": "left" } },
						React.createElement(
							FormItem,
							{
								label: '\u63D0\u793A\uFF1A',
								labelCol: { span: 2 },
								wrapperCol: { span: 20 } },
							React.createElement(
								'div',
								null,
								this.state.msgArr.map(function (msg) {
									return React.createElement(_antd.Alert, {
										message: '',
										description: msg.value,
										type: msg.type,
										showIcon: true });
								})
							)
						)
					)
				) : ""
			);
		},
		dataDel: function dataDel(setId) {
			var that = this;
			$.ajax({
				type: "POST",
				url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryDel&setId=" + setId,
				success: function success(datas) {
					_antd.message.success("删除成功！");
					that.getDatas(that.state.date1);
				},
				error: function error(datas) {
					_antd.message.error("删除失败！");
				},
	
				dataType: "json"
			});
		},
		dataSend: function dataSend(setId) {
			var that = this;
			$.ajax({
				type: "POST",
				url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalarySend&setId=" + setId,
				success: function success(datas) {
					_antd.message.success("发送/收回工资条成功！");
					that.getDatas(that.state.date1);
				},
				error: function error(datas) {
					_antd.message.error("删除失败！");
				},
	
				dataType: "json"
			});
		},
		dataExcelOut: function dataExcelOut(setId, date) {
			var that = this;
			this.setState({
				loading: true
			});
			$.ajax({
				type: "POST",
				url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryOutput",
				data: {
					isHr: 0,
					date: date,
					setId: setId
				},
				success: function success(datas) {
					//console.log("datas:",datas);
					datas = datas.replace(/(^\s*)|(\s*$)/g, '');
					//console.log(datas.length);
					if (datas != "1") {
						_antd.message.success("EXCEL导出成功！");
						//console.log("datas:",datas);
						window.open(datas);
					} else {
						_antd.message.success("EXCEL导出失败！");
					}
					that.setState({
						loading: false
					});
				},
				error: function error(datas) {
					_antd.message.success("EXCEL导出失败！");
					that.setState({
						loading: false
					});
				},
	
				dataType: "html"
			});
		},
		dataMsgSend: function dataMsgSend(setId) {},
		dataRender: function dataRender() {
			var datas = this.state.datas == null ? [] : this.state.datas;
			//console.log("datas:",datas);
			var tableArr = [];
			var setIdArr = [];
			var dateArr = [];
			var tmpSetId = "";
			for (var i = 0; i < datas.length; i++) {
				var data = datas[i];
				if (data.setId != tmpSetId) {
					setIdArr[setIdArr.length] = data.setId;
					dateArr[dateArr.length] = data.date;
					tmpSetId = data.setId;
				}
			}
			for (var j = 0; j < setIdArr.length; j++) {
				var setId = setIdArr[j];
				var tbWidth = 130;
				var columns = [{
					title: "人员",
					dataIndex: "userName",
					key: "userName",
					width: 50,
					fixedLeft: true
				}, {
					title: "工资类型",
					dataIndex: "type",
					key: "type",
					width: 80,
					fixedLeft: true
				}];
				var find = false;
				for (var _i = 0; _i < datas.length && !find; _i++) {
					var _data = datas[_i];
					if (_data.setId == setId) {
						var nameArr = _data.names.split(",");
						for (var m = 0; m < nameArr.length; m++) {
							columns[columns.length] = {
								title: nameArr[m],
								dataIndex: "v" + m,
								key: "v" + m,
								width: 60
							};
							tbWidth += 60;
						}
						find = true;
					}
				}
				var dataSource = [];
				var isSend = "1";
				for (var _i2 = 0; _i2 < datas.length; _i2++) {
					var _data2 = datas[_i2];
					if (_data2.setId == setId) {
						var valueArr = _data2.values.split(",");
						for (var _m = 0; _m < valueArr.length; _m++) {
							_data2["v" + _m] = valueArr[_m];
						}
						dataSource.push(_data2);
						if (_data2.isSend == "-1") isSend = "-1";
					}
				}
				var pagination = {
					total: dataSource.length,
					showSizeChanger: true
				};
				tableArr[tableArr.length] = React.createElement(
					'div',
					{ style: { "text-align": "right", "padding-bottom": "10px" } },
					React.createElement(
						_antd.Button,
						{ onClick: this.dataSend.bind(this, setId) },
						isSend == "1" ? "发送工资条" : "收回工资条"
					),
					'\xA0\xA0\xA0',
					React.createElement(
						_antd.Button,
						{ onClick: this.dataExcelOut.bind(this, setId, dateArr[j]) },
						'\u5BFC\u51FA\u5DE5\u8D44\u6761'
					),
					'\xA0\xA0\xA0',
					React.createElement(
						_antd.Button,
						{ onClick: this.dataDel.bind(this, setId) },
						'\u5220\u9664\u5DE5\u8D44\u6761'
					)
				);
				tableArr[tableArr.length] = React.createElement(_antd.Table, { rowKey: 'id', dataSource: dataSource, columns: columns, pagination: pagination, bordered: true, scroll: { x: tbWidth } });
			}
			return React.createElement(
				_antd.Form,
				{ horizontal: true },
				React.createElement(
					_antd.Row,
					{ style: { "margin-top": "10px" } },
					React.createElement(
						_antd.Col,
						{ span: '8' },
						React.createElement(
							FormItem,
							{
								label: '\u65E5\u671F\uFF1A',
								labelCol: { span: 6 },
								wrapperCol: { span: 16 } },
							React.createElement(MonthPicker, { format: 'yyyy-MM', defaultValue: '', onChange: this.setValue.bind(this, 'date1') })
						)
					)
				),
				React.createElement(
					_antd.Row,
					null,
					React.createElement(
						_antd.Col,
						null,
						tableArr.length > 0 ? tableArr : React.createElement(_antd.Alert, { type: 'info', description: '\u6682\u65E0\u6570\u636E', showIcon: true })
					)
				)
			);
		}
	});
	
	exports["default"] = Main;
	
	//ReactDOM.render(<Main />,document.getElementById("container"));

/***/ },
/* 78 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _antd = __webpack_require__(70);
	
	var _weaCom = __webpack_require__(75);
	
	var FormItem = _antd.Form.Item;
	var MonthPicker = _antd.DatePicker.MonthPicker;
	var Option = _antd.Select.Option;
	//import Top from '../ComponentsV1/Top';
	//import WeaInput4Hrm from '../ComponentsV1/Form/WeaInput4Hrm';
	
	var createForm = _antd.Form.create;
	
	function format(d, fmt) {
		//author: meizz 
		var o = {
			"M+": d.getMonth() + 1, //月份 
			"d+": d.getDate(), //日 
			"h+": d.getHours(), //小时 
			"m+": d.getMinutes(), //分 
			"s+": d.getSeconds(), //秒 
			"q+": Math.floor((d.getMonth() + 3) / 3), //季度 
			"S": d.getMilliseconds() //毫秒 
		};
		if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (d.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o) {
			if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}return fmt;
	}
	
	var that = null;
	
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			that = this;
			return {
				canGetMsgList: true,
				salaryTypeList: [],
				salaryMsgList: [],
				loadingMsgList: false,
				loadingMsgSend: false
			};
		},
		render: function render() {
			var _props$form = this.props.form,
			    getFieldProps = _props$form.getFieldProps,
			    getFieldError = _props$form.getFieldError,
			    isFieldValidating = _props$form.isFieldValidating;
	
			var columns = [{
				title: '姓名',
				dataIndex: 'userName',
				key: 'userName'
			}, {
				title: '部门',
				dataIndex: 'depName',
				key: 'depName'
			}, {
				title: '公司',
				dataIndex: 'comName',
				key: 'comName'
			}, {
				title: '导入者',
				dataIndex: 'hrName',
				key: 'hrName',
				render: function render(text, row, index) {
					if ("" == text) {
						return React.createElement(
							'div',
							null,
							'\u65E0'
						);
					} else {
						return React.createElement(
							'div',
							null,
							text
						);
					}
				}
			}, {
				title: '短信内容',
				dataIndex: 'msgContext',
				key: 'msgContext'
			}, {
				title: '工资条',
				dataIndex: 'isSend',
				key: 'isSend',
				render: function render(text, row, index) {
					if ("-1" == text) {
						return React.createElement(
							'div',
							null,
							'\u5DF2\u53D1\u9001'
						);
					} else {
						return React.createElement(
							'div',
							null,
							'\u672A\u53D1\u9001'
						);
					}
				}
			}, {
				title: '短信',
				dataIndex: 'isMsgSend',
				key: 'isMsgSend',
				render: function render(text, row, index) {
					//console.log("isMsgSend:"+text);
					if ("-1" == text) {
						return React.createElement(
							'div',
							null,
							'\u5DF2\u53D1\u9001'
						);
					} else if ("-2" == text) {
						return React.createElement(
							'div',
							null,
							'\u5931\u8D25\uFF1A\u65E0\u624B\u673A\u53F7'
						);
					} else if ("-3" == text) {
						return React.createElement(
							'div',
							null,
							'\u5931\u8D25\uFF1A\u53D1\u9001\u5F02\u5E38'
						);
					} else {
						return React.createElement(
							'div',
							null,
							'\u672A\u53D1\u9001'
						);
					}
				},
	
				filters: [{
					text: '已发送',
					value: '-1'
				}, {
					text: '失败：无手机号',
					value: '-2'
				}, {
					text: '失败：发送异常',
					value: '-3'
				}, {
					text: '未发送',
					value: '1'
				}],
				filterMultiple: false,
				onFilter: function onFilter(value, record) {
					return record.isMsgSend === value;
					//return record.address.indexOf(value) === 0;
				}
			}];
			var pagination = {
				total: this.state.salaryMsgList.length,
				showSizeChanger: true
			};
			return React.createElement(
				'div',
				{ style: { "padding-top": "10px", "padding-left": "15px", "padding-right": "15px" } },
				React.createElement(_weaCom.WeaTop, { title: '\u5DE5\u8D44\u5355\u77ED\u4FE1' }),
				React.createElement(
					_antd.Form,
					{ horizontal: true },
					React.createElement(
						_antd.Row,
						null,
						React.createElement(
							_antd.Col,
							{ span: '8' },
							React.createElement(
								_antd.Row,
								{ style: { "margin-top": "10px" } },
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u65E5\u671F\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 },
											required: true },
										React.createElement(MonthPicker, _extends({ format: 'yyyy-MM', defaultValue: '' }, getFieldProps('date')))
									)
								)
							),
							React.createElement(
								_antd.Row,
								null,
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u5BFC\u5165\u4E3B\u952E\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 },
											required: true },
										React.createElement(
											_antd.Select,
											_extends({ defaultValue: '\u8EAB\u4EFD\u8BC1', style: { width: 120 }
											}, getFieldProps('mainKey', {
												initialValue: "idCard",
												valuePropName: "value"
											})),
											React.createElement(
												Option,
												{ value: 'idCard' },
												'\u8EAB\u4EFD\u8BC1'
											),
											React.createElement(
												Option,
												{ value: 'workCode' },
												'\u5DE5\u53F7'
											)
										)
									)
								)
							),
							React.createElement(
								_antd.Row,
								null,
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u5DE5\u8D44\u7C7B\u578B\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 },
											required: true },
										React.createElement(
											_antd.Select,
											getFieldProps('type'),
											this.state.salaryTypeList.map(function (data) {
												return React.createElement(
													Option,
													{ value: data },
													data
												);
											})
										)
									)
								)
							),
							React.createElement(
								_antd.Row,
								null,
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u4EBA\u5458\u9009\u62E9\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 },
											required: true },
										React.createElement(_weaCom.WeaInput4Hrm, _extends({ name: 'createrIds', isMult: true }, getFieldProps('userIds')))
									)
								)
							),
							React.createElement(
								_antd.Row,
								null,
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u77ED\u4FE1\u6A21\u677F\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 },
											required: true },
										React.createElement(_antd.Input, _extends({ type: 'textarea', rows: '3'
										}, getFieldProps('context', {
											initialValue: "[name]您[date]的工资详细为：应发合计[应发合计]元，实发合计[实发合计]元。"
										}), {
											defaultValue: '[name]\u60A8[date]\u7684\u5DE5\u8D44\u8BE6\u7EC6\u4E3A\uFF1A\u5E94\u53D1\u5408\u8BA1[\u5E94\u53D1\u5408\u8BA1]\u5143\uFF0C\u5B9E\u53D1\u5408\u8BA1[\u5B9E\u53D1\u5408\u8BA1]\u5143\u3002' }))
									)
								)
							),
							React.createElement(
								_antd.Row,
								null,
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u64CD\u4F5C\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 } },
										React.createElement(
											_antd.Button,
											{ onClick: this.getMsgList, disabled: this.state.canGetMsgList || this.state.loadingMsgSend, loading: this.state.loadingMsgList },
											'\u751F\u6210\u77ED\u4FE1'
										),
										'\xA0\xA0\xA0',
										React.createElement(
											_antd.Button,
											{ onClick: this.sendMsg, disabled: this.state.loadingMsgList && this.state.salaryMsgList.length == 0 || this.state.loadingMsgList, loading: this.state.loadingMsgSend },
											'\u53D1\u9001\u77ED\u4FE1'
										)
									)
								)
							),
							React.createElement(
								_antd.Row,
								null,
								React.createElement(
									_antd.Col,
									null,
									React.createElement(
										FormItem,
										{
											label: '\u8BF4\u660E\uFF1A',
											labelCol: { span: 6 },
											wrapperCol: { span: 16 } },
										React.createElement(_antd.Alert, {
											message: '',
											description: React.createElement(
												'div',
												null,
												React.createElement(
													'p',
													null,
													'\uFF081\uFF09[name]\u7B49\u4E8E\u59D3\u540D;'
												),
												React.createElement(
													'p',
													null,
													'\uFF082\uFF09[date]\u7B49\u4E8E\u5E74-\u6708;'
												),
												React.createElement(
													'p',
													null,
													'\uFF083\uFF09[\u5E94\u53D1\u5408\u8BA1]\u4F1A\u76F4\u63A5\u53D6\u76F8\u5E94\u5DE5\u8D44\u5217'
												)
											),
											type: 'info' })
									)
								)
							)
						),
						React.createElement(
							_antd.Col,
							{ span: '16', style: { "paddingTop": "5px", "paddingLeft": "10px" } },
							React.createElement(_antd.Table, { dataSource: this.state.salaryMsgList, columns: columns, pagination: pagination, loading: this.state.loadingMsgList || this.state.loadingMsgSend })
						)
					)
				)
			);
		},
		sendMsg: function sendMsg(e) {
			e.preventDefault();
			var that = this;
			this.props.form.validateFields(function (errors, values) {
				if (!!errors) {
					console.log('Errors in form!!!');
					return;
				}
				//console.log('Submit!!!');
				//values.date = format(values.date,"yyyy-MM");
				//console.log(values);
				var params = values;
				var paramsData = "";
				for (var p in params) {
					//console.log(typeof(params[p]));
					//console.log(params[p]);
					var type = _typeof(params[p]);
					if (type == "string") {
						paramsData += p + "=" + (typeof params[p] == "undefined" ? "" : params[p]) + "&";
					}
				}
				//console.log("paramsData:"+paramsData);
				that.setState({
					loadingMsgSend: true
				});
				setTimeout(function () {
					$.ajax({
						type: "POST",
						url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryMsgSend",
						data: paramsData,
						success: function success(datas) {
							console.log(datas);
							that.setState({
								salaryMsgList: datas,
								loadingMsgSend: false
							});
						},
						error: function error(datas) {
							that.setState({
								salaryMsgList: [],
								loadingMsgSend: false
							});
						},
	
						dataType: "json"
					});
				}, 500);
			});
		},
		getMsgList: function getMsgList(e) {
			e.preventDefault();
			var that = this;
			this.props.form.validateFields(function (errors, values) {
				if (!!errors) {
					console.log('Errors in form!!!');
					return;
				}
				//console.log('Submit!!!');
				//values.date = format(values.date,"yyyy-MM");
				//console.log(values);
				var params = values;
				var paramsData = "";
				for (var p in params) {
					//console.log(typeof(params[p]));
					//console.log(params[p]);
					var type = _typeof(params[p]);
					if (type == "string") {
						paramsData += p + "=" + (typeof params[p] == "undefined" ? "" : params[p]) + "&";
					}
				}
				//console.log("paramsData:"+paramsData);
				that.setState({
					loadingMsgList: true
				});
				setTimeout(function () {
					$.ajax({
						type: "POST",
						url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryMsgDatasGet",
						data: paramsData,
						success: function success(datas) {
							that.setState({
								salaryMsgList: datas,
								loadingMsgList: false
							});
						},
						error: function error(datas) {
							that.setState({
								salaryMsgList: [],
								loadingMsgList: false
							});
						},
	
						dataType: "json"
					});
				}, 500);
			});
		}
	});
	
	var options = {
		onFieldsChange: function onFieldsChange(props, fields) {
			//console.log(props);
			if (fields.date) fields.date.value = format(fields.date.value, "yyyy-MM");
			that.props.form.validateFields(function (errors, values) {
				if (!!errors) {
					console.log('Errors in form!!!');
					return;
				}
				//console.log(values);
				var date = typeof values.date == "undefined" ? "" : values.date;
				var mainKey = typeof values.mainKey == "undefined" ? "" : values.mainKey;
				var type = typeof values.type == "undefined" ? "" : values.type;
				var userIds = typeof values.userIds == "undefined" ? "" : values.userIds;
				//console.log("date:"+date+" mainKey:"+mainKey);
				//console.log("fields.date:"+fields.date+" fields.mainKey:"+fields.mainKey);
				if (fields.date || fields.mainKey) {
					$.ajax({
						type: "POST",
						url: "/cloudstore/app/no0000005/ControlServlet.jsp?action=Action_DoSalaryTypesGet&date=" + date + "&mainKey=" + mainKey,
						success: function success(datas) {
							//console.log(datas);
							//console.log(that.props.form);
							that.props.form.setFieldsValue({ type: "" });
							that.setState({
								salaryTypeList: datas
							});
						},
						error: function error(datas) {
							that.setState({
								salaryTypeList: []
							});
							that.props.form.setFieldsValue({ type: "" });
						},
	
						dataType: "json"
					});
				}
				if (date != "" && mainKey != "" && userIds != "" && type != "") {
					that.setState({
						canGetMsgList: false
					});
				} else {
					that.setState({
						canGetMsgList: true
					});
				}
			});
		}
	};
	
	Main = createForm(options)(Main);
	
	exports["default"] = Main;
	
	//ReactDOM.render(<Main />,document.getElementById("container"));

/***/ },
/* 79 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _antd = __webpack_require__(70);
	
	var _weaCom = __webpack_require__(75);
	
	var _ecCom = __webpack_require__(80);
	
	var FormItem = _antd.Form.Item;
	var MonthPicker = _antd.DatePicker.MonthPicker;
	var Option = _antd.Select.Option;
	var createForm = _antd.Form.create;
	var RadioGroup = _antd.Radio.Group;
	
	function format(d, fmt) {
		//author: meizz 
		var o = {
			"M+": d.getMonth() + 1, //月份 
			"d+": d.getDate(), //日 
			"h+": d.getHours(), //小时 
			"m+": d.getMinutes(), //分 
			"s+": d.getSeconds(), //秒 
			"q+": Math.floor((d.getMonth() + 3) / 3), //季度 
			"S": d.getMilliseconds() //毫秒 
		};
		if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (d.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o) {
			if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}return fmt;
	}
	function newArray(start, end) {
		var result = [];
		for (var i = start; i < end; i++) {
			result.push(i);
		}
		return result;
	}
	var that = null;
	var uuid = 2;
	var syscurrenttime = new Date();
	var syscurrenttimenetday = new Date(syscurrenttime.getTime() + 1 * 24 * 60 * 60 * 1000);
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			window.publishObj = this;
			that = this;
			return {
				showMax: false,
				themeimageid: '',
				submitsucess: '0'
			};
		},
		handleSubmit: function handleSubmit(e) {
			var _this = this;
			e.preventDefault();
			if (this.state.submitsucess == "1") return;
			this.props.form.validateFields(function (errors, values) {
				var _votetheme = jQuery.trim(values.votetheme);
				if (!_votetheme) {
					_antd.message.warning('请填写投票主题');
					return;
				}
				var optionHaveContentCount = 0;
				var _keys = values.keys;
				if (_keys && _keys.length > 0) {
					for (var i = 0; i < _keys.length; i++) {
						var _voteoption = "voteoption" + _keys[i];
						var optionvalue = jQuery.trim(values[_voteoption]);
						if (optionvalue) {
							optionHaveContentCount++;
						}
					}
				}
				if (optionHaveContentCount < 2) {
					_antd.message.warning('请至少填写2个选项');
					return;
				}
				var submitdate = new Date();
				var voteendtimestring = format(values.enddate, 'yyyy-MM-dd') + " " + format(values.endtime, 'hh:mm');
				var voteendtime = new Date(voteendtimestring);
	
				if (voteendtime.getTime() < submitdate.getTime()) {
					_antd.message.warning('截止时间不能小于当前系统时间');
					return;
				}
				var voteremind = values.voteremind;
				var timeinterval = voteendtime.getTime() - submitdate.getTime();
				var warningmessge = "投票截止时间与当前时间的间隔小于";
				var timeflag = true;
				if (voteremind == "1") {
					//提前30分钟	      	
					timeflag = timeinterval / (1000 * 60) > 30 ? true : false;
					if (!timeflag) {
						warningmessge += "30分钟";
					}
				} else if (voteremind == "2") {
					//
					timeflag = timeinterval / (1000 * 60 * 60) > 12 ? true : false;
					if (!timeflag) {
						warningmessge += "12小时";
					}
				} else if (voteremind == "3") {
					timeflag = timeinterval / (1000 * 60 * 60) > 24 ? true : false;
					if (!timeflag) {
						warningmessge += "24小时";
					}
				}
				if (!timeflag) {
					_antd.message.warning(warningmessge);
					return;
				}
				_this.state.submitsucess = "1";
				_ecCom.WeaTools.callApi('/voting/groupchatvote/SaveVoting.jsp?groupid=' + window.__groupid, 'POST', values).then(function (data) {
					//1.关掉发布的框
					//2.发消息；
					//3.群列表追加新发布的投票
					//4.创建定时任务
					var votingid = data.vote.votingid;
					var votetheme = data.vote.votetheme;
					var endtime = data.vote.enddate + " " + data.vote.endtime;
					var themeimageid = data.vote.themeimageid;
					var voteremind = data.vote.voteremind;
					//let themeimageurl="/voting/groupchatvote/images/themedefaultimage.png";
					//if(themeimageid){
					//themeimageurl="/weaver/weaver.file.FileDownload?fileid="+themeimageid;
					//}
					var saveflag = data.vote.saveflag;
					if ("sucess" == saveflag) {
						_antd.message.success("投票发布成功");
						if (parent.docUtil) {
							//emessage客户端
							parent.docUtil.voteMessage(votingid, votetheme, window.__groupid, endtime, themeimageid);
						} else {
							//PC网页
							top.getDialog(window).currentWindow.parent.docUtil.voteMessage(votingid, votetheme, window.__groupid, endtime, themeimageid);
						}
						setTimeout(function () {
							top.getDialog(window).currentWindow.refreshVoteList();
							top.getDialog(window).close();
						}, 500);
					} else {
						_this.state.submitsucess = "0";
					}
				});
			});
		},
		handleCancel: function handleCancel(e) {
			top.getDialog(window).close();
		},
		onRadioChange: function onRadioChange(e) {
			this.setState({ showMax: 1 == e.target.value });
		},
		addVoteOption: function addVoteOption() {
			uuid++;
			var form = this.props.form;
	
			var keys = form.getFieldValue('keys');
			keys = keys.concat(uuid);
			form.setFieldsValue({
				keys: keys
			});
			jQuery('#scrollcontainer').perfectScrollbar();
			setTimeout(function () {
				jQuery('#scrollcontainer').perfectScrollbar('update');
			}, 500);
		},
		removeVoteOption: function removeVoteOption(k) {
			var form = this.props.form;
	
			var keys = form.getFieldValue('keys');
			keys = keys.filter(function (key) {
				return key !== k;
			});
			form.setFieldsValue({
				keys: keys
			});
			jQuery('#scrollcontainer').perfectScrollbar();
		},
		render: function render() {
			var _this2 = this;
	
			var _props$form = this.props.form,
			    getFieldProps = _props$form.getFieldProps,
			    getFieldValue = _props$form.getFieldValue,
			    getFieldError = _props$form.getFieldError,
			    isFieldValidating = _props$form.isFieldValidating;
			var _state = this.state,
			    showMax = _state.showMax,
			    themeimageid = _state.themeimageid;
	
			var formItemLayout = {
				labelCol: { span: 6 },
				wrapperCol: { span: 16 }
			};
			getFieldProps('keys', {
				initialValue: [0, 1, 2]
			});
			var formItems = getFieldValue('keys').map(function (k) {
				return React.createElement(
					FormItem,
					{ key: k },
					React.createElement(_antd.Input, _extends({}, getFieldProps('voteoption' + k, {
						// rules: [{
						//   min: 1, max:100,message: '投票选项内容为1到100个字符之间',required: true, whitespace: true
						// }],
					}), { style: { width: '95%', marginRight: 8 }, placeholder: '\u9009\u9879' + (k + 1), maxLength: 100
					})),
					k > 1 && React.createElement(_antd.Icon, { type: 'cross', onClick: function onClick() {
							return _this2.removeVoteOption(k);
						}, style: { 'cursor': 'pointer' } })
				);
			});
	
			var disabledDate = function disabledDate(current) {
				return current.getTime() < syscurrenttime.getTime();
			};
			var voteThemeProps = getFieldProps('votetheme', {
				rules: [{
					//required: true, min: 1, max:200,message: '投票主题内容为1到200个字符之间',whitespace: true
				}]
			});
	
			var voteModelProps = getFieldProps('choosemodel', {
				initialValue: 0,
				onChange: this.onRadioChange.bind(this)
			});
			var uploadThemeImageprops = {
				action: '/voting/groupchatvote/upload/UploadThemeImg.jsp',
				listType: 'picture-card',
				accept: '.jpg,.jpeg,.png',
				onChange: function onChange(file) {
					if (file.file.response) {
						_this2.setState({
							themeimageid: file.file.response.imageid
						});
						//$("div.ant-upload.ant-upload-select-picture-card").hide();
					}
				},
				//onRemove:(file)=>{
				//$("div.ant-upload-list.ant-upload-list-picture-card span").html("");
				//$("div.ant-upload.ant-upload-select-picture-card").show();
				//}ChatUtil
				onPreview: function onPreview(file) {
					var chatimgpool = [];
					var imageurl = "/weaver/weaver.file.FileDownload?fileid=" + file.response.imageid;
					chatimgpool.push(imageurl);
					parent.parent.IMCarousel.showImgScanner4Pool(true, chatimgpool, 0, null, window.top);
					// if(parent.ImageReviewForPc){
					// 	parent.ImageReviewForPc.show(0, chatimgpool);      		
					// }else{
					// 	parent.parent.IMCarousel.showImgScanner4Pool(true, chatimgpool, 0, null, window.top);
					// }        
				}
			};
			return React.createElement(
				'div',
				null,
				React.createElement(
					_antd.Form,
					{ horizontal: true, onSubmit: this.handleSubmit, id: 'publishform' },
					React.createElement(
						'div',
						{ className: 'publishvoteformdiv', id: 'scrollcontainer' },
						React.createElement(
							'div',
							{ style: { 'height': '100%' } },
							React.createElement(
								'div',
								{ className: 'publishvoterowdiv' },
								React.createElement(
									FormItem,
									{
										label: '\u6295\u7968\u4E3B\u9898 :',
										className: 'requiredStar'
									},
									React.createElement(
										'div',
										{ className: 'votethemediv' },
										React.createElement(
											FormItem,
											null,
											React.createElement(_antd.Input, _extends({ type: 'textarea', placeholder: '\u8BF7\u586B\u5199\u6295\u7968\u4E3B\u9898', className: 'votethemetextarea' }, voteThemeProps, { maxLength: 200 })),
											React.createElement(_antd.Input, _extends({}, getFieldProps('themeimageid', { initialValue: themeimageid }), { style: { display: 'none' } }))
										),
										React.createElement(
											'div',
											{ className: 'clearfix', style: { 'width': '70px', 'height': '70px', 'overflow': 'hidden' } },
											React.createElement(
												_antd.Upload,
												uploadThemeImageprops,
												React.createElement(
													'div',
													{ className: 'ant-upload-text uploadthemeimage' },
													React.createElement(
														'span',
														null,
														'\u6DFB\u52A0\u56FE\u7247'
													)
												)
											)
										)
									)
								)
							),
							React.createElement(
								'div',
								{ className: 'publishvoterowdiv' },
								React.createElement(
									FormItem,
									{
										label: '\u9009\u62E9\u6A21\u5F0F :'
									},
									React.createElement(
										'div',
										null,
										React.createElement(
											RadioGroup,
											voteModelProps,
											React.createElement(
												_antd.Radio,
												{ value: 0 },
												'\u5355\u9009'
											),
											React.createElement(
												_antd.Radio,
												{ value: 1 },
												'\u591A\u9009'
											)
										),
										React.createElement(
											'span',
											{ style: { display: showMax ? 'inline-block' : 'none', verticalAlign: "middle" }, className: 'maxOptionsNum' },
											'\u6700\u591A\xA0\xA0',
											React.createElement(_antd.InputNumber, _extends({
												style: { width: '60px', height: '24px' },
												min: 2
											}, getFieldProps('maxvoteoption', { initialValue: 2 }))),
											'\u9879'
										)
									)
								)
							),
							React.createElement(
								'div',
								{ clasName: 'publishvoterowdiv' },
								React.createElement(
									FormItem,
									{
										className: 'requiredStar',
										label: '\u6295\u7968\u9009\u9879 :'
									},
									formItems,
									React.createElement(
										'div',
										{ onClick: this.addVoteOption, style: { color: '#3597f2', cursor: 'pointer' } },
										'\u6DFB\u52A0\u9009\u9879'
									)
								)
							),
							React.createElement(
								'div',
								{ className: 'publishvoterowdiv' },
								React.createElement(
									FormItem,
									{
										label: '\u6295\u7968\u9690\u79C1 :'
	
									},
									React.createElement(
										RadioGroup,
										getFieldProps('voteprivacy', { initialValue: 0 }),
										React.createElement(
											_antd.Radio,
											{ value: 0 },
											'\u516C\u5F00'
										),
										React.createElement(
											_antd.Radio,
											{ value: 1 },
											'\u533F\u540D'
										)
									),
									React.createElement(
										'span',
										{ style: { verticalAlign: "middle", 'color': '#bebebe', 'marginLeft': '-9px' } },
										'(\u53EA\u6709\u53D1\u5E03\u8005\u624D\u53EF\u67E5\u770B\u6295\u7968\u4EBA)'
									)
								)
							),
							React.createElement(
								'div',
								{ className: 'publishvoterowdiv' },
								React.createElement(
									FormItem,
									{
										label: '\u622A\u6B62\u65F6\u95F4 :'
	
									},
									React.createElement(_antd.DatePicker, _extends({}, getFieldProps('enddate', { initialValue: syscurrenttimenetday }), { disabledDate: disabledDate })),
									React.createElement(_antd.TimePicker, _extends({}, getFieldProps('endtime', { initialValue: syscurrenttime }), { format: 'HH:mm' }))
								)
							),
							React.createElement(
								'div',
								{ className: 'publishvoterowdiv' },
								React.createElement(
									FormItem,
									{
										label: '\u63D0\u9192 :'
	
									},
									React.createElement(
										_antd.Select,
										_extends({}, getFieldProps('voteremind', { initialValue: '1' }), { style: { width: 120 } }),
										React.createElement(
											Option,
											{ value: '1' },
											'\u63D0\u524D30\u5206\u949F'
										),
										React.createElement(
											Option,
											{ value: '2' },
											'\u63D0\u524D12\u5C0F\u65F6'
										),
										React.createElement(
											Option,
											{ value: '3' },
											'\u63D0\u524D24\u5C0F\u65F6'
										),
										React.createElement(
											Option,
											{ value: '4' },
											'\u4E0D\u63D0\u9192'
										)
									)
								)
							)
						)
					),
					React.createElement(
						'div',
						{ id: 'zDialog_div_bottom', className: 'zDialog_div_bottom' },
						React.createElement(
							'table',
							{ style: { 'width': '100%' } },
							React.createElement(
								'tr',
								null,
								React.createElement(
									'td',
									{ style: { 'text-align': 'center' }, colspan: '3' },
									React.createElement('input', { type: 'button', value: '\u53D1\u5E03', className: 'zd_btn_submit', onClick: this.handleSubmit }),
									React.createElement(
										'span',
										{ className: 'e8_sep_line' },
										'|'
									),
									React.createElement('input', { type: 'button', value: '\u53D6\u6D88', className: 'zd_btn_cancle', onClick: this.handleCancel })
								)
							)
						)
					)
				)
			);
		}
	});
	Main = createForm()(Main);
	exports["default"] = Main;

/***/ },
/* 80 */
/***/ function(module, exports) {

	module.exports = ecCom;

/***/ },
/* 81 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _ecCom = __webpack_require__(80);
	
	var FormItem = _antd.Form.Item;
	var createForm = _antd.Form.create;
	var confirm = _antd.Modal.confirm;
	
	var that = null;
	
	var listDeleteIcon = {
		'width': '17px',
		'text-align': 'center'
	};
	var fontLineHeight = {
		'line-height': '23px',
		'padding-right': '15px'
	};
	
	var ongoingStyle = {
		'margin-left': '10px',
		'display': 'inline-block',
		'line-height': '20px',
		'padding': '0 5.5px',
		'background-color': '#ff7d00',
		'border-radius': '2px',
		'font-size': '11px',
		'color': '#ffffff'
	};
	var finishStyle = {
		'margin-left': '10px',
		'display': 'inline-block',
		'line-height': '20px',
		'padding': '0 5.5px',
		'background-color': '#c9c9c9',
		'border-radius': '2px',
		'font-size': '11px',
		'color': '#ffffff'
	};
	var timeStyle = {
		'color': '#a5a5a5',
		'font-size': '12px'
	};
	var contentFont = {
		'word-break': 'break-all',
		'color': '#333333',
		'font-size': '14px'
	};
	var _backgroundcolor = window.__skin;
	var _defaultcolor = "5cb5d8";
	if (_backgroundcolor) {
		var _background = _backgroundcolor.toLowerCase();
		if ("5bb4d8" == _background) {
			_defaultcolor = "5cb5d8";
		} else if ("31a66b" == _background) {
			_defaultcolor = "3bc27e";
		} else {
			_defaultcolor = _background;
		}
	}
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			that = this;
			return {
				dataList: [],
				formheight: 515,
				ifsearch: '',
				firstPage: 1,
				defaultcolor: _defaultcolor
			};
		},
		componentDidMount: function componentDidMount() {
			var _this2 = this;
	
			this.state.firstPage = 0;
			this.getDataList().then(function () {
				_this2.windowResize();
			});
		},
		getDataList: function getDataList(keyword, ifsearch) {
			var _this3 = this;
	
			return _ecCom.WeaTools.callApi('/voting/groupchatvote/VotingList.jsp?groupid=' + window.__groupid, 'POST', { 'votetheme': keyword ? keyword : '', 'ifsearch': ifsearch ? ifsearch : '' }).then(function (data) {
				var winheight = $(window).height();
				_this3.setState({
					dataList: data.dataList,
					formheight: winheight - 112,
					ifsearch: data.ifsearch
				});
			});
		},
		windowResize: function windowResize() {
			var _this = this;
			jQuery('#scrollcontainer').perfectScrollbar();
			$(window).resize(function () {
				var winheight = $(window).height();
				_this.setState({
					formheight: winheight - 112
				});
				jQuery('#scrollcontainer').perfectScrollbar();
			});
		},
		getVoteDetail: function getVoteDetail(groupid, votingid) {
			//votestatus有3个状态：0：删除；1：进入详情页面；2：进入投票页面；
			var curdate = new Date();
			var votestatus = "";
			var url = "/voting/groupchatvote/VotingShow.jsp?groupid=" + groupid + "&votingid=" + votingid + "&groupowner=" + window.__groupowner + "&time=_" + curdate.getTime();
			_ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { groupid: groupid, votingid: votingid, method: 'chatmessage' }).then(function (data) {
				votestatus = data.votestatus;
				if (votestatus == "0") {//提示删除
	
				} else if (votestatus == "1") {
					//返回进入详情url
					url += "&groupusercount=" + window.__groupusercount + "&method=detail#/votedetail";
				} else {
					//返回进入投票url
					url += "&method=vote#/startvoting";
				}
			});
			return votestatus;
		},
		pubnishVote: function pubnishVote() {
			var url = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "#/pubnishvote";
			parent.commonUtil.dialog('发布投票', false, url, 630, 478, '', window);
		},
		votethemsearch: function votethemsearch(value) {
			this.getDataList(value, "search");
		},
		deleteVote: function deleteVote(data, e) {
			var _this = this;
			confirm({
				content: '确定要删除该投票吗？',
				iconType: 'none',
				onOk: function onOk() {
					_ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { 'votingid': data.votingid, 'method': 'delete' }).then(function (_data) {
						_this.state.dataList.map(function (d, i) {
							if (d.votingid == data.votingid) {
								_this.state.dataList.splice(i, 1);
								return;
							}
						});
						_this.setState({});
					});
				},
				onCancel: function onCancel() {}
			});
		},
		voteOrLookDetail: function voteOrLookDetail(data, e) {
			var _this = this;
			var curdate = new Date();
			var url = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "&votingid=" + data.votingid + "&skin=" + window.__skin + "&time=time_" + curdate.getTime();
			_ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { 'votingid': data.votingid, 'method': 'chatmessage' }).then(function (_data) {
				var _status = _data.votestatus;
				if (_status == "0") {
					_antd.message.warning('该投票已经被删除！');
					_this.state.dataList.map(function (d, i) {
						if (d.votingid == data.votingid) {
							_this.state.dataList.splice(i, 1);
							return;
						}
					});
					_this.setState({});
				} else if (_status == "2") {
					url += "&method=vote#/startvoting";
					parent.commonUtil.imslideDiv('400', url);
				} else if (_status == "1" || _status == "3") {
					url += "&method=detail#/votedetail";
					parent.commonUtil.imslideDiv('400', url);
				}
			});
			// let curdate=new Date(); 
			// let voteendtime=new Date(data.voteendtime); 
			// let canvote=data.canvote;
			// let votestatus=data.votestatus;
			// let url="/voting/groupchatvote/VotingShow.jsp?groupid="+window.__groupid+"&votingid="+data.votingid+"&groupowner="+window.__groupowner+"&time=time_"+curdate.getTime();
			// if(canvote=="1"){
			// 	if(curdate.getTime()<voteendtime.getTime()){
			// 		url +="&method=vote#/startvoting";
			// 	}else{
			// 		data.votestatus="1";
			// 		this.setState();
			// 		url +="&groupusercount="+window.__groupusercount+"&method=detail#/votedetail";    		
			// 	}	
			// }else{
			// 	url +="&groupusercount="+window.__groupusercount+"&method=detail#/votedetail";
			//   	}
	
			//parent.commonUtil.imslideDiv('400',url);
		},
		bodyClick: function bodyClick(e) {
			var $obj = e.target;
			var flag = false;
			e.stopPropagation();
			while ($obj && $obj.tagName != "body") {
				if ($obj.className && $obj.className.indexOf("voteDetailOpen") > -1) {
					flag = true;
					break;
				}
				$obj = $obj.parentNode;
			}
			if (!flag) {
				parent.commonUtil.doHideSlideDiv();
				//let slideDiv = parent.$("#imSlideDiv");
				//parent.IMUtil.doHideSlideDiv(slideDiv); 		
			}
		},
		render: function render() {
			var _this4 = this;
	
			var getFieldProps = this.props.form.getFieldProps;
			var _state = this.state,
			    dataList = _state.dataList,
			    formheight = _state.formheight,
			    ifsearch = _state.ifsearch,
			    firstPage = _state.firstPage,
			    defaultcolor = _state.defaultcolor;
	
			var listItems = dataList.map(function (data) {
				return React.createElement(
					'div',
					{ className: 'listUnitStyle', id: "votingid" + data.votingid },
					React.createElement(
						'div',
						{ style: { 'cursor': 'pointer' }, className: 'voteDetailOpen', onClick: _this4.voteOrLookDetail.bind(_this4, data) },
						React.createElement(
							'div',
							{ style: fontLineHeight },
							React.createElement(
								'span',
								{ style: contentFont },
								data.votetheme
							),
							React.createElement(
								'span',
								{ style: data.votestatus == '0' ? ongoingStyle : finishStyle },
								data.votestatus == '0' ? data.votestatusongoingshow : data.votestatusendshow
							)
						),
						React.createElement(
							'div',
							{ style: fontLineHeight },
							React.createElement(
								'span',
								{ style: timeStyle },
								data.creatername + ' ' + data.createdate + ' ' + data.createtime
							)
						)
					),
					data.deletestatus == '1' && React.createElement(
						'div',
						{ style: listDeleteIcon },
						React.createElement('img', { src: '/voting/groupchatvote/images/deletevote.png', onClick: _this4.deleteVote.bind(_this4, { votingid: data.votingid }), className: 'votelistdeleteimage' })
					)
				);
			});
			return React.createElement(
				'div',
				{ className: 'votelistdiv', onClick: this.bodyClick },
				React.createElement(
					_antd.Form,
					{ horizontal: true },
					React.createElement(
						FormItem,
						null,
						React.createElement(
							'div',
							{ className: 'votelistdivsearchPdiv' },
							React.createElement(
								'div',
								{ className: 'votelistsearchdiv' },
								React.createElement(
									'div',
									null,
									React.createElement(
										'div',
										{ className: 'votelistsearchflexdiv' },
										React.createElement(
											'div',
											{ className: 'votethemsearch' },
											React.createElement(_ecCom.WeaInputSearch, { placeholder: '\u641C\u7D22\u5173\u952E\u5B57', onSearch: this.votethemsearch })
										),
										React.createElement(
											'div',
											{ className: 'publicBtnDiv' },
											React.createElement(
												'div',
												{ className: 'publicBtn' },
												React.createElement(
													_antd.Button,
													{ type: 'primary', onClick: this.pubnishVote, style: { 'background-color': "#" + defaultcolor } },
													'\u53D1\u5E03\u6295\u7968'
												)
											)
										)
									)
								)
							)
						)
					),
					firstPage == 1 ? React.createElement('div', null) : React.createElement(
						FormItem,
						null,
						React.createElement(
							'div',
							{ className: 'votelistshowdiv', style: { 'height': formheight + "px", 'overflow': 'hidden' }, id: 'scrollcontainer' },
							dataList.length > 0 ? React.createElement(
								'div',
								{ style: { 'height': '100%' } },
								listItems
							) : ifsearch == "search" ? React.createElement(
								'div',
								{ className: 'novoteinfo' },
								React.createElement(
									'div',
									null,
									React.createElement('img', { src: '/voting/groupchatvote/images/nodata.png', style: { 'cursor': 'pointer' } })
								),
								React.createElement(
									'div',
									null,
									React.createElement(
										'span',
										null,
										'\u6CA1\u6709\u53EF\u4EE5\u663E\u793A\u7684\u6570\u636E!'
									)
								)
							) : React.createElement(
								'div',
								{ className: 'novoteinfo' },
								React.createElement(
									'div',
									null,
									React.createElement('img', { src: '/voting/groupchatvote/images/novote.png', style: { 'cursor': 'pointer' } })
								),
								React.createElement(
									'div',
									null,
									React.createElement(
										'span',
										null,
										'\u6682\u65E0\u6295\u7968\uFF0C\u5FEB\u53BB\u53D1\u5E03\u6295\u7968\u5427\uFF01'
									)
								)
							)
						)
					)
				)
			);
		}
	});
	Main = createForm()(Main);
	exports["default"] = Main;

/***/ },
/* 82 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };
	
	var _antd = __webpack_require__(70);
	
	var _ecCom = __webpack_require__(80);
	
	var FormItem = _antd.Form.Item;
	var createForm = _antd.Form.create;
	var RadioGroup = _antd.Radio.Group;
	var CheckboxGroup = _antd.Checkbox.Group;
	var confirm = _antd.Modal.confirm;
	
	var that = null;
	var listUnitStyle = {
		'padding': '5px 0',
		'border-bottom': '1px solid #dddddd',
		'display': 'flex',
		'justify-content': 'space-between',
		'align-items': 'center',
		'width': '670px'
	};
	
	var listDeleteIcon = {
		'width': '50px',
		'text-align': 'center'
	};
	var fontLineHeight = {
		'line-height': '28px'
	};
	
	var ongoingStyle = {
		'margin-left': '30px',
		'display': 'inline-block',
		'line-height': '20px',
		'padding': '0 8px',
		'background-color': '#ff7d00',
		'color': '#ffffff'
	};
	var finishStyle = {
		'margin-left': '30px',
		'display': 'inline-block',
		'line-height': '20px',
		'padding': '0 8px',
		'background-color': '#c9c9c9',
		'color': '#ffffff'
	};
	var timeStyle = {
		'color': '#a5a5a5',
		'font-size': '12px'
	};
	var contentFont = {
		'word-break': 'break-all',
		'color': '#333333',
		'font-size': '14px'
	};
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			that = this;
			return {
				disabled: false,
				checkvalue: [],
				votedata: {},
				maxOptionCount: 2,
				buttonstate: false,
				formheight: 609,
				firstPage: 1,
				showvoteuser: false,
				defaultcolor: '5cb5d8'
			};
		},
		componentDidMount: function componentDidMount() {
			var _this2 = this;
	
			var _backgroundcolor = window.__skin;
			if (_backgroundcolor) {
				var _defaultcolor = "5cb5d8";
				var _background = _backgroundcolor.toLowerCase();
				if ("5bb4d8" == _background) {
					_defaultcolor = "5cb5d8";
				} else if ("31a66b" == _background) {
					_defaultcolor = "3bc27e";
				} else {
					_defaultcolor = _background;
				}
				this.state.defaultcolor = _defaultcolor;
			}
			this.state.firstPage = 0;
			this.getDataList().then(function () {
				_this2.windowResize();
			});
		},
		windowResize: function windowResize() {
			var _this = this;
			jQuery('#scrollcontainer').perfectScrollbar();
			$(window).resize(function () {
				var winheight = $(window).height();
				_this.setState({
					formheight: winheight - 150
				});
				jQuery('#scrollcontainer').perfectScrollbar();
			});
		},
		getDataList: function getDataList(keyword) {
			var _this3 = this;
	
			return _ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { 'groupid': window.__groupid, 'votingid': window.__votingid, method: 'vote' }).then(function (data) {
				var winheight = $(window).height();
				_this3.setState({
					votedata: data.votedata,
					maxOptionCount: data.votedata.maxvoteoption,
					formheight: winheight - 150
				});
			});
		},
		handleSubmit: function handleSubmit(e) {
			var _this = this;
			var formvalues = this.props.form.getFieldsValue();
			_ecCom.WeaTools.callApi("/voting/groupchatvote/VotingOperator.jsp?groupid=" + window.__groupid + "&votingid=" + window.__votingid + "&method=voteresult", 'POST', formvalues).then(function (data) {
				//判断此时投票是否已经被其他用户删除
				var reloadurl = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "&votingid=" + window.__votingid + "&method=detail#/votedetail";
				if (data.status == "1") {
					//保存成功      			
					//跳转到详情页面
					window.location.href = reloadurl;
					//刷新列表页面	  		
					//发消息(判断投票发布人是否还在群中，如果在则发消息给投票发布人)
					parent.docUtil.voteNotice(data.voteuserid, data.createrid, window.__votingid, window.__groupid, data.votetheme);
				} else if (data.status == "-1") {
					//已经被删除
					_antd.message.warning('该投票已经被删除，不能再进行投票！');
					setTimeout(function () {
						parent.commonUtil.doHideSlideDiv();
					}, 2000);
				} else if (data.status == "0") {
					//已经结束
					_antd.message.warning('该投票已经结束，不能再进行投票！');
					setTimeout(function () {
						_this.refleshCurentPage(reloadurl);
					}, 2000);
				} else if (data.status == "2") {
					//已经投过票了
					_antd.message.warning('该投票已经投过票了，不能再重复投票！');
					setTimeout(function () {
						parent.commonUtil.doHideSlideDiv();
					}, 2000);
				}
				var parentwin = top.window.frames['vote_' + window.__groupid];
				if (parentwin) {
					parentwin.location.reload();
				}
			});
		},
		refleshCurentPage: function refleshCurentPage(reloadurl) {
			window.location.href = reloadurl;
		},
		checkLimit: function checkLimit(value) {
			var _buttonstate = value.length > 0;
			var _disabled = false;
			if (value.length >= this.state.maxOptionCount) {
				_disabled = true;
			}
			this.setState({ disabled: _disabled, buttonstate: _buttonstate, checkvalue: value });
		},
		changeButtonState: function changeButtonState(e) {
			this.setState({ buttonstate: true });
		},
		showViewImage: function showViewImage(data, e) {
			var themeimageid = data.themeimageid;
			var imageurl = themeimageid > 0 ? "/weaver/weaver.file.FileDownload?fileid=" + themeimageid : "/voting/groupchatvote/images/themedefaultimage.png";
			var chatimgpool = [];
			chatimgpool.push(imageurl);
			parent.parent.IMCarousel.showImgScanner4Pool(true, chatimgpool, 0, null, window.top);
			// if(parent.ImageReviewForPc){
			// 	parent.ImageReviewForPc.show(0, chatimgpool);      		
			// }else{
			// 	parent.parent.IMCarousel.showImgScanner4Pool(true, chatimgpool, 0, null, window.top);
			// }
		},
		showVoteUser: function showVoteUser() {
			var _this = this;
			var _showvoteuser = _this.state.showvoteuser;
			_this.setState({ showvoteuser: !_showvoteuser });
			jQuery('#scrollcontainer').perfectScrollbar('update');
		},
		deleteVote: function deleteVote(data, e) {
			var _this = this;
			confirm({
				content: '确定要删除该投票吗？',
				width: '300px!important',
				iconType: 'none',
				onOk: function onOk() {
					_ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { votingid: data.votingid, method: 'delete' }).then(function (_data) {
						//刷新投票列表
						_this.hideSlideVote();
						var parentwin = top.window.frames['vote_' + window.__groupid];
						if (parentwin) {
							parentwin.location.reload();
						}
					});
				},
				onCancel: function onCancel() {}
			});
		},
		hideSlideVote: function hideSlideVote() {
			//let slideDiv = parent.$("#imSlideDiv");
			//parent.IMUtil.doHideSlideDiv(slideDiv); 
			parent.commonUtil.doHideSlideDiv();
		},
		showGroupUser: function showGroupUser(usertype) {
			var url = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "&votingid=" + window.__votingid + "&usertype=" + usertype + "#/groupuserlist";
			parent.commonUtil.dialog('投票详情', false, url, 600, 530, '');
		},
		getVoteOptionDetail: function getVoteOptionDetail(optionid) {
			var optionDetailurl = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "&votingid=" + window.__votingid + "&optionid=" + optionid + "#/voteoptiondetail";
			parent.commonUtil.dialog('投票选项详情', false, optionDetailurl, 600, 530, '');
		},
		noGetVoteOptionDetail: function noGetVoteOptionDetail() {
			//do nothing;
		},
		render: function render() {
			var _this4 = this;
	
			var getFieldProps = this.props.form.getFieldProps;
			var _state = this.state,
			    votedata = _state.votedata,
			    disabled = _state.disabled,
			    checkvalue = _state.checkvalue,
			    buttonstate = _state.buttonstate,
			    formheight = _state.formheight,
			    firstPage = _state.firstPage,
			    showvoteuser = _state.showvoteuser,
			    defaultcolor = _state.defaultcolor;
	
			var formItemLayout = {
				labelCol: { span: 6 },
				wrapperCol: { span: 16 }
			};
			var radioStyle = {
				display: 'block',
				height: '30px',
				lineHeight: '30px'
			};
			var voteRadioItems = !votedata.options ? "" : votedata.options.map(function (data, i) {
				return React.createElement(
					_antd.Radio,
					{ style: radioStyle, value: data.optionid },
					React.createElement(
						'span',
						{ className: 'showoptioncontent' },
						i + 1 + "." + data.optioncontent
					),
					React.createElement(
						'span',
						{ className: 'showvotecount', style: { "cursor": votedata.canviewvoteuser == "1" ? "pointer" : "default" }, onClick: votedata.canviewvoteuser == "1" ? function () {
								return _this4.getVoteOptionDetail(data.optionid);
							} : function () {
								return _this4.noGetVoteOptionDetail();
							} },
						data.votecount,
						'\u7968'
					)
				);
			});
			var checkoptions = [];
			if (votedata.options) {
				votedata.options.map(function (data, i) {
					var _disabled = false;
					if (disabled) {
						_disabled = true;
						checkvalue.map(function (v) {
							if (v == data.optionid) {
								_disabled = false;
								return;
							}
						});
					}
					checkoptions.push({
						label: React.createElement(
							'span',
							null,
							React.createElement(
								'span',
								{ className: 'showoptioncontent' },
								i + 1 + "." + data.optioncontent
							),
							React.createElement(
								'span',
								{ className: 'showvotecount', style: { "cursor": votedata.canviewvoteuser == "1" ? "pointer" : "default" }, onClick: votedata.canviewvoteuser == "1" ? function () {
										return _this4.getVoteOptionDetail(data.optionid);
									} : function () {
										return _this4.noGetVoteOptionDetail();
									} },
								data.votecount,
								'\u7968'
							)
						),
						value: data.optionid,
						disabled: _disabled
					});
				});
			}
			var checkProps = getFieldProps('votooptioncheck', {
				onChange: this.checkLimit.bind(this)
			});
			var radioProps = getFieldProps('votooptionradio', {
				onChange: this.changeButtonState.bind(this)
			});
			var userItems = function userItems(user) {
				return React.createElement(
					'div',
					{ className: 'userInfo' },
					React.createElement(
						'div',
						{ className: 'userImage' },
						React.createElement('img', { src: user.messagerurl })
					),
					React.createElement(
						'div',
						{ className: 'userName' },
						user.voteusername
					)
				);
			};
			var submitUserItems = !votedata.havevotedpersons ? "" : votedata.havevotedpersons.map(function (data, i) {
				if (i < 7) {
					return userItems(data);
				}
			});
			var notSubmitUserItems = !votedata.havenotvotedpersons ? "" : votedata.havenotvotedpersons.map(function (data, i) {
				if (i < 7) {
					return userItems(data);
				}
			});
			var userType = [0, 1];
			var allUserItems = !votedata.havevotedpersons && !votedata.havenotvotedpersons ? "" : userType.map(function (type) {
				return React.createElement(
					'div',
					{ className: type == 0 ? "userGroupInfo voteuserGroupInfo" : "userGroupInfo notvoteuserGroupInfo" },
					React.createElement(
						'div',
						{ className: 'userHeader' },
						React.createElement(
							'div',
							null,
							React.createElement(
								'span',
								null,
								type == 0 ? votedata.votelabel : votedata.notvotelabel
							)
						),
						React.createElement(
							'div',
							null,
							React.createElement(
								'span',
								{ className: 'moreUser', onClick: function onClick() {
										return _this4.showGroupUser(type);
									} },
								'\u67E5\u770B\u8BE6\u60C5',
								'>>'
							)
						)
					),
					React.createElement(
						'div',
						{ className: 'userGroup' },
						type == 0 ? submitUserItems : notSubmitUserItems
					)
				);
			});
			return firstPage == 1 ? React.createElement('div', null) : React.createElement(
				'div',
				{ id: 'startVotediv', style: { "width": "400px" } },
				React.createElement(
					_antd.Form,
					{ horizontal: true, onSubmit: this.handleSubmit },
					React.createElement(
						FormItem,
						null,
						React.createElement(
							'div',
							{ className: 'votingDetail' },
							React.createElement(
								'div',
								{ className: 'dCloseBtn', title: '\u5173\u95ED', onClick: this.hideSlideVote },
								'\xD7'
							),
							React.createElement(
								'div',
								{ className: 'detailHeader' },
								React.createElement(
									'div',
									{ className: 'headerTheme' },
									React.createElement(
										'div',
										{ className: 'themeFont' },
										React.createElement(
											'span',
											null,
											votedata.votetheme
										),
										React.createElement(
											'span',
											{ className: "headerStatus" + (votedata.votestatus == '0' ? "" : " gary") },
											votedata.votestatusshow
										)
									),
									React.createElement(
										'div',
										{ className: 'headerUserAndTime' },
										React.createElement(
											'span',
											{ className: 'headerUser' },
											votedata.creatername
										),
										React.createElement(
											'span',
											{ className: 'headerTime' },
											votedata.createdate + ' ' + votedata.createtime
										)
									)
								)
							),
							React.createElement(
								'div',
								{ style: { 'max-height': formheight + "px", 'overflow': 'hidden' }, id: 'scrollcontainer' },
								React.createElement(
									'div',
									{ style: { 'height': '100%' } },
									React.createElement(
										'div',
										{ className: 'detailOptions', style: { "border-bottom-width": showvoteuser ? "1px" : "0px" } },
										votedata.themeimageid > 0 && React.createElement(
											'div',
											{ className: 'votethemeshow', onClick: this.showViewImage.bind(this, { themeimageid: votedata.themeimageid }) },
											React.createElement('img', { className: 'votethemeimage', src: "/weaver/weaver.file.FileDownload?fileid=" + votedata.themeimageid })
										),
										React.createElement(
											'div',
											{ className: 'optionHeader' },
											React.createElement(
												'div',
												{ className: 'optionType' },
												votedata.choosemodelshow
											),
											React.createElement(
												'div',
												{ className: 'submitNumber', onClick: votedata.canviewvoteuser2 == "1" ? function () {
														return _this4.showVoteUser();
													} : function () {
														return _this4.noGetVoteOptionDetail();
													}, style: { "cursor": votedata.canviewvoteuser2 == "1" ? "pointer" : "default" } },
												votedata.votetotalcountshow
											)
										),
										React.createElement(
											'div',
											null,
											React.createElement(
												'div',
												{ className: 'checkboxblock' },
												votedata.choosemodel == '0' ? React.createElement(
													RadioGroup,
													radioProps,
													voteRadioItems
												) : React.createElement(CheckboxGroup, _extends({ options: checkoptions }, checkProps))
											),
											React.createElement(
												'div',
												{ className: 'optionsFoot' },
												React.createElement(
													'div',
													null,
													React.createElement(
														'span',
														null,
														votedata.endtimelabel
													),
													React.createElement(
														'span',
														null,
														votedata.enddate + " " + votedata.endtime
													)
												),
												votedata.deletestatus == '1' && React.createElement(
													'div',
													{ onClick: this.deleteVote.bind(this, { votingid: votedata.votingid }) },
													React.createElement('img', { src: '/voting/groupchatvote/images/deletevote.png', style: { 'cursor': 'pointer', 'margin-bottom': '-2px', 'height': '16px', 'padding-right': '5px' } }),
													React.createElement(
														'span',
														{ className: 'deleteVoting', style: { 'padding-right': '6px' } },
														'\u5220\u9664\u6295\u7968'
													)
												)
											)
										)
									),
									React.createElement(
										'div',
										{ style: { "display": showvoteuser ? "block" : "none" } },
										allUserItems
									)
								)
							),
							React.createElement(
								'div',
								{ className: 'buttondiv' },
								React.createElement(
									_antd.Button,
									{ type: 'primary', disabled: !buttonstate, onClick: this.handleSubmit, style: { 'background-color': !buttonstate ? "#c9c9c9" : "#" + defaultcolor, "border": "none", "color": "#fff" } },
									'\u6295\u7968'
								)
							)
						)
					)
				)
			);
		}
	});
	Main = createForm()(Main);
	exports["default"] = Main;

/***/ },
/* 83 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _ecCom = __webpack_require__(80);
	
	var createForm = _antd.Form.create;
	var confirm = _antd.Modal.confirm;
	var that = null;
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			that = this;
			return {
				dataMap: {},
				visible: false,
				votedata: {},
				formheight: 609,
				firstPage: 1
			};
		},
		componentDidMount: function componentDidMount() {
			var _this2 = this;
	
			this.state.firstPage = 0;
			this.getDataList().then(function () {
				_this2.windowResize();
			});;
		},
		windowResize: function windowResize() {
			var _this = this;
			jQuery('#scrollcontainer').perfectScrollbar();
			$(window).resize(function () {
				var winheight = $(window).height();
				_this.setState({
					formheight: winheight - 77
				});
				jQuery('#scrollcontainer').perfectScrollbar();
			});
		},
		getDataList: function getDataList() {
			var _this3 = this;
	
			return _ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { votingid: window.__votingid, groupid: window.__groupid, groupowner: window.__groupowner, groupusercount: window.__groupusercount, method: 'detail' }).then(function (data) {
				var winheight = $(window).height();
				_this3.setState({
					votedata: data.votedata,
					formheight: winheight - 77
				});
			});
		},
		showModal: function showModal() {
			this.setState({
				visible: true
			});
		},
		hideSlideVote: function hideSlideVote() {
			//let slideDiv = parent.$("#imSlideDiv");
			//parent.IMUtil.doHideSlideDiv(slideDiv); 
			parent.commonUtil.doHideSlideDiv();
		},
		showGroupUser: function showGroupUser(usertype) {
			var url = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "&votingid=" + window.__votingid + "&usertype=" + usertype + "#/groupuserlist";
			parent.commonUtil.dialog('投票详情', false, url, 600, 530, '');
		},
		getVoteOptionDetail: function getVoteOptionDetail(optionid) {
			var optionDetailurl = "/voting/groupchatvote/VotingShow.jsp?groupid=" + window.__groupid + "&votingid=" + window.__votingid + "&optionid=" + optionid + "#/voteoptiondetail";
			parent.commonUtil.dialog('投票选项详情', false, optionDetailurl, 600, 530, '');
		},
		noGetVoteOptionDetail: function noGetVoteOptionDetail() {
			//do nothing;
		},
		showViewImage: function showViewImage(data, e) {
			var themeimageid = data.themeimageid;
			var imageurl = themeimageid > 0 ? "/weaver/weaver.file.FileDownload?fileid=" + themeimageid : "/voting/groupchatvote/images/themedefaultimage.png";
			var chatimgpool = [];
			chatimgpool.push(imageurl);
			parent.parent.IMCarousel.showImgScanner4Pool(true, chatimgpool, 0, null, window.top);
			// if(parent.ImageReviewForPc){
			// 	parent.ImageReviewForPc.show(0, chatimgpool);      		
			// }else{
			// 	parent.parent.IMCarousel.showImgScanner4Pool(true, chatimgpool, 0, null, window.top);
			// }
			//parent.docUtil.doChatImgClick(event, imageurl);
		},
		deleteVote: function deleteVote(data, e) {
			var _this = this;
			confirm({
				content: '确定要删除该投票吗？',
				iconType: 'none',
				width: '200px',
				onOk: function onOk() {
					_ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { votingid: data.votingid, method: 'delete' }).then(function (_data) {
						//刷新投票列表
						_this.hideSlideVote();
						var parentwin = top.window.frames['vote_' + window.__groupid];
						if (parentwin) {
							parentwin.location.reload();
						}
					});
				},
				onCancel: function onCancel() {}
			});
		},
		render: function render() {
			var _this4 = this;
	
			var _this = this;
			var _props$form = this.props.form,
			    getFieldProps = _props$form.getFieldProps,
			    getFieldValue = _props$form.getFieldValue,
			    getFieldError = _props$form.getFieldError,
			    isFieldValidating = _props$form.isFieldValidating;
			var _state = this.state,
			    votedata = _state.votedata,
			    formheight = _state.formheight,
			    firstPage = _state.firstPage;
	
			var optionItems = !votedata.options ? "" : votedata.options.map(function (data, i) {
				return React.createElement(
					'div',
					{ className: 'optionUnit', onClick: votedata.canviewvoteuser == "1" ? function () {
							return _this4.getVoteOptionDetail(data.optionid);
						} : function () {
							return _this4.noGetVoteOptionDetail();
						}, style: { "cursor": votedata.canviewvoteuser == "1" ? "pointer" : "default" } },
					React.createElement(
						'div',
						{ className: 'optionContent' },
						React.createElement(
							'div',
							{ className: 'optionLeft' },
							data.optionvoteflag == "1" ? React.createElement('img', { src: '/voting/groupchatvote/images/optionvoteflag.png', className: 'optionvoteflag' }) : ''
						),
						React.createElement(
							'div',
							{ className: 'optionCenter' },
							i + 1,
							'. ',
							data.optioncontent
						),
						React.createElement(
							'div',
							{ className: 'optionRight' },
							data.votecount,
							'\u7968'
						)
					),
					React.createElement('div', { className: 'percentLine', style: { "width": data.votepercent + "%" } })
				);
			});
			var userItems = function userItems(user) {
				return React.createElement(
					'div',
					{ className: 'userInfo' },
					React.createElement(
						'div',
						{ className: 'userImage' },
						React.createElement('img', { src: user.messagerurl })
					),
					React.createElement(
						'div',
						{ className: 'userName' },
						user.voteusername
					)
				);
			};
			var submitUserItems = !votedata.havevotedpersons ? "" : votedata.havevotedpersons.map(function (data, i) {
				if (i < 7) {
					return userItems(data);
				}
			});
			var notSubmitUserItems = !votedata.havenotvotedpersons ? "" : votedata.havenotvotedpersons.map(function (data, i) {
				if (i < 7) {
					return userItems(data);
				}
			});
			var userType = [0, 1];
			var allUserItems = !votedata.havevotedpersons && !votedata.havenotvotedpersons ? "" : userType.map(function (type) {
				return React.createElement(
					'div',
					{ className: type == 0 ? "userGroupInfo voteuserGroupInfo" : "userGroupInfo notvoteuserGroupInfo" },
					React.createElement(
						'div',
						{ className: 'userHeader' },
						React.createElement(
							'div',
							null,
							React.createElement(
								'span',
								null,
								type == 0 ? votedata.votelabel : votedata.notvotelabel
							)
						),
						React.createElement(
							'div',
							null,
							React.createElement(
								'span',
								{ className: 'moreUser', onClick: function onClick() {
										return _this4.showGroupUser(type);
									} },
								'\u67E5\u770B\u8BE6\u60C5',
								'>>'
							)
						)
					),
					React.createElement(
						'div',
						{ className: 'userGroup' },
						type == 0 ? submitUserItems : notSubmitUserItems
					)
				);
			});
			return firstPage == 1 ? React.createElement('div', null) : React.createElement(
				'div',
				{ className: 'votingDetail', style: { "width": "400px" } },
				React.createElement(
					'div',
					{ className: 'dCloseBtn', title: '\u5173\u95ED', onClick: this.hideSlideVote },
					'\xD7'
				),
				React.createElement(
					'div',
					{ className: 'detailHeader' },
					React.createElement(
						'div',
						{ className: 'headerTheme' },
						React.createElement(
							'div',
							{ className: 'themeFont' },
							React.createElement(
								'span',
								null,
								votedata.votetheme
							),
							React.createElement(
								'span',
								{ className: "headerStatus" + (votedata.votestatus == '0' ? "" : " gary") },
								votedata.votestatusshow
							)
						),
						React.createElement(
							'div',
							{ className: 'headerUserAndTime' },
							React.createElement(
								'span',
								{ className: 'headerUser' },
								votedata.creatername
							),
							React.createElement(
								'span',
								{ className: 'headerTime' },
								votedata.createdate + ' ' + votedata.createtime
							)
						)
					)
				),
				React.createElement(
					'div',
					{ style: { 'height': formheight + "px", 'overflow': 'hidden' }, id: 'scrollcontainer' },
					React.createElement(
						'div',
						{ style: { 'height': '100%' } },
						React.createElement(
							'div',
							{ className: 'detailOptions' },
							votedata.themeimageid > 0 && React.createElement(
								'div',
								{ className: 'votethemeshow', onClick: this.showViewImage.bind(this, { themeimageid: votedata.themeimageid }) },
								React.createElement('img', { className: 'votethemeimage', src: "/weaver/weaver.file.FileDownload?fileid=" + votedata.themeimageid })
							),
							React.createElement(
								'div',
								{ className: 'optionHeader' },
								React.createElement(
									'div',
									{ className: 'optionType' },
									votedata.choosemodelshow
								),
								React.createElement(
									'div',
									{ className: 'submitNumber' },
									votedata.votetotalcountshow
								)
							),
							React.createElement(
								'div',
								null,
								React.createElement(
									'div',
									{ className: 'optionItems' },
									optionItems
								),
								React.createElement(
									'div',
									{ className: 'optionsFoot' },
									React.createElement(
										'div',
										null,
										React.createElement(
											'span',
											null,
											votedata.endtimelabel
										),
										React.createElement(
											'span',
											null,
											votedata.enddate + " " + votedata.endtime
										)
									),
									votedata.deletestatus == '1' && React.createElement(
										'div',
										{ onClick: this.deleteVote.bind(this, { votingid: votedata.votingid }) },
										React.createElement('img', { src: '/voting/groupchatvote/images/deletevote.png', style: { 'cursor': 'pointer', 'margin-bottom': '-2px', 'height': '16px', 'padding-right': '5px' } }),
										React.createElement(
											'span',
											{ className: 'deleteVoting', style: { 'padding-right': '6px' } },
											'\u5220\u9664\u6295\u7968'
										)
									)
								)
							)
						),
						votedata.canviewvoteuser == '1' && allUserItems
					)
				)
			);
		}
	});
	Main = createForm()(Main);
	exports["default"] = Main;

/***/ },
/* 84 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _ecCom = __webpack_require__(80);
	
	var FormItem = _antd.Form.Item;
	var createForm = _antd.Form.create;
	var that = null;
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			that = this;
			return {
				usertype: '',
				userList: []
			};
		},
		componentDidMount: function componentDidMount() {
			this.getDataList().then(function () {
				jQuery('.groupUserBody').perfectScrollbar();
			});
		},
		getDataList: function getDataList(keyword) {
			var _this2 = this;
	
			return _ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { 'votingid': window.__votingid, 'groupid': window.__groupid, 'method': 'groupuser', 'usertype': window.__usertype, 'lastname': keyword ? keyword : '' }).then(function (data) {
				_this2.setState({
					usertype: data.usertype,
					userList: data.userList
				});
			});
		},
		closeDialog: function closeDialog() {
			parent.getDialog(window).close();
		},
		inputSearch: function inputSearch() {
			var _this = this;
			var keyCode = event.keyCode;
			if (keyCode == 13) {
				_this.searchTableUser();
			}
		},
		searchTableUser: function searchTableUser() {
			var keyword = $.trim($('.searchInput').val());
			this.getDataList(keyword);
		},
		render: function render() {
			var usertype = this.state.usertype;
	
			var dataSource = this.state.userList;
			var cloumns = [{
				title: '',
				dataIndex: '',
				key: '',
				width: '5%'
			}, {
				title: '',
				dataIndex: '',
				key: '',
				width: '5%'
			}, {
				title: '成员',
				dataIndex: 'name',
				key: 'name',
				width: '20%'
			}, {
				title: '部门',
				dataIndex: 'department',
				key: 'department',
				width: '35%'
			}, {
				title: '岗位',
				dataIndex: 'position',
				key: 'position',
				width: '35%'
			}];
			return React.createElement(
				'div',
				{ className: 'groupUserList' },
				React.createElement(
					'div',
					{ className: 'groupUserHeader' },
					React.createElement(
						'div',
						{ className: 'groupUserIcon' },
						React.createElement('img', { src: '/js/tabs/images/nav/social_wev8.png' })
					),
					React.createElement(
						'div',
						{ className: 'groupUserLabel' },
						usertype == 0 ? '参与投票人员' : '未参与投票人员'
					),
					React.createElement(
						'div',
						{ className: 'searchgroupuserdiv' },
						React.createElement(
							'span',
							{ id: 'searchblockspan' },
							React.createElement(
								'span',
								{ className: 'searchInputSpan', style: { "position": "relative" } },
								React.createElement('input', { type: 'text', className: 'searchInput middle', name: 'lastname', id: 'lastname', style: { "vertical-align": "top" }, onKeyPress: this.inputSearch }),
								React.createElement(
									'span',
									{ className: 'middle searchImg' },
									React.createElement('img', { className: 'middle', style: { "vertical-align": "top", "margin-top": "2px" }, src: '/images/ecology8/request/search-input_wev8.png', onClick: this.searchTableUser })
								)
							)
						)
					)
				),
				React.createElement(
					'div',
					{ className: 'groupUserBody', style: { "height": "430px" } },
					React.createElement(_antd.Table, { dataSource: dataSource, columns: cloumns, pagination: false })
				),
				React.createElement(
					'div',
					{ className: 'zDialog_div_bottom' },
					React.createElement('input', { type: 'button', value: '\u5173\u95ED', className: 'zd_btn_cancle', onClick: this.closeDialog })
				)
			);
		}
	});
	Main = createForm()(Main);
	exports["default"] = Main;

/***/ },
/* 85 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
		value: true
	});
	
	var _antd = __webpack_require__(70);
	
	var _ecCom = __webpack_require__(80);
	
	var FormItem = _antd.Form.Item;
	var createForm = _antd.Form.create;
	var that = null;
	var Main = React.createClass({
		getInitialState: function getInitialState() {
			that = this;
			return {
				voteoptiondata: {},
				optionVotePersons: [],
				firstPage: 1
			};
		},
		componentDidMount: function componentDidMount() {
			this.state.firstPage = 0;
			this.getDataList();
			// this.setState({
			// 	voteoptiondata : {
			// 		headshowlabel:'选项:',
			// 		optioncontent:'外卖芝根芝底（只点披萨和小食）',
			// 		voteoptionpersonlabel:'投此选项的人：4人',
			// 		havevotedpersons:[
			// 			{'voteusername':'韦利东','messagerurl':'/social/images/head.png'}
			// 		]
			// 	}
			// });
		},
		getDataList: function getDataList() {
			var _this = this;
	
			return _ecCom.WeaTools.callApi('/voting/groupchatvote/VotingOperator.jsp', 'POST', { votingid: window.__votingid, groupid: window.__groupid, optionid: window.__optionid, method: 'optiondetail' }).then(function (data) {
				_this.setState({
					voteoptiondata: data.voteoptiondata,
					optionVotePersons: data.optionVotePersons
				});
			});
		},
		closeDialog: function closeDialog() {
			parent.getDialog(window).close();
		},
		render: function render() {
			var _state = this.state,
			    voteoptiondata = _state.voteoptiondata,
			    optionVotePersons = _state.optionVotePersons,
			    firstPage = _state.firstPage;
	
			var userItems = function userItems(user) {
				return React.createElement(
					'div',
					{ className: 'userInfo' },
					React.createElement(
						'div',
						{ className: 'userImage' },
						React.createElement('img', { src: user.messagerurl })
					),
					React.createElement(
						'div',
						{ className: 'userName' },
						user.voteusername
					)
				);
			};
			var voteUserItems = !optionVotePersons ? "" : optionVotePersons.map(function (data) {
				return userItems(data);
			});
			return firstPage == 1 ? React.createElement('div', null) : React.createElement(
				'div',
				{ className: 'optionDetail' },
				React.createElement(
					'div',
					{ className: 'optionHeader' },
					React.createElement(
						'span',
						null,
						voteoptiondata.headshowlabel + ":" + voteoptiondata.optioncontent
					)
				),
				React.createElement(
					'div',
					{ className: 'userGroupInfo' },
					React.createElement(
						'div',
						{ className: 'userHeader' },
						React.createElement(
							'span',
							null,
							voteoptiondata.voteoptionpersonlabel
						)
					),
					React.createElement(
						'div',
						{ className: 'userGroup' },
						voteoptiondata.optioncanviewvoteuser == '1' ? voteUserItems : ''
					)
				),
				React.createElement(
					'div',
					{ className: 'zDialog_div_bottom' },
					React.createElement('input', { type: 'button', value: '\u5173\u95ED', className: 'zd_btn_cancle', onClick: this.closeDialog })
				)
			);
		}
	});
	Main = createForm()(Main);
	exports["default"] = Main;

/***/ },
/* 86 */
/***/ function(module, exports, __webpack_require__) {

	// style-loader: Adds some css to the DOM by adding a <style> tag
	
	// load the styles
	var content = __webpack_require__(87);
	if(typeof content === 'string') content = [[module.id, content, '']];
	// add the styles to the DOM
	var update = __webpack_require__(89)(content, {});
	if(content.locals) module.exports = content.locals;
	// Hot Module Replacement
	if(false) {
		// When the styles change, update the <style> tags
		if(!content.locals) {
			module.hot.accept("!!./node_modules/css-loader/index.js!./index.css", function() {
				var newContent = require("!!./node_modules/css-loader/index.js!./index.css");
				if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
				update(newContent);
			});
		}
		// When the module is disposed, remove the <style> tags
		module.hot.dispose(function() { update(); });
	}

/***/ },
/* 87 */
/***/ function(module, exports, __webpack_require__) {

	exports = module.exports = __webpack_require__(88)();
	// imports
	
	
	// module
	exports.push([module.id, ".ant-advanced-search-form {\r\n  padding: 16px 8px;\r\n  background: #f8f8f8;\r\n  border: 1px solid #d9d9d9;\r\n  border-radius: 6px;\r\n  margin: 8px;\r\n}\r\n\r\n/* 由于输入标签长度不确定，所以需要微调使之看上去居中 */\r\n.ant-advanced-search-form > .ant-row {\r\n  position: relative;\r\n  left: -6px;\r\n}\r\n\r\n.ant-advanced-search-form .ant-btn + .ant-btn {\r\n  margin-left: 8px;\r\n}\r\n\r\n.code-box-demo .ant-row {\r\n  margin-left: -8px;\r\n  margin-right: -8px;\r\n}\r\n.code-box-demo .ant-row > div {\r\n  padding: 0 8px;\r\n}\r\n\r\n.code-box-demo .ant-card {\r\n\tmargin-bottom: 16px;\r\n}\r\n\r\n.ant-form-item {\r\n  margin-bottom:8px !important;\r\n}\r\n\r\n.salary-table th {\r\n  text-align: right;\r\n  padding-right:10px;\r\n}\r\n\r\n.salary-table td {\r\n  text-align: left; \r\n  padding-left:10px;\r\n}", ""]);
	
	// exports


/***/ },
/* 88 */
/***/ function(module, exports) {

	/*
		MIT License http://www.opensource.org/licenses/mit-license.php
		Author Tobias Koppers @sokra
	*/
	// css base code, injected by the css-loader
	module.exports = function() {
		var list = [];
	
		// return the list of modules as css string
		list.toString = function toString() {
			var result = [];
			for(var i = 0; i < this.length; i++) {
				var item = this[i];
				if(item[2]) {
					result.push("@media " + item[2] + "{" + item[1] + "}");
				} else {
					result.push(item[1]);
				}
			}
			return result.join("");
		};
	
		// import a list of modules into the list
		list.i = function(modules, mediaQuery) {
			if(typeof modules === "string")
				modules = [[null, modules, ""]];
			var alreadyImportedModules = {};
			for(var i = 0; i < this.length; i++) {
				var id = this[i][0];
				if(typeof id === "number")
					alreadyImportedModules[id] = true;
			}
			for(i = 0; i < modules.length; i++) {
				var item = modules[i];
				// skip already imported module
				// this implementation is not 100% perfect for weird media query combinations
				//  when a module is imported multiple times with different media queries.
				//  I hope this will never occur (Hey this way we have smaller bundles)
				if(typeof item[0] !== "number" || !alreadyImportedModules[item[0]]) {
					if(mediaQuery && !item[2]) {
						item[2] = mediaQuery;
					} else if(mediaQuery) {
						item[2] = "(" + item[2] + ") and (" + mediaQuery + ")";
					}
					list.push(item);
				}
			}
		};
		return list;
	};


/***/ },
/* 89 */
/***/ function(module, exports, __webpack_require__) {

	/*
		MIT License http://www.opensource.org/licenses/mit-license.php
		Author Tobias Koppers @sokra
	*/
	var stylesInDom = {},
		memoize = function(fn) {
			var memo;
			return function () {
				if (typeof memo === "undefined") memo = fn.apply(this, arguments);
				return memo;
			};
		},
		isOldIE = memoize(function() {
			return /msie [6-9]\b/.test(window.navigator.userAgent.toLowerCase());
		}),
		getHeadElement = memoize(function () {
			return document.head || document.getElementsByTagName("head")[0];
		}),
		singletonElement = null,
		singletonCounter = 0;
	
	module.exports = function(list, options) {
		if(false) {
			if(typeof document !== "object") throw new Error("The style-loader cannot be used in a non-browser environment");
		}
	
		options = options || {};
		// Force single-tag solution on IE6-9, which has a hard limit on the # of <style>
		// tags it will allow on a page
		if (typeof options.singleton === "undefined") options.singleton = isOldIE();
	
		var styles = listToStyles(list);
		addStylesToDom(styles, options);
	
		return function update(newList) {
			var mayRemove = [];
			for(var i = 0; i < styles.length; i++) {
				var item = styles[i];
				var domStyle = stylesInDom[item.id];
				domStyle.refs--;
				mayRemove.push(domStyle);
			}
			if(newList) {
				var newStyles = listToStyles(newList);
				addStylesToDom(newStyles, options);
			}
			for(var i = 0; i < mayRemove.length; i++) {
				var domStyle = mayRemove[i];
				if(domStyle.refs === 0) {
					for(var j = 0; j < domStyle.parts.length; j++)
						domStyle.parts[j]();
					delete stylesInDom[domStyle.id];
				}
			}
		};
	}
	
	function addStylesToDom(styles, options) {
		for(var i = 0; i < styles.length; i++) {
			var item = styles[i];
			var domStyle = stylesInDom[item.id];
			if(domStyle) {
				domStyle.refs++;
				for(var j = 0; j < domStyle.parts.length; j++) {
					domStyle.parts[j](item.parts[j]);
				}
				for(; j < item.parts.length; j++) {
					domStyle.parts.push(addStyle(item.parts[j], options));
				}
			} else {
				var parts = [];
				for(var j = 0; j < item.parts.length; j++) {
					parts.push(addStyle(item.parts[j], options));
				}
				stylesInDom[item.id] = {id: item.id, refs: 1, parts: parts};
			}
		}
	}
	
	function listToStyles(list) {
		var styles = [];
		var newStyles = {};
		for(var i = 0; i < list.length; i++) {
			var item = list[i];
			var id = item[0];
			var css = item[1];
			var media = item[2];
			var sourceMap = item[3];
			var part = {css: css, media: media, sourceMap: sourceMap};
			if(!newStyles[id])
				styles.push(newStyles[id] = {id: id, parts: [part]});
			else
				newStyles[id].parts.push(part);
		}
		return styles;
	}
	
	function createStyleElement() {
		var styleElement = document.createElement("style");
		var head = getHeadElement();
		styleElement.type = "text/css";
		head.appendChild(styleElement);
		return styleElement;
	}
	
	function createLinkElement() {
		var linkElement = document.createElement("link");
		var head = getHeadElement();
		linkElement.rel = "stylesheet";
		head.appendChild(linkElement);
		return linkElement;
	}
	
	function addStyle(obj, options) {
		var styleElement, update, remove;
	
		if (options.singleton) {
			var styleIndex = singletonCounter++;
			styleElement = singletonElement || (singletonElement = createStyleElement());
			update = applyToSingletonTag.bind(null, styleElement, styleIndex, false);
			remove = applyToSingletonTag.bind(null, styleElement, styleIndex, true);
		} else if(obj.sourceMap &&
			typeof URL === "function" &&
			typeof URL.createObjectURL === "function" &&
			typeof URL.revokeObjectURL === "function" &&
			typeof Blob === "function" &&
			typeof btoa === "function") {
			styleElement = createLinkElement();
			update = updateLink.bind(null, styleElement);
			remove = function() {
				styleElement.parentNode.removeChild(styleElement);
				if(styleElement.href)
					URL.revokeObjectURL(styleElement.href);
			};
		} else {
			styleElement = createStyleElement();
			update = applyToTag.bind(null, styleElement);
			remove = function() {
				styleElement.parentNode.removeChild(styleElement);
			};
		}
	
		update(obj);
	
		return function updateStyle(newObj) {
			if(newObj) {
				if(newObj.css === obj.css && newObj.media === obj.media && newObj.sourceMap === obj.sourceMap)
					return;
				update(obj = newObj);
			} else {
				remove();
			}
		};
	}
	
	var replaceText = (function () {
		var textStore = [];
	
		return function (index, replacement) {
			textStore[index] = replacement;
			return textStore.filter(Boolean).join('\n');
		};
	})();
	
	function applyToSingletonTag(styleElement, index, remove, obj) {
		var css = remove ? "" : obj.css;
	
		if (styleElement.styleSheet) {
			styleElement.styleSheet.cssText = replaceText(index, css);
		} else {
			var cssNode = document.createTextNode(css);
			var childNodes = styleElement.childNodes;
			if (childNodes[index]) styleElement.removeChild(childNodes[index]);
			if (childNodes.length) {
				styleElement.insertBefore(cssNode, childNodes[index]);
			} else {
				styleElement.appendChild(cssNode);
			}
		}
	}
	
	function applyToTag(styleElement, obj) {
		var css = obj.css;
		var media = obj.media;
		var sourceMap = obj.sourceMap;
	
		if(media) {
			styleElement.setAttribute("media", media)
		}
	
		if(styleElement.styleSheet) {
			styleElement.styleSheet.cssText = css;
		} else {
			while(styleElement.firstChild) {
				styleElement.removeChild(styleElement.firstChild);
			}
			styleElement.appendChild(document.createTextNode(css));
		}
	}
	
	function updateLink(linkElement, obj) {
		var css = obj.css;
		var media = obj.media;
		var sourceMap = obj.sourceMap;
	
		if(sourceMap) {
			// http://stackoverflow.com/a/26603875
			css += "\n/*# sourceMappingURL=data:application/json;base64," + btoa(unescape(encodeURIComponent(JSON.stringify(sourceMap)))) + " */";
		}
	
		var blob = new Blob([css], { type: "text/css" });
	
		var oldSrc = linkElement.href;
	
		linkElement.href = URL.createObjectURL(blob);
	
		if(oldSrc)
			URL.revokeObjectURL(oldSrc);
	}


/***/ },
/* 90 */
/***/ function(module, exports, __webpack_require__) {

	// style-loader: Adds some css to the DOM by adding a <style> tag
	
	// load the styles
	var content = __webpack_require__(91);
	if(typeof content === 'string') content = [[module.id, content, '']];
	// add the styles to the DOM
	var update = __webpack_require__(89)(content, {});
	if(content.locals) module.exports = content.locals;
	// Hot Module Replacement
	if(false) {
		// When the styles change, update the <style> tags
		if(!content.locals) {
			module.hot.accept("!!./../node_modules/css-loader/index.js!./vote.css", function() {
				var newContent = require("!!./../node_modules/css-loader/index.js!./vote.css");
				if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
				update(newContent);
			});
		}
		// When the module is disposed, remove the <style> tags
		module.hot.dispose(function() { update(); });
	}

/***/ },
/* 91 */
/***/ function(module, exports, __webpack_require__) {

	exports = module.exports = __webpack_require__(88)();
	// imports
	
	
	// module
	exports.push([module.id, "/*votelist-css-start*/\r\n.votelistdiv{\r\n\tpadding:10px 0;\r\n}\r\n.votelistdiv .votelistsearchdiv{\r\n\tposition:fixed;\r\n\tbackground-color:#ffffff;\r\n\twidth:100%;\r\n\tz-index:999;\r\n\tpadding-right: 6px;\r\n}\r\n.votelistdiv .votelistsearchdiv .votelistsearchflexdiv{\r\n\tpadding-left:14px;\r\n\tdisplay:flex;\r\n}\r\n.votelistdiv .votelistshowdiv{\r\n\tmargin-top: 30px;\r\n\theight:520px;\r\n\toverflow:auto;\r\n}\r\n.votethemsearch,.votethemsearch  > .wea-input-focus{\r\n\twidth:100%;\r\n}\r\n.votethemsearch .wea-input-focus> .wea-input-focus-btn{\r\n\ttop:3px;\r\n}\r\n.votethemsearch   .wea-input-focus .ant-input{\r\n\theight:34px;\r\n}\r\n.votethemsearch .wea-input-focus .ant-input-wrapper>input{\r\n\tborder-color: #e2e2e2 !important;\r\n}\r\n.votethemsearch .wea-input-focus .ant-input-wrapper>input{\r\n\tborder-color: #e2e2e2 !important;\r\n}\r\n.votethemsearch .anticon-search{\r\n\tfont-size:14px;\r\n\tcolor: gray;\r\n}\r\n.publicBtnDiv{\r\n\twidth:100px;\r\n}\r\n.publicBtn{\r\n\tmargin-left:10px;\r\n\twidth:78px;\r\n}\r\n.publicBtn > .ant-btn-primary{\r\n\tborder-radius: 4px;\r\n\tborder: none;\r\n    padding: 8px 13px;\r\n\tbackground-color:transparent;\r\n}\r\n.novoteinfo {\r\n\ttext-align: center;\r\n\tfont-size:12px;\r\n\tcolor:#a5a5a5;\r\n\tpadding-top:100px;\r\n}\r\n.votelistdiv .votelistshowdiv .listUnitStyle{\r\n\tpadding: 8.5px 0;\r\n\tborder-bottom : 1px solid #dddddd;\r\n\tdisplay : flex;\r\n\tjustify-content : space-between;\r\n\talign-items : center;\r\n\tpadding-left:24px;\r\n\tpadding-right:20px\r\n}\r\n.votelistdiv .votelistshowdiv .listUnitStyle:hover{\r\n\tbackground-color:#f0f0f0;\r\n}\r\n\r\n.votelistdiv .votelistdeleteimage{\r\n\tcursor:pointer;\r\n\tposition:relative;\r\n\tright:10px;\r\n}\r\n.ant-confirm-confirm{\r\n\twidth:300px!important;\r\n\tmargin:auto;\r\n}\r\n/*votelist-css-end*/\r\n\r\n/*startvote-css-start*/\r\n.checkboxblock .ant-checkbox-wrapper{\r\n\tdisplay:flex;\r\n\tpadding-right: 72px!important;\r\n}\r\n.checkboxblock label{\r\n\tmargin:8px;\r\n\tbackground-color:#f0f0f0;\r\n}\r\n.checkboxblock .ant-radio-group{\r\n\twidth:100%;\r\n}\r\n.checkboxblock .ant-radio-wrapper ,.checkboxblock .ant-checkbox-wrapper{\r\n\theight:auto!important;\r\n\tline-height:32px!important;\r\n\tpadding-right: 100px;\t\r\n}\r\n.checkboxblock .ant-radio-wrapper .ant-radio,.checkboxblock .ant-checkbox-wrapper .ant-checkbox{\r\n\tfloat: left;\r\n    margin: 10px 0px 0px 6px;\r\n}\r\n.checkboxblock .ant-radio-wrapper .showoptioncontent,.checkboxblock .ant-checkbox-wrapper .showoptioncontent{\r\n\tword-break: break-all;\r\n    display: inline-block;\r\n    white-space: normal;\r\n}\r\n.checkboxblock .ant-radio-wrapper .showvotecount,.checkboxblock .ant-checkbox-wrapper .showvotecount{\r\n    position: absolute;\r\n    right: 10px;\t\r\n}\r\n.ant-confirm .ant-confirm-btns{\r\n\tfloat: none;\r\n    text-align: center;\r\n}\r\n.buttondiv {\r\n\ttext-align:center;\r\n\tborder-top: 1px solid #dddddd;\r\n}\r\n.buttondiv  button{\r\n\twidth:150px;\r\n\theight:34px;\r\n\tmargin-bottom:-25px;\r\n\tpadding-left:60px;\r\n}\r\n/*startvote-css-end*/\r\n\r\n/*publishvote-css-start*/\r\n.publishvoteformdiv{\r\n\tpadding-top:20px;\r\n\theight:440px;\r\n\toverflow:hidden;\r\n}\r\n.publishvoteformdiv .ant-form-item{\r\n\tdisplay:flex;\r\n}\r\n.publishvoteformdiv .votethemediv{\r\n\tdisplay:flex;\r\n}\r\n.publishvoteformdiv .ant-form-item-label{\r\n\twidth:125px;\r\n\tpadding-right:4px;\r\n}\r\n.publishvoteformdiv  .votethemetextarea{\r\n\twidth:412px;\r\n\theight:62px;\r\n}\r\n.publishvoteformdiv .ant-upload{\r\n\twidth:62px;\r\n\theight:62px;\r\n\tpadding:0px;\r\n}\r\n.publishvoteformdiv .ant-form-item{\r\n\tmargin-right:10px;\r\n}\r\n.publishvoteformdiv .ant-upload-list-item{\r\n\tpadding:0px;\r\n\theight:62px;\r\n\twidth:62px;\r\n}\r\n.publishvoteformdiv  .ant-input-wrapper .ant-input {\r\n\twidth:412px !important;\r\n}\r\n.publishvoteformdiv .ant-calendar-range-picker{\r\n\twidth:116px;\r\n}\r\n.publishvoteformdiv .ant-time-picker-input{\r\n\twidth:80px;\r\n\tmargin-left:10px;\r\n}\r\n.publishvoteformdiv  .uploadthemeimage{\r\n\tcolor:#bebebe;\r\n\tdisplay: flex;\r\n    justify-content: center;\r\n    align-items: center;\r\n    height: 62px\r\n}\r\n.publishvoteformdiv  .uploadthemeimage span{\r\n\tdisplay: inline-block;\r\n\twidth:35px;\r\n\tword-break:break-all;\r\n\tline-height:16px;\r\n}\r\n.clearfix .ant-upload-list-item-info span a{\r\n\tpointer-events: auto!important;\r\n}\r\n#publishform .ant-col-6 .ant-form-item-label label{\r\n\tfont-size:14px;\r\n}\r\n\r\n.requiredStar .ant-form-item-label label:before{\r\n\tdisplay: inline-block;\r\n    margin-right: 4px;\r\n    content: \"*\";\r\n    font-family: SimSun;\r\n    font-size: 12px;\r\n    color: #f50;\r\n} \r\n.maxOptionsNum .ant-input-number-input-wrap,.maxOptionsNum .ant-input-number-input{\r\n\theight:100%;\r\n\tline-height:100%;\r\n}\r\n.zDialog_div_bottom{\r\n\tpadding-top:5px!important;\r\n\tpadding-bottom:5px!important;\r\n\tbackground-color:#FAFAFA;\r\n\tz-index:3;\r\n\tbottom:0;\r\n\twidth:100%;\r\n\tborder:none;\r\n\tborder-top:1px solid #dadedb;\r\n\tposition:absolute;\r\n\theight:40px;\r\n}\r\n.zd_btn_cancle, .zd_btn_submit{\r\n\tcolor:#3597f2;\r\n\tpadding-left:18px;\r\n\tpadding-right:18px;\t\r\n\tfont-size:14px;\r\n\tcursor:pointer;\r\n\tposition:relative;\r\n\ttop:0px;\r\n\tvertical-align:middle;\r\n\tborder:none;\r\n\tbackground-color:transparent;\r\n\toutline:none;\r\n\theight:30px;\r\n}\r\n.zd_btn_submit:hover,.zd_btn_cancle:hover{\r\n\tcolor: #FFFFFF;\r\n\tbackground-color: #2690E3;\r\n}\r\n.e8_sep_line{\r\n\tcolor:#cccccc;\r\n}\r\n\r\n/*publishvote-css-end*/\r\n\r\n/*votedetail-css-start*/\r\n.votingDetail{\r\n\tfont-size: 14px;\r\n}\r\n\r\n.votingDetail .dsTitle{\r\n\tbackground: #5cb5d8;\r\n\tcolor:#ffffff;\r\n\twidth:100%;\r\n}\r\n.votingDetail .dsTitle .setTitle{\r\n\tline-height: 35px;\r\n    padding-left: 6px;\r\n}\r\n.votingDetail .dsTitle .closeSlide{\r\n\tcursor:pointer;\r\n    margin-left: 319px;\r\n}\r\n.votingDetail .dsTitle .closeSlide:hover{\r\n\tbackground:red;\r\n}\r\n.votingDetail .dsTitle .votecloseSlide{\r\n\tcursor:pointer;\r\n    margin-left: 345px;\r\n}\r\n.votingDetail .dsTitle .votecloseSlide:hover{\r\n\tbackground:red;\r\n}\r\n.votingDetail .dCloseBtn{\r\n\tposition: absolute;\r\n    top: 5px;\r\n    right: 10px;\r\n    color: #B8B4B4;\r\n    font-size: 24px;\r\n    font-weight: bold;\r\n    cursor: pointer;\r\n    z-index: 1;\r\n}\r\n.votingDetail .dCloseBtn:hover{\r\n\tcolor:#fe4643\r\n}\r\n.detailHeader{\r\n\tdisplay: flex;\r\n\tjustify-content: space-between;\r\n\tline-height: 26px;\r\n}\r\n.detailHeader,.detailOptions,.voteuserGroupInfo{\r\n\tpadding: 12px;\r\n\tborder-bottom: 1px solid #dddddd;\r\n}\r\n.notvoteuserGroupInfo{\r\n\tpadding: 12px;\r\n}\r\n.detailHeader .headerTheme{\r\n\tword-break:break-all;\r\n\t\r\n}\r\n.detailHeader .headerTheme span{\r\n\tline-height: 26px;\r\n\tdisplay: inline-block;\r\n}\r\n.detailHeader .headerTheme .headerUserAndTime{\r\n\tcolor:#a5a5a5;\r\n\tfont-size: 12px;\r\n}\r\n.detailHeader .headerTime{\r\n\tmargin-left: 10px;\r\n}\r\n.detailHeader .headerRight{\r\n\twidth:40px;\r\n}\r\n.detailHeader .headerTheme span.headerStatus{\r\n\tcolor:#ffffff;\r\n\twhite-space : nowrap;\r\n\tpadding: 0 5.5px;\r\n\tline-height: 20px;\r\n\tbackground-color: #ff7d00;\r\n\tborder-radius: 2px;\r\n\tmargin-left: 10px;\r\n\tfont-size: 11px;\r\n}\r\n.detailHeader .headerRight .headerClose{\r\n\ttext-align: right;\r\n\tfont-size: 18px;\r\n\tcolor: #a5a5a5;\r\n}\r\n.detailHeader .headerTheme span.headerStatus.gary{\r\n\tbackground-color: #c9c9c9;\r\n\tfont-size: 11px;\r\n}\r\n.headerClose i:hover,.deleteVoting:hover,.userGroupInfo .moreUser:hover{\r\n\tcursor: pointer;\r\n\tcolor: #000000;\r\n}\r\n.optionHeader .submitNumber{\r\n\tmargin-right:8px;\r\n}\r\n.optionvoteflag{\r\n    margin-left: 10px;\r\n\tmargin-bottom: -2px;\r\n}\r\n.detailOptions .optionHeader,.detailOptions .optionsFoot,.optionItems .optionUnit .optionContent,.userGroupInfo .userHeader{\r\n\tdisplay: flex;\r\n\tjustify-content: space-between;\r\n}\r\n.detailOptions .optionsFoot{\r\n\tpadding:10px 0;\r\n\tfont-size: 12px;\r\n\tcolor: #a5a5a5;\r\n}\r\n.detailOptions .optionHeader{\r\n\tpadding-bottom:10px;\r\n}\r\n.optionItems .optionUnit{\r\n\tbackground-color: #f0f0f0;\r\n\tline-height: 29px;\r\n\tmargin-bottom: 2px;\r\n\tfont-size: 12px;\r\n}\r\n.optionItems .optionUnit .percentLine{\r\n\theight: 3px;\r\n\twidth:0px;\r\n\tbackground-color: #72b9ff;\r\n}\r\n.optionItems .optionUnit .optionContent .optionLeft{\t\r\n\twidth:50px;\r\n\tline-height: 31px;\r\n}\r\n.optionItems .optionUnit .optionContent .optionRight{\r\n\ttext-align: right;\r\n\twhite-space: nowrap;\r\n\tpadding:0 10px;\r\n\twidth:50px;\r\n}\r\n.optionItems .optionUnit .optionContent .optionCenter{\r\n\twidth:100%;\r\n}\r\n\r\n.userGroupInfo{\r\n\tfont-size: 12px;\r\n\tcolor: #333333;\r\n}\r\n.userGroupInfo .userGroup{\r\n\tpadding-top:9px;\r\n\tdisplay: flex;\r\n}\r\n.userGroupInfo .userGroup .userInfo{\r\n\tpadding-left: 9px;\r\n}\r\n.userGroupInfo .userGroup .userInfo .userImage img{\r\n\twidth:40px;\r\n\theight: 40px;\r\n\tborder-radius: 20px;\r\n}\r\n.userGroupInfo .userGroup .userInfo .userName{\r\n\ttext-align: center;\r\n}\r\n.votethemeshow{\r\n\tcursor:pointer;\r\n\toverflow: hidden;\r\n}\r\n.votethemeshow .votethemeimage{\r\n\tmax-width: 100%;\r\n}\r\n/*votedetail-css-end*/\r\n/*vote-showpersondetail-css-start*/\r\n.groupUserHeader{\r\n\tdisplay: flex;\r\n\tfont-size: 16px;\r\n\tcolor: #333333;\r\n\tborder-bottom: 1px solid #e2e2e2;\r\n}\r\n\r\n.groupUserLabel{\r\n\theight: 57px;\r\n\tline-height: 35px;\r\n\tmargin-left: -1px;\r\n}\r\n.groupUserIcon{\r\n\tmargin: 6px 6px 0px 6px;\r\n}\r\n.groupUserIcon img{\r\n\tmargin-top: 1px;\r\n}\r\n.searchgroupuserdiv{\r\n\tpadding-left: 338px;\r\n}\r\n.searchgroupuserdiv .searchInputSpan{\r\n\tborder: 1px solid #F5F2F2;\r\n    display: inline-block;\r\n    top: 28px;\r\n    line-height: 21px;\r\n}\r\n.searchgroupuserdiv .searchInputSpan:hover{\r\n\tborder: 1px solid #DADADA;\r\n}\r\n.searchgroupuserdiv .searchInput {\r\n    border: none;\r\n\theight:21px;\r\n\twidth: 70px;\r\n\tfont-size:14px;\r\n}\r\n.searchgroupuserdiv .searchInput:focus{\r\n\toutline:none;\r\n}\r\n.searchgroupuserdiv .searchImg {\r\n    display: inline;\r\n    cursor: pointer;\r\n    padding-left: 5px !important;\r\n    padding-right: 5px !important;\r\n}\t\r\n.groupUserBody .ant-table-tbody>tr>td,.groupUserBody .ant-table-thead>tr>th{\r\n\tpadding: 0px 5px 0px 12px;\r\n\t/*text-align: center;*/\r\n\theight: 31px;\r\n\tline-height: 29px;\r\n\tfont-size: 12px;\r\n\tfont-weight: normal;\r\n\tcolor: #333333;\r\n}\r\n.groupUserBody .ant-table-thead>tr>th{\r\n\tbackground: #f2f2f2;\r\n\tborder-bottom: 2px solid #B7E0FE;\r\n}\r\n\r\n.groupUserBody  .ant-table,.groupUserBody  .ant-table table{\r\n\tborder-radius:0px;\r\n}\r\n.groupUserList .zDialog_div_bottom,.optionDetail .zDialog_div_bottom{\r\n\ttext-align: center;\r\n}\r\n.e8_outbox{\r\n\ttop:19px!important;\r\n}\r\n\r\n\r\n\r\n\r\n\r\n/*vote-showpersondetail-css-end*/\r\n\r\n/*vote-optiondetail-css-start*/\r\n.optionDetail .optionHeader{\r\n\tpadding: 12px;\r\n\tfont-size:14px;\r\n\tfont-weight:bold;\r\n\tborder-bottom: 1px solid #e2e2e2;\r\n}\r\n.optionDetail .userGroupInfo{\r\n\tborder-bottom: none;\r\n}\r\n.optionHeader .headerClose{\r\n\tdisplay:inline-block;\r\n\tfloat:right;\r\n\tcolor:#a5a5a5;\r\n}\r\n.optionDetail .userGroupInfo .userHeader{\r\n\tmargin-left:10px;\r\n\tpadding-top: 11px;\r\n}\r\n/*vote-optiondetail-css-end*/\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n.votelistsearchdiv .wea-input-focus> .wea-input-focus-btn{\r\n\theight:100%;\r\n}", ""]);
	
	// exports


/***/ }
/******/ ]);