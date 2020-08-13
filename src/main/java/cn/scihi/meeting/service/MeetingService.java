package cn.scihi.meeting.service;

import cn.scihi.meeting.bean.Meeting;
import cn.scihi.meeting.bean.MeetingCondition;
import cn.scihi.meeting.bean.MeetingMember;
import cn.scihi.meeting.bean.MeetingSignLog;
import cn.scihi.meeting.mapper.MeetingMapper;
import cn.scihi.meeting.mapper.MeetingMemberMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author uplus
 *
 */
@Service
public class MeetingService extends ServiceAdapter {

	@Autowired
	private MeetingMapper meetingMapper;
	@Autowired
	private MeetingMemberMapper meetingMemberMapper;

	public void init() throws Exception {
		super.setBaseMapper(meetingMapper);
	}

    public List<Meeting> selectForBean(MeetingCondition condition) {
		return meetingMapper.selectForBean(condition);
    }

	public void removeMembersByMeetingId(String meetingId) {
		Map<String, Object> param = new HashMap<>();
		param.put("meeting_id", meetingId);
		meetingMemberMapper.delete(param);
	}

	public void saveMembers(String meetingId, List<String> usernames) {
		if(CollectionUtils.isEmpty(usernames)){
			return;
		}
		meetingMemberMapper.saveMembers(meetingId, usernames);
	}

	public Meeting getMeetingById(String meetingId) {
		MeetingCondition condition = new MeetingCondition();
		condition.setId(meetingId);
		List<Meeting> meetings = meetingMapper.selectForBean(condition);
		if(CollectionUtils.isEmpty(meetings)){
			return null;
		}else{
			return meetings.get(0);
		}
	}

	/**
	 * 查询预计参会人员
	 * @param meetingId
	 * @return
	 */
	public List<MeetingMember> getMeetingMembers(String meetingId) {
		MeetingMember condition = new MeetingMember();
		condition.setMeeting_id(meetingId);
		List<MeetingMember> list = meetingMemberMapper.selectForBean(condition);
		return list;
	}

	/**
	 * 查询实际参会人员
	 * @param meetingId
	 * @return
	 */
	public List<MeetingMember> getExMeetingMembers(String meetingId) {
		MeetingMember condition = new MeetingMember();
		condition.setMeeting_id(meetingId);
		List<MeetingMember> list = meetingMemberMapper.selectExUser(condition);
		return list;
	}

    public List<Map<String, Object>> countByStatus(String year, String month, String username) {
		return meetingMapper.countByStatus(year, month, username);
    }
}
