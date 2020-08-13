package cn.scihi.mbgl.controller;

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
@SysLog(module = "周期任务")
@RequestMapping("/biz/cycle")
public class CycleController extends BizController {

	@Autowired
	private IBaseUcc cycleUcc;

	public void init() {
		super.setBaseUcc(cycleUcc);
	}
}
