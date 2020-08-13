package cn.scihi.meeting.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.base.ucc.IBaseUcc;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author uplus
 *
 */
@RestController
@SysLog(module = "会议签到记录")
public class MeetingSignLogController extends BizController {

	@Autowired
	private IBaseUcc meetingSignLogUcc;

	public void init() {
		super.setBaseUcc(meetingSignLogUcc);
	}
}
