<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/jquery.jeditable.js"></script>
<script>
	var selectUrl = "${ctx}/biz/xjglInfo/select.do";
	var insertUrl = "${ctx}/biz/xjglInfo/insert.do";
	var updateUrl = "${ctx}/biz/xjglInfo/update.do";
	var deleteUrl = "${ctx}/biz/xjglInfo/delete.do";
	
	
	var callbackUrl = "${ctx}/sdk/callback.do";
	
	var back = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };
	var xj_id = "${param.xj_id}";
	var xjmc = "${param.xjmc}";
	var table;
	
	
	$(window).ready(function() {
		$("#xjmc").html("（${param.xjmc}）");
		
		$("#datas").wrapAll("<div style='overflow-x:auto'>");
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"paging": false,
			"scrollX": false,
			 //表头固定
            /* "scrollY": "500px",
            "scrollCollapse": "true", */
			"ajax": {
				"dataSrc": "datas",
				"url": selectUrl,
				"data": function() {
					if(xj_id) {
						return {"xj_id": xj_id};
					}
					return {"xj_id": "------------"};
				} 
			},
			"columns": [ {
				"title":'<a id="a-plus" title="新增"><i class="fa fa-plus"></i></a>',
				"data":"id",
				"render": function (data, type, row) {
					return '<a title="删除"><i class="fa fa-remove a-remove"></i></a>';
				}
			}, {
				"className":"edit",
				"title":"序号",
				"data":"xh"
			}, {
				"className":"edit",
				"title":"巡检任务项",
				"data":"rwx"
			}, {
				"className":"address",
				"title":"巡检地点",
				"data":"rwdd"
			}, {
				"className":"lnglat",
				"title":"经纬度",
				"data":"lnglat"
			}, {
				"className":"btn-map",
				"title":"定位",
				"data":"dw",
				"render": function (data, type, row) {
					return "<button type='button' class='btn btn-sm btn-success ' ><i class='fa fa-map-marker'></i> 定位 </button> ";
				}
			}]
			,"drawCallback": function(s) {
					$("#a-plus").off("click").on("click", function() {
						var length = table.api().data().length + 1;
						var v = {
								"xh":length,
								"rwx":"巡检任务-"+length,
								"rwdd":"巡检地点-"+length,
								"lng":"",
								"dw":"<button type='button' class='btn btn-sm btn-success ' ><i class='fa fa-map-marker'></i> 定位 </button> "
								}; 
						table.fnAddData(v);
			       	});
					$(".a-remove").off("click").on("click", function() {
			    		table.api().row($(this).parents('tr')).remove().draw();
			       	});
					
					table.$('.edit,.address').editable(callbackUrl, {
						type: 'textarea',
			          	onblur: 'submit',
			            tooltip: '可编辑',
					    indicator: '写入中...',
			            width: '100%',
			            height: '100%',
			            callback: function (value, settings) {
			            	var aPos = table.fnGetPosition(this);
			            	console.log(aPos);
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
		});
		
		
		
		$("body").off().on("click",".btn-map", function() {
			var thiz = $(this);
			var btn = $('#map').contents().find("#mapRef");
			$(btn).off().on("click",function(){
				var rs ={};
				rs.lat=	$('#map').contents().find("#latY").val();
				rs.lng=$('#map').contents().find("#lngX").val();
				rs.address=$('#map').contents().find("#keyword").val();
				if(!rs.lat){
					layer.msg("未选择具体地址！")
					return;
				}
				var trs = $("tr");
				var tr = $(thiz).parent();
				console.log(trs.index(tr));
				
            	table.fnUpdate(rs.address, trs.index(tr)-1,3);
            	table.fnUpdate(rs.lng+","+rs.lat, trs.index(tr)-1, 4);
				$("#myModal").modal("hide");
			})
        	$("#myModal").modal("show");
       	});
		
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				dtParam.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = dtParam;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
       	});
          
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload(null, false);
						$("#myModal").modal("hide");
					}
				});
			}
		});
		
		$("#a-save").on("click", function() {
			try {
				var obj ={};
				$("*", $("#editForm")).attr("disabled", false);
				if (confirm("您确定要保存吗？")) {
					$("#editForm").attr("action", insertUrl);
					obj.xjgl_info_size = table.api().data().length;
					obj.xjgl_info_list = JSON.stringify(table.api().data());
					if(0 == obj.xjgl_info_size) {
						layer.msg("操作详情无数据！");
						return;
					}
					ajaxSubmit("#editForm", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								shade : [ 0.1, "#fff" ] //独占
							}, function() {
								$(".a-reload").click();
							});
						}
					});
				}
			} catch (e) {
			}
		});
		$(".cycle").on("change",function(){
			if ($(this).val()=="1") {//$(this).attr("checked",true)两种方式
				$("#zqDiv").show();
			}else{
				$("#zqDiv").hide();
			}
		})
		
		/* document.getElementById("map").contentDocument.getElementById("mapRef").οnclick=function(){
			var rs ={};
			rs.lat=	$('iframe').contents().find("#latY").val();
			rs.lng=$('iframe').contents().find("#lngX").val();
			rs.address=$('iframe').contents().find("#keyword").val();
			console.log(rs);
		}; */
		
	});
	
	

</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="editForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i>巡检任务项管理<span id="xjmc"></span></h5>
	                    <div class="ibox-tools">
	                    	<c:if test="${param.zxzt ==0}">
	                    		<a id="a-save" style="color:#337ab7"><i class="fa fa-save"></i> 保存</a>
	                    	</c:if>
	                       <a class="a-reload">
	                          <i class="fa fa-repeat"></i> 刷新
	                       </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">

	                  <input type="text" id="xj_id" name="xj_id" value="${param.xj_id}" style="display: none;">
	                  <input type="text" id="zxr" name="zxr" value="${param.zxr}" style="display: none;">
	                  <table id="datas" class="table display" style="width: 100%"></table>
		            </div>
		            
				</form>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:85%;">
	        <div class="modal-content ibox">
	         <i class="fa fa-close" data-dismiss="modal" style="margin-right:5px; float: right;"></i> 
	        <iframe id="map" height="100%" width="100%" src="${ctx}/jsp/base/Amap.jsp" style="min-height: 500px; min-width: 800px"></iframe>
	        </div>
        </div>
    </div>
	
</body>
</html>