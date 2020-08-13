<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/base/base.jsp"></jsp:include>
<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main1119.css"/>
<!-- 这里要配置参数key,将其值设置为高德官网开发者获取的key -->
<script src="http://webapi.amap.com/maps?v=1.3&key=985a43b18ee1652571ca0fb6618e3382"></script>   
<link href="${ctx}/js/bootstrap/css/bootstrap-table.css" type="text/css" rel="stylesheet">
<link href="${ctx}/js/bootstrap/css/bootstrap-datetimepicker.css" type="text/css" rel="stylesheet">
<link href="${ctx}/js/bootstrap/css/bootstrap-editable.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table-zh-CN.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-editable.js"></script>
<script type="text/javascript" src="${ctx}/js/bootstrap/js/bootstrap-table-editable.js"></script>
	<script src="${ctx}/js/plugins/ztree/jquery.ztree.all.min.js?v=3.5.39"></script>
	<script src="${ctx}/js/plugins/ztree/fuzzysearch.js"></script>
	<link href="${ctx}/js/plugins/ztree/css/zTreeStyle/zTreeStyle.css?v=3.5.19" rel="stylesheet">
<style type="text/css">
.w-e-text-container{
    height: 260px !important; 
 }
 #pos{ 
    background-color: #fff;
    padding-left: 2px;
    padding-right: 2px;
    position:absolute;
    font-size: 12px;
    right: 10px;
    top: 10px;
    border-radius: 3px;
    line-height: 30px;
    border:1px solid #ccc;
    width: 450px;
}
#panel {
    position: absolute;
    background-color: white; 
    max-height: 400px ;
    overflow-y: auto;
    top: 160px;
    right: 10px;
    width: 280px;
}
#zTreeDiv > ul {
	width: 200px;
	height: 300px;
	border: 1px solid #ccc;
	background: #f3f3f3;
	overflow: auto;
}
::-webkit-scrollbar {
	width: 6px;
	height: 6px;
	background-color: #f3f3f3;
}
::-webkit-scrollbar-thumb {
	background-color: #ccc;
}
.search {
	padding-left:30px;
	background-image: url("${ctx}/images/icon_search.png");
	background-position: 5px;
	background-repeat: no-repeat;
}

