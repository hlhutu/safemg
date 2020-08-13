package cn.scihi.meeting.ucc;

import cn.scihi.mbgl.service.impl.TaskInstanceService;
import cn.scihi.mbgl.service.impl.TaskService;
import cn.scihi.mbgl.ucc.impl.TaskUcc;
import cn.scihi.meeting.bean.Meeting;
import cn.scihi.meeting.bean.MeetingCondition;
import cn.scihi.meeting.bean.MeetingMember;
import cn.scihi.meeting.bean.MeetingSignLog;
import cn.scihi.meeting.service.MeetingService;
import cn.scihi.meeting.service.MeetingSignLogService;
import cn.scihi.sdk.base.ucc.UccAdapter;
import cn.scihi.sdk.core.MyApiUtils;
import com.alibaba.fastjson.JSONObject;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author uplus
 *
 */
@Service
public class MeetingUcc extends UccAdapter {
	public static final String CREATED = "CREATED";
	public static final String RUNNING = "RUNNING";
	public static final String FINISHED = "FINISHED";
	public static final Integer WIDTH = 600;
	public static final Integer HEIGHT = 600;
	public static final long TIMELONG = 2*60*60*1000;

	@Autowired
	private MeetingService meetingService;
	@Autowired
	private MeetingSignLogService meetingSignLogService;
	@Autowired
	private TaskUcc taskUcc;

	public void init() throws Exception {
		super.setBaseService(meetingService);
	}

	/**
	 * 保存会议的参会人员
	 * @param meetingId
	 * @param ids
	 * @return
	 */
	public Integer saveMembers(String meetingId, List<String> ids) {
		meetingService.removeMembersByMeetingId(meetingId);
		meetingService.saveMembers(meetingId, ids);
		return 1;
	}

	/**
	 * 开始会议
	 * @param meetingId
	 * @return
	 */
	public Meeting start(String meetingId) throws Exception {
		Meeting meeting = meetingService.getMeetingById(meetingId);
		if(meeting==null || !CREATED.equals(meeting.getStatus())){
			throw new Exception("会议不存在，或当前不可开始");
		}
		Map<String, Object> param = new HashMap<>();
		param.put("id", meetingId);
		param.put("status", RUNNING);
		param.put("real_start", new Date());
		meetingService.update(param);
		return this.selectMeetingById(meetingId);
	}

	/**
	 * 结束会议
	 * @param meetingId
	 * @return
	 */
	public Meeting end(String meetingId) throws Exception {
		Meeting meeting = meetingService.getMeetingById(meetingId);
		if(meeting==null || !RUNNING.equals(meeting.getStatus())){
			throw new Exception("会议不存在，或当前不可结束");
		}
		Map<String, Object> param = new HashMap<>();
		param.put("id", meetingId);
		param.put("status", FINISHED);
		param.put("real_end", new Date());
		meetingService.update(param);
		taskUcc.completeByOther(TaskInstanceService.MEETING, meetingId);
		return this.selectMeetingById(meetingId);
	}

	/**
	 * 获取签到二维码
	 * @param meetingId
	 * @return
	 */
	public byte[] genaratorSignCode(String meetingId) throws Exception {
		this.checkSign(meetingId);
		JSONObject json = new JSONObject();
		json.put("action", "sign");
		json.put("meetingId", meetingId);
		byte[] bytes = this.genaratorCode(json.toJSONString());
		return bytes;
	}

