package cn.scihi.yjsj.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import cn.scihi.yjsj.ucc.impl.DangerTemplateTaskUcc;

/**
* @author bayueshiwu
* @version 创建时间：2020年6月9日 上午10:18:05
*/
@RestController
@SysLog(module = "执法任务管理")
@RequestMapping("/jsp/template/user")
public class DangerTemplateTaskController extends BizController{
	@Resource
	private IBaseUcc dangerTemplateTaskUcc;
	@Autowired
	private DangerTemplateTaskUcc myDangerTemplateTaskUcc;

	@Override
	public void init() throws Exception {
		super.baseUcc = dangerTemplateTaskUcc;
	}
	
	@GetMapping("/getCountDealt.do")
	public Object getCountDealt(@RequestParam("lawUser") String lawUser) throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("datas", this.myDangerTemplateTaskUcc.getCountDealt(lawUser));
		return toJSONString(map);
	}
}
