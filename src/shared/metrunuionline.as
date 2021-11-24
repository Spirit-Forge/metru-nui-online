var self = this;

var truthy = function(v) {
	return typeof(v) === "string" ? !!v.length : !!v;
};
var defined = function(v) {
	var undef;
	return v !== null && v !== undef;
};
var replace = function(s, f, r) {
	return s.split(f).join(r);
};
var forEach = function(a, f) {
	for (var i = 0, l = a.length; i < l; i++) {
		f(a[i], i);
	}
};
var forKeys = function(o, cb) {
	for (var k in o) {
		if (o.hasOwnProperty(k)) {
			cb(k, o[k]);
		}
	}
};
var xmlEntitiesList = [
	["&", "&amp;"],
	["<", "&lt;"],
	[">", "&gt;"],
	["\"", "&quot;"],
	["'", "&apos;"]
];
var xmlEscape = function(s) {
	forEach(xmlEntitiesList, function(repl) {
		s = replace(s, repl[0], repl[1]);
	});
	return s;
};
var xmlFindNode = function(node, nodeName) {
	var children = node.childNodes;
	for (var i = 0; i < children.length; i++) {
		var child = children[i];
		if (child.nodeName === nodeName) {
			return child;
		}
		var found = xmlFindNode(child, nodeName);
		if (found) {
			return found;
		}
	}
	return null;
};

// Response tags.
var playerStatusTags = ["<playerStatus>", "</playerStatus>"];
var resultsetTags = ["<resultset>", "</resultset>"];
var resultTags = ["<result>", "</result>"];

// Save API.
var save = Array(function() {
	var setting = LSO ?
		Array(function() {
			// Get fresh each use, avoids stale object issues.
			var getSO = function() {
				return SharedObject.getLocal("metru-nui-online", "/");
			};
			return function(key, clean) {
				// Keep value in memory, only need to write.
				var stored = getSO().data[key];
				return {
					get: function() {
						return truthy(stored) ? stored : clean;
					},
					set: function(value) {
						var so = getSO();
						so.data[key] = stored = value;
						so.flush();
					},
					clear: function() {
						this.set(clean);
					},
					clean: function() {
						return clean;
					}
				};
			};
		})[0]() :
		Array(function() {
			var pre = "menol_";
			var fsCmd = function(key, value) {
				// A fscommand function call is compiled to getURL.
				getURL("FSCommand:" + pre + key, value);
			};
			var swfVar = function(key) {
				return _root[pre + key];
			};
			return function(key, clean) {
				// Keep value in memory, only need to write.
				var stored = swfVar(key);
				return {
					get: function() {
						return truthy(stored) ? stored : clean;
					},
					set: function(value) {
						stored = value;
						fsCmd(key, stored);
					},
					clear: function() {
						this.set(clean);
					},
					clean: function() {
						return clean;
					}
				};
			};
		})[0]();
	return {
		status: setting("status", playerStatusTags.join(""))
	};
})[0]();

