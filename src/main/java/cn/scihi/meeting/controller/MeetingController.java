package cn.scihi.meeting.controller;

import cn.scihi.meeting.bean.MeetingCondition;
import cn.scihi.meeting.ucc.MeetingUcc;
import cn.scihi.sdk.base.controller.BizController;
import cn.scihi.sdk.core.MyApiUtils;
import cn.scihi.sdk.util.SysAnnotation.SysLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotBlank;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * @author uplus
 *
 */
@RestController
@SysLog(module = "会议")
@RequestMapping("/meeting")
public class MeetingController extends BizController {

	@Autowired
	private MeetingUcc meetingUcc;

	public void init() {
		super.setBaseUcc(meetingUcc);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 查询会议列表
	 * @description 结果将会按照status状态排序，顺序为：RUNNING、CREATED、FINISHED。相同状态按照时间逆序排列。
	 * @method get
	 * @url /smg/meeting/selectForBean.do
	 * @param status 否 String 会议状态。CREATED未开始，RUNNING进行中，FINISHED已完成。
	 * @param username 否 String 会议主持人，或者参会人
	 * @param page 否 Integer 页码，从1开始
	 * @param pagesize 否 Integer 每页条数，也支持start/length模式
	 * @param ids 否 String 会议ids，多个用逗号隔开
	 * @param year 否 String 会议开始的年（实际开始）
	 * @param month 否 String 会议开始的月（实际开始）
	 * @return {}
	 * @return_param datas List 会议列表
	 * @return_param status String 会议状态。CREATED未开始，RUNNING进行中，FINISHED已完成
	 * @return_param username String 主办人账号
	 * @return_param user_alias String 主办人名
	 * @return_param user_alias String 主办人昵称
	 * @return_param mobile_phone String 主办人手机号
	 * @return_param org_id String 主办机构
	 * @return_param org_name String 主办机构名
	 * @return_param title String 标题
	 * @return_param category String 分组：党委会（党组会），常务会（办公室），安委会，工作例会，专题会，企委会或其他
	 * @return_param description String 描述
	 * @return_param address String 会议地点
	 * @return_param expected_start Date 预计开始时间
	 * @return_param expected_end Date 预计结束时间
	 * @return_param real_start Date 真实开始时间
	 * @return_param real_end Date 真实结束时间
	 * @return_param created Date 创建时间
	 * @return_param users List 参会人员列表
	 * @return_param overTime boolean 是否已经超过结束后2小时
	 * @return_param myStatus String 本人的参会状态
	 * @return_param users[0].username String 账号
	 * @return_param users[0].user_alias String 昵称
	 * @return_param users[0].user_photo String 头像base64
	 * @return_param users[0].status String 状态：应到，出席，缺席，额外出席等
	 * @return_param users[0].duty Boolean 是否应到
	 * @return_param users[0].come Boolean 是否实到
     * @return_param meeting_file File 附件列表，查询详情才会有此字段
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/selectForBean.do"})
	@SysLog(module = "会议", method = "查询会议列表")
	public String list(HttpServletRequest request, MeetingCondition condition) throws Exception {
		try{
			condition.setDatas(meetingUcc.selectForBean(condition));
		}catch (Exception e){
			e.printStackTrace();
		}
		return this.toJSONString(condition);
	}

    /**
     * showdoc
     * @catalog 南充应急/会议
     * @title 根据id查询会议
     * @description -
     * @method get
     * @url /smg/meeting/selectForBean/{meetingId}.do
     * @param meetingId 路径参数 会议id
     * @return {}
     * @return_param datas Meeting 会议，字段详见《查询会议列表》
     * @remark
     * @number 0
     */
    @RequestMapping({"/selectForBean/{meetingId}.do"})
    @SysLog(module = "会议", method = "根据id查询会议")
    public String list(HttpServletRequest request, Map<String, Object> map, @PathVariable("meetingId") String meetingId) throws Exception {
        try{
            map.put("datas",meetingUcc.selectMeetingById(meetingId));
        }catch (Exception e){
            e.printStackTrace();
        }
        return this.toJSONString(map);
    }

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 根据状态查询会议数
	 * @description -
	 * @method get
	 * @url /smg/meeting/countByStatus.do
	 * @param year 否 String 年
	 * @param month 否 String 月
	 * @return {}
	 * @return_param status String 状态，CREATED未开始，RUNNING进行中，FINISHED已完成
	 * @return_param total String 个数
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/countByStatus.do"})
	@SysLog(module = "会议", method = "根据状态查询会议数")
	public String countByStatus(HttpServletRequest request, Map<String, Object> map, String year, String month) throws Exception {
		try{
			map.put("datas",meetingUcc.countByStatus(year, month, MyApiUtils.getUser("user_name")));
		}catch (Exception e){
			e.printStackTrace();
		}
		return this.toJSONString(map);
	}


	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 保存会议
	 * @description -
	 * @method post
	 * @url /smg/meeting/insert.do
	 * @param - 是 - 保存字段详见《查询会议列表》
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@Override
	public Object insert(HttpServletRequest request, Map<String, Object> map) throws Exception {
		try{
			map = this.getParameterMap(request, false);
			map.put("datas", this.baseUcc.insert(map, request));
		}catch (Exception e){
			e.printStackTrace();
		}

		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 更新会议信息
	 * @description -
	 * @method post
	 * @url /smg/meeting/update.do
	 * @param id 是 String 会议id
	 * @param - 否 - 保存字段详见《查询会议列表》
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 删除会议
	 * @description -
	 * @method delete
	 * @url /smg/meeting/delete/{meetingId}.do
	 * @param meetingId 路径参数 String 会议id
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = {"/delete/{meetingId}.do"}, method = RequestMethod.POST)
	@SysLog(module = "会议", method = "删除会议")
	@Transactional(rollbackFor = Exception.class)
	public String deleteMeeting(HttpServletRequest request, @PathVariable String meetingId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("datas", meetingUcc.deleteMeeting(meetingId));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 保存参会人员
	 * @description 将会删除已有参会人员列表，然后全量保存
	 * @method post
	 * @url /smg/meeting/{meetingId}/members.do
	 * @param meetingId 路径参数 String 会议id
	 * @param usernameStr 是 String 参会人员usernames，多个用逗号隔开
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = {"/{meetingId}/members.do"}, method = RequestMethod.POST)
	@SysLog(module = "会议", method = "保存参会人员")
	@Transactional(rollbackFor = Exception.class)
	public String saveMembers(HttpServletRequest request, Map<String, Object> map, @PathVariable String meetingId, @NotBlank String usernameStr) throws Exception {
		map = this.getParameterMap(request, true);
		map.put("datas", meetingUcc.saveMembers(meetingId, Arrays.asList(usernameStr.split(","))));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 查询参会人员列表
	 * @description -
	 * @method get
	 * @url /smg/meeting/{meetingId}/members.do
	 * @param meetingId 路径参数 String 会议id
	 * @return {}
	 * @return_param datas List 人员列表
	 * @remark
	 * @number 0
	 */
	@RequestMapping(value = {"/{meetingId}/members.do"}, method = RequestMethod.GET)
	@SysLog(module = "会议", method = "查询参会人员")
	public String getMembers(HttpServletRequest request, Map<String, Object> map, @PathVariable String meetingId) throws Exception {
		map = this.getParameterMap(request, true);
		try{
			map.put("datas", meetingUcc.queryMembers(meetingId, null, MyApiUtils.getUser("user_name")));
		}catch (Exception e){
			e.printStackTrace();
		}
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 开始会议
	 * @description 开始会议之后才可以查看签到二维码
	 * @method post
	 * @url /smg/meeting/{meetingId}/start.do
	 * @param meetingId 路径参数 String 会议id
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/{meetingId}/start.do"})
	@SysLog(module = "会议", method = "开始会议")
	@Transactional(rollbackFor = Exception.class)
	public String start(HttpServletRequest request, Map<String, Object> map, @PathVariable String meetingId) throws Exception {
		map = this.getParameterMap(request, true);
		map.put("datas", meetingUcc.start(meetingId));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 结束会议
	 * @description 结束会议之后才可以查看签到二维码
	 * @method post
	 * @url /smg/meeting/{meetingId}/end.do
	 * @param meetingId 路径参数 String 会议id
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/{meetingId}/end.do"})
	@SysLog(module = "会议", method = "结束会议")
	@Transactional(rollbackFor = Exception.class)
	public String end(HttpServletRequest request, Map<String, Object> map, @PathVariable String meetingId) throws Exception {
		map = this.getParameterMap(request, true);
		map.put("datas", meetingUcc.end(meetingId));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 查看签到二维码
	 * @description 会议状态为RUNNING则是签到，FINISHED则是签退。结束后2小时不可查看二维码
	 * @method post
	 * @url /smg/meeting/{meetingId}/sign.png.do
	 * @param meetingId 路径参数 String 会议id
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/{meetingId}/sign.png.do"})
	@SysLog(module = "会议", method = "查看签到二维码")
	public void signCode(HttpServletRequest request, HttpServletResponse response, @PathVariable String meetingId) throws Exception {
		response.setContentType("image/png");
		ServletOutputStream out = response.getOutputStream();
		out.write(meetingUcc.genaratorSignCode(meetingId));
		out.close();
	}

	/**
	 * showdoc
	 * @catalog 南充应急/会议
	 * @title 签到/签退
	 * @description 会议状态为RUNNING才可签到
	 * @method post
	 * @url /smg/meeting/{meetingId}/sign.do
	 * @param meetingId 路径参数 String 会议id
	 * @param lon 否 String 经度
	 * @param lat 否 String 维度
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
	@RequestMapping({"/{meetingId}/sign.do"})
	@SysLog(module = "会议", method = "签到")
	@Transactional(rollbackFor = Exception.class)
	public String sign(HttpServletRequest request, HttpServletResponse response, Map<String, Object> map, @PathVariable String meetingId, String lon, String lat) throws Exception {
		map = this.getParameterMap(request, true);
		map.put("resMsg", meetingUcc.sign(MyApiUtils.getUser("user_name"), meetingId, lon, lat));
		return this.toJSONString(map);
	}

	/**
	 * showdoc
	 * @catalog 通用
	 * @title 上传附件
	 * @description -
	 * @method post
	 * @url /smg/sdk/file/upload.do
	 * @param fk_id 是 文件关联的外键id
	 * @param (binary) 是 文件流，支持多个文件上传
	 * @return {}
	 * @return_param datas Integer 变更的行数
	 * @remark
	 * @number 0
	 */
}