</style>
<script>
	var selectUrl = "${ctx}/jsp/aqfxdzzh/jdd/select.do"; 
	var insertUrl = "${ctx}/jsp/aqfxdzzh/jdd/insert.do";
	var updateUrl = "${ctx}/jsp/aqfxdzzh/jdd/update.do";
	var selectzhdUrl ="${ctx}/jsp/aqfxdzzh/zhd/select.do";
	var o = { action : "click", target : ".a-back", result : "" };
	var closeItem = { action : "closeItem", target : document.location.toString() };
	 
	var v = {action:"menuItem", name:"列表", target: "${basePath}/jsp/jdd/jddList.jsp"}; 

	var obj = new Object();
	obj.node = "${param.node}";
	obj.id = "${param.orderId}"; 
	obj.delflag = '1';
	var amapKey ='985a43b18ee1652571ca0fb6618e3382';
	var addressContent = '';
	var lnglat =  []
	
	$(window).ready(function() {
		var zTree;
		var thiz;
		$(".org_select").on("click", function() {
			thiz = this;
			if ($("#zTreeDiv").is(":hidden")) {
				var objOffset = $(thiz).offset();
				var w = $(thiz).outerWidth();
				w = w < 200 ? 200 : (w > 300 ? 300 : w - 12);
				$("#zTreeDiv ul").width(w);
				$("#zTreeDiv").css({
					left : objOffset.left + "px",
					top : objOffset.top + $(thiz).outerHeight() + "px"
				}).fadeToggle("fast", function() {
					if(!zTree) {
						var obj = new Object();
						obj.url = "${ctx}/sdk/org/select.do";
						<c:if test="${'all' ne param.org}">
						obj.parent_ids = "${myUser.user.parent_ids}";
						if(!obj.parent_ids) {
							return;
						}
						</c:if>
						ajax(obj, function(result) {
							if ("error" == result.resCode) {
								layer.msg(result.resMsg, {icon: 2});
							} else {
								var setting = {
									data: {
										key: {name: "org_name", title: "id"},
										simpleData: {enable: true, idKey: "id", pIdKey: "parent_id"}
									},
									view: {dblClickExpand: false, fontCss: function(treeId, treeNode){
											return "0" == treeNode.row_state ? {'font-style':'italic','text-decoration':'line-through'} : {};
										}},
									callback: {
										beforeClick: function(treeId, treeNode) {
											$("#"+$(thiz).attr("t")).val(treeNode.id);
											$(thiz).val(treeNode.org_name);
										}
									}
								};
								zTree = $.fn.zTree.init($("#zTreeul"), setting, result.datas);
								zTree.expandNode(zTree.getNodeByTId("zTreeul_1"), true);
								fuzzySearch("zTreeul", "#key1", false, false);
							}
						});
					}
					$("body").bind("mousedown", function(event) {
						if (!(event.target.id == "zTreeDiv" || $(event.target).parents("#zTreeDiv").length > 0 || event.target == thiz)) {
							$("#zTreeDiv").fadeOut("fast");
							$("body").unbind("mousedown");
						}
					});
				});
			}
		});
		
		$("#thisform")[0].reset();  
		display();

		if (obj.node == "0") { //新增
			$("#thisform").attr("action", insertUrl);
			
		} else { //修改/查看
			initClientTable("zhdTableLayout","zhdTable","id",'get',selectzhdUrl,"client",false,false,zhdTableColumns,[],false,true); 
			obj.url = selectUrl; 
			ajax(obj, function(result) { // 查询业务数据
				if ("error" == result.resCode) {
					layer.msg(result.resMsg);
				} else {
					$("#thisform").fill(result.datas[0]);
					fillSelect("#thisform",result.datas[0]);
					$("#attachmentList").html(result.datas[0].attachList); 
					lnglat=[result.datas[0].jddgl_jd,result.datas[0].jddgl_wd]
					$("#zhdTable").bootstrapTable("load",result.datas[0].zhdList );
					display();
				}
			});
			$("#thisform").attr("action", updateUrl);
		}
		 
		

		$(".action button").on("click", function() {
			try {
				obj.result = $(this).attr("result");
				if ("取消" == obj.result) {
					$("#thisform")[0].reset(); 
					return doMessage(closeItem);
				}

				$("*", $("#thisform")).attr("disabled", false); 
				var b = $("#thisform").validationEngine("validate"); 
				if (b && confirm("您确定要" + obj.result + "吗？")) { 
					ajaxSubmit("#thisform", obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg);
						} else {
							layer.msg("数据处理成功！", {
								time:500,
								shade : [ 0.1, "#fff" ]  
							}, function() {
								return doMessage(closeItem);
							});
						}
					});
				}
				display();
			} catch (e) {
			}
		});
		
