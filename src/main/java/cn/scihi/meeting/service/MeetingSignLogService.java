package cn.scihi.meeting.service;

import cn.scihi.meeting.bean.MeetingSignLog;
import cn.scihi.meeting.bean.MeetingSignLogCondition;
import cn.scihi.meeting.mapper.MeetingSignLogMapper;
import cn.scihi.sdk.base.service.ServiceAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * @author uplus
 *
 */
@Service
public class MeetingSignLogService extends ServiceAdapter {

	@Autowired
	private MeetingSignLogMapper meetingSignLogMapper;

	public void init() throws Exception {
		super.setBaseMapper(meetingSignLogMapper);
	}

    public MeetingSignLog getLogByMeetingIdAndUsername(String username, String meetingId) {
		MeetingSignLogCondition condition = new MeetingSignLogCondition();
		condition.setMeeting_id(meetingId);
		condition.setUsername(username);
		List<MeetingSignLog> list = meetingSignLogMapper.selectForBean(condition);
		if(CollectionUtils.isEmpty(list)){
			return null;
		}else{
			return list.get(0);
		}
    }

	public Integer updateById(MeetingSignLog log, String meetingId) {
		meetingSignLogMapper.updateById(log, meetingId);
		return 1;
	}
}
