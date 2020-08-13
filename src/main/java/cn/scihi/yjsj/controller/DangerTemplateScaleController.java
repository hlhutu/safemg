package cn.scihi.yjsj.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import cn.scihi.yjsj.ucc.impl.DangerTempalteScaleUcc;

/**
* @author xiongxiaojing
* @version 创建时间：2020年6月2日 上午10:38:35
*/
@RestController
@SysLog(module = "隐患排查清单管理")
@RequestMapping("/jsp/danger/template/scale")
public class DangerTemplateScaleController extends BizController{
	@Resource
	private IBaseUcc dangerTempalteScaleUcc;
	@Autowired
	private DangerTempalteScaleUcc myDangerTempalteScaleUcc;

	@Override
	public void init() throws Exception {
		super.baseUcc = dangerTempalteScaleUcc;
	}
	
	@GetMapping("/getTemplateOrder.do")
	public Object getTemplateOrder() throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("datas", this.myDangerTempalteScaleUcc.getTemplateOrder());
		return toJSONString(map);
	}
}