//----------------------AMap 		
		var map = new AMap.Map('container', {
		    resizeEnable: true,
		    zoom:13,
		    center: [106.07125296789552,30.757634505284802]

		});
	//点标记的创建与添加
        var marker  = new AMap.Marker({
            position: [106.07125296789552,30.757634505284802],
            map:map
        }); 
      //地图点击事件
        var clickEventListener=AMap.event.addListener(map,'click',function(e){
        	setJwd(e.lnglat.lng,e.lnglat.lat) 
        	//查询经纬度的地址
   	  		map.plugin('AMap.Geocoder', function() {
	       	 var geocoder = new AMap.Geocoder({
	       	    // city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
	       	    city: '511304'
	       	  })
	       	 
	       	 lnglat =  [e.lnglat.lng, e.lnglat.lat]
	       	 geocoder.getAddress(lnglat, function(status, result) {
	        	    if (status === 'complete' && result.info === 'OK') {
	        	        // result为对应的地理位置详细信息
	        	    	addressContent = result.regeocode.formattedAddress
	        	    }
	        	    map.remove(marker); 
	 	            marker = new AMap.Marker({
	 	                position: [e.lnglat.lng, e.lnglat.lat]
	 	            });
	 	            
	 	            marker.setMap(map); 
	 	            marker.setTitle(addressContent);
	 	            var tempContent="<div class='infos'>"+addressContent+"</div>";
	 	            // label默认蓝框白底左上角显示，样式className为：amap-marker-label
	 	            marker.setLabel({
	 	                offset: new AMap.Pixel(20, 20),  //设置文本标注偏移量
	 	                content: tempContent, //设置文本标注内容
	 	                direction: 'top' //设置文本标注方位
	 	            });
	       		})
	       })
        });
        
        AMap.service(["AMap.PlaceSearch"], function() {
            //构造地点查询类
            var placeSearch = new AMap.PlaceSearch({ 
                pageSize: 5, // 单页显示结果条数
                pageIndex: 1, // 页码
                city: "511304", // 兴趣点城市  南充嘉陵区 511304
                citylimit: true,  //是否强制限制在设置的城市内搜索
                map: map, // 展现结果的地图实例
                panel: "panel", // 结果列表将在此容器中进行展示。
                autoFitView: true // 是否自动调整地图视野使绘制的 Marker点都处于视口的可见范围
            });
          //关键字查询
            $("#btn-query").on("click", function() {
        	 placeSearch.search($("#keyword").val());
        	})
        	 //查询结果列表点击事件
        	placeSearch.on("listElementClick",function(e){
		   		 map.remove(marker);
		   		setJwd(e.data.location.lng,e.data.location.lat,e.data.name)  
            })
            //查询结果地图上marker点击事件
            placeSearch.on("markerClick",function(e){
		   		 map.remove(marker);
		   		setJwd(e.data.location.lng,e.data.location.lat,e.data.name) 
           }) 
        });
        
		map.plugin(["AMap.ToolBar"], function() {
			map.addControl(new AMap.ToolBar());
		});
		
		$("#btn-map").on("click", function() {
			$("#myModal").modal("show");
			lnglat =[$("#jddgl_jd").val(),$("#jddgl_wd").val()]; 
			map.plugin('AMap.Geocoder', function() {
		       	 var geocoder = new AMap.Geocoder({
		       	    // city 指定进行编码查询的城市，支持传入城市名、adcode 和 citycode
		       	    city: '511304'
		       	  })
		       	 geocoder.getAddress(lnglat, function(status, result) {
		        	    if (status === 'complete' && result.info === 'OK') {
		        	        // result为对应的地理位置详细信息
		        	    	addressContent = result.regeocode.formattedAddress
		        	    }
		        	    map.remove(marker); 
		 	            marker = new AMap.Marker({
		 	                position: lnglat
		 	            });
		 	            marker.setTitle(addressContent); 
		 	            marker.setMap(map); 
		 	            var tempContent="<div class='infos'>"+addressContent+"</div>";
		 	            // label默认蓝框白底左上角显示，样式className为：amap-marker-label
		 	            marker.setLabel({
		 	            	offset:new AMap.Pixel(20, -20), //设置文本标注偏移量
		 	                content: tempContent, //设置文本标注内容
		 	                direction: 'top' //设置文本标注方位
		 	            });
		 	           setJwd(lnglat[0],lnglat[1],addressContent)
		 	          $("#keyword").val(addressContent);
		       		})
		       })
			
       	});
		$("#mapRef").on("click", function() { //确定地址
			if ("0"==obj.node||"1"==obj.node) {	
				$("#jddgl_dz").val(addressContent);
				$("#jddgl_jd").val($("#lngX").val());
				$("#jddgl_wd").val($("#latY").val());
			}
       	});
	});
	
	 
	
	

	var display = function() {
		var node = obj.node;
		if("0"==node){//新增
			$("#thisform").attr("action", insertUrl); 
			delete obj.id;
			$("#filespan").hide()
			$("*", $("#thisform")).attr("disabled", false); 
			$("#zhDiv").hide()
			
		} else if ("1" == node) { //修改
			$("#thisform").attr("action", updateUrl); 
			$("*", $("#thisform")).attr("disabled", false);  
		}else if ("-1"==node) { //查看
			$("*", $("#thisform")).attr("disabled", true);  
			$("#thisform").attr("action", "#"); 
			$("#attachmentUploadLayout").hide();
			$(".tj").hide();
			$("*",$(".action")).attr("disabled",false); 
			obj.delflag = '0';
			$("#btn-map").attr("disabled",false); 
			
		}
		
	}

	 window.onload = function() {
		 
			/* if(location.href.indexOf('&guide=1')!==-1){
				map.setStatus({scrollWheel:false})
			} */
		}
	 var setJwd = function(j,w,address){
			 $("#lngX").val(j);
	         $("#latY").val(w);
	         addressContent=address;
		 
	 }
	 
	//初始化bootstrap表格 
		function initClientTable(tableLayout, tableId, uniqueId, method, url, sidePagination, editable, search, columns, data,
			detailView, clickToSelect) {
			$("#" + tableLayout).empty();
			$("#" + tableLayout).html('<table id="' + tableId +
				'" class="table table-bordered table-hover" style="table-layout: fixed;"></table>');
			$("#" + tableId).bootstrapTable({
				id: tableId,
				url: url, //请求后台的URL（*）
				method: method, //请求方式（*）
				dataType: 'json',
				singleSelect : true,//单选
				striped: true, //是否显示行间隔色
				cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
				pagination: true, //是否显示分页（*）
				height: 275,
				sortable: false, //是否启用排序
				sortOrder: "asc", //排序方式
				sidePagination: sidePagination, //分页方式：client客户端分页，server服务端分页（*）
				pageNumber: 1, //初始化加载第一页，默认第一页
				pageSize: 5, //每页的记录行数（*）
				pageList: [5, 10, 20], //可供选择的每页的行数（*）
				showColumns: false, //是否显示所有的列选项
				showRefresh: false, //是否显示刷新按钮
				minimumCountColumns: 2, //最少允许的列数
				clickToSelect: clickToSelect, //是否启用点击选中行
				uniqueId: uniqueId, //每一行的唯一标识，一般为主键列
				showToggle: false, //是否显示详细视图和列表视图的切换按钮
				cardView: false, //是否显示详细视图
				detailView: detailView, //是否显示父子表
				search: search,
				editable: editable,
				columns: columns, 
				onUncheckAll: onBootStrapTableCheckAll, 
				queryParamsType: 'limit',
				//请求服务器数据
				queryParams: queryParams,
				//构建返回数据
				responseHandler: responseHandler
			});
			if (data != null) {
				$("#" + tableId).bootstrapTable("load", data);
			}
		}
		
		//bootstrap查询参数构建
		function queryParams(params) {
			var param = {
				offset: params.offset	,
				limit: params.limit
			};
			param.keywords = $("#jdd_keywords").val();
			param.start = params.offset;
			param.length =params.limit ;
			param.page = (params.offset/params.limit) +1;
			param.pagesize =params.limit ; 
			return param;
		}
		//bootstrap返回数据格式构建
		function responseHandler(res) {
			var datas = {
				rows: res.datas, //数据
				total: res.recordsTotal
			};
			return datas;
		}	
		//bootstrap表格行选中事件
		function onBootStrapTableCheck(row, $element) {
			if (typeof(rowTableCheck) == "function") {
				rowTableCheck(row, $element, $(this));
			}
		}
		//bootstrap表格行选中事件
		function onBootStrapTableCheckAll(row) {
			if (typeof(rowTableCheck) == "function") {
				rowTableCheck(row, null, $(this));
			}
		}
		
		// 灾害点列
		var zhdTableColumns = [ 
				{
		            field: 'id',
		            title: '隐藏列(id)',
		            visible: false,
		            formatter: function(value, row, index) {
		                return index;
		            }
		        },  {
		            field: 'zhd_fxr_desc',
		            title: '发现人' 
		            
		        }, {
		            field: 'zh_jb_desc',
		            title: '灾害级别    '
		        }, {
		            field: 'zhd_fssj',
		            title: '发生时间 ' 
		        }, {
		            field: 'zhd_jssj',
		            title: '结束时间 ' 
		        } 
		    ];
 