// Setup API exposed to the game.
var setupApi = function() {
	// List of variables in the order they must be printed.
	var variables = [
		["location", ""],     // 2
		["prevLocation", ""], // 3
		["colors", ""],       // 4
		["items", ""],        // 5
		["energy", "0"],      // 6
		["disks", "0"],       // 7
		["username", ""],     // 0
		["password", ""],     // 1
		["widgets", "0"],     // 8
		["currentZone", ""],  // 9
		["akiliniDisks", ""], // 10
		["hoverDisk", "0"],   // 11
		["anarchist", "0"],   // 12
		["idealist", "0"],    // 13
		["airship", "0"],     // 14
		["akilini", "0"],     // 15
		["gamesWon", "0"],    // 16
		["temple", "0"],      // 17
		["tournament", "0"],  // 18
		["email", ""],        // 19
		["birthday", ""]      // 20
	];
	var forEachVariable = function(cb) {
		forEach(variables, function(kv) {
			cb(kv[0], kv[1]);
		});
	};
	var statusCreate = function() {
		var r = {};
		forEachVariable(function(k, v) {
			r[k] = v;
		});
		return r;
	};
	var statusReadXml = function(state, xmlstr) {
		var doc = new XML();
		doc.parseXML(xmlstr);
		var root = doc.firstChild;
		forEachVariable(function(k) {
			var node = xmlFindNode(root, k);
			if (!node) {
				return;
			}
			var firstChild = node.firstChild;
			var value = firstChild ? firstChild.nodeValue : null;
			state[k] = defined(value) ? value : "";
		});
	};
	var statusToXml = function(state) {
		var tags = [];
		forEachVariable(function(k, v) {
			// Tag order is important, must have all tags.
			v = state.hasOwnProperty(k) ? state[k] : v;
			tags.push("<" + k + ">" + xmlEscape(v) + "</" + k + ">");
		});
		return playerStatusTags.join(tags.join(""));
	};

	var queryRemoveUsername = function(query) {
		// Game does not encode username and password correctly.
		// The password was modified to a fixed string, which can be ignored.
		// Anything after first username= and before last &password= is name.
		var usernameParam = "username=";
		var usernameI = query.indexOf(usernameParam);
		if (usernameI < 0) {
			return ["", query];
		}
		var usernameE = query.lastIndexOf("&password=");
		usernameE = usernameE < usernameI ? query.length : usernameE;
		return [
			query.substring(usernameI + usernameParam.length, usernameE),
			query.substring(0, usernameI) + query.substring(usernameE)
		];
	};
	var queryParse = function(url) {
		var query = url.split("?").slice(1).join("?");
		var usernameAndQuery = queryRemoveUsername(query);
		var r = {};
		forEach(usernameAndQuery[1].split("&"), function(s) {
			var parts = s.split("=");
			if (parts.length < 2) {
				return;
			}
			r[parts[0]] = parts[1];
		});
		r.username = usernameAndQuery[0];
		r.password = "";
		return r;
	};

	// Custom handlers to replace PHP scripts.
	var actions = {};
	actions["XML/checkStatus.php"] = function(url) {
		var state = statusCreate();
		forKeys(queryParse(url), function(k, v) {
			state[k] = v;
		});
		return resultTags.join(truthy(state.username));
	};
	actions["XML/setStatus.php"] = function(url) {
		var state = statusCreate();
		statusReadXml(state, save.status.get());
		forKeys(queryParse(url), function(k, v) {
			state[k] = v;
		});
		save.status.set(statusToXml(state));
		return resultsetTags.join("");
	};
	actions["XML/getStatus.php"] = function(url) {
		var state = {};
		statusReadXml(state, save.status.get());

		// Check if a user is saved or not.
		if (! truthy(state.username)) {
			// Output an empty status.
			return playerStatusTags.join("");
		}

		// Set the magic password in the response data.
		state.password = "password";
		return statusToXml(state);
	};
	actions["XML/insertUser.php"] = function(url) {
		var state = statusCreate();
		forKeys(queryParse(url), function(k, v) {
			state[k] = v;
		});

		// Defaults from insertUser.php file.
		state.location = "chute";
		state.prevLocation = "elsewhere";
		state.currentZone = "z_moto_hub";
		state.energy = "100";
		state.hoverDisk = "111";
		state.widgets = "30";
		state.items = "3,3,3,27,27";

		save.status.set(statusToXml(state));
		return resultsetTags.join("");
	};

	_global.__menol = {
		loaderXML: function(obj, url) {
			var path = url.split("?")[0];
			if (actions.hasOwnProperty(path)) {
				var response = actions[path](url);
				var success = truthy(response);
				if (success) {
					obj.parseXML(response);
				}
				obj.onLoad(success);
			}
			else {
				obj.load(url);
			}
		}
	};
};

var player = function() {
	loadMovie("player.swf", "_level0");
};

var main = function() {
	setupApi();
	player();
};

main();
