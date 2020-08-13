package cn.scihi.mbgl.service.impl;

import cn.scihi.meeting.bean.Meeting;
import cn.scihi.meeting.service.MeetingService;
import cn.scihi.meeting.ucc.MeetingUcc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TaskInstanceService {
    @Autowired
    private MeetingService meetingService;

    public static final String MEETING = "会议";
    public static final String XUNJIAN = "巡检";
    public static final String STUDY = "学习";

    public boolean check(String pattern, String id, String reqModelId){
        if(MEETING.equals(pattern)){
            return this.checkMeeting(id);
        }else if(XUNJIAN.equals(pattern)){
            return this.checkXunjian(id, reqModelId);
        }else if(STUDY.equals(pattern)){
            return this.checkStudy(id, reqModelId);
        }
        return true;
    }

    private boolean checkStudy(String id, String reqModelId) {
        return true;
    }

    private boolean checkXunjian(String id, String reqModelId) { return true; }

    private boolean checkMeeting(String id) {
        Meeting meeting = meetingService.getMeetingById(id);
        return MeetingUcc.FINISHED.equals(meeting.getStatus());
    }
}