</script>
</head>
<div id="zTreeDiv" style="display: none; position: absolute; z-index: 9999">
	<ul id="zTreeul" class="ztree"></ul>
	<input type="text" class="input-sm form-control search" id="key1" placeholder="关键字" style="width:calc(100% - 0px);">
</div>
<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">
					<form id="thisform" class="form-horizontal" role="form" onsubmit="return false;" >
					<div class="ibox-title">
						<h5>
							<class="fa fa-file-o a-clear"></i> 详情
						</h5>
						<div class="ibox-tools">
							<a class="a-reload"> <i class="fa fa-repeat"></i> 刷新
							</a>
						</div>
					</div>
						<div class="ibox-content" > 
			                  
			                  <div class="form-group"  >
									<label class="col-sm-2 control-label">风险点名称</label>
									<div class="col-sm-4">
									<input type="text" class="input-sm form-control validate[required]" name="jddgl_mc" id="jddgl_mc" maxtlenth='50' >
									</div>
									<label class="col-sm-2 control-label">风险等级</label>
									<div class="col-sm-4">
									<s:dict dictType="fxy_jb" name="jddgl_fxydj" clazz="input-sm form-control validate[required]"></s:dict>
									</div>
									<%--<label class="col-sm-2 control-label" >社会信用代码</label>
									<div class="col-sm-4"  >
										<input type="text" class="input-sm form-control " name="jddgl_bh" id="jddgl_bh" maxtlenth='50' >
									</div>--%>
							  </div>

							  <div class="form-group">
								<label class="col-sm-2 control-label">监管部门</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control org_select" name="jddgl_jgbm_desc"  t="jddgl_jgbm" readonly/>
									<input type="text" class="input-sm form-control" name="jddgl_jgbm" id="jddgl_jgbm" style="display: none"/>
								</div>
								<label class="col-sm-2 control-label">主体机构</label>
								<div class="col-sm-4">
									<input type="text" class="input-sm form-control org_select" name="jddgl_ztjg_desc"   t="jddgl_ztjg" readonly/>
									<input type="text" class="input-sm form-control" name="jddgl_ztjg" id="jddgl_ztjg" style="display: none"/>
								</div>
							  </div>

							   <div class="form-group" style="display: none;">
							    <label class="col-sm-2 control-label">联系人</label>
							    <div class="col-sm-4"> 
							      <input type="text" class="input-sm form-control" name="jddgl_lxr" id="jddgl_lxr" maxtlenth='50' >
							    </div>
							    <label class="col-sm-2 control-label">联系电话</label>
							    <div class="col-sm-4"> 
							      <input type="number" class="input-sm form-control" name="jddgl_lxdh" id="jddgl_lxdh" maxtlenth='50' >
							    </div>
							  </div>
							  <div class="form-group" style="display: none;">
							  	
							    <label class="col-sm-2 control-label">经度</label>
							    <div class="col-sm-4"> 
							      <input type="number" class="input-sm form-control validate[required]" name="jddgl_jd" id="jddgl_jd" maxtlenth='50' > 
							    </div>
							    <label class="col-sm-2 control-label">纬度</label>
							    <div class="col-sm-3"> 
							      <input type="number" class="input-sm form-control validate[required]" name="jddgl_wd" id="jddgl_wd" maxtlenth='50' > 
							    </div>
							  </div>
			                  
							   <div class="form-group"  >
							   		<label class="col-sm-2 control-label">地址</label>
								    <div class="col-sm-9">
								      <input type="text" class="input-sm form-control validate[required]" name="jddgl_dz" id="jddgl_dz" maxtlenth='200' > 
								    </div>
								   <div class="col-sm-1">
									   <button type="button" class="btn  btn-sm   btn-success " id="btn-map" >
										   <i class="fa fa-map-marker"></i> 定位
									   </button>
								   </div>
							   </div>
							   <div class="form-group"  >
									<label class="col-sm-2 control-label">备注</label>
								    <div class="col-sm-10">
										<textarea class="input-sm form-control " name="jddgl_bz" id="jddgl_bz" rows="3" maxlength="200">
										</textarea>
								    </div> 
							   </div>
							    <div class="form-group desc" id="attachmentList_div">
								<label class="col-sm-2 control-label">附件列表</label>
								<div class="col-sm-10" id="filespan">
								
									<div class="col-sm-11" id="attachmentList">
									</div>
								</div>
							</div>

							<div class="form-group yc" id="attachmentUploadLayout">
								<label class="col-sm-2 control-label">附件上传 </label>
								<div class="col-sm-10">
									<input type="file" name="file" id="file" multiple />
								</div>
							</div>
							<div class="form-group" id='zhDiv'>
								<label class="col-sm-2 control-label"> 灾害情况</label>
							    <div class="col-sm-10" style="margin-top: 5px;margin-bottom: 5px;">
							    	<h5>
										<class="fa fa-file-o a-clear"></i>
									</h5>
							    	<div id="zhdTableLayout"></div>
							    </div>
						    </div>
					
							<div class="form-group action">
								<div class="col-sm-12" style="text-align: center">
									<button type="button" class="btn btn-sm btn-success btn-group1 tj" result="提交">
										<i class="fa fa-check"></i> 提交
									</button>
									<button type="button" class="btn btn-sm btn-warning btn-group1 qx" result="取消">
										<i class="fa fa-remove"></i> 取消
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
	                    <h5><i class="fa fa-pencil-square-o"></i> 获取经纬度</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            	<div id="container" style="height:500px"></div>
					 <div id="pos">
					 	<div class="form-group" style="margin-bottom:2px !important" >
					 		<label class="col-sm-2 control-label">关键字：</label>
					        <input class="col-sm-7 input-sm " type="text" id="keyword" title="仅会查询南充嘉陵区内" style="margin-top:2px" />  
							<button class="col-sm-2" type="button" class="btn btn-sm btn-success" id='btn-query' style="margin-left:5px"  >
							 <i class="fa fa-search"></i> 搜索 </button>
							 <i class="fa fa-close" data-dismiss="modal" style="margin-left:10px"></i> 
						</div>	
						<div class="form-group"  style="margin-bottom:2px !important" >
					        <label class="col-sm-2 control-label">经度:</label>	<input  class="col-sm-3 input-sm " type="text" id="lngX" name="lngX" /> 
					        <label class="col-sm-2 control-label">纬度:</label>	<input  class="col-sm-3 input-sm  " type="text" id="latY" name="latY" /> 
					        <button type="button" class="btn btn-sm btn-success btn-cancel col-sm-1" data-dismiss="modal" id="mapRef" style="margin-left:5px">
		                	<i class="fa fa-check"></i> 
		                </button>
					    </div>
					 </div> 
					 <div id="panel"></div> 
	                  
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
</body>
</html>