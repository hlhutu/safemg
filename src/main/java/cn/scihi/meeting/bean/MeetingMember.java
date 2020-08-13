package cn.scihi.meeting.bean;

import cn.scihi.comm.bean.SysUser;
import lombok.Data;

import java.util.Date;

@Data
public class MeetingMember extends SysUser {
    String meeting_id;
    String username;
    String status;//状态，缺席（应到未到），出席（应到实到），额外（不应到实到）
    Date sign_date;
    Date sign_out_date;
    boolean duty;//是否应到
    int sort_no;
}
