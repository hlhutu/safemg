<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/jquery.jeditable.js"></script>
<script>
	var selectUrl = "${ctx}/jsp/scyx/gdgl/select.do";
	var insertUrl = "${ctx}/jsp/scyx/gdgl/insert.do";
	var updateUrl = "${ctx}/jsp/scyx/gdgl/update.do";

	var selectMbglUrl = "${ctx}/jsp/scyx/mbgl/select.do";
	var insertMbglUrl = "${ctx}/jsp/scyx/mbgl/insert.do";
	
	var selectMbglInfoUrl = "${ctx}/jsp/scyx/mbglInfo/select.do";
	var updateMbglInfoUrl = "${ctx}/jsp/scyx/mbglInfo/update.do";
	
	var callbackUrl = "${ctx}/jsp/scyx/gdgl/callback.do";

	var selectmbUrl = "${ctx}/jsp/scyx/selectmb.do";
	
	var back = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };

	var obj = new Object();
	obj.pId = "${param.pId}";
	obj.pid = "${param.pId}";
	obj.taskId = "${param.taskId}";
	obj.node = "${param.node}";
	obj.folderId = "${myUser.user.extMap.sys.ext1}"; //公共目录

	$(window).ready(function() {
		$("#thisform")[0].reset();
		$("#bh").val(getBh());
		//console.log();
		display();

		if (obj.pId) {
			obj.url = selectUrl;
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					$("#thisform").fill(result.datas[0]);
					fillSelect("#thisform",result.datas[0]);
					display();
				}
			});

			if (obj.taskId) { // 待处理
				$("#thisform").attr("action", updateUrl);
				obj.userName = "${myUser.username}";
				if (!obj.userName) {
					layer.msg("缺少参数userName！");
					return;
				}
			}
		} else { //发起
			$("#thisform").attr("action", insertUrl);
			obj.pdId = "工单管理";
			if (!obj.pdId) {
				layer.msg("缺少参数pdId！");
				return;
			}
		}

		$(".action button").on("click", function() {
			try {
				obj.result = $(this).attr("result");
				if ("取消" == obj.result) {
					$("#thisform")[0].reset();
					if("0" == obj.node) {
						return doMessage(closeItem);
					} 
					return doMessage(back);
				}

				$("*", $("#thisform")).attr("disabled", false);
				var b = $("#thisform").validationEngine("validate");
				if (b && confirm("您确定要" + obj.result + "吗？")) {
					if("0" == obj.node) {
						obj.mbgl_info_size = table.api().data().length;
						obj.mbgl_info_list = JSON.stringify(table.api().data());
						if(0 == obj.mbgl_info_size) {
							layer.msg("操作详情无数据！");
							return;
						}
					}
					if('99' == '${param.node}' && 0 != table.api().data()[0].num) {
						layer.msg("请先完成所有操作项！");
						display();
						return;
					}
					
					ajaxSubmit("#thisform", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								shade : [ 0.1, "#fff" ] //独占
							}, function() {
								if("0" == obj.node) {
									return doMessage(closeItem);
								}
								return doMessage(back);
							});
						}
					});
				}
				display();
			} catch (e) {
			}
		});

		$('[class*="validate').attr("data-prompt-position", "topLeft");
		
		var visible0 = "0" == "${param.node}" ? true : false;
		var visible9 = "99" == "${param.node}" ? true : false;
		var visible_1 = "-1" == "${param.node}" ? true : false;
		var visible_2 = "${param.os_}" ? true : false;
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"paging": false,
			"scrollX": false,
			"ajax": {
				"dataSrc": "datas",
				"url": selectMbglInfoUrl,
				"data": function() {
					if("${param.pId}") {
						return {"pid": "${param.pId}"};
					}
					return {"pid": "------------"};
				} 
			},
			"columns": [ {
				"title":'<a id="a-plus" title="新增"><i class="fa fa-plus"></i></a>',
				"data":"id",
				"visible": visible0,
				"render": function (data, type, row) {
					return '<a title="删除"><i class="fa fa-remove a-remove"></i></a>';
				}
			}, {
				"className":"edit",
				"title":"序号",
				"data":"xh"
			}, {
				"className":"edit",
				"title":"执行项",
				"data":"zxxm"
			}, {
				"className":"edit",
				"title":"注意事项",
				"data":"zysx"
			}, {
				"title":"执行人",
				"data":"zxrDesc",
				"visible": (!visible_2 && (visible_1 || visible9))
			}, {
				"title":"执行时间",
				"data":"zxsj",
				"visible": visible_1
			}, {
				"title":"执行",
				"data":"id",
				"visible": visible9,
				"render": function (data, type, row) {
					if(row.zxsj) {
						return row.zxsj;
					}
					return '<a class="info" value="'+data+'" title="执行"><i class="fa fa-check"></i></a>';
				}
			}]
			,"drawCallback": function(s) {
				$(".info").off("click").on("click", function() {
					if (confirm("您确定完成了该操作吗？")) {
						var o = table.api().row($(this).parents('tr')).data();
						o.url = updateMbglInfoUrl;
						o.zxr = "${myUser.username}";
						o.zxsj = formatDate(new Date());
						ajax(o, function(result) {
							if ("error" == result.resCode) {
								layer.msg(result.resMsg);
							} else {
								table.api().ajax.reload();
								layer.msg("执行成功！");
							}
						});
					}
		       	});

				if("0" == "${param.node}") {
					$("#a-plus").off("click").on("click", function() {
						var length = table.api().data().length + 1;
						var v = {"xh":length, "zxxm":"执行项-"+length, "zysx":"注意事项-"+length}; 
						table.fnAddData(v); 
			       	});
					$(".a-remove").off("click").on("click", function() {
			    		table.api().row($(this).parents('tr')).remove().draw();
			       	});
					
					table.$('.edit').editable(callbackUrl, {
						type: 'textarea',
			          	onblur: 'submit',
			            tooltip: '可编辑',
					    indicator: '写入中...',
			            width: '100%',
			            height: '100%',
			            callback: function (value, settings) {
			            	var aPos = table.fnGetPosition(this);
			            	table.fnUpdate(value, aPos[0], aPos[1]);
			            },
			            onsubmit: function(settings, original) {
			            	var value = $(this).find('textarea').val();
			            	return $.trim(value) ? value : false;
			            }
			            /* ,submitdata: function (value, settings) {
			            	var c = ["c", "bh" , "qxlx", "qxlx", "qxlsx"];
			            	var aPos = table.fnGetPosition(this);
			            	var data = table.api().row(this).data();
			            	data.oldValue = value;
			            	data[c[aPos[1]]] = $(this).find('input').val();
			            	return data;
			            } */
			        });
				}
			}
		});
		
		$("#a-save").off("click").on("click", function() {
			var o = new Object();
			o.mbgl_info_size = table.api().data().length;
			o.mbgl_info_list = JSON.stringify(table.api().data());
			if(0 == o.mbgl_info_size) {
				layer.msg("操作详情无数据！");
				return;
			}
			o.glid = $("#gdlx").val();
			if(!o.glid) {
				layer.msg("请选择工单类型！");
				return;
			}
			$("#myModal").modal("show");

			$("#btn-ok").off("click").on("click", function() {
				var b = $("#editForm").validationEngine("validate");
				if (b && confirm("您确定要另存为模板数据吗？")) {
					o.url = insertMbglUrl;
					o.sys_id = "${myUser.user.sys.id}";
					o.modifier = "${myUser.username}";
					o.mbmc = $("#mbmc").val();
					o.status = "1";
					o.xh = "1";
					ajax(o, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("保存成功！");
							$("#myModal").modal("hide");
						}
					});
				}
			});
       	});

		$("#a-list").off("click").on("click", function() {
			$("#mbid").empty();
			var o = new Object();
			o.url = selectMbglUrl;
			o.sys_id = "${myUser.user.sys.id}";
			o.glid = $("#gdlx").val();
			o.status = "1";
			if(!o.glid) {
				layer.msg("请选择工单类型！");
				return;
			}
			ajax(o, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					result.datas = result.datas.sort(
						function compareFunction(o1,o2) {
							return o1.mbmc.localeCompare(o2.mbmc);
						}
					);
					$.each(result.datas, function(index, item) {
						$("#mbid").append('<option value="'+item.id+'">'+item.mbmc+'</option>');
					})
					
					$("#myModalmb").modal("show");
					$("#btn-okmb").off("click").on("click", function() {
						var b = $("#editFormmb").validationEngine("validate");
						if (b && confirm("您确定要导入模板数据吗？")) {
							o.url = selectMbglInfoUrl;
							o.glid = $("#mbid").val();
							ajax(o, function(res) {
								if ("error" == res.resCode) {
									layer.msg(res.resMsg);
								} else {
									table.api().clear().draw();
									$.each(res.datas, function(index, item) {
										table.fnAddData(item); 
									})
									$("#myModalmb").modal("hide");
								}
							});
						}
					});
				}
			});
       	});
		
		$(".report").on("click", function() {
			var pid = $(this).attr("value");
			var target = "${portal}/api/report/report.do?rid=57032f19-a447-48d0-99cd-10ad6aa513aa&pid="+encodeURI(pid);
			doMessage({action:"menuItem", name:"工作票", target: target});
       	});
	});

	//node：-1历史表单；0、新建任务；1、第一任务节点；99、结束任务节点
	var display = function() {
		var node = "${param.node}";
		
		$("*", $("#thisform")).attr("disabled", true);
		
		$("button", $(".action")).attr("disabled", false);
		$("button", $(".action")).hide();
		
		$("#desc", $("#thisform")).attr("disabled", false);
		$(".desc", $("#thisform")).hide();
		
		$("#file", $("#thisform")).hide();
		if ("0" == node || "1" == node) {
			$("*", $("#thisform")).attr("disabled", false);
			$(".btn-group1").show();
			$("#file").show();
		} else if ("-1" != node) {
			$(".btn-group3").show();
			$(".desc").show();
		}
		
		if("11" == node) {
			$("#qfr").val("${myUser.username}");
			$("#qfrDesc").val("${myUser.user.user_alias}");
			<%-- $("#qfsj").val("${s:getDate('')}");--%>
		}

		if ("99" == node) {
			$("#file").attr("disabled", false);
			$("#file", $("#thisform")).show();
			
			$("button[result='终止']").hide();
		}
	}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="thisform" class="form-horizontal" role="form" onsubmit="return false;">
						<%-- <c:if test="${empty param.os_}">
							<div class="ibox-title" align="center">
								<h5 style="float: none">
									<b>操作票</b>
								</h5>
							</div>
						</c:if> --%>

						<div class="ibox-content">
		                    <input type="text" id="id" name="id" style="display:none"/>
		                    <input type="text" id="status" name="status" style="display: none;">
		                    <input type="text" id="pdid" name="pdid" style="display: none;">
							
							<div class="form-group">
								<div class="col-sm-12">
									<fieldset>
										<legend><b>工单信息（<a class="report" value="${param.pId}">打印</a>）</b></legend>
									</fieldset>
								</div>
							</div>
							
							<div class="form-group">
								<label class="col-sm-2 control-label">编号</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required]" name="bh" id="bh" readonly="readonly" >
								</div>
								<label class="col-sm-2 control-label">工单名称</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required]" name="gdmc" id="gdmc">
								</div>
							</div>

							<div class="form-group">
								<label class="col-sm-2 control-label">工单类型</label>
								<div class="col-sm-4">
									<s:dict dictType="gdlx" clazz="input-sm form-control validate[required]"></s:dict>
								</div>
								<label class="col-sm-2 control-label">执行人</label>
								<div class="col-sm-4">
									<%-- <s:user name="zxr" sysId="${myUser.user.sys.id}" title="该选项如为空，申请人将默认为工单执行人" clazz="input-sm form-control selectpicker multiple"></s:user> --%>
								</div>
								<!-- <label class="col-sm-6 control-label" style="text-align:left">注意：该选项如为空，申请人将默认为工单执行人</label> -->
							</div>

							<div class="form-group">
								<label class="col-sm-2 control-label">申请人</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required]" name="sqrDesc" id="sqrDesc" readonly="readonly" value="${myUser.user.user_alias}">
									<input type="text" name="sqr" id="sqr" value="${myUser.username}" style="display: none;">
								</div>
								<label class="col-sm-2 control-label">申请时间</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required] date_select" name="sqsj" id="sqsj" readonly="readonly" >
								</div>
							</div>

							<div class="form-group">
								<label class="col-sm-2 control-label">开始时间</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required] date_select" name="kssj" id="kssj" readonly="readonly" maxDate="1">
								</div>
								<label class="col-sm-2 control-label">结束时间</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required] date_select" name="jssj" id="jssj" readonly="readonly" maxDate="1">
								</div>
							</div>

							<c:if test="${param.node >= 11 or param.node == -1}">
								<div class="form-group">
									<label class="col-sm-2 control-label">签发人</label>
									<div class="col-sm-4">
										<input type="text" class="input-sm form-control validate[required]" name="qfrDesc" id="qfrDesc" readonly="readonly">
										<input type="text" name="qfr" id="qfr" style="display: none;">
									</div>
									<label class="col-sm-2 control-label">签发时间</label>
									<div class="col-sm-4">
										<!-- <input type="text" class="input-sm form-control validate[required]" name="qfsj" id="qfsj" readonly="readonly"> -->
									</div>
								</div>
							</c:if>

							<div class="form-group">
								<label class="col-sm-2 control-label">工单内容</label>
								<div class="col-sm-10">
									<textarea class="form-control validate[required]" name="gdnr"></textarea>
								</div>
							</div>
							
							<div class="form-group">
								<div class="col-sm-12">
									<fieldset>
										<legend><b>操作详情</b></legend>
									</fieldset>
									<c:if test="${param.node == 0}">
										<a id="a-save"><i class="fa fa-save"></i> 存为模板</a>
										<a id="a-list"><i class="fa fa-list"></i> 引用模板</a>
									</c:if>
									<table id="datas" class="table display" style="width: 100%"></table>
								</div>
							</div>
							
							<c:if test="${param.node == 99 or param.node == -1}">
								<div class="form-group">
									<label class="col-sm-2 control-label">附件</label>
									<div class="col-sm-10">
										<input type="file" class="input-sm" name="file" id="file" multiple="multiple">
										<%-- ${s:getFile(param.pId, param.node)} --%>
									</div>
								</div>
							</c:if>
							
							<div class="form-group desc">
								<label class="col-sm-2 control-label">意见</label>
								<div class="col-sm-10">
									<input type="text" class="input-sm form-control" name="desc" id="desc">
								</div>
							</div>

							<div class="form-group action">
								<div class="col-sm-12" style="text-align: center">
									<button type="button" class="btn btn-sm btn-success btn-group1" result="提交">
										<i class="fa fa-check"></i> 提交
									</button>
									<button type="button" class="btn btn-sm btn-warning btn-group1" result="取消">
										<i class="fa fa-remove"></i> 取消
									</button>

									<button type="button" class="btn btn-sm btn-success btn-group3" result="确定">
										<i class="fa fa-check"></i> 确定
									</button>
									<button type="button" class="btn btn-sm btn-warning btn-group3" result="终止">
										<i class="fa fa-remove"></i> 终止
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o a-clear"></i> 编辑数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">模板名称</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required]" name="mbmc" id="mbmc" >
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->

	<!-- edit start-->
	<div class="modal fade" id="myModalmb" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editFormmb" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">模板选择</label>
					    <div class="col-sm-10">
					     	<select id="mbid" name="mbid" class="input-sm form-control validate[required]"></select>
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-okmb">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
</body>
</html>