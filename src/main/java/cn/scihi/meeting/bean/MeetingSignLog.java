package cn.scihi.meeting.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

import java.util.Date;

/**
 * 签到记录
 */
@Data
public class MeetingSignLog extends BaseBean {
    String sys_id;
    String id;
    String username;//用户名
    String meeting_id;//会议id
    Date sign_date;//签到时间
    Date sign_out_date;//签退时间
}
