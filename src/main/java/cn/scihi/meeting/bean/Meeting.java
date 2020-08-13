package cn.scihi.meeting.bean;

import cn.scihi.sdk.base.pojo.BaseBean;
import lombok.Data;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 会议
 */
@Data
public class Meeting extends BaseBean {
    String sys_id;
    String id;
    String status; //会议状态。CREATED 未开始，RUNNING 进行中，FINISHED 已完成。
    boolean overTime = false;//
    String username;//主办人账号
    String user_alias;//主办人昵称
    String mobile_phone;//主办人手机号
    String org_id;//主办机构
    String org_name;//主办机构名

    String title;//标题
    String category;//分组
    String description;//描述

    Date created;//创建时间
    Date expected_start;//预计开始时间
    Date expected_end;//预计结束时间
    Date real_start;//真实开始时间
    Date real_end;//真实结束时间

    String address;//会议地点

    List<MeetingMember> users;//参会人员列表
    String myStatus;//本人参会状态

    List<Map<String, Object>> meeting_files;
}
