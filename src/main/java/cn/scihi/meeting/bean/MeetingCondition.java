package cn.scihi.meeting.bean;

import lombok.Data;

@Data
public class MeetingCondition extends Meeting {
    String member;//参会人员
    String ids;
    String year;
    String month;
    String keywords;
}