	private byte[] genaratorCode(String text) throws Exception {
		Map<EncodeHintType, Object> map = new Hashtable<EncodeHintType, Object>();
		map.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
		map.put(EncodeHintType.CHARACTER_SET, "UTF-8");
		map.put(EncodeHintType.MARGIN, 1);
		BitMatrix bm = new MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, WIDTH, HEIGHT, map);// QR_CODE、EAN_13(6923450657713)
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		MatrixToImageWriter.writeToStream(bm, "PNG", out);
		return out.toByteArray();
	}

	public String checkSign(String meetingId) throws Exception {
		Meeting meeting = meetingService.getMeetingById(meetingId);
		if(meeting==null){
			return "会议不存在";
		}
		if(RUNNING.equals(meeting.getStatus())){
			return "SIGN";
		}else if(FINISHED.equals(meeting.getStatus())){
			if(new Date().getTime()-meeting.getReal_end().getTime()>TIMELONG){
				return "会议结束已经超过2小时";
			}
			return "SIGN_OUT";
		}else{
			return "会议未开始";
		}
	}

	public String sign(String username, String meetingId, String lon, String lat) throws Exception {
		String signPattern = this.checkSign(meetingId);
		if("SIGN".equals(signPattern)){
			MeetingSignLog log = meetingSignLogService.getLogByMeetingIdAndUsername(username, meetingId);
			if(log!=null){
				return "您已签到";
			}
			Map<String, Object> param = new HashMap<>();
			param.put("meeting_id", meetingId);
			param.put("username", username);
			param.put("sign_date", new Date());
			param.put("lon", lon);
			param.put("lat", lat);
			meetingSignLogService.insert(param);
			return "签到成功";
		}else if("SIGN_OUT".equals(signPattern)){
			MeetingSignLog log = meetingSignLogService.getLogByMeetingIdAndUsername(username, meetingId);
			if(log==null){//未签到，直接签退
				Map<String, Object> param = new HashMap<>();
				param.put("meeting_id", meetingId);
				param.put("username", username);
				param.put("sign_out_date", new Date());
				meetingSignLogService.insert(param);
				return "签退成功（您未签到）";
			}else{
				if(log.getSign_out_date()!=null){
					return "您已签退";
				}
				log.setSign_out_date(new Date());
				meetingSignLogService.updateById(log, log.getId());
				return "签退成功";
			}
		}else{
			return signPattern;
		}
	}

	public List<Meeting> selectForBean(MeetingCondition condition) throws Exception {
		String username = MyApiUtils.getUser("user_name");//当前登录用户
		List<Meeting> list = meetingService.selectForBean(condition);
		Map<String, Object> param = new HashMap<>();
		for (Meeting meeting : list) {
			this.parseMeeting(meeting, username);
		}
		return list;
	}

	private void parseMeeting(Meeting meeting, String username) throws Exception {
		meeting.setUsers(this.queryMembers(meeting.getId(), meeting, username));
		Map<String, Object> param = new HashMap<>();
		param.put("fk_id", meeting.getId());
		Map<String, Object> resMap = MyApiUtils.queryFile(param);
		if("success".equals(resMap.get("resCode")) && resMap.get("datas")!=null){
			meeting.setMeeting_files((List<Map<String, Object>>) resMap.get("datas"));
		}
		if("FINISHED".equals(meeting.getStatus())){//已经结束
			Calendar cal = Calendar.getInstance();
			cal.setTime(meeting.getReal_end());//从真实时间开始计算
			cal.add(Calendar.HOUR_OF_DAY, 2);
			if(cal.getTime().before(new Date())){//现在时间在结束时间2小时内
				meeting.setOverTime(true);
			}
		}
	}

	public Meeting selectMeetingById(String meetingId) throws Exception {
		MeetingCondition condition = new MeetingCondition();
		condition.setId(meetingId);
		List<Meeting> list = this.selectForBean(condition);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}
		Meeting meeting = list.get(0);
		this.parseMeeting(meeting, MyApiUtils.getUser("user_name"));
		return meeting;
	}

	private boolean isFinished(Meeting meeting) {
		if(!FINISHED.equals(meeting.getStatus())){
			return false;
		}else if(new Date().getTime()-meeting.getReal_end().getTime()>TIMELONG){
			return true;
		}
		return false;
	}

	public Integer deleteMeeting(String meetingId) throws Exception {
		Meeting meeting = meetingService.getMeetingById(meetingId);
		if(meeting==null || !CREATED.equals(meeting.getStatus())){
			throw new Exception("只能删除未开始的会议");
		}
		meetingService.removeMembersByMeetingId(meetingId);
		Map<String, Object> param = new HashMap<>();
		param.put("id", meetingId);
		meetingService.delete(param);
		return 1;
	}

	public List<MeetingMember> queryMembers(String meetingId, Meeting meeting, String username) {
		meeting = meeting==null? meetingService.getMeetingById(meetingId): meeting;
		//预计参会人列表
		List<MeetingMember> members = meetingService.getMeetingMembers(meeting.getId());
		if(CREATED.equals(meeting.getStatus())){//会议未开始，所有预计参会人员为“应到”
			members.forEach(m->{
				m.setStatus("");
				m.setSort_no(1);
			});
			return members;
		}else{
			List<MeetingMember> exMembers = meetingService.getExMeetingMembers(meeting.getId());//实到人员
			List<MeetingMember> resultMembers = new ArrayList<>();
			if(!CollectionUtils.isEmpty(members)){
				Meeting finalMeeting = meeting;
				members.forEach(m->{//应到列表
					if(!isFinished(finalMeeting)){//会议进行中
						if(m.getSign_date()!=null){
							m.setStatus("出席");
							m.setSort_no(0);
						}else{
							m.setStatus("");
							m.setSort_no(10);
						}
					}else{//会议已结束
						if(m.getSign_date()!=null){
							if(m.getSign_out_date()!=null){
								m.setStatus("出席");
								m.setSort_no(0);
							}else{
								m.setStatus("出席（未签退）");
								m.setSort_no(1);
							}
						}else{
							if(m.getSign_out_date()!=null){
								m.setStatus("出席（未签到）");//只签退，也认为是出席
								m.setSort_no(2);
							}else{
								m.setStatus("缺席");
								m.setSort_no(20);
							}
						}
					}
					if(username.equals(m.getUsername())){
						finalMeeting.setMyStatus(m.getStatus());
					}
				});
				resultMembers.addAll(members);
			}
			if(!CollectionUtils.isEmpty(exMembers)){
				Meeting finalMeeting1 = meeting;
				exMembers.forEach(m->{//不应到列表
					if(!isFinished(finalMeeting1)){//会议进行中
						m.setStatus("出席");
						m.setSort_no(3);
					}else{//会议已结束
						if(m.getSign_out_date()!=null){
							m.setStatus("出席");
							m.setSort_no(3);
						}else{
							m.setStatus("出席（未签退）");
							m.setSort_no(4);
						}
					}
					if(username.equals(m.getUsername())){
						finalMeeting1.setMyStatus(m.getStatus());
					}
				});
				resultMembers.addAll(exMembers);
			}
			return resultMembers.stream().sorted(Comparator.comparing(MeetingMember::getSort_no)).collect(Collectors.toList());
		}
	}

    public List<Map<String, Object>> countByStatus(String year, String month, String username) {
		return meetingService.countByStatus(year, month, username);
    }
}
