package cn.scihi.meeting.mapper;

import cn.scihi.meeting.bean.MeetingMember;
import cn.scihi.sdk.base.mapper.IBaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author uplus
 *
 */
public interface MeetingMemberMapper extends IBaseMapper {
    List<MeetingMember> selectForBean(MeetingMember condition);

    List<MeetingMember> selectExUser(MeetingMember condition);

    Integer saveMembers(@Param("meeting_id") String meetingId, @Param("usernames") List<String> usernames);
}
