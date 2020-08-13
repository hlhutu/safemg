//document.oncontextmenu = function() {
//	return false;
//}

window.onerror = function(message, url, line, column, error) {
	console.error(error);
}

String.prototype.startWith = function(str) {
	var reg = new RegExp("^" + str);
	return reg.test(this);
}

String.prototype.endWith = function(str) {
	var reg = new RegExp(str + "$");
	return reg.test(this);
}

Date.prototype.format = function(format) {
	var paddNum = function(num) {
		num += "";
		return num.replace(/^(\d)$/, "0$1");
	}
	var cfg = {
		yyyy : this.getFullYear(),
		MM : paddNum(this.getMonth() + 1), // 月 : 如果1位的时候补0
		dd : paddNum(this.getDate()),
		hh : paddNum(this.getHours()),
		mm : paddNum(this.getMinutes()),
		ss : paddNum(this.getSeconds())
	}
	format || (format = "yyyy-MM-dd hh:mm:ss");
	return format.replace(/([a-z])(\1)*/ig, function(m) {
		return cfg[m];
	});
}

function arrRemove(arr, val) {
	arr.splice($.inArray(val, arr), 1);
}

function getParameter(name, url) {
	if (!url) {
		url = document.location.toString();
	}
	var LocString = String(url);
	return (RegExp(name + '=' + '(.+?)(&|$)').exec(LocString) || [ , '' ])[1];
}

function getParameterObj(url) {
	if (!url) {
		url = document.location.search;
	}
	var obj = new Object();
	if (url.indexOf("?") != -1) {
		var str = url.substr(url.indexOf("?") + 1);
		strs = str.split("&");
		for (var i = 0; i < strs.length; i++) {
			obj[strs[i].split("=")[0]] = decodeURI(strs[i].split("=")[1]);
		}
	}
	return obj;
}

function getParameterStr(url) {
	if (!url) {
		url = document.location.search;
	}
	if (url.indexOf("?") != -1) {
		return url.substr(url.indexOf("?") + 1);
	}
	return "";
}

function ajax(param, callback) {
	if (!param || !param.url) {
		layer.msg("缺少必要参数！[url]", {
			icon : 3
		});
		return false;
	}
	layer.closeAll("loading");
	var i_ = layer.load(1);
	var doing = jQuery.ajax({
		url: param.url,
		data: param,
		type: param.type_ || "POST",
		dataType: param.dataType_ || "json",
		async: param.async_ == false ? false : true,
		timeout: 30000,
		success : function(result) {
			layer.close(i_);
			if (typeof callback === "function") {
				callback(result);
			} else {
				layer.msg("数据处理成功！", {
					icon : 1
				});
			}
		},
		error : function(result) {
			layer.close(i_);
			if (doing) {
				doing.abort();
			}
			var msg = "网络连接错误！";
			if (result && result.statusText == "timeout") {
				msg = "网络请求超时！";
			} else if (result && result.statusText == "parsererror") {
				msg = "解析数据错误！";
			} else if (result && result.status == "404") {
				msg = "接口不存在！";
			}
			if (typeof callback === "function") {
				var rs = new Object();
				rs.resCode = "error";
				rs.resMsg = msg;
				callback(rs);
			} else {
				layer.msg(msg, {
					icon : 2
				});
			}
		}
	});
}

function ajaxSubmit(form, param, callback) {
	if (!form) {
		layer.msg("缺少必要参数！[表单]", {
			icon : 3
		});
		return false;
	}
	var obj = new Object();
	if (param && !(typeof param === "function")) {
		obj = param;
	}
	layer.closeAll("loading");
	var i_ = layer.load(1);
	$(form).ajaxSubmit({
		data: obj,
		type: obj.type_ || "POST",
		dataType: obj.dataType_ || "json",
		async: obj.async_ == false ? false : true,
		timeout: 30000,
		success : function(result) {
			layer.close(i_);
			if (typeof param === "function") {
				param(result);
			} else if (typeof callback === "function") {
				callback(result);
			} else {
				layer.msg("数据处理成功！", {
					icon : 1
				});
			}
		},
		error : function(result) {
			layer.close(i_);
			var msg = "网络连接错误！";
			if (result && result.statusText == "timeout") {
				msg = "网络请求超时！";
			} else if (result && result.statusText == "parsererror") {
				msg = "解析数据错误！";
			} else if (result && result.status == "404") {
				msg = "接口不存在！";
			}
			if (typeof callback === "function") {
				var rs = new Object();
				rs.resCode = "error";
				rs.resMsg = msg;
				callback(rs);
			} else {
				layer.msg(msg, {
					icon : 2
				});
			}
		}
	});
}

function isNull(obj) {
	if (typeof (obj) == "undefined" || obj == "undefined" || !obj) {
		return true;
	}
	return false;
}

$.fn.serializeObj = function() {
	var obj = {};
	var data = this.serializeArray();
	$.each(data, function() {
		if (obj[this.name]) {
			if (!obj[this.name].push) {
				obj[this.name] = [ obj[this.name] ];
			}
			obj[this.name].push(this.value || "");
		} else {
			obj[this.name] = this.value || "";
		}
	});
	return obj;
}
