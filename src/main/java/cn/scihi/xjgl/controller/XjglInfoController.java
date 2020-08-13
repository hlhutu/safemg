package cn.scihi.xjgl.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;

/**
 * @author uplus
 *
 */
@Controller
@SysLog(module = "巡检任务项")
@RequestMapping("/biz/xjglInfo")
public class XjglInfoController extends BizController {

	@Autowired
	private IBaseUcc xjglInfoUcc;

	public void init() {
		super.setBaseUcc(xjglInfoUcc);
	}
}
