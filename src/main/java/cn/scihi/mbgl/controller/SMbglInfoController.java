package cn.scihi.mbgl.controller;

import cn.scihi.mbgl.ucc.impl.SMbglInfoUcc;
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
@SysLog(module = "责任项")
@RequestMapping("/biz/sMbglInfo")
public class SMbglInfoController extends BizController {

	@Autowired
	private SMbglInfoUcc sMbglInfoUcc;

	public void init() {
		super.setBaseUcc(sMbglInfoUcc);
	}
}
